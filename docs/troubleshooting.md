# Troubleshooting Guide 🔧

## Overview

This guide covers common issues, debugging strategies, and solutions for NeuroLearn AI. Whether you're experiencing development, deployment, or runtime issues, this documentation will help you resolve problems quickly.

## Table of Contents

1. [Common Development Issues](#common-development-issues)
2. [Emotion Engine Problems](#emotion-engine-problems)
3. [Story Generation Issues](#story-generation-issues)
4. [Backend API Problems](#backend-api-problems)
5. [Database Issues](#database-issues)
6. [Performance Problems](#performance-problems)
7. [Deployment Issues](#deployment-issues)
8. [Browser Compatibility](#browser-compatibility)
9. [Logging & Debugging](#logging--debugging)
10. [Support Resources](#support-resources)

## Common Development Issues

### Flutter Build Failures

#### Issue: `flutter pub get` fails
```bash
Error: pub get failed (66) -- attempting retry 1 in 1 second
```

**Solution:**
```bash
# Clear Flutter cache
flutter clean
flutter pub cache clean

# Delete pubspec.lock and regenerate
rm pubspec.lock
flutter pub get

# If using VSCode, restart the Dart Language Server
# Ctrl+Shift+P -> "Dart: Restart Language Server"
```

#### Issue: Web build fails with "Failed to compile"
```
Target web_entrypoint failed: Exception: Failed to compile
```

**Solution:**
```bash
# Enable web support if not already enabled
flutter config --enable-web

# Clean and rebuild
flutter clean
flutter build web --release

# Check for conflicting dependencies
flutter doctor -v
```

#### Issue: Hot reload not working
**Solution:**
```bash
# Restart with clean state
flutter clean
flutter run -d web-server --web-port=8087

# If using VSCode, try:
# 1. Restart Dart Language Server
# 2. Reload Window (Ctrl+Shift+P -> "Developer: Reload Window")
```

### Dependency Conflicts

#### Issue: Version conflicts in pubspec.yaml
```
The current Dart SDK version is 3.1.0.
Because package requires SDK version >=3.2.0 <4.0.0
```

**Solution:**
```yaml
# In pubspec.yaml, update SDK constraints
environment:
  sdk: '>=3.1.0 <4.0.0'
  flutter: ">=3.13.0"

# Update specific packages
dependencies:
  google_ml_kit: ^0.16.0  # Use compatible version
  camera: ^0.10.5
```

### Import Resolution Issues

#### Issue: "Target of URI doesn't exist" errors
```dart
import 'package:neurolearn_ai/features/emotion_engine/emotion_engine_page.dart';
// Error: Target of URI doesn't exist
```

**Solution:**
```dart
// Check file path and ensure it exists
// Correct import:
import '../features/emotion_engine/presentation/pages/emotion_engine_page.dart';

// Or use relative imports:
import '../../emotion_engine/emotion_engine_page.dart';
```

## Emotion Engine Problems

### Camera Access Issues

#### Issue: Camera permission denied
```
Camera permission denied. Please enable camera access in browser settings.
```

**Solution:**
```dart
// Check permissions implementation
Future<bool> _requestCameraPermission() async {
  final status = await Permission.camera.request();
  
  if (status == PermissionStatus.denied) {
    // Show user-friendly message
    _showPermissionDialog();
    return false;
  }
  
  if (status == PermissionStatus.permanentlyDenied) {
    // Direct user to app settings
    await openAppSettings();
    return false;
  }
  
  return status == PermissionStatus.granted;
}
```

**Browser-specific solutions:**
- **Chrome**: Settings → Privacy and Security → Site Settings → Camera
- **Firefox**: Address bar → Lock icon → Permissions
- **Safari**: Safari → Settings → Websites → Camera

#### Issue: Camera not detecting faces
```
Face detection returning empty results consistently
```

**Debugging steps:**
```dart
class EmotionDebugger {
  static Future<void> debugFaceDetection(CameraImage image) async {
    final inputImage = InputImage.fromCameraImage(image);
    
    // Log image properties
    print('Image format: ${image.format}');
    print('Image dimensions: ${image.width}x${image.height}');
    print('Image rotation: ${inputImage.metadata?.rotation}');
    
    // Test with different detector options
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
      minFaceSize: 0.1, // Reduce minimum face size
    );
    
    final faceDetector = GoogleMlKit.vision.faceDetector(options);
    final faces = await faceDetector.processImage(inputImage);
    
    print('Detected faces: ${faces.length}');
    for (int i = 0; i < faces.length; i++) {
      print('Face $i confidence: ${faces[i].smilingProbability}');
    }
  }
}
```

### ML Kit Integration Issues

#### Issue: ML Kit models not loading
```
PlatformException(Error, Failed to load ML Kit model, null, null)
```

**Solution:**
```dart
// Ensure proper ML Kit initialization
class MLKitInitializer {
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Pre-load models
      final faceDetector = GoogleMlKit.vision.faceDetector(
        FaceDetectorOptions(
          enableClassification: true,
          enableLandmarks: true,
        ),
      );
      
      // Test with dummy image to trigger model download
      final testImage = InputImage.fromFilePath('assets/test_face.jpg');
      await faceDetector.processImage(testImage);
      
      _initialized = true;
      print('ML Kit initialized successfully');
    } catch (e) {
      print('ML Kit initialization failed: $e');
      throw e;
    }
  }
}
```

#### Issue: Emotion classification accuracy is poor
**Debugging approach:**
```dart
class EmotionCalibration {
  static void debugEmotionClassification(Face face) {
    print('=== Face Analysis ===');
    print('Smiling probability: ${face.smilingProbability}');
    print('Left eye open: ${face.leftEyeOpenProbability}');
    print('Right eye open: ${face.rightEyeOpenProbability}');
    
    // Check face landmarks
    final landmarks = face.landmarks;
    print('Available landmarks: ${landmarks.keys.toList()}');
    
    // Validate face quality
    final boundingBox = face.boundingBox;
    final faceArea = boundingBox.width * boundingBox.height;
    print('Face size: ${boundingBox.width}x${boundingBox.height} (area: $faceArea)');
    
    if (faceArea < 10000) {
      print('WARNING: Face too small for reliable detection');
    }
  }
}
```

## Story Generation Issues

### Mistral API Problems

#### Issue: API calls failing with authentication errors
```
HTTP 401: Unauthorized - Invalid API key
```

**Solution:**
```dart
// Verify API key configuration
class MistralApiClient {
  final String _apiKey;
  
  MistralApiClient(this._apiKey) {
    if (_apiKey.isEmpty || !_apiKey.startsWith('mis-')) {
      throw Exception('Invalid Mistral API key format');
    }
  }
  
  Future<String> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.mistral.ai/v1/models'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return 'Connection successful';
      } else {
        throw Exception('API test failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection test failed: $e');
    }
  }
}
```

#### Issue: Story generation taking too long
```
Story generation timeout after 30 seconds
```

**Solution:**
```dart
class StoryGenerationOptimizer {
  static const Duration _timeout = Duration(seconds: 45);
  
  static Future<String> generateWithTimeout({
    required String prompt,
    required MistralApiClient client,
  }) async {
    return await Future.any([
      _generateStory(prompt, client),
      _timeoutFallback(),
    ]);
  }
  
  static Future<String> _generateStory(String prompt, MistralApiClient client) async {
    // Optimize prompt for faster generation
    final optimizedPrompt = _optimizePrompt(prompt);
    return await client.generateStory(
      prompt: optimizedPrompt,
      maxTokens: 800, // Reduce for faster generation
      temperature: 0.7,
    );
  }
  
  static Future<String> _timeoutFallback() async {
    await Future.delayed(_timeout);
    throw TimeoutException('Story generation timed out', _timeout);
  }
  
  static String _optimizePrompt(String original) {
    // Add instructions for concise generation
    return '''$original

Please keep the story concise (under 500 words) and focus on the main educational objective.''';
  }
}
```

### Content Filtering Issues

#### Issue: Generated content being blocked
```
Content filtered due to safety concerns
```

**Solution:**
```dart
class ContentValidator {
  static final List<String> _safetyKeywords = [
    'educational', 'learning', 'adventure', 'discovery',
    'friendship', 'kindness', 'helping', 'exploring'
  ];
  
  static bool validateContent(String content) {
    // Check for inappropriate content
    final inappropriatePatterns = [
      RegExp(r'\b(violence|scary|frightening)\b', caseSensitive: false),
      RegExp(r'\b(death|dying|killed)\b', caseSensitive: false),
    ];
    
    for (final pattern in inappropriatePatterns) {
      if (pattern.hasMatch(content)) {
        return false;
      }
    }
    
    // Ensure educational content
    final hasSafetyKeywords = _safetyKeywords.any(
      (keyword) => content.toLowerCase().contains(keyword)
    );
    
    return hasSafetyKeywords;
  }
  
  static String sanitizeContent(String content) {
    // Replace problematic words with child-friendly alternatives
    final replacements = {
      RegExp(r'\bscary\b', caseSensitive: false): 'surprising',
      RegExp(r'\bfrightening\b', caseSensitive: false): 'exciting',
      RegExp(r'\bdangerous\b', caseSensitive: false): 'challenging',
    };
    
    String sanitized = content;
    replacements.forEach((pattern, replacement) {
      sanitized = sanitized.replaceAll(pattern, replacement);
    });
    
    return sanitized;
  }
}
```

## Backend API Problems

### Connection Issues

#### Issue: API requests failing with CORS errors
```
Access to fetch at 'http://localhost:8000/api/v1/stories' from origin 'http://localhost:8087' 
has been blocked by CORS policy
```

**Solution:**
```python
# In FastAPI backend (main.py)
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8087",
        "https://neurolearn-ai.com",
        "https://staging.neurolearn-ai.com"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

#### Issue: Request timeout errors
```
DioError [DioErrorType.connectTimeout]: Connecting timeout[10000ms]
```

**Solution:**
```dart
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 60),
      sendTimeout: Duration(seconds: 30),
    ));
    
    // Add retry interceptor
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: print,
      retries: 3,
      retryDelays: [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ));
  }
}
```

### Authentication Issues

#### Issue: JWT token expiration
```
HTTP 401: Token has expired
```

**Solution:**
```dart
class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  static Future<void> refreshTokenIfNeeded() async {
    final token = await _getStoredToken();
    if (token == null) return;
    
    if (_isTokenExpired(token)) {
      await _refreshToken();
    }
  }
  
  static bool _isTokenExpired(String token) {
    try {
      final payload = _decodeJWT(token);
      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return now >= exp;
    } catch (e) {
      return true; // Assume expired if can't decode
    }
  }
  
  static Future<void> _refreshToken() async {
    final refreshToken = await _getStoredRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    
    // Make refresh request
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    
    await _storeTokens(
      response.data['access_token'],
      response.data['refresh_token'],
    );
  }
}
```

## Database Issues

### Connection Problems

#### Issue: Database connection failures
```
could not connect to server: Connection refused
```

**Debugging steps:**
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Test connection manually
psql -h localhost -p 5432 -U postgres -d neurolearn

# Check network connectivity
telnet localhost 5432

# Verify environment variables
echo $DATABASE_URL
```

**Solution:**
```python
# Add connection retry logic
import asyncpg
import asyncio
from tenacity import retry, stop_after_attempt, wait_exponential

class DatabaseManager:
    @retry(
        stop=stop_after_attempt(5),
        wait=wait_exponential(multiplier=1, min=4, max=10)
    )
    async def connect(self):
        try:
            self.pool = await asyncpg.create_pool(
                self.database_url,
                min_size=5,
                max_size=20,
                command_timeout=60,
                server_settings={
                    'application_name': 'neurolearn_api',
                }
            )
            print("Database connected successfully")
        except Exception as e:
            print(f"Database connection failed: {e}")
            raise
    
    async def health_check(self):
        try:
            async with self.pool.acquire() as conn:
                result = await conn.fetchval("SELECT 1")
                return result == 1
        except Exception as e:
            print(f"Database health check failed: {e}")
            return False
```

### Performance Issues

#### Issue: Slow query performance
```sql
-- Identify slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
```

**Solution:**
```sql
-- Add indexes for common queries
CREATE INDEX CONCURRENTLY idx_emotion_states_student_created 
ON emotion_states(student_id, created_at DESC);

CREATE INDEX CONCURRENTLY idx_story_sessions_student 
ON story_sessions(student_id) 
WHERE completed_at IS NOT NULL;

-- Update table statistics
ANALYZE emotion_states;
ANALYZE story_sessions;
```

## Performance Problems

### Memory Issues

#### Issue: Flutter web app consuming too much memory
**Debugging:**
```dart
class MemoryProfiler {
  static void logMemoryUsage() {
    // Monitor widget rebuilds
    print('Active widgets: ${WidgetsBinding.instance.debugPrintGlobalKeyRegistry}');
    
    // Check for memory leaks in streams
    print('Active stream subscriptions: ${_activeSubscriptions.length}');
  }
  
  static void optimizeMemoryUsage() {
    // Dispose unused resources
    _disposeUnusedControllers();
    
    // Clear image cache periodically
    PaintingBinding.instance.imageCache.clear();
    
    // Limit emotion history size
    if (_emotionHistory.length > 100) {
      _emotionHistory.removeRange(0, _emotionHistory.length - 100);
    }
  }
}
```

#### Issue: High CPU usage during emotion detection
**Solution:**
```dart
class PerformanceOptimizer {
  static Timer? _detectionTimer;
  static bool _isProcessing = false;
  
  static void startOptimizedDetection() {
    // Reduce detection frequency under high load
    const baseInterval = Duration(milliseconds: 2000);
    const maxInterval = Duration(milliseconds: 5000);
    
    _detectionTimer = Timer.periodic(baseInterval, (timer) async {
      if (_isProcessing) return; // Skip if still processing
      
      final cpuUsage = await _getCPUUsage();
      if (cpuUsage > 80) {
        // Reduce frequency under high load
        timer.cancel();
        Timer(maxInterval, () => startOptimizedDetection());
        return;
      }
      
      _isProcessing = true;
      try {
        await _processEmotionFrame();
      } finally {
        _isProcessing = false;
      }
    });
  }
}
```

## Deployment Issues

### Kubernetes Problems

#### Issue: Pods not starting
```bash
# Debug pod issues
kubectl describe pod <pod-name> -n neurolearn-prod
kubectl logs <pod-name> -n neurolearn-prod --previous

# Common issues and solutions:
```

**ImagePullBackOff:**
```yaml
# Check image registry access
apiVersion: v1
kind: Secret
metadata:
  name: registry-secret
  namespace: neurolearn-prod
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <base64-encoded-docker-config>
```

**CrashLoopBackOff:**
```yaml
# Add health checks and resource limits
spec:
  containers:
  - name: backend
    image: neurolearn-backend:latest
    resources:
      requests:
        memory: "512Mi"
        cpu: "250m"
      limits:
        memory: "1Gi"
        cpu: "500m"
    livenessProbe:
      httpGet:
        path: /health
        port: 8000
      initialDelaySeconds: 60
      periodSeconds: 30
    readinessProbe:
      httpGet:
        path: /ready
        port: 8000
      initialDelaySeconds: 10
      periodSeconds: 5
```

### Docker Issues

#### Issue: Build failures in Docker
```dockerfile
# Multi-stage build optimization
FROM node:18-alpine AS flutter-deps
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

FROM flutter-deps AS builder
COPY . .
RUN flutter build web --release --dart-define=API_URL=https://api.neurolearn-ai.com

FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
```

## Browser Compatibility

### Chrome Issues
- **Camera not working**: Enable camera permissions in site settings
- **WebGL errors**: Update graphics drivers
- **Memory leaks**: Clear browser cache and disable extensions

### Firefox Issues
- **WebRTC limitations**: Check `about:config` for media.navigator settings
- **Performance**: Disable hardware acceleration if needed

### Safari Issues
- **WebKit restrictions**: Some ML Kit features limited
- **Autoplay policies**: User interaction required for camera access

## Logging & Debugging

### Frontend Debugging

```dart
class DebugLogger {
  static const bool _enableLogging = true; // Set to false in production
  
  static void log(String message, [String? tag]) {
    if (!_enableLogging) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = tag != null 
        ? '[$timestamp] [$tag] $message'
        : '[$timestamp] $message';
    
    print(logMessage);
    
    // Send to remote logging in production
    if (kReleaseMode) {
      _sendToRemoteLogging(logMessage);
    }
  }
  
  static void logError(dynamic error, StackTrace? stackTrace, [String? tag]) {
    final errorMessage = 'ERROR: $error';
    log(errorMessage, tag);
    
    if (stackTrace != null) {
      log('Stack trace: $stackTrace', tag);
    }
    
    // Report to crash analytics
    _reportCrash(error, stackTrace);
  }
}
```

### Backend Logging

```python
import logging
import structlog
from pythonjsonlogger import jsonlogger

# Configure structured logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

# Usage
logger.info("Story generated", student_id="123", story_id="456", duration=2.5)
logger.error("Database connection failed", error=str(e), retry_count=3)
```

## Support Resources

### Debug Information Collection

```bash
#!/bin/bash
# scripts/collect-debug-info.sh

echo "🔍 Collecting debug information..."

# System information
echo "=== System Information ===" > debug-info.txt
uname -a >> debug-info.txt
echo "" >> debug-info.txt

# Flutter information
echo "=== Flutter Doctor ===" >> debug-info.txt
flutter doctor -v >> debug-info.txt
echo "" >> debug-info.txt

# Docker information
echo "=== Docker Status ===" >> debug-info.txt
docker ps >> debug-info.txt
docker images | grep neurolearn >> debug-info.txt
echo "" >> debug-info.txt

# Kubernetes information (if applicable)
if command -v kubectl &> /dev/null; then
    echo "=== Kubernetes Status ===" >> debug-info.txt
    kubectl get pods -n neurolearn-prod >> debug-info.txt
    kubectl top pods -n neurolearn-prod >> debug-info.txt
    echo "" >> debug-info.txt
fi

# Recent logs
echo "=== Recent Logs ===" >> debug-info.txt
tail -n 100 /var/log/neurolearn/app.log >> debug-info.txt 2>/dev/null || echo "No app logs found" >> debug-info.txt

echo "Debug information collected in debug-info.txt"
```

### Getting Help

1. **GitHub Issues**: [Report bugs and feature requests](https://github.com/your-org/neurolearn-ai/issues)
2. **Discord Community**: [Join our developer community](https://discord.gg/neurolearn-ai)
3. **Email Support**: technical-support@neurolearn-ai.com
4. **Documentation**: [Browse our docs](https://docs.neurolearn-ai.com)

### Issue Template

When reporting issues, please include:

```markdown
## Issue Description
[Brief description of the problem]

## Environment
- Platform: [Web/iOS/Android]
- Flutter version: [output of `flutter --version`]
- Browser: [Chrome/Firefox/Safari + version]
- Operating System: [Windows/macOS/Linux]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]

## Expected Behavior
[What you expected to happen]

## Actual Behavior
[What actually happened]

## Logs/Screenshots
[Paste relevant logs or attach screenshots]

## Additional Context
[Any other relevant information]
```

---

*This troubleshooting guide is continuously updated based on community feedback and new issues. Last updated: January 15, 2024* 