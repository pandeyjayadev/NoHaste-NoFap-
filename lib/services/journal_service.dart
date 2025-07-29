// services/journal_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import 'package:uuid/uuid.dart';

class JournalService {
  static const String _storageKey = 'journal_entries';
  static const _uuid = Uuid();

  // Predefined common triggers
  static const List<String> commonTriggers = [
    'Stress',
    'Boredom',
    'Loneliness',
    'Social Media',
    'Internet Browsing',
    'Evening/Night Time',
    'Weekend',
    'Tired/Exhausted',
    'Anxiety',
    'Depression',
    'Relationship Issues',
    'Work Pressure',
    'Free Time',
    'Being Alone',
  ];

  Future<List<JournalEntry>> getAllEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? entriesJson = prefs.getString(_storageKey);

      if (entriesJson == null) return [];

      final List<dynamic> entriesList = json.decode(entriesJson);
      return entriesList.map((entry) => JournalEntry.fromJson(entry)).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error loading journal entries: $e');
      return [];
    }
  }

  Future<bool> saveEntry(JournalEntry entry) async {
    try {
      final entries = await getAllEntries();
      final existingIndex = entries.indexWhere((e) => e.id == entry.id);

      if (existingIndex != -1) {
        entries[existingIndex] = entry.copyWith(updatedAt: DateTime.now());
      } else {
        entries.add(entry);
      }

      await _saveAllEntries(entries);
      return true;
    } catch (e) {
      print('Error saving journal entry: $e');
      return false;
    }
  }

  Future<bool> deleteEntry(String id) async {
    try {
      final entries = await getAllEntries();
      entries.removeWhere((entry) => entry.id == id);
      await _saveAllEntries(entries);
      return true;
    } catch (e) {
      print('Error deleting journal entry: $e');
      return false;
    }
  }

  Future<JournalEntry?> getEntryById(String id) async {
    final entries = await getAllEntries();
    try {
      return entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<JournalEntry>> searchEntries(String query) async {
    final entries = await getAllEntries();
    if (query.isEmpty) return entries;

    final lowercaseQuery = query.toLowerCase();
    return entries.where((entry) {
      return entry.title.toLowerCase().contains(lowercaseQuery) ||
          entry.content.toLowerCase().contains(lowercaseQuery) ||
          entry.triggers.any(
            (trigger) => trigger.toLowerCase().contains(lowercaseQuery),
          ) ||
          entry.customTriggers.any(
            (trigger) => trigger.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  Future<List<JournalEntry>> getEntriesByMood(MoodLevel mood) async {
    final entries = await getAllEntries();
    return entries.where((entry) => entry.mood == mood).toList();
  }

  Future<List<JournalEntry>> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entries = await getAllEntries();
    return entries.where((entry) {
      return entry.createdAt.isAfter(start) && entry.createdAt.isBefore(end);
    }).toList();
  }

  Future<Map<MoodLevel, int>> getMoodStatistics() async {
    final entries = await getAllEntries();
    final Map<MoodLevel, int> stats = {};

    for (final mood in MoodLevel.values) {
      stats[mood] = entries.where((entry) => entry.mood == mood).length;
    }

    return stats;
  }

  Future<Map<String, int>> getTriggerStatistics() async {
    final entries = await getAllEntries();
    final Map<String, int> stats = {};

    for (final entry in entries) {
      for (final trigger in [...entry.triggers, ...entry.customTriggers]) {
        stats[trigger] = (stats[trigger] ?? 0) + 1;
      }
    }

    // Sort by frequency
    final sortedEntries = stats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  String generateId() => _uuid.v4();

  Future<void> _saveAllEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = json.encode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, entriesJson);
  }
}
