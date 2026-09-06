import 'tes_seleksi_model.dart';

List<QuestionItem> getGeneralQuestionsForMajor(String major) {
  return [
    QuestionItem(
      questionText: 'Metode berpikir logis dan sistematis yang berurutan dalam menyelesaikan masalah disebut:',
      options: ['Algoritma', 'Heuristik', 'Spekulasi', 'Intuisi'],
      correctOptionIndex: 0,
      explanation: 'Algoritma adalah langkah berurutan secara logis.',
    ),
    QuestionItem(
      questionText: 'Dalam metode ilmiah, langkah awal yang dilakukan sebelum merumuskan hipotesis adalah:',
      options: ['Eksperimen', 'Observasi / Pengamatan', 'Kesimpulan', 'Publikasi'],
      correctOptionIndex: 1,
      explanation: 'Observasi mendahului perumusan hipotesis.',
    ),
    QuestionItem(
      questionText: 'Sikap etis yang mengedepankan kejujuran akademik dan anti-plagiarisme adalah:',
      options: ['Integritas Akademik', 'Efisiensi Studi', 'Kompetisi Bebas', 'Pragmatisme'],
      correctOptionIndex: 0,
      explanation: 'Integritas akademik menjaga kejujuran karya ilmiah.',
    ),
    QuestionItem(
      questionText: 'Kemampuan untuk menganalisis data, mengevaluasi argumen, dan menarik kesimpulan secara objektif disebut:',
      options: ['Berpikir Kritis (Critical Thinking)', 'Berpikir Emosional', 'Hafalan', 'Intuisi'],
      correctOptionIndex: 0,
      explanation: 'Berpikir kritis memproses informasi secara rasional.',
    ),
    QuestionItem(
      questionText: 'Bahasa internasional utama yang digunakan dalam penulisan jurnal ilmiah bereputasi global adalah:',
      options: ['Bahasa Latin', 'Bahasa Inggris', 'Bahasa Spanyol', 'Bahasa Prancis'],
      correctOptionIndex: 1,
      explanation: 'Bahasa Inggris adalah lingua franca sains global.',
    ),
    QuestionItem(
      questionText: 'Kerja sama antar tim dari disiplin ilmu yang berbeda untuk memecahkan masalah kompleks disebut pendekatan:',
      options: ['Interdisipliner / Multidisipliner', 'Monodisipliner', 'Isolasional', 'Sektoral'],
      correctOptionIndex: 0,
      explanation: 'Pendekatan interdisipliner menggabungkan berbagai bidang ilmu.',
    ),
    QuestionItem(
      questionText: 'Landasan hukum tertinggi bagi penyelenggaraan pendidikan nasional di Indonesia adalah:',
      options: ['UU Pendidikan Nasional (UU No. 20 Tahun 2003)', 'Peraturan Menteri', 'Keputusan Dekan', 'Peraturan Rektor'],
      correctOptionIndex: 0,
      explanation: 'UU Sisdiknas No. 20 Tahun 2003.',
    ),
    QuestionItem(
      questionText: 'Gelar akademik pertama yang diperoleh lulusan program pendidikan sarjana di Indonesia adalah:',
      options: ['Diploma (A.Md)', 'Sarjana (S.1)', 'Magister (S.2)', 'Doktor (S.3)'],
      correctOptionIndex: 1,
      explanation: 'Program S1 menghasilkan gelar Sarjana.',
    ),
    QuestionItem(
      questionText: 'Prinsip Tri Dharma Perguruan Tinggi di Indonesia mencakup:',
      options: ['Pendidikan, Penelitian, dan Pengabdian Masyarakat', 'Ujian, Kuliah, dan Praktikum', 'Olahraga, Seni, dan Akademik', 'Absensi, Tugas, dan Skripsi'],
      correctOptionIndex: 0,
      explanation: 'Tri Dharma = Pendidikan, Penelitian, Pengabdian Masyarakat.',
    ),
    QuestionItem(
      questionText: 'Penyusunan karya ilmiah akhir sebagai syarat kelulusan program Sarjana (S1) dinamakan:',
      options: ['Tesis', 'Disertasi', 'Skripsi', 'Makalah Kelas'],
      correctOptionIndex: 2,
      explanation: 'Skripsi adalah karya ilmiah lulusan S1.',
    ),
  ];
}
