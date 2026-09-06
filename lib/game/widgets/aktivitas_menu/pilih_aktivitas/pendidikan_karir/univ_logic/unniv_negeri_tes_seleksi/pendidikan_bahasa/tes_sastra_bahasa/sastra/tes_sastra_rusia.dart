import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraRusiaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Russian Golden Age Literature (Pushkin, Dostoevsky, Tolstoy)',
      'Cyrillic Alphabet & Russian Phonology',
      'Russian Noun Cases (6 Cases Inflection)',
      'Verbs of Motion & Aspect (Imperfective/Perfective)',
      'Silver Age Poetry & Soviet Literature',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_rus_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Rusia (#${index + 1}): Which Russian literary or grammatical concept fits $topic?',
      options: [
        'Analyse novel Tolstoy dan Dostoevsky',
        'Sistem 6 Deklinasi Kasus Kata Benda Rusia',
        'Perbedaan Aspek Fi\'il Совершенный/Несовершенный вид',
        'Aturan Fonetik Palatalisasi Konsonan Rusia',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan tata bahasa Rusia mengenai $topic.',
    );
  });
}
