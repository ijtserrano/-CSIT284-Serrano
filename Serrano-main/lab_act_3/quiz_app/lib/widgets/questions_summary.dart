import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/question_identifier.dart';

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
            final userAnswer = data['user_answer'] as String;
            final correctAnswer = data['correct_answer'] as String;
            
            final isCorrect = userAnswer == correctAnswer;
            final isTimeout = userAnswer == 'TIMEOUT';
            final isAnswered = !isTimeout && userAnswer.isNotEmpty;

            // Determine text color based on status
            Color answerTextColor;
            if (isCorrect) {
              answerTextColor = const Color(0xFF52B788); // Light green for correct
            } else if (isTimeout) {
              answerTextColor = const Color(0xFFFFB703); // Timer Amber-Orange for TIMEOUT
            } else {
              answerTextColor = const Color(0xFFE57373); // Coral Red for incorrect selected answers
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionIdentifier(
                    questionIndex: data['question_index'] as int,
                    isCorrectAnswer: isAnswered,
                  ),
                  const SizedBox(width: 20),
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
                        // User's Answer or TIMEOUT string
                        Text(
                          userAnswer,
                          style: TextStyle(
                            color: answerTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Correct Answer
                        Text(
                          correctAnswer,
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