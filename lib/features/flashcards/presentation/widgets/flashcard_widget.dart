import 'package:flutter/material.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../core/models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback? onTap;
  final bool showAnswer;
  final bool isInteractive;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    this.onTap,
    this.showAnswer = false,
    this.isInteractive = true,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.showAnswer) {
      _isFlipped = true;
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (!widget.isInteractive) return;
    
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  Color _getCardColor() {
    if (widget.flashcard.isPersonalized) {
      return Color(0xFF9C27B0); // Deep Purple
    }
    return Color(0xFF2196F3); // Blue
  }

  String _getCategoryName(FlashcardCategory category) {
    // You can expand this mapping as needed
    switch (category) {
      case FlashcardCategory.math:
        return 'Math';
      case FlashcardCategory.reading:
        return 'Reading';
      case FlashcardCategory.science:
        return 'Science';
      case FlashcardCategory.socialSkills:
        return 'Social';
      case FlashcardCategory.vocabulary:
        return 'Words';
      case FlashcardCategory.memory:
        return 'Memory';
      case FlashcardCategory.problemSolving:
        return 'Problem';
      case FlashcardCategory.emotions:
        return 'Emotions';
      default:
        return category.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? _flip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14159),
            child: isShowingFront ? _buildFront() : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final cardColor = _getCardColor();
    
    return Container(
      width: double.infinity,
      height: 220,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.flashcard.isPersonalized ? Icons.favorite : Icons.school,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  widget.flashcard.isPersonalized ? 'Memory Card' : 'Study Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryName(widget.flashcard.category).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Question
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  widget.flashcard.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          
          // Footer
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 8),
                Text(
                  'Tap to flip',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    final cardColor = _getCardColor();
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        width: double.infinity,
        height: 220,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: cardColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Answer',
                    style: TextStyle(
                      color: cardColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Answer
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    widget.flashcard.answer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tap to flip back',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 