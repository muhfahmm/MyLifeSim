import 'tes_seleksi_model.dart';

import 'stem_teknik/stem_teknik_resolver.dart';
import 'kesehatan/kesehatan_resolver.dart';
import 'bisnis_ekonomi/bisnis_ekonomi_resolver.dart';
import 'hukum_sosial/hukum_sosial_resolver.dart';
import 'pendidikan_bahasa/pendidikan_bahasa_resolver.dart';
import 'kreatif_seni/kreatif_seni_resolver.dart';
import 'pertanian_lainnya/pertanian_lainnya_resolver.dart';
import 'tes_general_questions.dart';

List<QuestionItem> getQuestionsForMajor(String majorName) {
  final String m = majorName.toLowerCase();

  // 1. STEM & TEKNIK
  if (m.contains('teknik') || m.contains('sistem informasi') || m.contains('komputer') || m.contains('arsitektur')) {
    return getStemTeknikQuestions(majorName);
  }
  // 2. KESEHATAN
  else if (m.contains('kedokteran') || m.contains('dokter') || m.contains('farmasi') || m.contains('perawat') || m.contains('gizi')) {
    return getKesehatanQuestions(majorName);
  }
  // 3. BISNIS & EKONOMI
  else if (m.contains('manajemen') || m.contains('akuntansi') || m.contains('ekonomi') || m.contains('keuangan') || m.contains('pemasaran')) {
    return getBisnisEkonomiQuestions(majorName);
  }
  // 4. HUKUM & SOSIAL
  else if (m.contains('hukum') || m.contains('psikologi') || m.contains('komunikasi') || m.contains('hubungan') || m.contains('publik') || m.contains('kriminologi')) {
    return getHukumSosialQuestions(majorName);
  }
  // 5. PENDIDIKAN & BAHASA
  else if (m.contains('sastra') || m.contains('bahasa') || m.contains('pendidikan') || m.contains('pgsd')) {
    return getPendidikanBahasaQuestions(majorName);
  }
  // 6. KREATIF & SENI
  else if (m.contains('desain') || m.contains('dkv') || m.contains('film') || m.contains('musik') || m.contains('seni')) {
    return getKreatifSeniQuestions(majorName);
  }
  // 7. PERTANIAN & LAINNYA
  else if (m.contains('agroteknologi') || m.contains('pertanian') || m.contains('perhotelan') || m.contains('pangan')) {
    return getPertanianLainnyaQuestions(majorName);
  }
  // Fallback
  else {
    return getGeneralQuestionsForMajor(majorName);
  }
}
