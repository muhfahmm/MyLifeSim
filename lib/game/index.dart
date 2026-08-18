// lib/game/index.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/paused_menu/pausedMenu.dart';

// Import widget-widget UI
import 'package:bitlife/game/widgets/kategori_usia/age_category_button.dart';
import 'package:bitlife/game/widgets/assets_menu/assets_button.dart';
import 'package:bitlife/game/widgets/hubungan_menu/relationship_button.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/activity_button.dart';
import 'package:bitlife/game/widgets/kategori_usia/age_up_button.dart';

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

  // --- LOGIKA TAMBAH UMUR ---
  void _ageUp() {
    List<String> events = [];
    setState(() {
      events = _character.ageUp();
    });
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

  // --- LOGIKA NOTIFIKASI AJAKAN KELUARGA ---
  void _checkActiveProposal() {
    if (_character.activeProposal == null) return;
    
    final proposal = _character.activeProposal!;
    final String partnerName = proposal['name'];
    final String type = proposal['type']; // 'Ajak Pacaran' atau 'Bercinta'
    final String relation = proposal['relation'];
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(type == 'Ajak Pacaran' ? Icons.favorite : Icons.heart_broken, color: Colors.pink, size: 28),
            const SizedBox(width: 8),
            Text(type == 'Ajak Pacaran' ? 'Ajakan Pacaran!' : 'Ajakan Mesra!', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(
          type == 'Ajak Pacaran'
              ? 'Saudaramu/Keluargamu, $partnerName mengajakmu untuk berkomitmen dalam hubungan berpacaran secara diam-diam. Apakah kamu mau menerimanya?'
              : '$partnerName mendekatimu dengan tatapan penuh gairah dan mengajakmu untuk bercinta secara intim malam ini. Apakah kamu mau menerimanya?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (type == 'Ajak Pacaran') {
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
                } else {
                  // Bercinta diterima
                  _character.happiness = (_character.happiness + 20).clamp(0, 100);
                  _updateFamilyRelationship(partnerName, 15);
                }
                _character.activeProposal = null;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('💖 Kamu menerima ajakan dari $partnerName!'),
                  backgroundColor: Colors.pink,
                ),
              );
            },
            child: const Text('Terima', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _character.happiness = (_character.happiness - 10).clamp(0, 100);
                _updateFamilyRelationship(partnerName, -15);
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
                    const Icon(Icons.person, size: 64, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(_character.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Gender: ${_character.gender}', style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
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
                
                // 4. AKTIVITAS
                ActivityButton(
                  isAlive: _character.isAlive,
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
}