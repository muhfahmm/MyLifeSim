import '../tes_seleksi_model.dart';

List<QuestionItem> getSistemInformasiQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Analisis & Perancangan Sistem',
      'Manajemen Basis Data & ERD',
      'Enterprise Resource Planning (ERP)',
      'Business Intelligence & Big Data',
      'Tata Kelola TI (IT Governance)',
    ];
    final String topic = topics[index % topics.length];
    final String id = 'si_${(index + 1).toString().padLeft(3, '0')}';
    return QuestionItem(
      id: id,
      questionText: 'Sistem Informasi (#${index + 1}): Manakah komponen penting dalam $topic?',
      options: [
        'Model Konseptual & Aliran Data',
        'Infrastruktur Jaringan & Server',
        'Kebutuhan Bisnis & Pengguna',
        'Evaluasi Usability & Pengujian',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Pemahaman mendalam mengenai $topic dalam kaitan sistem informasi.',
    );
  });
}
