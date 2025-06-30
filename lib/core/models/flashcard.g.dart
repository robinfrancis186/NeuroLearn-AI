// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardAdapter extends TypeAdapter<Flashcard> {
  @override
  final int typeId = 6;

  @override
  Flashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flashcard(
      id: fields[0] as String,
      question: fields[1] as String,
      answer: fields[2] as String,
      category: fields[3] as FlashcardCategory,
      difficulty: fields[4] as FlashcardDifficulty,
      hint: fields[5] as String?,
      image: fields[6] as String?,
      tags: (fields[7] as List).cast<String>(),
      createdAt: fields[8] as DateTime,
      memoryContext: fields[9] as String?,
      isPersonalized: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Flashcard obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.answer)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.hint)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.memoryContext)
      ..writeByte(10)
      ..write(obj.isPersonalized);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardSessionAdapter extends TypeAdapter<FlashcardSession> {
  @override
  final int typeId = 9;

  @override
  FlashcardSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardSession(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
      attempts: (fields[3] as List).cast<FlashcardAttempt>(),
      category: fields[4] as FlashcardCategory?,
      totalCards: fields[5] as int,
      correctAnswers: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.attempts)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.totalCards)
      ..writeByte(6)
      ..write(obj.correctAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardAttemptAdapter extends TypeAdapter<FlashcardAttempt> {
  @override
  final int typeId = 10;

  @override
  FlashcardAttempt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardAttempt(
      flashcardId: fields[0] as String,
      userAnswer: fields[1] as String,
      isCorrect: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      responseTime: fields[4] as Duration,
      usedHint: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardAttempt obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.flashcardId)
      ..writeByte(1)
      ..write(obj.userAnswer)
      ..writeByte(2)
      ..write(obj.isCorrect)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.responseTime)
      ..writeByte(5)
      ..write(obj.usedHint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAttemptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardProgressAdapter extends TypeAdapter<FlashcardProgress> {
  @override
  final int typeId = 11;

  @override
  FlashcardProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardProgress(
      flashcardId: fields[0] as String,
      timesShown: fields[1] as int,
      timesCorrect: fields[2] as int,
      lastShown: fields[3] as DateTime,
      nextReview: fields[4] as DateTime?,
      masteryLevel: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardProgress obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.flashcardId)
      ..writeByte(1)
      ..write(obj.timesShown)
      ..writeByte(2)
      ..write(obj.timesCorrect)
      ..writeByte(3)
      ..write(obj.lastShown)
      ..writeByte(4)
      ..write(obj.nextReview)
      ..writeByte(5)
      ..write(obj.masteryLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardCategoryAdapter extends TypeAdapter<FlashcardCategory> {
  @override
  final int typeId = 7;

  @override
  FlashcardCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FlashcardCategory.math;
      case 1:
        return FlashcardCategory.reading;
      case 2:
        return FlashcardCategory.science;
      case 3:
        return FlashcardCategory.socialSkills;
      case 4:
        return FlashcardCategory.vocabulary;
      case 5:
        return FlashcardCategory.memory;
      case 6:
        return FlashcardCategory.problemSolving;
      case 7:
        return FlashcardCategory.emotions;
      default:
        return FlashcardCategory.math;
    }
  }

  @override
  void write(BinaryWriter writer, FlashcardCategory obj) {
    switch (obj) {
      case FlashcardCategory.math:
        writer.writeByte(0);
        break;
      case FlashcardCategory.reading:
        writer.writeByte(1);
        break;
      case FlashcardCategory.science:
        writer.writeByte(2);
        break;
      case FlashcardCategory.socialSkills:
        writer.writeByte(3);
        break;
      case FlashcardCategory.vocabulary:
        writer.writeByte(4);
        break;
      case FlashcardCategory.memory:
        writer.writeByte(5);
        break;
      case FlashcardCategory.problemSolving:
        writer.writeByte(6);
        break;
      case FlashcardCategory.emotions:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardDifficultyAdapter extends TypeAdapter<FlashcardDifficulty> {
  @override
  final int typeId = 8;

  @override
  FlashcardDifficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FlashcardDifficulty.easy;
      case 1:
        return FlashcardDifficulty.medium;
      case 2:
        return FlashcardDifficulty.hard;
      default:
        return FlashcardDifficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, FlashcardDifficulty obj) {
    switch (obj) {
      case FlashcardDifficulty.easy:
        writer.writeByte(0);
        break;
      case FlashcardDifficulty.medium:
        writer.writeByte(1);
        break;
      case FlashcardDifficulty.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
