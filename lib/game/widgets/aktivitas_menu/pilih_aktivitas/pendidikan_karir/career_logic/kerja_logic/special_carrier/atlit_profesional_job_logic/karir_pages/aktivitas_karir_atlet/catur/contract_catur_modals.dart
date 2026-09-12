import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'negosiasi_kontrak_catur_modal.dart';
import 'tim_tertarik_catur_modal.dart';

class ContractCaturModal {
  static void showContractOffer(
    BuildContext context, {
    required Character character,
    required Map<String, dynamic> offerData,
    required VoidCallback onDone,
  }) {
    final String teamName = offerData['teamName'] ?? 'Klub Catur';
    final int offeredYears = offerData['offeredYears'] as int? ?? 3;
    final int offeredSalary = offerData['offeredSalary'] as int? ?? 8000;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.assignment_turned_in, color: Colors.deepPurple, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Penawaran Kontrak Catur ♟️',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    'Manajemen $teamName menawari perpanjangan kontrak baru!',
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurple),
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.deepPurple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onDone();
                  },
                  child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(width: 4),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    TimTertarikCaturModal.show(
                      context: context,
                      character: character,
                      onDone: onDone,
                    );
                  },
                  icon: const Icon(Icons.swap_horiz, size: 16),
                  label: const Text('Pilih Tim Lain', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
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
                    NegosiasiKontrakCaturModal.show(
                      context: context,
                      character: character,
                      offerData: offerData,
                      onDone: onDone,
                    );
                  },
                  icon: const Icon(Icons.handshake_outlined, size: 16),
                  label: const Text('Negosiasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
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
                  label: const Text('Terima', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
