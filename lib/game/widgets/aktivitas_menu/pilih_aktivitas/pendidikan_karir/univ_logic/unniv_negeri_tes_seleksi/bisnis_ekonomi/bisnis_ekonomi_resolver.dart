import '../tes_seleksi_model.dart';
import 'tes_manajemen.dart';
import 'tes_akuntansi.dart';
import 'tes_pemasaran_digital.dart';
import 'tes_ekonomi_pembangunan.dart';
import 'tes_perbankan_keuangan.dart';

List<QuestionItem> getBisnisEkonomiQuestions(String major) {
  final String m = major.toLowerCase();
  if (m.contains('akuntansi')) {
    return getAkuntansiQuestions();
  } else if (m.contains('pemasaran')) {
    return getPemasaranDigitalQuestions();
  } else if (m.contains('pembangunan') || m.contains('pembangunan ekonomi')) {
    return getEkonomiPembangunanQuestions();
  } else if (m.contains('bank') || m.contains('keuangan')) {
    return getPerbankanKeuanganQuestions();
  } else {
    return getManajemenQuestions();
  }
}
