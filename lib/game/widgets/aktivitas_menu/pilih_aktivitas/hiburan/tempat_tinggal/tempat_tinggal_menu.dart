// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/tempat_tinggal/tempat_tinggal_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'tempat_tinggal_logic.dart';

class TempatTinggalMenuHelper {
  static void showTempatTinggalMenu(
    BuildContext context,
    Character character,
    VoidCallback onRefresh,
  ) {
    DialogHelper.show(
      context: context,
      title: 'Pilih Tempat Tinggal',
      isNotification: false,
      content: StatefulBuilder(
        builder: (context, setStateDialog) {
          final bool livesWithParents = character.livesWithParents;
          final String? activeHouse = character.activeHouseName;
          final List<Map<String, String>> ownedHouses = character.ownedHouses;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current Status Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      livesWithParents ? Icons.family_restroom : Icons.home,
                      color: Colors.blue,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status Tempat Tinggal saat Ini:',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            livesWithParents
                                ? 'Tinggal Bersama Orang Tua'
                                : 'Mandiri di ${activeHouse ?? 'Rumah Sendiri'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Opsi Tempat Tinggal:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),

              // Option 1: Tinggal bersama orang tua
              InkWell(
                onTap: () {
                  final res = TempatTinggalLogic.setLivingArrangement(
                    character,
                    livesWithParents: true,
                  );
                  setStateDialog(() {});
                  onRefresh();
                  DialogHelper.show(
                    context: context,
                    title: 'Tempat Tinggal',
                    content: Text((res['message'] ?? '').toString()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: livesWithParents
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: livesWithParents
                          ? Colors.green
                          : Colors.grey.withValues(alpha: 0.3),
                      width: livesWithParents ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.family_restroom, color: Colors.indigo, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tinggal Bersama Orang Tua',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              'Tidak memerlukan biaya sewa / perawatan rumah',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (livesWithParents)
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Option 2...N: Rumah yang dimiliki
              if (ownedHouses.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Kamu belum memiliki rumah pribadi. Beli rumah di menu Assets -> Properti & Rumah.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...ownedHouses.map((house) {
                  final String name = house['name'] ?? 'Rumah';
                  final String type = house['type'] ?? 'Hunian';
                  final bool isSelected = !livesWithParents && activeHouse == name;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        final res = TempatTinggalLogic.setLivingArrangement(
                          character,
                          livesWithParents: false,
                          houseName: name,
                        );
                        setStateDialog(() {});
                        onRefresh();
                        DialogHelper.show(
                          context: context,
                          title: 'Tempat Tinggal',
                          content: Text((res['message'] ?? '').toString()),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.home, color: Colors.teal, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    type,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
