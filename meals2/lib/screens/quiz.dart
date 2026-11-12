import 'package:flutter/material.dart';
import 'package:meals2/data/quiz_generator.dart';
import 'package:meals2/models/category.dart';
import 'package:meals2/models/quiz_question.dart';
import 'package:meals2/providers/quiz_stats_store.dart';
import 'package:meals2/screens/results.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.category});

  final Category category;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizQuestion> _questions;
  late final List<int> _answers;
  int _index = 0;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _questions = generateQuiz(widget.category.id);
    _answers = [];
  }

  void _choose(int option) {
    if (_selected != null) return; // already answered
    setState(() => _selected = option);
  }

  void _next() {
    _answers.add(_selected!);
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }

    final score = [
      for (var i = 0; i < _questions.length; i++)
        if (_answers[i] == _questions[i].correctIndex) 1
    ].length;

    quizStatsStore.add(QuizAttempt(
      categoryTitle: widget.category.title,
      score: score,
      total: _questions.length,
      date: DateTime.now(),
    ));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ResultsScreen(
          category: widget.category,
          questions: _questions,
          answers: _answers,
        ),
      ),
    );
  }

  Color? _tileColor(int i) {
    if (_selected == null) return null;
    if (i == _questions[_index].correctIndex) {
      return Colors.green.withValues(alpha: 0.35);
    }
    if (i == _selected) return Colors.red.withValues(alpha: 0.35);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category.title)),
        body: const Center(child: Text('No questions available.')),
      );
    }

    final question = _questions[_index];
    final isLast = _index == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.category.title} quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_index + 1) / _questions.length,
            ),
            const SizedBox(height: 8),
            Text('Question ${_index + 1} of ${_questions.length}'),
            const SizedBox(height: 24),
            Text(question.prompt, style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            for (var i = 0; i < question.options.length; i++)
              Card(
                color: _tileColor(i),
                child: ListTile(
                  title: Text(question.options[i]),
                  onTap: () => _choose(i),
                ),
              ),
            const Spacer(),
            FilledButton(
              onPressed: _selected == null ? null : _next,
              child: Text(isLast ? 'See results' : 'Next question'),
            ),
          ],
        ),
      ),
    );
  }
}