import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student_profile.dart';

class VoiceService {
  static VoiceService? _instance;
  static VoiceService get instance => _instance!;
  
  late FlutterTts _tts;
  late SpeechToText _stt;
  late AudioPlayer _audioPlayer;
  late AudioRecorder _recorder;
  late Dio _dio;
  
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isListening = false;
  
  // Voice cloning service configuration
  String? _clonedVoiceEndpoint;
  String? _currentVoiceProfile;
  
  static Future<void> initialize() async {
    _instance = VoiceService._();
    await _instance!._init();
  }
  
  VoiceService._();
  
  Future<void> _init() async {
    try {
      _tts = FlutterTts();
      _stt = SpeechToText();
      _audioPlayer = AudioPlayer();
      _recorder = AudioRecorder();
      _dio = Dio();
      
      await _initializeTTS();
      await _initializeSTT();
      
      _isInitialized = true;
    } catch (e) {
      throw VoiceServiceException('Failed to initialize voice service: $e');
    }
  }
  
  Future<void> _initializeTTS() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(0.8);
    await _tts.setPitch(1.0);
    
    // Set up TTS event handlers
    _tts.setStartHandler(() {
      _isSpeaking = true;
    });
    
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });
    
    _tts.setErrorHandler((message) {
      _isSpeaking = false;
      print('TTS Error: $message');
    });
  }
  
  Future<void> _initializeSTT() async {
    bool available = await _stt.initialize(
      onStatus: (status) {
        _isListening = status == 'listening';
      },
      onError: (error) {
        _isListening = false;
        print('STT Error: $error');
      },
    );
    
    if (!available) {
      throw VoiceServiceException('Speech recognition not available');
    }
  }
  
  /// Speaks text using either system TTS or cloned voice
  Future<void> speak({
    required String text,
    String? voiceProfileId,
    VoiceSettings? settings,
  }) async {
    if (!_isInitialized) throw VoiceServiceException('Service not initialized');
    
    try {
      // Stop current speech if playing
      await stop();
      
      if (voiceProfileId != null && _clonedVoiceEndpoint != null) {
        // Use cloned voice
        await _speakWithClonedVoice(text, voiceProfileId, settings);
      } else {
        // Use system TTS
        await _speakWithSystemTTS(text, settings);
      }
    } catch (e) {
      throw VoiceServiceException('Failed to speak: $e');
    }
  }
  
  Future<void> _speakWithSystemTTS(String text, VoiceSettings? settings) async {
    if (settings != null) {
      await _tts.setSpeechRate(settings.speechRate);
      await _tts.setPitch(settings.pitch);
      await _tts.setVolume(settings.volume);
    }
    
    await _tts.speak(text);
  }
  
  Future<void> _speakWithClonedVoice(
    String text,
    String voiceProfileId,
    VoiceSettings? settings,
  ) async {
    try {
      final response = await _dio.post(
        '$_clonedVoiceEndpoint/synthesize',
        data: {
          'text': text,
          'voice_id': voiceProfileId,
          'settings': settings?.toJson(),
        },
      );
      
      if (response.statusCode == 200) {
        final audioData = response.data as Uint8List;
        final tempDir = await getTemporaryDirectory();
        final audioFile = File('${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.wav');
        
        await audioFile.writeAsBytes(audioData);
        await _audioPlayer.play(DeviceFileSource(audioFile.path));
        
        // Clean up temp file after playing
        _audioPlayer.onPlayerComplete.listen((_) {
          audioFile.deleteSync();
        });
      }
    } catch (e) {
      // Fallback to system TTS
      await _speakWithSystemTTS(text, settings);
    }
  }
  
  /// Starts speech recognition
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    VoidCallback? onComplete,
    Function(String)? onError,
  }) async {
    if (!_isInitialized) throw VoiceServiceException('Service not initialized');
    
    try {
      bool available = await _stt.initialize();
      if (!available) {
        onError?.call('Speech recognition not available');
        return;
      }
      
      await _stt.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            onComplete?.call();
          } else {
            onPartialResult?.call(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    } catch (e) {
      onError?.call('Failed to start listening: $e');
    }
  }
  
  /// Stops speech recognition
  Future<void> stopListening() async {
    if (_isListening) {
      await _stt.stop();
    }
  }
  
  /// Stops current speech output
  Future<void> stop() async {
    if (_isSpeaking) {
      await _tts.stop();
      await _audioPlayer.stop();
    }
  }
  
  /// Records audio for voice cloning
  Future<String?> recordVoiceSample({
    required Duration maxDuration,
    required Function(String) onResult,
    Function(String)? onError,
  }) async {
    try {
      if (await _recorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final recordingPath = '${tempDir.path}/voice_sample_${DateTime.now().millisecondsSinceEpoch}.wav';
        
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 44100,
            bitRate: 128000,
          ),
          path: recordingPath,
        );
        
        // Auto-stop after max duration
        Future.delayed(maxDuration, () async {
          if (await _recorder.isRecording()) {
            await _recorder.stop();
          }
        });
        
        return recordingPath;
      } else {
        onError?.call('Recording permission not granted');
        return null;
      }
    } catch (e) {
      onError?.call('Failed to record: $e');
      return null;
    }
  }
  
  /// Stops current recording
  Future<String?> stopRecording() async {
    try {
      return await _recorder.stop();
    } catch (e) {
      return null;
    }
  }
  
  /// Creates a voice profile for cloning
  Future<String?> createVoiceProfile({
    required String name,
    required List<String> audioSamplePaths,
    required String description,
  }) async {
    try {
      if (_clonedVoiceEndpoint == null) {
        throw VoiceServiceException('Voice cloning service not configured');
      }
      
      final formData = FormData();
      formData.fields.add(MapEntry('name', name));
      formData.fields.add(MapEntry('description', description));
      
      for (int i = 0; i < audioSamplePaths.length; i++) {
        formData.files.add(MapEntry(
          'samples',
          await MultipartFile.fromFile(
            audioSamplePaths[i],
            filename: 'sample_$i.wav',
          ),
        ));
      }
      
      final response = await _dio.post(
        '$_clonedVoiceEndpoint/voices',
        data: formData,
      );
      
      if (response.statusCode == 201) {
        return response.data['voice_id'];
      }
      
      return null;
    } catch (e) {
      throw VoiceServiceException('Failed to create voice profile: $e');
    }
  }
  
  /// Sets the voice cloning service endpoint
  void configureVoiceCloning({
    required String endpoint,
    String? apiKey,
  }) {
    _clonedVoiceEndpoint = endpoint;
    if (apiKey != null) {
      _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    }
  }
  
  /// Applies voice settings from student profile
  Future<void> applyStudentVoiceSettings(StudentProfile student) async {
    final preferences = student.cognitiveProfile.sensoryPreferences;
    
    await _tts.setVolume(preferences.preferredVolume);
    
    // Adjust speech rate based on communication needs
    if (student.cognitiveProfile.communicationNeeds.prefersShorterSentences) {
      await _tts.setSpeechRate(0.4); // Slower for better comprehension
    } else {
      await _tts.setSpeechRate(0.5); // Normal rate
    }
    
    // Adjust pitch for comfort
    if (preferences.auditorySensitivity) {
      await _tts.setPitch(0.8); // Lower pitch for sensitivity
    } else {
      await _tts.setPitch(1.0); // Normal pitch
    }
  }
  
  /// Gets available system voices
  Future<List<Map<String, String>>> getAvailableVoices() async {
    try {
      final voices = await _tts.getVoices;
      return voices.cast<Map<String, String>>();
    } catch (e) {
      return [];
    }
  }
  
  /// Sets the system voice
  Future<void> setVoice(String voiceId) async {
    try {
      await _tts.setVoice({'name': voiceId, 'locale': 'en-US'});
    } catch (e) {
      print('Failed to set voice: $e');
    }
  }
  
  /// Analyzes audio for emotional content
  Future<Map<String, dynamic>> analyzeAudioEmotion(String audioPath) async {
    try {
      if (_clonedVoiceEndpoint == null) {
        return {'emotion': 'neutral', 'confidence': 0.0};
      }
      
      final formData = FormData();
      formData.files.add(MapEntry(
        'audio',
        await MultipartFile.fromFile(audioPath),
      ));
      
      final response = await _dio.post(
        '$_clonedVoiceEndpoint/analyze/emotion',
        data: formData,
      );
      
      if (response.statusCode == 200) {
        return response.data;
      }
      
      return {'emotion': 'neutral', 'confidence': 0.0};
    } catch (e) {
      return {'emotion': 'neutral', 'confidence': 0.0};
    }
  }
  
  // Getters for state
  bool get isSpeaking => _isSpeaking;
  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String? get currentVoiceProfile => _currentVoiceProfile;
  
  /// Disposes of resources
  Future<void> dispose() async {
    await stop();
    await stopListening();
    await _audioPlayer.dispose();
    await _recorder.dispose();
  }
}

