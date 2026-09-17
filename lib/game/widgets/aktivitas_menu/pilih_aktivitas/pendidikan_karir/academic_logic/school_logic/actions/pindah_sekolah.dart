// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/pindah_sekolah.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'dart:math';

class PindahSekolahActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PindahSekolahActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _pindahSekolah(BuildContext context, String type) {
    if (type == 'Swasta') {
      // Ask parents
      final parentRel = ((character.fatherRelationship ?? 50) + (character.motherRelationship ?? 50)) ~/ 2;
      final success = Random().nextInt(100) < parentRel;

      if (success) {
        final int happyBoost = 10 + Random().nextInt(11); // 10-20%
        character.schoolType = 'Swasta';
        character.happiness = (character.happiness + happyBoost).clamp(0, 100);
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.classmates.clear(); // Generate new classmates
        onRefresh();
        _showOutcome(context, 'Permintaan Disetujui! 🎉', 'Orang tuamu menyetujui permintaanmu untuk pindah ke Sekolah Swasta Unggulan! Kebahagiaan (+ $happyBoost%) dan Kecerdasan (+10%) meningkat.');
      } else {
        character.happiness = (character.happiness - 10).clamp(0, 100);
        onRefresh();
        _showOutcome(context, 'Permintaan Ditolak 😔', 'Orang tuamu menolak memindahkanmu ke Sekolah Swasta karena biayanya yang mahal. Kebahagiaanmu berkurang (-10%).');
      }
    } else {
      // Public school
      final int happyBoost = 5 + Random().nextInt(6); // 5-10%
      character.schoolType = 'Negeri';
      character.classmates.clear(); // Generate new classmates
      character.happiness = (character.happiness + happyBoost).clamp(0, 100);
      onRefresh();
      _showOutcome(context, 'Pindah Sekolah Negeri 🏫', 'Kamu berhasil pindah ke Sekolah Negeri baru. Kebahagiaanmu meningkat (+$happyBoost%). Kamu bersiap-siap bertemu dengan teman sekelas baru.');
    }
  }

  void _showOutcome(BuildContext context, String title, String content) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context); // Go back to school menu
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pindah Sekolah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: isDark ? Colors.blueGrey.shade900.withValues(alpha: 0.5) : Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_horiz_rounded, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pindah ke Sekolah Lain',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Apakah kamu merasa tidak cocok dengan sekolah saat ini? Pilih tipe sekolah baru yang ingin kamu masuki.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context: context,
              icon: Icons.school_rounded,
              title: 'Pindah ke Sekolah Negeri',
              subtitle: 'Gratis • Sekolah umum pemerintah',
              color: Colors.blueAccent,
              onTap: () => _pindahSekolah(context, 'Negeri'),
            ),
            const SizedBox(height: 14),
            _buildOptionCard(
              context: context,
              icon: Icons.star_rounded,
              title: 'Pindah ke Sekolah Swasta',
              subtitle: 'Minta persetujuan orang tua (Berbayar)',
              color: Colors.purple.shade600,
              onTap: () => _pindahSekolah(context, 'Swasta'),
            ),
          ],
        ),
      ),
    );
  }
}
