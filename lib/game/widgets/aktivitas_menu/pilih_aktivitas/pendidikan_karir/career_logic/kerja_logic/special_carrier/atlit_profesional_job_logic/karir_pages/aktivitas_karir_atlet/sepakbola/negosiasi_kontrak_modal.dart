// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/negosiasi_kontrak_modal.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class NegosiasiKontrakModal {
  static void show({
    required BuildContext context,
    required Character character,
    required Map<String, dynamic> offerData,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _NegosiasiDialogWidget(
        character: character,
        offerData: offerData,
        onDone: onDone,
      ),
    );
  }
}

class _NegosiasiDialogWidget extends StatefulWidget {
  final Character character;
  final Map<String, dynamic> offerData;
  final VoidCallback onDone;

  const _NegosiasiDialogWidget({
    required this.character,
    required this.offerData,
    required this.onDone,
  });

  @override
  State<_NegosiasiDialogWidget> createState() => _NegosiasiDialogWidgetState();
}

class _NegosiasiDialogWidgetState extends State<_NegosiasiDialogWidget> {
  late int _selectedYears;
  late int _demandedSalary;

  @override
  void initState() {
    super.initState();
    _selectedYears = widget.offerData['offeredYears'] as int? ?? 3;
    final int baseOffer = widget.offerData['offeredSalary'] as int? ?? 10000;
    _demandedSalary = (baseOffer * 1.15).round(); // Default tuntutan +15% dari penawaran
  }

  int _calculateSuccessChance() {
    final int offeredSalary = widget.offerData['offeredSalary'] as int? ?? 10000;
    final double ratio = _demandedSalary / offeredSalary;

    double baseChance = 80.0;
    if (ratio > 1.0) {
      baseChance -= (ratio - 1.0) * 100 * 1.3; // Kenaikan gaji menurunkan peluang
    } else {
      baseChance += (1.0 - ratio) * 20;
    }

    // Bonus dari kesehatan & kedisiplinan karakter
    final double fitnessFactor = (widget.character.health + widget.character.discipline) / 200.0;
    baseChance += (fitnessFactor - 0.5) * 15;

    return baseChance.round().clamp(5, 95);
  }

  void _submitNegotiation() {
    final int chance = _calculateSuccessChance();
    final int roll = Random().nextInt(100);
    final String teamName = widget.offerData['teamName'] ?? 'Klub';

    Navigator.pop(context); // Tutup dialog negosiasi

    if (roll < chance) {
      // BERHASIL NEGOSIASI
      widget.character.jobSalary = _demandedSalary;
      widget.character.athleteContractYears = _selectedYears;

      final String successMsg = '📝 Negosiasi Kontrak Berhasil!\n'
          'Manajemen $teamName menyetujui tuntutanmu. Kontrak resmi diperpanjang selama $_selectedYears tahun dengan gaji baru ${CurrencySettings.format(_demandedSalary)}/tahun!';

      widget.character.inbox.add(successMsg);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Negosiasi Diterima! 🎉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Manajemen $teamName menyetujui tuntutan gajimu sebesar ${CurrencySettings.format(_demandedSalary)}/tahun dengan durasi $_selectedYears tahun!',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onDone();
              },
              child: const Text('Mantap! ⚽', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      // DITOLAK NEGOSIASI
      final String failMsg = '⚠️ Negosiasi Ditolak & Bebas Transfer!\n'
          'Manajemen $teamName merasa tuntutan gajimu terlalu tinggi dan memutuskan membatalkan tawaran kontrak. Kamu kini menjadi Pengangguran (Free Agent).';

      widget.character.inbox.add(failMsg);
      widget.character.resignJob();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Negosiasi Ditolak! ❌', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Manajemen $teamName menganggap tuntutan gajimu terlalu mahal. Mereka resmi membatalkan tawaran kontrak dan melepaskanmu ke status Bebas Transfer.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onDone();
              },
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String teamName = widget.offerData['teamName'] ?? 'Klub';
    final int offeredSalary = widget.offerData['offeredSalary'] as int? ?? 10000;
    final int offeredYears = widget.offerData['offeredYears'] as int? ?? 3;
    final int chance = _calculateSuccessChance();

    Color chanceColor = Colors.green;
    if (chance < 40) {
      chanceColor = Colors.red;
    } else if (chance < 70) {
      chanceColor = Colors.orange;
    }

    final int minSalary = (offeredSalary * 0.8).round();
    final int maxSalary = (offeredSalary * 2.0).round();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.handshake, color: Colors.amber, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Negosiasi Kontrak 🤝',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Klub: $teamName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tawaran Awal Klub: ${CurrencySettings.format(offeredSalary)}/th ($offeredYears th)',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pilihan Durasi Kontrak
            const Text(
              'Durasi Kontrak yang Diminta:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [1, 2, 3, 4, 5].map((years) {
                final bool isSelected = _selectedYears == years;
                return ChoiceChip(
                  label: Text('$years th'),
                  selected: isSelected,
                  selectedColor: Colors.green,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedYears = years;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Permintaan Gaji Baru Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tuntutan Gaji Baru:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  CurrencySettings.format(_demandedSalary),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Slider(
              value: _demandedSalary.toDouble().clamp(minSalary.toDouble(), maxSalary.toDouble()),
              min: minSalary.toDouble(),
              max: maxSalary.toDouble(),
              divisions: 24,
              activeColor: Colors.green,
              inactiveColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              onChanged: (val) {
                setState(() {
                  _demandedSalary = val.round();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencySettings.format(minSalary),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  CurrencySettings.format(maxSalary),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Indikator Peluang Berhasil
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: chanceColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: chanceColor),
              ),
              child: Row(
                children: [
                  Icon(
                    chance >= 50 ? Icons.trending_up : Icons.trending_down,
                    color: chanceColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Peluang Manajemen Setuju: $chance%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: chanceColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade800,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _submitNegotiation,
          icon: const Icon(Icons.send_rounded, size: 16),
          label: const Text('Kirim Negosiasi', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
