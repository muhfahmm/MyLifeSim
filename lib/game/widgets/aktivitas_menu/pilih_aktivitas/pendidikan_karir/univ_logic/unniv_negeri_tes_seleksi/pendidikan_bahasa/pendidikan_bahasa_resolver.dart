import 'dart:math';
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

// Import PGSD Sub-Subjects
import 'tes_pendidikan_pgsd/tes_pgsd_bahasa_indonesia.dart';
import 'tes_pendidikan_pgsd/tes_pgsd_matematika.dart';
import 'tes_pendidikan_pgsd/tes_pgsd_ipa.dart';
import 'tes_pendidikan_pgsd/tes_pgsd_ips.dart';
import 'tes_pendidikan_pgsd/tes_pgsd_karakter_warga_negara.dart';
import 'tes_pendidikan_pgsd/tes_pgsd_seni_budaya.dart';
import 'tes_pendidikan_pgsd/tes_pgsd_olahraga.dart';

// Import Pendidikan Agama
import 'tes_pendidikan_agama/tes_pendidikan_agama_islam.dart';
import 'tes_pendidikan_agama/tes_pendidikan_agama_kristen.dart';
import 'tes_pendidikan_agama/tes_pendidikan_agama_katolik.dart';
import 'tes_pendidikan_agama/tes_pendidikan_agama_hindu.dart';
import 'tes_pendidikan_agama/tes_pendidikan_agama_buddha.dart';
import 'tes_pendidikan_agama/tes_pendidikan_agama_khonghucu.dart';

List<QuestionItem> getPendidikanBahasaQuestions(String major) {
  final String m = major.toLowerCase();

  // Kategori Pendidikan Agama Spesifik
  if (m.contains('agama islam') || m.contains('pendidikan agama islam') || m.contains('pai')) {
    return getTesPendidikanAgamaIslamQuestions();
  } else if (m.contains('agama kristen') || m.contains('pendidikan agama kristen') || m.contains('pak')) {
    return getTesPendidikanAgamaKristenQuestions();
  } else if (m.contains('agama katolik') || m.contains('pendidikan agama katolik')) {
    return getTesPendidikanAgamaKatolikQuestions();
  } else if (m.contains('agama hindu') || m.contains('pendidikan agama hindu')) {
    return getTesPendidikanAgamaHinduQuestions();
  } else if (m.contains('agama buddha') || m.contains('pendidikan agama buddha')) {
    return getTesPendidikanAgamaBuddhaQuestions();
  } else if (m.contains('agama khonghucu') || m.contains('pendidikan agama khonghucu')) {
    return getTesPendidikanAgamaKhonghucuQuestions();
  } else if (m.contains('pendidikan agama')) {
    final List<QuestionItem> agamaPool = [
      ...getTesPendidikanAgamaIslamQuestions(),
      ...getTesPendidikanAgamaKristenQuestions(),
      ...getTesPendidikanAgamaKatolikQuestions(),
      ...getTesPendidikanAgamaHinduQuestions(),
      ...getTesPendidikanAgamaBuddhaQuestions(),
      ...getTesPendidikanAgamaKhonghucuQuestions(),
    ];
    agamaPool.shuffle(Random());
    return agamaPool;
  }

  // Kategori Pendidikan / PGSD (Kombinasi 7 Sub-Mata Pelajaran)
  if (m.contains('pgsd') || m.contains('pendidikan / pgsd')) {
    final List<QuestionItem> pgsdPool = [
      ...getTesPgsdBahasaIndonesiaQuestions(),
      ...getTesPgsdMatematikaQuestions(),
      ...getTesPgsdIpaQuestions(),
      ...getTesPgsdIpsQuestions(),
      ...getTesPgsdKarakterWargaNegaraQuestions(),
      ...getTesPgsdSeniBudayaQuestions(),
      ...getTesPgsdOlahragaQuestions(),
    ];
    pgsdPool.shuffle(Random());
    return pgsdPool;
  }

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

  // Default fallback
  return getTesSastraIndonesiaQuestions();
}
