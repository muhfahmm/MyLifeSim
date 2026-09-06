import '../../../tes_seleksi_model.dart';

List<QuestionItem> getTesSastraPrancisQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Littérature du Siècle des Lumières (Voltaire, Rousseau)',
      'Subjonctif & French Verb Conjugation',
      'French Romanticism & Symbolism (Baudelaire, Victor Hugo)',
      'Phonétique et Liaison Française',
      'Syntaxe et Accord des Participes Passés',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'sas_pra_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Sastra Prancis (#${index + 1}): Which French literary or grammatical analysis corresponds to $topic?',
      options: [
        'Conjugaison du Subjonctif et Conditionnel',
        'Analyse des Poèmes de Baudelaire et Victor Hugo',
        'Règles de la Liaison et Nasalisation en Phonétique',
        'Kajian Filsafat Pencerahan Lumières Voltaire',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar sastra dan tata bahasa Prancis mengenai $topic.',
    );
  });
}
