#!/usr/bin/env python3
"""
Test script for NeuroLearn AI LangChain Backend

This script demonstrates how to test both LangChain flows:
1. Story Generation Flow: Student data → Personalized prompt → LLM → Story generation
2. Progress Summary Flow: Parent inputs → IEP map → Progress summaries
"""

import asyncio
import json
import httpx
from typing import Dict, Any

BASE_URL = "http://localhost:8001"

# Test data for story generation
story_request_data = {
    "student_profile": {
        "id": "student_alex_123",
        "name": "Alex",
        "age": 8,
        "cognitive_profile": {
            "neurodivergent_traits": ["ADHD", "visual_processing_strength"],
            "primary_learning_style": "visual",
            "attention_profile": {
                "attention_span_minutes": 15,
                "best_focus_time": "morning",
                "distraction_sensitivity": "high"
            },
            "sensory_preferences": {
                "sound_sensitivity": "high",
                "visual_preference": "moderate", 
                "tactile_preference": "low"
            },
            "communication_needs": {
                "prefers_shorter_sentences": True,
                "needs_visual_supports": True,
                "preferred_communication_mode": "verbal"
            },
            "skill_levels": {
                "reading": 0.7,
                "math": 0.6,
                "social_skills": 0.8
            },
            "support_strategies": [
                "visual_schedules",
                "movement_breaks",
                "positive_reinforcement"
            ]
        },
        "favorite_characters": ["dinosaurs", "robots", "friendly_dragons"],
        "preferred_topics": ["science", "adventure", "animals"],
        "learning_progress": {
            "current_level": "grade_2",
            "strengths": ["pattern_recognition", "creative_thinking"],
            "challenges": ["sustained_attention", "working_memory"]
        }
    },
    "learning_objective": "Understanding addition with numbers 1-10 using visual grouping",
    "subject": "mathematics",
    "mood": "adventure",
    "previous_story_context": None,
    "memory_context": {
        "location": "local park",
        "people": "mom, dad, little sister Emma",
        "matter": "feeding ducks and counting them together"
    }
}

# Test data for progress summary
progress_request_data = {
    "student_profile": story_request_data["student_profile"],  # Same student
    "iep_goals": [
        {
            "id": "math_goal_1",
            "description": "Improve basic addition skills with numbers 1-10",
            "target_criteria": "Complete 8 out of 10 addition problems correctly",
            "current_progress": 0.65,
            "deadline": "2024-06-30",
            "category": "academic"
        },
        {
            "id": "attention_goal_1", 
            "description": "Increase sustained attention for learning activities",
            "target_criteria": "Maintain focus for 15 consecutive minutes",
            "current_progress": 0.70,
            "deadline": "2024-06-30",
            "category": "behavioral"
        },
        {
            "id": "social_goal_1",
            "description": "Develop peer interaction skills during group activities",
            "target_criteria": "Participate in group activities with minimal prompting",
            "current_progress": 0.80,
            "deadline": "2024-06-30", 
            "category": "social"
        }
    ],
    "progress_data": {
        "session_count": 25,
        "total_time_minutes": 750,
        "comprehension_scores": [0.6, 0.65, 0.7, 0.68, 0.75, 0.72, 0.78],
        "engagement_scores": [0.7, 0.8, 0.75, 0.85, 0.9, 0.8, 0.88],
        "mood_trends": ["curious", "excited", "focused", "engaged", "proud"],
        "achievements": [
            "Completed first chapter book independently",
            "Mastered addition facts 1-5",
            "Participated in group science project",
            "Used visual schedule independently for a week"
        ],
        "areas_of_strength": [
            "Visual pattern recognition",
            "Creative problem solving", 
            "Enthusiasm for learning",
            "Strong memory for stories"
        ],
        "areas_needing_support": [
            "Working memory strategies",
            "Self-regulation during transitions",
            "Fine motor coordination"
        ]
    },
    "parent_input": {
        "observations": "Alex has been much more excited about school lately. We've noticed they're starting to count objects around the house spontaneously and asking more math questions. Reading time has become a favorite activity, especially stories with animals or adventure themes. Still needs reminders for transitions but is getting better with visual cues.",
        "concerns": [
            "Still struggles with sitting still during homework time",
            "Gets overwhelmed in noisy environments",
            "Sometimes has difficulty with multi-step instructions"
        ],
        "celebrations": [
            "Successfully read entire book to little sister",
            "Helped count money at the store",
            "Made a new friend at school",
            "Remembered to use quiet voice in library"
        ],
        "home_activities": [
            "Daily 20-minute reading time",
            "Math games with manipulatives",
            "Outdoor nature walks with counting activities",
            "Art projects and building with blocks"
        ],
        "questions": [
            "How can we better support working memory at home?",
            "Are there specific math games you'd recommend?",
            "What's the best way to handle meltdowns during homework?",
            "How can we help with the transition to group activities?"
        ]
    },
    "time_period": "monthly"
}

