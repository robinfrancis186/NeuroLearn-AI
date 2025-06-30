import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../data/models/geography_models.dart';

/// Hand tracking service for AR gesture recognition
class HandTrackingService extends ChangeNotifier {
  // Hand tracking state
  bool _isTracking = false;
  HandGesture? _currentGesture;
  
  // Hand position data
  Offset? _leftHandPosition;
  Offset? _rightHandPosition;
  double _gestureConfidence = 0.0;
  
  // Gesture recognition parameters
  static const double _pinchThreshold = 30.0;    // pixels
  static const double _rotationSensitivity = 0.5; // degrees per pixel
  static const double _minConfidence = 0.7;      // minimum gesture confidence
  
  // Gesture timing
  DateTime? _gestureStartTime;
  static const Duration _gestureTimeout = Duration(milliseconds: 500);
  static const Duration _holdDuration = Duration(milliseconds: 200);
  
  // Camera control callbacks
  VoidCallback? _onZoomIn;
  VoidCallback? _onZoomOut;
  ValueChanged<GeoLocation>? _onLocationSelected;
  ValueChanged<double>? _onRotation;
  VoidCallback? _onGestureStart;
  VoidCallback? _onGestureEnd;
  
  // Stream controllers for real-time gesture updates
  final StreamController<HandGesture> _gestureController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _handDataController = StreamController.broadcast();
  
  // Getters
  bool get isTracking => _isTracking;
  HandGesture? get currentGesture => _currentGesture;
  double get gestureConfidence => _gestureConfidence;
  Offset? get leftHandPosition => _leftHandPosition;
  Offset? get rightHandPosition => _rightHandPosition;
  
  // Streams
  Stream<HandGesture> get gestureStream => _gestureController.stream;
  Stream<Map<String, dynamic>> get handDataStream => _handDataController.stream;

  /// Initialize hand tracking with camera control callbacks
  void initialize({
    VoidCallback? onZoomIn,
    VoidCallback? onZoomOut,
    ValueChanged<GeoLocation>? onLocationSelected,
    ValueChanged<double>? onRotation,
    VoidCallback? onGestureStart,
    VoidCallback? onGestureEnd,
  }) {
    _onZoomIn = onZoomIn;
    _onZoomOut = onZoomOut;
    _onLocationSelected = onLocationSelected;
    _onRotation = onRotation;
    _onGestureStart = onGestureStart;
    _onGestureEnd = onGestureEnd;
  }

  /// Start hand tracking
  Future<void> startTracking() async {
    if (_isTracking) return;
    
    try {
      _isTracking = true;
      _gestureStartTime = DateTime.now();
      _onGestureStart?.call();
      
      // Start gesture recognition loop
      _startGestureRecognition();
      
      notifyListeners();
      
      if (kDebugMode) {
        print('Hand tracking started successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error starting hand tracking: $e');
      }
      _isTracking = false;
      rethrow;
    }
  }

  /// Stop hand tracking
  Future<void> stopTracking() async {
    if (!_isTracking) return;
    
    _isTracking = false;
    _currentGesture = null;
    _leftHandPosition = null;
    _rightHandPosition = null;
    _gestureConfidence = 0.0;
    _gestureStartTime = null;
    
    _onGestureEnd?.call();
    notifyListeners();
    
    if (kDebugMode) {
      print('Hand tracking stopped');
    }
  }

