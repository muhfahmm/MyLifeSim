// lib/game/widgets/aktivitas_menu/activity_button.dart

import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/masturbate.dart';

// Import submenus untuk sekolah
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/school_menu_page.dart';

class ActivityButton extends StatelessWidget {
  final Character character;
  final bool isAlive;
  final VoidCallback onWork;
  final VoidCallback onExercise;
  final VoidCallback onRefresh;

  const ActivityButton({
    super.key,
    required this.character,
    required this.isAlive,
    required this.onWork,
    required this.onExercise,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!isAlive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Karakter sudah meninggal!')),
          );
          return;
        }

        final int age = character.age;

        DialogHelper.show(
          context: context,
          title: 'Pilih Aktivitas',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ============================================
              // 1. BAGIAN PENDIDIKAN & KARIR
              // ============================================
              const Text('Pendidikan & Karir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 8),

              // Item Sekolah (Kondisional berdasarkan usia)
              if (age >= 6 && age <= 12)
                _buildActivityTile(
                  context: context,
                  label: 'Sekolah Dasar (SD)',
                  subtitle: 'Belajar dan bermain di Sekolah Dasar',
                  icon: Icons.school,
                  color: Colors.blue,
                  minAge: 6,
                  currentAge: age,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchoolMenuPage(
                          character: character,
                          onRefresh: onRefresh,
                        ),
                      ),
                    );
                  },
                ),
              if (age >= 13 && age <= 15)
                _buildActivityTile(
                  context: context,
                  label: 'Sekolah Menengah Pertama (SMP)',
                  subtitle: 'Lanjutkan pendidikan tingkat pertama',
                  icon: Icons.school,
                  color: Colors.blueAccent,
                  minAge: 13,
                  currentAge: age,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchoolMenuPage(
                          character: character,
                          onRefresh: onRefresh,
                        ),
                      ),
                    );
                  },
                ),
              if (age >= 16 && age <= 18)
                _buildActivityTile(
                  context: context,
                  label: 'Sekolah Menengah Atas (SMA)',
                  subtitle: 'Pendidikan tingkat atas persiapan karir',
                  icon: Icons.school,
                  color: Colors.purple,
                  minAge: 16,
                  currentAge: age,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchoolMenuPage(
                          character: character,
                          onRefresh: onRefresh,
                        ),
                      ),
                    );
                  },
                ),
              if (age >= 19 && age <= 23)
                _buildActivityTile(
                  context: context,
                  label: 'Universitas (Kuliah)',
                  subtitle: 'Menempuh pendidikan tinggi untuk karir profesional',
                  icon: Icons.school,
                  color: Colors.indigo,
                  minAge: 19,
                  currentAge: age,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchoolMenuPage(
                          character: character,
                          onRefresh: onRefresh,
                        ),
                      ),
                    );
                  },
                ),

              // Item Bekerja (Terbuka usia 19)
              _buildActivityTile(
                context: context,
                label: 'Bekerja',
                subtitle: 'Mulai bekerja untuk menghasilkan uang tunai',
                icon: Icons.work,
                color: Colors.green,
                minAge: 19,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  onWork();
                },
              ),

              const Divider(height: 32),

              // ============================================
              // 2. BAGIAN KESEHATAN & KEBUGARAN
              // ============================================
              const Text('Kesehatan & Kebugaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 8),

              // Item Olahraga (Terbuka usia 7)
              _buildActivityTile(
                context: context,
                label: 'Olahraga',
                subtitle: 'Latih fisikmu agar tetap sehat dan bugar',
                icon: Icons.fitness_center,
                color: Colors.orange,
                minAge: 7,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  onExercise();
                },
              ),

              if (age >= 9) ...[
                const Divider(height: 32),
                
                // ============================================
                // 3. BAGIAN LAINNYA
                // ============================================
                const Text('Lainnya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                const SizedBox(height: 8),

                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.grey.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                    title: const Text('Masturbasi (Fantasi)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Mengeksplorasi fantasi pribadimu'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    onTap: () {
                      Navigator.pop(context);
                      MasturbasiHelper.showMasturbationMenu(context, character, onRefresh);
                    },
                  ),
                ),
              ],
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.withOpacity(0.2),
        foregroundColor: Colors.purple,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.purple, width: 1.5),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_run, size: 28),
          SizedBox(height: 4),
          Text(
            'Aktivitas',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple),
          ),
        ],
      ),
    );
  }

  // --- Helper untuk membuat item aktivitas dengan batas usia ---
  Widget _buildActivityTile({
    required BuildContext context,
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int minAge,
    required int currentAge,
    required VoidCallback onTap,
  }) {
    final bool isUnlocked = currentAge >= minAge;
    final Color itemColor = isUnlocked ? color : Colors.grey.shade400;
    final Color textColor = isUnlocked ? Colors.black87 : Colors.grey.shade400;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isUnlocked ? Colors.grey.shade200 : Colors.grey.shade100),
      ),
      color: isUnlocked ? Colors.grey.shade50 : Colors.grey.shade50.withOpacity(0.5),
      child: ListTile(
        leading: Icon(icon, color: itemColor),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.black54 : Colors.grey.shade400)),
        trailing: isUnlocked
            ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
            : const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
        onTap: isUnlocked
            ? onTap
            : () {
                DialogHelper.show(
                  context: context,
                  title: 'Akses Dibatasi',
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🔒', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kamu harus berusia minimal $minAge tahun untuk membuka aktivitas ini.',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0), // Solid light orange
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFB74D)), // Solid border
                        ),
                        child: Row(
                          children: [
                            const Text('⚠️', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            Text(
                              'Usia saat ini: $currentAge tahun',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
      ),
    );
  }
}