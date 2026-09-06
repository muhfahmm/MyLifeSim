import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdIpsQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Geografi Dasar & Kenampakan Alam/Buatan',
      'Kegiatan Ekonomi Dasar (Produksi, Distribusi, Konsumsi)',
      'Sejarah Dasar & Peradaban Dunia',
      'Keragaman Sosial, Budaya & Interaksi Masyarakat',
      'Peta, Denah & Skala Sederhana',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_ips_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'PGSD Ilmu Pengetahuan Sosial (IPS) (#${index + 1}): Manakah konsep dasar pengetahuan sosial mengenai $topic?',
      options: [
        'Membaca Denah, Simbol Peta, dan Mata Angin',
        'Pemahaman Peran Produsen, Distributor, dan Konsumen',
        'Kajian Interaksi Sosial dan Adaptasi Lingkungan',
        'Penanaman Nilai-Nilai Toleransi Sosial & Budaya',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Ilmu Pengetahuan Sosial untuk Sekolah Dasar mengenai $topic.',
    );
  });
}
