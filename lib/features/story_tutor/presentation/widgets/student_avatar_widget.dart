import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';

class StudentAvatarWidget extends StatelessWidget {
  final String avatarPath;
  final double size;
  final bool showBorder;
  final bool isOnline;
  final VoidCallback? onTap;
  
  const StudentAvatarWidget({
    super.key,
    required this.avatarPath,
    this.size = 60,
    this.showBorder = true,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: showBorder ? AppTheme.focusGradient : null,
          boxShadow: showBorder ? [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(showBorder ? 3 : 0),
          child: Stack(
            children: [
              // Avatar image
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: avatarPath.startsWith('assets/')
                      ? Image.asset(
                          avatarPath,
                          width: size - (showBorder ? 6 : 0),
                          height: size - (showBorder ? 6 : 0),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                      : avatarPath.startsWith('http')
                          ? Image.network(
                              avatarPath,
                              width: size - (showBorder ? 6 : 0),
                              height: size - (showBorder ? 6 : 0),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar();
                              },
                            )
                          : _buildDefaultAvatar(),
                ),
              ),
              
              // Online indicator
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: size * 0.25,
                    height: size * 0.25,
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 500.ms)
                      .then()
                      .fadeOut(duration: 500.ms),
                ),
            ],
          ),
        ),
      ).animate()
          .scale(duration: 300.ms, curve: Curves.elasticOut),
    );
  }
  
  Widget _buildDefaultAvatar() {
    return Container(
      width: size - (showBorder ? 6 : 0),
      height: size - (showBorder ? 6 : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.focusGradient,
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
} 