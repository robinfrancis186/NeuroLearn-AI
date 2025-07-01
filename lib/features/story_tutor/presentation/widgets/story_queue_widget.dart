import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';

class StoryQueueWidget extends StatelessWidget {
  final List<String> stories;
  final Function(String) onStoryTap;
  
  const StoryQueueWidget({
    super.key,
    required this.stories,
    required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return _buildEmptyState(context);
    }
    
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final storyId = stories[index];
          return Padding(
            padding: EdgeInsets.only(
              right: 16,
              left: index == 0 ? 0 : 0,
            ),
            child: _StoryCard(
              storyId: storyId,
              onTap: () => onStoryTap(storyId),
            ).animate(delay: Duration(milliseconds: 100 * index))
                .slide(
                  begin: Offset(1, 0),
                  end: Offset.zero,
                  duration: 600.ms,
                )
                .fadeIn(),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No stories available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check back later for new adventures!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slide(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        );
  }
}

class _StoryCard extends StatelessWidget {
  final String storyId;
  final VoidCallback onTap;
  
  const _StoryCard({
    required this.storyId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mock story data - in real app this would come from a provider
    final storyData = _getStoryData(storyId);
    
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: storyData.color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      storyData.color,
                      storyData.color.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        storyData.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Story info
                    Text(
                      storyData.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      storyData.duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Progress indicator
                    if (storyData.progress > 0)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: storyData.progress,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(storyData.progress * 100).round()}%',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              
              // New story indicator
              if (storyData.isNew)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NEW',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2000.ms),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  _StoryData _getStoryData(String storyId) {
    // Mock data - replace with actual story data
    final mockStories = {
      'story1': _StoryData(
        title: 'Luna\'s Space Adventure',
        duration: '8 min',
        color: AppTheme.primaryBlue,
        icon: Icons.rocket_launch,
        progress: 0.0,
        isNew: true,
      ),
      'story2': _StoryData(
        title: 'The Magic Garden',
        duration: '12 min',
        color: AppTheme.secondaryGreen,
        icon: Icons.local_florist,
        progress: 0.3,
        isNew: false,
      ),
      'story3': _StoryData(
        title: 'Counting with Friends',
        duration: '6 min',
        color: AppTheme.accentOrange,
        icon: Icons.calculate,
        progress: 0.0,
        isNew: false,
      ),
    };
    
    return mockStories[storyId] ?? _StoryData(
      title: 'Unknown Story',
      duration: '? min',
      color: AppTheme.focusLavender,
      icon: Icons.book,
      progress: 0.0,
      isNew: false,
    );
  }
}

class _StoryData {
  final String title;
  final String duration;
  final Color color;
  final IconData icon;
  final double progress;
  final bool isNew;
  
  const _StoryData({
    required this.title,
    required this.duration,
    required this.color,
    required this.icon,
    required this.progress,
    required this.isNew,
  });
} 