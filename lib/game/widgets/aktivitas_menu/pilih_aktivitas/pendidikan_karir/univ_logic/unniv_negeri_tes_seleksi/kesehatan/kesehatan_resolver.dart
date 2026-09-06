import '../tes_seleksi_model.dart';
import 'tes_kedokteran.dart';
import 'tes_farmasi.dart';

List<QuestionItem> getKesehatanQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('farmasi')) {
    return getFarmasiQuestions();
  } else {
    return getKedokteranQuestions();
  }
}
