import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'core/services/voice_service.dart';
import 'core/services/ai_service.dart';
import 'core/services/voice_upload_service.dart';
import 'shared/themes/app_theme.dart';
import 'shared/providers/app_providers.dart';
import 'features/story_tutor/presentation/pages/home_page.dart';
import 'core/models/emotional_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  // Register Hive adapters for emotional state and related types
  Hive.registerAdapter(EmotionalStateAdapter());
  Hive.registerAdapter(DetectedEmotionAdapter());
  Hive.registerAdapter(EmotionalValenceAdapter());
  Hive.registerAdapter(EmotionDetectionSourceAdapter());
  Hive.registerAdapter(StoryMoodAdapter());
  
  // Initialize core services
  await VoiceService.initialize();
  await AIService.initialize();
  await VoiceUploadService.initialize();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const ProviderScope(child: NeuroLearnApp()));
}

class NeuroLearnApp extends ConsumerWidget {
  const NeuroLearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'NeuroLearn AI',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomePage(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // Consistent text scaling
          ),
          child: child!,
        );
      },
    );
  }
} 