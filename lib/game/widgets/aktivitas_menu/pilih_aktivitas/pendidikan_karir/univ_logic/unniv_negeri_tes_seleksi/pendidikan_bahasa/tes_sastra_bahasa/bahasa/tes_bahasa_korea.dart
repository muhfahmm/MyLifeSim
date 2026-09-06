import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaKoreaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'TOPIK Test Grammar & Sentence Structure',
      'Korean Conversation & Situational Expressions',
      'Media, Hallyu & Culture Communication',
      'Interpretation & Translation Skills',
      'Business Korean & Formal Correspondence',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_kor_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Korea (#${index + 1}): Manakah penerapan tata bahasa & komunikasi Korea mengenai $topic?',
      options: [
        'Penguasaan Tata Bahasa TOPIK Level 3-4',
        'Ekspresi Percakapan Situasional Komunikatif',
        'Kosakata Komunikasi Bisnis dan Email Resmi Korea',
        'Analisis Teks Media dan Kebudayaan Pop Korea',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan praktis kebahasaan dan komunikasi Korea mengenai $topic.',
    );
  });
}
