import '../../tes_seleksi_model.dart';

List<QuestionItem> getTesPgsdBahasaIndonesiaQuestions() {
  return List.generate(100, (index) {
    final List<String> topics = [
      'Keterampilan Membaca Permulaan & Literasi Dasar',
      'Metode Pengajaran Bahasa Indonesia di Sekolah Dasar',
      'Tata Bahasa, Ejaan & EYD untuk Anak Sekolah Dasar',
      'Apresiasi Sastra Anak & Dongeng Nusantara',
      'Keterampilan Menulis & Berbicara Dasar',
    ];
    final String topic = topics[index % topics.length];
    return QuestionItem(
      id: 'pgsd_bah_${(index + 1).toString().padLeft(3, '0')}',
      questionText: 'PGSD Bahasa Indonesia (#${index + 1}): Manakah konsep pembelajaran bahasa dasar mengenai $topic?',
      options: [
        'Metode Eja, Suku Kata, dan Membaca Nyaring',
        'Pengenalan Kalimat Sederhana dan Kosakata Dasar',
        'Analisis Cerita Anak dan Pesan Moral',
        'Teknik Pembimbingan Menulis Karangan Pendek',
      ],
      correctOptionIndex: index % 4,
      explanation: 'Konsep dasar pedagogi dan materi Bahasa Indonesia untuk Pendidikan Guru Sekolah Dasar mengenai $topic.',
    );
  });
}
