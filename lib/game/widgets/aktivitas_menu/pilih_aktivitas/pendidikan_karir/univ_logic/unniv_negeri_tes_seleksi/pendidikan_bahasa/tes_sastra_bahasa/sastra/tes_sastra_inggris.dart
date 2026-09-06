import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraInggrisQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Shakespearean & Classical Literature',
      'English Syntax & Morphology',
      'Modern American & British Prose',
      'Literary Devices & Figures of Speech',
      'Phonetics & Phonology',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_ing_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Inggris (#${index + 1}): Which literary or linguistic analysis corresponds to $topic?',
      options: [
        'Analysis of Iambic Pentameter and Rhyme Scheme',
        'Syntax Tree Structure and Clause Analysis',
        'Metaphor, Simile, and Imagery Evaluation',
        'Phonetic Transcription and Stress Placement',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Core knowledge of English literature and linguistics regarding $topic.',
    );
  });
}
