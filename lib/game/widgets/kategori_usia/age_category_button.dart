import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class AgeCategoryButton extends StatelessWidget {
  final Character character;
  final Map<String, dynamic> ageData;
  final int age;
  
  // Parameter tambahan untuk data karakter
  final String gender;
  final String location;
  final int health;
  final int happiness;
  final int intelligence;
  final int money;
  final int appearance;

  const AgeCategoryButton({
    super.key,
    required this.character,
    required this.ageData,
    required this.age,
    required this.gender,
    required this.location,
    required this.health,
    required this.happiness,
    required this.intelligence,
    required this.money,
    required this.appearance,
  });

  Widget _buildEducationHistorySection() {
    final history = character.educationHistory;
    final List<String> displayStages = [];

    if (character.age < 6) {
      return const Text(
        'Belum Memulai Pendidikan',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }

    // Selalu tampilkan SD
    displayStages.add('SD');

    if (history['SD'] == 'Lulus') {
      displayStages.add('SMP');
      if (history['SMP'] == 'Lulus') {
        displayStages.add('SMA');
        if (history['SMA'] == 'Lulus') {
          displayStages.add('S1');
          if (history['S1'] == 'Lulus') {
            displayStages.add('S2');
            if (history['S2'] == 'Lulus') {
              displayStages.add('S3');
            }
          }
        }
      }
    }

    return Column(
      children: displayStages.map((stage) {
        final status = history[stage] ?? 'Belum Lulus';
        Color badgeColor = Colors.grey;
        String statusLabel = 'Belum Lulus';

        if (status == 'Lulus') {
          badgeColor = Colors.green;
          statusLabel = 'Lulus';
        } else if (status == 'Putus Sekolah') {
          badgeColor = Colors.red;
          statusLabel = 'Putus Sekolah';
        } else {
          badgeColor = Colors.blue;
          statusLabel = 'Sedang Ditempuh';
        }

        return Card(
          elevation: 0,
          color: Colors.grey.shade50,
          margin: const EdgeInsets.only(bottom: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stage,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = ageData['color'];
    return InkWell(
      onTap: () {
        DialogHelper.show(
          context: context,
          title: '📊 Kategori & Status',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- HEADER: IKON USIA ---
              Center(
                child: Column(
                  children: [
                    Icon(ageData['icon'], size: 56, color: color),
                    const SizedBox(height: 8),
                    Text(
                      '${ageData['label']}',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- INFO DASAR (Gender, Usia, Lokasi) ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoItem(Icons.wc, 'Gender', gender, Colors.purple),
                    _buildInfoItem(Icons.cake, 'Usia', '$age Tahun', Colors.blue),
                    _buildInfoItem(Icons.location_on, 'Lokasi', location, Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- STATISTIK KARAKTER ---
              const Text('📈 Statistik Karakter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildStatChip(Icons.favorite, 'Kesehatan', health, Colors.red),
                  _buildStatChip(Icons.sentiment_satisfied, 'Kebahagiaan', happiness, Colors.green),
                  _buildStatChip(Icons.psychology, 'Kecerdasan', intelligence, Colors.blue),
                  _buildStatChip(Icons.monetization_on, 'Uang', money, Colors.amber, isMoney: true),
                  _buildStatChip(Icons.face, 'Penampilan', appearance, Colors.pink),
                ],
              ),
              const SizedBox(height: 16),

              // --- RIWAYAT PENDIDIKAN ---
              const Text('🎓 Riwayat Pendidikan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              _buildEducationHistorySection(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ageData['icon'], color: color, size: 28),
            const SizedBox(width: 8),
            Text(
              ageData['label'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PEMBANTU UNTUK INFO DASAR ---
  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // --- WIDGET PEMBANTU UNTUK CHIP STATISTIK ---
  Widget _buildStatChip(IconData icon, String label, int value, Color color, {bool isMoney = false}) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        isMoney ? '\$$value' : '$value%',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }
}