// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentProgressAdapter extends TypeAdapter<StudentProgress> {
  @override
  final int typeId = 6;

  @override
  StudentProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentProgress(
      studentId: fields[0] as String,
      storiesCompleted: fields[1] as int,
      totalLearningTime: fields[2] as Duration,
      learningStreakDays: fields[3] as int,
      achievements: fields[4] as int,
      subjectProgress: (fields[5] as Map).cast<String, double>(),
      weeklyActivity: (fields[6] as List).cast<DailyActivity>(),
      dailyLearningTime: (fields[7] as List).cast<DailyLearningTime>(),
      moodData: (fields[8] as Map).cast<String, dynamic>(),
      lastUpdated: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StudentProgress obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.storiesCompleted)
      ..writeByte(2)
      ..write(obj.totalLearningTime)
      ..writeByte(3)
      ..write(obj.learningStreakDays)
      ..writeByte(4)
      ..write(obj.achievements)
      ..writeByte(5)
      ..write(obj.subjectProgress)
      ..writeByte(6)
      ..write(obj.weeklyActivity)
      ..writeByte(7)
      ..write(obj.dailyLearningTime)
      ..writeByte(8)
      ..write(obj.moodData)
      ..writeByte(9)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyActivityAdapter extends TypeAdapter<DailyActivity> {
  @override
  final int typeId = 7;

  @override
  DailyActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyActivity(
      day: fields[0] as String,
      value: fields[1] as double,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyActivity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyLearningTimeAdapter extends TypeAdapter<DailyLearningTime> {
  @override
  final int typeId = 8;

  @override
  DailyLearningTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyLearningTime(
      day: fields[0] as String,
      minutes: fields[1] as double,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyLearningTime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.minutes)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyLearningTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectProgressAdapter extends TypeAdapter<SubjectProgress> {
  @override
  final int typeId = 9;

  @override
  SubjectProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectProgress(
      subject: fields[0] as String,
      progress: fields[1] as double,
      totalLessons: fields[2] as double,
      completedLessons: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.subject)
      ..writeByte(1)
      ..write(obj.progress)
      ..writeByte(2)
      ..write(obj.totalLessons)
      ..writeByte(3)
      ..write(obj.completedLessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodEntryAdapter extends TypeAdapter<MoodEntry> {
  @override
  final int typeId = 4;

  @override
  MoodEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodEntry(
      date: fields[0] as DateTime,
      mood: fields[1] as MoodType,
      energyLevel: fields[2] as int,
      focusLevel: fields[3] as int,
      notes: fields[4] as String?,
      activities: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoodEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.energyLevel)
      ..writeByte(3)
      ..write(obj.focusLevel)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.activities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 6;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      iconPath: fields[3] as String,
      category: fields[4] as AchievementCategory,
      unlockedAt: fields[5] as DateTime,
      points: fields[6] as int,
      isNew: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconPath)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.unlockedAt)
      ..writeByte(6)
      ..write(obj.points)
      ..writeByte(7)
      ..write(obj.isNew);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIInsightAdapter extends TypeAdapter<AIInsight> {
  @override
  final int typeId = 8;

  @override
  AIInsight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIInsight(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      type: fields[3] as InsightType,
      generatedAt: fields[4] as DateTime,
      confidence: fields[5] as double,
      recommendations: (fields[6] as List).cast<String>(),
      metadata: (fields[7] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AIInsight obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.generatedAt)
      ..writeByte(5)
      ..write(obj.confidence)
      ..writeByte(6)
      ..write(obj.recommendations)
      ..writeByte(7)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIInsightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WellbeingMetricsAdapter extends TypeAdapter<WellbeingMetrics> {
  @override
  final int typeId = 10;

  @override
  WellbeingMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WellbeingMetrics(
      averageMoodScore: fields[0] as double,
      averageEnergyLevel: fields[1] as double,
      averageFocusLevel: fields[2] as double,
      totalMoodEntries: fields[3] as int,
      lastMoodEntry: fields[4] as DateTime,
      moodDistribution: (fields[5] as Map).cast<MoodType, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, WellbeingMetrics obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.averageMoodScore)
      ..writeByte(1)
      ..write(obj.averageEnergyLevel)
      ..writeByte(2)
      ..write(obj.averageFocusLevel)
      ..writeByte(3)
      ..write(obj.totalMoodEntries)
      ..writeByte(4)
      ..write(obj.lastMoodEntry)
      ..writeByte(5)
      ..write(obj.moodDistribution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellbeingMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodTypeAdapter extends TypeAdapter<MoodType> {
  @override
  final int typeId = 5;

  @override
  MoodType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoodType.veryHappy;
      case 1:
        return MoodType.happy;
      case 2:
        return MoodType.neutral;
      case 3:
        return MoodType.sad;
      case 4:
        return MoodType.verySad;
      case 5:
        return MoodType.excited;
      case 6:
        return MoodType.calm;
      case 7:
        return MoodType.anxious;
      case 8:
        return MoodType.frustrated;
      case 9:
        return MoodType.proud;
      default:
        return MoodType.veryHappy;
    }
  }

  @override
  void write(BinaryWriter writer, MoodType obj) {
    switch (obj) {
      case MoodType.veryHappy:
        writer.writeByte(0);
        break;
      case MoodType.happy:
        writer.writeByte(1);
        break;
      case MoodType.neutral:
        writer.writeByte(2);
        break;
      case MoodType.sad:
        writer.writeByte(3);
        break;
      case MoodType.verySad:
        writer.writeByte(4);
        break;
      case MoodType.excited:
        writer.writeByte(5);
        break;
      case MoodType.calm:
        writer.writeByte(6);
        break;
      case MoodType.anxious:
        writer.writeByte(7);
        break;
      case MoodType.frustrated:
        writer.writeByte(8);
        break;
      case MoodType.proud:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementCategoryAdapter extends TypeAdapter<AchievementCategory> {
  @override
  final int typeId = 7;

  @override
  AchievementCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementCategory.learning;
      case 1:
        return AchievementCategory.consistency;
      case 2:
        return AchievementCategory.creativity;
      case 3:
        return AchievementCategory.social;
      case 4:
        return AchievementCategory.milestone;
      case 5:
        return AchievementCategory.special;
      default:
        return AchievementCategory.learning;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementCategory obj) {
    switch (obj) {
      case AchievementCategory.learning:
        writer.writeByte(0);
        break;
      case AchievementCategory.consistency:
        writer.writeByte(1);
        break;
      case AchievementCategory.creativity:
        writer.writeByte(2);
        break;
      case AchievementCategory.social:
        writer.writeByte(3);
        break;
      case AchievementCategory.milestone:
        writer.writeByte(4);
        break;
      case AchievementCategory.special:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightTypeAdapter extends TypeAdapter<InsightType> {
  @override
  final int typeId = 9;

  @override
  InsightType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightType.learningPattern;
      case 1:
        return InsightType.moodTrend;
      case 2:
        return InsightType.performanceAnalysis;
      case 3:
        return InsightType.recommendation;
      case 4:
        return InsightType.achievement;
      case 5:
        return InsightType.warning;
      case 6:
        return InsightType.celebration;
      default:
        return InsightType.learningPattern;
    }
  }

  @override
  void write(BinaryWriter writer, InsightType obj) {
    switch (obj) {
      case InsightType.learningPattern:
        writer.writeByte(0);
        break;
      case InsightType.moodTrend:
        writer.writeByte(1);
        break;
      case InsightType.performanceAnalysis:
        writer.writeByte(2);
        break;
      case InsightType.recommendation:
        writer.writeByte(3);
        break;
      case InsightType.achievement:
        writer.writeByte(4);
        break;
      case InsightType.warning:
        writer.writeByte(5);
        break;
      case InsightType.celebration:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
