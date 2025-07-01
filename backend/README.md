# NeuroLearn AI LangChain Backend

This backend service implements LangChain flows for the NeuroLearn AI Flutter application, providing advanced AI-powered features for personalized story generation and progress summaries.

## LangChain Flows Implemented

### 1. Story Generation Flow
**Student data → Personalized prompt → LLM → Story generation**

- Processes comprehensive student profile data including neurodivergent traits, learning preferences, and cognitive profile
- Generates personalized prompts that adapt to individual student needs
- Uses LLM to create engaging, educational stories with built-in interactions
- Returns structured story data with learning points, vocabulary, and adaptation notes

### 2. Progress Summary Flow  
**Parent inputs → IEP map → Progress summaries**

- Analyzes IEP goals against student performance data
- Incorporates parent observations and home experiences
- Generates comprehensive progress reports with evidence-based insights
- Provides actionable recommendations for continued learning

## Features

- **Personalized Story Generation**: Creates tailored learning stories based on student cognitive profiles
- **IEP Progress Analysis**: Comprehensive evaluation of Individual Education Plan goals
- **Parent Collaboration**: Bridges home and school experiences in progress reporting
- **Neurodivergent-Friendly**: Specialized adaptations for ADHD, autism, and other neurodivergent traits
- **Real-time Adaptation**: Story content adapts based on student responses and engagement
- **Visual Learning Support**: Includes interaction points for different learning styles

## Installation

### Prerequisites

- Python 3.8 or higher
- OpenAI API key
- (Optional) LangSmith API key for tracing

### Setup

1. Clone the repository and navigate to the backend directory:
```bash
cd backend
```

2. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your API keys
```

5. Start the server:
```bash
python main.py
```

The backend will be available at `http://localhost:8000`

## API Endpoints

### POST /generate-story

Generates personalized learning stories using the LangChain story generation flow.

**Request Body:**
```json
{
  "student_profile": {
    "id": "student_123",
    "name": "Alex",
    "age": 8,
    "cognitive_profile": {
      "neurodivergent_traits": ["ADHD", "visual_processing"],
      "primary_learning_style": "visual",
      "attention_profile": {
        "attention_span_minutes": 15,
        "best_focus_time": "morning",
        "distraction_sensitivity": "high"
      },
      "communication_needs": {
        "prefers_shorter_sentences": true,
        "needs_visual_supports": true,
        "preferred_communication_mode": "verbal"
      },
      "sensory_preferences": {
        "sound_sensitivity": "high",
        "visual_preference": "moderate",
        "tactile_preference": "low"
      }
    },
    "favorite_characters": ["dinosaurs", "robots"],
    "preferred_topics": ["science", "adventure"]
  },
  "learning_objective": "Understanding addition with numbers 1-10",
  "subject": "mathematics",
  "mood": "adventure",
  "memory_context": {
    "location": "park",
    "people": "mom, dad",
    "matter": "feeding ducks"
  }
}
```

**Response:**
```json
{
  "title": "Alex and the Counting Ducks Adventure",
  "content": "Once upon a time, Alex and their family went to the park...",
  "characters": ["Alex", "Robot Helper", "Counting Ducks"],
  "learning_points": ["Addition with single digits", "Counting in sequence"],
  "interaction_points": [
    {
      "type": "choice",
      "prompt": "How many ducks did Alex count?",
      "expected_responses": ["5", "five", "5 ducks"]
    }
  ],
  "vocabulary_words": ["addition", "sum", "total"],
  "comprehension_questions": ["What did Alex learn about numbers?"],
  "adaptation_notes": "Use visual counting aids if student struggles",
  "estimated_duration_minutes": 12,
  "difficulty_level": "beginner"
}
```

### POST /generate-progress-summary

Creates comprehensive progress summaries using the LangChain progress analysis flow.

**Request Body:**
```json
{
  "student_profile": { /* Same as above */ },
  "iep_goals": [
    {
      "id": "goal_1",
      "description": "Improve reading comprehension",
      "target_criteria": "80% accuracy on grade-level texts",
      "current_progress": 0.65,
      "deadline": "2024-06-01",
      "category": "academic"
    }
  ],
  "progress_data": {
    "session_count": 20,
    "total_time_minutes": 600,
    "comprehension_scores": [0.6, 0.7, 0.65, 0.8],
    "engagement_scores": [0.8, 0.9, 0.7, 0.85],
    "mood_trends": ["positive", "engaged", "focused"],
    "achievements": ["Completed first chapter book", "Improved sight words"],
    "areas_of_strength": ["Visual learning", "Story comprehension"],
    "areas_needing_support": ["Phonics", "Reading fluency"]
  },
  "parent_input": {
    "observations": "Alex is reading more at home and seems excited about books",
    "concerns": ["Still struggles with sounding out new words"],
    "celebrations": ["Finished reading first chapter book independently"],
    "home_activities": ["Daily reading time", "Library visits"],
    "questions": ["How can we help with phonics at home?"]
  },
  "time_period": "monthly"
}
```

