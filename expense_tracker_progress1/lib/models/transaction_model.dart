import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum TransactionType { income, expense }
enum Category { all, work, food, bills, travel, leisure, health, shopping }

extension CategoryExtension on Category {
  String get label => name[0].toUpperCase() + name.substring(1);
}

const categoryIcons = {
  Category.all: Icons.all_inclusive_rounded,
  Category.work: Icons.work_rounded,
  Category.food: Icons.lunch_dining_rounded,
  Category.bills: Icons.receipt_long_rounded,
  Category.travel: Icons.flight_takeoff_rounded,
  Category.leisure: Icons.sports_esports_rounded,
  Category.health: Icons.favorite_rounded,
  Category.shopping: Icons.shopping_bag_rounded,
};

class FinancialTransaction {
  FinancialTransaction({
    String? id,
    required this.title,
    required this.cents,
    required this.date,
    required this.category,
    required this.type,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final int cents;
  final DateTime date;
  final Category category;
  final TransactionType type;

  double get amount => cents / 100;
  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
}