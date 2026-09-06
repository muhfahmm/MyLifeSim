class QuestionItem {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuestionItem({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}
