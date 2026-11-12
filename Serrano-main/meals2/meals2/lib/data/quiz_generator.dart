import 'dart:math';

import 'package:meals2/data/dummy_data.dart';
import 'package:meals2/models/meal.dart';
import 'package:meals2/models/quiz_question.dart';

/// Builds a random quiz from the meals that belong to [categoryId].
List<QuizQuestion> generateQuiz(String categoryId, {int maxQuestions = 5}) {
  final rng = Random();
  final meals =
      dummyMeals.where((m) => m.categories.contains(categoryId)).toList();

  // One candidate question of each type per meal, then pick a random few.
  final all = <QuizQuestion>[
    for (final meal in meals) ...[
      _durationQuestion(meal, rng),
      _ingredientQuestion(meal, rng),
      _complexityQuestion(meal),
    ],
  ]..shuffle(rng);

  return all.take(maxQuestions).toList();
}

QuizQuestion _build(
  String prompt,
  String correct,
  List<String> wrong,
  Random rng,
) {
  final options = [correct, ...wrong]..shuffle(rng);
  return QuizQuestion(
    prompt: prompt,
    options: options,
    correctIndex: options.indexOf(correct),
  );
}

QuizQuestion _durationQuestion(Meal meal, Random rng) {
  final d = meal.duration;
  final wrong = <int>{d + 5, d + 10, d + 15, d + 20, d + 30, d - 5, d - 10}
      .where((x) => x > 0 && x != d)
      .toList()
    ..shuffle(rng);
  return _build(
    'About how long does "${meal.title}" take to prepare?',
    '$d min',
    wrong.take(3).map((x) => '$x min').toList(),
    rng,
  );
}

QuizQuestion _ingredientQuestion(Meal meal, Random rng) {
  final correct = meal.ingredients[rng.nextInt(meal.ingredients.length)];
  final others = dummyMeals
      .where((m) => m.id != meal.id)
      .expand((m) => m.ingredients)
      .where((i) => !meal.ingredients.contains(i))
      .toSet()
      .toList()
    ..shuffle(rng);
  return _build(
    'Which ingredient is used in "${meal.title}"?',
    correct,
    others.take(3).toList(),
    rng,
  );
}

QuizQuestion _complexityQuestion(Meal meal) {
  final options = Complexity.values
      .map((c) => c.name[0].toUpperCase() + c.name.substring(1))
      .toList();
  return QuizQuestion(
    prompt: 'How complex is "${meal.title}" to cook?',
    options: options,
    correctIndex: Complexity.values.indexOf(meal.complexity),
  );
}