import 'package:flutter/material.dart';
// Update the import path to match your actual project folder name: expense_tracker
import 'package:expense_tracker/widgets/custom_metric_card.dart';
import 'package:expense_tracker/widgets/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount = (orientation == Orientation.portrait) ? 2 : 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker Dashboard"),
      ),
      body: ResponsiveLayout(
        mobileLayout: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const CustomMetricCard(
              title: "Total Balance",
              amount: "\$4,250.00",
              icon: Icons.account_balance_wallet,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}