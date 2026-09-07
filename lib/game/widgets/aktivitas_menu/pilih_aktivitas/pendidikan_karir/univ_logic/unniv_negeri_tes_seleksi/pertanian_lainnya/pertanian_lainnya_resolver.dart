import '../tes_seleksi_model.dart';
import 'tes_agroteknologi.dart';
import 'tes_manajemen_perhotelan.dart';

List<QuestionItem> getPertanianLainnyaQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('hotel') || m.contains('perhotelan') || m.contains('hospitality') || m.contains('pariwisata')) {
    return getManajemenPerhotelanQuestions();
  }
  return getAgroteknologiQuestions();
}
