import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/geography_models.dart';

/// 3D AR Globe Widget with realistic world map rendering
class ARGlobeWidget extends StatefulWidget {
  final ARCameraState cameraState;
  final List<Country> countries;
  final Country? selectedCountry;
  final GeographicState? selectedState;
  final City? selectedCity;
  final MapDetailLevel detailLevel;
  final ValueChanged<GeoLocation> onLocationTapped;
  final ValueChanged<Country> onCountrySelected;
  final ValueChanged<GeographicState> onStateSelected;
  final ValueChanged<City> onCitySelected;

  const ARGlobeWidget({
    super.key,
    required this.cameraState,
    required this.countries,
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
    required this.detailLevel,
    required this.onLocationTapped,
    required this.onCountrySelected,
    required this.onStateSelected,
    required this.onCitySelected,
  });

  @override
  State<ARGlobeWidget> createState() => _ARGlobeWidgetState();
}

class _ARGlobeWidgetState extends State<ARGlobeWidget>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _earthRotationController;
  late AnimationController _cloudsRotationController;
  late AnimationController _selectionPulseController;
  
  // Animations
  late Animation<double> _earthRotation;
  late Animation<double> _cloudsRotation;
  late Animation<double> _selectionPulse;
  
  // Globe rendering parameters
  static const double _globeRadius = 150.0;
  
  // Touch and gesture handling
  Offset? _lastPanPoint;
  double _currentRotationX = 0.0;
  double _currentRotationY = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _earthRotationController.dispose();
    _cloudsRotationController.dispose();
    _selectionPulseController.dispose();
    super.dispose();
  }

  /// Initialize animations for Earth rotation and effects
  void _initializeAnimations() {
    // Earth slow rotation
    _earthRotationController = AnimationController(
      duration: const Duration(minutes: 5),
      vsync: this,
    );
    
    // Clouds faster rotation
    _cloudsRotationController = AnimationController(
      duration: const Duration(minutes: 3),
      vsync: this,
    );
    
    // Selection pulse effect
    _selectionPulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _earthRotation = Tween<double>(
      begin: 0.0,
      end: 2.0 * math.pi,
    ).animate(CurvedAnimation(
      parent: _earthRotationController,
      curve: Curves.linear,
    ));

    _cloudsRotation = Tween<double>(
      begin: 0.0,
      end: 2.0 * math.pi,
    ).animate(CurvedAnimation(
      parent: _cloudsRotationController,
      curve: Curves.linear,
    ));

    _selectionPulse = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionPulseController,
      curve: Curves.easeInOut,
    ));

    // Start continuous rotations
    _earthRotationController.repeat();
    _cloudsRotationController.repeat();
    
    // Start selection pulse if something is selected
    if (widget.selectedCountry != null) {
      _selectionPulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ARGlobeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update selection pulse based on selection state
    if (widget.selectedCountry != null && oldWidget.selectedCountry == null) {
      _selectionPulseController.repeat(reverse: true);
    } else if (widget.selectedCountry == null && oldWidget.selectedCountry != null) {
      _selectionPulseController.stop();
      _selectionPulseController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        
        return GestureDetector(
          onTapDown: _handleTapDown,
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF0B1426), // Deep space blue
                  Color(0xFF000000), // Black space
                ],
              ),
            ),
            child: Stack(
              children: [
                // Stars background
                _buildStarsBackground(constraints),
                
                // Main globe rendering
                Positioned(
                  left: centerX - _globeRadius * widget.cameraState.zoomLevel,
                  top: centerY - _globeRadius * widget.cameraState.zoomLevel,
                  child: _buildGlobe(),
                ),
                
                // Location markers and labels
                ..._buildLocationMarkers(centerX, centerY),
                
                // Zoom level indicator
                _buildZoomIndicator(),
                
                // Coordinates display
                _buildCoordinatesDisplay(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build the main 3D globe
  Widget _buildGlobe() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _earthRotation,
        _cloudsRotation,
        _selectionPulse,
      ]),
      builder: (context, child) {
        final globeSize = _globeRadius * 2 * widget.cameraState.zoomLevel;
        
        return Container(
          width: globeSize,
          height: globeSize,
          child: Stack(
            children: [
              // Earth sphere with realistic texture
              Transform.rotate(
                angle: _earthRotation.value + 
                       widget.cameraState.rotation * math.pi / 180,
                child: Container(
                  width: globeSize,
                  height: globeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.3),
                      radius: 1.2,
                      colors: [
                        const Color(0xFF4A90E2), // Ocean blue (lit side)
                        const Color(0xFF2E5C8A), // Deeper blue
                        const Color(0xFF1A3B5C), // Dark blue (shadow side)
                        const Color(0xFF0F2A3F), // Very dark (back side)
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 20,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomPaint(
                      painter: EarthPainter(
                        countries: widget.countries,
                        selectedCountry: widget.selectedCountry,
                        selectedState: widget.selectedState,
                        cameraState: widget.cameraState,
                        detailLevel: widget.detailLevel,
                        animationValue: _earthRotation.value,
                        pulseValue: _selectionPulse.value,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Atmospheric glow
              Container(
                width: globeSize,
                height: globeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF4A90E2).withOpacity(0.3),
                      const Color(0xFF2196F3).withOpacity(0.6),
                    ],
                    stops: const [0.85, 0.95, 1.0],
                  ),
                ),
              ),
              
              // Cloud layer (if zoomed out enough)
              if (widget.cameraState.zoomLevel < 5.0)
                Transform.rotate(
                  angle: _cloudsRotation.value,
                  child: Container(
                    width: globeSize,
                    height: globeSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: const Alignment(-0.2, -0.2),
                        radius: 1.0,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    child: ClipOval(
                      child: CustomPaint(
                        painter: CloudsPainter(
                          animationValue: _cloudsRotation.value,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Build location markers for countries, states, and cities
  List<Widget> _buildLocationMarkers(double centerX, double centerY) {
    final markers = <Widget>[];
    
    // Add country markers based on zoom level
    if (widget.detailLevel == MapDetailLevel.global) {
      for (final country in widget.countries.take(20)) { // Limit for performance
        if (_isLocationVisible(country.center)) {
          final screenPos = _geoToScreen(country.center, centerX, centerY);
          markers.add(_buildCountryMarker(country, screenPos));
        }
      }
    }
    
    // Add state markers
    if (widget.selectedCountry != null && 
        widget.detailLevel == MapDetailLevel.country) {
      for (final state in widget.selectedCountry!.states) {
        if (_isLocationVisible(state.center)) {
          final screenPos = _geoToScreen(state.center, centerX, centerY);
          markers.add(_buildStateMarker(state, screenPos));
        }
      }
    }
    
    // Add city markers
    if (widget.selectedState != null && 
        widget.detailLevel == MapDetailLevel.state) {
      for (final city in widget.selectedState!.cities) {
        if (_isLocationVisible(city.location)) {
          final screenPos = _geoToScreen(city.location, centerX, centerY);
          markers.add(_buildCityMarker(city, screenPos));
        }
      }
    }
    
    return markers;
  }

  /// Build country marker
  Widget _buildCountryMarker(Country country, Offset position) {
    final isSelected = widget.selectedCountry?.code == country.code;
    
    return Positioned(
      left: position.dx - 8,
      top: position.dy - 8,
      child: GestureDetector(
        onTap: () => widget.onCountrySelected(country),
        child: AnimatedBuilder(
          animation: _selectionPulse,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? 1.0 + (_selectionPulse.value * 0.3) : 1.0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.yellow : Colors.red,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isSelected ? Colors.yellow : Colors.red)
                          .withOpacity(0.6),
                      blurRadius: isSelected ? 8 : 4,
                      spreadRadius: isSelected ? 2 : 1,
                    ),
                  ],
                ),
                child: widget.cameraState.zoomLevel > 3.0
                    ? Center(
                        child: Text(
                          country.code,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build state marker
  Widget _buildStateMarker(GeographicState state, Offset position) {
    final isSelected = widget.selectedState?.code == state.code;
    
    return Positioned(
      left: position.dx - 6,
      top: position.dy - 6,
      child: GestureDetector(
        onTap: () => widget.onStateSelected(state),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.orange : Colors.blue,
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? Colors.orange : Colors.blue)
                    .withOpacity(0.6),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build city marker
  Widget _buildCityMarker(City city, Offset position) {
    final isSelected = widget.selectedCity?.name == city.name;
    
    return Positioned(
      left: position.dx - 4,
      top: position.dy - 4,
      child: GestureDetector(
        onTap: () => widget.onCitySelected(city),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.purple : Colors.green,
            border: Border.all(color: Colors.white, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? Colors.purple : Colors.green)
                    .withOpacity(0.6),
                blurRadius: 3,
                spreadRadius: 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build stars background
  Widget _buildStarsBackground(BoxConstraints constraints) {
    return CustomPaint(
      size: Size(constraints.maxWidth, constraints.maxHeight),
      painter: StarsPainter(),
    );
  }

  /// Build zoom level indicator
  Widget _buildZoomIndicator() {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Text(
          'Zoom: ${widget.cameraState.zoomLevel.toStringAsFixed(1)}x',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Build coordinates display
  Widget _buildCoordinatesDisplay() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lat: ${widget.cameraState.target.latitude.toStringAsFixed(2)}°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Lng: ${widget.cameraState.target.longitude.toStringAsFixed(2)}°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Convert geographic coordinates to screen coordinates
  Offset _geoToScreen(GeoLocation location, double centerX, double centerY) {
    // Simplified spherical projection
    final lat = location.latitude * math.pi / 180;
    final lng = (location.longitude + widget.cameraState.rotation) * math.pi / 180;
    
    final radius = _globeRadius * widget.cameraState.zoomLevel;
    
    // Project 3D coordinates to 2D screen
    final x = centerX + radius * math.cos(lat) * math.sin(lng);
    final y = centerY - radius * math.sin(lat);
    
    return Offset(x, y);
  }

  /// Check if a location is visible on the current globe view
  bool _isLocationVisible(GeoLocation location) {
    // Simplified visibility check
    final lng = (location.longitude + widget.cameraState.rotation) % 360;
    return lng >= -90 && lng <= 90;
  }

  /// Handle tap down events
  void _handleTapDown(TapDownDetails details) {
    final position = details.localPosition;
    final geoLocation = _screenToGeo(position);
    
    // Provide haptic feedback
    HapticFeedback.selectionClick();
    
    // Trigger location selection
    widget.onLocationTapped(geoLocation);
  }

  /// Handle pan start
  void _handlePanStart(DragStartDetails details) {
    _lastPanPoint = details.localPosition;
  }

  /// Handle pan update for globe rotation
  void _handlePanUpdate(DragUpdateDetails details) {
    if (_lastPanPoint != null) {
      final delta = details.localPosition - _lastPanPoint!;
      
      // Convert pan to rotation
      _currentRotationY += delta.dx * 0.5;
      _currentRotationX += delta.dy * 0.5;
      
      // Apply rotation constraints
      _currentRotationX = _currentRotationX.clamp(-90.0, 90.0);
      _currentRotationY = _currentRotationY % 360.0;
      
      _lastPanPoint = details.localPosition;
    }
  }

  /// Handle pan end
  void _handlePanEnd(DragEndDetails details) {
    _lastPanPoint = null;
  }

  /// Convert screen coordinates to geographic coordinates
  GeoLocation _screenToGeo(Offset screenPosition) {
    // Simplified reverse projection
    final centerX = context.size!.width / 2;
    final centerY = context.size!.height / 2;
    
    final radius = _globeRadius * widget.cameraState.zoomLevel;
    
    final x = (screenPosition.dx - centerX) / radius;
    final y = (centerY - screenPosition.dy) / radius;
    
    // Clamp to sphere surface
    final distance = math.sqrt(x * x + y * y);
    if (distance > 1.0) {
      return const GeoLocation(latitude: 0, longitude: 0);
    }
    
    final lat = math.asin(y) * 180 / math.pi;
    final lng = (math.atan2(x, math.sqrt(1 - x * x - y * y)) * 180 / math.pi) 
               - widget.cameraState.rotation;
    
    return GeoLocation(
      latitude: lat.clamp(-90, 90),
      longitude: lng.clamp(-180, 180),
    );
  }
}

/// Custom painter for Earth surface with countries
class EarthPainter extends CustomPainter {
  final List<Country> countries;
  final Country? selectedCountry;
  final GeographicState? selectedState;
  final ARCameraState cameraState;
  final MapDetailLevel detailLevel;
  final double animationValue;
  final double pulseValue;

  EarthPainter({
    required this.countries,
    this.selectedCountry,
    this.selectedState,
    required this.cameraState,
    required this.detailLevel,
    required this.animationValue,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw land masses
    _drawLandMasses(canvas, center, radius);
    
    // Draw country boundaries
    if (detailLevel == MapDetailLevel.global || detailLevel == MapDetailLevel.country) {
      _drawCountryBoundaries(canvas, center, radius);
    }
    
    // Draw state boundaries
    if (selectedCountry != null && detailLevel == MapDetailLevel.country) {
      _drawStateBoundaries(canvas, center, radius);
    }
    
    // Highlight selected regions
    _drawSelectionHighlights(canvas, center, radius);
  }

  /// Draw simplified land masses
  void _drawLandMasses(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32) // Forest green for land
      ..style = PaintingStyle.fill;

    // Simplified continent shapes
    _drawContinentShape(canvas, center, radius, paint, 'northAmerica');
    _drawContinentShape(canvas, center, radius, paint, 'southAmerica');
    _drawContinentShape(canvas, center, radius, paint, 'europe');
    _drawContinentShape(canvas, center, radius, paint, 'africa');
    _drawContinentShape(canvas, center, radius, paint, 'asia');
    _drawContinentShape(canvas, center, radius, paint, 'australia');
  }

  /// Draw simplified continent shapes
  void _drawContinentShape(Canvas canvas, Offset center, double radius, 
                          Paint paint, String continent) {
    final path = Path();
    
    switch (continent) {
      case 'northAmerica':
        // Simplified North America
        path.moveTo(center.dx - radius * 0.6, center.dy - radius * 0.3);
        path.quadraticBezierTo(
          center.dx - radius * 0.8, center.dy - radius * 0.1,
          center.dx - radius * 0.7, center.dy + radius * 0.2,
        );
        path.quadraticBezierTo(
          center.dx - radius * 0.4, center.dy + radius * 0.1,
          center.dx - radius * 0.3, center.dy - radius * 0.2,
        );
        path.close();
        break;
        
      case 'southAmerica':
        // Simplified South America
        path.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.1);
        path.quadraticBezierTo(
          center.dx - radius * 0.5, center.dy + radius * 0.6,
          center.dx - radius * 0.3, center.dy + radius * 0.8,
        );
        path.quadraticBezierTo(
          center.dx - radius * 0.1, center.dy + radius * 0.7,
          center.dx - radius * 0.2, center.dy + radius * 0.2,
        );
        path.close();
        break;
        
      case 'africa':
        // Simplified Africa
        path.moveTo(center.dx + radius * 0.1, center.dy - radius * 0.2);
        path.quadraticBezierTo(
          center.dx + radius * 0.3, center.dy + radius * 0.1,
          center.dx + radius * 0.2, center.dy + radius * 0.6,
        );
        path.quadraticBezierTo(
          center.dx - radius * 0.1, center.dy + radius * 0.5,
          center.dx, center.dy,
        );
        path.close();
        break;
        
      default:
        // Generic land mass
        path.addOval(Rect.fromCircle(
          center: Offset(
            center.dx + radius * 0.3 * math.cos(animationValue),
            center.dy + radius * 0.3 * math.sin(animationValue),
          ),
          radius: radius * 0.2,
        ));
    }
    
    canvas.drawPath(path, paint);
  }

  /// Draw country boundaries
  void _drawCountryBoundaries(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final country in countries) {
      if (country.boundaries.isNotEmpty) {
        final path = _createBoundaryPath(country.boundaries, center, radius);
        canvas.drawPath(path, paint);
      }
    }
  }

  /// Draw state boundaries
  void _drawStateBoundaries(Canvas canvas, Offset center, double radius) {
    if (selectedCountry == null) return;
    
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final state in selectedCountry!.states) {
      if (state.boundaries.isNotEmpty) {
        final path = _createBoundaryPath(state.boundaries, center, radius);
        canvas.drawPath(path, paint);
      }
    }
  }

  /// Create path from boundary coordinates
  Path _createBoundaryPath(List<GeoLocation> boundaries, Offset center, double radius) {
    final path = Path();
    
    for (int i = 0; i < boundaries.length; i++) {
      final point = _geoToCanvas(boundaries[i], center, radius);
      
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    
    path.close();
    return path;
  }

  /// Draw selection highlights
  void _drawSelectionHighlights(Canvas canvas, Offset center, double radius) {
    if (selectedCountry != null) {
      final paint = Paint()
        ..color = Colors.yellow.withOpacity(0.3 + pulseValue * 0.3)
        ..style = PaintingStyle.fill;
      
      final countryCenter = _geoToCanvas(selectedCountry!.center, center, radius);
      canvas.drawCircle(countryCenter, radius * 0.1, paint);
    }
  }

  /// Convert geographic coordinates to canvas coordinates
  Offset _geoToCanvas(GeoLocation location, Offset center, double radius) {
    final lat = location.latitude * math.pi / 180;
    final lng = (location.longitude + cameraState.rotation) * math.pi / 180;
    
    final x = center.dx + radius * math.cos(lat) * math.sin(lng);
    final y = center.dy - radius * math.sin(lat);
    
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant EarthPainter oldDelegate) {
    return oldDelegate.selectedCountry != selectedCountry ||
           oldDelegate.selectedState != selectedState ||
           oldDelegate.animationValue != animationValue ||
           oldDelegate.pulseValue != pulseValue ||
           oldDelegate.cameraState != cameraState;
  }
}

/// Custom painter for cloud layer
class CloudsPainter extends CustomPainter {
  final double animationValue;

  CloudsPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw moving cloud patterns
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + animationValue;
      final cloudRadius = radius * (0.3 + 0.1 * math.sin(animationValue * 2 + i));
      
      final cloudCenter = Offset(
        center.dx + cloudRadius * math.cos(angle),
        center.dy + cloudRadius * math.sin(angle),
      );
      
      canvas.drawCircle(cloudCenter, radius * 0.08, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CloudsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Custom painter for stars background
class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent stars
    
    // Generate stars
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 0.5;
      
      paint.color = Colors.white.withOpacity(0.5 + random.nextDouble() * 0.5);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) => false;
} 