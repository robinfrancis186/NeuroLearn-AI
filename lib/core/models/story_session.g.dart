// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StorySessionAdapter extends TypeAdapter<StorySession> {
  @override
  final int typeId = 6;

  @override
  StorySession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StorySession(
      id: fields[0] as String,
      studentId: fields[1] as String,
      storyId: fields[2] as String,
      storyTitle: fields[3] as String,
      storyType: fields[4] as StoryType,
      startTime: fields[5] as DateTime,
      endTime: fields[6] as DateTime?,
      status: fields[7] as StorySessionStatus,
      interactions: (fields[8] as List).cast<StoryInteraction>(),
      learningObjectives: (fields[9] as Map).cast<String, dynamic>(),
      completionData: (fields[10] as Map).cast<String, dynamic>(),
      voiceProfileUsed: fields[11] as String?,
      emotionalStatesDetected: (fields[12] as List).cast<String>(),
      comprehensionScore: fields[13] as double,
      engagementScore: fields[14] as double,
      adaptationsApplied: (fields[15] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, StorySession obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.storyId)
      ..writeByte(3)
      ..write(obj.storyTitle)
      ..writeByte(4)
      ..write(obj.storyType)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.interactions)
      ..writeByte(9)
      ..write(obj.learningObjectives)
      ..writeByte(10)
      ..write(obj.completionData)
      ..writeByte(11)
      ..write(obj.voiceProfileUsed)
      ..writeByte(12)
      ..write(obj.emotionalStatesDetected)
      ..writeByte(13)
      ..write(obj.comprehensionScore)
      ..writeByte(14)
      ..write(obj.engagementScore)
      ..writeByte(15)
      ..write(obj.adaptationsApplied);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorySessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryInteractionAdapter extends TypeAdapter<StoryInteraction> {
  @override
  final int typeId = 9;

  @override
  StoryInteraction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryInteraction(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      type: fields[2] as InteractionType,
      content: fields[3] as String?,
      data: (fields[4] as Map).cast<String, dynamic>(),
      responseTime: fields[5] as double?,
      isCorrect: fields[6] as bool,
      emotionalState: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StoryInteraction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.responseTime)
      ..writeByte(6)
      ..write(obj.isCorrect)
      ..writeByte(7)
      ..write(obj.emotionalState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryInteractionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryTypeAdapter extends TypeAdapter<StoryType> {
  @override
  final int typeId = 7;

  @override
  StoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StoryType.learning;
      case 1:
        return StoryType.adventure;
      case 2:
        return StoryType.communication;
      case 3:
        return StoryType.emotional;
      case 4:
        return StoryType.social;
      case 5:
        return StoryType.creative;
      default:
        return StoryType.learning;
    }
  }

  @override
  void write(BinaryWriter writer, StoryType obj) {
    switch (obj) {
      case StoryType.learning:
        writer.writeByte(0);
        break;
      case StoryType.adventure:
        writer.writeByte(1);
        break;
      case StoryType.communication:
        writer.writeByte(2);
        break;
      case StoryType.emotional:
        writer.writeByte(3);
        break;
      case StoryType.social:
        writer.writeByte(4);
        break;
      case StoryType.creative:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StorySessionStatusAdapter extends TypeAdapter<StorySessionStatus> {
  @override
  final int typeId = 8;

  @override
  StorySessionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StorySessionStatus.inProgress;
      case 1:
        return StorySessionStatus.paused;
      case 2:
        return StorySessionStatus.completed;
      case 3:
        return StorySessionStatus.abandoned;
      case 4:
        return StorySessionStatus.interrupted;
      default:
        return StorySessionStatus.inProgress;
    }
  }

  @override
  void write(BinaryWriter writer, StorySessionStatus obj) {
    switch (obj) {
      case StorySessionStatus.inProgress:
        writer.writeByte(0);
        break;
      case StorySessionStatus.paused:
        writer.writeByte(1);
        break;
      case StorySessionStatus.completed:
        writer.writeByte(2);
        break;
      case StorySessionStatus.abandoned:
        writer.writeByte(3);
        break;
      case StorySessionStatus.interrupted:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorySessionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InteractionTypeAdapter extends TypeAdapter<InteractionType> {
  @override
  final int typeId = 10;

  @override
  InteractionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InteractionType.tap;
      case 1:
        return InteractionType.voice;
      case 2:
        return InteractionType.gesture;
      case 3:
        return InteractionType.choice;
      case 4:
        return InteractionType.drawing;
      case 5:
        return InteractionType.text;
      case 6:
        return InteractionType.emotion;
      default:
        return InteractionType.tap;
    }
  }

  @override
  void write(BinaryWriter writer, InteractionType obj) {
    switch (obj) {
      case InteractionType.tap:
        writer.writeByte(0);
        break;
      case InteractionType.voice:
        writer.writeByte(1);
        break;
      case InteractionType.gesture:
        writer.writeByte(2);
        break;
      case InteractionType.choice:
        writer.writeByte(3);
        break;
      case InteractionType.drawing:
        writer.writeByte(4);
        break;
      case InteractionType.text:
        writer.writeByte(5);
        break;
      case InteractionType.emotion:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