/// Voice settings configuration
class VoiceSettings {
  final double speechRate;
  final double pitch;
  final double volume;
  final bool enableVoiceCloning;
  final String? selectedVoiceId;
  
  const VoiceSettings({
    this.speechRate = 0.5,
    this.pitch = 1.0,
    this.volume = 0.8,
    this.enableVoiceCloning = false,
    this.selectedVoiceId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'speechRate': speechRate,
      'pitch': pitch,
      'volume': volume,
      'enableVoiceCloning': enableVoiceCloning,
      'selectedVoiceId': selectedVoiceId,
    };
  }
  
  factory VoiceSettings.fromJson(Map<String, dynamic> json) {
    return VoiceSettings(
      speechRate: json['speechRate']?.toDouble() ?? 0.5,
      pitch: json['pitch']?.toDouble() ?? 1.0,
      volume: json['volume']?.toDouble() ?? 0.8,
      enableVoiceCloning: json['enableVoiceCloning'] ?? false,
      selectedVoiceId: json['selectedVoiceId'],
    );
  }
  
  VoiceSettings copyWith({
    double? speechRate,
    double? pitch,
    double? volume,
    bool? enableVoiceCloning,
    String? selectedVoiceId,
  }) {
    return VoiceSettings(
      speechRate: speechRate ?? this.speechRate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      enableVoiceCloning: enableVoiceCloning ?? this.enableVoiceCloning,
      selectedVoiceId: selectedVoiceId ?? this.selectedVoiceId,
    );
  }
}

class VoiceServiceException implements Exception {
  final String message;
  VoiceServiceException(this.message);
  
  @override
  String toString() => 'VoiceServiceException: $message';
} 