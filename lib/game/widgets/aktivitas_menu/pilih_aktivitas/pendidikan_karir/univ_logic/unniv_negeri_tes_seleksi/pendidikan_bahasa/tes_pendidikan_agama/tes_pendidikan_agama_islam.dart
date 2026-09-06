import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPendidikanAgamaIslamQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Al-Qur\'an & Ilmu Tafsir Dasar',
      'Hadits & Sunnah Nabi',
      'Fiqih Ibadah & Muamalah',
      'Sejarah Peradaban Islam (Tarikh Khulafaur Rasyidin)',
      'Akidah, Akhlak & Etika Islam',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pai_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Agama Islam (#${index + 1}): Manakah analisis konsep keilmuan Islam mengenai $topic?',
      options: [
        'Kajian Ayat Al-Qur\'an dan Asbabun Nuzul',
        'Pemahaman Fiqih Ibadah dan Tata Cara Pengamalan',
        'Analisis Sejarah Daulah dan Perkembangan Peradaban',
        'Pembinaan Akhlak Mahmudah dan Nilai Multikultural',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Agama Islam mengenai $topic.',
    );
  });
}
