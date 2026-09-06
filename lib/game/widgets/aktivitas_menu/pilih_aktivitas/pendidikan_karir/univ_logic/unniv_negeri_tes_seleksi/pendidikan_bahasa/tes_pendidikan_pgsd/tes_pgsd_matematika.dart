import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdMatematikaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Operasi Hitung Dasar (Penjumlahan, Pengurangan, Perkalian, Pembagian)',
      'Geometri Dasar & Bangun Datar/Ruang Sederhana',
      'Pecahan, Desimal & Persentase Dasar',
      'Pengukuran (Waktu, Panjang, Berat, dan Luas)',
      'Metode Pembelajaran Matematika Konkret untuk Anak',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_mat_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'PGSD Matematika (#${index + 1}): Manakah konsep dasar matematika dasar/pedagogi matematika mengenai $topic?',
      options: [
        'Penggunaan Alat Peraga Konkret dan Manipulatif',
        'Penghitungan Luas dan Keliling Bangun Datar',
        'Konversi Satuan Pengukuran dan Operasi Pecahan',
        'Strategi Pemecahan Masalah Soal Cerita Dasar',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar matematika dan metode pengajarannya untuk Sekolah Dasar mengenai $topic.',
    );
  });
}
