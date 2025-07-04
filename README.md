# NeuroLearn AI 🧠✨

> **Learning Without Limits — One Story at a Time**

NeuroLearn AI is an adaptive, emotion-aware educational platform specifically designed for neurodivergent students. It combines AI-powered story generation, real-time emotion detection, and personalized learning experiences to create an inclusive learning environment.

## 🌟 Features

### Core Learning Platform
- **🎭 Emotion Engine**: Real-time facial emotion detection using Google ML Kit
- **📚 AI Story Generation**: Powered by Mistral 7B and adaptive storytelling
- **🗣️ Communication Tools**: Visual boards, emotion expression, and social skills practice
- **🎯 Personalized Learning**: Adaptive content based on cognitive profiles and emotional states
- **📊 Analytics Dashboard**: Comprehensive progress tracking and insights
- **🎮 Interactive Elements**: Flashcards, AR geography, and gamified learning

### Accessibility & Neurodivergence Support
- **♿ Inclusive Design**: High contrast modes, reduced animations, and sensory preferences
- **🧩 Cognitive Profiling**: Attention span tracking, learning style adaptation
- **💬 Communication Assistance**: Alternative communication methods and visual supports
- **🎨 Mood-Based Content**: Stories adapt to emotional states for optimal learning
- **⏱️ Break Management**: Automatic break suggestions based on attention patterns

## 🏗️ Architecture

### Frontend (Flutter Web)
```
lib/
├── core/                     # Core business logic and models
│   ├── models/              # Data models (Student, EmotionalState, etc.)
│   ├── services/            # Business logic services
│   └── utils/               # Utility functions and helpers
├── features/                # Feature-based modules
│   ├── emotion_engine/      # Emotion detection and analysis
│   ├── story_tutor/         # Story generation and management
│   ├── communication/       # Communication assistance tools
│   ├── dashboard/           # Analytics and progress tracking
│   ├── flashcards/          # Interactive learning cards
│   └── ar_geography/        # Augmented reality learning
├── shared/                  # Shared UI components and themes
│   ├── widgets/             # Reusable UI components
│   ├── themes/              # App theming and styling
│   └── providers/           # State management (Riverpod)
└── main.dart               # Application entry point
```

### Backend (Python/FastAPI)
```
backend/
├── app/
│   ├── api/                 # API endpoints
│   ├── core/                # Core backend logic
│   ├── models/              # Database models
│   └── services/            # Business logic services
├── mistral_integration/     # Mistral AI integration
├── emotion_processing/      # Emotion data processing
└── requirements.txt         # Python dependencies
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Python 3.8+ (for backend)
- Chrome/Edge browser (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/neurolearn-ai.git
   cd neurolearn-ai
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Install backend dependencies**
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. **Run the application**
   ```bash
   # Frontend (Flutter Web)
   flutter run -d web-server --web-port=8087
   
   # Backend (Optional - for full AI features)
   cd backend
   python -m uvicorn app.main:app --reload
   ```

5. **Open in browser**
   Navigate to `http://localhost:8087`

## 🎯 Core Features Deep Dive

### Emotion Engine
The Emotion Engine uses advanced facial recognition to detect student emotions and adapt content accordingly:

- **Real-time Detection**: 2-second intervals with confidence scoring
- **8 Emotion Categories**: Happiness, sadness, anger, fear, surprise, disgust, contempt, neutral
- **Mood Mapping**: Emotions mapped to 7 story mood types for optimal learning
- **Intervention System**: Automatic calming or energizing content recommendations

### Story Generation System
AI-powered storytelling that creates personalized educational content:

- **Memory Integration**: Family stories converted to learning adventures
- **Adaptive Narrative**: Stories adjust based on emotional state and learning progress
- **Multi-modal Input**: Voice notes, manual entry, and guided story building
- **Educational Focus**: Math, reading, science concepts woven into engaging narratives

### Communication Tools
Comprehensive communication assistance for neurodivergent learners:

- **Visual Communication Board**: Category-based word selection
- **Emotion Expression**: Visual emotion identification and communication
- **Social Skills Practice**: Interactive conversation scenarios
- **Voice Practice**: Speech exercises with feedback

## 🛠️ Development

### Code Style & Standards
- **Dart/Flutter**: Follow official Dart style guide
- **File Organization**: Feature-based folder structure
- **Naming Conventions**: PascalCase for classes, camelCase for variables
- **Documentation**: Comprehensive inline documentation for all public APIs

### State Management
Using **Riverpod** for predictable state management:
- Providers for global state
- StateNotifiers for complex state logic
- Consumer widgets for reactive UI

### Testing Strategy
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test/
```

### Adding New Features

1. **Create feature module** in `lib/features/`
2. **Define models** in `lib/core/models/`
3. **Implement services** in `lib/core/services/`
4. **Add routing** in main navigation
5. **Write tests** for all components

## 📱 Supported Platforms

- ✅ **Web** (Primary platform)
- 🔄 **iOS** (Planned)
- 🔄 **Android** (Planned)
- 🔄 **Desktop** (Future consideration)

## 🔧 Configuration

### Environment Variables
Create `.env` file for configuration:
```bash
# AI Model Configuration
MISTRAL_API_KEY=your_mistral_key
OPENAI_API_KEY=your_openai_key

