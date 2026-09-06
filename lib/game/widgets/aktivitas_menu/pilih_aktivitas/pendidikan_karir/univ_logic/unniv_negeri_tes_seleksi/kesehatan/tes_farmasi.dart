import '../tes_seleksi_model.dart';

List<QuestionItem> getFarmasiQuestions() {
  return const [
    QuestionItem(
      questionText: 'Cabang ilmu farmasi yang mempelajari asal-usul, sifat, dan kegunaan obat dari bahan alam (tumbuhan/hewan) dinamakan:',
      options: ['Farmakologi', 'Farmakognosi', 'Farmasetika', 'Toksikologi'],
      correctOptionIndex: 1,
      explanation: 'Farmakognosi mempelajari bahan obat alamiah.',
    ),
    QuestionItem(
      questionText: 'Tulisan resep dokter yang mengandung instruksi pembuatan dan penyerahan obat disebut:',
      options: ['Preskripsi / Resep Obat', 'Dosis Maksimum', 'Brosur Obat', 'Faktur Penjualan'],
      correctOptionIndex: 0,
      explanation: 'Preskripsi adalah permintaan tertulis dokter kepada apoteker.',
    ),
    QuestionItem(
      questionText: 'Singkatan dalam resep dokter "3 dd tab 1" berarti:',
      options: ['3 kali sehari 1 tablet', '1 kali sehari 3 tablet', 'Setiap 3 jam 1 tablet', '3 tablet sekaligus per minggu'],
      correctOptionIndex: 0,
      explanation: '3 dd (ter de die) tab 1 = 3 kali sehari 1 tablet.',
    ),
    QuestionItem(
      questionText: 'Obat yang dapat diperoleh bebas di apotek tanpa resep dokter ditandai dengan lingkaran berwarna:',
      options: ['Hijau dengan garis tepi hitam', 'Biru dengan garis tepi hitam', 'Merah dengan huruf K', 'Kuning bertanda palang merah'],
      correctOptionIndex: 0,
      explanation: 'Lingkaran hijau lis hitam adalah obat bebas.',
    ),
    QuestionItem(
      questionText: 'Proses nasib obat dalam tubuh mencakup empat tahap ADME. Apakah kepanjangan ADME?',
      options: ['Absorpsi, Distribusi, Metabolisme, Ekskresi', 'Analisis, Dosis, Medikasi, Evaluasi', 'Aktivitas, Daya Tahan, Memori, Efektivitas', 'Aplikasi, Formulasi, Manufaktur, Edar'],
      correctOptionIndex: 0,
      explanation: 'ADME: Absorpsi, Distribusi, Metabolisme, Ekskresi.',
    ),
    QuestionItem(
      questionText: 'Bentuk sediaan obat padat berupa cangkang lunak atau keras yang berisi bahan obat dinamakan:',
      options: ['Sirup', 'Kapsul', 'Salep', 'Suspensi'],
      correctOptionIndex: 1,
      explanation: 'Kapsul adalah cangkang penyimpan bahan obat.',
    ),
    QuestionItem(
      questionText: 'Ilmu yang mempelajari efek racun zat kimia bagi makhluk hidup disebut:',
      options: ['Patologi', 'Toksikologi', 'Fisiologi', 'Mikrobiologi'],
      correctOptionIndex: 1,
      explanation: 'Toksikologi mempelajari racun dan dampaknya.',
    ),
    QuestionItem(
      questionText: 'Antibiotik adalah golongan obat yang berfungsi membunuh atau menghambat pertumbuhan:',
      options: ['Virus', 'Bakteri', 'Jamur', 'Parasit cacing'],
      correctOptionIndex: 1,
      explanation: 'Antibiotik efektif melawan infeksi bakteri.',
    ),
    QuestionItem(
      questionText: 'Organ utama di dalam tubuh manusia yang bertugas memetabolisme sebagian besar obat adalah:',
      options: ['Ginjal', 'Hati (Hepar)', 'Lambung', 'Paru-paru'],
      correctOptionIndex: 1,
      explanation: 'Hati adalah organ utama tempat metabolisme obat.',
    ),
    QuestionItem(
      questionText: 'Gelar profesi kelulusan yang berhak membuka praktek pelayanan apotek setelah sarjana farmasi adalah:',
      options: ['Apoteker (Apt.)', 'Dokter Spesialis', 'Ahli Gizi', 'Bidan'],
      correctOptionIndex: 0,
      explanation: 'Gelar profesi Apoteker (Apt.).',
    ),
  ];
}