  /// Process hand tracking data (simulated for demo)
  void processHandData(Map<String, dynamic> handData) {
    if (!_isTracking) return;
    
    try {
      // Extract hand positions
      if (handData.containsKey('leftHand')) {
        final leftData = handData['leftHand'] as Map<String, dynamic>;
        _leftHandPosition = Offset(
          leftData['x']?.toDouble() ?? 0.0,
          leftData['y']?.toDouble() ?? 0.0,
        );
      }
      
      if (handData.containsKey('rightHand')) {
        final rightData = handData['rightHand'] as Map<String, dynamic>;
        _rightHandPosition = Offset(
          rightData['x']?.toDouble() ?? 0.0,
          rightData['y']?.toDouble() ?? 0.0,
        );
      }
      
      // Extract gesture confidence
      _gestureConfidence = handData['confidence']?.toDouble() ?? 0.0;
      
      // Recognize gesture if confidence is high enough
      if (_gestureConfidence >= _minConfidence) {
        final gesture = _recognizeGesture(handData);
        if (gesture != null) {
          _updateGesture(gesture);
        }
      }
      
      // Broadcast hand data
      _handDataController.add({
        'leftHand': _leftHandPosition,
        'rightHand': _rightHandPosition,
        'confidence': _gestureConfidence,
        'gesture': _currentGesture?.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error processing hand data: $e');
      }
    }
  }

  /// Simulate hand tracking data for demo purposes
  void simulateHandTracking() {
    if (!_isTracking) return;
    
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isTracking) {
        timer.cancel();
        return;
      }
      
      // Generate simulated hand data
      final random = math.Random();
      final simulatedData = {
        'leftHand': {
          'x': 100 + random.nextDouble() * 200,
          'y': 100 + random.nextDouble() * 200,
          'fingers': _generateFingerData(),
        },
        'rightHand': {
          'x': 300 + random.nextDouble() * 200,
          'y': 100 + random.nextDouble() * 200,
          'fingers': _generateFingerData(),
        },
        'confidence': 0.8 + random.nextDouble() * 0.2,
        'gesture': _simulateRandomGesture(),
      };
      
      processHandData(simulatedData);
    });
  }

  /// Generate simulated finger position data
  Map<String, dynamic> _generateFingerData() {
    final random = math.Random();
    return {
      'thumb': {'x': random.nextDouble() * 50, 'y': random.nextDouble() * 50},
      'index': {'x': random.nextDouble() * 50, 'y': random.nextDouble() * 50},
      'middle': {'x': random.nextDouble() * 50, 'y': random.nextDouble() * 50},
      'ring': {'x': random.nextDouble() * 50, 'y': random.nextDouble() * 50},
      'pinky': {'x': random.nextDouble() * 50, 'y': random.nextDouble() * 50},
    };
  }

  /// Simulate random gestures for demo
  String _simulateRandomGesture() {
    final gestures = ['pinch', 'point', 'palm', 'fist', 'swipe'];
    final random = math.Random();
    return gestures[random.nextInt(gestures.length)];
  }

  /// Start gesture recognition loop
  void _startGestureRecognition() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isTracking) {
        timer.cancel();
        return;
      }
      
      _checkGestureTimeout();
      _processCurrentGesture();
    });
  }

  /// Recognize gesture from hand data
  HandGesture? _recognizeGesture(Map<String, dynamic> handData) {
    try {
      // Check for pinch gesture (zoom)
      if (_isPinchGesture(handData)) {
        final distance = _calculatePinchDistance(handData);
        return distance < _pinchThreshold ? HandGesture.pinchZoomIn : HandGesture.pinchZoomOut;
      }
      
      // Check for point gesture (selection)
      if (_isPointGesture(handData)) {
        return HandGesture.pointSelect;
      }
      
      // Check for palm open (navigation)
      if (_isPalmOpenGesture(handData)) {
        return HandGesture.palmOpen;
      }
      
      // Check for fist (stop interaction)
      if (_isFistGesture(handData)) {
        return HandGesture.fist;
      }
      
      // Check for swipe gestures (rotation)
      final swipeDirection = _detectSwipe(handData);
      if (swipeDirection != null) {
        return swipeDirection;
      }
      
      // Check for grab gesture (dragging)
      if (_isGrabGesture(handData)) {
        return HandGesture.grab;
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error recognizing gesture: $e');
      }
      return null;
    }
  }

  /// Check if current gesture is a pinch
  bool _isPinchGesture(Map<String, dynamic> handData) {
    // Simplified pinch detection based on hand positions
    if (_leftHandPosition != null && _rightHandPosition != null) {
      final distance = (_leftHandPosition! - _rightHandPosition!).distance;
      return distance < 150; // pixels
    }
    
    // Check for single-hand pinch using finger data
    if (handData.containsKey('gesture') && handData['gesture'] == 'pinch') {
      return true;
    }
    
    return false;
  }

  /// Calculate pinch distance for zoom level
  double _calculatePinchDistance(Map<String, dynamic> handData) {
    if (_leftHandPosition != null && _rightHandPosition != null) {
      return (_leftHandPosition! - _rightHandPosition!).distance;
    }
    return 100.0; // default distance
  }

  /// Check if current gesture is pointing
  bool _isPointGesture(Map<String, dynamic> handData) {
    return handData.containsKey('gesture') && handData['gesture'] == 'point';
  }

  /// Check if palm is open
  bool _isPalmOpenGesture(Map<String, dynamic> handData) {
    return handData.containsKey('gesture') && handData['gesture'] == 'palm';
  }

  /// Check if hand is in fist position
  bool _isFistGesture(Map<String, dynamic> handData) {
    return handData.containsKey('gesture') && handData['gesture'] == 'fist';
  }

  /// Detect swipe direction for rotation
  HandGesture? _detectSwipe(Map<String, dynamic> handData) {
    if (handData.containsKey('gesture') && handData['gesture'] == 'swipe') {
      // Simplified swipe detection - in real implementation would analyze movement
      final random = math.Random();
      return random.nextBool() ? HandGesture.swipeLeft : HandGesture.swipeRight;
    }
    return null;
  }

  /// Check if current gesture is grab
  bool _isGrabGesture(Map<String, dynamic> handData) {
    return handData.containsKey('gesture') && handData['gesture'] == 'grab';
  }

  /// Update current gesture and trigger callbacks
  void _updateGesture(HandGesture gesture) {
    if (_currentGesture == gesture) return;
    
    _currentGesture = gesture;
    _gestureStartTime = DateTime.now();
    
    // Trigger appropriate callback based on gesture
    _handleGestureAction(gesture);
    
    // Broadcast gesture update
    _gestureController.add(gesture);
    
    if (kDebugMode) {
      print('Gesture updated: $gesture (confidence: ${_gestureConfidence.toStringAsFixed(2)})');
    }
  }

  /// Handle gesture action by triggering appropriate callback
  void _handleGestureAction(HandGesture gesture) {
    switch (gesture) {
      case HandGesture.pinchZoomIn:
        _onZoomIn?.call();
        break;
      case HandGesture.pinchZoomOut:
        _onZoomOut?.call();
        break;
      case HandGesture.pointSelect:
        _handlePointSelection();
        break;
      case HandGesture.swipeLeft:
        _onRotation?.call(-_rotationSensitivity);
        break;
      case HandGesture.swipeRight:
        _onRotation?.call(_rotationSensitivity);
        break;
      case HandGesture.palmOpen:
      case HandGesture.fist:
      case HandGesture.grab:
        // These gestures might be handled by the AR view directly
        break;
    }
  }

  /// Handle point selection gesture
  void _handlePointSelection() {
    if (_rightHandPosition != null) {
      // Convert screen position to geographic coordinates (simplified)
      final geoLocation = _screenToGeoLocation(_rightHandPosition!);
      _onLocationSelected?.call(geoLocation);
    }
  }

  /// Convert screen coordinates to geographic location (simplified)
  GeoLocation _screenToGeoLocation(Offset screenPosition) {
    // This is a simplified conversion - in real implementation would use
    // the current camera view and projection matrix
    final normalizedX = (screenPosition.dx - 400) / 400; // Assuming 800px width
    final normalizedY = (screenPosition.dy - 300) / 300; // Assuming 600px height
    
    final longitude = normalizedX * 180; // -180 to 180
    final latitude = normalizedY * -90;  // -90 to 90 (inverted Y)
    
    return GeoLocation(
      latitude: latitude.clamp(-90, 90),
      longitude: longitude.clamp(-180, 180),
    );
  }

  /// Check for gesture timeout
  void _checkGestureTimeout() {
    if (_gestureStartTime != null) {
      final elapsed = DateTime.now().difference(_gestureStartTime!);
      if (elapsed > _gestureTimeout) {
        _currentGesture = null;
        _gestureStartTime = null;
        notifyListeners();
      }
    }
  }

  /// Process current gesture continuously
  void _processCurrentGesture() {
    if (_currentGesture == null) return;
    
    final elapsed = _gestureStartTime != null 
        ? DateTime.now().difference(_gestureStartTime!)
        : Duration.zero;
    
    // Handle continuous gestures (like zoom or rotation)
    if (elapsed > _holdDuration) {
      switch (_currentGesture!) {
        case HandGesture.pinchZoomIn:
        case HandGesture.pinchZoomOut:
          // Continue zoom gesture
          _handleGestureAction(_currentGesture!);
          break;
        case HandGesture.grab:
          // Handle continuous dragging
          break;
        default:
          // Single-action gestures don't need continuous processing
          break;
      }
    }
  }

  /// Get gesture description for UI display
  String getGestureDescription(HandGesture gesture) {
    switch (gesture) {
      case HandGesture.pinchZoomIn:
        return 'Pinch to zoom in on the map';
      case HandGesture.pinchZoomOut:
        return 'Spread fingers to zoom out';
      case HandGesture.pointSelect:
        return 'Point to select a location';
      case HandGesture.palmOpen:
        return 'Open palm for navigation mode';
      case HandGesture.fist:
        return 'Close fist to stop interaction';
      case HandGesture.swipeLeft:
        return 'Swipe left to rotate map';
      case HandGesture.swipeRight:
        return 'Swipe right to rotate map';
      case HandGesture.grab:
        return 'Grab to drag the map';
    }
  }

  /// Get gesture status for debugging
  Map<String, dynamic> getGestureStatus() {
    return {
      'isTracking': _isTracking,
      'currentGesture': _currentGesture?.toString(),
      'confidence': _gestureConfidence,
      'leftHandPosition': _leftHandPosition?.toString(),
      'rightHandPosition': _rightHandPosition?.toString(),
      'gestureStartTime': _gestureStartTime?.millisecondsSinceEpoch,
    };
  }

  /// Cleanup resources
  @override
  void dispose() {
    stopTracking();
    _gestureController.close();
    _handDataController.close();
    super.dispose();
  }

  /// Toggle tracking for debug/demo purposes
  void toggleTracking() {
    if (_isTracking) {
      stopTracking();
    } else {
      startTracking();
      // Start simulation for demo
      simulateHandTracking();
    }
  }

  /// Reset gesture state
  void resetGesture() {
    _currentGesture = null;
    _gestureStartTime = null;
    _gestureConfidence = 0.0;
    notifyListeners();
  }

  /// Calibrate gesture sensitivity
  void calibrateGestures({
    double? pinchThreshold,
    double? zoomSensitivity,
    double? rotationSensitivity,
    double? minConfidence,
  }) {
    // In a real implementation, these would update static constants
    // For now, we'll store them as instance variables if needed
    if (kDebugMode) {
      print('Gesture calibration updated');
    }
  }
} 