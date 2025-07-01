import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'core/services/voice_service.dart';
import 'core/services/ai_service.dart';
import 'shared/themes/app_theme.dart';
import 'shared/providers/app_providers.dart';
import 'features/story_tutor/presentation/pages/home_page.dart';
import 'features/story_tutor/presentation/pages/mistral_story_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize core services
  await VoiceService.initialize();
  await AIService.initialize();
  
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

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroLearn AI'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.blue[700], size: 32),
                        const SizedBox(width: 12),
                        const Text(
                          'AI-Powered Story Generation',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Generate personalized educational stories using Mistral 7B AI model. Stories are tailored for neurodivergent learners with ADHD, dyslexia, and other learning differences.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MistralStoryDemo(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Try Mistral 7B Story Generator'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.green[700], size: 32),
                        const SizedBox(width: 12),
                        const Text(
                          'Progress Analytics',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'AI-powered progress summaries and learning insights. Track IEP goals and generate comprehensive reports for parents and educators.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement progress analytics demo
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Progress Analytics coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.trending_up),
                        label: const Text('View Progress Analytics'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Backend Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Make sure the Mistral 7B backend is running:\n'
                      '• cd backend\n'
                      '• source venv/bin/activate\n'
                      '• uvicorn main:app --reload --host 127.0.0.1 --port 8002',
                      style: TextStyle(fontSize: 14, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 