# Database Configuration
DATABASE_URL=your_database_url

# Feature Flags
ENABLE_EMOTION_ENGINE=true
ENABLE_AR_FEATURES=false
```

### ML Kit Setup
For emotion detection, ensure ML Kit dependencies are properly configured:
```yaml
dependencies:
  google_ml_kit: ^0.15.0
  camera: ^0.10.0
  permission_handler: ^10.0.0
```

### Model Context Protocol (MCP) Integration
NeuroLearn AI includes Context7 MCP server for enhanced development experience:

- **Real-time Documentation**: Instant access to up-to-date library documentation
- **AI-Assisted Development**: Smart code completion with current best practices
- **Framework Support**: Flutter, Dart, Python, FastAPI, and ML libraries

**Configuration**: `~/.cursor/mcp.json`
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

See [MCP Integration Guide](docs/mcp_integration.md) for detailed setup and usage instructions.

## 🎨 Theming & Accessibility

### Design System
- **Primary Colors**: Blue (#2196F3) for focus, Green (#4CAF50) for comfort
- **Typography**: Accessible fonts with clear hierarchy
- **Spacing**: 8px grid system for consistent layouts
- **Components**: Material Design 3 with custom neurodivergent adaptations

### Accessibility Features
- High contrast mode
- Reduced motion options
- Large text support
- Screen reader compatibility
- Keyboard navigation

## 📊 Analytics & Privacy

### Data Collection
- **Learning Progress**: Anonymized learning analytics
- **Emotion Data**: Local processing, no cloud storage
- **Usage Patterns**: Aggregate usage statistics for improvement

### Privacy Compliance
- COPPA compliant for children's data
- GDPR ready with data export/deletion
- Local-first architecture for sensitive data

## 🤝 Contributing

### Getting Started
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Development Workflow
1. **Issue Creation**: Use GitHub issues for bug reports and feature requests
2. **Code Review**: All PRs require review and automated testing
3. **Testing**: Maintain >80% code coverage
4. **Documentation**: Update docs for any API changes

## 📋 Roadmap

### Phase 1 (Current)
- ✅ Core emotion detection
- ✅ Basic story generation
- ✅ Communication tools
- ✅ Web platform

### Phase 2 (Next 3 months)
- 🔄 Advanced AI tutoring
- 🔄 Parent/teacher dashboard
- 🔄 Mobile app development
- 🔄 Multi-language support

### Phase 3 (6-12 months)
- 🔄 AR/VR learning experiences
- 🔄 Advanced analytics
- 🔄 Third-party integrations
- 🔄 Marketplace for content

## 📚 Documentation

### Core Documentation
- [📖 Development Guide](DEVELOPMENT_GUIDE.md) - Comprehensive development setup and guidelines
- [🏗️ Architecture](docs/architecture.md) - System architecture and design patterns
- [📁 Code Organization](docs/code_organization.md) - Project structure and file organization
- [🚀 Deployment Guide](docs/deployment.md) - Deployment strategies and configurations

### API & Technical Reference
- [🔌 API Reference](docs/api.md) - Complete API documentation with examples
- [🎨 Widget Catalog](docs/widgets.md) - UI component library and usage guide
- [🔧 Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

### Specialized Guides
- [🧩 Neurodivergence Support](docs/neurodivergence.md) - Understanding and supporting neurodivergent learners
- [♿ Accessibility Guidelines](docs/accessibility/) - WCAG compliance and inclusive design
- [🎯 Testing Strategy](docs/testing.md) - Comprehensive testing approaches

## 🆘 Support & Resources

### Getting Help
- **📋 GitHub Issues**: [Report bugs and request features](https://github.com/your-org/neurolearn-ai/issues)
- **💬 Discord Community**: [Join our developer community](https://discord.gg/neurolearn-ai)
- **📧 Email Support**: technical-support@neurolearn-ai.com
- **📖 Documentation**: [Browse comprehensive guides](docs/)

### Community Guidelines
- **🤝 Be Respectful**: Treat all contributors with kindness and respect
- **🌟 Be Inclusive**: Consider neurodivergent users in all design decisions
- **💡 Be Constructive**: Provide helpful feedback and actionable suggestions
- **🎯 Be Patient**: Remember we're all learning and growing together

### Educational Resources
- [Understanding Neurodivergence](docs/neurodivergence.md) - Research-backed insights
- [Inclusive Design Principles](docs/accessibility/guidelines.md) - Best practices for accessibility
- [Emotion Recognition Ethics](docs/ethics.md) - Ethical considerations and privacy

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Google ML Kit team for emotion detection capabilities
- Mistral AI for advanced language modeling
- Flutter team for the amazing cross-platform framework
- Neurodivergent community for guidance and feedback

---

**Made with ❤️ for inclusive education**

*NeuroLearn AI - Empowering every learner to reach their full potential* 