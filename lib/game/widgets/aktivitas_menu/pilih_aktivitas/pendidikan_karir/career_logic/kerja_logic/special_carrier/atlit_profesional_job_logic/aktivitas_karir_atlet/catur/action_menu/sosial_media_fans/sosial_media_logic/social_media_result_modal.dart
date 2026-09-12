// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/sosial_media_logic/social_media_result_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'social_media_models.dart';

class SocialMediaResultModal {
  static void show({
    required BuildContext context,
    required Character character,
    required SocialCaptionOption option,
    required bool isSuccess,
    required int addedFollowers,
    required VoidCallback onDone,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.stars_rounded : Icons.warning_amber_rounded,
                color: isSuccess ? Colors.amber.shade700 : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isSuccess ? 'Postingan Medsos Viral! ✨🚀' : 'Dampak Postingan Medsos 📲',
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
                  // CARD NARASI HASIL (Warm Amber / Gold Theme)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSuccess
                          ? Colors.amber.shade900.withValues(alpha: 0.15)
                          : Colors.red.shade900.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSuccess ? Colors.amber.shade600 : Colors.red.shade400,
                      ),
                    ),
                    child: Text(
                      isSuccess ? option.successNarration : option.failNarration,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: isSuccess ? (isDark ? Colors.amber.shade300 : Colors.amber.shade900) : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // PERUBAHAN STATISTIK & FOLLOWERS
                  const Text('📈 Update Atribut & Sosial Media:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildChip('Followers', '+${_formatNumber(addedFollowers)} 👥', Colors.blue),
                      _buildChip('Popularitas', '${option.popularityDelta > 0 ? "+" : ""}${option.popularityDelta}% ⭐', Colors.amber.shade800),
                      _buildChip('Interaksi (Engagement)', '${option.engagementDelta > 0 ? "+" : ""}${option.engagementDelta}% 💬', Colors.purple),
                      if (option.moneyReward > 0)
                        _buildChip('Penghasilan Endorse', '+${CurrencySettings.format(option.moneyReward)} 💵', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // CARD RINGKASAN TOTAL MEDSOS SAAT INI
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoStat('Total Followers', _formatNumber(character.followers), Icons.people, Colors.blue, isDark),
                            _buildInfoStat('Popularitas', '${character.popularity}%', Icons.star, Colors.amber, isDark),
                            _buildInfoStat('Engagement', '${character.engagementRate}%', Icons.bar_chart, Colors.purple, isDark),
                          ],
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
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                onDone();
              },
              child: const Text('Mantap!', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  static Widget _buildChip(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label: $val',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  static Widget _buildInfoStat(String label, String val, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
        ),
      ],
    );
  }
}
