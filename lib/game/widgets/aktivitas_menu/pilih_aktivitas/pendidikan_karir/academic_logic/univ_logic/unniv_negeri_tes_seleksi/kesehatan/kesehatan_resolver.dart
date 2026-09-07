import '../tes_seleksi_model.dart';
import 'tes_kedokteran.dart';
import 'tes_farmasi.dart';
import 'tes_kedokteran_gigi.dart';
import 'tes_keperawatan.dart';
import 'tes_gizi_ilmu_pangan.dart';

List<QuestionItem> getKesehatanQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('farmasi')) {
    return getFarmasiQuestions();
  } else if (m.contains('gigi')) {
    return getKedokteranGigiQuestions();
  } else if (m.contains('perawat') || m.contains('keperawatan')) {
    return getKeperawatanQuestions();
  } else if (m.contains('gizi') || m.contains('pangan')) {
    return getGiziIlmuPanganQuestions();
  } else {
    return getKedokteranQuestions();
  }
}
