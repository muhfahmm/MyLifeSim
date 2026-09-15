// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/misi_luar_angkasa_modal.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class MisiLuarAngkasaModal {
  static void show(
    BuildContext context, {
    required Character character,
    required VoidCallback onRefresh,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> missions = [
      {
        'title': 'Misi Perbaikan Teleskop Antariksa 📡',
        'desc': 'Melakukan Spacewalk (EVA) untuk mengganti panel surya teleskop',
        'rewardMoney': 120000,
        'popBonus': 8,
        'minHealth': 70,
        'icon': Icons.satellite,
        'color': Colors.indigo,
      },
      {
        'title': 'Ekspedisi Stasiun Luar Angkasa (ISS) 🛰️',
        'desc': 'Tinggal selama 6 bulan di ISS untuk eksperimen biologi mikro-gravitasi',
        'rewardMoney': 250000,
        'popBonus': 12,
        'minHealth': 75,
        'icon': Icons.space_dashboard,
        'color': Colors.blue,
      },
      {
        'title': 'Misi Eksplorasi Bulan (Artemis) 🌕',
        'desc': 'Pendaratan manusia di kutub selatan bulan & pengumpulan sampel batuan',
        'rewardMoney': 500000,
        'popBonus': 20,
        'minHealth': 80,
        'icon': Icons.brightness_3,
        'color': Colors.amber.shade800,
      },
      {
        'title': 'Misi Perintis Koloni Planet Mars 🔴',
        'desc': 'Misi berisiko tinggi meluncurkan wahana berawak menuju planet merah Mars',
        'rewardMoney': 1000000,
        'popBonus': 35,
        'minHealth': 85,
        'icon': Icons.public,
        'color': Colors.deepOrange,
      },
    ];

    DialogHelper.show(
      context: context,
      title: 'Pilih Misi Luar Angkasa 🌌🚀',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lembaga antariksa memanggil astronot terbaik untuk menjalankan misi penerbangan luar angkasa:',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 12),
          ...missions.map((mission) {
            final int minH = mission['minHealth'] as int;
            final bool isReady = character.health >= minH;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: mission['color'] as Color,
                  radius: 18,
                  child: Icon(mission['icon'] as IconData, color: Colors.white, size: 18),
                ),
                title: Text(
                  mission['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: Text(
                  '${mission['desc']}\n'
                  'Bonus Misi: ${CurrencySettings.format((mission['rewardMoney'] as int).toDouble())} • Min. Kesehatan $minH%',
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.grey.shade700),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isReady ? (mission['color'] as Color) : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    if (!isReady) {
                      DialogHelper.show(
                        context: context,
                        title: 'Kesehatan Tidak Mencukupi 🩺',
                        content: Text(
                          'Kesehatan fisikmu (${character.health}%) kurang dari syarat minimal $minH% untuk misi ini. Lakukan latihan di pusat kosmonot terlebih dahulu.',
                        ),
                      );
                      return;
                    }

                    Navigator.of(context, rootNavigator: true).pop();

                    final r = Random();
                    final bool isSuccess = r.nextInt(100) < (character.health + character.intelligence) ~/ 2 + 10;

                    if (isSuccess) {
                      final int moneyEarned = mission['rewardMoney'] as int;
                      final int popBonus = mission['popBonus'] as int;

                      character.money += moneyEarned;
                      character.popularity = (character.popularity + popBonus).clamp(0, 100);
                      character.followers += r.nextInt(5000) + 2000;
                      onRefresh();

                      DialogHelper.show(
                        context: context,
                        title: 'Misi Sukses Besar! 🚀🥇',
                        content: Text(
                          'Selamat! Misi ${mission['title']} berhasil dilaksanakan sempurna!\n\n'
                          '• Bonus Misi Diterima: ${CurrencySettings.format(moneyEarned.toDouble())}\n'
                          '• Popularitas Dunia: +$popBonus%\n'
                          '• Pengikut Baru: Tambah drastis di sosmed!',
                        ),
                      );
                    } else {
                      character.health = (character.health - 15).clamp(10, 100);
                      onRefresh();

                      DialogHelper.show(
                        context: context,
                        title: 'Kendala Teknis Misi ⚠️',
                        content: Text(
                          'Misi mengalami sedikit anomali sistem roket. Beruntung kapsul darurat mendarat selamat! (Kesehatan -15%)',
                        ),
                      );
                    }
                  },
                  child: const Text('Jalankan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
