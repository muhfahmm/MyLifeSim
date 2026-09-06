import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdSeniBudayaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Seni Rupa & Gambar Ekspresif Anak',
      'Seni Musik Dasar (Nada, Ritme & Alat Musik)',
      'Seni Tari & Gerak Kreatif Anak',
      'Kerajinan Tangan & Prakarya (Prakarya/Crafting)',
      'Apresiasi Seni & Kebudayaan Tradisional/Global',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_seni_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'PGSD Seni Budaya & Prakarya (#${index + 1}): Manakah konsep pengajaran seni dasar mengenai $topic?',
      options: [
        'Pengenalan Unsur Warna, Garis, dan Bentuk Seni Rupa',
        'Latihan Ritme Ketukan dan Tangga Nada Musik Dasar',
        'Eksplorasi Gerak Tari Sederhana dan Ekspresi Anak',
        'Pembuatan Kerajinan Bahan Alam dan Daur Ulang',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Seni Budaya, Kerajinan Tangan dan Prakarya untuk Pendidikan Dasar mengenai $topic.',
    );
  });
}
