// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/contract_modals.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'negosiasi_kontrak_modal.dart';

class ContractModal {
  /// Modal khusus untuk penawaran perpanjangan kontrak (Terima, Negosiasi, Tolak)
  static void showContractOffer(
    BuildContext context, {
    required Character character,
    required Map<String, dynamic> offerData,
    required VoidCallback onDone,
  }) {
    final String teamName = offerData['teamName'] ?? 'Klub';
    final int offeredYears = offerData['offeredYears'] as int? ?? 3;
    final int offeredSalary = offerData['offeredSalary'] as int? ?? 8000;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.assignment_turned_in, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Penawaran Kontrak Baru 📝',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  Text(
                    'Manajemen $teamName sangat puas dengan kontribusimu dan resmi menawarimu perpanjangan kontrak!',
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Durasi Kontrak: $offeredYears Tahun',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Gaji Ditawarkan: ${CurrencySettings.format(offeredSalary)} / tahun',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Apakah kamu ingin menerima tawaran ini, mencoba bernegosiasi gaji/durasi, atau menolak dan mencari klub lain?',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                character.resignJob();
                character.inbox.add('⚠️ Kamu menolak perpanjangan kontrak dari $teamName dan kini berstatus Bebas Transfer (Free Agent).');
                onDone();
              },
              child: const Text('Tolak & Resign', style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amber.shade800,
                    side: BorderSide(color: Colors.amber.shade700),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    NegosiasiKontrakModal.show(
                      context: context,
                      character: character,
                      offerData: offerData,
                      onDone: onDone,
                    );
                  },
                  icon: const Icon(Icons.handshake_outlined, size: 16),
                  label: const Text('Negosiasi', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    character.jobSalary = offeredSalary;
                    character.athleteContractYears = offeredYears;
                    character.lastContractSignedAge = character.age;
                    character.inbox.add('📝 Kamu menyetujui kontrak baru di $teamName selama $offeredYears tahun dengan gaji ${CurrencySettings.format(offeredSalary)}/tahun.');
                    onDone();
                  },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Terima', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Modal standar notifikasi akhir kontrak / informasi kontrak
  static void showContractNotice(
    BuildContext context, {
    required String noticeText,
    required VoidCallback onDone,
  }) {
    final bool isExtension = noticeText.contains('Pembaruan Kontrak');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                isExtension ? Icons.description_outlined : Icons.warning_amber_rounded,
                color: isExtension ? Colors.green.shade700 : Colors.orange.shade800,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isExtension ? 'Pembaruan Kontrak 📝' : 'Kontrak Berakhir ⚠️',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Text(
                noticeText
                    .replaceFirst('📝 Pembaruan Kontrak Ditawarkan!\n', '')
                    .replaceFirst('⚠️ Kontrak Berakhir & Bebas Transfer!\n', ''),
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onDone();
              },
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
