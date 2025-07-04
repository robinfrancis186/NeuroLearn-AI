from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
from enum import Enum

class LearningStyle(str, Enum):
    VISUAL = "visual"
    AUDITORY = "auditory"
    KINESTHETIC = "kinesthetic"
    READING_WRITING = "reading_writing"
    MULTIMODAL = "multimodal"

class StoryMood(str, Enum):
    CALM = "calm"
    EXCITEMENT = "excitement"
    COMFORT = "comfort"
    ADVENTURE = "adventure"
    CREATIVE = "creative"
    SOCIAL = "social"
    NEUTRAL = "neutral"

class Mood(str, Enum):
    HAPPY = "happy"
    CALM = "calm"
    EXCITED = "excited"
    FOCUSED = "focused"
    PLAYFUL = "playful"
    CURIOUS = "curious"

class AttentionProfile(BaseModel):
    attention_span_minutes: int = 15
    preferred_break_frequency: int = 30
    optimal_learning_time: str = "morning"

class CommunicationNeeds(BaseModel):
    prefers_shorter_sentences: bool = False
    needs_visual_supports: bool = False
    preferred_communication_mode: str = "verbal"

class SensoryPreferences(BaseModel):
    sound_sensitivity: str = "moderate"
    visual_preference: str = "moderate"
    tactile_preference: str = "moderate"

class CognitiveProfile(BaseModel):
    neurodivergent_traits: List[str]
    primary_learning_style: LearningStyle
    attention_profile: AttentionProfile
    communication_needs: CommunicationNeeds
    sensory_preferences: SensoryPreferences
    skill_levels: Dict[str, int] = {}

class StudentProfile(BaseModel):
    id: str
    name: str
    age: int
    cognitive_profile: CognitiveProfile
    favorite_characters: List[str] = Field(default_factory=list)
    preferred_topics: List[str] = Field(default_factory=list)
    learning_progress: Dict[str, Any] = Field(default_factory=dict)

class StoryGenerationRequest(BaseModel):
    student_name: str
    age: int
    neurodivergent_traits: List[str]
    learning_style: LearningStyle
    attention_span: str
    communication_needs: str
    sensory_preferences: List[str]
    favorite_characters: List[str]
    preferred_topics: List[str]
    learning_objective: str
    subject: str
    mood: Mood
    previous_context: Optional[str] = None
    memory_context: Optional[str] = None

class LearningActivity(BaseModel):
    subject: str
    completed_tasks: int
    success_rate: float
    engagement_level: str
    areas_of_difficulty: List[str] = []

class IEPGoal(BaseModel):
    id: str
    description: str
    target_criteria: str
    current_progress: float
    deadline: str
    category: str

class ProgressData(BaseModel):
    goal_id: str
    goal_description: str
    baseline_score: float
    current_score: float
    target_score: float
    assessment_date: str
    notes: List[str]

class ParentInput(BaseModel):
    observations: str
    concerns: List[str] = Field(default_factory=list)
    celebrations: List[str] = Field(default_factory=list)
    home_activities: List[str] = Field(default_factory=list)
    questions: List[str] = Field(default_factory=list)

class ProgressSummaryRequest(BaseModel):
    student_name: str
    time_period: str
    progress_data: List[ProgressData]
    learning_insights: List[Dict[str, Any]]
    visual_progress_data: Optional[Dict[str, Any]] = None

class VoiceCloneRequest(BaseModel):
    text: str = Field(..., description="Text to be converted to speech with cloned voice")
    reference_audio: str = Field(..., description="Base64 encoded reference audio file")
    speed: float = Field(default=1.0, description="Speech speed multiplier")
    language: str = Field(default="English", description="Language for text-to-speech")
    output_filename: Optional[str] = Field(default=None, description="Optional custom filename for output")