# NeuroLearn AI Setup Guide

## 📋 Prerequisites

- Flutter SDK (✅ Installed)
- Chrome browser for web development (✅ Available)
- OpenAI API account
- Firebase project (optional for local development)

## 🔧 Step-by-Step Setup

### 1. Configure OpenAI API Keys

1. Get your OpenAI API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Open `lib/core/config/app_config.dart`
3. Replace `YOUR_OPENAI_API_KEY_HERE` with your actual API key
4. Optionally add your organization ID

```dart
static const String openAiApiKey = 'your-openai-api-key-here';
static const String openAiOrganizationId = 'org-your-org-id'; // Optional
```

### 2. Firebase Setup (Optional for Demo)

For full functionality, set up Firebase:

1. **Create Firebase Project**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase in project
   firebase init
   ```

2. **Configure Firestore, Auth, and Storage**
   - Enable Firestore Database
   - Enable Authentication (Email/Password)
   - Enable Cloud Storage

3. **Generate Firebase Config**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for Flutter
   flutterfire configure
   ```

### 3. Run the Application

```bash
# Make sure you're in the project directory
cd "/Users/robinfrancis/Desktop/NeuroLearn AI"

# Run on web (Chrome)
flutter run -d chrome

# Or run on any connected device
flutter run
```

## 🌐 Quick Start (Web Demo)

You can start with a web demo immediately:

1. Update the OpenAI API key in `app_config.dart`
2. Run: `flutter run -d chrome`
3. The app will work with local storage for demo purposes

## 🎯 Features Available

### Immediately Available (Local):
- ✅ Story generation with OpenAI
- ✅ Interactive storytelling interface
- ✅ Mood selection and emotional adaptations
- ✅ Local progress tracking
- ✅ Beautiful animations and UI

### Requires Firebase Setup:
- 🔄 Cloud storage for stories
- 🔄 User authentication
- 🔄 Cross-device sync
- 🔄 Analytics and reporting

## 🔧 Configuration Files

### Main Configuration:
- `lib/core/config/app_config.dart` - API keys and app settings

### Firebase (when set up):
- `lib/firebase_options.dart` - Auto-generated Firebase config
- `firebase.json` - Firebase project settings

## 🎨 Optional Enhancements

### Voice Features:
1. Update `voiceCloningApiKey` in config for OpenVoice integration
2. Configure speech-to-text permissions

### Emotion Detection:
1. Add Affectiva API key for advanced emotion detection
2. Enable camera permissions for facial recognition

## 🚀 Development Commands

```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Build for web
flutter build web

# Check for issues
flutter doctor

# Update dependencies
flutter pub upgrade
```

## 📱 Platform Support

- ✅ **Web (Chrome)** - Ready to use
- 🔄 **iOS** - Requires Xcode setup
- 🔄 **Android** - Requires Android Studio setup
- 🔄 **macOS** - Native macOS app support

## 🎯 Quick Demo Steps

1. Open `lib/core/config/app_config.dart`
2. Add your OpenAI API key
3. Run: `flutter run -d chrome`
4. Select a student profile
5. Choose your mood
6. Start your first AI-powered story!

## 📞 Support

If you encounter any issues:
1. Check `flutter doctor` for system requirements
2. Verify API keys are correctly configured
3. Check console logs for specific error messages

Ready to transform neurodivergent learning! 🧠✨ 