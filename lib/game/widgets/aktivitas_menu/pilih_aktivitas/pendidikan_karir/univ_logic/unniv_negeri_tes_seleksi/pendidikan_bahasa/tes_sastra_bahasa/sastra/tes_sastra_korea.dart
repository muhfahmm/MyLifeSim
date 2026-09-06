import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraKoreaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Hangul Principles & History (Jang-in)',
      'Sijo & Classic Korean Poetry',
      'Modern Korean Fiction & Dramaturgy',
      'Honorific System (Jondaetmal & Banmal)',
      'Korean Phonology & Assimilation Rules',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_kor_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Korea (#${index + 1}): Manakah analisis sastra dan kebahasaan Korea mengenai $topic?',
      options: [
        'Prinsip Pembuatan Konsonan dan Vokal Hangul',
        'Struktur Sijo 3 Baris Klasik Korea',
        'Sistem Akhiran Kehormatan Honorifik Korea',
        'Hukum Asimilasi Bunyi Bachim Korea',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan kebahasaan Korea mengenai $topic.',
    );
  });
}
