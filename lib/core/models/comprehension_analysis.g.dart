// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comprehension_analysis.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComprehensionAnalysisAdapter extends TypeAdapter<ComprehensionAnalysis> {
  @override
  final int typeId = 16;

  @override
  ComprehensionAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComprehensionAnalysis(
      score: fields[0] as int,
      understandingLevel: fields[1] as String,
      conceptsIdentified: (fields[2] as List).cast<String>(),
      improvementAreas: (fields[3] as List).cast<String>(),
      encouragement: fields[4] as String,
      followUpSuggestions: (fields[5] as List).cast<String>(),
      analysisTimestamp: fields[6] as DateTime,
      feedback: fields[7] as String,
      suggestions: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ComprehensionAnalysis obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.understandingLevel)
      ..writeByte(2)
      ..write(obj.conceptsIdentified)
      ..writeByte(3)
      ..write(obj.improvementAreas)
      ..writeByte(4)
      ..write(obj.encouragement)
      ..writeByte(5)
      ..write(obj.followUpSuggestions)
      ..writeByte(6)
      ..write(obj.analysisTimestamp)
      ..writeByte(7)
      ..write(obj.feedback)
      ..writeByte(8)
      ..write(obj.suggestions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComprehensionAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComprehensionAnalysis _$ComprehensionAnalysisFromJson(
        Map<String, dynamic> json) =>
    ComprehensionAnalysis(
      score: (json['score'] as num).toInt(),
      understandingLevel: json['understandingLevel'] as String,
      conceptsIdentified: (json['conceptsIdentified'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      improvementAreas: (json['improvementAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      encouragement: json['encouragement'] as String,
      followUpSuggestions: (json['followUpSuggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      analysisTimestamp: DateTime.parse(json['analysisTimestamp'] as String),
      feedback: json['feedback'] as String,
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ComprehensionAnalysisToJson(
        ComprehensionAnalysis instance) =>
    <String, dynamic>{
      'score': instance.score,
      'understandingLevel': instance.understandingLevel,
      'conceptsIdentified': instance.conceptsIdentified,
      'improvementAreas': instance.improvementAreas,
      'encouragement': instance.encouragement,
      'followUpSuggestions': instance.followUpSuggestions,
      'analysisTimestamp': instance.analysisTimestamp.toIso8601String(),
      'feedback': instance.feedback,
      'suggestions': instance.suggestions,
    };
