class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  final String text;
  // The first answer in the list is always the correct one.
  // We shuffle a copy of this list when displaying the answers.
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
