// lib/game/widgets/age_category_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class AgeCategoryButton extends StatelessWidget {
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