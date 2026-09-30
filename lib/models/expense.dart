import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { food, groceries, travel, leisure, bills, health, work }

extension CategoryLabel on Category {
  String get label => name[0].toUpperCase() + name.substring(1);
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.groceries: Icons.shopping_cart,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.bills: Icons.receipt_long,
  Category.health: Icons.health_and_safety,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    String? id,
    required this.title,
    required this.cents,
    required this.date,
    required this.category,
    DateTime? createdAt,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Expense.fromJson(Map<String, dynamic> j) {
    final date = DateTime.parse(j['date'] as String);
    return Expense(
      id: j['id'] as String,
      title: j['title'] as String,
      cents: (j['cents'] as num).toInt(),
      date: date,
      category: Category.values.byName(j['category'] as String),
      createdAt: DateTime.tryParse((j['createdAt'] as String?) ?? '') ?? date,
    );
  }

  final String id;
  final String title;
  final int cents;
  final DateTime date;
  final Category category;
  final DateTime createdAt;

  double get amount => cents / 100;

  String get formattedDate => DateFormat.yMMMd().format(date);

  Expense copyWith({
    String? title,
    int? cents,
    DateTime? date,
    Category? category,
  }) =>
      Expense(
        id: id,
        title: title ?? this.title,
        cents: cents ?? this.cents,
        date: date ?? this.date,
        category: category ?? this.category,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cents': cents,
        'date': date.toIso8601String(),
        'category': category.name,
        'createdAt': createdAt.toIso8601String(),
      };
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> all, this.category)
      : expenses = all.where((e) => e.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);
}
