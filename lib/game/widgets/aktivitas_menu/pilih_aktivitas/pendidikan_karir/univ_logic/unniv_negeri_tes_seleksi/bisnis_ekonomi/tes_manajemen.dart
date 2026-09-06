import '../tes_seleksi_model.dart';

List<QuestionItem> getManajemenQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Manajemen Strategis & Analisis SWOT',
      'Manajemen Sumber Daya Manusia (SDM)',
      'Manajemen Pemasaran 4P & Digital',
      'Manajemen Keuangan & BEP',
      'Manajemen Operasional & Rantai Pasok',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'mnj_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Manajemen (#${index + 1}): Manakah strategi utama yang diterapkan pada $topic?',
      options: [
        'Perencanaan Organisasi (Planning & POAC)',
        'Efisiensi Biaya Operasional & BEP',
        'Segmentasi, Targeting & Positioning (STP)',
        'Pengembangan Budaya Organisasi & Kepemimpinan',
      ],
      correctOptionIndex: (index + 2) % 4,
      explanation: 'Strategi pengelolaan manajemen dalam urusan $topic.',
    );
  });
}
