import 'package:flutter/material.dart';

class MetricCardGrid extends StatelessWidget {
  const MetricCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.1,
      children: [
        _buildCard(
          title: "TOTAL BALANCE",
          value: "\$4,377.31",
          subtitle: "🟢 Healthy net position",
          icon: Icons.account_balance_wallet_rounded,
          iconColor: Colors.tealAccent,
        ),
        _buildCard(
          title: "TOTAL INCOME",
          value: "\$5,150.00",
          subtitle: "2 credit entries",
          icon: Icons.trending_up_rounded,
          iconColor: Colors.greenAccent,
        ),
        _buildCard(
          title: "TOTAL EXPENSES",
          value: "\$772.69",
          subtitle: "6 debit entries",
          icon: Icons.trending_down_rounded,
          iconColor: Colors.pinkAccent,
        ),
        _buildCard(
          title: "SAVINGS RATE",
          value: "85%",
          subtitle: "\$4,377.31 net saved",
          icon: Icons.savings_rounded,
          iconColor: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}