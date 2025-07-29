// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) => JournalEntry(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  title: json['title'] as String,
  content: json['content'] as String,
  mood: $enumDecode(_$MoodLevelEnumMap, json['mood']),
  triggers: (json['triggers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  customTriggers: (json['customTriggers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'mood': _$MoodLevelEnumMap[instance.mood]!,
      'triggers': instance.triggers,
      'customTriggers': instance.customTriggers,
    };

const _$MoodLevelEnumMap = {
  MoodLevel.veryBad: 'veryBad',
  MoodLevel.bad: 'bad',
  MoodLevel.neutral: 'neutral',
  MoodLevel.good: 'good',
  MoodLevel.veryGood: 'veryGood',
};
