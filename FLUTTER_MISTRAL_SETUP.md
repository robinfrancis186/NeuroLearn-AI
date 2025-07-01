# NeuroLearn AI - Flutter + Mistral 7B Setup Guide 🚀

## Complete Setup Instructions

### 🔧 Prerequisites
- Flutter SDK installed
- Python 3.9+
- [Ollama](https://ollama.ai) installed
- Git

### 📱 Flutter App Setup

1. **Clone and Setup Flutter Project**:
   ```bash
   cd /path/to/NeuroLearn\ AI
   flutter pub get
   ```

2. **Verify Flutter Installation**:
   ```bash
   flutter doctor
   ```

### 🧠 Mistral 7B Backend Setup

1. **Navigate to Backend Directory**:
   ```bash
   cd backend
   ```

2. **Create Virtual Environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Pull Mistral Model**:
   ```bash
   ollama pull mistral
   ```

5. **Start the Backend Server**:
   ```bash
   uvicorn main:app --reload --host 127.0.0.1 --port 8002
   ```

   You should see:
   ```
   INFO:     Uvicorn running on http://127.0.0.1:8002
   INFO:     Application startup complete.
   ```

### 📱 Running the Flutter App

1. **Open New Terminal** (keep backend running):
   ```bash
   cd /path/to/NeuroLearn\ AI
   ```

2. **Run Flutter App**:
   ```bash
   flutter run
   ```

   Or for web:
   ```bash
   flutter run -d chrome
   ```

## 🎯 Testing the Integration

### 1. **Backend Health Check**
   Open browser: `http://127.0.0.1:8002/docs`
   
   Or test via curl:
   ```bash
   curl http://127.0.0.1:8002/health
   ```
   Expected response: `{"status":"healthy"}`

### 2. **Flutter App Testing**
   1. Launch the Flutter app
   2. You should see the main navigation page
   3. Click "Try Mistral 7B Story Generator"
   4. Check backend status (should show "Connected")
   5. Configure story settings and click "Generate Story"

### 3. **Story Generation Test**
   - **Subject**: Science
   - **Learning Objective**: Understanding solar system
   - **Mood**: Excitement
   - **Expected**: Personalized story about space with dinosaur characters

## 🔍 Troubleshooting

### Backend Issues

**Port already in use**:
```bash
lsof -i :8002
kill -9 <PID>
```

**Ollama not found**:
```bash
# Install Ollama from https://ollama.ai
ollama pull mistral
```

**Python dependencies**:
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Flutter Issues

**Dependencies not found**:
```bash
flutter clean
flutter pub get
```

**Platform issues**:
```bash
flutter doctor
flutter config --enable-web  # For web support
```

## 📊 Features Available

### ✅ **Working Features**
- ✅ Mistral 7B story generation
- ✅ Neurodivergent-friendly adaptations
- ✅ Interactive learning elements
- ✅ Real-time backend status checking
- ✅ Beautiful Flutter UI
- ✅ Error handling and loading states

### 🚧 **Coming Soon**
- Progress analytics dashboard
- IEP goal tracking
- Parent collaboration tools
- Additional AI models

## 🎨 UI Features

### Main Navigation
- Story generation launcher
- Progress analytics (placeholder)
- Backend status indicator

### Story Generator
- Real-time backend connectivity check
- Subject selection (Science, Math, Reading, Social Skills)
- Learning objective input
- Mood selection (excitement, calm, adventure, etc.)
- Live story generation with Mistral 7B
- Beautiful story display with:
  - Story title and content
  - Character list
  - Learning points
  - Vocabulary words
  - Adaptation notes

## 🚀 Development Tips

### Running Both Services
1. **Terminal 1** (Backend):
   ```bash
   cd backend
   source venv/bin/activate
   uvicorn main:app --reload --host 127.0.0.1 --port 8002
   ```

2. **Terminal 2** (Flutter):
   ```bash
   flutter run
   ```

### Quick Test Script
```bash
# Test backend
curl -X POST "http://127.0.0.1:8002/generate-story" \
  -H "Content-Type: application/json" \
  -d '{"student_name": "Alex", "age": 8, "neurodivergent_traits": ["ADHD"], "learning_style": "visual", "attention_span": "medium", "communication_needs": "clear and concise", "sensory_preferences": ["visual"], "favorite_characters": ["dinosaurs"], "preferred_topics": ["space"], "learning_objective": "understanding solar system", "subject": "science", "mood": "excited", "previous_context": "", "memory_context": ""}'
```

## 📈 Performance Notes

- **Story Generation**: 5-15 seconds per story
- **Memory Usage**: 2-4GB RAM (Mistral model)
- **Network**: All processing is local (no internet required)
- **Cost**: $0 (completely free, no API costs)

## 🎉 Success Indicators

### Backend Success
- ✅ Server starts without errors
- ✅ Health endpoint returns `{"status":"healthy"}`
- ✅ Story generation returns JSON with title, content, etc.
- ✅ Interactive API docs accessible at `/docs`

### Flutter Success
- ✅ App launches without errors
- ✅ Main navigation shows properly
- ✅ Backend status shows "Connected"
- ✅ Story generation works end-to-end
- ✅ Generated stories display beautifully

**🎊 You're ready to revolutionize neurodivergent education with AI!** 