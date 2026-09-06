import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdIpaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Ciri-Ciri Makhluk Hidup & Ekosistem Dasar',
      'Wujud Benda & Perubahan Wujud Zat',
      'Gaya, Energi & Sumber Daya Alam',
      'Sistem Organ Manusia (Pencernaan & Pernapasan Dasar)',
      'Tata Surya & Kehidupan di Bumi',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_ipa_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'PGSD Ilmu Pengetahuan Alam (IPA) (#${index + 1}): Manakah konsep dasar sains SD mengenai $topic?',
      options: [
        'Pengamatan Rantai Makanan dan Hubungan Antarmakhluk Hidup',
        'Analisis Perubahan Wujud Mencair, Membeku, dan Menguap',
        'Konsep Gaya Otot, Gesek, dan Gravitasi Sederhana',
        'Pembelajaran Eksperimen Sains Sederhana untuk Anak',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Ilmu Pengetahuan Alam dan sains dasar untuk Sekolah Dasar mengenai $topic.',
    );
  });
}
