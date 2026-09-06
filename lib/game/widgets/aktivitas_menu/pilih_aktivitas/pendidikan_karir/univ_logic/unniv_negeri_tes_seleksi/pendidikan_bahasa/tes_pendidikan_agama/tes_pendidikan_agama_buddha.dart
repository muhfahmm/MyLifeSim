import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPendidikanAgamaBuddhaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Empat Kebenaran Mulia (Ariya Sacca)',
      'Jalan Mulia Berunsur Delapan (Atthangika Magga)',
      'Kitab Suci Tripitaka (Sutta, Vinaya, Abhidhamma)',
      'Hukum Karma, Anicca, Dukkha & Anatta',
      'Meditasi (Samatha & Vipassana) & Etika Sila',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pab_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Agama Buddha (#${index + 1}): Manakah ajaran Dhamma mengenai $topic?',
      options: [
        'Pemahaman Empat Kebenaran Mulia dan Jalan Mulia Berunsur Delapan',
        'Struktur dan Pembagian Kitab Suci Tripitaka',
        'Praktik Meditasi dan Pengembangan Sila (Etika)',
        'Hukum Sebab Akibat (Patticcasamuppada) dan Karma',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Agama Buddha dan ajaran Buddhis mengenai $topic.',
    );
  });
}
