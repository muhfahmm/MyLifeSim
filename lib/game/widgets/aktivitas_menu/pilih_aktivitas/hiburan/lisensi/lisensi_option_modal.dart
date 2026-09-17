// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/lisensi/lisensi_option_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'ujian_lisensi_page.dart';

class LisensiOptionModal {
  static void showOptionModal({
    required BuildContext context,
    required Character character,
    required Map<String, dynamic> lisensiData,
    required VoidCallback onComplete,
    required VoidCallback onRefreshParent,
  }) {
    final String name = lisensiData['name'] ?? 'Lisensi';
    final int baseCost = lisensiData['cost'] as int? ?? 50;

    // Instant fee rates
    int instantCost = baseCost * 3;
    if (name.contains('SIM C')) {
      instantCost = 50000;
    } else if (name.contains('SIM A')) {
      instantCost = 100000;
    } else if (name.contains('Paspor')) {
      instantCost = 250000;
    } else if (name.contains('Pilot')) {
      instantCost = 25000000;
    }

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    DialogHelper.show(
      context: context,
      title: 'Urus $name 📋',
      headerColor: Colors.indigo.shade800,
      isNotification: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pilih metode untuk mendapatkan $name:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),

          // Option 1: Ikuti Ujian / Tes
          InkWell(
            onTap: () {
              if (character.money < baseCost) {
                DialogHelper.show(
                  context: context,
                  title: 'Uang Tidak Cukup ⚠️',
                  content: Text('Uang kamu tidak cukup untuk membayar ujian (${CurrencySettings.format(baseCost)}).'),
                );
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UjianLisensiPage(
                    character: character,
                    license: lisensiData,
                    onComplete: () {
                      onRefreshParent();
                      onComplete();
                    },
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.shade400, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📝 Ikuti Ujian / Tes',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Jawab soal teori & praktek untuk lulus.',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencySettings.format(baseCost),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark ? Colors.blueAccent : Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Option 2: Bayar Instan (Express / VIP)
          InkWell(
            onTap: () {
              if (character.money < instantCost) {
                DialogHelper.show(
                  context: context,
                  title: 'Saldo Kurang 💸',
                  content: Text('Uang kamu tidak cukup untuk layanan instan (${CurrencySettings.format(instantCost)}).'),
                );
                return;
              }

              character.money -= instantCost;
              if (!character.ownedLicenses.contains(name)) {
                character.ownedLicenses.add(name);
              }
              character.inbox.add('📋 Lisensi Express: Kamu mendapatkan $name secara instan!');
              onRefreshParent();
              onComplete();

              Navigator.pop(context);
              DialogHelper.show(
                context: context,
                title: 'Lisensi Terbit! 🎉',
                content: Text('🎉 Selamat! $name kamu telah terbit secara resmi tanpa perlu tes!'),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3B1D28) : Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade600, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡ Bayar Instan (Express / VIP)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Langsung terbit resmi tanpa perlu tes.',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencySettings.format(instantCost),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ],
    );
  }
}
