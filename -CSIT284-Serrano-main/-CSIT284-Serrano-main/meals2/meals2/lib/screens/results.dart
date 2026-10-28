import 'package:flutter/material.dart';
import 'package:meals2/models/category.dart';
import 'package:meals2/models/quiz_question.dart';
import 'package:meals2/screens/quiz.dart';
import 'package:meals2/screens/statistics.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.category,
    required this.questions,
    required this.answers,
  });

  final Category category;
  final List<QuizQuestion> questions;
  final List<int> answers;

  int get _score => [
        for (var i = 0; i < questions.length; i++)
          if (answers[i] == questions[i].correctIndex) 1
      ].length;

  String get _message {
    final p = questions.isEmpty ? 0 : _score / questions.length;
    if (p == 1) return 'Perfect! You are a kitchen master.';
    if (p >= 0.7) return 'Great job!';
    if (p >= 0.4) return 'Not bad, keep practicing.';
    return 'Time to browse more recipes!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent =
        questions.isEmpty ? 0 : (_score / questions.length * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Your results')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: percent / 100,
                      strokeWidth: 10,
                    ),
                  ),
                  Text('$percent%', style: theme.textTheme.headlineMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_score / ${questions.length} correct in ${category.title}',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(_message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text('Review', style: theme.textTheme.titleLarge),
          for (var i = 0; i < questions.length; i++)
            Builder(builder: (context) {
              final q = questions[i];
              final correct = answers[i] == q.correctIndex;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  correct ? Icons.check_circle : Icons.cancel,
                  color: correct ? Colors.green : Colors.red,
                ),
                title: Text(q.prompt),
                subtitle: Text(correct
                    ? 'Your answer: ${q.options[answers[i]]}'
                    : 'Your answer: ${q.options[answers[i]]}\n'
                        'Correct: ${q.correctAnswer}'),
                isThreeLine: !correct,
              );
            }),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.replay),
            label: const Text('Try again'),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => QuizScreen(category: category),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.bar_chart),
            label: const Text('View statistics'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const StatisticsScreen()),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // back to categories
            child: const Text('Pick another category'),
          ),
        ],
      ),
    );
  }
}