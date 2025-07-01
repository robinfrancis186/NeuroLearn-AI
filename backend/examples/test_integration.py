import requests
import json
from typing import Dict, Any, Optional

def test_story_generation() -> Optional[Dict[str, Any]]:
    """Test the story generation endpoint"""
    url = "http://localhost:8002/generate-story"
    payload = {
        "student_name": "Alex",
        "age": 8,
        "neurodivergent_traits": ["ADHD", "dyslexia"],
        "learning_style": "visual",
        "attention_span": "medium",
        "communication_needs": "clear and concise",
        "sensory_preferences": ["visual", "tactile"],
        "favorite_characters": ["dinosaurs", "scientists"],
        "preferred_topics": ["space", "animals"],
        "learning_objective": "understanding solar system",
        "subject": "science",
        "mood": "excited",
        "previous_context": "",
        "memory_context": ""
    }
    
    response = requests.post(url, json=payload)
    print("\n=== Story Generation Test ===")
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        result = response.json()
        print("\nGenerated Story Title:", result.get("title", "No title"))
        print("\nFirst few lines:", result.get("content", "No content")[:200] + "...")
    else:
        print("Error:", response.text)
    return response.json() if response.status_code == 200 else None

def test_progress_summary() -> Optional[Dict[str, Any]]:
    """Test the progress summary endpoint"""
    url = "http://localhost:8002/generate-progress-summary"
    payload = {
        "student_name": "Alex",
        "age": 8,
        "assessment_period": "Q4 2023",
        "subjects": ["Math", "Science", "Reading"],
        "learning_activities": [
            {
                "subject": "Math",
                "completed_tasks": 15,
                "success_rate": 0.85,
                "engagement_level": "high",
                "areas_of_difficulty": ["long division"]
            },
            {
                "subject": "Science",
                "completed_tasks": 12,
                "success_rate": 0.92,
                "engagement_level": "very high",
                "areas_of_difficulty": []
            }
        ],
        "iep_goals": [
            {
                "goal": "Improve reading comprehension",
                "baseline": "Reading at grade level 2",
                "target": "Reading at grade level 3",
                "progress_indicators": ["Can summarize main points", "Identifies key characters"]
            }
        ],
        "behavioral_notes": "Shows increased focus during hands-on activities"
    }
    
    response = requests.post(url, json=payload)
    print("\n=== Progress Summary Test ===")
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        result = response.json()
        print("\nProgress Overview:", result.get("overview", "No overview")[:200] + "...")
        print("\nNumber of insights:", len(result.get("insights", [])))
    else:
        print("Error:", response.text)
    return response.json() if response.status_code == 200 else None

def test_health() -> bool:
    """Test the health check endpoint"""
    url = "http://localhost:8002/health"
    response = requests.get(url)
    print("\n=== Health Check Test ===")
    print(f"Status Code: {response.status_code}")
    print("Response:", response.json())
    return response.status_code == 200

if __name__ == "__main__":
    print("Starting integration tests...")
    
    # Test health endpoint
    health_ok = test_health()
    if not health_ok:
        print("Health check failed. Stopping tests.")
        exit(1)
    
    # Test story generation
    story_result = test_story_generation()
    
    # Test progress summary
    summary_result = test_progress_summary()
    
    print("\nTests completed!") 