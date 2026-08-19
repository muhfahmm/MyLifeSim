// lib/game/index.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/paused_menu/pausedMenu.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

// Import widget-widget UI
import 'package:bitlife/game/widgets/kategori_usia/age_category_button.dart';
import 'package:bitlife/game/widgets/assets_menu/assets_button.dart';
import 'package:bitlife/game/widgets/hubungan_menu/relationship_button/relationship_button.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/activity_button.dart';
import 'package:bitlife/game/widgets/kategori_usia/age_up_button.dart';
import 'package:bitlife/game/widgets/inbox_menu/inbox_button.dart';
import 'package:bitlife/game/widgets/penyakit_logic/std_logic.dart';

class GameScreen extends StatefulWidget {
  final Character character;
  const GameScreen({super.key, required this.character});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Character _character;

  @override
  void initState() {
    super.initState();
    _character = widget.character;
  }

  // --- LOGIKA RESET ---
  void _resetGame() {
    setState(() {
      _character.age = 0;
      _character.health = 100;
      _character.happiness = 50;
      _character.intelligence = 50;
      _character.money = 0;
      _character.isAlive = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔄 Semua status berhasil direset!'), backgroundColor: Colors.green),
    );
  }

  // --- LOGIKA TAMBAH UMUR (DENGAN KELAHIRAN & KEGUGURAN) ---
  void _ageUp() {
    List<String> events = [];
    setState(() {
      events = _character.ageUp();
    });

    // Cek kehamilan saat bertambah umur
    if (_character.isPregnant || _character.partnerIsPregnant) {
      // Hitung roll kelahiran (80% berhasil, 20% keguguran)
      int birthRoll = Random().nextInt(100);
      bool isSuccess = birthRoll < 80;

      if (isSuccess) {
        // Logika melahirkan sukses (panggil fungsi lahir)
        _handleBirth();
      } else {
        // Logika keguguran
        _handleMiscarriage();
      }
    }

    if (!_character.isAlive) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Karakter Meninggal'),
          content: Text('${_character.name} meninggal pada usia ${_character.age} tahun.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Selesai'),
            ),
          ],
        ),
      );
    } else if (events.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text('Kejadian Penting', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: events.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(e, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _checkActiveProposal();
              },
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      _checkActiveProposal();
    }
  }

  // --- LOGIKA MELAHIRKAN (80%) ---
  void _handleBirth() {
    final Random random = Random();
    final String childGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
    
    final List<String> boys = ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi', 'Rehan', 'Fadel', 'Budi', 'Aditya'];
    final List<String> girls = ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra', 'Keysha', 'Aurel', 'Santi', 'Putri'];
    
    final String childFirstName = childGender == 'Laki-laki' 
        ? boys[random.nextInt(boys.length)] 
        : girls[random.nextInt(girls.length)];
    
    final List<String> playerParts = _character.name.split(' ');
    final String childLastName = playerParts.length > 1 ? playerParts.last : '';
    final String childName = childLastName.isNotEmpty ? '$childFirstName $childLastName' : childFirstName;

    // Tentukan ayah/ibu dari data kehamilan
    String father = 'Tidak diketahui';
    String mother = 'Tidak diketahui';
    String partnerName = _character.pregnantByPartnerName ?? 'Pasangan';

    if (_character.gender.toLowerCase() == 'laki-laki') {
      father = _character.name;
      mother = partnerName;
    } else {
      father = partnerName;
      mother = _character.name;
    }

    // Tambahkan anak ke daftar children
    _character.children.add({
      'name': childName,
      'gender': childGender,
      'relationship': '80',
      'age': '0',
      'father': father,
      'mother': mother,
      'isDeceased': 'false',
      'trait': 'Sehat',
    });

    // Reset status hamil
    _character.isPregnant = false;
    _character.partnerIsPregnant = false;
    _character.pregnantByPartnerName = null;
    _character.pregnantByPartnerRole = null;

    // Tampilkan modal keberhasilan lahir
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Selamat! Bayi Lahir 🍼', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Proses persalinan berjalan lancar!\n\n'
          'Selamat, ${_character.name} telah melahirkan seorang ${childGender == 'Laki-laki' ? 'putra' : 'putri'} bernama $childName.\n\n'
          'Hubunganmu dengan $partnerName semakin erat!',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- LOGIKA KEGUGURAN (20%) ---
  void _handleMiscarriage() {
    String partnerName = _character.pregnantByPartnerName ?? 'Pasangan';

    // Reset status hamil
    _character.isPregnant = false;
    _character.partnerIsPregnant = false;
    _character.pregnantByPartnerName = null;
    _character.pregnantByPartnerRole = null;

    // Penalti kebahagiaan
    _character.happiness = (_character.happiness - 40).clamp(0, 100);

    // Tampilkan modal keguguran
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Keguguran 💔', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Kabar duka menyelimuti keluarga.\n\n'
          'Sayangnya, kehamilan yang dijalani bersama $partnerName tidak berhasil. '
          'Proses persalinan berakhir dengan keguguran.\n\n'
          'Kebahagiaanmu turun drastis (-40%).\n\n'
          'Sabar ya, semoga ada rezeki lain nanti.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- LOGIKA NOTIFIKASI AJAKAN KELUARGA ---
  void _checkActiveProposal() {
    if (_character.activeProposal == null) return;
    
    final proposal = _character.activeProposal!;
    final String partnerName = proposal['name'];
    final String type = proposal['type']; // 'Ajak Pacaran' atau 'Bercinta'
    final String relation = proposal['relation'];
    final String myGender = _character.gender.trim().toLowerCase();
    final String partnerGender = (proposal['gender'] ?? 'Laki-laki').trim().toLowerCase();

    String dialogTitle = '';
    String dialogBody = '';

    if (myGender == 'laki-laki' && partnerGender == 'laki-laki') {
      dialogTitle = type == 'Ajak Pacaran' ? 'Ajakan Gay (Pacaran)!' : 'Ajakan Gay (Bercinta)!';
      dialogBody = type == 'Ajak Pacaran'
          ? 'Saudaramu/Keluargamu, $partnerName mengajakmu untuk berkomitmen dalam hubungan sesama jenis (Gay) secara diam-diam. Apakah kamu mau menerimanya?'
          : '$partnerName (Gay) mendekatimu dengan tatapan penuh gairah dan mengajakmu untuk bercinta secara intim malam ini. Apakah kamu mau menerimanya?';
    } else if (myGender == 'perempuan' && partnerGender == 'perempuan') {
      dialogTitle = type == 'Ajak Pacaran' ? 'Ajakan Lesbian (Pacaran)!' : 'Ajakan Lesbian (Bercinta)!';
      dialogBody = type == 'Ajak Pacaran'
          ? 'Saudaramu/Keluargamu, $partnerName mengajakmu untuk berkomitmen dalam hubungan sesama jenis (Lesbian) secara diam-diam. Apakah kamu mau menerimanya?'
          : '$partnerName (Lesbian) mendekatimu dengan tatapan penuh gairah dan mengajakmu untuk bercinta secara intim malam ini. Apakah kamu mau menerimanya?';
    } else {
      dialogTitle = type == 'Ajak Pacaran' ? 'Ajakan Pacaran!' : 'Ajakan Mesra!';
      dialogBody = type == 'Ajak Pacaran'
          ? 'Saudaramu/Keluargamu, $partnerName mengajakmu untuk berkomitmen dalam hubungan berpacaran secara diam-diam. Apakah kamu mau menerimanya?'
          : '$partnerName mendekatimu dengan tatapan penuh gairah dan mengajakmu untuk bercinta secara intim malam ini. Apakah kamu mau menerimanya?';
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(type == 'Ajak Pacaran' ? Icons.favorite : Icons.heart_broken, color: Colors.pink, size: 28),
            const SizedBox(width: 8),
            Text(dialogTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(
          dialogBody,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (type == 'Ajak Pacaran') {
                setState(() {
                  _character.partner = {
                    'name': partnerName,
                    'gender': proposal['gender'],
                    'age': proposal['age'],
                    'relationship': '100',
                    'relation': 'Pacar',
                  };
                  _character.happiness = (_character.happiness + 30).clamp(0, 100);
                  
                  // Update relationship di siblings/parents
                  _updateFamilyRelationship(partnerName, 20);

                  _character.inbox.add(
                    '💖 Hubungan Baru: Kamu menerima ajakan pacaran dari keluargamu, $partnerName. Sekarang kalian resmi berpacaran diam-diam.'
                  );
                  _character.activeProposal = null;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('💖 Kamu menerima ajakan dari $partnerName!'),
                    backgroundColor: Colors.pink,
                  ),
                );
              } else {
                // Bercinta diterima -> Tampilkan dialog pengaman (kondom)
                _showIncomingCondomDialog(proposal);
              }
            },
            child: const Text('Terima', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _character.happiness = (_character.happiness - 10).clamp(0, 100);
                _updateFamilyRelationship(partnerName, -15);
                
                _character.inbox.add(
                  '💔 Penolakan: Kamu menolak ajakan ${type == "Ajak Pacaran" ? "pacaran" : "bercinta"} dari $partnerName.'
                );

                _character.activeProposal = null;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('💔 Kamu menolak ajakan dari $partnerName.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Tolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showIncomingCondomDialog(Map<String, dynamic> proposal) {
    final String partnerName = proposal['name'];
    final String relation = proposal['relation'];
    final String myGender = _character.gender.trim().toLowerCase();
    final String partnerGender = (proposal['gender'] ?? 'Laki-laki').trim().toLowerCase();
    final bool isHetero = myGender != partnerGender;

    String riskInfo = '';
    String whoGetsPregnant = '';
    int ageMin = 0, ageMax = 0;

    if (isHetero) {
      if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        whoGetsPregnant = 'Kamu hamil';
        ageMin = 8; ageMax = 45;
      } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        whoGetsPregnant = 'Pasanganmu hamil';
        ageMin = 9; ageMax = 65;
      }

      bool isAgeValid = _character.age >= ageMin && _character.age <= ageMax;
      if (isAgeValid) {
        double fertility = _getIncomingFertilityRate(_character.age, myGender);
        riskInfo = 'Jika TIDAK memakai pengaman: Ada ${(fertility * 100).toInt()}% risiko $whoGetsPregnant! (Usia saat ini ${_character.age} tahun, kesuburan ${(fertility * 100).toInt()}%)';
      } else {
        riskInfo = 'Jika TIDAK memakai pengaman: Risiko 0% karena usia saat ini (${_character.age} tahun) berada di luar masa subur. (Syarat: Minimal $ageMin - Maksimal $ageMax tahun)';
      }
    } else {
      riskInfo = 'Kombinasi gender: Kamu ($myGender) & Pasangan ($partnerGender) -> Risiko hamil 0% (Tidak memungkinkan secara biologis).';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.health_and_safety, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text('Gunakan Pengaman?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apa kamu ingin menggunakan kondom untuk mencegah kehamilan?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              'Gender: Kamu ($_character.gender) & $relation ($partnerGender)',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                riskInfo,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeIncomingBercinta(proposal, true);
            },
            child: const Text('Ya, pakai', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeIncomingBercinta(proposal, false);
            },
            child: const Text('Tidak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  double _getIncomingFertilityRate(int age, String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan') {
      if (age < 8 || age > 45) return 0.0;
      if (age >= 8 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.65;
      if (age >= 40 && age <= 45) return 0.30;
    } else {
      if (age < 9 || age > 65) return 0.0;
      if (age >= 9 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.75;
      if (age >= 40 && age <= 49) return 0.55;
      if (age >= 50 && age <= 65) return 0.35;
    }
    return 0.0;
  }

  void _executeIncomingBercinta(Map<String, dynamic> proposal, bool useCondom) {
    final String partnerName = proposal['name'];
    final String relation = proposal['relation'];
    final String myGender = _character.gender.trim().toLowerCase();
    final String partnerGender = (proposal['gender'] ?? 'Laki-laki').trim().toLowerCase();
    final Random random = Random();

    setState(() {
      _character.happiness = (_character.happiness + 20).clamp(0, 100);
      _updateFamilyRelationship(partnerName, 15);

      String additionalMsg = '';
      if (!useCondom && myGender != partnerGender) {
        double myFertility = _getIncomingFertilityRate(_character.age, myGender);
        if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
          if (!_character.isPregnant && myFertility > 0 && random.nextDouble() < myFertility) {
            _character.isPregnant = true;
            _character.pregnantByPartnerName = partnerName;
            _character.pregnantByPartnerRole = proposal['role'] ?? relation;
            _character.inbox.add(
              '🍼 Kabar Kehamilan: Kamu hamil dari hasil hubungan intim dengan $partnerName!'
            );
          }
        } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
          if (!_character.partnerIsPregnant && myFertility > 0 && random.nextDouble() < myFertility) {
            _character.partnerIsPregnant = true;
            _character.pregnantByPartnerName = partnerName;
            _character.pregnantByPartnerRole = proposal['role'] ?? relation;
            _character.inbox.add(
              '👶 Kabar Kehamilan: Pasangan/keluargamu, $partnerName, hamil dari hasil hubungan intim denganmu!'
            );
          }
        }
      }

      // Jalankan logika penularan penyakit seksual (STD) jika tidak pakai pengaman
      if (!useCondom) {
        // Panggil std_logic.dart helper
        importPenyakitSTDCheck(proposal);
      }

      _character.inbox.add(
        '💋 Aktivitas Mesra: Kamu menerima ajakan bercinta dari $partnerName. Kalian menghabiskan waktu intim bersama.'
      );
      _character.activeProposal = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💋 Kamu menerima ajakan bercinta dari $partnerName!'),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void importPenyakitSTDCheck(Map<String, dynamic> proposal) {
    // Memanggil handleSTDCheck di std_logic.dart
    final String partnerName = proposal['name'];
    final String relation = proposal['relation'];
    final String role = proposal['role'] ?? relation;
    final Random random = Random();
    
    handleSTDCheck(_character, role, partnerName, random);
  }

  void _updateFamilyRelationship(String targetName, int changeAmount) {
    if (targetName.startsWith('Ayah')) {
      if (targetName.contains('Tiri')) {
        _character.stepFatherRelationship = ((_character.stepFatherRelationship ?? 50) + changeAmount).clamp(0, 100);
      } else {
        _character.fatherRelationship = ((_character.fatherRelationship ?? 50) + changeAmount).clamp(0, 100);
      }
    } else if (targetName.startsWith('Ibu')) {
      _character.motherRelationship = ((_character.motherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else {
      for (var sib in _character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == targetName) {
          int currentRel = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          sib['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    }
  }

  // --- LOGIKA KATEGORI USIA ---
  Map<String, dynamic> _getAgeData(int age) {
    if (age <= 4) {
      return {'label': 'Bayi', 'icon': Icons.baby_changing_station, 'color': Colors.green};
    } else if (age <= 12) {
      return {'label': 'Anak-anak', 'icon': Icons.child_care, 'color': Colors.blueAccent};
    } else if (age <= 19) {
      return {'label': 'Remaja', 'icon': Icons.face, 'color': Colors.purple};
    } else if (age <= 59) {
      return {'label': 'Dewasa', 'icon': Icons.person, 'color': Colors.blue};
    } else {
      return {'label': 'Tua', 'icon': Icons.face_retouching_natural, 'color': Colors.grey};
    }
  }

  // --- FUNGSI SIMPAN PROGRESS ---
  void _saveProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 Fitur Simpan Progress belum diimplementasikan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // --- FUNGSI MULAI GAME BARU ---
  void _startNewGame() {
    _resetGame();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Game Baru dimulai! Buat karakter baru lagi.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ageData = _getAgeData(_character.age);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BitLife'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: PausedMenu(
        onRestart: _resetGame,
        onSaveProgress: _saveProgress,
        onNewGame: _startNewGame,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Character Card Info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.blue.shade50,
                      child: Image.network(
                        AvatarAgeRules.getAgeBasedAvatarUrl(
                          _character,
                          happiness: _character.happiness,
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        width: 72,
                        height: 72,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_character.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Gender: ${_character.gender} • ${_character.birthOrderLabel} (Anak ${_character.birthOrder == 1 ? 'Pertama' : 'ke-${_character.birthOrder}'})', style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                    Text('Umur: ${_character.age} Tahun', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            _buildStatRow('Kesehatan', _character.health, Colors.red),
            const SizedBox(height: 12),
            _buildStatRow('Kebahagiaan', _character.happiness, Colors.green),
            const SizedBox(height: 12),
            _buildStatRow('Kecerdasan', _character.intelligence, Colors.blue),
            const SizedBox(height: 12),
            _buildStatRow('Keuangan', _character.money, Colors.amber, isMoney: true),

            // --- TAMBAHAN MENU BARU ---
            const SizedBox(height: 12),
            _buildStatRow('Disiplin', _character.discipline, Colors.purple),
            const SizedBox(height: 12),
            _buildSexualityRow('Seksualitas', _character.sexuality),
            // --------------------------

            // --- STATUS KEHAMILAN (PERBAIKAN) ---
            if (_character.isPregnant || _character.partnerIsPregnant) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pink.shade200, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _character.isPregnant ? Icons.pregnant_woman : Icons.child_care,
                      color: Colors.pink,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _character.isPregnant 
                        ? 'Status: Hamil 🍼' 
                        : 'Status: ${_character.partner?['name'] ?? 'Pasangan'} Hamil 👶',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // --- 5 MENU UTAMA ---
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: [
                // 1. KATEGORI
                AgeCategoryButton(
                  ageData: ageData,
                  age: _character.age,
                  gender: _character.gender ?? 'Laki-laki',
                  location: _character.location ?? 'Indonesia',
                  health: _character.health,
                  happiness: _character.happiness,
                  intelligence: _character.intelligence,
                  money: _character.money,
                  appearance: _character.appearance ?? 50,
                ),
                
                // 2. ASSETS
                AssetsButton(
                  money: _character.money,
                  age: _character.age,
                ),
                
                // 3. HUBUNGAN
                RelationshipButton(
                  character: _character,
                  isAlive: _character.isAlive,
                  onRefresh: () {
                    setState(() {});
                  },
                ),
                
                // INBOX NOTIFIKASI
                InboxButton(
                  character: _character,
                  onRefresh: () {
                    setState(() {});
                  },
                ),
                
                // 4. AKTIVITAS
                ActivityButton(
                  character: _character,
                  isAlive: _character.isAlive,
                  onRefresh: () {
                    setState(() {});
                  },
                  onWork: () {
                    setState(() => _character.money += 100);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mendapatkan uang 100!')),
                    );
                  },
                  onStudy: () {
                    setState(() => _character.intelligence += 10);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kecerdasan +10!')),
                    );
                  },
                  onExercise: () {
                    setState(() => _character.health += 10);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kesehatan +10!')),
                    );
                  },
                ),
                
                // 5. TAMBAH UMUR
                AgeUpButton(
                  onPressed: _character.isAlive ? _ageUp : null,
                ),
              ],
            ),
            
            // Jika karakter mati
            if (!_character.isAlive)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: Text(
                    '💀 Karakter telah meninggal pada usia ${_character.age} tahun',
                    style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET STAT BAR ---
  Widget _buildStatRow(String label, int value, Color color, {bool isMoney = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(isMoney ? '\$$value' : '$value%', style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        if (!isMoney)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (value.clamp(0, 100)) / 100.0,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 12,
            ),
          ),
      ],
    );
  }

  // --- WIDGET STAT BAR UNTUK SEKSUALITAS (STRING) ---
  Widget _buildSexualityRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.withOpacity(0.3)),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.pink),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}