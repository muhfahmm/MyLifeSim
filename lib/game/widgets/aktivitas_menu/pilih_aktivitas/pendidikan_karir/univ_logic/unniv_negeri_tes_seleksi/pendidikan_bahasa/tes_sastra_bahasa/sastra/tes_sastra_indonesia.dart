import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraIndonesiaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Puisi & Pantun Klasik',
      'Prosa, Novel & Cerpen Indonesia',
      'Sintaksis & Tata Bahasa Indonesia',
      'Semantik & Majas Bahasa Indonesia',
      'Sejarah Sastra Indonesia (Pujangga Baru s.d. Modern)',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_indo_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Indonesia (#${index + 1}): Manakah analisis sastra dan bahasa terkait $topic?',
      options: [
        'Analisis Struktur Fonem dan Morfem',
        'Gaya Bahasa Personifikasi dan Metafora',
        'Kajian Tokoh, Alur, dan Amanat Novel',
        'Perkembangan Angkatan Sastra Indonesia',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan kebahasaan Indonesia mengenai $topic.',
    );
  });
}
