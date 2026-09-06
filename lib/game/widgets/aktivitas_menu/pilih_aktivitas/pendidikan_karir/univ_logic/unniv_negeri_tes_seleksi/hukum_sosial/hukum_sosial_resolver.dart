import '../tes_seleksi_model.dart';
import 'tes_hukum.dart';
import 'tes_psikologi.dart';
import 'tes_hubungan_internasional.dart';
import 'tes_ilmu_komunikasi.dart';
import 'tes_administrasi_publik.dart';
import 'tes_kriminologi.dart';

List<QuestionItem> getHukumSosialQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('psikologi')) {
    return getPsikologiQuestions();
  } else if (m.contains('hubungan internasional') || m.contains('hi')) {
    return getHubunganInternasionalQuestions();
  } else if (m.contains('komunikasi')) {
    return getIlmuKomunikasiQuestions();
  } else if (m.contains('administrasi publik') || m.contains('negara')) {
    return getAdministrasiPublikQuestions();
  } else if (m.contains('kriminologi')) {
    return getKriminologiQuestions();
  } else {
    return getHukumQuestions();
  }
}
