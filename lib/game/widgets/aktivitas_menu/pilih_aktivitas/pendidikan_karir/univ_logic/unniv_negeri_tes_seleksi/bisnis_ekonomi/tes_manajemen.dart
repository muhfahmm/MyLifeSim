import '../tes_seleksi_model.dart';

List<QuestionItem> getManajemenQuestions() {
  return const [
    QuestionItem(
      questionText: 'Manakah dari berikut ini yang BUKAN merupakan fungsi utama manajemen (POAC)?',
      options: ['Planning', 'Organizing', 'Actuating', 'Computing'],
      correctOptionIndex: 3,
      explanation: 'POAC singkatan dari Planning, Organizing, Actuating, Controlling.',
    ),
    QuestionItem(
      questionText: 'Analisis SWOT digunakan untuk mengevaluasi posisi strategis perusahaan. Apa kepanjangan dari SWOT?',
      options: ['Strengths, Weaknesses, Opportunities, Threats', 'Sales, Work, Organization, Targets', 'Strategy, Wealth, Operations, Team', 'Structure, Working, Output, Timing'],
      correctOptionIndex: 0,
      explanation: 'SWOT = Strengths, Weaknesses, Opportunities, Threats.',
    ),
    QuestionItem(
      questionText: 'Laporan keuangan yang menyajikan posisi aset, kewajiban (liabilitas), dan ekuitas pada tanggal tertentu adalah:',
      options: ['Laporan Laba Rugi', 'Neraca (Balance Sheet)', 'Laporan Arus Kas', 'Laporan Perubahan Ekuitas'],
      correctOptionIndex: 1,
      explanation: 'Neraca menyajikan aset, utang, dan modal.',
    ),
    QuestionItem(
      questionText: 'Strategi pemasaran 4P klasik terdiri dari:',
      options: ['Product, Price, Place, Promotion', 'People, Process, Performance, Profit', 'Plan, Production, Placement, Pay', 'Public, Power, Position, Prestige'],
      correctOptionIndex: 0,
      explanation: 'Bauran pemasaran 4P = Product, Price, Place, Promotion.',
    ),
    QuestionItem(
      questionText: 'Kondisi di mana total pendapatan sama dengan total biaya sehingga perusahaan tidak mengalami laba maupun rugi disebut:',
      options: ['Return on Investment (ROI)', 'Break Even Point (BEP)', 'Net Present Value (NPV)', 'Gross Profit Margin'],
      correctOptionIndex: 1,
      explanation: 'BEP adalah titik impas perusahaan.',
    ),
    QuestionItem(
      questionText: 'Lembaga pengawas sektor jasa keuangan di Indonesia yang independen adalah:',
      options: ['Bank Indonesia', 'Otoritas Jasa Keuangan (OJK)', 'Kementerian Keuangan', 'Lembaga Penjamin Simpanan (LPS)'],
      correctOptionIndex: 1,
      explanation: 'OJK bertugas mengawasi jasa keuangan.',
    ),
    QuestionItem(
      questionText: 'Nilai mata uang yang menurun secara berkelanjutan dan menyebabkan kenaikan harga barang dinamakan:',
      options: ['Deflasi', 'Inflasi', 'Stagflasi', 'Devaluasi'],
      correctOptionIndex: 1,
      explanation: 'Inflasi adalah kenaikan harga umum secara berkala.',
    ),
    QuestionItem(
      questionText: 'Manakah yang termasuk ke dalam Aset Lancar (Current Assets) dalam akuntansi?',
      options: ['Gedung Kantor', 'Mesin Pabrik', 'Kas dan Setara Kas', 'Hak Paten'],
      correctOptionIndex: 2,
      explanation: 'Kas adalah aset paling lancar.',
    ),
    QuestionItem(
      questionText: 'Gaya kepemimpinan di mana pemimpin memberikan kebebasan penuh kepada bawahan untuk mengambil keputusan disebut:',
      options: ['Otokratis', 'Demokratis', 'Laissez-Faire', 'Transaksional'],
      correctOptionIndex: 2,
      explanation: 'Laissez-Faire memberikan kebebasan penuh.',
    ),
    QuestionItem(
      questionText: 'Proses merekrut, melatih, menilai, dan memberi kompensasi kepada karyawan merupakan fungsi dari manajemen:',
      options: ['Manajemen Keuangan', 'Manajemen Operasional', 'Manajemen Sumber Daya Manusia (SDM)', 'Manajemen Pemasaran'],
      correctOptionIndex: 2,
      explanation: 'Fungsi utama manajemen SDM.',
    ),
  ];
}
