import '../tes_seleksi_model.dart';

List<QuestionItem> getKedokteranQuestions() {
  return const [
    QuestionItem(
      questionText: 'Organ tubuh manusia yang berfungsi memompa darah ke seluruh tubuh adalah:',
      options: ['Hati', 'Jantung', 'Paru-paru', 'Ginjal'],
      correctOptionIndex: 1,
      explanation: 'Jantung bertugas memompa darah.',
    ),
    QuestionItem(
      questionText: 'Pembuluh darah yang membawa darah kembali menuju ke jantung disebut:',
      options: ['Arteri', 'Vena', 'Kapiler', 'Aorta'],
      correctOptionIndex: 1,
      explanation: 'Vena mengalirkan darah kembali ke jantung.',
    ),
    QuestionItem(
      questionText: 'Jumlah tulang rusuk pada manusia normal adalah:',
      options: ['10 pasang', '12 pasang', '14 pasang', '16 pasang'],
      correctOptionIndex: 1,
      explanation: 'Manusia memiliki 12 pasang tulang rusuk.',
    ),
    QuestionItem(
      questionText: 'Hormon yang berfungsi menurunkan kadar gula dalam darah adalah:',
      options: ['Glukagon', 'Insulin', 'Adrenalin', 'Tiroksin'],
      correctOptionIndex: 1,
      explanation: 'Insulin diproduksi oleh pankreas untuk menurunkan gula darah.',
    ),
    QuestionItem(
      questionText: 'Sistem organ yang bertanggung jawab menyaring limbah dari darah dan membentuk urine adalah:',
      options: ['Sistem Pencernaan', 'Sistem Eksresi (Ginjal)', 'Sistem Limfatik', 'Sistem Endokrin'],
      correctOptionIndex: 1,
      explanation: 'Ginjal menyaring darah untuk menghasilkan urine.',
    ),
    QuestionItem(
      questionText: 'Vitamin yang penting untuk pembekuan darah adalah:',
      options: ['Vitamin A', 'Vitamin C', 'Vitamin D', 'Vitamin K'],
      correctOptionIndex: 3,
      explanation: 'Vitamin K berperan pada koagulasi darah.',
    ),
    QuestionItem(
      questionText: 'Bagian otak yang mengontrol keseimbangan dan koordinasi gerakan adalah:',
      options: ['Cerebrum', 'Cerebellum', 'Medulla Oblongata', 'Hypothalamus'],
      correctOptionIndex: 1,
      explanation: 'Cerebellum (otak kecil) mengontrol keseimbangan.',
    ),
    QuestionItem(
      questionText: 'Tekanan darah sistolik normal pada orang dewasa sehat berada di kisaran:',
      options: ['70-80 mmHg', '110-120 mmHg', '140-150 mmHg', '160-180 mmHg'],
      correctOptionIndex: 1,
      explanation: 'Sistolik normal sekitar 120 mmHg.',
    ),
    QuestionItem(
      questionText: 'Sel darah merah (Eritrosit) berwarna merah karena mengandung protein:',
      options: ['Fibrinogen', 'Hemoglobin', 'Albumin', 'Globulin'],
      correctOptionIndex: 1,
      explanation: 'Hemoglobin mengikat oksigen dan memberi warna merah.',
    ),
    QuestionItem(
      questionText: 'Penyakit yang disebabkan oleh kekurangan hormon insulin atau resistensi insulin disebut:',
      options: ['Hipertensi', 'Diabetes Mellitus', 'Anemia', 'Hipotroidisme'],
      correctOptionIndex: 1,
      explanation: 'Diabetes Mellitus berkaitan dengan gangguan insulin.',
    ),
  ];
}
