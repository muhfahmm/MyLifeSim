// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/sosial_media_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

// Import halaman dashboard sosial media
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/medsos_dashboard/medsos_dashboard.dart';

import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/batasan_sosmed_logic/batasan_sosmed_logic.dart';

class SocialMediaMenuHelper {
  static const List<Map<String, dynamic>> platforms = [
    {'name': 'YouTube', 'icon': Icons.play_circle_filled, 'color': Colors.red},
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
    {'name': 'X (Twitter)', 'icon': Icons.chat, 'color': Colors.black},
    {'name': 'Telegram', 'icon': Icons.telegram, 'color': Colors.blue},
  ];

  // Fungsi ini memeriksa batasan negara & usia sebelum membuka menu sosial media
  static void showSocialMediaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    final String currentCountry = character.location.isNotEmpty ? character.location : (character.birthCountry ?? 'Indonesia');
    final hasilPemeriksaan = BatasanSosmedLogic.periksaAksesSosmed(
      country: currentCountry,
      age: character.age,
    );

    if (!hasilPemeriksaan.diizinkan) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(hasilPemeriksaan.judul),
          content: Text(hasilPemeriksaan.pesan),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Redirect ke halaman baru
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SocialMediaMenuPage(character: character, onComplete: onComplete),
      ),
    );
  }
}

// Halaman penuh untuk menu sosial media
class SocialMediaMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const SocialMediaMenuPage({Key? key, required this.character, required this.onComplete}) : super(key: key);

  @override
  State<SocialMediaMenuPage> createState() => _SocialMediaMenuPageState();
}

class _SocialMediaMenuPageState extends State<SocialMediaMenuPage> {
  Character get character => widget.character;

  int _getTotalFollowers() {
    int total = 0;
    for (var p in SocialMediaMenuHelper.platforms) {
      total += character.platformFollowers[p['name']] ?? 0;
    }
    return total;
  }

  String _fmt(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sosial Media 📱'),
        backgroundColor: isDark ? Colors.blueGrey.shade900 : Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Pengikut (Update real-time setiap kali build)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? Colors.blue.shade700 : Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, color: isDark ? Colors.lightBlueAccent : Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text(
                    'Total Pengikut (Followers): ${_fmt(_getTotalFollowers())}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.lightBlueAccent : Colors.blueAccent,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Daftar Platform
            ...SocialMediaMenuHelper.platforms.map((platform) {
              String name = platform['name'];
              IconData icon = platform['icon'];
              Color color = platform['color'];
              int followers = character.platformFollowers[name] ?? 0;

              // Untuk dark mode, warna hitam di Twitter harus diganti
              Color platformColor = color;
              if (isDark && name == 'X (Twitter)') {
                platformColor = Colors.white;
              }

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: Icon(icon, color: platformColor, size: 32),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Pengikut: ${_fmt(followers)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                  onTap: () async {
                    // Redirect ke dashboard platform
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedSosDashboard(
                          platformName: name,
                          character: character,
                          onComplete: widget.onComplete,
                        ),
                      ),
                    );
                    // Setelah kembali dari dashboard, update UI real-time
                    setState(() {});
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}