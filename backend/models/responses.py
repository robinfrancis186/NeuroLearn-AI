from pydantic import BaseModel
from typing import List, Dict, Optional, Any
from enum import Enum

class InteractionType(str, Enum):
    QUESTION = "question"
    CHOICE = "choice"
    ACTIVITY = "activity"
    GESTURE = "gesture"

class DifficultyLevel(str, Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"

class InteractionPoint(BaseModel):
    type: InteractionType
    prompt: str
    expected_responses: List[str]

class StoryGenerationResponse(BaseModel):
    title: str
    content: str
    characters: List[str]
    learning_points: List[str]
    interaction_points: List[InteractionPoint]
    vocabulary_words: List[str]
    comprehension_questions: List[str]
    adaptation_notes: str
    estimated_duration_minutes: int
    difficulty_level: DifficultyLevel

class IEPGoalProgress(BaseModel):
    goal_id: str
    goal_description: str
    current_progress: float
    progress_change: float
    status: str
    evidence: List[str]
    next_steps: List[str]

class LearningInsight(BaseModel):
    category: str
    insight: str
    supporting_data: str
    recommendation: str
    priority: str

class ProgressSummaryResponse(BaseModel):
    student_name: str
    time_period: str
    overview: str
    iep_goal_progress: List[IEPGoalProgress]
    insights: List[LearningInsight]
    celebration_highlights: List[str]
    areas_for_focus: List[str]
    parent_collaboration_summary: str
    recommended_home_activities: List[str]
    next_meeting_talking_points: List[str]
    overall_progress_score: float
    visual_data: Optional[Dict[str, Any]] = None

class VoiceCloneResponse(BaseModel):
    success: bool
    audio_base64: Optional[str] = None
    output_path: Optional[str] = None
    duration_seconds: Optional[float] = None
    message: str