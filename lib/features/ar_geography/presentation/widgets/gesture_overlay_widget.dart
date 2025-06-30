import 'package:flutter/material.dart';
import '../../services/hand_tracking_service.dart';

/// Simple gesture overlay widget
class GestureOverlayWidget extends StatelessWidget {
  final HandTrackingService handTrackingService;

  const GestureOverlayWidget({
    super.key,
    required this.handTrackingService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: handTrackingService.gestureStream,
      builder: (context, snapshot) {
        if (!handTrackingService.isTracking) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // Hand tracking status
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Hand Tracking Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Current gesture display
            if (snapshot.hasData)
              Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    handTrackingService.getGestureDescription(snapshot.data!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Gesture instructions
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🖐️ Hand Gesture Controls',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '👌 Pinch: Zoom in/out\n'
                      '👆 Point: Select location\n'
                      '✋ Palm: Navigate\n'
                      '👈👉 Swipe: Rotate globe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

 