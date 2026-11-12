import 'package:flutter/material.dart';
import 'package:meals2/models/meal.dart';
import 'package:meals2/screens/meals.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.availableMeals});

  /// Meals that already passed the user's filters.
  final List<Meal> availableMeals;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Meal> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return widget.availableMeals.where((meal) {
      return meal.title.toLowerCase().contains(q) ||
          meal.ingredients.any((i) => i.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasQuery = _query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search meals or ingredients',
            border: InputBorder.none,
          ),
          style: theme.textTheme.titleMedium,
          onChanged: (value) => setState(() => _query = value),
        ),
        actions: [
          if (hasQuery)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: hasQuery
          ? MealsScreen(
              meals: _results,
              emptyHint: 'No meals match "${_query.trim()}".',
            )
          : Center(
              child: Text(
                'Type a meal name or an ingredient.',
                style: theme.textTheme.bodyLarge,
              ),
            ),
    );
  }
}