import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesLinguistikTerapanQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Sociolinguistics & Language Variation',
      'Psycholinguistics & Language Acquisition',
      'Discourse Analysis & Pragmatics',
      'Translation Studies & Localization',
      'Computational Linguistics & Lexicography',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'ling_ter_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Linguistik Terapan (#${index + 1}): Manakah analisis linguistik terapan mengenai $topic?',
      options: [
        'Kajian Sosiolinguistik dan Variasi Bahasa Masyarakat',
        'Analisis Psikolinguistik dan Pemerolehan Bahasa',
        'Pragmatik, Tindak Tutur, dan Analisis Wacana',
        'Teori Penerjemahan dan Lokalisasi Teks Digital',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Linguistik Terapan dan Penerjemahan mengenai $topic.',
    );
  });
}
