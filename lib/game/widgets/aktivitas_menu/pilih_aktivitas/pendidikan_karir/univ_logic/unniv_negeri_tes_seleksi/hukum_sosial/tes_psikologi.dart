import '../tes_seleksi_model.dart';

List<QuestionItem> getPsikologiQuestions() {
  return const [
    QuestionItem(
      questionText: 'Tokoh ilmuwan yang dikenal sebagai bapak Psikoanalisis adalah:',
      options: ['B.F. Skinner', 'Sigmund Freud', 'Carl Jung', 'Ivan Pavlov'],
      correctOptionIndex: 1,
      explanation: 'Sigmund Freud mengembangkan teori psikoanalisis.',
    ),
    QuestionItem(
      questionText: 'Struktur kepribadian menurut Freud yang bekerja berdasarkan prinsip kesenangan (pleasure principle) adalah:',
      options: ['Id', 'Ego', 'Superego', 'Self'],
      correctOptionIndex: 0,
      explanation: 'Id bertindak atas dasar prinsip kesenangan instingtif.',
    ),
    QuestionItem(
      questionText: 'Eksperimen "Classical Conditioning" dengan menggunakan anjing dan bel dipopulerkan oleh:',
      options: ['Ivan Pavlov', 'Albert Bandura', 'Jean Piaget', 'Abraham Maslow'],
      correctOptionIndex: 0,
      explanation: 'Ivan Pavlov mengemukakan pengondisian klasik.',
    ),
    QuestionItem(
      questionText: 'Hierarki kebutuhan Maslow yang berada pada tingkatan paling puncak adalah:',
      options: ['Kebutuhan Fisiologis', 'Kebutuhan Rasa Aman', 'Aktualisasi Diri', 'Kebutuhan Penghargaan'],
      correctOptionIndex: 2,
      explanation: 'Aktualisasi diri adalah tingkat puncak hirarki Maslow.',
    ),
    QuestionItem(
      questionText: 'Cabang psikologi yang memfokuskan studi pada proses mental seperti persepsi, memori, dan penalaran dinamakan:',
      options: ['Psikologi Perkembangan', 'Psikologi Kognitif', 'Psikologi Sosial', 'Psikologi Klinis'],
      correctOptionIndex: 1,
      explanation: 'Psikologi kognitif mengkaji proses pikiran.',
    ),
    QuestionItem(
      questionText: 'Mekanisme pertahanan diri di mana seseorang mengalihkan dorongan tak bisa diterima ke bentuk produktif dinamakan:',
      options: ['Represi', 'Proyeksi', 'Sublimasi', 'Denial'],
      correctOptionIndex: 2,
      explanation: 'Sublimasi mengarahkan energi ke aktivitas positif.',
    ),
    QuestionItem(
      questionText: 'Tes inteligensi populer yang mengukur Intelligence Quotient (IQ) dewasa adalah:',
      options: ['WAIS (Wechsler Adult Intelligence Scale)', 'MMPI', 'Rorschach Test', 'TAT'],
      correctOptionIndex: 0,
      explanation: 'WAIS mengukur skala inteligensi dewasa.',
    ),
    QuestionItem(
      questionText: 'Tipe kepribadian yang cenderung lebih tertutup, mandiri, dan menyukai ketenangan dinamakan:',
      options: ['Ekstrovert', 'Introvert', 'Ambivert', 'Neurotis'],
      correctOptionIndex: 1,
      explanation: 'Introvert menyukai ketenangan internal.',
    ),
    QuestionItem(
      questionText: 'Gangguan suasana hati yang ditandai dengan periode depresi dan mania secara bergantian dinamakan:',
      options: ['Skizofrenia', 'Bipolar Disorder', 'Anksietas', 'PTSD'],
      correctOptionIndex: 1,
      explanation: 'Bipolar mengalami fase mania dan depresi.',
    ),
    QuestionItem(
      questionText: 'Teori perkembangan kognitif anak yang membagi tahap sensorimotor hingga operasional formal dikembangkan oleh:',
      options: ['Jean Piaget', 'Erik Erikson', 'Lev Vygotsky', 'John Watson'],
      correctOptionIndex: 0,
      explanation: 'Jean Piaget merumuskan tahap perkembangan kognitif.',
    ),
  ];
}
