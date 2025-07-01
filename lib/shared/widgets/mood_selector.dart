import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/models/emotional_state.dart';
import '../themes/app_theme.dart';

class MoodSelector extends StatelessWidget {
  final StoryMood currentMood;
  final Function(StoryMood) onMoodChanged;
  
  const MoodSelector({
    super.key,
    required this.currentMood,
    required this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: StoryMood.values.map((mood) {
            final isSelected = mood == currentMood;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _MoodChip(
                mood: mood,
                isSelected: isSelected,
                onTap: () => onMoodChanged(mood),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final StoryMood mood;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _MoodChip({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final moodData = _getMoodData(mood);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? moodData.gradient : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: moodData.color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withOpacity(0.2)
                    : moodData.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                moodData.icon,
                size: 20,
                color: isSelected ? Colors.white : moodData.color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              moodData.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0)
          .scale(begin: Offset(1.0, 1.0), end: Offset(1.05, 1.05), duration: 200.ms)
          .then()
          .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.5)),
    );
  }
  
  _MoodData _getMoodData(StoryMood mood) {
    switch (mood) {
      case StoryMood.calm:
        return _MoodData(
          label: 'Calm',
          icon: Icons.spa,
          color: AppTheme.calmBlue,
          gradient: AppTheme.calmGradient,
        );
      case StoryMood.excitement:
        return _MoodData(
          label: 'Excited',
          icon: Icons.celebration,
          color: AppTheme.excitementYellow,
          gradient: AppTheme.excitementGradient,
        );
      case StoryMood.comfort:
        return _MoodData(
          label: 'Comfort',
          icon: Icons.favorite,
          color: AppTheme.comfortGreen,
          gradient: AppTheme.comfortGradient,
        );
      case StoryMood.adventure:
        return _MoodData(
          label: 'Adventure',
          icon: Icons.explore,
          color: AppTheme.primaryBlue,
          gradient: AppTheme.focusGradient,
        );
      case StoryMood.creative:
        return _MoodData(
          label: 'Creative',
          icon: Icons.palette,
          color: AppTheme.softPurple,
          gradient: AppTheme.excitementGradient,
        );
      case StoryMood.social:
        return _MoodData(
          label: 'Social',
          icon: Icons.group,
          color: AppTheme.secondaryGreen,
          gradient: AppTheme.comfortGradient,
        );
      case StoryMood.neutral:
        return _MoodData(
          label: 'Balanced',
          icon: Icons.balance,
          color: AppTheme.focusLavender,
          gradient: AppTheme.focusGradient,
        );
    }
  }
}

class _MoodData {
  final String label;
  final IconData icon;
  final Color color;
  final LinearGradient gradient;
  
  const _MoodData({
    required this.label,
    required this.icon,
    required this.color,
    required this.gradient,
  });
} 