import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaJermanQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Goethe-Zertifikat B1/B2 Grammar & Syntax',
      'Wirtschaftsdeutsch (Business German)',
      'German Reading Comprehension & Text Analysis',
      'Translation & Intercultural Communication',
      'Listening & Everyday Conversational Skills',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_jer_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Jerman (#${index + 1}): Which applied German language skill corresponds to $topic?',
      options: [
        'Penerapan Tata Bahasa Sertifikat Goethe B1-B2',
        'Kosakata Komunikasi Bisnis Wirtschaftsdeutsch',
        'Teknik Penerjemahan dan Komunikasi Antar-Budaya',
        'Analisis Wacana Teks Berita dan Media Jerman',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan praktis kebahasaan dan komunikasi Jerman mengenai $topic.',
    );
  });
}
