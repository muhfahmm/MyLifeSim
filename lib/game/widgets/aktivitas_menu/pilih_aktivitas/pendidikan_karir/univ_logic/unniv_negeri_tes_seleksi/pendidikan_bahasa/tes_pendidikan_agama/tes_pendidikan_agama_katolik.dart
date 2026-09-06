import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPendidikanAgamaKatolikQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Kitab Suci & Tradisi Suci Katolik',
      'Sakramen-Sakramen Gereja Katolik',
      'Magisterium & Ajaran Sosial Gereja',
      'Sejarah Gereja & Tokoh Santo/Santa',
      'Moral & Moralitas Kristiani Katolik',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pkat_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Agama Katolik (#${index + 1}): Manakah ajaran teologi & tradisi Katolik mengenai $topic?',
      options: [
        'Pemahaman 7 Sakramen Gereja Katolik',
        'Penghayatan Ajaran Kitab Suci dan Tradisi Apostolik',
        'Penerapan Ajaran Sosial Gereja (ASG) dalam Masyarakat',
        'Teladan Hidup Para Santo/Santa dan Spiritualitas Katolik',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Agama Katolik mengenai $topic.',
    );
  });
}
