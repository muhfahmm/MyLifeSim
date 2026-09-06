import '../tes_seleksi_model.dart';

List<QuestionItem> getSastraBahasaQuestions() {
  return const [
    QuestionItem(
      questionText: 'Cabang linguistik yang mempelajari struktur kalimat dan tata susunan kata dinamakan:',
      options: ['Fonologi', 'Morfologi', 'Sintaksis', 'Semantik'],
      correctOptionIndex: 2,
      explanation: 'Sintaksis mempelajari tata susunan kalimat.',
    ),
    QuestionItem(
      questionText: 'Ilmu yang mengkaji makna kata dan kalimat dalam bahasa dinamakan:',
      options: ['Pragmatik', 'Semantik', 'Stilistika', 'Leksikografi'],
      correctOptionIndex: 1,
      explanation: 'Semantik adalah cabang ilmu makna bahasa.',
    ),
    QuestionItem(
      questionText: 'Majas yang menggunakan kata-kata kiasan membandingkan benda mati seolah-olah memiliki sifat manusia disebut:',
      options: ['Hiperbola', 'Personifikasi', 'Metakflora', 'Alegori'],
      correctOptionIndex: 1,
      explanation: 'Personifikasi menginsankan benda mati.',
    ),
    QuestionItem(
      questionText: 'Satuan bunyi terkecil yang dapat membedakan makna kata dinamakan:',
      options: ['Fonem', 'Morfem', 'Klausa', 'Frasa'],
      correctOptionIndex: 0,
      explanation: 'Fonem adalah bunyi terkecil pembeda makna.',
    ),
    QuestionItem(
      questionText: 'Pengubahan bentuk kata dasar karena penambahan imbuhan (afiks) dinamakan proses:',
      options: ['Morfofonemik', 'Morfolitas', 'Afiksasi / Morfologi', 'Reduplikasi'],
      correctOptionIndex: 2,
      explanation: 'Afiksasi adalah pembentukan kata berimbuhan.',
    ),
    QuestionItem(
      questionText: 'Puisi lama Melayu yang terdiri dari 4 baris berima a-b-a-b dinamakan:',
      options: ['Gurindam', 'Syair', 'Pantun', 'Karmina'],
      correctOptionIndex: 2,
      explanation: 'Pantun berstruktur 4 baris bersajak a-b-a-b.',
    ),
    QuestionItem(
      questionText: 'Tokoh sastrawan Indonesia yang menulis novel legendaris "Bumi Manusia" adalah:',
      options: ['Pramoedya Ananta Toer', 'Chairil Anwar', 'Sutan Takdir Alisjahbana', 'Taufiq Ismail'],
      correctOptionIndex: 0,
      explanation: 'Pramoedya Ananta Toer adalah pengarang Tetralogi Buru.',
    ),
    QuestionItem(
      questionText: 'Pendekatan kajian sastra yang memfokuskan analisis pada unsur intrinsik teks saja disebut:',
      options: ['Formalisme / Strukturalisme', 'Sosiologi Sastra', 'Psikologi Sastra', 'Mimesis'],
      correctOptionIndex: 0,
      explanation: 'Strukturalisme mengkaji unsur intrinsik teks karya.',
    ),
    QuestionItem(
      questionText: 'Cabang ilmu linguistik yang mempelajari bunyi bahasa dan cara produksinya dinamakan:',
      options: ['Fonetik', 'Grafemik', 'Dialektologi', 'Etimologi'],
      correctOptionIndex: 0,
      explanation: 'Fonetik mempelajari cara organ bicara memproduksi bunyi.',
    ),
    QuestionItem(
      questionText: 'Karya tulis kamus dan penyusunannya dalam ilmu bahasa disebut:',
      options: ['Leksikografi', 'Etimologi', 'Filologi', 'Ortografi'],
      correctOptionIndex: 0,
      explanation: 'Leksikografi adalah teknik penyusunan kamus.',
    ),
  ];
}
