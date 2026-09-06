import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikElektroQuestions() {
  return const [
    QuestionItem(
      questionText: 'Hukum Ohm menyatakan hubungan antara Tegangan (V), Arus (I), dan Hambatan (R) sebagai:',
      options: ['V = I * R', 'V = I / R', 'V = I + R', 'V = R / I'],
      correctOptionIndex: 0,
      explanation: 'Hukum Ohm: V = I x R.',
    ),
    QuestionItem(
      questionText: 'Satuan internasional untuk mengukur daya listrik adalah:',
      options: ['Volt', 'Ampere', 'Watt', 'Ohm'],
      correctOptionIndex: 2,
      explanation: 'Daya listrik diukur dalam Watt.',
    ),
    QuestionItem(
      questionText: 'Komponen elektronika yang berfungsi menyimpan muatan listrik sementara dinamakan:',
      options: ['Resistor', 'Kapasitor', 'Induktor', 'Dioda'],
      correctOptionIndex: 1,
      explanation: 'Kapasitor menyimpan energi dalam medan listrik.',
    ),
    QuestionItem(
      questionText: 'Komponen semikonduktor yang hanya mengalirkan arus listrik satu arah adalah:',
      options: ['Dioda', 'Transistor', 'Transformer', 'Relay'],
      correctOptionIndex: 0,
      explanation: 'Dioda berfungsi sebagai penyearah arus.',
    ),
    QuestionItem(
      questionText: 'Perangkat listrik yang digunakan untuk menaikkan atau menurunkan tegangan AC dinamakan:',
      options: ['Transformator (Trafo)', 'Inverter', 'Rectifier', 'Generator DC'],
      correctOptionIndex: 0,
      explanation: 'Transformator mengubah taraf tegangan bolak-balik.',
    ),
    QuestionItem(
      questionText: 'Frekuensi listrik standar PLN yang digunakan di rumah-rumah di Indonesia adalah:',
      options: ['20 Hz', '50 Hz', '60 Hz', '100 Hz'],
      correctOptionIndex: 1,
      explanation: 'Frekuensi standar sistem PLN Indonesia adalah 50 Hz.',
    ),
    QuestionItem(
      questionText: 'Alat pengukur yang mengabungkan fungsi pengukuran Volt, Ampere, dan Ohm disebut:',
      options: ['Oscilloscope', 'Multimeter / Avometer', 'Wattmeter', 'Tachometer'],
      correctOptionIndex: 1,
      explanation: 'Multimeter (Avometer) mengukur Ampere, Volt, Ohm.',
    ),
    QuestionItem(
      questionText: 'Arus listrik di mana arah alirannya selalu bolak-balik secara periodik dinamakan:',
      options: ['Direct Current (DC)', 'Alternating Current (AC)', 'Static Current', 'Inductive Current'],
      correctOptionIndex: 1,
      explanation: 'AC adalah arus bolak-balik.',
    ),
    QuestionItem(
      questionText: 'Gerbang logika yang menghasilkan output 1 (TRUE) HANYA JIKA seluruh inputnya bernilai 1 adalah:',
      options: ['Gerbang OR', 'Gerbang AND', 'Gerbang NOT', 'Gerbang XOR'],
      correctOptionIndex: 1,
      explanation: 'Gerbang AND membutuhkan semua input TRUE.',
    ),
    QuestionItem(
      questionText: 'Mikrokontroler populer bernuansa open-source yang sering digunakan dalam proyek elektronika pemula adalah:',
      options: ['Arduino', 'Intel Core i9', 'Raspberry Pi OS', 'Nvidia CUDA'],
      correctOptionIndex: 0,
      explanation: 'Arduino adalah papan mikrokontroler sangat populer.',
    ),
  ];
}
