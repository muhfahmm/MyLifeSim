import '../tes_seleksi_model.dart';
import 'tes_hukum.dart';
import 'tes_psikologi.dart';

List<QuestionItem> getHukumSosialQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('psikologi')) {
    return getPsikologiQuestions();
  } else {
    return getHukumQuestions();
  }
}
