import 'tes_seleksi_model.dart';

List<QuestionItem> getGeneralQuestionsForMajor(String major) {
  return List.generate(100, (index) {
    final String id = 'gen_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Tes Akademik Umum (#${index + 1}): Manakah asas berpikir ilmiah yang benar?',
      options: [
        'Observasi, Hipotesis, dan Eksperimen',
        'Intuisi, Spekulasi, dan Asumsi',
        'Penarikan Kesimpulan Berdasarkan Emosi',
        'Metode Hafalan Tanpa Analisis',
      ],
      correctOptionIndex: 0,
      explanation: 'Metode ilmiah berlandaskan observasi dan eksperimen.',
    );
  });
}
