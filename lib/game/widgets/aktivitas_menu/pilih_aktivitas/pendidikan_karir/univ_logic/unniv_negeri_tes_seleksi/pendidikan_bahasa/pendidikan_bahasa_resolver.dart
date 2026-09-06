import '../tes_seleksi_model.dart';

// Import Sastra
import 'tes_sastra_bahasa/sastra/tes_sastra_indonesia.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_inggris.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_jepang.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_mandarin.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_arab.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_korea.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_jerman.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_prancis.dart';
import 'tes_sastra_bahasa/sastra/tes_sastra_rusia.dart';

// Import Bahasa
import 'tes_sastra_bahasa/bahasa/tes_bahasa_indonesia.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_inggris.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_jepang.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_mandarin.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_arab.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_korea.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_jerman.dart';
import 'tes_sastra_bahasa/bahasa/tes_bahasa_prancis.dart';
import 'tes_sastra_bahasa/bahasa/tes_linguistik_terapan.dart';

List<QuestionItem> getPendidikanBahasaQuestions(String major) {
  final String m = major.toLowerCase();

  // Kategori Sastra
  if (m.contains('sastra indonesia')) {
    return getTesSastraIndonesiaQuestions();
  } else if (m.contains('sastra inggris')) {
    return getTesSastraInggrisQuestions();
  } else if (m.contains('sastra jepang')) {
    return getTesSastraJepangQuestions();
  } else if (m.contains('sastra mandarin') || m.contains('sastra china')) {
    return getTesSastraMandarinQuestions();
  } else if (m.contains('sastra arab')) {
    return getTesSastraArabQuestions();
  } else if (m.contains('sastra korea')) {
    return getTesSastraKoreaQuestions();
  } else if (m.contains('sastra jerman')) {
    return getTesSastraJermanQuestions();
  } else if (m.contains('sastra prancis')) {
    return getTesSastraPrancisQuestions();
  } else if (m.contains('sastra rusia')) {
    return getTesSastraRusiaQuestions();
  }

  // Kategori Bahasa
  else if (m.contains('bahasa') && m.contains('indonesia')) {
    return getTesBahasaIndonesiaQuestions();
  } else if (m.contains('bahasa') && m.contains('inggris')) {
    return getTesBahasaInggrisQuestions();
  } else if (m.contains('bahasa') && m.contains('jepang')) {
    return getTesBahasaJepangQuestions();
  } else if (m.contains('bahasa') && m.contains('mandarin')) {
    return getTesBahasaMandarinQuestions();
  } else if (m.contains('bahasa') && m.contains('arab')) {
    return getTesBahasaArabQuestions();
  } else if (m.contains('bahasa') && m.contains('korea')) {
    return getTesBahasaKoreaQuestions();
  } else if (m.contains('bahasa') && m.contains('jerman')) {
    return getTesBahasaJermanQuestions();
  } else if (m.contains('bahasa') && m.contains('prancis')) {
    return getTesBahasaPrancisQuestions();
  } else if (m.contains('linguistik') || m.contains('penerjemahan')) {
    return getTesLinguistikTerapanQuestions();
  }

  // Default fallback (misalnya Sastra Indonesia)
  return getTesSastraIndonesiaQuestions();
}
