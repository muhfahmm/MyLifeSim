import '../tes_seleksi_model.dart';

List<QuestionItem> getAkuntansiQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Persamaan Dasar Akuntansi (Aset = Liabilitas + Ekuitas)',
      'Jurnal Penyesuaian & Siklus Akuntansi',
      'Penyusunan Laporan Laba Rugi & Neraca',
      'Akuntansi Biaya & Harga Pokok Penjualan',
      'Pemeriksaan Laporan Keuangan (Auditing)',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'akt_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Akuntansi (#${index + 1}): Manakah akun yang paling dipengaruhi oleh $topic?',
      options: [
        'Aset Lancar & Kas',
        'Liabilitas & Utang Usaha',
        'Ekuitas Pemilik & Laba Ditahan',
        'Beban Depresiasi & Penyesuaian',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan standar akuntansi keuangan pada $topic.',
    );
  });
}
