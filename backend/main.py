import os
from fastapi import FastAPI, HTTPException, File, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import uvicorn
from typing import Dict, Any, Optional
import base64
from fastapi.responses import JSONResponse
import shutil

from chains.story_generation_chain import StoryGenerationChain
from chains.progress_summary_chain import ProgressSummaryChain
from services.voice_clone_service import VoiceCloneService
from models.requests import (
    StoryGenerationRequest,
    ProgressSummaryRequest,
    VoiceCloneRequest
)
from models.responses import (
    StoryGenerationResponse,
    ProgressSummaryResponse,
    VoiceCloneResponse
)


# Load environment variables
load_dotenv()

app = FastAPI(
    title="NeuroLearn AI API",
    description="AI-powered educational content generation for neurodivergent learners with Text-to-Speech capabilities",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
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
voice_clone_service = VoiceCloneService()

REFERENCE_AUDIO_PATH = "outputs/reference_audio.wav"

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

@app.post("/save-reference-audio")
async def save_reference_audio(reference_audio: UploadFile = File(...)):
    """Save uploaded reference audio file to backend storage"""
    try:
        with open(REFERENCE_AUDIO_PATH, "wb") as buffer:
            shutil.copyfileobj(reference_audio.file, buffer)
        return {"success": True, "message": "Reference audio saved successfully", "path": REFERENCE_AUDIO_PATH}
    except Exception as e:
        return JSONResponse(status_code=500, content={"success": False, "message": f"Failed to save reference audio: {str(e)}"})

@app.post("/clone", response_model=VoiceCloneResponse)
async def clone_voice(
    text: str = Form(...),
    speed: float = Form(...),
    language: str = Form(...),
    output_filename: str = Form(...),
    reference_audio: Optional[UploadFile] = File(None)
) -> VoiceCloneResponse:
    """Clone voice using reference audio and generate speech"""
    try:
        if reference_audio is not None:
            audio_bytes = await reference_audio.read()
        else:
            # Load the saved reference audio from disk
            with open(REFERENCE_AUDIO_PATH, "rb") as f:
                audio_bytes = f.read()
        reference_audio_base64 = base64.b64encode(audio_bytes).decode("utf-8")

        output_path, audio_base64, duration = voice_clone_service.clone_voice(
            text=text,
            reference_audio_base64=reference_audio_base64,
            speed=speed,
            language=language,
            output_filename=output_filename
        )
        return VoiceCloneResponse(
            success=True,
            audio_base64=audio_base64,
            output_path=output_path,
            duration_seconds=duration,
            message="Voice cloning completed successfully"
        )
    except Exception as e:
        return VoiceCloneResponse(
            success=False,
            message=f"Voice cloning failed: {str(e)}"
        )

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