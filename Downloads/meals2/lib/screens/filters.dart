import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals2/providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  Widget _switch(
    BuildContext context,
    WidgetRef ref,
    Map<Filter, bool> activeFilters,
    Filter filter,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return SwitchListTile(
      value: activeFilters[filter]!,
      onChanged: (isChecked) {
        ref.read(filtersProvider.notifier).setFilter(filter, isChecked);
      },
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
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
        actions: [
          TextButton(
            onPressed: () => ref.read(filtersProvider.notifier).reset(),
            child: const Text('Reset'),
          ),
        ],
      ),
      body: Column(
        children: [
          _switch(context, ref, activeFilters, Filter.glutenFree,
              'Gluten-free', 'Only include gluten-free meals.'),
          _switch(context, ref, activeFilters, Filter.lactoseFree,
              'Lactose-free', 'Only include lactose-free meals.'),
          _switch(context, ref, activeFilters, Filter.vegetarian,
              'Vegetarian', 'Only include vegetarian meals.'),
          _switch(context, ref, activeFilters, Filter.vegan, 'Vegan',
              'Only include vegan meals.'),
        ],
      ),
    );
  }
}