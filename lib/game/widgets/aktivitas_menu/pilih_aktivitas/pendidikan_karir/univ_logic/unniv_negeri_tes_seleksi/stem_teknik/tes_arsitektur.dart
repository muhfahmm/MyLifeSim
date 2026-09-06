import '../tes_seleksi_model.dart';

List<QuestionItem> getArsitekturQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Perancangan Arsitektur & Estetika',
      'Struktur & Konstruksi Bangunan',
      'Sejarah & Teori Arsitektur',
      'Sains Bangunan & Kebisingan/Pencahayaan',
      'Tata Kota & Arsitektur Lanskap',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'ars_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Arsitektur (#${index + 1}): Manakah elemen perancangan utama dalam $topic?',
      options: [
        'Proporsi, Skala & Estetika Ruang',
        'Pencahayaan Alami & Ventilasi Silang',
        'Integrasi Struktur & Material Bangunan',
        'Analisis Tapak & Sirkulasi Lanskap',
      ],
      correctOptionIndex: (index + 2) % 4,
      explanation: 'Prinsip desain dan sains arsitektur pada $topic.',
    );
  });
}
