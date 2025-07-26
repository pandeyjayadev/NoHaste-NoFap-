import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StreakData {
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final int hours;
  final int minutes;

  StreakData({
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.hours,
    required this.minutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'days': days,
      'hours': hours,
      'minutes': minutes,
    };
  }

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      days: json['days'],
      hours: json['hours'],
      minutes: json['minutes'],
    );
  }
}

class StreakService {
  static const String _currentStreakKey = 'current_streak_start';
  static const String _streakHistoryKey = 'streak_history';

  static Future<DateTime?> getCurrentStreakStart() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_currentStreakKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static Future<void> setCurrentStreakStart(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentStreakKey, date.toIso8601String());
  }

  static Future<void> resetStreak() async {
    final currentStart = await getCurrentStreakStart();
    if (currentStart != null) {
      // Calculate current streak duration
      final now = DateTime.now();
      final difference = now.difference(currentStart);

      // Only save to history if streak was longer than 0 days
      if (difference.inDays >= 0) {
        final streakData = StreakData(
          startDate: currentStart,
          endDate: now,
          days: difference.inDays,
          hours: difference.inHours % 24,
          minutes: difference.inMinutes % 60,
        );

        await _addToHistory(streakData);
      }
    }

    // Set new streak start to now
    await setCurrentStreakStart(DateTime.now());
  }

  static Future<void> _addToHistory(StreakData streakData) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_streakHistoryKey) ?? [];

    historyJson.add(jsonEncode(streakData.toJson()));
    await prefs.setStringList(_streakHistoryKey, historyJson);
  }

  static Future<List<StreakData>> getStreakHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_streakHistoryKey) ?? [];

    List<StreakData> history = historyJson
        .map((jsonString) => StreakData.fromJson(jsonDecode(jsonString)))
        .toList();

    // Sort by days (longest first)
    history.sort((a, b) => b.days.compareTo(a.days));

    return history;
  }

  static Future<void> deleteStreakAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_streakHistoryKey) ?? [];

    // Get current list sorted by days (longest first)
    List<StreakData> history = historyJson
        .map((jsonString) => StreakData.fromJson(jsonDecode(jsonString)))
        .toList();
    history.sort((a, b) => b.days.compareTo(a.days));

    // Remove the item at the specified index
    if (index >= 0 && index < history.length) {
      history.removeAt(index);

      // Save back to preferences
      final updatedJson = history
          .map((streak) => jsonEncode(streak.toJson()))
          .toList();
      await prefs.setStringList(_streakHistoryKey, updatedJson);
    }
  }

  static Future<void> updateStreakAt(
    int index,
    StreakData newStreakData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_streakHistoryKey) ?? [];

    // Get current list sorted by days (longest first)
    List<StreakData> history = historyJson
        .map((jsonString) => StreakData.fromJson(jsonDecode(jsonString)))
        .toList();
    history.sort((a, b) => b.days.compareTo(a.days));

    // Update the item at the specified index
    if (index >= 0 && index < history.length) {
      history[index] = newStreakData;

      // Save back to preferences (will be re-sorted when loaded)
      final updatedJson = history
          .map((streak) => jsonEncode(streak.toJson()))
          .toList();
      await prefs.setStringList(_streakHistoryKey, updatedJson);
    }
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakHistoryKey);
  }

  // Debug function to print all data
  static Future<void> printAllData() async {
    final prefs = await SharedPreferences.getInstance();

    print('=== NOHASTE STREAK DATA ===');
    print('Current Streak Start: ${prefs.getString(_currentStreakKey)}');
    print('Streak History: ${prefs.getStringList(_streakHistoryKey)}');
    print('All Keys: ${prefs.getKeys()}');
    print('========================');
  }
}
