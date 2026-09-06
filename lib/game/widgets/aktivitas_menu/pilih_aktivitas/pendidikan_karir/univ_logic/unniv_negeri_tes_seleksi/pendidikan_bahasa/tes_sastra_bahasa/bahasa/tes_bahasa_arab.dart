import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesBahasaArabQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Muhadatsah (Percakapan & Bahasa Arab Komunikatif)',
      'Qira\'ah (Membaca Teks Arab Gundul / Kitab)',
      'Kitabah (Menulis Kalimat Efektif & Insha\')',
      'Terjemah Teks Arab - Indonesia / Media',
      'Kajian Timur Tengah & Diplomasi Arab',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'bah_arab_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Bahasa Arab (#${index + 1}): Manakah penerapan kebahasaan & komunikasi Arab mengenai $topic?',
      options: [
        'Keterampilan Muhadatsah dan Penguasaan Mufradat',
        'Teknik Baca Teks Arab Gundul dan Analisis I\'rab Praktis',
        'Kaedah Insha\' dan Menulis Teks Resmi Bahasa Arab',
        'Penerjemahan Istilah Berita dan Diplomasi Timur Tengah',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Penerapan praktis kebahasaan dan studi Timur Tengah mengenai $topic.',
    );
  });
}
