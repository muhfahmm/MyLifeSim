import '../tes_seleksi_model.dart';
import 'tes_dkv.dart';
import 'tes_desain_mode.dart';
import 'tes_film_televisi.dart';
import 'tes_seni_musik.dart';

List<QuestionItem> getKreatifSeniQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('mode') || m.contains('busana') || m.contains('fashion') || m.contains('pakaian')) {
    return getDesainModeQuestions();
  }
  if (m.contains('film') || m.contains('televisi') || m.contains('tv') || m.contains('sinema')) {
    return getFilmTelevisiQuestions();
  }
  if (m.contains('musik') || m.contains('lagu') || m.contains('vokal') || m.contains('instrumen')) {
    return getSeniMusikQuestions();
  }
  return getDkvQuestions();
}
