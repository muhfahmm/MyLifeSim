// lib/game/widgets/hubungan_menu/action_menu/action_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// Import logic per usia
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_base.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_3_6.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart';

class ActionMenuScreen extends StatefulWidget {
  final Character character;
  final String targetName;
  final String targetRole;

  const ActionMenuScreen({
    super.key,
    required this.character,
    required this.targetName,
    required this.targetRole,
  });

  @override
  State<ActionMenuScreen> createState() => _ActionMenuScreenState();
}

class _ActionMenuScreenState extends State<ActionMenuScreen> {
  final Random _random = Random();

  // Helper untuk mengambil nilai umur target saat ini
  String _getCurrentAgeValue() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Pacar' || role == 'Tunangan' || role == 'Suami' || role == 'Istri') {
      return widget.character.partner != null ? '${widget.character.partner!['age']} tahun' : 'Tidak diketahui';
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) {
        return widget.character.fatherInLawAge != null ? '${widget.character.fatherInLawAge} tahun' : 'Tidak diketahui';
      } else {
        return widget.character.motherInLawAge != null ? '${widget.character.motherInLawAge} tahun' : 'Tidak diketahui';
      }
    }

    if (role == 'Kandung' && name.startsWith('Ayah')) {
      return widget.character.fatherAge != null ? '${widget.character.fatherAge} tahun' : 'Tidak diketahui';
    } else if (role == 'Kandung' && name.startsWith('Ibu')) {
      return widget.character.motherAge != null ? '${widget.character.motherAge} tahun' : 'Tidak diketahui';
    } else if (role == 'Tiri' && name.startsWith('Ayah')) {
      return widget.character.stepFatherAge != null ? '${widget.character.stepFatherAge} tahun' : 'Tidak diketahui';
    } else if (role == 'Tiri' && name.startsWith('Ibu')) {
      return widget.character.stepMotherAge != null ? '${widget.character.stepMotherAge} tahun' : 'Tidak diketahui';
    } else if (role == 'Laki-laki' || role == 'Perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        // Bersihkan nama dari '(Wafat)' jika ada
        final String cleanName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanName) {
          int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
          return '$childAge tahun';
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == name) {
          int extAge = int.tryParse(ext['age'] ?? '0') ?? 0;
          return extAge < 0 ? 'Belum Lahir (Dalam Kandungan)' : '$extAge tahun';
        }
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
          return sibAge < 0 ? 'Belum Lahir (Dalam Kandungan)' : '$sibAge tahun';
        }
      }
    }
    return 'Tidak diketahui';
  }

  // Helper untuk mengambil nilai hubungan target saat ini
  int _getCurrentRelationshipValue() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Pacar' || role == 'Tunangan' || role == 'Suami' || role == 'Istri' || role.contains('Pacar')) {
      // PERBAIKAN: Tambahkan widget. di depan character
      if (widget.character.partner != null && widget.character.partner!['name'] == name) {
        return int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
      }
      if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == name) {
        return int.tryParse(widget.character.secondPartner!['relationship'] ?? '50') ?? 50;
      }
      return int.tryParse(widget.character.partner?['relationship'] ?? '50') ?? 50;
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) {
        return widget.character.fatherInLawRelationship ?? 50;
      } else {
        return widget.character.motherInLawRelationship ?? 50;
      }
    }

    if (role == 'Kandung' && name.startsWith('Ayah')) {
      return widget.character.fatherRelationship ?? 50;
    } else if (role == 'Kandung' && name.startsWith('Ibu')) {
      return widget.character.motherRelationship ?? 50;
    } else if (role == 'Tiri' && name.startsWith('Ayah')) {
      return widget.character.stepFatherRelationship ?? 50;
    } else if (role == 'Tiri' && name.startsWith('Ibu')) {
      return widget.character.stepMotherRelationship ?? 50;
    } else if (role == 'Laki-laki' || role == 'Perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        final String cleanName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanName) {
          return int.tryParse(child['relationship'] ?? '50') ?? 50;
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == name) {
          return int.tryParse(ext['relationship'] ?? '50') ?? 50;
        }
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          return int.tryParse(sib['relationship'] ?? '50') ?? 50;
        }
      }
    }
    return 50;
  }

  // Helper untuk mengupdate nilai hubungan target saat ini
  void _updateRelationship(int changeAmount) {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Pacar' || role == 'Tunangan' || role == 'Suami' || role == 'Istri' || role.contains('Pacar')) {
      // PERBAIKAN: Tambahkan widget. di depan character
      if (widget.character.partner != null && widget.character.partner!['name'] == name) {
        int currentRel = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
        widget.character.partner!['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
      } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == name) {
        int currentRel = int.tryParse(widget.character.secondPartner!['relationship'] ?? '50') ?? 50;
        widget.character.secondPartner!['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
      }
      return;
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) {
        widget.character.fatherInLawRelationship = ((widget.character.fatherInLawRelationship ?? 50) + changeAmount).clamp(0, 100);
      } else {
        widget.character.motherInLawRelationship = ((widget.character.motherInLawRelationship ?? 50) + changeAmount).clamp(0, 100);
      }
      return;
    }

    if (role == 'Kandung' && name.startsWith('Ayah')) {
      widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else if (role == 'Kandung' && name.startsWith('Ibu')) {
      widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else if (role == 'Tiri' && name.startsWith('Ayah')) {
      widget.character.stepFatherRelationship = ((widget.character.stepFatherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else if (role == 'Tiri' && name.startsWith('Ibu')) {
      widget.character.stepMotherRelationship = ((widget.character.stepMotherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else if (role == 'Laki-laki' || role == 'Perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        final String cleanName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanName) {
          int currentRel = int.tryParse(child['relationship'] ?? '50') ?? 50;
          child['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == name) {
          int currentRel = int.tryParse(ext['relationship'] ?? '50') ?? 50;
          ext['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
          return;
        }
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          int currentRel = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          sib['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    }
  }

  void _showResultDialog(String title, String message, IconData icon, Color color, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Fungsi update state yang dikirim ke file usia
  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int age = widget.character.age;
    // Tentukan umur target. Jika target memiliki umur spesifik (misal anak), gunakan itu.
    // Jika tidak diketahui atau belum lahir, fallback ke 0.
    final String ageString = _getCurrentAgeValue();
    int targetAge = 0;
    if (ageString.contains('tahun')) {
      targetAge = int.tryParse(ageString.replaceAll(' tahun', '').trim()) ?? 0;
    }

    // --- LOGIKA PEMANGGILAN BERDASARKAN USIA TARGET ---
    List<ActionItem> actions = [];

    // Gunakan usia terkecil antara usia player dengan usia target untuk menentukan kategori interaksi.
    // Hal ini agar anak kecil (misal 5 tahun) tidak bisa mengajak pacaran atau bercinta dengan orang dewasa (misal kakaknya yang berumur 19 tahun).
    final int minAge = age < targetAge ? age : targetAge;
    final bool isChild = widget.targetRole == 'Laki-laki' || widget.targetRole == 'Perempuan';

    if (isChild && targetAge < 12) {
      // Jika target anak kita di bawah 12 tahun, tampilkan menu khusus orang tua mengasuh anak:
      // - Beri Uang Jajan (Minta uang dari sisi anak, di sini orang tua yang memberi uang)
      // - Beri Hadiah
      // - Ajak Bicara / Mengobrol
      // - Beri Pelukan
      // - Ajak Jalan-jalan / Bermain
      // - Disiplinkan (jika nakal)
      actions = [
        ActionItem(
          label: 'Beri Pelukan',
          icon: Icons.face,
          color: Colors.pinkAccent,
          onTap: () {
            int relBonus = _random.nextInt(6) + 10;
            _showResultDialog(
              'Pelukan Hangat',
              'Kamu memeluk erat ${widget.targetName}. Anakmu merasa sangat disayangi! (+$relBonus% hubungan)',
              Icons.face,
              Colors.pinkAccent,
              () {
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
        ActionItem(
          label: 'Bercakap-cakap',
          icon: Icons.chat,
          color: Colors.teal,
          onTap: () {
            int relBonus = _random.nextInt(5) + 5;
            _showResultDialog(
              'Mengobrol dengan Anak',
              'Kamu menghabiskan waktu mengobrol dan mendengarkan cerita ${widget.targetName}. (+$relBonus% hubungan)',
              Icons.chat,
              Colors.teal,
              () {
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
        ActionItem(
          label: 'Beri Uang Jajan',
          icon: Icons.monetization_on,
          color: Colors.green,
          onTap: () {
            if (widget.character.money < 10) {
              _showResultDialog(
                'Uang Tidak Cukup',
                'Kamu tidak memiliki cukup uang untuk memberikan uang jajan (\$10).',
                Icons.money_off,
                Colors.red,
                () {},
              );
            } else {
              int relBonus = _random.nextInt(6) + 10;
              _showResultDialog(
                'Beri Uang Jajan',
                'Kamu memberikan uang jajan sebesar \$10 kepada ${widget.targetName}. Dia sangat gembira! (+$relBonus% hubungan)',
                Icons.monetization_on,
                Colors.green,
                () {
                  widget.character.money -= 10;
                  _updateRelationship(relBonus);
                  _updateState();
                },
              );
            }
          },
        ),
        ActionItem(
          label: 'Beri Hadiah Mainan',
          icon: Icons.toys,
          color: Colors.orange,
          onTap: () {
            if (widget.character.money < 30) {
              _showResultDialog(
                'Uang Tidak Cukup',
                'Kamu tidak memiliki cukup uang untuk membelikan mainan (\$30).',
                Icons.money_off,
                Colors.red,
                () {},
              );
            } else {
              int relBonus = _random.nextInt(11) + 15;
              _showResultDialog(
                'Hadiah Mainan',
                'Kamu membelikan mainan baru seharga \$30 untuk ${widget.targetName}. Anakmu langsung melompat kegirangan! (+$relBonus% hubungan)',
                Icons.toys,
                Colors.orange,
                () {
                  widget.character.money -= 30;
                  _updateRelationship(relBonus);
                  _updateState();
                },
              );
            }
          },
        ),
        ActionItem(
          label: 'Ajak Bermain ke Taman',
          icon: Icons.park,
          color: Colors.deepOrange,
          onTap: () {
            int relBonus = _random.nextInt(6) + 12;
            _showResultDialog(
              'Bermain di Taman',
              'Kamu mengajak ${widget.targetName} bermain ayunan dan berlarian di taman. Waktu yang sangat menyenangkan! (+$relBonus% hubungan)',
              Icons.park,
              Colors.green,
              () {
                widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
        ActionItem(
          label: 'Puji Anak',
          icon: Icons.thumb_up,
          color: Colors.blue,
          onTap: () {
            int relBonus = _random.nextInt(5) + 8;
            _showResultDialog(
              'Pujian Orang Tua',
              'Kamu memuji kepintaran dan tingkah laku baik ${widget.targetName}. (+$relBonus% hubungan)',
              Icons.thumb_up,
              Colors.blue,
              () {
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
      ];
    } else {
      // Gunakan logika standar berdasarkan usia terkecil (minAge)
      if (minAge < 3) {
        // Belum ada menu, menampilkan pesan "Terlalu muda"
      } else if (minAge >= 3 && minAge <= 6) {
        actions = getAge3to6Actions(
          widget.character,
          widget.targetName,
          widget.targetRole,
          _random,
          _showResultDialog,
          _updateRelationship,
          _updateState,
        );
      } else if (minAge >= 6 && minAge < 12) {
        actions = getAge6to11Actions(
          widget.character,
          widget.targetName,
          widget.targetRole,
          _random,
          _showResultDialog,
          _updateRelationship,
          _updateState,
        );
      } else {
        actions = getAge12PlusActions(
          context,
          widget.character,
          widget.targetName,
          widget.targetRole,
          minAge,
          _random,
          _showResultDialog,
          _updateRelationship,
          _updateState,
        );
      }
    }

    final int relationshipVal = _getCurrentRelationshipValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Card Info
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          radius: 28,
                          child: const Icon(Icons.person, color: Colors.blue, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.targetName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                'Hubungan: ${widget.targetRole} | Umur: ${_getCurrentAgeValue()}',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tingkat Kepuasan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationshipVal / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationshipVal > 65 ? Colors.green : relationshipVal > 35 ? Colors.amber : Colors.red,
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$relationshipVal%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: relationshipVal > 65 ? Colors.green : relationshipVal > 35 ? Colors.amber : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
            ),
            const SizedBox(height: 12),

            // --- MENU ACTION LIST (HASIL DARI AGE FILE) ---
            Expanded(
              child: actions.isEmpty
                  ? Center(
                      child: Text(
                        'Kamu masih berusia $age tahun. Kamu terlalu muda untuk berinteraksi secara aktif.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: actions.length,
                      itemBuilder: (context, index) {
                        final action = actions[index];
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade100),
                          ),
                          child: ListTile(
                            leading: Icon(action.icon, color: action.color),
                            title: Text(action.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            onTap: action.onTap,
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