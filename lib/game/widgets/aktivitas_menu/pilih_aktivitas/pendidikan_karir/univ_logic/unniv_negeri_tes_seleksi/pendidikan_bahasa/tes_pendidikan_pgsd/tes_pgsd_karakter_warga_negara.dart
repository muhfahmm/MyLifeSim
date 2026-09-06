import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdKarakterWargaNegaraQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Universal Civics & Good Citizenship Values',
      'Rights and Responsibilities of a Citizen',
      'Rule of Law, Justice & Democracy Basics',
      'Global Citizenship, Diversity & Inclusivity',
      'Ethics, Integrity & Community Solidarity',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_kwn_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Karakter & Kewarganegaraan Global (#${index + 1}): Which global civic education principle corresponds to $topic?',
      options: [
        'Respecting Human Rights, Diversity, and Mutual Support',
        'Understanding Rights, Duties, and Community Responsibility',
        'Fostering Honesty, Integrity, and Ethical Leadership',
        'Promoting Peace, Inclusivity, and Environmental Stewardship',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Universal civic values, character education, and good citizenship principles regarding $topic.',
    );
  });
}
