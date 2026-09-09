// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/database_tim_olahraga.dart

import 'sepakbola/indonesia.dart';
import 'sepakbola/inggris.dart';
import 'sepakbola/spanyol.dart';
import 'sepakbola/jerman.dart';
import 'sepakbola/italia.dart';
import 'sepakbola/prancis.dart';
import 'basket/indonesia.dart';
import 'basket/amerika.dart';
import 'bulutangkis/indonesia.dart';
import 'balap/internasional.dart';
import 'tinju_mma/internasional.dart';
import 'tenis/internasional.dart';
import 'renang/internasional.dart';
import 'catur/internasional.dart';

class TimOlahragaDatabase {
  static List<Map<String, String>> getTeamsBySport(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'sepakbola':
        return [
          ...TimSepakbolaIndonesia.teams,
          ...TimSepakbolaInggris.teams,
          ...TimSepakbolaSpanyol.teams,
          ...TimSepakbolaJerman.teams,
          ...TimSepakbolaItalia.teams,
          ...TimSepakbolaPrancis.teams,
        ];
      case 'basket':
        return [
          ...TimBasketIndonesia.teams,
          ...TimBasketAmerika.teams,
        ];
      case 'bulu tangkis':
        return TimBuluTangkisIndonesia.teams;
      case 'balap motor & mobil':
        return TimBalapInternasional.teams;
      case 'tinju & mma':
        return TimTinjuMMAInternasional.teams;
      case 'tenis':
        return TimTenisInternasional.teams;
      case 'renang':
        return TimRenangInternasional.teams;
      case 'catur':
        return TimCaturInternasional.teams;
      default:
        return [
          {'name': 'Klub Profesional Nasional', 'origin': 'Indonesia', 'league': 'Liga Nasional'},
          {'name': 'Klub Profesional Internasional', 'origin': 'Internasional', 'league': 'Liga Dunia'},
        ];
    }
  }

  static List<String> getLeaguesBySport(String sportName) {
    final teams = getTeamsBySport(sportName);
    final Set<String> leagues = {};
    for (var team in teams) {
      if (team['league'] != null && team['league']!.isNotEmpty) {
        leagues.add(team['league']!);
      }
    }
    return leagues.toList();
  }
}
