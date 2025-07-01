import 'package:flutter/material.dart';
import '../../data/models/geography_models.dart';

/// AR controls widget for camera and interaction controls
class ARControlsWidget extends StatelessWidget {
  final ARCameraState cameraState;
  final MapDetailLevel currentDetailLevel;
  final bool handTrackingEnabled;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;
  final VoidCallback onToggleHandTracking;
  final VoidCallback onToggleInfo;

  const ARControlsWidget({
    super.key,
    required this.cameraState,
    required this.currentDetailLevel,
    required this.handTrackingEnabled,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
    required this.onToggleHandTracking,
    required this.onToggleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom controls
        _buildZoomControls(),
        
        const SizedBox(height: 12),
        
        // Action buttons
        _buildActionButtons(),
        
        const SizedBox(height: 12),
        
        // Detail level indicator
        _buildDetailLevelIndicator(),
      ],
    );
  }

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zoom in button
          IconButton(
            onPressed: onZoomIn,
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Zoom In',
          ),
          
          // Zoom level indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${cameraState.zoomLevel.toStringAsFixed(1)}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Zoom out button
          IconButton(
            onPressed: onZoomOut,
            icon: const Icon(Icons.remove, color: Colors.white),
            tooltip: 'Zoom Out',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hand tracking toggle
        _buildControlButton(
          icon: handTrackingEnabled ? Icons.pan_tool : Icons.pan_tool_outlined,
          label: handTrackingEnabled ? 'Hand Tracking On' : 'Hand Tracking Off',
          color: handTrackingEnabled ? Colors.green : Colors.grey,
          onPressed: onToggleHandTracking,
        ),
        
        const SizedBox(height: 8),
        
        // Info panel toggle
        _buildControlButton(
          icon: Icons.info_outline,
          label: 'Location Info',
          color: Colors.blue,
          onPressed: onToggleInfo,
        ),
        
        const SizedBox(height: 8),
        
        // Reset view button
        _buildControlButton(
          icon: Icons.home,
          label: 'Reset View',
          color: Colors.orange,
          onPressed: onResetView,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailLevelIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getDetailLevelIcon(currentDetailLevel),
            color: Colors.purple,
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            _getDetailLevelName(currentDetailLevel),
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDetailLevelIcon(MapDetailLevel level) {
    switch (level) {
      case MapDetailLevel.global:
        return Icons.public;
      case MapDetailLevel.continent:
        return Icons.map;
      case MapDetailLevel.country:
        return Icons.flag;
      case MapDetailLevel.state:
        return Icons.location_city;
      case MapDetailLevel.city:
        return Icons.business;
      case MapDetailLevel.street:
        return Icons.streetview;
    }
  }

  String _getDetailLevelName(MapDetailLevel level) {
    switch (level) {
      case MapDetailLevel.global:
        return 'Global';
      case MapDetailLevel.continent:
        return 'Continent';
      case MapDetailLevel.country:
        return 'Country';
      case MapDetailLevel.state:
        return 'State';
      case MapDetailLevel.city:
        return 'City';
      case MapDetailLevel.street:
        return 'Street';
    }
  }
} 