import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikKimiaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Neraca Massa & Energi',
      'Termodinamika Teknik Kimia',
      'Teknik Reaksi Kimia & Reaktor',
      'Operasi Teknik Kimia & Distilasi',
      'Kinetika & Perancangan Pabrik',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'tk_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Teknik Kimia (#${index + 1}): Apakah prinsip dasar pemrosesan industri pada $topic?',
      options: [
        'Hukum Kekekalan Massa & Energi',
        'Kesetimbangan Fasa & Distilasi',
        'Kinetika Laju Reaksi & Katalisator',
        'Transfer Massa & Absorpsi Gas',
      ],
      correctOptionIndex: (index + 1) % 4,
      explanation: 'Pemahaman rekayasa proses kimia industri pada $topic.',
    );
  });
}
