import '../tes_seleksi_model.dart';

import 'tes_teknik_informatika.dart';
import 'tes_sistem_informasi.dart';
import 'tes_teknik_sipil.dart';
import 'tes_teknik_elektro.dart';
import 'tes_teknik_mesin.dart';
import 'tes_teknik_kimia.dart';
import 'tes_arsitektur.dart';

List<QuestionItem> getStemTeknikQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('informatika') || m.contains('komputer')) {
    return getTeknikInformatikaQuestions();
  } else if (m.contains('sistem informasi')) {
    return getSistemInformasiQuestions();
  } else if (m.contains('sipil')) {
    return getTeknikSipilQuestions();
  } else if (m.contains('elektro')) {
    return getTeknikElektroQuestions();
  } else if (m.contains('mesin')) {
    return getTeknikMesinQuestions();
  } else if (m.contains('kimia')) {
    return getTeknikKimiaQuestions();
  } else if (m.contains('arsitektur')) {
    return getArsitekturQuestions();
  } else {
    return getTeknikInformatikaQuestions();
  }
}
