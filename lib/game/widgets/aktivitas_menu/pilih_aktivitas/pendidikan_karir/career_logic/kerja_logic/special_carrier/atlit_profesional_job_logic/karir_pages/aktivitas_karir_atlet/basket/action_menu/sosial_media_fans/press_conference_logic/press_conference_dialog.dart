// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/press_conference_logic/press_conference_dialog.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'press_conference_models.dart';
import 'press_conference_result_modal.dart';

class PressConferenceDialog {
  static void show({
    required BuildContext context,
    required Character character,
    required PressEvent pressEvent,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PressDialogWidget(
        character: character,
        pressEvent: pressEvent,
        onDone: onDone,
      ),
    );
  }
}

class _PressDialogWidget extends StatelessWidget {
  final Character character;
  final PressEvent pressEvent;
  final VoidCallback onDone;

  const _PressDialogWidget({
    required this.character,
    required this.pressEvent,
    required this.onDone,
  });

  void _selectOption(BuildContext context, PressOption option) {
    // 1. Terapkan perubahan pada karakter
    character.publicTrust = (character.publicTrust + option.publicTrustDelta).clamp(0, 100);
    character.pressure = (character.pressure + option.pressureDelta).clamp(0, 100);
    character.happiness = (character.happiness + option.happinessDelta).clamp(0, 100);

    for (var cw in character.coworkers) {
      int r = int.tryParse(cw['relationship'] ?? '50') ?? 50;
      cw['relationship'] = (r + option.relationshipDelta).clamp(0, 100).toString();
    }

    Navigator.pop(context); // Tutup dialog pertanyaan

    // 2. Tampilkan sub-menu hasil & analisis
    PressConferenceResultModal.show(
      context: context,
      character: character,
      chosenOption: option,
      onDone: onDone,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.mic_external_on, color: Colors.blue, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                pressEvent.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                // KATEGORI EVENT
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    pressEvent.category,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                  ),
                ),
                const SizedBox(height: 10),

                // PERTANYAAN MEDIA
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade300.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    pressEvent.question,
                    style: TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pilih Gaya & Pernyataan Jawabanmu:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),

                // DAFTAR PILIHAN JAWABAN (GAYA BICARA)
                ...pressEvent.options.map((opt) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.blue.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                      ),
                      onPressed: () => _selectOption(context, opt),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                opt.label,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt.answerText,
                            style: TextStyle(fontSize: 12, height: 1.3, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
