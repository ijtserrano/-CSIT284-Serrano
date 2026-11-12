import 'package:flutter/foundation.dart';

class QuizAttempt {
  const QuizAttempt({
    required this.categoryTitle,
    required this.score,
    required this.total,
    required this.date,
  });

  final String categoryTitle;
  final int score;
  final int total;
  final DateTime date;

  double get percent => total == 0 ? 0 : score / total * 100;
}

class QuizStatsStore extends ChangeNotifier {
  final List<QuizAttempt> _attempts = [];

  List<QuizAttempt> get attempts => List.unmodifiable(_attempts);

  void add(QuizAttempt attempt) {
    _attempts.insert(0, attempt); // newest first
    notifyListeners();
  }

  void clear() {
    _attempts.clear();
    notifyListeners();
  }
}

final quizStatsStore = QuizStatsStore();