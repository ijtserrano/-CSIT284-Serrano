import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            // Check if the user answered or missed/timed out
            final userAnswer = data['user_answer'] as String;
            final isMissed = userAnswer == 'TIMEOUT' || userAnswer.isEmpty;

            // Colors matching the progress sidebar badges
            final circleColor = isMissed 
                ? const Color(0xFFD8F3DC) // Light Green for Missed
                : const Color(0xFF4EAB81); // Dark Green for Answered

            final textColor = isMissed 
                ? const Color(0xFF1B4332) // Dark forest green text on light background
                : Colors.white; // White text on dark green background

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic Colored Number Circle
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      ((data['question_index'] as int) + 1).toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['question'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          isMissed ? 'Missed (Timeout)' : userAnswer,
                          style: TextStyle(
                            color: isMissed 
                                ? Colors.redAccent.shade100 
                                : Colors.white70,
                            fontWeight: isMissed ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                        Text(
                          data['correct_answer'] as String,
                          style: const TextStyle(
                            color: Color(0xFF52B788),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}