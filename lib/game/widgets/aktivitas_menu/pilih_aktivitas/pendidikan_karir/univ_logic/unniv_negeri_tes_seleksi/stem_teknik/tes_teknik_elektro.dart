import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikElektroQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Rangkaian Listrik AC/DC & Hukum Ohm',
      'Sistem Tenaga Listrik & Transmisi',
      'Elektronika Analog & Digital',
      'Sistem Kontrol & Robotika',
      'Telekomunikasi & Sinyal',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'te_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Teknik Elektro (#${index + 1}): Manakah hukum/komponen inti dalam $topic?',
      options: [
        'Hukum Kirchhoff & Hukum Ohm',
        'Semikonduktor, Dioda & Transistor',
        'Signal Processing & Frekuensi',
        'Mikrokontroler & Sensor',
      ],
      correctOptionIndex: (index + 2) % 4,
      explanation: 'Pengetahuan penting dalam pemodelan $topic.',
    );
  });
}
