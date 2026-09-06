import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaJepangQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'JLPT Grammar Standards (Bunpou)',
      'Dokkai (Reading Comprehension) & News Japanese',
      'Choukai (Listening) & Conversational Nuances',
      'Kanji & Vocabulary in Context (Goi)',
      'Intercultural Business Communication in Japan',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_jep_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Jepang (#${index + 1}): Manakah penerapan tata bahasa & komunikasi Jepang mengenai $topic?',
      options: [
        'Penggunaan Partikel (Joshi) dan Tata Bahasa JLPT N3-N2',
        'Analisis Wacana Berita dan Artikel Bahasa Jepang',
        'Etika Komunikasi Bisnis dan Keigo Praktis',
        'Strategi Penafsiran Kanji Gabungan (Jukugo)',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan praktis kebahasaan dan komunikasi Jepang mengenai $topic.',
    );
  });
}
