import 'package:flutter/material.dart';
import '../../models/expense.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon(this.category, {super.key});

  final Category category;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (category) {
      case Category.food:
        iconData = Icons.fastfood;
        break;
      case Category.groceries:
        iconData = Icons.shopping_cart;
        break;
      case Category.travel:
        iconData = Icons.flight;
        break;
      case Category.leisure:
        iconData = Icons.movie;
        break;
      case Category.bills:
        iconData = Icons.receipt;
        break;
      case Category.health:
        iconData = Icons.medical_services;
        break;
      case Category.work:
        iconData = Icons.work;
        break;
    }
    return Icon(iconData);
  }
}