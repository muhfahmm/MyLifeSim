import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraMandarinQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Goresan & Radikal Hanzi',
      'Pinyin & Nada (Tone 1-4)',
      'Puisi Dinasti Tang & Song',
      'Klasik Sastra Tiongkok (Empat Karya Agung)',
      'Tata Bahasa Sintaksis Mandarin',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_man_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Mandarin / China (#${index + 1}): Manakah analisis sastra dan bahasa Mandarin mengenai $topic?',
      options: [
        'Struktur Hanzi Tradisional dan Sederhana',
        'Analisis Puisi Tang (Lushi dan Jueju)',
        'Perubahan Nada (Tone Sandhi) Pinyin',
        'Kajian Klasik San Guo Yan Yi dan Xi You Ji',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan kebahasaan Mandarin mengenai $topic.',
    );
  });
}
