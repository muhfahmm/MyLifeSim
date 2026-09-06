import '../tes_seleksi_model.dart';

List<QuestionItem> getHukumQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Hukum Tata Negara & UUD 1945',
      'Hukum Pidana & Unsur Kesalahan',
      'Hukum Perdata & Perjanjian',
      'Hukum Acara & Pembuktian di Pengadilan',
      'Hukum Internasional & Perjanjian Bilateral',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'hkm_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Ilmu Hukum (#${index + 1}): Manakah asas hukum utama yang memayungi $topic?',
      options: [
        'Asas Legalitas & Kepastian Hukum',
        'Presumption of Innocence (Praduga Tak Bersalah)',
        'Pacta Sunt Servanda (Perjanjian Mengikat)',
        'Lex Specialis Derogat Legi Generali',
      ],
      correctOptionIndex: (index + 1) % 4,
      explanation: 'Penerapan doktrin dan asas hukum dalam ranah $topic.',
    );
  });
}
