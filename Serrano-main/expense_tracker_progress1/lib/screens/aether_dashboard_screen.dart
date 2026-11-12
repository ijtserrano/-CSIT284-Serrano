import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/widgets/common/responsive_container.dart';
import 'package:expense_tracker/widgets/dashboard/aether_header_card.dart';
import 'package:expense_tracker/widgets/dashboard/metric_card_grid.dart';
import 'package:expense_tracker/widgets/dashboard/smart_analysis_card.dart';
import 'package:expense_tracker/widgets/dashboard/transaction_history_list.dart';
import 'package:expense_tracker/widgets/dashboard/category_filter_bar.dart';

class AetherDashboardScreen extends StatefulWidget {
  const AetherDashboardScreen({super.key});

  @override
  State<AetherDashboardScreen> createState() => _AetherDashboardScreenState();
}

class _AetherDashboardScreenState extends State<AetherDashboardScreen> {
  Category _selectedCategory = Category.all;

  final List<FinancialTransaction> _allTransactions = [
    FinancialTransaction(
      title: "Tech Salary Deposit",
      cents: 420000,
      date: DateTime(2026, 10, 17),
      category: Category.work,
      type: TransactionType.income,
    ),
    FinancialTransaction(
      title: "Organic Market Purchase",
      cents: 14250,
      date: DateTime(2026, 10, 16),
      category: Category.food,
      type: TransactionType.expense,
    ),
    FinancialTransaction(
      title: "Electric & Internet Utility",
      cents: 8520,
      date: DateTime(2026, 10, 14),
      category: Category.bills,
      type: TransactionType.expense,
    ),
    FinancialTransaction(
      title: "Flight Ticket Reservation",
      cents: 32000,
      date: DateTime(2026, 10, 11),
      category: Category.travel,
      type: TransactionType.expense,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter transactions based on selected category chip
    final filteredTransactions = _selectedCategory == Category.all
        ? _allTransactions
        : _allTransactions.where((tx) => tx.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveContainer(
            maxWidth: 1000,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AetherHeaderCard(),
                  const SizedBox(height: 20),
                  const MetricCardGrid(),
                  const SizedBox(height: 20),
                  const SmartAnalysisCard(),
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
                  TransactionHistoryList(transactions: filteredTransactions),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}