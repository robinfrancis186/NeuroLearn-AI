// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 17;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      interactiveElements: (fields[3] as List).cast<String>(),
      comprehensionQuestions: (fields[4] as List).cast<String>(),
      vocabularyWords: (fields[5] as List).cast<String>(),
      nextSuggestions: (fields[6] as List).cast<String>(),
      difficultyLevel: fields[7] as String,
      estimatedDuration: fields[8] as int,
      learningObjectives: (fields[9] as List).cast<String>(),
      createdAt: fields[10] as DateTime,
      adaptationNotes: fields[11] as String?,
      characters: (fields[12] as List?)?.cast<String>(),
      interactionPoints: (fields[13] as List?)?.cast<String>(),
      learningPoints: (fields[14] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.interactiveElements)
      ..writeByte(4)
      ..write(obj.comprehensionQuestions)
      ..writeByte(5)
      ..write(obj.vocabularyWords)
      ..writeByte(6)
      ..write(obj.nextSuggestions)
      ..writeByte(7)
      ..write(obj.difficultyLevel)
      ..writeByte(8)
      ..write(obj.estimatedDuration)
      ..writeByte(9)
      ..write(obj.learningObjectives)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.adaptationNotes)
      ..writeByte(12)
      ..write(obj.characters)
      ..writeByte(13)
      ..write(obj.interactionPoints)
      ..writeByte(14)
      ..write(obj.learningPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      interactiveElements: (json['interactiveElements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      comprehensionQuestions: (json['comprehensionQuestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      vocabularyWords: (json['vocabularyWords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nextSuggestions: (json['nextSuggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      difficultyLevel: json['difficultyLevel'] as String,
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      learningObjectives: (json['learningObjectives'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      adaptationNotes: json['adaptationNotes'] as String?,
      characters: (json['characters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      interactionPoints: (json['interactionPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      learningPoints: (json['learningPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'interactiveElements': instance.interactiveElements,
      'comprehensionQuestions': instance.comprehensionQuestions,
      'vocabularyWords': instance.vocabularyWords,
      'nextSuggestions': instance.nextSuggestions,
      'difficultyLevel': instance.difficultyLevel,
      'estimatedDuration': instance.estimatedDuration,
      'learningObjectives': instance.learningObjectives,
      'createdAt': instance.createdAt.toIso8601String(),
      'adaptationNotes': instance.adaptationNotes,
      'characters': instance.characters,
      'interactionPoints': instance.interactionPoints,
      'learningPoints': instance.learningPoints,
    };