async def test_story_generation():
    """Test the story generation LangChain flow"""
    print("🔄 Testing Story Generation Flow...")
    print("📊 Student data → Personalized prompt → LLM → Story generation")
    
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{BASE_URL}/generate-story",
                json=story_request_data,
                timeout=60.0
            )
            
            if response.status_code == 200:
                story_response = response.json()
                print("✅ Story Generation Successful!")
                print(f"📖 Title: {story_response['title']}")
                print(f"⏱️  Duration: {story_response['estimated_duration_minutes']} minutes")
                print(f"📚 Learning Points: {', '.join(story_response['learning_points'])}")
                print(f"👥 Characters: {', '.join(story_response['characters'])}")
                print(f"🎯 Interactions: {len(story_response['interaction_points'])} interaction points")
                print("\n📝 Story Content Preview:")
                print(story_response['content'][:200] + "...")
                print("\n" + "="*50)
                return story_response
            else:
                print(f"❌ Story Generation Failed: {response.status_code}")
                print(response.text)
                return None
                
        except Exception as e:
            print(f"❌ Error during story generation: {e}")
            return None

async def test_progress_summary():
    """Test the progress summary LangChain flow"""
    print("🔄 Testing Progress Summary Flow...")
    print("📊 Parent inputs → IEP map → Progress summaries")
    
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{BASE_URL}/generate-progress-summary",
                json=progress_request_data,
                timeout=60.0
            )
            
            if response.status_code == 200:
                summary_response = response.json()
                print("✅ Progress Summary Generation Successful!")
                print(f"👤 Student: {summary_response['student_name']}")
                print(f"📅 Period: {summary_response['report_period']}")
                print(f"📈 Overall Progress: {summary_response['overall_progress_score']:.1%}")
                print(f"🎯 IEP Goals Analyzed: {len(summary_response['iep_goal_progress'])}")
                print(f"💡 Learning Insights: {len(summary_response['learning_insights'])}")
                print(f"🏠 Home Activities: {len(summary_response['recommended_home_activities'])}")
                
                print("\n🎉 Celebration Highlights:")
                for highlight in summary_response['celebration_highlights'][:3]:
                    print(f"  • {highlight}")
                
                print("\n🔍 Areas for Focus:")
                for area in summary_response['areas_for_focus'][:3]:
                    print(f"  • {area}")
                
                print("\n" + "="*50)
                return summary_response
            else:
                print(f"❌ Progress Summary Failed: {response.status_code}")
                print(response.text)
                return None
                
        except Exception as e:
            print(f"❌ Error during progress summary: {e}")
            return None

async def test_health_check():
    """Test backend health"""
    print("🔄 Testing Backend Health...")
    
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(f"{BASE_URL}/health", timeout=10.0)
            
            if response.status_code == 200:
                health_data = response.json()
                print(f"✅ Backend is healthy: {health_data}")
                return True
            else:
                print(f"❌ Health check failed: {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ Error during health check: {e}")
            print("💡 Make sure the backend is running at http://localhost:8001")
            return False

async def main():
    """Run all tests"""
    print("🚀 NeuroLearn AI LangChain Backend Test Suite")
    print("="*60)
    
    # Test health first
    if not await test_health_check():
        print("\n❌ Backend is not available. Please start the backend first:")
        print("   cd backend && python main.py")
        return
    
    print("\n")
    
    # Test story generation flow
    story_result = await test_story_generation()
    
    print("\n")
    
    # Test progress summary flow  
    summary_result = await test_progress_summary()
    
    print("\n🏁 Test Suite Complete!")
    
    if story_result and summary_result:
        print("✅ All LangChain flows are working correctly!")
        
        # Save results for inspection
        with open("test_results.json", "w") as f:
            json.dump({
                "story_generation": story_result,
                "progress_summary": summary_result
            }, f, indent=2)
        print("💾 Test results saved to test_results.json")
    else:
        print("❌ Some tests failed. Check the backend logs for details.")

if __name__ == "__main__":
    asyncio.run(main()) 