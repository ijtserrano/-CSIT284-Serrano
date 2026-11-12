import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals2/providers/favorite_meals_provider.dart';
import 'package:meals2/providers/filters_provider.dart';
import 'package:meals2/screens/about.dart';
import 'package:meals2/screens/categories.dart';
import 'package:meals2/screens/filters.dart';
import 'package:meals2/screens/meals.dart';
import 'package:meals2/screens/quiz_category.dart';
import 'package:meals2/screens/search.dart';
import 'package:meals2/screens/settings.dart';
import 'package:meals2/screens/statistics.dart';
import 'package:meals2/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop(); // close the drawer

    switch (identifier) {
      case 'meals':
        setState(() {
          _selectedPageIndex = 0;
        });
        break;

      case 'filters':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
        );
        break;

      case 'search':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => SearchScreen(
              availableMeals: ref.read(filteredMealsProvider),
            ),
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
    final availableMeals = ref.watch(filteredMealsProvider);
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    Widget activePage = CategoriesScreen(availableMeals: availableMeals);
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