import '../tes_seleksi_model.dart';

List<QuestionItem> getKedokteranQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Anatomi Manusia & Fisiologi Organ',
      'Farmakologi & Terapi Obat',
      'Patologi & Diagnosis Penyakit',
      'Sistem Kardiovaskular & Respirasi',
      'Neurologi & Sistem Saraf Pusat',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'med_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Kedokteran (#${index + 1}): Manakah patologi/mekanisme utama dalam $topic?',
      options: [
        'Sirkulasi Darah & Hemofilia',
        'Metabolisme Insulin & Diabetes',
        'Fungsi Paru & Pertukaran Gas',
        'Refleks Saraf & Sinapsis Neuron',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Pemahaman medis mengenai $topic.',
    );
  });
}
