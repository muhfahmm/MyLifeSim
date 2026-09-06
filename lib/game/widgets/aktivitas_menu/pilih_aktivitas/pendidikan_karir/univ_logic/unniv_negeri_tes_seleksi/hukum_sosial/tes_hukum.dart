import '../tes_seleksi_model.dart';

List<QuestionItem> getHukumQuestions() {
  return const [
    QuestionItem(
      questionText: 'Sumber hukum tertinggi dalam tata urutan perundang-undangan di Indonesia adalah:',
      options: ['Pancasila', 'UUD 1945', 'TAP MPR', 'UU / Perpu'],
      correctOptionIndex: 1,
      explanation: 'UUD 1945 adalah hukum dasar tertulis tertinggi.',
    ),
    QuestionItem(
      questionText: 'Asas yang menyatakan bahwa hukum tidak boleh berlaku surut disebut:',
      options: ['Asas Legalitas (Non-retroaktif)', 'Presumption of Innocence', 'Ne Bis In Idem', 'Lex Specialist'],
      correctOptionIndex: 0,
      explanation: 'Asas legalitas melarang hukum pidana berlaku surut.',
    ),
    QuestionItem(
      questionText: 'Lembaga yang berwenang menguji undang-undang terhadap UUD 1945 adalah:',
      options: ['Mahkamah Agung', 'Mahkamah Konstitusi', 'Komisi Yudisial', 'DPR'],
      correctOptionIndex: 1,
      explanation: 'Mahkamah Konstitusi menguji UU terhadap UUD 1945.',
    ),
    QuestionItem(
      questionText: 'Hukum yang mengatur hubungan hukum antara individu/badan hukum pribadi disebut:',
      options: ['Hukum Pidana', 'Hukum Perdata', 'Hukum Tata Negara', 'Hukum Internasional Publik'],
      correctOptionIndex: 1,
      explanation: 'Hukum perdata mengatur kepentingan privat/antar perorangan.',
    ),
    QuestionItem(
      questionText: 'Asas "Presumption of Innocence" berarti:',
      options: ['Seseorang dianggap bersalah sampai terbukti sebaliknya', 'Seseorang tidak bersalah sebelum ada putusan pengadilan yang berkekuatan hukum tetap', 'Hukum berlaku untuk semua orang tanpa terkecuali', 'Tersangka berhak mendapat pendampingan hukum'],
      correctOptionIndex: 1,
      explanation: 'Asas praduga tak bersalah.',
    ),
    QuestionItem(
      questionText: 'Siapakah pemegang kekuasaan yudikatif di Indonesia menurut konstitusi?',
      options: ['President dan Wapres', 'DPR dan DPD', 'Mahkamah Agung dan Mahkamah Konstitusi', 'KPK dan Kejaksaan Agung'],
      correctOptionIndex: 2,
      explanation: 'Kekuasaan kehakiman dilakukan oleh MA dan MK.',
    ),
    QuestionItem(
      questionText: 'Kitab Undang-Undang Hukum Perdata Indonesia sering dikenal dengan singkatan:',
      options: ['KUHP', 'KUHPer', 'KUHD', 'KUHAP'],
      correctOptionIndex: 1,
      explanation: 'KUHPer atau Burgerlijk Wetboek (BW).',
    ),
    QuestionItem(
      questionText: 'Gugatan perdata yang diajukan oleh kelompok masyarakat yang memperjuangkan kepentingan bersama disebut:',
      options: ['Class Action', 'Citizen Lawsuit', 'Judicial Review', 'Banding'],
      correctOptionIndex: 0,
      explanation: 'Class action adalah gugatan perwakilan kelompok.',
    ),
    QuestionItem(
      questionText: 'Asas "Ne Bis In Idem" menyatakan bahwa:',
      options: ['Niat jahat tidak dihukum', 'Seseorang tidak dapat diadili dua kali untuk perbuatan yang sama', 'Undang-undang khusus mengesampingkan undang-undang umum', 'Perjanjian mengikat sebagai undang-undang bagi yang membuatnya'],
      correctOptionIndex: 1,
      explanation: 'Ne bis in idem melarang pengadilan ulang perkara yang sudah diputus inkracht.',
    ),
    QuestionItem(
      questionText: 'Unsur subjektif dalam tindak pidana adalah:',
      options: ['Perbuatan melanggar hukum', 'Akibat yang ditimbulkan', 'Kesalahan/Sengaja atau Kealpaan pelaku', 'Objek tindak pidana'],
      correctOptionIndex: 2,
      explanation: 'Unsur subjektif melekat pada batin pelaku (mens rea).',
    ),
  ];
}
