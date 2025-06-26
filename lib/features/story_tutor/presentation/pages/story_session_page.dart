import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';

class StorySessionPage extends ConsumerStatefulWidget {
  final String storyId;
  
  const StorySessionPage({
    super.key,
    required this.storyId,
  });

  @override
  ConsumerState<StorySessionPage> createState() => _StorySessionPageState();
}

class _StorySessionPageState extends ConsumerState<StorySessionPage> {
  bool _isLoading = true;
  bool _isPlaying = false;
  double _progress = 0.0;
  String _currentText = '';
  
  @override
  void initState() {
    super.initState();
    _initializeStory();
  }

  Future<void> _initializeStory() async {
    // Simulate loading story content
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        _currentText = "Once upon a time, in a galaxy far, far away, there lived a brave little astronaut named Luna...";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: SafeArea(
        child: _isLoading ? _buildLoadingScreen() : _buildStoryInterface(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.focusGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 50,
                color: Colors.white,
              ),
            ).animate(onPlay: (controller) => controller.repeat())
                .scale(begin: Offset(1.0, 1.0), end: Offset(1.2, 1.2), duration: 1000.ms)
                .then()
                .scale(begin: Offset(1.2, 1.2), end: Offset(1.0, 1.0), duration: 1000.ms),
            
            const SizedBox(height: 32),
            
            Text(
              'Preparing your story...',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ).animate()
                .fadeIn(delay: 500.ms, duration: 800.ms),
            
            const SizedBox(height: 16),
            
            Text(
              'Creating a magical experience just for you',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ).animate()
                .fadeIn(delay: 1000.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryInterface() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withOpacity(0.8),
            Colors.white,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Column(
        children: [
          // Header with progress
          _buildHeader(),
          
          // Story content area
          Expanded(
            child: _buildStoryContent(),
          ),
          
          // Interactive controls
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Luna\'s Space Adventure',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => _showSettings(),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress bar
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(_progress * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContent() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Story illustration
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: AppTheme.focusGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.rocket_launch,
                size: 80,
                color: Colors.white,
              ),
            ),
          ).animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut),
          
          const SizedBox(height: 24),
          
          // Story text
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _currentText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ).animate()
                  .fadeIn(duration: 1000.ms)
                  .then()
                  .shimmer(duration: 2000.ms, color: AppTheme.primaryBlue.withOpacity(0.2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Main play controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.skip_previous,
                onTap: () => _previousSection(),
              ),
              
              AnimatedCard(
                onTap: () => _togglePlayPause(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppTheme.excitementGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentOrange.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              
              _buildControlButton(
                icon: Icons.skip_next,
                onTap: () => _nextSection(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Interaction buttons
          Row(
            children: [
              Expanded(
                child: _buildInteractionButton(
                  icon: Icons.mic,
                  label: 'Speak',
                  color: AppTheme.secondaryGreen,
                  onTap: () => _startVoiceInteraction(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInteractionButton(
                  icon: Icons.touch_app,
                  label: 'Touch',
                  color: AppTheme.softPurple,
                  onTap: () => _showTouchInteraction(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInteractionButton(
                  icon: Icons.help,
                  label: 'Help',
                  color: AppTheme.accentOrange,
                  onTap: () => _showHelp(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 28,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    // Show story session settings
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (_isPlaying) {
      // Start voice narration
      _simulateProgress();
    } else {
      // Pause narration
    }
  }

  void _simulateProgress() {
    if (_isPlaying && _progress < 1.0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _isPlaying) {
          setState(() {
            _progress = (_progress + 0.01).clamp(0.0, 1.0);
          });
          _simulateProgress();
        }
      });
    }
  }

  void _previousSection() {
    // Go to previous story section
  }

  void _nextSection() {
    // Go to next story section
  }

  void _startVoiceInteraction() {
    // Start speech recognition for student input
  }

  void _showTouchInteraction() {
    // Show touch-based interaction options
  }

  void _showHelp() {
    // Show contextual help
  }
} 