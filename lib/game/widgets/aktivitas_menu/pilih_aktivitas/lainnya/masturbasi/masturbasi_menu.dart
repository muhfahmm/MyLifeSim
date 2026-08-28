// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/masturbasi_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'risiko_masturbasi.dart'; // Import file risiko

class MasturbasiHelper {
  // ============================================================
  // KONSTANTA & FUNGSI KECANDUAN
  // ============================================================
  static const int maxAddiction = 100;

  static Color getAddictionColor(int level) {
    if (level < 34) return Colors.green;
    if (level < 67) return Colors.orange;
    return Colors.red;
  }

  static String getAddictionLabel(int level) {
    if (level < 34) return 'Rendah';
    if (level < 67) return 'Sedang';
    return 'Tinggi';
  }

  static int _increaseAddiction(Character character) {
    character.addictionLevel = (character.addictionLevel + 5).clamp(0, maxAddiction);
    return character.addictionLevel;
  }

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
  // FUNGSI PUBLIK: BUKA MENU MASTURBASI (HALAMAN)
  // ============================================================
  static void showMasturbationMenu(BuildContext context, Character character, VoidCallback onComplete) {
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
  // EKSEKUSI MASTURBASI (dengan parameter lokasi & sub-lokasi)
  // ============================================================
  static void executeMasturbation(
    BuildContext context,
    Character character,
    String targetName,
    String relation, {
    required String location, // 'Di Rumah', 'Di Mobil', 'Di Kantor', 'Di Toilet Umum'
    required String subLocation, // Nama ruangan spesifik (misal: 'Kamar Tidur Utama')
    VoidCallback? onComplete,
  }) {
    final Random random = Random();
    character.lastMasturbationAge = character.age;

    // ---- Probabilitas ketahuan berdasarkan lokasi utama (dari RisikoMasturbasi) ----
    int catchChance = RisikoMasturbasi.getCatchChance(location);
    final bool ketahuan = random.nextInt(100) < catchChance;

    if (ketahuan) {
      // Ambil efek spesifik dari risiko
      Map<String, dynamic> riskEffects = RisikoMasturbasi.getRiskEffects(location, character, targetName, relation);
      String msg = riskEffects['message'];

      // Terapkan efek
      character.happiness = (character.happiness + (riskEffects['happinessDelta'] as int)).clamp(0, 100);
      character.health = (character.health + (riskEffects['healthDelta'] as int)).clamp(0, 100);
      character.intelligence = (character.intelligence + (riskEffects['intelligenceDelta'] as int)).clamp(0, 100);

      // Jika ada efek hubungan (misal di kantor), bisa diterapkan ke partner/sibling
      if (riskEffects['relationshipDelta'] != 0 && character.partner != null) {
        int currentRel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (currentRel + (riskEffects['relationshipDelta'] as int)).clamp(0, 100).toString();
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
                onComplete?.call();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // ---- Tambahkan kecanduan ----
    int newAddiction = _increaseAddiction(character);

    // ---- Efek statistik utama ----
    String resultMsg = '';
    int happinessGain = 15;
    int healthGain = 5;
    int intelligenceLoss = 5;

    // Modifikasi efek berdasarkan lokasi utama
    if (location == 'Di Mobil') {
      happinessGain += 5;
      healthGain -= 2;
    } else if (location == 'Di Kantor') {
      happinessGain += 10; // lebih menantang
      healthGain -= 3;     // lebih tegang
    } else if (location == 'Di Toilet Umum') {
      happinessGain += 5;
      intelligenceLoss -= 2; // lebih cepat selesai, tidak terlalu ganggu fokus
    }

    // Modifikasi efek berdasarkan relasi
    if (relation == 'Pasangan') {
      happinessGain += 5;
      if (character.partner != null) {
        int currentRel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (currentRel + 5).clamp(0, 100).toString();
      }
    } else if (_isFamily(targetName, relation)) {
      // Fantasi terlarang: efek negatif tambahan
      healthGain -= 10;
      if (random.nextInt(100) < 20) {
        happinessGain -= 25;
        resultMsg = '⚠️ Fantasi Terlarang: Kamu bermasturbasi membayangkan $targetName di $subLocation ($location). Penyesalan batin membuat kesehatanmu turun dan memicu rasa bersalah yang mendalam.';
      } else {
        resultMsg = '⚠️ Fantasi Terlarang: Kamu bermasturbasi membayangkan $targetName di $subLocation ($location). Kamu merasa sangat bersalah tetapi puas.';
      }
    } else {
      resultMsg = '✨ Fantasi Bebas: Kamu bermasturbasi membayangkan $targetName di $subLocation ($location). Pikiranmu terasa segar.';
    }

    // Terapkan statistik
    character.happiness = (character.happiness + happinessGain).clamp(0, 100);
    character.health = (character.health + healthGain).clamp(0, 100);
    character.intelligence = (character.intelligence - intelligenceLoss).clamp(0, 100);

    // Buat pesan hasil
    String addictionNote = '';
    if (newAddiction >= 67) {
      addictionNote = '\n\n🚨 Kecanduanmu sudah TINGGI! Segera kurangi frekuensinya.';
    } else if (newAddiction >= 34) {
      addictionNote = '\n\n⚠️ Level kecanduanmu sedang. Waspadalah.';
    }

    if (resultMsg.isEmpty) {
      resultMsg = '💦 Selesai: Kamu menyelesaikan aktivitas ini di $subLocation ($location). Stres berkurang (+$happinessGain% Kebahagiaan, +$healthGain% Kesehatan, -$intelligenceLoss% Kecerdasan)$addictionNote';
    } else {
      resultMsg += '\n\n(+$happinessGain% Kebahagiaan, +$healthGain% Kesehatan, -$intelligenceLoss% Kecerdasan)$addictionNote';
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
              onComplete?.call();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEMBANGUN OPSI FANTASI
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
//  HALAMAN MENU MASTURBASI
// ============================================================
class MasturbasiMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const MasturbasiMenuPage({Key? key, required this.character, required this.onComplete}) : super(key: key);

  @override
  State<MasturbasiMenuPage> createState() => _MasturbasiMenuPageState();
}

class _MasturbasiMenuPageState extends State<MasturbasiMenuPage> {
  @override
  Widget build(BuildContext context) {
    final options = MasturbasiHelper._buildOptions(widget.character);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Bar Kecanduan ----
            _buildAddictionBar(),
            const SizedBox(height: 16),
            // ---- Daftar Fantasi ----
            Expanded(
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
                        // Tampilkan dialog pilihan tempat (tanpa metode)
                        _showLocationDialog(context, opt['name']!, opt['relation']!);
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

  // Widget Bar Kecanduan
  Widget _buildAddictionBar() {
    int level = widget.character.addictionLevel ?? 0;
    Color color = MasturbasiHelper.getAddictionColor(level);
    String label = MasturbasiHelper.getAddictionLabel(level);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                'Tingkat Kecanduan: $label',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text('$level%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: level / 100,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DIALOG PILIH TEMPAT UTAMA
  // ============================================================
  void _showLocationDialog(BuildContext context, String targetName, String relation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Tempat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Tile "Di Rumah" -> Buka modal ruangan rumah
                _buildLocationTile(
                  icon: Icons.home,
                  label: 'Di Rumah',
                  subtitle: 'Pilih kamar atau ruangan',
                  onTap: () {
                    Navigator.pop(ctx); // Tutup modal lokasi utama
                    _showRoomDialog(context, 'Di Rumah', targetName, relation);
                  },
                ),

                // Tile "Di Mobil" -> Langsung eksekusi (tanpa sub-ruangan)
                _buildLocationTile(
                  icon: Icons.directions_car,
                  label: 'Di Mobil',
                  subtitle: 'Langsung di kursi mobil',
                  onTap: () {
                    Navigator.pop(ctx);
                    MasturbasiHelper.executeMasturbation(
                      context,
                      widget.character,
                      targetName,
                      relation,
                      location: 'Di Mobil',
                      subLocation: 'Kursi Mobil',
                      onComplete: () {
                        Navigator.pop(context); // tutup halaman
                        widget.onComplete();
                      },
                    );
                  },
                ),

                // Tile "Di Kantor" -> Buka modal ruangan kantor
                _buildLocationTile(
                  icon: Icons.business,
                  label: 'Di Kantor',
                  subtitle: 'Pilih ruangan kantor',
                  onTap: () {
                    Navigator.pop(ctx); // Tutup modal lokasi utama
                    _showRoomDialog(context, 'Di Kantor', targetName, relation);
                  },
                ),

                // Tile "Di Toilet Umum" -> Langsung eksekusi
                _buildLocationTile(
                  icon: Icons.wc,
                  label: 'Di Toilet Umum',
                  subtitle: 'Langsung di bilik toilet',
                  onTap: () {
                    Navigator.pop(ctx);
                    MasturbasiHelper.executeMasturbation(
                      context,
                      widget.character,
                      targetName,
                      relation,
                      location: 'Di Toilet Umum',
                      subLocation: 'Bilik Toilet',
                      onComplete: () {
                        Navigator.pop(context);
                        widget.onComplete();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DIALOG PILIH RUANGAN SPESIFIK (Rumah & Kantor)
  // ============================================================
  void _showRoomDialog(BuildContext context, String location, String targetName, String relation) {
    // Dapatkan daftar ruangan dari RisikoMasturbasi
    List<String> rooms = RisikoMasturbasi.getRoomsForLocation(location);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Ruangan di $location',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: (ctx, index) {
                    final room = rooms[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(Icons.room, color: Colors.pinkAccent),
                        title: Text(room, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(ctx); // Tutup modal ruangan
                          // Eksekusi langsung
                          MasturbasiHelper.executeMasturbation(
                            context,
                            widget.character,
                            targetName,
                            relation,
                            location: location,
                            subLocation: room,
                            onComplete: () {
                              Navigator.pop(context); // tutup halaman utama
                              widget.onComplete();
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.pinkAccent),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}