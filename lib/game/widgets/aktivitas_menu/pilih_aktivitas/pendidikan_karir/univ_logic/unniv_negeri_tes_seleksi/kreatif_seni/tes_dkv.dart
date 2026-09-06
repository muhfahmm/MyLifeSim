import '../tes_seleksi_model.dart';

List<QuestionItem> getDkvQuestions() {
  return const [
    QuestionItem(
      questionText: 'Tiga warna primer dalam sistem pencampuran warna pigmen (subtraktif) adalah:',
      options: ['Red, Green, Blue (RGB)', 'Cyan, Magenta, Yellow (CMYK)', 'Merah, Kuning, Biru (RYB)', 'Hitam, Putih, Abu-abu'],
      correctOptionIndex: 2,
      explanation: 'Warna primer seni rupa/pigmen tradisional: Merah, Kuning, Biru.',
    ),
    QuestionItem(
      questionText: 'Format warna standar yang digunakan khusus untuk desain tampilan digital/layar adalah:',
      options: ['CMYK', 'RGB', 'Pantone', 'Grayscale'],
      correctOptionIndex: 1,
      explanation: 'RGB (Red Green Blue) digunakan untuk layar digital.',
    ),
    QuestionItem(
      questionText: 'Seni dan teknik mengatur tata letak huruf dan teks dinamakan:',
      options: ['Kaligrafi', 'Tipografi', 'Fotografi', 'Ilustrasi'],
      correctOptionIndex: 1,
      explanation: 'Tipografi adalah seni merancang dan mengatur cetak huruf.',
    ),
    QuestionItem(
      questionText: 'Satuan resolusi kerapatan piksel gambar digital untuk media layar dinamakan:',
      options: ['DPI (Dots Per Inch)', 'PPI (Pixels Per Inch)', 'Hertz', 'Bitrate'],
      correctOptionIndex: 1,
      explanation: 'PPI mengukur kerapatan piksel layar digital.',
    ),
    QuestionItem(
      questionText: 'Format berkas grafik berbasis vektor yang tidak pecah saat diperbesar adalah:',
      options: ['JPG / JPEG', 'PNG', 'SVG', 'GIF'],
      correctOptionIndex: 2,
      explanation: 'SVG (Scalable Vector Graphics) berbasis vektor.',
    ),
    QuestionItem(
      questionText: 'Prinsip desain visual yang mengatur keseimbangan bobot elemen visual dalam bidang dinamakan:',
      options: ['Balance (Keseimbangan)', 'Contrast', 'Rhythm', 'Proximity'],
      correctOptionIndex: 0,
      explanation: 'Balance menjaga keseimbangan komposisi visual.',
    ),
    QuestionItem(
      questionText: 'Software standar industri grafis buatan Adobe untuk mengolah gambar vektor adalah:',
      options: ['Adobe Photoshop', 'Adobe Illustrator', 'Adobe Premiere Pro', 'Adobe InDesign'],
      correctOptionIndex: 1,
      explanation: 'Adobe Illustrator merancang desain vektor.',
    ),
    QuestionItem(
      questionText: 'Aturan komposisi fotografi/desain yang membagi bidang visual menjadi 9 kotak sejajar disebut:',
      options: ['Golden Ratio', 'Rule of Thirds', 'Symmetry Rule', 'Center Focus'],
      correctOptionIndex: 1,
      explanation: 'Rule of Thirds membagi layar 3x3.',
    ),
    QuestionItem(
      questionText: 'Identitas visual suatu merek/perusahaan berupa lambang gambar dinamakan:',
      options: ['Poster', 'Logo', 'Flyer', 'Sketsa'],
      correctOptionIndex: 1,
      explanation: 'Logo mewakili identitas visual merek.',
    ),
    QuestionItem(
      questionText: 'Gaya desain visual abad ke-20 yang mengusung prinsip "Form Follows Function" dan minimalis adalah:',
      options: ['Bauhaus', 'Barok', 'Gotik', 'Surealisme'],
      correctOptionIndex: 0,
      explanation: 'Bauhaus memelopori fungsi visual fungsional minimalis.',
    ),
  ];
}
