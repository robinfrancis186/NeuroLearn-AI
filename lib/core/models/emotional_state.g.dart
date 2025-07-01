// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotional_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionalStateAdapter extends TypeAdapter<EmotionalState> {
  @override
  final int typeId = 11;

  @override
  EmotionalState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmotionalState(
      id: fields[0] as String,
      studentId: fields[1] as String,
      timestamp: fields[2] as DateTime,
      valence: fields[3] as EmotionalValence,
      arousal: fields[4] as double,
      detectedEmotions: (fields[5] as List).cast<DetectedEmotion>(),
      source: fields[6] as EmotionDetectionSource,
      confidence: fields[7] as double,
      rawData: (fields[8] as Map).cast<String, dynamic>(),
      recommendedMood: fields[9] as StoryMood,
      triggers: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EmotionalState obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.valence)
      ..writeByte(4)
      ..write(obj.arousal)
      ..writeByte(5)
      ..write(obj.detectedEmotions)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.confidence)
      ..writeByte(8)
      ..write(obj.rawData)
      ..writeByte(9)
      ..write(obj.recommendedMood)
      ..writeByte(10)
      ..write(obj.triggers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionalStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DetectedEmotionAdapter extends TypeAdapter<DetectedEmotion> {
  @override
  final int typeId = 15;

  @override
  DetectedEmotion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetectedEmotion(
      label: fields[0] as String,
      confidence: fields[1] as double,
      metadata: (fields[2] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, DetectedEmotion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectedEmotionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmotionalValenceAdapter extends TypeAdapter<EmotionalValence> {
  @override
  final int typeId = 12;

  @override
  EmotionalValence read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EmotionalValence.positive;
      case 1:
        return EmotionalValence.negative;
      case 2:
        return EmotionalValence.neutral;
      default:
        return EmotionalValence.positive;
    }
  }

  @override
  void write(BinaryWriter writer, EmotionalValence obj) {
    switch (obj) {
      case EmotionalValence.positive:
        writer.writeByte(0);
        break;
      case EmotionalValence.negative:
        writer.writeByte(1);
        break;
      case EmotionalValence.neutral:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionalValenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmotionDetectionSourceAdapter
    extends TypeAdapter<EmotionDetectionSource> {
  @override
  final int typeId = 13;

  @override
  EmotionDetectionSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EmotionDetectionSource.facial;
      case 1:
        return EmotionDetectionSource.voice;
      case 2:
        return EmotionDetectionSource.interaction;
      case 3:
        return EmotionDetectionSource.physiological;
      case 4:
        return EmotionDetectionSource.manual;
      case 5:
        return EmotionDetectionSource.combined;
      default:
        return EmotionDetectionSource.facial;
    }
  }

  @override
  void write(BinaryWriter writer, EmotionDetectionSource obj) {
    switch (obj) {
      case EmotionDetectionSource.facial:
        writer.writeByte(0);
        break;
      case EmotionDetectionSource.voice:
        writer.writeByte(1);
        break;
      case EmotionDetectionSource.interaction:
        writer.writeByte(2);
        break;
      case EmotionDetectionSource.physiological:
        writer.writeByte(3);
        break;
      case EmotionDetectionSource.manual:
        writer.writeByte(4);
        break;
      case EmotionDetectionSource.combined:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionDetectionSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryMoodAdapter extends TypeAdapter<StoryMood> {
  @override
  final int typeId = 14;

  @override
  StoryMood read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StoryMood.calm;
      case 1:
        return StoryMood.excitement;
      case 2:
        return StoryMood.comfort;
      case 3:
        return StoryMood.adventure;
      case 4:
        return StoryMood.creative;
      case 5:
        return StoryMood.social;
      case 6:
        return StoryMood.neutral;
      default:
        return StoryMood.calm;
    }
  }

  @override
  void write(BinaryWriter writer, StoryMood obj) {
    switch (obj) {
      case StoryMood.calm:
        writer.writeByte(0);
        break;
      case StoryMood.excitement:
        writer.writeByte(1);
        break;
      case StoryMood.comfort:
        writer.writeByte(2);
        break;
      case StoryMood.adventure:
        writer.writeByte(3);
        break;
      case StoryMood.creative:
        writer.writeByte(4);
        break;
      case StoryMood.social:
        writer.writeByte(5);
        break;
      case StoryMood.neutral:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryMoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
