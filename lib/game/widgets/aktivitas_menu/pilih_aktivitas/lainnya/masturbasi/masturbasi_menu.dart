// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/masturbasi_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class MasturbasiHelper {
  // Mengecek apakah target termasuk keluarga dekat (incest)
  static bool _isFamily(String name, String relation) {
    final String r = relation.toLowerCase();
    final String n = name.toLowerCase();
    return r == 'kandung' ||
        r == 'tiri' ||
        r.contains('saudara') ||
        n.contains('kakak') ||
        n.contains('adik') ||
        n.startsWith('ayah') ||
        n.startsWith('ibu');
  }

  // ============================================================
  // Fungsi publik untuk membuka menu masturbasi sebagai HALAMAN (PAGE)
  // ============================================================
  static void showMasturbationMenu(BuildContext context, Character character, VoidCallback onComplete) {
    // Validasi usia
    if (character.age < 9) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Terlalu Muda'),
          content: const Text('Kamu belum memasuki masa pubertas (usia minimal 9 tahun) untuk melakukan aktivitas ini.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // HAPUS LOGIKA PEMBATASAN PER TAHUN
    // if (character.age == character.lastMasturbationAge) { ... } --> dihapus

    // Navigasi ke halaman pilihan fantasi (bukan modal)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MasturbasiMenuPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }

  // ============================================================
  // METODE PUBLIK UNTUK EKSEKUSI (dipanggil dari halaman)
  // ============================================================
  static void executeMasturbation(
      BuildContext context, Character character, String targetName, String relation, VoidCallback onComplete) {
    final Random random = Random();
    character.lastMasturbationAge = character.age; // tetap dicatat untuk keperluan lain

    // Logika risiko Ketahuan (10%)
    final bool ketahuan = random.nextInt(100) < 10;

    if (ketahuan) {
      character.happiness = (character.happiness - 30).clamp(0, 100);
      String viewer = random.nextBool() ? 'Ayah' : 'Ibu';
      if (character.siblings.isNotEmpty) {
        final livingSiblings = character.siblings.where((s) => s['isDeceased'] != 'true').toList();
        if (livingSiblings.isNotEmpty) {
          viewer = livingSiblings[random.nextInt(livingSiblings.length)]['relation'] ?? 'Saudara';
        }
      }

      String msg = '😱 KETAHUAN! Ketika sedang asyik bermasturbasi, pintu tiba-tiba terbuka dan $viewer memergokimu! Kamu merasa sangat malu dan trauma (-30% Kebahagiaan).';
      if (_isFamily(targetName, relation)) {
        msg = '😱 TRAGEDI MEMALUKAN! Saat sedang bermasturbasi membayangkan $targetName, $viewer tiba-tiba masuk memergokimu basah kuyup! Kejadian ini menimbulkan kecanggungan luar biasa (-30% Kebahagiaan).';
      }

      character.inbox.add('😱 Ketahuan Basah: $msg');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Momen Memalukan!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onComplete();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Eksekusi efek statistik sukses
    String resultMsg = '';
    if (relation == 'Biasa') {
      character.happiness = (character.happiness + 15).clamp(0, 100);
      character.health = (character.health + 5).clamp(0, 100);
      character.intelligence = (character.intelligence - 5).clamp(0, 100);
      resultMsg = '💦 Selesai: Kamu menyelesaikan aktivitas ini secara normal. Stres berkurang (+15% Kebahagiaan, +5% Kesehatan, -5% Kecerdasan).';
    } else if (relation == 'Pasangan') {
      character.happiness = (character.happiness + 20).clamp(0, 100);
      character.health = (character.health + 5).clamp(0, 100);
      if (character.partner != null) {
        int currentRel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (currentRel + 5).clamp(0, 100).toString();
      }
      resultMsg = '💖 Bayangan Pasangan: Kamu bermasturbasi sambil membayangkan $targetName. Kamu merasa semakin dekat secara batin dengannya (+20% Kebahagiaan, +5% Hubungan).';
    } else if (_isFamily(targetName, relation)) {
      character.happiness = (character.happiness + 20).clamp(0, 100);
      character.health = (character.health - 10).clamp(0, 100);

      final bool merasaBersalah = random.nextInt(100) < 20;
      if (merasaBersalah) {
        character.happiness = (character.happiness - 25).clamp(0, 100);
        resultMsg = '⚠️ Fantasi Terlarang: Kamu bermasturbasi membayangkan $targetName. Penyesalan batin membuat kesehatanmu turun dan memicu rasa bersalah yang mendalam (-10% Kesehatan, -25% Kebahagiaan jangka panjang).';
      } else {
        resultMsg = '⚠️ Fantasi Terlarang: Kamu bermasturbasi membayangkan $targetName. Kamu merasa sangat bersalah tetapi puas (+20% Kebahagiaan awal, -10% Kesehatan karena stres batin).';
      }
    } else {
      character.happiness = (character.happiness + 15).clamp(0, 100);
      character.health = (character.health + 5).clamp(0, 100);
      resultMsg = '✨ Fantasi Bebas: Kamu bermasturbasi membayangkan $targetName. Pikiranmu terasa segar (+15% Kebahagiaan, +5% Kesehatan).';
    }

    character.inbox.add(resultMsg);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Aktivitas Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(resultMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onComplete();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FUNGSI PEMBANTU MEMBANGUN OPSI (digunakan oleh halaman)
  // ============================================================
  static List<Map<String, String>> _buildOptions(Character character) {
    final List<Map<String, String>> options = [
      {'name': 'Tanpa Bayangan (Biasa)', 'relation': 'Biasa'},
    ];

    if (character.partner != null) {
      options.add({
        'name': character.partner!['name']!,
        'relation': 'Pasangan',
      });
    }

    if (character.fatherName != null && !character.isFatherDeceased) {
      options.add({'name': 'Ayah (${character.fatherName})', 'relation': 'Ayah'});
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      options.add({'name': 'Ibu (${character.motherName})', 'relation': 'Ibu'});
    }
    for (var sib in character.siblings) {
      if (sib['isDeceased'] != 'true') {
        options.add({
          'name': '${sib['name']} (${sib['relation']})',
          'relation': sib['relation'] ?? 'Saudara',
        });
      }
    }

    options.add({'name': 'Teman Dekat / Selebriti', 'relation': 'Teman'});
    return options;
  }
}

// ============================================================
//  WIDGET HALAMAN (PAGE) UNTUK MENU MASTURBASI
// ============================================================
class MasturbasiMenuPage extends StatelessWidget {
  final Character character;
  final VoidCallback onComplete;

  const MasturbasiMenuPage({Key? key, required this.character, required this.onComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = MasturbasiHelper._buildOptions(character);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Fantasi Masturbasi'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final opt = options[index];
            return Card(
              elevation: 2,
              color: Colors.grey.shade50,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.psychology, color: Colors.pinkAccent),
                title: Text(opt['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Bayangkan: ${opt['relation']}', style: const TextStyle(fontSize: 11)),
                onTap: () {
                  // Eksekusi masturbasi, lalu tutup halaman setelah selesai
                  void wrappedComplete() {
                    Navigator.pop(context); // tutup halaman
                    onComplete();           // panggil callback eksternal
                  }
                  MasturbasiHelper.executeMasturbation(
                    context,
                    character,
                    opt['name']!,
                    opt['relation']!,
                    wrappedComplete,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}