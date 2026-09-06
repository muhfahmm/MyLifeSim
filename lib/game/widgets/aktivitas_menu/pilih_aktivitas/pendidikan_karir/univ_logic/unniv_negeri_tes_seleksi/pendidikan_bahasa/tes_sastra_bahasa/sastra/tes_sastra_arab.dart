import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraArabQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Nahwu & Sharaf (Grammar & Inflection)',
      'Balaghah (Bayan, Ma\'ani, Badi\')',
      'Syair Jahiliyah & Klasik Arab',
      'Kajian Prosa & Sastra Arab Modern',
      'Fonologi & Akustik Huruf Hijaiyah',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_arab_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Arab (#${index + 1}): Manakah analisis sastra dan bahasa Arab mengenai $topic?',
      options: [
        'Kajian I\'rab Fi\'il dan Isim dalam Nahwu',
        'Analisis Wazan Fi\'il Mujarrad dan Mazid dalam Sharaf',
        'Keindahan Badi\' dan Majas dalam Balaghah',
        'Struktur Bahr Syair Klasik Arab',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar ilmu Nahwu, Sharaf, Balaghah dan Sastra Arab mengenai $topic.',
    );
  });
}
