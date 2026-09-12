// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/negosiasi_kontrak_renang_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class NegosiasiKontrakRenangModal {
  static void show({
    required BuildContext context,
    required Character character,
    required Map<String, dynamic> offerData,
    required VoidCallback onDone,
  }) {
    final int currentOffer = offerData['offeredSalary'] as int? ?? 50000000;
    final int requestedSalary = (currentOffer * 1.2).round();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Negosiasi Kontrak Renang 🏊‍♂️', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Kamu mencoba meminta kenaikan gaji menjadi ${CurrencySettings.format(requestedSalary)} per tahun.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              character.jobSalary = requestedSalary;
              character.inbox.add('🤝 Negosiasi berhasil! Gaji baru: ${CurrencySettings.format(requestedSalary)}/tahun.');
              onDone();
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }
}
