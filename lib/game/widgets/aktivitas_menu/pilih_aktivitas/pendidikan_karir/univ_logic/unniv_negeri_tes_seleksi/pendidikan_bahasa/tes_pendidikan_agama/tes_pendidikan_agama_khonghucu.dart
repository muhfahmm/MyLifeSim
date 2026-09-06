import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPendidikanAgamaKhonghucuQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Kitab Sishu Wujing & Ajaran Ru Jiao',
      'Nilai Wu Chang (Ren, Yi, Li, Zhi, Xin)',
      'Xiao (Bakti Kepada Orang Tua & Leluhur)',
      'Tian & Keseimbangan Yin Yang',
      'Etika Kepemimpinan Junzi (Insan Kamil)',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pkh_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'Pendidikan Agama Khonghucu (#${index + 1}): Manakah ajaran filsafat Khonghucu mengenai $topic?',
      options: [
        'Pengamalan Nilai Wu Chang (Cinta Kasih, Kebenaran, Kesusilaan, Bijaksana, Terpercaya)',
        'Penghayatan Ajaran Kitab Sishu Wujing',
        'Prinsip Bakti (Xiao) dan Harmoni Keluarga/Masyarakat',
        'Pembentukan Karakter Junzi dan Etika Moralitas',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar Pendidikan Agama Khonghucu dan filsafat Ru Jiao mengenai $topic.',
    );
  });
}
