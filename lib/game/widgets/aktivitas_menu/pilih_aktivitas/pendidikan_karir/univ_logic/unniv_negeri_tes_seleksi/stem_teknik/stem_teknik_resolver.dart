import '../tes_seleksi_model.dart';

import 'tes_teknik_informatika.dart';
import 'tes_sistem_informasi.dart';
import 'tes_teknik_sipil.dart';
import 'tes_teknik_elektro.dart';

List<QuestionItem> getStemTeknikQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('informatika') || m.contains('komputer')) {
    return getTeknikInformatikaQuestions();
  } else if (m.contains('sistem informasi')) {
    return getSistemInformasiQuestions();
  } else if (m.contains('sipil') || m.contains('arsitektur')) {
    return getTeknikSipilQuestions();
  } else if (m.contains('elektro')) {
    return getTeknikElektroQuestions();
  } else {
    return getTeknikInformatikaQuestions();
  }
}
