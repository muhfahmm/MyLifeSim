import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraJepangQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Kanji, Hiragana & Katakana Analysis',
      'Klasik Bungo & Haiku',
      'Sastra Jepang Klasik (Genji Monogatari)',
      'Tata Bahasa & Keigo (Sopan/Hormat)',
      'Budaya & Kebudayaan Sastra Modern Jepang',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_jep_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Jepang (#${index + 1}): Manakah analisis sastra dan bahasa Jepang mengenai $topic?',
      options: [
        'Penggunaan Keigo Sonkeigo dan Kenjougo',
        'Struktur Haiku 5-7-5 dan Kigo',
        'Analisis Radikal Kanji dan Onyomi/Kunyomi',
        'Kajian Karya Sastra Zaman Heian dan Edo',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan kebahasaan Jepang mengenai $topic.',
    );
  });
}
