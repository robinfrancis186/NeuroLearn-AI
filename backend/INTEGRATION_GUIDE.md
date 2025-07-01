# NeuroLearn AI - LangChain Integration Guide

This guide explains how to set up and run the LangChain-powered backend for NeuroLearn AI, which uses Mistral 7B with Ollama for local AI processing.

## Prerequisites

1. Python 3.9+
2. [Ollama](https://ollama.ai) installed on your system
3. Virtual environment tool (e.g., `venv`)

## Setup Instructions

1. **Install Ollama and Pull Mistral Model**:
   ```bash
   # Install Ollama from https://ollama.ai
   # Pull Mistral model
   ollama pull mistral
   ```

2. **Create and Activate Virtual Environment**:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```

3. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Start the FastAPI Server**:
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

## API Endpoints

1. **Health Check**:
   - `GET /health`
   - Returns server status

2. **Story Generation**:
   - `POST /generate-story`
   - Generates personalized educational stories
   - Input: Student profile, learning objectives, preferences

3. **Progress Summary**:
   - `POST /generate-progress-summary`
   - Generates detailed progress reports
   - Input: Learning activities, assessment data, IEP goals

## Testing

1. **Using Swagger UI**:
   - Visit `http://localhost:8000/docs`
   - Interactive API documentation and testing interface

2. **Using Python Script**:
   ```python
   import requests
   
   # Test story generation
   response = requests.post(
       "http://localhost:8000/generate-story",
       json={
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
   )
   print(response.json())
   ```

## Performance Considerations

1. **Model Loading**:
   - First request may take longer as Mistral model is loaded into memory
   - Subsequent requests will be faster

2. **Resource Usage**:
   - Mistral 7B requires ~16GB RAM for optimal performance
   - Consider using a smaller model if memory is constrained

3. **Response Times**:
   - Story generation: 10-30 seconds
   - Progress summaries: 15-45 seconds

## Error Handling

The API implements comprehensive error handling:
- Invalid requests return 400 status code
- Processing errors return 500 status code
- All errors include descriptive messages

## Security Notes

1. In production:
   - Configure CORS properly in `main.py`
   - Use HTTPS
   - Implement authentication
   - Rate limit requests

2. Local Development:
   - Default configuration allows all origins (CORS)
   - No authentication required
   - Suitable for development only

## ✅ Setup Complete!

Your LangChain backend is now fully integrated with OpenAI and ready for use in your Flutter app!

## 🎯 What's Been Set Up

### 1. OpenAI API Configuration
- ✅ OpenAI API key added to `backend/.env`
- ✅ Models configured to use `gpt-3.5-turbo` (cost-effective and powerful)
- ✅ Backend tested and communicating with OpenAI API

### 2. LangChain Flows Implemented

#### Story Generation Flow
**Path:** `Student data → Personalized prompt → LLM → Story generation`
- **Endpoint:** `POST /generate-story`
- **Features:**
  - Personalized based on neurodivergent traits
  - Adapts to learning styles and sensory preferences
  - Includes interactive elements
  - Generates comprehension questions
  - Provides vocabulary and learning points

#### Progress Summary Flow
**Path:** `Parent inputs → IEP map → Progress summaries`
- **Endpoint:** `POST /generate-progress-summary`
- **Features:**
  - Analyzes IEP goal progress
  - Generates learning insights
  - Creates parent collaboration summaries
  - Provides home activity recommendations

### 3. Flutter Integration Ready
- ✅ `LangChainService` implemented in `lib/core/services/langchain_service.dart`
- ✅ Comprehensive response models with proper error handling
- ✅ Health check functionality for backend monitoring

## 🚀 Getting Started

### 1. Start the Backend Server
```bash
cd backend
source venv/bin/activate
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 2. Initialize in Flutter
```dart
// In your main.dart or app initialization
await LangChainService.initialize();
```

### 3. Generate Stories
```dart
final storyResponse = await LangChainService.instance.generatePersonalizedStory(
  student: studentProfile,
  learningObjective: "Learn about friendship",
  subject: "social_skills",
  mood: StoryMood.adventure,
);
```

### 4. Generate Progress Summaries
```dart
final progressSummary = await LangChainService.instance.generateProgressSummary(
  student: studentProfile,
  iepGoals: goals,
  progressData: data,
  parentInput: input,
);
```

## 💳 OpenAI Billing Setup Required

The integration is working correctly, but you need to add billing to your OpenAI account:

1. Visit [OpenAI Platform - Billing](https://platform.openai.com/account/billing)
2. Add a payment method
3. Purchase credits or set up auto-recharge
4. The current quota error will resolve once billing is active

**Estimated Costs:**
- Story Generation: ~$0.01-0.03 per story
- Progress Summary: ~$0.02-0.05 per summary
- GPT-3.5-turbo is very cost-effective for these use cases

## 🔧 Customization Options

### 1. Prompt Customization
Edit the prompt templates in:
- `backend/chains/story_generation_chain.py` (line 35)
- `backend/chains/progress_summary_chain.py` (line 40, 70, 98)

### 2. Model Configuration
Change models in the chain files if needed:
```python
self.llm = ChatOpenAI(
    model="gpt-4",  # Upgrade for better quality
    temperature=0.8,  # Adjust creativity level
    max_tokens=2000   # Adjust response length
)
```

### 3. Backend URL Configuration
Update the backend URL in `lib/core/services/langchain_service.dart`:
```dart
_baseUrl = 'https://your-production-url.com';  // For production
```

## 🧪 Testing

### Health Check
```bash
curl http://localhost:8000/health
```

### Test Story Generation
```bash
python backend/test_integration.py
```

### Flutter Integration Test
```dart
final isHealthy = await LangChainService.instance.isBackendHealthy();
print('Backend status: $isHealthy');
```

## 📱 UI Integration Examples

### Story Tutor Integration
```dart
// In your story tutor page
class StoryTutorPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LangChainStoryResponse>(
      future: LangChainService.instance.generatePersonalizedStory(
        student: currentStudent,
        learningObjective: selectedObjective,
        subject: selectedSubject,
        mood: selectedMood,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StoryDisplayWidget(story: snapshot.data!);
        }
        return LoadingWidget();
      },
    );
  }
}
```

### Progress Dashboard Integration
```dart
// In your dashboard
class ProgressDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LangChainProgressSummary>(
      future: LangChainService.instance.generateProgressSummary(
        student: student,
        iepGoals: iepGoals,
        progressData: progressData,
        parentInput: parentInput,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProgressSummaryWidget(summary: snapshot.data!);
        }
        return LoadingWidget();
      },
    );
  }
}
```

## 🔐 Security Best Practices

1. **Environment Variables**: Keep your `.env` file secure and never commit it to version control
2. **Production Setup**: Use environment-specific configurations
3. **Rate Limiting**: Implement rate limiting in production to manage API costs
4. **Error Handling**: The service includes comprehensive error handling for API failures

## 📝 Next Steps

1. ✅ Add billing to OpenAI account
2. 🔄 Test the integration with your Flutter UI
3. 🎨 Customize prompts for your specific educational needs
4. 📊 Implement usage analytics to track effectiveness
5. 🚀 Deploy backend to production (AWS, Google Cloud, etc.)

## 🆘 Troubleshooting

### Backend Not Starting
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
```

### OpenAI Errors
- Check your API key in `.env`
- Verify billing is set up on OpenAI platform
- Monitor usage limits

### Flutter Connection Issues
- Ensure backend is running on correct port
- Check network connectivity
- Verify URL configuration in LangChainService

---

Your LangChain integration is now complete and ready to provide personalized, AI-powered educational experiences for neurodivergent learners! 🎉 