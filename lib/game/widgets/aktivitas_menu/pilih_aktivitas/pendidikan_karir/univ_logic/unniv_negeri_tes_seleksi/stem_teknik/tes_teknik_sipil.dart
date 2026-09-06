import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikSipilQuestions() {
  return const [
    QuestionItem(
      questionText: 'Komponen struktur bawah bangunan yang berfungsi menyalurkan beban ke tanah keras dinamakan:',
      options: ['Pondasi', 'Sloof', 'Kolom', 'Balok'],
      correctOptionIndex: 0,
      explanation: 'Pondasi meneruskan beban struktur bawah ke tanah.',
    ),
    QuestionItem(
      questionText: 'Campuran antara semen, air, pasir, dan kerikil menghasilkan material bangunan bernama:',
      options: ['Beton', 'Mortal', 'Aspal', 'Gips'],
      correctOptionIndex: 0,
      explanation: 'Beton terbuat dari semen, agregat halus, agregat kasar, dan air.',
    ),
    QuestionItem(
      questionText: 'Hukum fisika yang menjadi dasar perhitungan tegangan dan regangan dalam struktur elastis adalah:',
      options: ['Hukum Pascal', 'Hukum Hooke', 'Hukum Bernoulli', 'Hukum Archimedes'],
      correctOptionIndex: 1,
      explanation: 'Hukum Hooke menyatakan tegangan berbanding lurus dengan regangan.',
    ),
    QuestionItem(
      questionText: 'Pengujian kekuatan tekan beton di laboratorium umumnya dilakukan pada umur beton mencapai:',
      options: ['7 Hari', '14 Hari', '28 Hari', '50 Hari'],
      correctOptionIndex: 2,
      explanation: 'Kuat tekan standar beton diuji pada umur 28 hari.',
    ),
    QuestionItem(
      questionText: 'Alat ukur sudut dan jarak yang digunakan dalam pemetaan lahan pada survei teknik sipil adalah:',
      options: ['Theodolite / Total Station', 'Barometer', 'Multimeter', 'Hydrometer'],
      correctOptionIndex: 0,
      explanation: 'Theodolite/Total station mengukur sudut horizontal dan vertikal.',
    ),
    QuestionItem(
      questionText: 'Bangunan air yang berfungsi menampung dan mengendalikan aliran air sungai untuk irigasi/PLTA disebut:',
      options: ['Dermaga', 'Bendungan (Dam)', 'Drainase', 'Gorong-gorong'],
      correctOptionIndex: 1,
      explanation: 'Bendungan menampung air sungai skala besar.',
    ),
    QuestionItem(
      questionText: 'Nilai perbandingan antara massa air dan massa semen dalam campuran beton dinamakan:',
      options: ['Faktor Air Semen (FAS)', 'Slump Test', 'Modulus Elastisitas', 'Porositas'],
      correctOptionIndex: 0,
      explanation: 'FAS mempengaruhi kuat tekan beton.',
    ),
    QuestionItem(
      questionText: 'Uji "Slump Test" pada beton segar dilakukan untuk mengukur:',
      options: ['Kekerasan beton', 'Workability / Kekentalan campuran beton', 'Daya tahan api', 'Kecepatan pengeringan'],
      correctOptionIndex: 1,
      explanation: 'Slump test mengukur kemudahan pengerjaan beton segar.',
    ),
    QuestionItem(
      questionText: 'Struktur rangka batang pada atap bangunan yang membentuk segi tiga disebut:',
      options: ['Truss / Kuda-kuda', 'Konsol', 'Pilar', 'Rigid Frame'],
      correctOptionIndex: 0,
      explanation: 'Truss/kuda-kuda membentuk struktur rangka atap.',
    ),
    QuestionItem(
      questionText: 'Ilmu teknik sipil yang mempelajari perilaku tanah di bawah beban struktur disebut:',
      options: ['Mekanika Tanah (Geoteknik)', 'Hidrologi', 'Struktur Baja', 'Manajemen Konstruksi'],
      correctOptionIndex: 0,
      explanation: 'Mekanika tanah mendasari perencanaan geoteknik.',
    ),
  ];
}
