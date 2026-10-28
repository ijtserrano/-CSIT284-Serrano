class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}