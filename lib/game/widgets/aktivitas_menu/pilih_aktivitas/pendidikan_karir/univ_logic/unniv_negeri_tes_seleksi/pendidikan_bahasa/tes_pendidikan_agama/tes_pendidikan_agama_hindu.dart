import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPendidikanAgamaHinduQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Kitab Suci Veda & Upanishad',
      'Panca Sradha (Lima Keyakinan Dasar Hindu)',
      'Tri Hita Karana & Nilai Keseimbangan Hidup',
      'Catur Purusartha & Karma Phala',
      'Etika & Upacara Yadnya Hindu',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pah_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Agama Hindu (#${index + 1}): Manakah filosofi & ajaran Hindu mengenai $topic?',
      options: [
        'Pemahaman Panca Sradha (Brahman, Atman, Karma, Samsara, Moksha)',
        'Penerapan Filosofi Tri Hita Karana dalam Kehidupan',
        'Pendalaman Kitab Veda, Itihasa, dan Bhagavadgita',
        'Pelaksanaan Etika Tata Susila dan Yadnya',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Agama Hindu mengenai $topic.',
    );
  });
}
