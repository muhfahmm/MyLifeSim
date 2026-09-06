import '../tes_seleksi_model.dart';

List<QuestionItem> getAgroteknologiQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Fotosintesis & Pigmen Klorofil',
      'Nutrisi Tanaman & Unsur NPK',
      'Metode Hidroponik & Media Air',
      'Pengendalian Hama & Penyakit Tanaman',
      'Teknologi Kultur Jaringan',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'agro_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Agroteknologi (#${index + 1}): Manakah faktor paling berpengaruh pada $topic?',
      options: [
        'Kandungan Nitrogen, Fosfor, dan Kalium',
        'Intensitas Cahaya Matahari & Gas CO2',
        'Penyerapan Nutrisi oleh Akar Tanaman',
        'Sterilitas Media & Hormon Sitokinin',
      ],
      correctOptionIndex: (index + 2) % 4,
      explanation: 'Konsep ilmu pertanian modern dan teknologi budidaya pada $topic.',
    );
  });
}
