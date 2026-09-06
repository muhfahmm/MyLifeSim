// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/esport_roster.dart
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class EsportRoster {
  static final List<String> divisions = [
    'Mobile Legends: Bang Bang',
    'PUBG Mobile',
    'Free Fire',
    'Valorant',
  ];

  /// Generate daftar pro player untuk tim tertentu dengan mengambil nama dari database global Character
  static Map<String, List<String>> generateProPlayers(String teamName) {
    final random = Random(teamName.hashCode); // Seed agar roster konsisten untuk tim yang sama
    Map<String, List<String>> roster = {};

    final maleFirsts = Character.globalMaleFirstNames.isNotEmpty 
        ? Character.globalMaleFirstNames 
        : ['Rian', 'Fatur', 'Bagas', 'Kevin', 'Liem', 'Albert', 'Vyn', 'Sanz', 'Kiboy', 'Butsss'];
    final lasts = Character.globalLastNames.isNotEmpty 
        ? Character.globalLastNames 
        : ['Pratama', 'Saputra', 'Wijaya', 'Kusuma', 'Santoso', 'Hidayat', 'Setiawan', 'Gunawan'];

    for (var div in divisions) {
      List<String> players = [];
      int playerCount = 4 + random.nextInt(2); // 4-5 players
      for (int i = 0; i < playerCount; i++) {
        final nick = maleFirsts[random.nextInt(maleFirsts.length)];
        final last = lasts[random.nextInt(lasts.length)];
        players.add('$nick "${nick.substring(0, min(3, nick.length))}${random.nextInt(99)}" $last');
      }
      roster[div] = players;
    }
    return roster;
  }

  /// Generate daftar Brand Ambassador untuk tim tertentu dengan mengambil nama dari database global Character
  static List<String> generateBAs(String teamName) {
    final random = Random(teamName.hashCode + 99); // Seed berbeda
    List<String> bas = [];
    int baCount = 3 + random.nextInt(3); // 3-5 BAs

    final femaleFirsts = Character.globalFemaleFirstNames.isNotEmpty 
        ? Character.globalFemaleFirstNames 
        : ['Rachel', 'Vior', 'Kayes', 'Angie', 'Gebian', 'Anisa', 'Lidia', 'Sheryl', 'Notnot', 'Mute'];
    final lasts = Character.globalLastNames.isNotEmpty 
        ? Character.globalLastNames 
        : ['Pratama', 'Saputra', 'Wijaya', 'Kusuma', 'Santoso', 'Hidayat', 'Setiawan', 'Gunawan'];

    for (int i = 0; i < baCount; i++) {
      final name = femaleFirsts[random.nextInt(femaleFirsts.length)];
      final last = lasts[random.nextInt(lasts.length)];
      bas.add('$name $last');
    }
    return bas;
  }
}
