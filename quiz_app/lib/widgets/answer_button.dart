import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onTap,
    this.isSelected = false,
  });

  final String answerText;
  final void Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const highlightColor = Color.fromARGB(255, 234, 224, 255);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: highlightColor,
          backgroundColor: const Color.fromARGB(255, 43, 5, 92),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? highlightColor : Colors.transparent,
                border: Border.all(
                  color: highlightColor,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                answerText,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}