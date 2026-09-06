import 'dart:math';

class QuestionItem {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuestionItem({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}
