import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikSipilQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Mekanika Tanah & Geoteknik',
      'Struktur Beton Bertulang & Baja',
      'Manajemen Konstruksi & Biaya',
      'Teknik Sumber Daya Air & Irigasi',
      'Rekayasa Jalan Raya & Transportasi',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'ts_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Teknik Sipil (#${index + 1}): Manakah analisis utama dalam $topic?',
      options: [
        'Kuat Tekan & Tegangan Bahan',
        'Stabilitas Pondasi & Daya Dukung Tanah',
        'Rencana Anggaran Biaya (RAB)',
        'Analisis Debit Air & Hidrologi',
      ],
      correctOptionIndex: (index + 1) % 4,
      explanation: 'Konsep dasar yang menjadi fondasi dalam bidang $topic.',
    );
  });
}
