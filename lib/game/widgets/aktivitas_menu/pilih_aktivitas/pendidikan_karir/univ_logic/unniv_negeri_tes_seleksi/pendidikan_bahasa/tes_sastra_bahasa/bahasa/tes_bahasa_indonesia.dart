import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaIndonesiaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Ejaan Bahasa Indonesia yang Disempurnakan (EYD/PUEBI)',
      'Sintaksis & Pembentukan Kalimat Efektif',
      'Analisis Paragraf & Ide Pokok',
      'Penulisan Karya Tulis Ilmiah & Sitasi',
      'Linguistik Terapan & Komunikasi Publik',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_indo_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Indonesia (#${index + 1}): Manakah penerapan tata bahasa & komunikasi dalam $topic?',
      options: [
        'Kaidah Penulisan Kata Serapan dan Huruf Kapital EYD',
        'Syarat Kalimat Efektif: Keparalelan dan Kehematan Kata',
        'Penentuan Kalimat Utama dan Gagasan Utama Paragraf',
        'Teknik Penyuntingan Teks Ilmiah dan Daftar Pustaka',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan tata bahasa dan komunikasi praktis Bahasa Indonesia mengenai $topic.',
    );
  });
}
