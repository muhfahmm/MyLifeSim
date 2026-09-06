import '../tes_seleksi_model.dart';

List<QuestionItem> getPsikologiQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Teori Kepribadian Freud & Jung',
      'Psikologi Kognitif & Memori',
      'Psikologi Perkembangan Piaget & Erikson',
      'Psikologi Klinis & Gangguan Mental',
      'Pengondisian Klasik Pavlov & Skinner',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'psi_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Psikologi (#${index + 1}): Manakah mekanisme/proses utama dalam $topic?',
      options: [
        'Id, Ego, dan Superego',
        'Aktualisasi Diri & Hirarki Maslow',
        'Persepsi, Sensasi & Atensi',
        'Refleks Kondisi & Penguatan (Reinforcement)',
      ],
      correctOptionIndex: (index + 2) % 4,
      explanation: 'Landasan teori psikologi mengenai dinamika $topic.',
    );
  });
}
