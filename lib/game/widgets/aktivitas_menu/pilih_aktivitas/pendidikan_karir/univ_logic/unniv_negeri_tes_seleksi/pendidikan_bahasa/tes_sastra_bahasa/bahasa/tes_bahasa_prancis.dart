import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaPrancisQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'DELF/DALF Standardized Grammar (B1-B2)',
      'Français des Affaires (Business French)',
      'Compréhension Écrite et Orale',
      'Techniques de Traduction et Interprétation',
      'Communication Interculturelle Francophone',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_pra_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Prancis (#${index + 1}): Which French language skill corresponds to $topic?',
      options: [
        'Penerapan Tata Bahasa Standar DELF B1-B2',
        'Kosakata Komunikasi Bisnis Français des Affaires',
        'Strategi Komunikasi Lisan dan Pemahaman Teks',
        'Teknik Penerjemahan Teks Prancis - Indonesia',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan praktis kebahasaan dan komunikasi Prancis mengenai $topic.',
    );
  });
}
