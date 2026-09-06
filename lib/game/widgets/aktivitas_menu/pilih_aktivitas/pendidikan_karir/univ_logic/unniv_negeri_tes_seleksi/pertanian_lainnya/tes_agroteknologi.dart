import '../tes_seleksi_model.dart';

List<QuestionItem> getAgroteknologiQuestions() {
  return const [
    QuestionItem(
      questionText: 'Proses pembuatan makanan pada tumbuhan berbunga dengan bantuan sinar matahari dinamakan:',
      options: ['Respirasi', 'Fotosintesis', 'Transpirasi', 'Absorpsi'],
      correctOptionIndex: 1,
      explanation: 'Fotosintesis mengolah CO2 dan H2O menjadi glukosa.',
    ),
    QuestionItem(
      questionText: 'Zat hijau daun yang menyerap gelombang cahaya matahari saat fotosintesis dinamakan:',
      options: ['Klorofil', 'Karoten', 'Xantofil', 'Stomata'],
      correctOptionIndex: 0,
      explanation: 'Klorofil adalah pigmen fotosintesis.',
    ),
    QuestionItem(
      questionText: 'Unsur hara makro utama yang dibutuhkan tanaman dalam jumlah banyak (NPK) adalah:',
      options: ['Nitrogen, Fosfor, Kalium', 'Natrium, Perak, Kalsium', 'Nikel, Fluor, Klor', 'Nitrogen, Ferum, Kalsium'],
      correctOptionIndex: 0,
      explanation: 'NPK singkatan dari Nitrogen, Fosfor, dan Kalium.',
    ),
    QuestionItem(
      questionText: 'Teknik budidaya tanaman tanpa menggunakan media tanah dinamakan:',
      options: ['Aeroponik', 'Hidroponik', 'Kultur Jaringan', 'Organik'],
      correctOptionIndex: 1,
      explanation: 'Hidroponik menggunakan media air kaya nutrisi.',
    ),
    QuestionItem(
      questionText: 'Organ tumbuhan yang berfungsi menyerap air dan mineral dari dalam tanah adalah:',
      options: ['Daun', 'Batang', 'Akar', 'Bunga'],
      correctOptionIndex: 2,
      explanation: 'Akar bertugas menyerap air dan mineral.',
    ),
    QuestionItem(
      questionText: 'Pengikisan atau perpindahan lapisan tanah atas akibat dorongan air atau angin dinamakan:',
      options: ['Erosi', 'Sedimentasi', 'Abrasi', 'Deforestasi'],
      correctOptionIndex: 0,
      explanation: 'Erosi adalah pengikisan permukaan tanah.',
    ),
    QuestionItem(
      questionText: 'Organisme pengganggu tanaman yang merugikan hasil pertanian dinamakan:',
      options: ['Gulma dan Hama', 'Predator', 'Bakteri Menguntungkan', 'Vektor Pasif'],
      correctOptionIndex: 0,
      explanation: 'Hama dan gulma merusak/mengganggu tanaman budidaya.',
    ),
    QuestionItem(
      questionText: 'Hormon tumbuhan yang memicu pematangan buah secara alami adalah:',
      options: ['Auksin', 'Giberelin', 'Gas Etilen', 'Sitokinin'],
      correctOptionIndex: 2,
      explanation: 'Gas etilen memicu proses pematangan buah.',
    ),
    QuestionItem(
      questionText: 'Sistem pertanian yang memanfaatkan daur alami tanpa pupuk kimia sintetis dinamakan:',
      options: ['Pertanian Konvensional', 'Pertanian Organik', 'Pertanian Industri', 'Pertanian Monokultur'],
      correctOptionIndex: 1,
      explanation: 'Pertanian organik ramah lingkungan tanpa bahan kimia buatan.',
    ),
    QuestionItem(
      questionText: 'Teknik perbanyakan tanaman secara vegetatif dengan menanam bagian sel/jaringan tanaman di media steril dinamakan:',
      options: ['Stek', 'Cangkok', 'Kultur Jaringan', 'Okulasi'],
      correctOptionIndex: 2,
      explanation: 'Kultur jaringan menumbuhkan eksplan di media aseptik.',
    ),
  ];
}
