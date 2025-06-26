// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentProfileAdapter extends TypeAdapter<StudentProfile> {
  @override
  final int typeId = 0;

  @override
  StudentProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      avatarPath: fields[3] as String,
      cognitiveProfile: fields[4] as CognitiveProfile,
      favoriteCharacters: (fields[5] as List).cast<String>(),
      preferredTopics: (fields[6] as List).cast<String>(),
      learningProgress: (fields[7] as Map).cast<String, dynamic>(),
      parentEmail: fields[8] as String?,
      teacherEmail: fields[9] as String?,
      createdAt: fields[10] as DateTime,
      lastActiveAt: fields[11] as DateTime,
      isActive: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StudentProfile obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.avatarPath)
      ..writeByte(4)
      ..write(obj.cognitiveProfile)
      ..writeByte(5)
      ..write(obj.favoriteCharacters)
      ..writeByte(6)
      ..write(obj.preferredTopics)
      ..writeByte(7)
      ..write(obj.learningProgress)
      ..writeByte(8)
      ..write(obj.parentEmail)
      ..writeByte(9)
      ..write(obj.teacherEmail)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.lastActiveAt)
      ..writeByte(12)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CognitiveProfileAdapter extends TypeAdapter<CognitiveProfile> {
  @override
  final int typeId = 1;

  @override
  CognitiveProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CognitiveProfile(
      neurodivergentTraits: (fields[0] as List).cast<String>(),
      primaryLearningStyle: fields[1] as LearningStyle,
      attentionProfile: fields[2] as AttentionProfile,
      sensoryPreferences: fields[3] as SensoryPreferences,
      communicationNeeds: fields[4] as CommunicationNeeds,
      skillLevels: (fields[5] as Map).cast<String, double>(),
      supportStrategies: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CognitiveProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.neurodivergentTraits)
      ..writeByte(1)
      ..write(obj.primaryLearningStyle)
      ..writeByte(2)
      ..write(obj.attentionProfile)
      ..writeByte(3)
      ..write(obj.sensoryPreferences)
      ..writeByte(4)
      ..write(obj.communicationNeeds)
      ..writeByte(5)
      ..write(obj.skillLevels)
      ..writeByte(6)
      ..write(obj.supportStrategies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CognitiveProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttentionProfileAdapter extends TypeAdapter<AttentionProfile> {
  @override
  final int typeId = 3;

  @override
  AttentionProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttentionProfile(
      attentionSpanMinutes: fields[0] as int,
      distractionTriggers: (fields[1] as List).cast<String>(),
      focusStrategies: (fields[2] as List).cast<String>(),
      needsBreaks: fields[3] as bool,
      breakIntervalMinutes: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AttentionProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.attentionSpanMinutes)
      ..writeByte(1)
      ..write(obj.distractionTriggers)
      ..writeByte(2)
      ..write(obj.focusStrategies)
      ..writeByte(3)
      ..write(obj.needsBreaks)
      ..writeByte(4)
      ..write(obj.breakIntervalMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttentionProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SensoryPreferencesAdapter extends TypeAdapter<SensoryPreferences> {
  @override
  final int typeId = 4;

  @override
  SensoryPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensoryPreferences(
      visualSensitivity: fields[0] as bool,
      auditorySensitivity: fields[1] as bool,
      tactileSensitivity: fields[2] as bool,
      preferredVolume: fields[3] as double,
      reducedAnimations: fields[4] as bool,
      highContrast: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SensoryPreferences obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.visualSensitivity)
      ..writeByte(1)
      ..write(obj.auditorySensitivity)
      ..writeByte(2)
      ..write(obj.tactileSensitivity)
      ..writeByte(3)
      ..write(obj.preferredVolume)
      ..writeByte(4)
      ..write(obj.reducedAnimations)
      ..writeByte(5)
      ..write(obj.highContrast);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensoryPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommunicationNeedsAdapter extends TypeAdapter<CommunicationNeeds> {
  @override
  final int typeId = 5;

  @override
  CommunicationNeeds read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommunicationNeeds(
      usesAAC: fields[0] as bool,
      needsVisualSupports: fields[1] as bool,
      prefersShorterSentences: fields[2] as bool,
      needsRepetition: fields[3] as bool,
      communicationMethods: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CommunicationNeeds obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.usesAAC)
      ..writeByte(1)
      ..write(obj.needsVisualSupports)
      ..writeByte(2)
      ..write(obj.prefersShorterSentences)
      ..writeByte(3)
      ..write(obj.needsRepetition)
      ..writeByte(4)
      ..write(obj.communicationMethods);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunicationNeedsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LearningStyleAdapter extends TypeAdapter<LearningStyle> {
  @override
  final int typeId = 2;

  @override
  LearningStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LearningStyle.visual;
      case 1:
        return LearningStyle.auditory;
      case 2:
        return LearningStyle.kinesthetic;
      case 3:
        return LearningStyle.reading;
      case 4:
        return LearningStyle.multimodal;
      default:
        return LearningStyle.visual;
    }
  }

  @override
  void write(BinaryWriter writer, LearningStyle obj) {
    switch (obj) {
      case LearningStyle.visual:
        writer.writeByte(0);
        break;
      case LearningStyle.auditory:
        writer.writeByte(1);
        break;
      case LearningStyle.kinesthetic:
        writer.writeByte(2);
        break;
      case LearningStyle.reading:
        writer.writeByte(3);
        break;
      case LearningStyle.multimodal:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
