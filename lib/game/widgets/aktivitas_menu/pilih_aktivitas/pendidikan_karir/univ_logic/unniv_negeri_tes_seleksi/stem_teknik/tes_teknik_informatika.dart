import '../tes_seleksi_model.dart';

List<QuestionItem> getTeknikInformatikaQuestions() {
  return const [
    QuestionItem(
      questionText: 'Kompleksitas waktu terbaik untuk algoritma Pencarian Biner (Binary Search) adalah:',
      options: ['O(1)', 'O(log n)', 'O(n)', 'O(n^2)'],
      correctOptionIndex: 0,
      explanation: 'Pencarian biner menemukan elemen di tengah pada langkah pertama O(1).',
    ),
    QuestionItem(
      questionText: 'Struktur data mana yang menerapkan prinsip LIFO (Last In First Out)?',
      options: ['Queue', 'Stack', 'Array', 'Linked List'],
      correctOptionIndex: 1,
      explanation: 'Stack menggunakan konsep LIFO.',
    ),
    QuestionItem(
      questionText: 'Apa kepanjangan dari SQL?',
      options: ['Structured Query Language', 'Simple Query Logic', 'System Quality Language', 'Sequential Query List'],
      correctOptionIndex: 0,
      explanation: 'SQL berarti Structured Query Language.',
    ),
    QuestionItem(
      questionText: 'Manakah protokol yang berjalan di port default 443?',
      options: ['HTTP', 'HTTPS', 'FTP', 'SSH'],
      correctOptionIndex: 1,
      explanation: 'HTTPS menggunakan port 443.',
    ),
    QuestionItem(
      questionText: 'Konsep Pemrograman Berorientasi Objek di mana kelas turunan mewarisi sifat dari kelas induk disebut:',
      options: ['Encapsulation', 'Inheritance', 'Polymorphism', 'Abstraction'],
      correctOptionIndex: 1,
      explanation: 'Inheritance atau pewarisan.',
    ),
    QuestionItem(
      questionText: 'Fungsi utama dari CPU (Central Processing Unit) adalah:',
      options: ['Menyimpan data jangka panjang', 'Mengolah instruksi dan eksekusi program', 'Menampilkan grafik di layar', 'Menyuplai daya ke motherboard'],
      correctOptionIndex: 1,
      explanation: 'CPU bertugas memproses instruksi aritmatika dan logika.',
    ),
    QuestionItem(
      questionText: 'Format bilangan berbasis 16 disebut bilangan:',
      options: ['Biner', 'Oktal', 'Desimal', 'Heksadesimal'],
      correctOptionIndex: 3,
      explanation: 'Basis 16 adalah heksadesimal.',
    ),
    QuestionItem(
      questionText: 'Algoritma pengurutan (sorting) yang membagi himpunan data menjadi dua bagian secara rekursif adalah:',
      options: ['Bubble Sort', 'Selection Sort', 'Merge Sort', 'Insertion Sort'],
      correctOptionIndex: 2,
      explanation: 'Merge sort mengadopsi pendekatan Divide and Conquer.',
    ),
    QuestionItem(
      questionText: 'Istilah "Deadlock" dalam Sistem Operasi mengacu pada:',
      options: ['Kondisi memori penuh', 'Kondisi 2 atau lebih proses saling menunggu sumber daya secara permanen', 'Proses booting yang gagal', 'Serangan malware dari jaringan'],
      correctOptionIndex: 1,
      explanation: 'Deadlock terjadi saat proses terjebak saling menunggu.',
    ),
    QuestionItem(
      questionText: 'Manakah yang BUKAN merupakan tipe data primitif dalam bahasa pemrograman Java?',
      options: ['int', 'boolean', 'char', 'String'],
      correctOptionIndex: 3,
      explanation: 'String di Java adalah objek/referensi, bukan primitif.',
    ),
  ];
}
