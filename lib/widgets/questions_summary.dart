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
            final String? userAnswer = data['user_answer'] as String?;
            final bool hasAnswer = userAnswer != null && userAnswer.trim().isNotEmpty;
            final bool isCorrect = hasAnswer && userAnswer == data['correct_answer'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circle Index Number
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color.fromARGB(255, 150, 198, 241)
                          : const Color.fromARGB(255, 249, 133, 241),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      ((data['question_index'] as int) + 1).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 22, 2, 56),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Question and Answers Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Text
                        Text(
                          data['question'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        
                        // User's Answer or "No Answer" Fallback Prompt
                        Text(
                          hasAnswer ? userAnswer : 'No Answer',
                          style: TextStyle(
                            color: hasAnswer
                                ? const Color.fromARGB(255, 202, 171, 252)
                                : Colors.redAccent,
                            fontStyle: hasAnswer
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                        
                        // Correct Answer
                        Text(
                          data['correct_answer'] as String,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 181, 254, 246),
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