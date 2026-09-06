import '../tes_seleksi_model.dart';

List<QuestionItem> getFarmasiQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Farmakokinetika (ADME)',
      'Farmakognosi & Bahan Alam',
      'Kimia Farmasi & Formulasi',
      'Farmakologi Klinik & Dosis Obat',
      'Teknologi Sediaan Padat & Cair',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'far_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Farmasi (#${index + 1}): Apakah faktor paling menentukan dalam $topic?',
      options: [
        'Ketersediaan Hayati (Bioavailabilitas)',
        'Kelarutan & Stabilitas Bahan Aktif',
        'Efek Samping & Interaksi Obat',
        'Tingkat Keamanan Dosis Maksimum',
      ],
      correctOptionIndex: (index + 1) % 4,
      explanation: 'Konsep dasar kefarmasian pada bidang $topic.',
    );
  });
}
