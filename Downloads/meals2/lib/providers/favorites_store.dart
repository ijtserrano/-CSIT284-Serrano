import 'package:flutter/foundation.dart';
import 'package:meals2/models/meal.dart';

/// Holds the user's favorite meals. Screens listen to it so the star icon
/// and the Favorites tab stay in sync without passing callbacks around.
class FavoritesStore extends ChangeNotifier {
  final List<Meal> _meals = [];

  List<Meal> get meals => List.unmodifiable(_meals);

  bool isFavorite(Meal meal) => _meals.contains(meal);

  /// Returns true if the meal was added, false if it was removed.
  bool toggle(Meal meal) {
    final added = !_meals.contains(meal);
    if (added) {
      _meals.add(meal);
    } else {
      _meals.remove(meal);
    }
    notifyListeners();
    return added;
  }
}

final favoritesStore = FavoritesStore();