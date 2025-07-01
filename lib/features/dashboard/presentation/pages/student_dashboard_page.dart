import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/models/student_profile.dart';
import '../../../../core/models/progress_data.dart';
import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/providers/app_providers.dart';

class StudentDashboardPage extends ConsumerStatefulWidget {
  final StudentProfile student;
  
  const StudentDashboardPage({
    super.key,
    required this.student,
  });

  @override
  ConsumerState<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends ConsumerState<StudentDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                widget.student.name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.student.name}'s Learning Dashboard",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                Text(
                  'Track progress and celebrate achievements',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _exportReport(),
            tooltip: 'Export Report',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareProgress(),
            tooltip: 'Share Progress',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            color: AppTheme.pureWhite,
            padding: const EdgeInsets.all(16),
            child: _buildStatsCards(),
          ),
          
          // Tab Bar
          Container(
            color: AppTheme.pureWhite,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryBlue,
              unselectedLabelColor: AppTheme.mediumGray,
              indicatorColor: AppTheme.primaryBlue,
              tabs: const [
                Tab(text: 'Learning Progress'),
                Tab(text: 'Mood & Wellbeing'),
                Tab(text: 'Achievements'),
                Tab(text: 'AI Insights'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLearningProgressTab(),
                _buildMoodWellbeingTab(),
                _buildAchievementsTab(),
                _buildAIInsightsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCards() {
    final mockProgress = _getMockProgress();
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Stories Completed',
            '${mockProgress.storiesCompleted}',
            '+12% this week',
            Icons.book,
            AppTheme.primaryBlue,
            Colors.blue.shade50,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Time Learning',
            _formatDuration(mockProgress.totalLearningTime),
            '+5 min daily avg',
            Icons.access_time,
            Colors.green,
            Colors.green.shade50,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Learning Streak',
            '${mockProgress.learningStreakDays} days',
            'Keep it up!',
            Icons.local_fire_department,
            Colors.orange,
            Colors.orange.shade50,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Achievements',
            '${mockProgress.achievements}',
            '3 this week',
            Icons.emoji_events,
            Colors.purple,
            Colors.purple.shade50,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, String subtitle, 
                       IconData icon, Color color, Color backgroundColor) {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLearningProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildWeeklyActivityChart(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSubjectProgress(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDailyLearningTimeChart(),
        ],
      ),
    );
  }
  
  Widget _buildWeeklyActivityChart() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Learning Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: AppTheme.mediumGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          );
                          switch (value.toInt()) {
                            case 0: return const Text('Mon', style: style);
                            case 1: return const Text('Tue', style: style);
                            case 2: return const Text('Wed', style: style);
                            case 3: return const Text('Thu', style: style);
                            case 4: return const Text('Fri', style: style);
                            case 5: return const Text('Sat', style: style);
                            case 6: return const Text('Sun', style: style);
                            default: return const Text('', style: style);
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: AppTheme.mediumGray,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2, color: AppTheme.primaryBlue, width: 16)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: AppTheme.primaryBlue, width: 16)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1, color: AppTheme.primaryBlue, width: 16)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4.2, color: AppTheme.primaryBlue, width: 16)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 2, color: AppTheme.primaryBlue, width: 16)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 3, color: AppTheme.primaryBlue, width: 16)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 2, color: AppTheme.primaryBlue, width: 16)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubjectProgress() {
    final subjects = [
      {'name': 'Math', 'progress': 12.0, 'total': 20.0, 'color': AppTheme.primaryBlue},
      {'name': 'Science', 'progress': 8.0, 'total': 15.0, 'color': Colors.green},
      {'name': 'Reading', 'progress': 15.0, 'total': 18.0, 'color': Colors.purple},
      {'name': 'Language', 'progress': 6.0, 'total': 12.0, 'color': Colors.orange},
    ];
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 20),
            ...subjects.map((subject) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject['name'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.highContrastDark,
                        ),
                      ),
                      Text(
                        '${(subject['progress'] as double).toInt()}/${(subject['total'] as double).toInt()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: (subject['progress'] as double) / (subject['total'] as double),
                    backgroundColor: (subject['color'] as Color).withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
                    minHeight: 6,
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDailyLearningTimeChart() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Learning Time',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightGray,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: AppTheme.mediumGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          );
                          switch (value.toInt()) {
                            case 0: return const Text('Mon', style: style);
                            case 1: return const Text('Tue', style: style);
                            case 2: return const Text('Wed', style: style);
                            case 3: return const Text('Thu', style: style);
                            case 4: return const Text('Fri', style: style);
                            case 5: return const Text('Sat', style: style);
                            case 6: return const Text('Sun', style: style);
                            default: return const Text('', style: style);
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: AppTheme.mediumGray,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 80,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 45),
                        FlSpot(1, 58),
                        FlSpot(2, 60),
                        FlSpot(3, 30),
                        FlSpot(4, 75),
                        FlSpot(5, 50),
                        FlSpot(6, 65),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.green,
                            strokeWidth: 2,
                            strokeColor: AppTheme.pureWhite,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMoodWellbeingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildMoodTrendChart(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWellbeingOverview(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMoodEntryCard(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEnergyFocusChart(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecentMoodEntries(),
        ],
      ),
    );
  }
  
  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAchievementStats(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRecentAchievements(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAchievementCategories(),
          const SizedBox(height: 16),
          _buildAllAchievements(),
        ],
      ),
    );
  }
  
  Widget _buildAIInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInsightsSummary(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLearningPatterns(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceAnalysis(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecommendations(),
          const SizedBox(height: 16),
          _buildInsightHistory(),
        ],
      ),
    );
  }
  
  StudentProgress _getMockProgress() {
    return StudentProgress(
      studentId: widget.student.id,
      storiesCompleted: 24,
      totalLearningTime: const Duration(hours: 12, minutes: 45),
      learningStreakDays: 7,
      achievements: 24,
      lastUpdated: DateTime.now(),
    );
  }
  
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  
  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export report feature coming soon!')),
    );
  }
  
  void _shareProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share progress feature coming soon!')),
    );
  }

  // MOOD & WELLBEING TAB WIDGETS
  Widget _buildMoodTrendChart() {
    final moodEntries = ref.watch(moodEntriesProvider);
    
    // Convert mood entries to chart data
    final spots = <FlSpot>[];
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final targetDate = now.subtract(Duration(days: 6 - i));
      final dayEntry = moodEntries.where((entry) => 
        entry.date.day == targetDate.day && 
        entry.date.month == targetDate.month
      ).firstOrNull;
      
      double moodValue = 3.0; // Default neutral
      if (dayEntry != null) {
        moodValue = _moodToValue(dayEntry.mood);
      }
      spots.add(FlSpot(i.toDouble(), moodValue));
    }
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mood Trend (7 Days)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                Icon(Icons.mood, color: Colors.orange, size: 24),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightGray,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: AppTheme.mediumGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          );
                          switch (value.toInt()) {
                            case 0: return const Text('Mon', style: style);
                            case 1: return const Text('Tue', style: style);
                            case 2: return const Text('Wed', style: style);
                            case 3: return const Text('Thu', style: style);
                            case 4: return const Text('Fri', style: style);
                            case 5: return const Text('Sat', style: style);
                            case 6: return const Text('Sun', style: style);
                            default: return const Text('', style: style);
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const moodLabels = ['😢', '😕', '😐', '😊', '😄'];
                          if (value >= 1 && value <= 5) {
                            return Text(
                              moodLabels[value.toInt() - 1],
                              style: const TextStyle(fontSize: 16),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 1,
                  maxY: 5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.orange,
                            strokeWidth: 2,
                            strokeColor: AppTheme.pureWhite,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _moodToValue(MoodType mood) {
    switch (mood) {
      case MoodType.verySad:
        return 1.0;
      case MoodType.sad:
        return 2.0;
      case MoodType.neutral:
        return 3.0;
      case MoodType.happy:
        return 4.0;
      case MoodType.veryHappy:
        return 5.0;
      case MoodType.excited:
        return 4.5;
      case MoodType.calm:
        return 3.5;
      case MoodType.anxious:
        return 2.5;
      case MoodType.frustrated:
        return 2.0;
      case MoodType.proud:
        return 4.5;
    }
  }

  Widget _buildWellbeingOverview() {
    final moodEntries = ref.watch(moodEntriesProvider);
    
    // Calculate wellbeing metrics from real data
    double averageMood = 3.0;
    double averageEnergy = 3.0;
    double averageFocus = 3.0;
    
    if (moodEntries.isNotEmpty) {
      averageMood = moodEntries.map((e) => _moodToValue(e.mood)).reduce((a, b) => a + b) / moodEntries.length;
      averageEnergy = moodEntries.map((e) => e.energyLevel.toDouble()).reduce((a, b) => a + b) / moodEntries.length;
      averageFocus = moodEntries.map((e) => e.focusLevel.toDouble()).reduce((a, b) => a + b) / moodEntries.length;
    }
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wellbeing Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 24),
            _buildWellbeingMetric('Average Mood', averageMood.toStringAsFixed(1), '😊', Colors.orange),
            const SizedBox(height: 16),
            _buildWellbeingMetric('Energy Level', averageEnergy.toStringAsFixed(1), '⚡', Colors.yellow),
            const SizedBox(height: 16),
            _buildWellbeingMetric('Focus Level', averageFocus.toStringAsFixed(1), '🎯', Colors.purple),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      averageMood >= 3.5 ? 'Positive trend this week!' : 'Keep tracking your mood!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildWellbeingMetric(String label, String value, String emoji, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.highContrastDark,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodEntryCard() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodButton('😄', 'Great', Colors.green),
                _buildMoodButton('😊', 'Good', Colors.blue),
                _buildMoodButton('😐', 'Okay', Colors.orange),
                _buildMoodButton('😕', 'Sad', Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showMoodEntryDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Mood Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: AppTheme.pureWhite,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label, Color color) {
    return InkWell(
      onTap: () => _quickMoodEntry(label),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyFocusChart() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy & Focus',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 24),
            _buildProgressIndicator('Energy Level', 0.76, Colors.yellow),
            const SizedBox(height: 16),
            _buildProgressIndicator('Focus Level', 0.82, Colors.purple),
            const SizedBox(height: 16),
            _buildProgressIndicator('Engagement', 0.88, Colors.green),
            const SizedBox(height: 24),
            Text(
              'Based on today\'s activities',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.highContrastDark,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildRecentMoodEntries() {
    final moodEntries = ref.watch(moodEntriesProvider);
    final recentEntries = moodEntries.take(5).toList();

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Mood Entries',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                TextButton(
                  onPressed: () => _viewAllMoodEntries(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentEntries.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.mood, color: AppTheme.mediumGray, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No mood entries yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first mood entry above!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...recentEntries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getMoodEmoji(entry.mood),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.notes ?? _getMoodLabel(entry.mood),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.highContrastDark,
                            ),
                          ),
                          Text(
                            '${_formatDate(entry.date)} • Energy: ${entry.energyLevel}/5 • Focus: ${entry.focusLevel}/5',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          if (entry.activities.isNotEmpty)
                            Text(
                              'Activities: ${entry.activities.join(', ')}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryBlue,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showMoodEntryDialog() {
    MoodType selectedMood = MoodType.neutral;
    int energyLevel = 3;
    int focusLevel = 3;
    String notes = '';
    List<String> selectedActivities = [];
    
    final activities = ['Learning', 'Stories', 'Math', 'Reading', 'Science', 'Art', 'Music', 'Games', 'Exercise'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Mood Entry'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('How are you feeling?'),
                const SizedBox(height: 8),
                DropdownButton<MoodType>(
                  value: selectedMood,
                  isExpanded: true,
                  items: MoodType.values.map((mood) {
                    return DropdownMenuItem(
                      value: mood,
                      child: Text('${_getMoodEmoji(mood)} ${_getMoodLabel(mood)}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedMood = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text('Energy Level: $energyLevel/5'),
                Slider(
                  value: energyLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() => energyLevel = value.round());
                  },
                ),
                const SizedBox(height: 8),
                Text('Focus Level: $focusLevel/5'),
                Slider(
                  value: focusLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() => focusLevel = value.round());
                  },
                ),
                const SizedBox(height: 16),
                const Text('Notes (optional):'),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'How was your learning today?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => notes = value,
                ),
                const SizedBox(height: 16),
                const Text('Activities:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: activities.map((activity) {
                    final isSelected = selectedActivities.contains(activity);
                    return FilterChip(
                      label: Text(activity),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedActivities.add(activity);
                          } else {
                            selectedActivities.remove(activity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final moodEntry = MoodEntry(
                  date: DateTime.now(),
                  mood: selectedMood,
                  energyLevel: energyLevel,
                  focusLevel: focusLevel,
                  notes: notes.isEmpty ? null : notes,
                  activities: selectedActivities,
                );
                
                ref.read(moodEntriesProvider.notifier).addMoodEntry(moodEntry);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mood entry saved successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _quickMoodEntry(String moodLabel) {
    MoodType mood;
    switch (moodLabel) {
      case 'Great':
        mood = MoodType.veryHappy;
        break;
      case 'Good':
        mood = MoodType.happy;
        break;
      case 'Okay':
        mood = MoodType.neutral;
        break;
      case 'Sad':
        mood = MoodType.sad;
        break;
      default:
        mood = MoodType.neutral;
    }
    
    final moodEntry = MoodEntry(
      date: DateTime.now(),
      mood: mood,
      energyLevel: 3,
      focusLevel: 3,
      notes: 'Quick entry: $moodLabel',
      activities: ['Quick Entry'],
    );
    
    ref.read(moodEntriesProvider.notifier).addMoodEntry(moodEntry);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quick mood entry: $moodLabel saved!')),
    );
  }

  String _getMoodEmoji(MoodType mood) {
    switch (mood) {
      case MoodType.veryHappy:
        return '😄';
      case MoodType.happy:
        return '😊';
      case MoodType.neutral:
        return '😐';
      case MoodType.sad:
        return '😕';
      case MoodType.verySad:
        return '😢';
      case MoodType.excited:
        return '🤩';
      case MoodType.calm:
        return '😌';
      case MoodType.anxious:
        return '😰';
      case MoodType.frustrated:
        return '😤';
      case MoodType.proud:
        return '😎';
    }
  }

  String _getMoodLabel(MoodType mood) {
    switch (mood) {
      case MoodType.veryHappy:
        return 'Very Happy';
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
      case MoodType.verySad:
        return 'Very Sad';
      case MoodType.excited:
        return 'Excited';
      case MoodType.calm:
        return 'Calm';
      case MoodType.anxious:
        return 'Anxious';
      case MoodType.frustrated:
        return 'Frustrated';
      case MoodType.proud:
        return 'Proud';
    }
  }

  void _viewAllMoodEntries() {
    final moodEntries = ref.read(moodEntriesProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Mood Entries'),
        content: SizedBox(
          width: 400,
          height: 400,
          child: moodEntries.isEmpty
              ? const Center(child: Text('No mood entries yet'))
              : ListView.builder(
                  itemCount: moodEntries.length,
                  itemBuilder: (context, index) {
                    final entry = moodEntries[index];
                    return ListTile(
                      leading: Text(_getMoodEmoji(entry.mood), style: const TextStyle(fontSize: 24)),
                      title: Text(entry.notes ?? _getMoodLabel(entry.mood)),
                      subtitle: Text(
                        '${_formatDate(entry.date)} • Energy: ${entry.energyLevel}/5 • Focus: ${entry.focusLevel}/5\nActivities: ${entry.activities.join(', ')}',
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewAllAchievements() {
    final achievements = ref.read(userAchievementsProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Achievements'),
        content: SizedBox(
          width: 400,
          height: 400,
          child: achievements.isEmpty
              ? const Center(child: Text('No achievements yet'))
              : ListView.builder(
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return ListTile(
                      leading: Text(achievement.iconPath, style: const TextStyle(fontSize: 24)),
                      title: Text(achievement.title),
                      subtitle: Text('${achievement.description}\n${achievement.points} points • ${_formatDate(achievement.unlockedAt)}'),
                      trailing: achievement.isNew ? const Icon(Icons.new_releases, color: Colors.red) : null,
                      isThreeLine: true,
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareAchievement(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Achievement "$title" shared!')),
    );
  }

  void _generateNewInsights() {
    final insights = ref.read(aiInsightsProvider.notifier);
    final now = DateTime.now();
    
    final newInsight = AIInsight(
      id: 'insight_${now.millisecondsSinceEpoch}',
      title: 'New Learning Insight',
      content: 'Recent analysis shows improved focus during afternoon sessions. Consider adding more challenging content during this time.',
      type: InsightType.learningPattern,
      generatedAt: now,
      confidence: 0.85,
      recommendations: [
        'Schedule challenging topics in the afternoon',
        'Use varied content formats to maintain engagement',
        'Monitor attention spans during different times',
      ],
      metadata: {
        'analysis_type': 'time_based',
        'data_points': 32,
        'trend': 'improving',
      },
    );
    
    insights.addInsight(newInsight);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New AI insight generated!')),
    );
  }

  IconData _getIconForInsightType(InsightType type) {
    switch (type) {
      case InsightType.learningPattern:
        return Icons.psychology;
      case InsightType.moodTrend:
        return Icons.mood;
      case InsightType.performanceAnalysis:
        return Icons.analytics;
      case InsightType.recommendation:
        return Icons.lightbulb;
      case InsightType.achievement:
        return Icons.emoji_events;
      case InsightType.warning:
        return Icons.warning;
      case InsightType.celebration:
        return Icons.celebration;
    }
  }

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // ACHIEVEMENTS TAB WIDGETS
  Widget _buildAchievementStats() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievement Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAchievementStatItem('Total', '24', '🏆', Colors.amber),
                _buildAchievementStatItem('This Week', '3', '⭐', Colors.blue),
                _buildAchievementStatItem('Points', '1,250', '💎', Colors.purple),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              'Progress to next milestone: 65%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementStatItem(String label, String value, String emoji, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAchievements() {
    final achievements = ref.watch(userAchievementsProvider);
    final recentAchievements = achievements.take(3).toList();

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Achievements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                TextButton(
                  onPressed: () => _viewAllAchievements(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentAchievements.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.emoji_events, color: AppTheme.mediumGray, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No achievements yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep learning to unlock achievements!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...recentAchievements.map((achievement) => _buildAchievementItemFromModel(achievement)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement['new'] == true ? Colors.amber.shade50 : AppTheme.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: achievement['new'] == true ? Colors.amber.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              achievement['emoji'] as String,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      achievement['title'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.highContrastDark,
                      ),
                    ),
                    if (achievement['new'] == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  achievement['description'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                Text(
                  achievement['date'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItemFromModel(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.isNew ? Colors.amber.shade50 : AppTheme.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: achievement.isNew ? Colors.amber.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              achievement.iconPath,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      achievement.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.highContrastDark,
                      ),
                    ),
                    if (achievement.isNew) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      '${achievement.points} pts',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                Text(
                  'Unlocked ${_formatDate(achievement.unlockedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _shareAchievement(achievement.title),
            icon: const Icon(Icons.share, size: 18),
            color: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCategories() {
    final categories = [
      {'name': 'Learning', 'count': 12, 'color': Colors.blue, 'icon': Icons.school},
      {'name': 'Consistency', 'count': 8, 'color': Colors.green, 'icon': Icons.timeline},
      {'name': 'Creativity', 'count': 6, 'color': Colors.purple, 'icon': Icons.palette},
      {'name': 'Social', 'count': 4, 'color': Colors.orange, 'icon': Icons.people},
    ];

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievement Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (category['color'] as Color).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.highContrastDark,
                        ),
                      ),
                      Text(
                        '${category['count']} earned',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllAchievements() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Achievements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                TextButton(
                  onPressed: () => _viewAllAchievements(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tap on any achievement to see details and share your progress!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _shareAchievements(),
              icon: const Icon(Icons.share),
              label: const Text('Share Achievements'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: AppTheme.pureWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareAchievements() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share achievements feature coming soon!')),
    );
  }

  // AI INSIGHTS TAB WIDGETS
  Widget _buildInsightsSummary() {
    final insights = ref.watch(aiInsightsProvider);
    final topInsight = insights.isNotEmpty ? insights.first : null;
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppTheme.primaryBlue, size: 28),
                const SizedBox(width: 12),
                Text(
                  'AI Learning Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _generateNewInsights(),
                  child: const Text('Generate'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (topInsight != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          topInsight.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topInsight.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.highContrastDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${(topInsight.confidence * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.lightGray),
                ),
                child: Column(
                  children: [
                    Icon(Icons.psychology, color: AppTheme.mediumGray, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No insights available yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI will analyze learning patterns as data is collected',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
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

  Widget _buildLearningPatterns() {
    final patterns = ref.watch(learningPatternsProvider);
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Patterns',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildPatternItem('Best Learning Time', patterns['bestLearningTime'] ?? 'Not determined', Icons.schedule, Colors.green),
            _buildPatternItem('Preferred Duration', patterns['preferredDuration'] ?? 'Not determined', Icons.timer, Colors.blue),
            _buildPatternItem('Learning Style', patterns['learningStyle'] ?? 'Not determined', Icons.visibility, Colors.purple),
            _buildPatternItem('Break Frequency', patterns['breakFrequency'] ?? 'Not determined', Icons.pause_circle, Colors.orange),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Performance improves by ${patterns['performanceImprovement']?.toStringAsFixed(0) ?? '0'}% when following these patterns',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildPatternItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.highContrastDark,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalysis() {
    final analysis = ref.watch(performanceAnalysisProvider);
    
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Analysis',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: analysis['visual'] ?? 0,
                      color: Colors.blue,
                      title: 'Visual\n${analysis['visual']?.toInt() ?? 0}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: analysis['auditory'] ?? 0,
                      color: Colors.green,
                      title: 'Auditory\n${analysis['auditory']?.toInt() ?? 0}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: analysis['kinesthetic'] ?? 0,
                      color: Colors.purple,
                      title: 'Kinesthetic\n${analysis['kinesthetic']?.toInt() ?? 0}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: analysis['reading'] ?? 0,
                      color: Colors.orange,
                      title: 'Reading\n${analysis['reading']?.toInt() ?? 0}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Learning Style Distribution',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.highContrastDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    final insights = ref.watch(aiInsightsProvider);
    final allRecommendations = <Map<String, dynamic>>[];
    
    // Extract recommendations from AI insights
    for (final insight in insights) {
      for (int i = 0; i < insight.recommendations.length; i++) {
        allRecommendations.add({
          'title': insight.title,
          'description': insight.recommendations[i],
          'priority': i == 0 ? 'High' : (i == 1 ? 'Medium' : 'Low'),
          'icon': _getIconForInsightType(insight.type),
          'color': _getColorForPriority(i == 0 ? 'High' : (i == 1 ? 'Medium' : 'Low')),
          'confidence': insight.confidence,
        });
      }
    }
    
    // Add default recommendations if no AI insights available
    if (allRecommendations.isEmpty) {
      allRecommendations.addAll([
        {
          'title': 'Optimize Learning Schedule',
          'description': 'Schedule math and science in the morning for better focus',
          'priority': 'High',
          'icon': Icons.schedule,
          'color': Colors.red,
          'confidence': 0.8,
        },
        {
          'title': 'Add Visual Elements',
          'description': 'Include more diagrams and visual aids in stories',
          'priority': 'Medium',
          'icon': Icons.image,
          'color': Colors.orange,
          'confidence': 0.7,
        },
        {
          'title': 'Shorter Sessions',
          'description': 'Break down learning into 15-minute focused sessions',
          'priority': 'Medium',
          'icon': Icons.timer,
          'color': Colors.orange,
          'confidence': 0.6,
        },
        {
          'title': 'Mood Integration',
          'description': 'Adjust content difficulty based on daily mood scores',
          'priority': 'Low',
          'icon': Icons.mood,
          'color': Colors.green,
          'confidence': 0.5,
        },
      ]);
    }

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Recommendations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 16),
            ...allRecommendations.take(4).map((rec) => _buildRecommendationItem(rec)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(Map<String, dynamic> recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (recommendation['color'] as Color).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            recommendation['icon'] as IconData,
            color: recommendation['color'] as Color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      recommendation['title'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.highContrastDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (recommendation['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        recommendation['priority'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: recommendation['color'] as Color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation['description'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () => _applyRecommendation(recommendation['title'] as String),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightHistory() {
    final insights = ref.watch(aiInsightsProvider);
    final recentInsights = insights.take(5).toList();

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent AI Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                TextButton(
                  onPressed: () => _viewInsightHistory(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentInsights.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.psychology, color: AppTheme.mediumGray, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No insights generated yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...recentInsights.map((insight) => _buildInsightHistoryItemFromModel(insight)).toList(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'New insights are generated weekly based on learning patterns and interactions.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
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

  Widget _buildInsightHistoryItem(Map<String, dynamic> insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.psychology,
              color: AppTheme.primaryBlue,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                Text(
                  insight['summary'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                Text(
                  '${insight['date']} • ${insight['type']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightHistoryItemFromModel(AIInsight insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getIconForInsightType(insight.type),
              color: AppTheme.primaryBlue,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.highContrastDark,
                  ),
                ),
                Text(
                  insight.content.length > 60 
                      ? '${insight.content.substring(0, 60)}...' 
                      : insight.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                Text(
                  '${_formatDate(insight.generatedAt)} • ${insight.type.name} • ${(insight.confidence * 100).toInt()}% confidence',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyRecommendation(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applying recommendation: $title')),
    );
  }

  void _viewInsightHistory() {
    final insights = ref.read(aiInsightsProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All AI Insights'),
        content: SizedBox(
          width: 500,
          height: 400,
          child: insights.isEmpty
              ? const Center(child: Text('No insights generated yet'))
              : ListView.builder(
                  itemCount: insights.length,
                  itemBuilder: (context, index) {
                    final insight = insights[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(_getIconForInsightType(insight.type), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    insight.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  '${(insight.confidence * 100).toInt()}%',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(insight.content),
                            const SizedBox(height: 8),
                            Text(
                              '${_formatDate(insight.generatedAt)} • ${insight.type.name}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            if (insight.recommendations.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Recommendations:',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              ...insight.recommendations.map((rec) => Text(
                                '• $rec',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              )).toList(),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 