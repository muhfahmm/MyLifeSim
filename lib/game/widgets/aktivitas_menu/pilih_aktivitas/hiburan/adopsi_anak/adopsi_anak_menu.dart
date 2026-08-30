// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/adopsi_anak/adopsi_anak_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'pilih_anak/pilih_anak_page.dart'; // import halaman pilih anak

class AdopsiAnakMenuHelper {
  static void showAdopsiAnakMenu(BuildContext context, Character character, VoidCallback onComplete) {
    // Validasi umur
    if (character.age < 21) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 21 tahun untuk mengadopsi anak.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdopsiAnakPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class AdopsiAnakPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const AdopsiAnakPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<AdopsiAnakPage> createState() => _AdopsiAnakPageState();
}

class _AdopsiAnakPageState extends State<AdopsiAnakPage> {
  // Kategori umur yang tersedia
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Bayi & Balita (0-3 tahun) 👶',
      'minAge': 0,
      'maxAge': 3,
      'baseCost': 45000,
      'desc': 'Bayi dan balita yang membutuhkan kasih sayang penuh',
    },
    {
      'name': 'Anak Kecil (4-7 tahun) 🧒',
      'minAge': 4,
      'maxAge': 7,
      'baseCost': 25000,
      'desc': 'Anak kecil yang aktif, ceria, dan mulai belajar mandiri',
    },
    {
      'name': 'Anak (8-12 tahun) 👦👧',
      'minAge': 8,
      'maxAge': 12,
      'baseCost': 15000,
      'desc': 'Anak yang sudah mandiri dan siap menempuh pendidikan dasar',
    },
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopsi Anak 👶🧒', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: \$${_fmt(widget.character.money)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final int cost = cat['baseCost'] as int;
                  const bool canAfford = true;
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        cat['name'], 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${cat['desc']}\nBiaya: \$${_fmt(cost)}',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                      ),
                      onTap: () {
                        // Navigasi ke halaman pilih anak
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PilihAnakPage(
                              character: widget.character,
                              category: cat,
                              onComplete: widget.onComplete,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}