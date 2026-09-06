import '../tes_seleksi_model.dart';

List<QuestionItem> getSistemInformasiQuestions() {
  return const [
    QuestionItem(
      questionText: 'Komponen utama Sistem Informasi yang menghubungkan manusia, data, dan proses dinamakan:',
      options: ['Teknologi Informasi & Komunikasi', 'Hardware, Software, Data, Prosedur, Manusia', 'Server & Client', 'Database Management System'],
      correctOptionIndex: 1,
      explanation: 'Sistem informasi mencakup komponen teknis dan manusia/prosedur.',
    ),
    QuestionItem(
      questionText: 'Diagram yang digunakan untuk menggambarkan aliran data dalam suatu sistem informasi adalah:',
      options: ['Use Case Diagram', 'Data Flow Diagram (DFD)', 'Class Diagram', 'ERD'],
      correctOptionIndex: 1,
      explanation: 'DFD menggambarkan aliran data dalam sistem.',
    ),
    QuestionItem(
      questionText: 'Pemodelan relasi antar entitas beserta atributnya dalam perancangan basis data dinamakan:',
      options: ['Sequence Diagram', 'Entity Relationship Diagram (ERD)', 'Activity Diagram', 'Flowchart'],
      correctOptionIndex: 1,
      explanation: 'ERD memetakan entitas dan relasi basis data.',
    ),
    QuestionItem(
      questionText: 'Sistem yang mengintegrasikan seluruh proses bisnis inti perusahaan seperti keuangan, SDM, dan logistik adalah:',
      options: ['Customer Relationship Management (CRM)', 'Enterprise Resource Planning (ERP)', 'Supply Chain Management (SCM)', 'Decision Support System (DSS)'],
      correctOptionIndex: 1,
      explanation: 'ERP mengintegrasikan seluruh departemen perusahaan.',
    ),
    QuestionItem(
      questionText: 'Manakah metodologi pengembangan perangkat lunak yang berfokus pada iterasi cepat dan fleksibilitas?',
      options: ['Waterfall', 'Agile / Scrum', 'V-Model', 'Linear Sequential'],
      correctOptionIndex: 1,
      explanation: 'Agile menekankan iterasi cepat dan respon perubahan.',
    ),
    QuestionItem(
      questionText: 'Proses mengubah data mentah menjadi informasi yang berguna untuk pengambilan keputusan bisnis disebut:',
      options: ['Data Mining & Business Intelligence', 'Data Backup', 'Data Entry', 'Data Compression'],
      correctOptionIndex: 0,
      explanation: 'Business Intelligence & Data Mining mengolah data jadi wawasan.',
    ),
    QuestionItem(
      questionText: 'Tingkatan pengguna yang bertugas menjembatani antara kebutuhan bisnis pengguna dengan tim pengembang IT adalah:',
      options: ['System Analyst / Business Analyst', 'Database Administrator', 'Network Engineer', 'Quality Assurance'],
      correctOptionIndex: 0,
      explanation: 'Business Analyst menjembatani kebutuhan bisnis dan solusi IT.',
    ),
    QuestionItem(
      questionText: 'Istilah "Cloud Computing" mengacu pada pemrosesan dan penyimpanan data melalui:',
      options: ['Harddisk Lokal', 'Jaringan Internet / Server Terdistribusi', 'Flashdisk', 'Kabel LAN tanpa jaringan luar'],
      correctOptionIndex: 1,
      explanation: 'Cloud computing beroperasi di server terdistribusi internet.',
    ),
    QuestionItem(
      questionText: 'Metrik evaluasi dalam pengujian UI/UX yang mengukur kemudahan pengguna saat memakai aplikasi disebut:',
      options: ['Scalability', 'Usability', 'Maintainability', 'Portability'],
      correctOptionIndex: 1,
      explanation: 'Usability mengukur tingkat kemudahan penggunaan.',
    ),
    QuestionItem(
      questionText: 'Ancaman keamanan siber yang mengelabui pengguna agar memberikan informasi sensitif melalui email palsu disebut:',
      options: ['DDoS Attack', 'Phishing', 'Ransomware', 'SQL Injection'],
      correctOptionIndex: 1,
      explanation: 'Phishing mengelabui korban untuk mencuri kredensial.',
    ),
  ];
}
