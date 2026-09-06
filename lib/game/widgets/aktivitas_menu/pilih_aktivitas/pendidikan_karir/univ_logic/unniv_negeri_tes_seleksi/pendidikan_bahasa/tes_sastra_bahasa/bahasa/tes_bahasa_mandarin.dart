import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaMandarinQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'HSK Grammar & Sentence Structures',
      'Mandarin Business Communication & Negotiation',
      'Reading & Writing Practical Hanzi',
      'Audio & Listening Comprehension Nuances',
      'Translation Techniques (Mandarin - Indonesian)',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_man_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Mandarin (#${index + 1}): Manakah penerapan tata bahasa & komunikasi Mandarin mengenai $topic?',
      options: [
        'Penggunaan Tata Bahasa HSK 4-5 dan Kata Pelengkap (Bu Yuyi)',
        'Kosakata Komunikasi Bisnis dan Perdagangan',
        'Analisis Kalimat Struktur Ba (把) dan Bei (被)',
        'Teknik Penerjemahan Teks Ekonomi dan Kebudayaan',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan praktis kebahasaan dan komunikasi Mandarin mengenai $topic.',
    );
  });
}
