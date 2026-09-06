// lib/game/widgets/aktivitas_menu/pilih_aktivitas/kesehatan/olahraga_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class OlahragaMenuHelper {
  static void showOlahragaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OlahragaPage(character: character, onComplete: onComplete),
      ),
    );
  }
}

class OlahragaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const OlahragaPage({super.key, required this.character, required this.onComplete});

  @override
  State<OlahragaPage> createState() => _OlahragaPageState();
}

class _OlahragaPageState extends State<OlahragaPage> {
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Character character = widget.character;

    if (character.age < 7) {
      return Scaffold(
        appBar: AppBar(title: const Text('Olahraga'), backgroundColor: Colors.orange),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.no_accounts, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Terlalu Muda',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu belum cukup umur untuk berolahraga secara serius (minimal 7 tahun).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> olahraga = [
      {'name': 'Lari Pagi 🏃', 'health': 10, 'happiness': 5, 'intelligence': 0, 'desc': 'Berlari di pagi hari untuk kebugaran dasar.'},
      {'name': 'Gym / Angkat Beban 🏋️', 'health': 15, 'happiness': 5, 'intelligence': 0, 'desc': 'Latihan intensif di gym untuk membangun otot.'},
      {'name': 'Renang 🏊', 'health': 12, 'happiness': 8, 'intelligence': 0, 'desc': 'Olahraga seluruh tubuh yang menyenangkan.'},
      {'name': 'Yoga & Meditasi 🧘', 'health': 8, 'happiness': 12, 'intelligence': 3, 'desc': 'Menenangkan pikiran dan meregangkan tubuh.'},
      {'name': 'Sepeda 🚴', 'health': 10, 'happiness': 10, 'intelligence': 0, 'desc': 'Bersepeda santai atau menjelajah kota.'},
      {'name': 'Olahraga Tim ⚽', 'health': 10, 'happiness': 15, 'intelligence': 0, 'desc': 'Bergabung dengan tim sepak bola atau basket.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Jenis Olahraga'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: olahraga.length,
        itemBuilder: (context, index) {
          final o = olahraga[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              ),
            ),
            child: ListTile(
              leading: Icon(
                o['name'].contains('Lari') ? Icons.directions_run :
                o['name'].contains('Gym') ? Icons.fitness_center :
                o['name'].contains('Renang') ? Icons.pool :
                o['name'].contains('Yoga') ? Icons.self_improvement :
                o['name'].contains('Sepeda') ? Icons.directions_bike :
                Icons.sports_soccer,
                color: Colors.orange,
                size: 28,
              ),
              title: Text(
                o['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                o['desc'],
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              trailing: Text(
                '+${o['health']}❤️',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () => _executeOlahraga(context, o),
            ),
          );
        },
      ),
    );
  }

  void _executeOlahraga(BuildContext context, Map<String, dynamic> o) {
    final Character character = widget.character;
    final bool cedera = _random.nextInt(100) < 5;
    String resultMsg;

    if (cedera) {
      character.health = (character.health - 10).clamp(0, 100);
      character.happiness = (character.happiness - 5).clamp(0, 100);
      resultMsg = '😣 Kamu mengalami cedera saat ${o['name']}! Kesehatanmu turun (-10% Kesehatan, -5% Kebahagiaan).';
    } else {
      character.health = (character.health + (o['health'] as int)).clamp(0, 100);
      character.happiness = (character.happiness + (o['happiness'] as int)).clamp(0, 100);
      if ((o['intelligence'] as int) > 0) {
        character.intelligence = (character.intelligence + (o['intelligence'] as int)).clamp(0, 100);
      }
      resultMsg = '💪 ${o['name']} selesai! Tubuhmu terasa lebih bugar (+${o['health']}% Kesehatan, +${o['happiness']}% Kebahagiaan).';
    }

    character.inbox.add(resultMsg);

    // Tampilkan dialog hasil
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              cedera ? Icons.warning : Icons.check_circle,
              color: cedera ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            Text(
              cedera ? 'Cedera!' : 'Olahraga Selesai',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(resultMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog hasil saja
              widget.onComplete(); // panggil callback untuk refresh
              // JANGAN panggil Navigator.pop(context) di sini agar tetap di halaman
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}