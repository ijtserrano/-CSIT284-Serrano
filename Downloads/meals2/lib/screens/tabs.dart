import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals2/models/meal.dart';
import 'package:meals2/providers/favorite_meals_provider.dart';
import 'package:meals2/providers/meals_provider.dart';
import 'package:meals2/screens/about.dart';
import 'package:meals2/screens/categories.dart';
import 'package:meals2/screens/filters.dart';
import 'package:meals2/screens/meals.dart';
import 'package:meals2/screens/quiz_category.dart';
import 'package:meals2/screens/search.dart';
import 'package:meals2/screens/settings.dart';
import 'package:meals2/screens/statistics.dart';
import 'package:meals2/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  List<Meal> _availableMeals() {
    final meals = ref.read(mealsProvider);
    return meals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<void> _setScreen(String identifier) async {
    Navigator.of(context).pop(); // close the drawer

    switch (identifier) {
      case 'meals':
        setState(() {
          _selectedPageIndex = 0;
        });
        break;

      case 'filters':
        final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
            builder: (ctx) => FiltersScreen(
              currentFilters: _selectedFilters,
            ),
          ),
        );
        if (!mounted) return;
        setState(() {
          _selectedFilters = result ?? kInitialFilters;
        });
        break;

      case 'search':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => SearchScreen(availableMeals: _availableMeals()),
          ),
        );
        break;

      case 'quiz':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const QuizCategoryScreen()),
        );
        break;

      case 'statistics':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StatisticsScreen()),
        );
        break;

      case 'settings':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const SettingsScreen()),
        );
        break;

      case 'about':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const AboutScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    ref.watch(mealsProvider); // rebuild if the meals list ever changes

    Widget activePage = CategoriesScreen(availableMeals: _availableMeals());
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeals,
        emptyHint: 'Tap the star on a meal to add it here.',
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}