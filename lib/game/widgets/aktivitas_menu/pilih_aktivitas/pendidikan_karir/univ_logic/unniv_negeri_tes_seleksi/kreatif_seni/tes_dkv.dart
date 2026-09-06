import '../tes_seleksi_model.dart';

List<QuestionItem> getDkvQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Teori Warna CMYK vs RGB',
      'Tipografi & Anatomi Huruf',
      'Desain Grafis Vektor vs Raster',
      'Komposisi Visual & Rule of Thirds',
      'Branding & Perancangan Logo',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'dkv_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Desain Komunikasi Visual (#${index + 1}): Manakah elemen dasar dalam $topic?',
      options: [
        'Kerapatan Piksel & PPI/DPI',
        'Format SVG, AI, dan Gambar Vektor',
        'Keseimbangan Komposisi Visual (Balance)',
        'Hierarki Huruf & Kerning Tipografi',
      ],
      correctOptionIndex: (index + 1) % 4,
      explanation: 'Pemahaman elemen seni dan desain visual pada $topic.',
    );
  });
}
