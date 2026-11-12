import 'package:flutter/material.dart';
import 'package:meals2/data/dummy_data.dart';
import 'package:meals2/models/meal.dart';
import 'package:meals2/providers/favorites_store.dart';
import 'package:meals2/screens/categories.dart';
import 'package:meals2/screens/filters.dart';
import 'package:meals2/screens/meals.dart';
import 'package:meals2/screens/search.dart';
import 'package:meals2/screens/settings.dart';
import 'package:meals2/widgets/main_drawer.dart';
import 'package:meals2/screens/about.dart';
import 'package:meals2/screens/quiz_category.dart';
import 'package:meals2/screens/statistics.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  Map<Filter, bool> _selectedFilters = {...kInitialFilters};

  List<Meal> get _availableMeals => dummyMeals.where((meal) {
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

  Future<void> _openFilters() async {
    final result = await Navigator.of(context).push<Map<Filter, bool>>(
      MaterialPageRoute(
        builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters),
      ),
    );
    if (result != null) {
      setState(() => _selectedFilters = result);
    }
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SearchScreen(availableMeals: _availableMeals),
      ),
    );
  }

    void _setScreen(String identifier) {
    Navigator.of(context).pop(); // close the drawer
    switch (identifier) {
      case 'search':
        _openSearch();
      case 'filters':
        _openFilters();
      case 'quiz':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const QuizCategoryScreen()),
        );
      case 'statistics':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StatisticsScreen()),
        );
      case 'settings':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const SettingsScreen()),
        );
      case 'about':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const AboutScreen()),
        );
      default:
        setState(() => _selectedPageIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavoritesTab = _selectedPageIndex == 1;

    final Widget activePage = isFavoritesTab
        ? ListenableBuilder(
            listenable: favoritesStore,
            builder: (context, _) => MealsScreen(
              meals: favoritesStore.meals,
              emptyHint: 'Tap the star on a meal to save it here.',
            ),
          )
        : CategoriesScreen(availableMeals: _availableMeals);

    return Scaffold(
      appBar: AppBar(
        title: Text(isFavoritesTab ? 'Your Favorites' : 'Pick your category'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _selectedPageIndex = index),
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