**Response:**
```json
{
  "student_name": "Alex",
  "report_period": "Monthly Report",
  "overall_progress_score": 0.72,
  "iep_goal_progress": [
    {
      "goal_id": "goal_1",
      "goal_description": "Improve reading comprehension",
      "current_progress": 0.65,
      "progress_change": 0.15,
      "status": "on_track",
      "evidence": ["Increased comprehension scores", "Completed chapter book"],
      "next_steps": ["Focus on phonics support", "Continue story-based learning"]
    }
  ],
  "learning_insights": [
    {
      "category": "Learning Patterns",
      "insight": "Alex shows strong visual learning preferences",
      "supporting_data": "High engagement with picture books and visual stories",
      "recommendation": "Continue using visual supports and graphic organizers",
      "priority": "high"
    }
  ],
  "parent_collaboration_summary": "Parents are actively supporting reading at home...",
  "celebration_highlights": ["First chapter book completion", "Increased reading motivation"],
  "areas_for_focus": ["Phonics development", "Reading fluency"],
  "recommended_home_activities": ["Sound-based games", "Phonics apps", "Repeated reading"],
  "next_meeting_talking_points": ["Phonics intervention strategies", "Home-school reading coordination"],
  "visual_progress_data": {
    "overall_progress": {"score": 0.72, "percentage": 72.0},
    "goal_progress_chart": {
      "labels": ["Reading Comprehension"],
      "data": [0.65],
      "type": "bar"
    }
  }
}
```

### GET /health

Health check endpoint to verify backend status.

**Response:**
```json
{
  "status": "healthy",
  "service": "langchain-backend"
}
```

## LangChain Architecture

### Story Generation Chain

1. **Data Processing**: Student profile data is processed and formatted
2. **Prompt Engineering**: Personalized prompts are created based on neurodivergent traits
3. **LLM Generation**: GPT-4 generates the story content with structured output
4. **Response Parsing**: JSON response is parsed into structured story format

### Progress Summary Chain

1. **Parallel Analysis**: Multiple prompt chains run in parallel:
   - IEP goal analysis
   - Learning insights generation
   - Parent collaboration summary
2. **Data Synthesis**: Results are combined into comprehensive report
3. **Visual Data Generation**: Chart data is prepared for dashboard visualization

## Environment Variables

Create a `.env` file with the following variables:

```env
OPENAI_API_KEY=your_openai_api_key_here
LANGCHAIN_TRACING_V2=true
LANGCHAIN_API_KEY=your_langsmith_api_key_here
PORT=8000
```

## Integration with Flutter App

The Flutter app includes a `LangChainService` that communicates with this backend:

```dart
// Initialize the service
await LangChainService.initialize();

// Generate a story
final story = await LangChainService.instance.generatePersonalizedStory(
  student: studentProfile,
  learningObjective: "Basic addition",
  subject: "mathematics",
  mood: StoryMood.adventure,
);

// Generate progress summary
final summary = await LangChainService.instance.generateProgressSummary(
  student: studentProfile,
  iepGoals: goals,
  progressData: data,
  parentInput: input,
);
```

## Development

### Running in Development

```bash
# With auto-reload
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Testing

```bash
# Test the endpoints
curl -X POST http://localhost:8000/generate-story \
  -H "Content-Type: application/json" \
  -d @test_story_request.json

curl -X POST http://localhost:8000/generate-progress-summary \
  -H "Content-Type: application/json" \
  -d @test_progress_request.json
```

## Deployment

For production deployment:

1. Set proper CORS origins in `main.py`
2. Use environment variables for configuration
3. Deploy using Docker or cloud platforms like Heroku, AWS, or GCP
4. Ensure proper API key security and rate limiting

## Contributing

1. Follow Python PEP 8 style guidelines
2. Add type hints to all functions
3. Update documentation for new features
4. Test with various student profiles and edge cases

## License

This project is part of the NeuroLearn AI ecosystem and follows the same licensing terms. 