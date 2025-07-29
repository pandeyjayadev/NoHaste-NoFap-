import 'package:json_annotation/json_annotation.dart';
part 'journal_entry.g.dart';

enum MoodLevel {
  veryBad(1, 'Very Bad', 0xFFE53E3E),
  bad(2, 'Bad', 0xFFEF4444),
  neutral(3, 'Neutral', 0xFF6B7280),
  good(4, 'Good', 0xFF10B981),
  veryGood(5, 'Very Good', 0xFF059669);

  const MoodLevel(this.value, this.label, this.color);
  final int value;
  final String label;
  final int color;
}

@JsonSerializable()
class JournalEntry {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String content;
  final MoodLevel mood;
  final List<String> triggers;
  final List<String> customTriggers;

  JournalEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.content,
    required this.mood,
    required this.triggers,
    required this.customTriggers,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);

  JournalEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? content,
    MoodLevel? mood,
    List<String>? triggers,
    List<String>? customTriggers,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      triggers: triggers ?? this.triggers,
      customTriggers: customTriggers ?? this.customTriggers,
    );
  }
}
