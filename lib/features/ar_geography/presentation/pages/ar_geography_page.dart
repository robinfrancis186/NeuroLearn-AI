import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/geography_models.dart';
import '../../data/services/geography_data_service.dart';
import '../../services/hand_tracking_service.dart';
import '../widgets/ar_globe_widget.dart';
import '../widgets/gesture_overlay_widget.dart';
import '../widgets/location_info_panel.dart';
import '../widgets/ar_controls_widget.dart';

/// AR Geography Explorer - Main page with 3D globe and hand tracking
class ARGeographyPage extends StatefulWidget {
  const ARGeographyPage({super.key});

  @override
  State<ARGeographyPage> createState() => _ARGeographyPageState();
}

class _ARGeographyPageState extends State<ARGeographyPage>
    with TickerProviderStateMixin {
  // Services
  late HandTrackingService _handTrackingService;
  
  // Current state
  ARCameraState _cameraState = const ARCameraState(
    target: GeoLocation(latitude: 0, longitude: 0),
    distance: 1000,
    zoomLevel: 1.0,
  );
  
  MapDetailLevel _currentDetailLevel = MapDetailLevel.global;
  Country? _selectedCountry;
  GeographicState? _selectedState;
  City? _selectedCity;
  List<Country> _countries = [];
  
  // Animation controllers
  late AnimationController _zoomAnimationController;
  late AnimationController _rotationAnimationController;
  late AnimationController _transitionAnimationController;
  
  // Animations
  late Animation<double> _zoomAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _transitionAnimation;
  
  // UI state
  bool _showLocationInfo = false;
  bool _showControls = true;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Hand tracking state
  bool _handTrackingEnabled = true;
  StreamSubscription<HandGesture>? _gestureSubscription;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimations();
    _loadGeographyData();
  }

  @override
  void dispose() {
    _handTrackingService.dispose();
    _gestureSubscription?.cancel();
    _zoomAnimationController.dispose();
    _rotationAnimationController.dispose();
    _transitionAnimationController.dispose();
    super.dispose();
  }

  /// Initialize services and hand tracking
  void _initializeServices() {
    _handTrackingService = HandTrackingService();
    
    // Initialize hand tracking callbacks
    _handTrackingService.initialize(
      onZoomIn: _handleZoomIn,
      onZoomOut: _handleZoomOut,
      onLocationSelected: _handleLocationSelected,
      onRotation: _handleRotation,
      onGestureStart: _handleGestureStart,
      onGestureEnd: _handleGestureEnd,
    );

    // Listen to gesture updates
    _gestureSubscription = _handTrackingService.gestureStream.listen(
      _handleGestureUpdate,
      onError: (error) {
        debugPrint('Gesture stream error: $error');
      },
    );
  }

  /// Initialize animation controllers
  void _initializeAnimations() {
    _zoomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _rotationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _transitionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _zoomAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _zoomAnimationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(CurvedAnimation(
      parent: _rotationAnimationController,
      curve: Curves.easeInOut,
    ));

    _transitionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _transitionAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  /// Load geography data from service
  Future<void> _loadGeographyData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await GeographyDataService.initialize();
      final countries = await GeographyDataService.getAllCountries();
      
      setState(() {
        _countries = countries;
        _isLoading = false;
      });

      // Start hand tracking after data is loaded
      if (_handTrackingEnabled) {
        await _handTrackingService.startTracking();
        _handTrackingService.simulateHandTracking();
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load geography data: $error';
        _isLoading = false;
      });
    }
  }

  /// Handle zoom in gesture
  void _handleZoomIn() {
    final newZoomLevel = (_cameraState.zoomLevel * 1.2).clamp(0.1, 50.0);
    _updateCameraState(zoomLevel: newZoomLevel);
    _zoomAnimationController.forward().then((_) {
      _zoomAnimationController.reset();
    });
    
    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  /// Handle zoom out gesture
  void _handleZoomOut() {
    final newZoomLevel = (_cameraState.zoomLevel * 0.8).clamp(0.1, 50.0);
    _updateCameraState(zoomLevel: newZoomLevel);
    _zoomAnimationController.forward().then((_) {
      _zoomAnimationController.reset();
    });
    
    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  /// Handle location selection gesture
  void _handleLocationSelected(GeoLocation location) {
    _selectLocationAtCoordinates(location);
    
    // Show location info panel
    setState(() {
      _showLocationInfo = true;
    });
    
    // Provide haptic feedback
    HapticFeedback.mediumImpact();
  }

  /// Handle rotation gesture
  void _handleRotation(double rotationDelta) {
    final newRotation = (_cameraState.rotation + rotationDelta) % 360;
    _updateCameraState(rotation: newRotation);
    
    // Animate rotation
    _rotationAnimationController.forward().then((_) {
      _rotationAnimationController.reset();
    });
  }

  /// Handle gesture start
  void _handleGestureStart() {
    // Visual feedback for gesture start
    setState(() {
      _showControls = false;
    });
  }

  /// Handle gesture end
  void _handleGestureEnd() {
    // Restore UI controls
    setState(() {
      _showControls = true;
    });
  }

  /// Handle gesture updates
  void _handleGestureUpdate(HandGesture gesture) {
    // Update UI based on current gesture
    debugPrint('Gesture detected: $gesture');
  }

  /// Update camera state
  void _updateCameraState({
    GeoLocation? target,
    double? distance,
    double? rotation,
    double? tilt,
    double? zoomLevel,
  }) {
    setState(() {
      _cameraState = _cameraState.copyWith(
        target: target,
        distance: distance,
        rotation: rotation,
        tilt: tilt,
        zoomLevel: zoomLevel,
      );
    });
  }

  /// Select location based on coordinates
  Future<void> _selectLocationAtCoordinates(GeoLocation location) async {
    try {
      // Find the closest country to the selected coordinates
      Country? closestCountry;
      double minDistance = double.infinity;
      
      for (final country in _countries) {
        final distance = GeographyDataService.calculateDistance(
          location,
          country.center,
        );
        
        if (distance < minDistance) {
          minDistance = distance;
          closestCountry = country;
        }
      }
      
      if (closestCountry != null) {
        await _selectCountry(closestCountry);
        
        // Check if we should zoom into state level
        if (minDistance < 500) { // Within 500km
          final states = await GeographyDataService.getStatesForCountry(
            closestCountry.code,
          );
          
          if (states.isNotEmpty) {
            // Find closest state
            GeographicState? closestState;
            double minStateDistance = double.infinity;
            
            for (final state in states) {
              final stateDistance = GeographyDataService.calculateDistance(
                location,
                state.center,
              );
              
              if (stateDistance < minStateDistance) {
                minStateDistance = stateDistance;
                closestState = state;
              }
            }
            
            if (closestState != null && minStateDistance < 100) {
              await _selectState(closestState);
            }
          }
        }
      }
    } catch (error) {
      debugPrint('Error selecting location: $error');
    }
  }

  /// Select a country and zoom to it
  Future<void> _selectCountry(Country country) async {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _selectedCity = null;
      _currentDetailLevel = MapDetailLevel.country;
    });

    // Animate to country view
    _updateCameraState(
      target: country.center,
      zoomLevel: 5.0,
    );

    // Start transition animation
    _transitionAnimationController.forward().then((_) {
      _transitionAnimationController.reset();
    });
  }

  /// Select a state and zoom to it
  Future<void> _selectState(GeographicState state) async {
    setState(() {
      _selectedState = state;
      _selectedCity = null;
      _currentDetailLevel = MapDetailLevel.state;
    });

    // Animate to state view
    _updateCameraState(
      target: state.center,
      zoomLevel: 15.0,
    );

    // Start transition animation
    _transitionAnimationController.forward().then((_) {
      _transitionAnimationController.reset();
    });
  }

  /// Select a city and zoom to it
  Future<void> _selectCity(City city) async {
    setState(() {
      _selectedCity = city;
      _currentDetailLevel = MapDetailLevel.city;
    });

    // Animate to city view
    _updateCameraState(
      target: city.location,
      zoomLevel: 25.0,
    );

    // Start transition animation
    _transitionAnimationController.forward().then((_) {
      _transitionAnimationController.reset();
    });
  }

  /// Reset to global view
  void _resetToGlobalView() {
    setState(() {
      _selectedCountry = null;
      _selectedState = null;
      _selectedCity = null;
      _currentDetailLevel = MapDetailLevel.global;
      _showLocationInfo = false;
    });

    _updateCameraState(
      target: const GeoLocation(latitude: 0, longitude: 0),
      zoomLevel: 1.0,
      rotation: 0.0,
    );
  }

  /// Toggle hand tracking
  void _toggleHandTracking() {
    setState(() {
      _handTrackingEnabled = !_handTrackingEnabled;
    });

    if (_handTrackingEnabled) {
      _handTrackingService.startTracking();
      _handTrackingService.simulateHandTracking();
    } else {
      _handTrackingService.stopTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main AR Globe View
          Positioned.fill(
            child: _buildMainContent(),
          ),
          
          // Gesture Overlay
          if (_handTrackingEnabled)
            Positioned.fill(
              child: GestureOverlayWidget(
                handTrackingService: _handTrackingService,
              ),
            ),
          
          // Top Navigation Bar
          _buildTopNavigationBar(),
          
          // Location Info Panel
          if (_showLocationInfo)
            Positioned(
              right: 16,
              top: 100,
              bottom: 100,
              child: LocationInfoPanel(
                selectedCountry: _selectedCountry,
                selectedState: _selectedState,
                selectedCity: _selectedCity,
                onClose: () => setState(() => _showLocationInfo = false),
                onCountrySelected: _selectCountry,
                onStateSelected: _selectState,
                onCitySelected: _selectCity,
              ),
            ),
          
          // AR Controls
          if (_showControls)
            Positioned(
              left: 16,
              bottom: 16,
              child: ARControlsWidget(
                cameraState: _cameraState,
                currentDetailLevel: _currentDetailLevel,
                handTrackingEnabled: _handTrackingEnabled,
                onZoomIn: _handleZoomIn,
                onZoomOut: _handleZoomOut,
                onResetView: _resetToGlobalView,
                onToggleHandTracking: _toggleHandTracking,
                onToggleInfo: () => setState(() => _showLocationInfo = !_showLocationInfo),
              ),
            ),
          
          // Loading Indicator
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Loading Geography Data...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build the main content area
  Widget _buildMainContent() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGeographyData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _zoomAnimation,
        _rotationAnimation,
        _transitionAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_zoomAnimation.value - 1.0) * 0.1,
          child: Transform.rotate(
            angle: _rotationAnimation.value * math.pi / 180,
            child: SlideTransition(
              position: _transitionAnimation,
              child: ARGlobeWidget(
                cameraState: _cameraState,
                countries: _countries,
                selectedCountry: _selectedCountry,
                selectedState: _selectedState,
                selectedCity: _selectedCity,
                detailLevel: _currentDetailLevel,
                onLocationTapped: _handleLocationSelected,
                onCountrySelected: _selectCountry,
                onStateSelected: _selectState,
                onCitySelected: _selectCity,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build top navigation bar
  Widget _buildTopNavigationBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Expanded(
              child: Text(
                'AR Geography Explorer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () {
                // Show help/tutorial
                _showHelpDialog();
              },
              icon: const Icon(Icons.help_outline, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// Show help dialog with gesture instructions
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hand Gesture Controls'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👌 Pinch: Zoom in/out'),
              SizedBox(height: 8),
              Text('👆 Point: Select location'),
              SizedBox(height: 8),
              Text('✋ Open palm: Navigation mode'),
              SizedBox(height: 8),
              Text('✊ Fist: Stop interaction'),
              SizedBox(height: 8),
              Text('👈👉 Swipe: Rotate map'),
              SizedBox(height: 8),
              Text('✊ Grab: Drag map'),
              SizedBox(height: 16),
              Text(
                'Explore the world by zooming into countries and states. Point at locations to get detailed information.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
} 