import '../tes_seleksi_model.dart';
import 'tes_manajemen.dart';
import 'tes_akuntansi.dart';

List<QuestionItem> getBisnisEkonomiQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('akuntansi')) {
    return getAkuntansiQuestions();
  } else {
    return getManajemenQuestions();
  }
}
