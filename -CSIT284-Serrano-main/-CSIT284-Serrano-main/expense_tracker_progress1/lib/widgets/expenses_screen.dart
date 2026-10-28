import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/common/responsive_container.dart';
import 'package:expense_tracker/widgets/expenses/expense_summary_card.dart';
import 'package:expense_tracker/widgets/expenses/budget_progress_card.dart';
import 'package:expense_tracker/widgets/expenses/expense_tile.dart';
import 'package:expense_tracker/widgets/expenses/category_filter_bar.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  Category? _selectedCategory;
  final double _monthlyBudgetLimit = 1000.00;

  final List<Expense> _registeredExpenses = [
    Expense(
      id: 'e1',
      title: 'Whole Foods Market',
      cents: 4550,
      date: DateTime.now(),
      category: Category.groceries,
    ),
    Expense(
      id: 'e2',
      title: 'Gasoline Refill',
      cents: 3000,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      id: 'e3',
      title: 'Netflix Subscription',
      cents: 1599,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.leisure,
    ),
    Expense(
      id: 'e4',
      title: 'Doctor Appointment',
      cents: 8500,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.health,
    ),
  ];

  List<Expense> get _filteredExpenses {
    if (_selectedCategory == null) return _registeredExpenses;
    return _registeredExpenses
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  double get _totalExpenses {
    return _registeredExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _removeExpense(String id) {
    setState(() {
      _registeredExpenses.removeWhere((expense) => expense.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Expense Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: ResponsiveContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLandscape
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ExpenseSummaryCard(
                              totalAmount: _totalExpenses,
                              totalTransactions: _registeredExpenses.length,
                            ),
                            const SizedBox(height: 16),
                            BudgetProgressCard(
                              currentSpending: _totalExpenses,
                              budgetLimit: _monthlyBudgetLimit,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryFilterBar(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Expanded(child: _buildExpenseList()),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpenseSummaryCard(
                      totalAmount: _totalExpenses,
                      totalTransactions: _registeredExpenses.length,
                    ),
                    const SizedBox(height: 12),
                    BudgetProgressCard(
                      currentSpending: _totalExpenses,
                      budgetLimit: _monthlyBudgetLimit,
                    ),
                    const SizedBox(height: 20),
                    CategoryFilterBar(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: _buildExpenseList()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    final listToDisplay = _filteredExpenses;

    if (listToDisplay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            const Text(
              "No expenses match your selection.",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: listToDisplay.length,
      itemBuilder: (context, index) {
        final expense = listToDisplay[index];
        return ExpenseTile(
          expense: expense,
          onDelete: () => _removeExpense(expense.id),
        );
      },
    );
  }
}