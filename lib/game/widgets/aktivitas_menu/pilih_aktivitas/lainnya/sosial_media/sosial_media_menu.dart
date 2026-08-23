// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/sosial_media_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// Import halaman dashboard sosial media
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/medsos_dashboard/medsos_dashboard.dart';

class SocialMediaMenuHelper {
  static const List<Map<String, dynamic>> platforms = [
    {'name': 'YouTube', 'icon': Icons.play_circle_filled, 'color': Colors.red},
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
    {'name': 'X (Twitter)', 'icon': Icons.chat, 'color': Colors.black},
    {'name': 'Telegram', 'icon': Icons.telegram, 'color': Colors.blue},
  ];

  // Fungsi ini sekarang langsung mengarahkan ke halaman penuh, BUKAN modal!
  static void showSocialMediaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk memiliki akun sosial media.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sosial Media 📱'),
        backgroundColor: Colors.blueAccent,
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text(
                    'Total Pengikut (Followers): ${_fmt(_getTotalFollowers())}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 13),
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

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: Icon(icon, color: color, size: 32),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Pengikut: ${_fmt(followers)}', style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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