from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain_community.llms import Ollama
from langchain.schema import StrOutputParser
from langchain.schema.runnable import RunnablePassthrough, RunnableLambda
from typing import Dict, Any
import json

from models.requests import StoryGenerationRequest
from models.responses import StoryGenerationResponse, InteractionPoint, DifficultyLevel

class StoryGenerationChain:
    def __init__(self):
        self.llm = Ollama(
            model="mistral",
            temperature=0.7
        )
        
        # Define the personalized prompt template
        self.prompt_template = PromptTemplate(
            input_variables=[
                "student_name", "age", "neurodivergent_traits", "learning_style", 
                "attention_span", "communication_needs", "sensory_preferences",
                "favorite_characters", "preferred_topics", "learning_objective", 
                "subject", "mood", "previous_context", "memory_context"
            ],
            template=self._get_story_prompt_template()
        )
        
        # Build the chain: Data processing → Prompt → LLM → Structured output
        self.chain = (
            RunnableLambda(self._process_student_data)
            | self.prompt_template
            | self.llm
            | StrOutputParser()
            | RunnableLambda(self._parse_story_response)
        )
    
    def _get_story_prompt_template(self) -> str:
        return """
You are an expert educational content creator specializing in neurodivergent learners. Create a personalized learning story based on the following student profile and requirements.

STUDENT PROFILE:
- Name: {student_name}
- Age: {age} years old
- Neurodivergent traits: {neurodivergent_traits}
- Primary learning style: {learning_style}
- Attention span: {attention_span} minutes
- Communication needs: {communication_needs}
- Sensory preferences: {sensory_preferences}
- Favorite characters: {favorite_characters}
- Preferred topics: {preferred_topics}

STORY REQUIREMENTS:
- Learning objective: {learning_objective}
- Subject area: {subject}
- Story mood: {mood}
- Previous story context: {previous_context}
- Personal memory context: {memory_context}

PERSONALIZATION GUIDELINES:
1. Adapt language complexity to the student's age and communication needs
2. Incorporate their favorite characters and topics naturally
3. Respect sensory preferences (avoid overwhelming descriptions if sensitive)
4. Design interactions that match their learning style
5. Keep story segments within their attention span
6. Include positive reinforcement and emotional connection points
7. If personal memory context is provided, weave it into the educational narrative

INTERACTION DESIGN:
- Visual learners: Include picture choices, color coding, visual sequences
- Auditory learners: Include rhythm, rhyme, sound effects, verbal responses
- Kinesthetic learners: Include movement, gestures, hands-on activities
- Reading/writing learners: Include word games, writing prompts, text analysis

OUTPUT FORMAT:
Return a JSON object with the following structure:
{{
    "title": "Engaging story title",
    "content": "Main story content with [INTERACTION_1], [INTERACTION_2] markers",
    "characters": ["List of main characters"],
    "learning_points": ["Key educational concepts covered"],
    "interaction_points": [
        {{
            "type": "question|choice|activity|gesture",
            "prompt": "Interaction prompt for student",
            "expected_responses": ["possible responses"]
        }}
    ],
    "vocabulary_words": ["New vocabulary introduced"],
    "comprehension_questions": ["Assessment questions"],
    "adaptation_notes": "How to modify based on student response",
    "estimated_duration_minutes": 15,
    "difficulty_level": "beginner|intermediate|advanced"
}}

Create an engaging, educational story that makes learning joyful and accessible for this specific student.
"""

    def _process_student_data(self, request: StoryGenerationRequest) -> Dict[str, Any]:
        """Process and format student data for the prompt"""
        
        processed = {
            "student_name": request.student_name,
            "age": request.age,
            "neurodivergent_traits": ", ".join(request.neurodivergent_traits) or "None specified",
            "learning_style": request.learning_style.value,
            "attention_span": request.attention_span,
            "communication_needs": request.communication_needs,
            "sensory_preferences": ", ".join(request.sensory_preferences),
            "favorite_characters": ", ".join(request.favorite_characters) or "None specified",
            "preferred_topics": ", ".join(request.preferred_topics) or "None specified",
            "learning_objective": request.learning_objective,
            "subject": request.subject,
            "mood": request.mood.value,
            "previous_context": request.previous_context or "None",
            "memory_context": request.memory_context or "None"
        }
        
        return processed
    
    def _parse_story_response(self, llm_output: str) -> StoryGenerationResponse:
        """Parse LLM output into structured response"""
        try:
            # Try to parse as JSON
            story_data = json.loads(llm_output)
            
            # Convert interaction points to proper format
            interaction_points = []
            for interaction in story_data.get("interaction_points", []):
                interaction_points.append(InteractionPoint(
                    type=interaction.get("type", "question"),
                    prompt=interaction.get("prompt", ""),
                    expected_responses=interaction.get("expected_responses", [])
                ))
            
            return StoryGenerationResponse(
                title=story_data.get("title", "Learning Story"),
                content=story_data.get("content", ""),
                characters=story_data.get("characters", []),
                learning_points=story_data.get("learning_points", []),
                interaction_points=interaction_points,
                vocabulary_words=story_data.get("vocabulary_words", []),
                comprehension_questions=story_data.get("comprehension_questions", []),
                adaptation_notes=story_data.get("adaptation_notes", ""),
                estimated_duration_minutes=story_data.get("estimated_duration_minutes", 15),
                difficulty_level=DifficultyLevel.BEGINNER
            )
            
        except json.JSONDecodeError:
            # Fallback for non-JSON responses
            return StoryGenerationResponse(
                title="Generated Learning Story",
                content=llm_output,
                characters=[],
                learning_points=[],
                interaction_points=[],
                vocabulary_words=[],
                comprehension_questions=[],
                adaptation_notes="Manual adaptation may be needed",
                estimated_duration_minutes=15,
                difficulty_level=DifficultyLevel.BEGINNER
            )
    
    async def run(self, request: StoryGenerationRequest) -> StoryGenerationResponse:
        """Execute the story generation chain"""
        return await self.chain.ainvoke(request) 