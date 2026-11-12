import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction_model.dart';

class CategoryFilterBar extends StatelessWidget {
  final Category selectedCategory;
  final ValueChanged<Category> onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: Category.values.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category.label),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              selectedColor: const Color(0xFF00F2FE),
              backgroundColor: const Color(0xFF131B2E),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF00F2FE)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
