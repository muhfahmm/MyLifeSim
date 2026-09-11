// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/press_conference_logic/press_conference_result_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'press_conference_models.dart';

class PressConferenceResultModal {
  static void show({
    required BuildContext context,
    required Character character,
    required PressOption chosenOption,
    required VoidCallback onDone,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color gradeColor = Colors.green;
    if (chosenOption.mediaGrade == 'B') gradeColor = Colors.blue;
    if (chosenOption.mediaGrade == 'C') gradeColor = Colors.amber.shade800;
    if (chosenOption.mediaGrade == 'D') gradeColor = Colors.red;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: const Row(
            children: [
              Icon(Icons.assessment_rounded, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hasil & Analisis Konferensi Pers 📰',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. ANALISIS MEDIA (MEDIA RATING)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: gradeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: gradeColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: gradeColor,
                          child: Text(
                            chosenOption.mediaGrade,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '📰 Nilai Analisis Media',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                'Gaya Bicara: ${chosenOption.styleName}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. PERUBAHAN STATISTIK
                  const Text('📊 Perubahan Statistik & Efek:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildStatChip('Kepercayaan Publik', chosenOption.publicTrustDelta, isDark),
                      _buildStatChip('Tingkat Tekanan', chosenOption.pressureDelta, isDark, isInverse: true),
                      _buildStatChip('Kebahagiaan', chosenOption.happinessDelta, isDark),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 3. REAKSI FANS DI SOSMED
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.blue),
                            SizedBox(width: 4),
                            Text('📱 Reaksi Fans di Sosmed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chosenOption.fanReaction,
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4. REAKSI REKAN TIM & PELATIH
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.groups_outlined, size: 14, color: Colors.purple),
                            SizedBox(width: 4),
                            Text('💬 Reaksi Tim & Pelatih', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chosenOption.teamReaction,
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                onDone();
              },
              child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatChip(String label, int delta, bool isDark, {bool isInverse = false}) {
    if (delta == 0) return const SizedBox.shrink();
    final bool isPositive = isInverse ? delta < 0 : delta > 0;
    final String sign = delta > 0 ? '+' : '';
    final Color chipColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: chipColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label: $sign$delta',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: chipColor),
      ),
    );
  }
}
