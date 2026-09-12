// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/sosial_media_logic/social_media_dialog.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'social_media_models.dart';
import 'social_media_data.dart';
import 'social_media_result_modal.dart';

class SocialMediaDialog {
  static void show({
    required BuildContext context,
    required Character character,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _SocialTypeSelectionDialog(
        character: character,
        onDone: onDone,
      ),
    );
  }
}

// 1. DIALOG PILIHAN JENIS KONTEN
class _SocialTypeSelectionDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onDone;

  const _SocialTypeSelectionDialog({
    required this.character,
    required this.onDone,
  });

  @override
  State<_SocialTypeSelectionDialog> createState() => _SocialTypeSelectionDialogState();
}

class _SocialTypeSelectionDialogState extends State<_SocialTypeSelectionDialog> {
  late List<SocialContentType> _contentTypes;

  @override
  void initState() {
    super.initState();
    _contentTypes = SocialMediaData.getContentTypes();
  }

  void _selectContentType(SocialContentType contentType) {
    Navigator.pop(context); // Tutup dialog pilihan jenis konten

    // Buka dialog pilihan gaya caption
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CaptionSelectionDialog(
        character: widget.character,
        contentType: contentType,
        onDone: widget.onDone,
      ),
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
        title: const Row(
          children: [
            Icon(Icons.camera_alt_rounded, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Simulasi Media Sosial 📲✨',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                const Text(
                  'Kamu membuka aplikasi media sosial milikmu. Pilih jenis konten yang ingin kamu bagikan hari ini:',
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 14),

                ..._contentTypes.map((type) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.amber.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.amber.shade50.withValues(alpha: 0.4),
                      ),
                      onPressed: () => _selectContentType(type),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                type.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type.description,
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// 2. DIALOG PILIHAN GAYA CAPTION
class _CaptionSelectionDialog extends StatelessWidget {
  final Character character;
  final SocialContentType contentType;
  final VoidCallback onDone;

  const _CaptionSelectionDialog({
    required this.character,
    required this.contentType,
    required this.onDone,
  });

  void _postContent(BuildContext context, SocialCaptionOption option) {
    final Random random = Random();

    // Kalkulasi kesuksesan berdasarkan Kecerdasan & Karma
    double baseSuccessChance = 70.0;
    if (character.intelligence >= 75) baseSuccessChance += 15.0;
    if (character.karma >= 70) baseSuccessChance += 10.0;
    if (character.karma < 40) baseSuccessChance -= 15.0;

    final bool isSuccess = random.nextDouble() * 100 < baseSuccessChance;

    // Tambahkan pengikut baru
    int baseAddedFollowers = (character.followers * (option.followersMultiplier / 1000.0)).round();
    if (baseAddedFollowers < 50) baseAddedFollowers = 50 + random.nextInt(100);

    if (!isSuccess) {
      baseAddedFollowers = (baseAddedFollowers * 0.3).round(); // Pengikut lebih sedikit jika kurang viral
    }

    // Terapkan statistik ke Character
    character.followers += baseAddedFollowers;
    character.popularity = (character.popularity + option.popularityDelta).clamp(0, 100);
    character.engagementRate = (character.engagementRate + option.engagementDelta).clamp(0, 100);
    character.karma = (character.karma + option.karmaDelta).clamp(0, 100);
    if (option.moneyReward > 0) {
      character.money += option.moneyReward;
    }

    for (var cw in character.coworkers) {
      int r = int.tryParse(cw['relationship'] ?? '50') ?? 50;
      cw['relationship'] = (r + option.relationshipDelta).clamp(0, 100).toString();
    }

    Navigator.pop(context); // Tutup dialog caption

    // Tampilkan modal hasil akhir
    SocialMediaResultModal.show(
      context: context,
      character: character,
      option: option,
      isSuccess: isSuccess,
      addedFollowers: baseAddedFollowers,
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
            const Icon(Icons.edit_note_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gaya Caption: ${contentType.label}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                const Text(
                  'Tentukan gaya penulisan caption untuk postingan ini:',
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 14),

                ...contentType.captionOptions.map((opt) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.amber.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                      ),
                      onPressed: () => _postContent(context, opt),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                opt.label,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                              ),
                              const Icon(Icons.send_rounded, size: 14, color: Colors.amber),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt.captionText,
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
