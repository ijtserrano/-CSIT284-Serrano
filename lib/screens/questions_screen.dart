import 'dart:async';
import 'package:flutter/material.dart';

import 'package:quiz_app/data/questions.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
  });

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  static const int maxSeconds = 20;
  int secondsRemaining = maxSeconds;
  Timer? timer;

  String? selectedAnswer;
  List<String> currentShuffledAnswers = [];
  
  // Track status of each question ('answered' or 'timeout')
  final List<String> questionStatuses = [];

  @override
  void initState() {
    super.initState();
    _loadQuestionAnswers();
    startTimer();
  }

  void _loadQuestionAnswers() {
    currentShuffledAnswers =
        questions[currentQuestionIndex].getShuffledAnswers();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        // Time expired! Record as timeout ("Missed") and advance
        handleTimeout();
      }
    });
  }

  void resetTimer() {
    secondsRemaining = maxSeconds;
    selectedAnswer = null;
    _loadQuestionAnswers();
    startTimer();
  }

  void chooseAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void handleTimeout() {
    timer?.cancel();

    questionStatuses.add('timeout');
    widget.onSelectAnswer('TIMEOUT');

    _advanceOrFinish();
  }

  void goToNextQuestion() {
    timer?.cancel();

    // Answered before time ran out
    questionStatuses.add('answered');
    widget.onSelectAnswer(selectedAnswer ?? 'TIMEOUT');

    _advanceOrFinish();
  }

  void _advanceOrFinish() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        resetTimer();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final seconds = secondsRemaining.toString().padLeft(2, '0');
    return '00:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final bool hasSelectedAnswer = selectedAnswer != null;

    return Scaffold(
      backgroundColor: const Color(0xFF5B118C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- LEFT SIDE: Vertical Progress Sidebar ---
              Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ...List.generate(questions.length, (index) {
                        final isCompleted = index < currentQuestionIndex;
                        final isCurrent = index == currentQuestionIndex;
                        final status = isCompleted ? questionStatuses[index] : 'pending';

                        // Dynamic background color based on completion state
                        Color badgeColor = Colors.white.withValues(alpha: 0.15);
                        if (isCompleted) {
                          badgeColor = status == 'answered'
                              ? Colors.greenAccent
                              : Colors.redAccent; // Red background for Missed / Timeout
                        } else if (isCurrent) {
                          badgeColor = const Color(0xFF7B1FA2);
                        }

                        return Column(
                          children: [
                            // Question Step Badge
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: isCompleted
                                    ? Text(
                                        status == 'answered'
                                            ? 'Answered'
                                            : 'Missed', // Displays "Missed" for timeouts
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: status == 'answered'
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        'Question ${index + 1}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isCurrent
                                              ? Colors.white
                                              : Colors.white60,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            // Connecting Line
                            if (index < questions.length - 1)
                              Container(
                                width: 2,
                                height: 20,
                                color: isCompleted
                                    ? (status == 'answered'
                                        ? Colors.greenAccent
                                        : Colors.redAccent)
                                    : Colors.white.withValues(alpha: 0.2),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // --- RIGHT SIDE: Timer, Question & Fixed Answer List ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Timer
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formattedTime,
                        style: TextStyle(
                          color: secondsRemaining <= 5
                              ? Colors.redAccent
                              : Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Question Card Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        currentQuestion.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fixed Answer List
                    Expanded(
                      child: ListView(
                        children: currentShuffledAnswers.map((answer) {
                          final isSelected = selectedAnswer == answer;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => chooseAnswer(answer),
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF7B1FA2)
                                      : const Color(0xFF4A0E74),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        answer,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Faded/Disabled Next Question Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: hasSelectedAnswer ? goToNextQuestion : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          disabledBackgroundColor: Colors.white.withValues(alpha: 0.3),
                          foregroundColor: const Color(0xFF5B118C),
                          disabledForegroundColor:
                              const Color(0xFF5B118C).withValues(alpha: 0.4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          currentQuestionIndex == questions.length - 1
                              ? 'Finish Quiz'
                              : 'Next Question',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}