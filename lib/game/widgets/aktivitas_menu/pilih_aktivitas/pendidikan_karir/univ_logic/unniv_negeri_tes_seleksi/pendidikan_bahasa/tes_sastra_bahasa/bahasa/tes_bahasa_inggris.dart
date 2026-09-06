import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaInggrisQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Advanced English Grammar & Tenses',
      'Business Communication & Public Speaking',
      'Translation & Interpretation Principles',
      'Reading Comprehension & Critical Analysis',
      'Academic Writing & Vocabulary in Use',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_ing_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Inggris (#${index + 1}): Which applied linguistic concept fits $topic?',
      options: [
        'Mastery of Conditional Sentences and Subjunctive',
        'Principles of Equivalence in Translation',
        'Formal Business Correspondence and Tone',
        'Identifying Main Ideas and Contextual Inferences',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Applied English language proficiency and skills in $topic.',
    );
  });
}
