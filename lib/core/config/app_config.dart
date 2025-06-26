/// NeuroLearn AI Application Configuration
/// Replace these values with your actual API keys
class AppConfig {
  // OpenAI Configuration
  static const String openAiApiKey = 'your_openai_api_key_here'; // Replace with your actual API key
  static const String openAiModel = 'gpt-3.5-turbo';
  static const double openAiTemperature = 0.7;
  static const int openAiMaxTokens = 1000;
  static const String openAiOrganizationId = 'YOUR_ORGANIZATION_ID_HERE';
  
  // Firebase Configuration (these will be replaced by firebase_options.dart)
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY_HERE';
  static const String firebaseAuthDomain = 'your-project-id.firebaseapp.com';
  static const String firebaseProjectId = 'your-project-id';
  static const String firebaseStorageBucket = 'your-project-id.appspot.com';
  static const String firebaseMessagingSenderId = 'YOUR_MESSAGING_SENDER_ID';
  static const String firebaseAppId = 'YOUR_APP_ID_HERE';
  
  // Voice & AI Configuration
  static const String voiceCloningApiKey = 'YOUR_VOICE_CLONING_API_KEY_HERE';
  static const String affectivaApiKey = 'YOUR_AFFECTIVA_API_KEY_HERE';
  
  // Development Settings
  static const bool isDebugMode = true;
  static const String logLevel = 'debug';
  
  // App Settings
  static const String appName = 'NeuroLearn AI';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Learning Without Limits — One Story at a Time';
  
  // Validation Methods
  static bool get isOpenAiConfigured => 
      openAiApiKey != 'YOUR_OPENAI_API_KEY_HERE' && openAiApiKey.isNotEmpty;
      
  static bool get isFirebaseConfigured =>
      firebaseApiKey != 'YOUR_FIREBASE_API_KEY_HERE' && firebaseApiKey.isNotEmpty;
      
  static bool get isVoiceCloningConfigured =>
      voiceCloningApiKey != 'YOUR_VOICE_CLONING_API_KEY_HERE' && voiceCloningApiKey.isNotEmpty;
} 