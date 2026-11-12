import 'package:flutter/material.dart';

import '../models/expense.dart';

/// Search field plus a scrolling row of category chips.
class FilterBar extends StatefulWidget {
  const FilterBar({
    super.key,
    required this.query,
    required this.category,
    required this.onQueryChanged,
    required this.onCategoryChanged,
  });

  final String query;
  final Category? category;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<Category?> onCategoryChanged;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late final TextEditingController _text =
      TextEditingController(text: widget.query);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        children: [
          TextField(
            controller: _text,
            onChanged: widget.onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search expenses',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _text.clear();
                        widget.onQueryChanged('');
                      },
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: widget.category == null,
                  onSelected: (_) => widget.onCategoryChanged(null),
                ),
                for (final c in Category.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      avatar: Icon(categoryIcons[c], size: 16),
                      label: Text(c.label),
                      selected: widget.category == c,
                      onSelected: (on) => widget.onCategoryChanged(on ? c : null),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
