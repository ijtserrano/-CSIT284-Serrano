import 'package:flutter/material.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late Map<Filter, bool> _filters;

  @override
  void initState() {
    super.initState();
    _filters = {...widget.currentFilters};
  }

  Widget _switch(Filter filter, String title, String subtitle) {
    final theme = Theme.of(context);
    return SwitchListTile(
      value: _filters[filter]!,
      onChanged: (isChecked) => setState(() => _filters[filter] = isChecked),
      title: Text(
        title,
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.labelMedium!.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      activeThumbColor: theme.colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _filters = {...kInitialFilters};
            }),
            child: const Text('Reset'),
          ),
        ],
      ),
      // Returns the chosen filters to whoever opened this screen.
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(context).pop(_filters);
        },
        child: Column(
          children: [
            _switch(Filter.glutenFree, 'Gluten-free',
                'Only include gluten-free meals.'),
            _switch(Filter.lactoseFree, 'Lactose-free',
                'Only include lactose-free meals.'),
            _switch(Filter.vegetarian, 'Vegetarian',
                'Only include vegetarian meals.'),
            _switch(Filter.vegan, 'Vegan', 'Only include vegan meals.'),
          ],
        ),
      ),
    );
  }
}