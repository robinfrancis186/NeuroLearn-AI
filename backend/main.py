import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import uvicorn
from typing import Dict, Any

from chains.story_generation_chain import StoryGenerationChain
from chains.progress_summary_chain import ProgressSummaryChain
from models.requests import (
    StoryGenerationRequest,
    ProgressSummaryRequest
)
from models.responses import (
    StoryGenerationResponse,
    ProgressSummaryResponse
)

# Load environment variables
load_dotenv()

app = FastAPI(
    title="NeuroLearn AI API",
    description="AI-powered educational content generation for neurodivergent learners",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize chains
story_chain = StoryGenerationChain()
progress_chain = ProgressSummaryChain()

@app.get("/")
async def root():
    return {"message": "NeuroLearn AI LangChain Backend is running"}

@app.post("/generate-story", response_model=StoryGenerationResponse)
async def generate_story(request: StoryGenerationRequest) -> StoryGenerationResponse:
    """Generate a personalized educational story"""
    try:
        return await story_chain.run(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Story generation failed: {str(e)}")

@app.post("/generate-progress-summary", response_model=ProgressSummaryResponse)
async def generate_progress_summary(request: ProgressSummaryRequest) -> ProgressSummaryResponse:
    """Generate a progress summary report"""
    try:
        return await progress_chain.run(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Progress summary generation failed: {str(e)}")

@app.get("/health")
async def health_check() -> Dict[str, str]:
    """Health check endpoint"""
    return {"status": "healthy"}

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port) 