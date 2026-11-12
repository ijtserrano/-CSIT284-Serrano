import 'package:flutter/material.dart';

class SmartAnalysisCard extends StatelessWidget {
  const SmartAnalysisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, color: Colors.purpleAccent, size: 20),
              SizedBox(width: 8),
              Text(
                "Smart Analysis",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "You spent 41% of total expenses on Travel (\$320.00). Consider tracking this category closely!",
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: Colors.purpleAccent, size: 14),
              SizedBox(width: 6),
              Text(
                "Automatic breakdown",
                style: TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}