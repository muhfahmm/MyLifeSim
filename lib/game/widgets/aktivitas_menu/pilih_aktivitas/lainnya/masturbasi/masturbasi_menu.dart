// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/masturbasi_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'risiko_masturbasi.dart'; // Import file risiko
import 'persentase_ajakan.dart'; // Import persentase ajakan
import 'ajakan_masturbasi_dialog.dart'; // Import ajakan masturbasi dialog
import 'efek_samping.dart'; // Import efek samping masturbasi



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
  // EKSEKUSI MASTURBASI (dengan parameter lokasi, sub-lokasi & waktu)
  // ============================================================
  static void executeMasturbation(
    BuildContext context,
    Character character,
    String targetName,
    String relation, {
    required String location, // 'Di Rumah', 'Di Mobil', 'Di Kantor', 'Di Toilet Umum'
    required String subLocation, // Nama ruangan spesifik (misal: 'Kamar Tidur Utama')
    required String timeOfDay, // 'Pagi', 'Siang', 'Sore', 'Malam'
    VoidCallback? onComplete,
  }) {
    final Random random = Random();
    character.lastMasturbationAge = character.age;

    // ---- Probabilitas ketahuan berdasarkan lokasi, sub-lokasi, waktu & target secara dinamis ----
    int catchChance = RisikoMasturbasi.getDynamicCatchChance(location, subLocation, timeOfDay, targetName, relation);
    final bool ketahuan = random.nextInt(100) < catchChance;

    if (ketahuan) {
      // Ambil efek spesifik dari risiko
      Map<String, dynamic> riskEffects = RisikoMasturbasi.getRiskEffects(location, character, targetName, relation);
      String msg = riskEffects['message'];

      // Tambahkan info waktu ketahuan
      msg = msg.replaceFirst('😱 KETAHUAN!', '😱 KETAHUAN pada waktu $timeOfDay!');
      msg = msg.replaceFirst('😱 TRAGEDI MEMALUKAN!', '😱 TRAGEDI MEMALUKAN pada waktu $timeOfDay!');
      msg = msg.replaceFirst('🚗 KETAHUAN!', '🚗 KETAHUAN pada waktu $timeOfDay!');
      msg = msg.replaceFirst('🏢 KETAHUAN!', '🏢 KETAHUAN pada waktu $timeOfDay!');
      msg = msg.replaceFirst('🚽 KETAHUAN!', '🚽 KETAHUAN pada waktu $timeOfDay!');

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

      _MasturbasiMenuPageState._showCaughtInteractiveDialog(context, character, riskEffects, timeOfDay, onComplete);
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
        resultMsg = '⚠️ Fantasi Terlarang: Kamu bermasturbasi membayangkan $targetName pada $timeOfDay hari di $subLocation ($location). Penyesalan batin membuat kesehatanmu turun dan memicu rasa bersalah yang mendalam.';
      } else {
        resultMsg = '⚠️ Fantasi Terlarang: Kamu bermasturbasi membayangkan $targetName pada $timeOfDay hari di $subLocation ($location). Kamu merasa sangat bersalah tetapi puas.';
      }
    } else {
      resultMsg = '✨ Fantasi Bebas: Kamu bermasturbasi membayangkan $targetName pada $timeOfDay hari di $subLocation ($location). Pikiranmu terasa segar.';
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
      resultMsg = '💦 Selesai: Kamu menyelesaikan aktivitas ini pada $timeOfDay hari di $subLocation ($location). Stres berkurang (+$happinessGain% Kebahagiaan, +$healthGain% Kesehatan, -$intelligenceLoss% Kecerdasan)$addictionNote';
    } else {
      resultMsg += '\n\n(+$happinessGain% Kebahagiaan, +$healthGain% Kesehatan, -$intelligenceLoss% Kecerdasan)$addictionNote';
    }

    character.inbox.add(resultMsg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
              Navigator.pop(ctx);
              EfekSampingMasturbasi.checkSoloEffect(context, character, relation, onComplete);
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

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.onComplete();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Fantasi Masturbasi'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onComplete();
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    ),
  );
}

  // Widget Bar Kecanduan
  Widget _buildAddictionBar() {
    int level = widget.character.addictionLevel;
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
        final bool works = widget.character.jobName != null && widget.character.jobName!.isNotEmpty;

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

                // Tile "Di Mobil" -> Buka modal pilih waktu
                _buildLocationTile(
                  icon: Icons.directions_car,
                  label: 'Di Mobil',
                  subtitle: 'Langsung di kursi mobil',
                  onTap: () {
                    Navigator.pop(ctx);
                    _showTimeDialog(context, 'Di Mobil', 'Kursi Mobil', targetName, relation);
                  },
                ),

                // Tile "Di Kantor" -> Buka modal ruangan kantor (jika bekerja)
                if (works)
                  _buildLocationTile(
                    icon: Icons.business,
                    label: 'Di Kantor',
                    subtitle: 'Pilih ruangan kantor',
                    onTap: () {
                      Navigator.pop(ctx); // Tutup modal lokasi utama
                      _showRoomDialog(context, 'Di Kantor', targetName, relation);
                    },
                  ),

                // Tile "Di Toilet Umum" -> Buka modal pilih waktu
                _buildLocationTile(
                  icon: Icons.wc,
                  label: 'Di Toilet Umum',
                  subtitle: 'Langsung di bilik toilet',
                  onTap: () {
                    Navigator.pop(ctx);
                    _showTimeDialog(context, 'Di Toilet Umum', 'Bilik Toilet', targetName, relation);
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
    List<String> rooms = RisikoMasturbasi.getRoomsForLocation(location, widget.character);

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
                        leading: const Icon(Icons.room, color: Colors.pinkAccent),
                        title: Text(room, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(ctx); // Tutup modal ruangan
                          if (room == 'Kamar Tidur') {
                            _showBedroomDialog(context, targetName, relation);
                          } else {
                            _showTimeDialog(context, location, room, targetName, relation);
                          }
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

  // ============================================================
  // DIALOG PILIH KAMAR TIDUR SPESIFIK (Keluarga)
  // ============================================================
  void _showBedroomDialog(BuildContext context, String targetName, String relation) {
    final List<String> bedrooms = [];

    // 1. Kamar Orang Tua (Ayah & Ibu)
    final List<String> parentNames = [];
    if (widget.character.fatherName != null && !widget.character.isFatherDeceased) parentNames.add(widget.character.fatherName!);
    if (widget.character.motherName != null && !widget.character.isMotherDeceased) parentNames.add(widget.character.motherName!);
    if (widget.character.stepFatherName != null && !widget.character.isStepFatherDeceased) parentNames.add(widget.character.stepFatherName!);
    if (widget.character.stepMotherName != null && !widget.character.isStepMotherDeceased) parentNames.add(widget.character.stepMotherName!);
    
    String parentLabel = 'Kamar Orang Tua';
    if (parentNames.isNotEmpty) {
      parentLabel += ' (${parentNames.join(" & ")})';
    }
    if (parentNames.isNotEmpty || widget.character.fatherName != null || widget.character.motherName != null) {
      bedrooms.add(parentLabel);
    }

    // 2. Kamarmu Sendiri
    bedrooms.add('Kamarmu Sendiri');

    // 3. Kamar Kakak & Adik
    for (var sib in widget.character.siblings) {
      if (sib['isDeceased'] != 'true') {
        final rel = sib['relation'] ?? 'Saudara';
        final name = sib['name'] ?? '';
        bedrooms.add('Kamar $rel ($name)');
      }
    }

    // 4. Kamar Anak
    for (var child in widget.character.children) {
      if (child['isDeceased'] != 'true') {
        final rel = child['gender'] == 'Laki-laki' ? 'Anak Laki-laki' : 'Anak Perempuan';
        final name = child['name'] ?? '';
        bedrooms.add('Kamar $rel ($name)');
      }
    }

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
                  'Pilih Kamar Tidur Siapa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: bedrooms.length,
                    itemBuilder: (ctx, index) {
                      final room = bedrooms[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.bed, color: Colors.pinkAccent),
                          title: Text(room, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(ctx); // Tutup modal kamar tidur
                            _showTimeDialog(context, 'Di Rumah', room, targetName, relation);
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
      },
    );
  }

  // ============================================================
  // DIALOG PILIH WAKTU
  // ============================================================
  void _showTimeDialog(BuildContext context, String location, String subLocation, String targetName, String relation) {
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
                  'Pilih Waktu Aktivitas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildLocationTile(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Pagi',
                  subtitle: 'Aktivitas normal (Modifikator Risiko: +0%)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _runExecution(context, location, subLocation, 'Pagi', targetName, relation);
                  },
                ),

                _buildLocationTile(
                  icon: Icons.wb_sunny,
                  label: 'Siang',
                  subtitle: 'Ramai & rawan (Modifikator Risiko: +15%)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _runExecution(context, location, subLocation, 'Siang', targetName, relation);
                  },
                ),

                _buildLocationTile(
                  icon: Icons.wb_twilight,
                  label: 'Sore',
                  subtitle: 'Sore hari tenang (Modifikator Risiko: +5%)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _runExecution(context, location, subLocation, 'Sore', targetName, relation);
                  },
                ),

                _buildLocationTile(
                  icon: Icons.nights_stay,
                  label: 'Malam',
                  subtitle: 'Sepi & aman (Modifikator Risiko: -8%)',
                  onTap: () {
                    Navigator.pop(ctx);
                    _runExecution(context, location, subLocation, 'Malam', targetName, relation);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _runExecution(BuildContext context, String location, String subLocation, String time, String targetName, String relation) {
    MasturbasiHelper.executeMasturbation(
      context,
      widget.character,
      targetName,
      relation,
      location: location,
      subLocation: subLocation,
      timeOfDay: time,
      onComplete: () {
        if (mounted) {
          setState(() {});
        }
        widget.onComplete();
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

  // ============================================================
  // DIALOG INTERAKTIF SAAT KETAHUAN (3 Pilihan)
  // ============================================================
  static void _showCaughtInteractiveDialog(
    BuildContext context,
    Character character,
    Map<String, dynamic> riskEffects,
    String timeOfDay,
    VoidCallback? onComplete,
  ) {
    final Random random = Random();
    final String relationType = riskEffects['viewerRelation'] ?? 'Lainnya';
    final String viewerName = riskEffects['viewerName'] ?? '';
    final String msg = riskEffects['message'];
    final String relLower = relationType.toLowerCase();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Momen Memalukan!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg),
            const SizedBox(height: 16),
            const Text(
              'Apa yang akan kamu lakukan?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Opsi 1: Minta Maaf
                    character.happiness = (character.happiness - 30).clamp(0, 100);
                    _modifyRelativeRelationship(character, relationType, viewerName, -10);
                    
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Minta Maaf 🙏'),
                        content: Text('Kamu segera menutupi dirimu dan meminta maaf dengan panik. $relationType kecewa (-30% Kebahagiaan, -10% Hubungan).'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onComplete?.call();
                            },
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text('🙏 Minta Maaf'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Opsi 2: Kabur
                    final bool success = random.nextBool();
                    if (success) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Kabur Berhasil 🏃'),
                          content: const Text('Kamu dengan gesit merapikan pakaianmu, melompat keluar, dan bersembunyi! Kamu berhasil menghindari kecanggungan tanpa terluka.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onComplete?.call();
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    } else {
                      character.health = (character.health - 20).clamp(0, 100);
                      character.happiness = (character.happiness - 30).clamp(0, 100);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Kabur Gagal 🤕'),
                          content: const Text('Kamu panik, terpeleset saat mencoba kabur, dan membentur lantai dengan keras! (-20% Kesehatan, -30% Kebahagiaan).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onComplete?.call();
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('🏃 Kabur / Bersembunyi'),
                ),
                if (character.age >= 12) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(ctx);
                      // Opsi 3: Ajak (Rayu)
                      int successChance = PersentaseAjakan.getSuccessChance(
                        character: character,
                        relationType: relationType,
                        viewerName: viewerName,
                      );

                      final bool success = random.nextInt(100) < successChance;

                      final bool isParent = relLower == 'ayah' || relLower == 'ibu' || relLower == 'ayah tiri' || relLower == 'ibu tiri';

                      if (success) {
                        AjakanMasturbasiDialog.show(
                          context: context,
                          character: character,
                          relationType: relationType,
                          viewerName: viewerName,
                          onComplete: onComplete,
                        );
                      } else {
                        // Gagal
                        if (isParent) {
                          character.happiness = (character.happiness - 50).clamp(0, 100);
                          character.money = (character.money * 0.5).round();
                          _modifyRelativeRelationship(character, relationType, viewerName, -100);
                          character.inbox.add('🚨 DIUSIR & DIPENJARA: Kamu diusir dari rumah dan polisi memenjarakanmu selama 3 tahun atas tindakan asusila!');
                          
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Rayuan Ditolak (Tragedi) 🚨'),
                              content: Text('$relationType marah besar dan merasa sangat jijik! Kamu langsung diusir dari rumah, dan polisi dipanggil untuk menangkapmu. Kamu dipenjara selama 3 tahun (-50% Kebahagiaan, uangmu terpotong 50%, -100% Hubungan).'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onComplete?.call();
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            ),
                          );
                        } else {
                          // Saudara lapor orang tua
                          _modifyRelativeRelationship(character, relationType, viewerName, -100);
                          _modifyParentsRelationship(character, -50);
                          character.happiness = (character.happiness - 50).clamp(0, 100);
                          character.inbox.add('🚨 Dilaporkan ke Orang Tua: Tindakan asusilamu dilaporkan oleh $viewerName. Orang tuamu sangat marah!');
                          
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Rayuan Gagal (Dilaporkan) 🚨'),
                              content: const Text('Saudaramu berteriak histeris dan langsung melaporkan kelakuanmu ke orang tua! Orang tuamu menghukummu dengan sangat keras (-50% Kebahagiaan, -100% Hubungan saudara, -50% Hubungan orang tua).'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onComplete?.call();
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('😈 Ajak (Rayu)'),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }

  static void _modifyRelativeRelationship(Character character, String relationType, String name, int delta) {
    final String relLower = relationType.toLowerCase();
    if (relLower == 'ayah' || relLower == 'ayah kandung') {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) + delta).clamp(0, 100);
    } else if (relLower == 'ibu' || relLower == 'ibu kandung') {
      character.motherRelationship = ((character.motherRelationship ?? 50) + delta).clamp(0, 100);
    } else if (relLower == 'ayah tiri') {
      character.stepFatherRelationship = ((character.stepFatherRelationship ?? 50) + delta).clamp(0, 100);
    } else if (relLower == 'ibu tiri') {
      character.stepMotherRelationship = ((character.stepMotherRelationship ?? 50) + delta).clamp(0, 100);
    }
    
    for (var sib in character.siblings) {
      if (sib['name'] == name) {
        int cur = int.tryParse(sib['relationship'] ?? '50') ?? 50;
        sib['relationship'] = (cur + delta).clamp(0, 100).toString();
        break;
      }
    }
    for (var child in character.children) {
      if (child['name'] == name) {
        int cur = int.tryParse(child['relationship'] ?? '50') ?? 50;
        child['relationship'] = (cur + delta).clamp(0, 100).toString();
        break;
      }
    }
  }

  static void _modifyParentsRelationship(Character character, int delta) {
    if (character.fatherName != null) {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) + delta).clamp(0, 100);
    }
    if (character.motherName != null) {
      character.motherRelationship = ((character.motherRelationship ?? 50) + delta).clamp(0, 100);
    }
  }
}