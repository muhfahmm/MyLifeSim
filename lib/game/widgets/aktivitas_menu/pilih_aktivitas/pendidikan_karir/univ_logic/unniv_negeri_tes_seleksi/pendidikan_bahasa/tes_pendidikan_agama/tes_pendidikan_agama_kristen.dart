import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPendidikanAgamaKristenQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Alkitab Perjanjian Lama & Perjanjian Baru',
      'Teologi Kristen & Doktrin Trinitas',
      'Etika Kristen & Kasih Sesama',
      'Sejarah Gereja & Reformasi',
      'Pedagogi & Pendidikan Karakter Kristiani',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pak_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Agama Kristen (#${index + 1}): Which Christian theological concept relates to $topic?',
      options: [
        'Pemahaman Ayat Alkitab dan Eksposisinya',
        'Penerapan Etika Kasih dan Pelayanan Masyarakat',
        'Kajian Teologi Doktrinal dan Kredo Gereja',
        'Sejarah Perkembangan Gereja dan Reformasi Tokoh Teologi',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Agama Kristen mengenai $topic.',
    );
  });
}
