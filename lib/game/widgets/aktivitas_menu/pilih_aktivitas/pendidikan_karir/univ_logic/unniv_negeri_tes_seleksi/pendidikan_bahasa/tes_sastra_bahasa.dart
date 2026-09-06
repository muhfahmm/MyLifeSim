import '../tes_seleksi_model.dart';

List<QuestionItem> getSastraBahasaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Sintaksis & Tata Kalimat',
      'Semantik & Makna Kata',
      'Morfologi & Proses Afiksasi',
      'Fonologi & Sistem Bunyi',
      'Kajian Karya Sastra & Majas',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'sas_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Sastra & Bahasa (#${index + 1}): Manakah analisis kebahasaan dalam $topic?',
      options: [
        'Struktur Frasa & Klausa',
        'Imbuhan & Pembentukan Kata Baru',
        'Gaya Bahasa & Personifikasi',
        'Pembeda Bunyi & Fonemik',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar linguistik dan sastra mengenai $topic.',
    );
  });
}
