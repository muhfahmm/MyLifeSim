import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraJermanQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Deutsche Grammatik & Kasus (Nominativ, Akkusativ, Dativ, Genitiv)',
      'Goethe & Weimarer Klassik Literature',
      'Germanic Phonology & Umlaut Shift',
      'Romantik & Modern German Prose',
      'Compound Nouns & Word Formation (Komposita)',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_jer_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Jerman (#${index + 1}): Which German literature or linguistic concept relates to $topic?',
      options: [
        'Deklination der Artikel und Adjektive nach Kasus',
        'Analisis Drama Faust Goethe dan Strum und Drang',
        'Pembentukan Kata Majemuk Komposita Nomen',
        'Perubahan Bunyi Lautverschiebung dalam Bahasa Jerman',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan kebahasaan Jerman mengenai $topic.',
    );
  });
}
