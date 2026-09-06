import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikMesinQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Termodinamika & Perpindahan Panas',
      'Mekanika Fluida & Mesin Fluida',
      'Elemen Mesin & Perancangan Mekanikal',
      'Material Teknik & Manufaktur',
      'Sistem Getaran & Dinamika Teknik',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'tm_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Teknik Mesin (#${index + 1}): Manakah konsep atau analisis inti dalam $topic?',
      options: [
        'Hukum Termodinamika & Siklus Energi',
        'Persamaan Bernoulli & Tekanan Fluida',
        'Tegangan Geser & Beban Kelelahan (Fatigue)',
        'Proses Pengecoran & Pengelasan Logam',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar bidang teknik mesin mengenai $topic.',
    );
  });
}
