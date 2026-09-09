// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/database_tim_olahraga.dart

import 'sepakbola/indonesia.dart';
import 'sepakbola/inggris.dart';
import 'sepakbola/spanyol.dart';
import 'sepakbola/jerman.dart';
import 'sepakbola/italia.dart';
import 'sepakbola/prancis.dart';
import 'basket/indonesia.dart';
import 'basket/amerika.dart';
import 'balap/internasional.dart';
import 'tinju_mma/internasional.dart';
import 'tenis/internasional.dart';
import 'renang/internasional.dart';

class TimOlahragaDatabase {
  static List<Map<String, String>> getTeamsBySport(String sportName) {
    final String s = sportName.toLowerCase();
    if (s.contains('sepakbola')) {
      return [
        ...TimSepakbolaIndonesia.teams,
        ...TimSepakbolaInggris.teams,
        ...TimSepakbolaSpanyol.teams,
        ...TimSepakbolaJerman.teams,
        ...TimSepakbolaItalia.teams,
        ...TimSepakbolaPrancis.teams,
      ];
    } else if (s.contains('basket')) {
      return [
        ...TimBasketIndonesia.teams,
        ...TimBasketAmerika.teams,
      ];
    } else if (s.contains('balap')) {
      return TimBalapInternasional.teams;
    } else if (s.contains('tinju') || s.contains('mma')) {
      return TimTinjuMMAInternasional.teams;
    } else if (s.contains('tenis')) {
      return TimTenisInternasional.teams;
    } else if (s.contains('renang')) {
      return TimRenangInternasional.teams;
    } else {
      return [
        {'name': 'Klub Profesional Nasional', 'origin': 'Indonesia', 'league': 'Liga Nasional'},
        {'name': 'Klub Profesional Internasional', 'origin': 'Internasional', 'league': 'Liga Dunia'},
      ];
    }
  }

  static int getLeagueTeamCount(String teamName) {
    final allTeams = [
      ...TimSepakbolaIndonesia.teams,
      ...TimSepakbolaInggris.teams,
      ...TimSepakbolaSpanyol.teams,
      ...TimSepakbolaJerman.teams,
      ...TimSepakbolaItalia.teams,
      ...TimSepakbolaPrancis.teams,
      ...TimBasketIndonesia.teams,
      ...TimBasketAmerika.teams,
      ...TimBalapInternasional.teams,
      ...TimTinjuMMAInternasional.teams,
      ...TimTenisInternasional.teams,
      ...TimRenangInternasional.teams,
    ];

    final matchedTeam = allTeams.firstWhere(
      (t) => (t['name'] ?? '').toLowerCase() == teamName.toLowerCase(),
      orElse: () => {},
    );

    if (matchedTeam.isNotEmpty && matchedTeam['league'] != null) {
      final String league = matchedTeam['league']!;
      final int leagueTeams = allTeams.where((t) => t['league'] == league).length;
      if (leagueTeams > 1) {
        return leagueTeams;
      }
    }
    return 8; // Default 8 tim
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
