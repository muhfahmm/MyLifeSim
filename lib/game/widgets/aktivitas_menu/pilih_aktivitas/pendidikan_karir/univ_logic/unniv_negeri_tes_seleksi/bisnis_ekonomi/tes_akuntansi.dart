import '../tes_seleksi_model.dart';

List<QuestionItem> getAkuntansiQuestions() {
  return const [
    QuestionItem(
      questionText: 'Persamaan dasar akuntansi yang benar adalah:',
      options: ['Aset = Kewajiban + Ekuitas', 'Aset = Kewajiban - Ekuitas', 'Ekuitas = Aset + Kewajiban', 'Kewajiban = Aset + Ekuitas'],
      correctOptionIndex: 0,
      explanation: 'Persamaan akuntansi dasar: Aset = Liabilitas + Ekuitas.',
    ),
    QuestionItem(
      questionText: 'Pencatatan transaksi keuangan pertama kali secara kronologis dilakukan pada buku:',
      options: ['Buku Besar (Ledger)', 'Jurnal Umum', 'Neraca Saldo', 'Laporan Keuangan'],
      correctOptionIndex: 1,
      explanation: 'Jurnal umum mencatat transaksi secara kronologis.',
    ),
    QuestionItem(
      questionText: 'Prinsip akuntansi yang mengharuskan pendataan transaksi menggunakan saldo terukur dinamakan:',
      options: ['Matching Principle', 'Historical Cost Principle', 'Full Disclosure', 'Going Concern'],
      correctOptionIndex: 1,
      explanation: 'Biaya historis mencatat sesuai harga perolehan.',
    ),
    QuestionItem(
      questionText: 'Penyusutan nilai aset tetap secara berkala dalam akuntansi dinamakan:',
      options: ['Amortisasi', 'Depresiasi', 'Deplesi', 'Liabilitas'],
      correctOptionIndex: 1,
      explanation: 'Depresiasi adalah penyusutan aset tetap berwujud.',
    ),
    QuestionItem(
      questionText: 'Laporan yang menggambarkan penerimaan dan pengeluaran kas perusahaan selama periode tertentu adalah:',
      options: ['Neraca', 'Laporan Laba Rugi', 'Laporan Arus Kas', 'Laporan Perubahan Modal'],
      correctOptionIndex: 2,
      explanation: 'Laporan arus kas menyajikan aktivitas operasi, investasi, dan pendanaan.',
    ),
    QuestionItem(
      questionText: 'Manakah akun berikut yang bernilai normal di sisi Kredit?',
      options: ['Kas', 'Beban Gaji', 'Utang Usaha', 'Piutang Usaha'],
      correctOptionIndex: 2,
      explanation: 'Utang usaha (Liabilitas) bertambah di sisi Kredit.',
    ),
    QuestionItem(
      questionText: 'Pemeriksaan independen atas laporan keuangan perusahaan oleh pihak ketiga disebut:',
      options: ['Bookkeeping', 'Auditing', 'Taxation', 'Budgeting'],
      correctOptionIndex: 1,
      explanation: 'Auditing memeriksa kebenaran laporan keuangan.',
    ),
    QuestionItem(
      questionText: 'Singkatan dari Standar Akuntansi Keuangan yang berlaku di Indonesia adalah:',
      options: ['IFRS', 'SAK', 'GAAP', 'PSA'],
      correctOptionIndex: 1,
      explanation: 'SAK (Standar Akuntansi Keuangan).',
    ),
    QuestionItem(
      questionText: 'Aktiva yang tidak memiliki wujud fisik tetapi memberikan manfaat ekonomis masa depan dinamakan:',
      options: ['Aset Lancar', 'Aset Tetap', 'Aset Takberwujud (Intangible Asset)', 'Investasi Jangka Panjang'],
      correctOptionIndex: 2,
      explanation: 'Contoh aset takberwujud: Hak cipta, paten, dan goodwill.',
    ),
    QuestionItem(
      questionText: 'Metode penilaian persediaan barang di mana barang yang pertama kali masuk dianggap pertama kali keluar adalah:',
      options: ['LIFO', 'FIFO', 'Average', 'Weighted Average'],
      correctOptionIndex: 1,
      explanation: 'FIFO (First In First Out).',
    ),
  ];
}
