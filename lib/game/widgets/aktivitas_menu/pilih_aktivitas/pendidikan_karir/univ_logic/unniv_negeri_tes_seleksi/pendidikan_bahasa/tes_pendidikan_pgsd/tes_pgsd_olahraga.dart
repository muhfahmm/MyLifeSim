import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdOlahragaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Gerak Lokomotor, Non-Lokomotor & Manipulatif',
      'Kebugaran Jasmani & Kesehatan Anak SD',
      'Permainan Olahraga Senam & Bola Besar/Kecil Sederhana',
      'Pendidikan Kesehatan, Nutrisi & Higiene Diri',
      'Keselamatan & Pertolongan Pertama (P3K) dalam Olahraga',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_olahr_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'PGSD Jasmani & Olahraga (#${index + 1}): Manakah konsep pendidikan jasmani dasar mengenai $topic?',
      options: [
        'Pengembangan Pola Gerak Dasar Lokomotor dan Manipulatif',
        'Pembiasaan Hidup Sehat, Kebersihan, dan Nutrisi Seimbang',
        'Aturan Permainan Olahraga Modifikasi untuk Anak',
        'Pertolongan Pertama pada Cedera Olahraga Ringan',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Jasmani, Olahraga, dan Kesehatan (PJOK) SD mengenai $topic.',
    );
  });
}
