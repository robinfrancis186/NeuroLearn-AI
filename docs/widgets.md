# Widget Catalog 🎨

## Overview

This catalog documents all reusable UI components in NeuroLearn AI, designed specifically for neurodivergent learners. Each widget follows accessibility best practices and supports customization for different sensory preferences.

## Design Principles

- **Accessibility First**: High contrast, large touch targets, screen reader support
- **Sensory Awareness**: Reduced motion options, calming color schemes
- **Cognitive Load Reduction**: Clear visual hierarchy, predictable patterns
- **Customizable**: Adaptable to individual user preferences

## Table of Contents

1. [Core Components](#core-components)
2. [Emotion Engine Widgets](#emotion-engine-widgets)
3. [Story Components](#story-components)
4. [Communication Widgets](#communication-widgets)
5. [Analytics Widgets](#analytics-widgets)
6. [Navigation Components](#navigation-components)
7. [Form Components](#form-components)
8. [Accessibility Widgets](#accessibility-widgets)

## Core Components

### NeuroScaffold

**Purpose**: Main scaffold wrapper with neurodivergent-friendly defaults

```dart
class NeuroScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool reduceMotion;
  final bool highContrast;
  
  const NeuroScaffold({
    Key? key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.reduceMotion = false,
    this.highContrast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: highContrast 
          ? NeuroColors.highContrastBackground 
          : NeuroColors.primaryBackground,
      appBar: title != null ? NeuroAppBar(
        title: title!,
        actions: actions,
        highContrast: highContrast,
      ) : null,
      body: AnimatedSwitcher(
        duration: reduceMotion 
            ? Duration.zero 
            : const Duration(milliseconds: 300),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
```

**Features:**
- Automatic high contrast support
- Reduced motion compliance
- Consistent spacing and typography
- Screen reader optimized

**Usage:**
```dart
NeuroScaffold(
  title: 'Emotion Engine',
  highContrast: userPreferences.highContrast,
  reduceMotion: userPreferences.reduceMotion,
  body: EmotionEngineContent(),
  actions: [
    NeuroIconButton(
      icon: Icons.settings,
      onPressed: () => _openSettings(),
      tooltip: 'Open settings',
    ),
  ],
)
```

### NeuroCard

**Purpose**: Consistent card component with accessibility features

```dart
class NeuroCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool elevated;
  final Color? backgroundColor;
  
  const NeuroCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
    this.semanticLabel,
    this.elevated = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: Material(
        color: backgroundColor ?? theme.cardColor,
        elevation: elevated ? 2.0 : 0.0,
        borderRadius: BorderRadius.circular(NeuroConstants.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NeuroConstants.borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

**Features:**
- Consistent border radius and elevation
- Semantic labeling for screen readers
- Customizable background colors
- Ripple effect for feedback

### NeuroButton

**Purpose**: Accessible button with proper sizing and feedback

```dart
class NeuroButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final NeuroButtonStyle style;
  final IconData? icon;
  final bool loading;
  final double? width;
  
  const NeuroButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = NeuroButtonStyle.primary,
    this.icon,
    this.loading = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: NeuroConstants.buttonHeight, // Minimum 44px for accessibility
      child: ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading 
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : icon != null 
                ? Icon(icon) 
                : const SizedBox.shrink(),
        label: Text(
          text,
          style: _getTextStyle(context, style),
        ),
        style: _getButtonStyle(context, style),
      ),
    );
  }
}

enum NeuroButtonStyle {
  primary,
  secondary,
  success,
  warning,
  danger,
  calm, // Special style for calming interventions
}
```

## Emotion Engine Widgets

### EmotionDisplay

**Purpose**: Visual representation of detected emotions

```dart
class EmotionDisplay extends StatelessWidget {
  final EmotionalState? emotion;
  final bool showConfidence;
  final bool animated;
  
  const EmotionDisplay({
    Key? key,
    this.emotion,
    this.showConfidence = true,
    this.animated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (emotion == null) {
      return _buildNoEmotionState();
    }
    
    return NeuroCard(
      semanticLabel: 'Current emotion: ${emotion!.primaryEmotion}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEmotionIcon(),
          const SizedBox(height: 8),
          _buildEmotionLabel(),
          if (showConfidence) ...[
            const SizedBox(height: 8),
            _buildConfidenceIndicator(),
          ],
        ],
      ),
    );
  }
  
  Widget _buildEmotionIcon() {
    return AnimatedContainer(
      duration: animated ? const Duration(milliseconds: 500) : Duration.zero,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _getEmotionColor(),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getEmotionIcon(),
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
```

### MoodMeter

**Purpose**: Visual mood tracking with historical data

```dart
class MoodMeter extends StatelessWidget {
  final List<EmotionalState> history;
  final Duration timeRange;
  final bool interactive;
  
  const MoodMeter({
    Key? key,
    required this.history,
    this.timeRange = const Duration(hours: 1),
    this.interactive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuroCard(
      semanticLabel: 'Mood meter showing emotional patterns',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Timeline',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildMoodChart(),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }
  
  Widget _buildMoodChart() {
    return SizedBox(
      height: 120,
      child: CustomPaint(
        painter: MoodChartPainter(
          emotions: history,
          timeRange: timeRange,
        ),
        size: Size.infinite,
      ),
    );
  }
}
```

### InterventionCard

**Purpose**: Recommendation cards for emotional interventions

```dart
class InterventionCard extends StatelessWidget {
  final InterventionType type;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final IconData icon;
  
  const InterventionCard({
    Key? key,
    required this.type,
    required this.title,
    required this.description,
    this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuroCard(
      onTap: onTap,
      semanticLabel: '$title intervention. $description',
      backgroundColor: _getBackgroundColor(),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getTextColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getTextColor(),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: _getTextColor(),
            size: 16,
          ),
        ],
      ),
    );
  }
}

enum InterventionType {
  calming,
  energizing,
  focusing,
  socializing,
}
```

## Story Components

### StoryCard

**Purpose**: Interactive story preview with engagement metrics

```dart
class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback? onTap;
  final bool showProgress;
  final double? completionRate;
  
  const StoryCard({
    Key? key,
    required this.story,
    this.onTap,
    this.showProgress = false,
    this.completionRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuroCard(
      onTap: onTap,
      semanticLabel: 'Story: ${story.title}. ${story.mood} mood.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildPreview(),
          if (showProgress) ...[
            const SizedBox(height: 12),
            _buildProgressIndicator(),
          ],
          const SizedBox(height: 12),
          _buildMetadata(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        _buildMoodIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            story.title,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMoodIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: StoryMoodColors.getColor(story.mood),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        StoryMoodIcons.getIcon(story.mood),
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
```

### StoryReader

**Purpose**: Accessible story reading interface

```dart
class StoryReader extends StatefulWidget {
  final Story story;
  final Function(double progress)? onProgressUpdate;
  final VoidCallback? onComplete;
  
  const StoryReader({
    Key? key,
    required this.story,
    this.onProgressUpdate,
    this.onComplete,
  }) : super(key: key);

  @override
  State<StoryReader> createState() => _StoryReaderState();
}

class _StoryReaderState extends State<StoryReader> {
  late ScrollController _scrollController;
  double _readingProgress = 0.0;
  
  @override
  Widget build(BuildContext context) {
    return NeuroScaffold(
      title: widget.story.title,
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: _buildStoryContent(),
          ),
          _buildControls(),
        ],
      ),
    );
  }
  
  Widget _buildStoryContent() {
    return Semantics(
      label: 'Story content',
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        child: SelectableText(
          widget.story.content,
          style: _getReadingTextStyle(),
          onSelectionChanged: _handleTextSelection,
        ),
      ),
    );
  }
  
  TextStyle _getReadingTextStyle() {
    final preferences = UserPreferences.instance;
    return TextStyle(
      fontSize: preferences.fontSize,
      height: preferences.lineHeight,
      fontFamily: preferences.dyslexiaFriendly 
          ? 'OpenDyslexic' 
          : null,
      color: preferences.highContrast 
          ? Colors.black 
          : null,
    );
  }
}
```

## Communication Widgets

### CommunicationBoard

**Purpose**: Visual communication aid with categories and words

```dart
class CommunicationBoard extends StatefulWidget {
  final Function(String word)? onWordSelected;
  final Function(String message)? onMessageComplete;
  
  const CommunicationBoard({
    Key? key,
    this.onWordSelected,
    this.onMessageComplete,
  }) : super(key: key);

  @override
  State<CommunicationBoard> createState() => _CommunicationBoardState();
}

class _CommunicationBoardState extends State<CommunicationBoard> {
  String _selectedCategory = 'feelings';
  List<String> _messageWords = [];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMessageBuilder(),
        const SizedBox(height: 16),
        _buildCategoryTabs(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildWordGrid(),
        ),
      ],
    );
  }
  
  Widget _buildWordGrid() {
    final words = CommunicationWords.getWords(_selectedCategory);
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return WordTile(
          word: word,
          onTap: () => _addWordToMessage(word),
        );
      },
    );
  }
}
```

### WordTile

**Purpose**: Individual word/symbol tiles for communication

```dart
class WordTile extends StatelessWidget {
  final CommunicationWord word;
  final VoidCallback? onTap;
  final bool selected;
  
  const WordTile({
    Key? key,
    required this.word,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Communication word: ${word.text}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected 
                ? NeuroColors.selectedTile 
                : NeuroColors.communicationTile,
            borderRadius: BorderRadius.circular(12),
            border: selected 
                ? Border.all(
                    color: NeuroColors.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (word.iconPath != null)
                Image.asset(
                  word.iconPath!,
                  width: 32,
                  height: 32,
                ),
              const SizedBox(height: 8),
              Text(
                word.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Analytics Widgets

### ProgressChart

**Purpose**: Visual progress tracking with multiple metrics

```dart
class ProgressChart extends StatelessWidget {
  final List<ProgressDataPoint> data;
  final String title;
  final ProgressChartType type;
  final Duration timeRange;
  
  const ProgressChart({
    Key? key,
    required this.data,
    required this.title,
    this.type = ProgressChartType.line,
    this.timeRange = const Duration(days: 7),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuroCard(
      semanticLabel: '$title progress chart',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildChart(),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }
  
  Widget _buildChart() {
    switch (type) {
      case ProgressChartType.line:
        return _buildLineChart();
      case ProgressChartType.bar:
        return _buildBarChart();
      case ProgressChartType.pie:
        return _buildPieChart();
    }
  }
}

enum ProgressChartType {
  line,
  bar,
  pie,
}
```

### MetricCard

**Purpose**: Key performance indicator display

```dart
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final double? change;
  final bool showTrend;
  
  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.change,
    this.showTrend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuroCard(
      semanticLabel: '$title: $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              if (showTrend && change != null)
                _buildTrendIndicator(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

## Navigation Components

### NeuroBottomNavigation

**Purpose**: Accessible bottom navigation with clear labels

```dart
class NeuroBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int index)? onTap;
  final List<NeuroNavItem> items;
  
  const NeuroBottomNavigation({
    Key? key,
    required this.currentIndex,
    this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return Expanded(
                child: NeuroNavButton(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onTap?.call(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class NeuroNavItem {
  final IconData icon;
  final String label;
  final String? semanticLabel;
  
  const NeuroNavItem({
    required this.icon,
    required this.label,
    this.semanticLabel,
  });
}
```

## Form Components

### NeuroTextField

**Purpose**: Accessible text input with validation

```dart
class NeuroTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final int? maxLines;
  
  const NeuroTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffix: suffix,
            filled: true,
            fillColor: enabled 
                ? Theme.of(context).colorScheme.surface 
                : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NeuroConstants.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NeuroConstants.borderRadius),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NeuroConstants.borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NeuroConstants.borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

## Accessibility Widgets

### NeuroAccessibilityWrapper

**Purpose**: Universal accessibility wrapper for any widget

```dart
class NeuroAccessibilityWrapper extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final bool excludeSemantics;
  final bool focusable;
  final VoidCallback? onTap;
  final String? hint;
  
  const NeuroAccessibilityWrapper({
    Key? key,
    required this.child,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.focusable = false,
    this.onTap,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget wrappedChild = child;
    
    if (!excludeSemantics) {
      wrappedChild = Semantics(
        label: semanticLabel,
        button: onTap != null,
        focusable: focusable,
        hint: hint,
        child: wrappedChild,
      );
    }
    
    if (onTap != null) {
      wrappedChild = GestureDetector(
        onTap: onTap,
        child: wrappedChild,
      );
    }
    
    return wrappedChild;
  }
}
```

### HighContrastWrapper

**Purpose**: Conditional high contrast styling

```dart
class HighContrastWrapper extends StatelessWidget {
  final Widget child;
  final Widget? highContrastChild;
  final bool? forceHighContrast;
  
  const HighContrastWrapper({
    Key? key,
    required this.child,
    this.highContrastChild,
    this.forceHighContrast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final preferences = ref.watch(userPreferencesProvider);
        final useHighContrast = forceHighContrast ?? preferences.highContrast;
        
        if (useHighContrast && highContrastChild != null) {
          return highContrastChild!;
        }
        
        return child;
      },
    );
  }
}
```

## Theme Integration

### NeuroTheme

**Purpose**: Centralized theme configuration

```dart
class NeuroTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    textTheme: _textTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    cardTheme: _cardTheme,
    appBarTheme: _appBarTheme,
  );
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    textTheme: _textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    elevatedButtonTheme: _elevatedButtonTheme,
    cardTheme: _cardTheme,
    appBarTheme: _appBarTheme,
  );
  
  static ThemeData get highContrastTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _highContrastColorScheme,
    textTheme: _textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
  );
}
```

## Usage Guidelines

### Accessibility Checklist

- ✅ Minimum touch target size: 44x44px
- ✅ Color contrast ratio: 4.5:1 minimum
- ✅ Text scaling support: Up to 200%
- ✅ Screen reader labels: All interactive elements
- ✅ Focus indicators: Visible keyboard navigation
- ✅ Reduced motion: Respectful of user preferences

### Best Practices

1. **Always use semantic labels** for screen reader accessibility
2. **Test with high contrast mode** to ensure visibility
3. **Provide alternative text** for images and icons
4. **Use consistent spacing** following the 8px grid system
5. **Support keyboard navigation** for all interactive elements
6. **Respect user preferences** for motion and contrast

---

*This widget catalog is maintained and updated with new components. Last updated: January 15, 2024* 