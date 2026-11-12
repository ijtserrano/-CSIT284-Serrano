import 'package:flutter/material.dart';

class QuestionIdentifier extends StatelessWidget {
  const QuestionIdentifier({
    super.key,
    required this.questionIndex,
    required this.isCorrectAnswer,
  });

  final int questionIndex;
  final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    final questionNumber = questionIndex + 1;

    // Dark Green for answered/correct, Light Green for missed/incorrect
    final circleColor = isCorrectAnswer
        ? const Color(0xFF4EAB81) // Dark Green
        : const Color(0xFFD8F3DC); // Light Green

    final textColor = isCorrectAnswer
        ? Colors.white
        : const Color(0xFF1B4332); // Dark Forest Green Text

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        questionNumber.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}