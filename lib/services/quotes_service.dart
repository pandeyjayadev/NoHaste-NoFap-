import '../models/Motivational_quote.dart';
import 'package:flutter/material.dart';

class QuotesService {
  static final List<MotivationalQuote> _allQuotes = [
    MotivationalQuote(
      text:
          "The strongest people are not those who show strength in front of us, but those who win battles we know nothing about.",
      author: "Unknown",
      category: "Strength",
      gradient: [Colors.purple.shade400, Colors.purple.shade600],
    ),
    MotivationalQuote(
      text:
          "Every time you resist temptation, you become stronger. Every time you give in, you become weaker.",
      author: "Recovery Wisdom",
      category: "Discipline",
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
    ),
    MotivationalQuote(
      text: "You are not your thoughts. You are the observer of your thoughts.",
      author: "Mindfulness Teaching",
      category: "Mindfulness",
      gradient: [Colors.green.shade400, Colors.green.shade600],
    ),
    MotivationalQuote(
      text:
          "The pain of discipline weighs ounces, but the pain of regret weighs tons.",
      author: "Jim Rohn",
      category: "Discipline",
      gradient: [Colors.orange.shade400, Colors.orange.shade600],
    ),
    MotivationalQuote(
      text:
          "Your future self is counting on you to make the right choice today.",
      author: "Recovery Community",
      category: "Future Focus",
      gradient: [Colors.teal.shade400, Colors.teal.shade600],
    ),
    MotivationalQuote(
      text:
          "Every moment is a fresh beginning. You have the power to start over right now.",
      author: "T.S. Eliot",
      category: "New Beginnings",
      gradient: [Colors.indigo.shade400, Colors.indigo.shade600],
    ),
  ];

  static List<MotivationalQuote> getAllQuotes() => List.from(_allQuotes);

  static List<MotivationalQuote> getQuotesByCategory(String category) {
    return _allQuotes.where((quote) => quote.category == category).toList();
  }

  static List getRandomQuotes(int count) {
    final shuffled = List.from(_allQuotes)..shuffle();
    return shuffled.take(count).toList();
  }

  static MotivationalQuote getDailyQuote() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    return _allQuotes[dayOfYear % _allQuotes.length];
  }
}
