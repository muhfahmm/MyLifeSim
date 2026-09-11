// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/balap/negosiasi_kontrak_balap_modal.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'balap_logic/logika_pemain_balap.dart';

class NegosiasiKontrakBalapModal {
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
    final validYears = LogikaPemainBalap.getOpsiDurasiKontrak(widget.character.age);
    final int offered = widget.offerData['offeredYears'] as int? ?? 1;
    _selectedYears = validYears.contains(offered) ? offered : validYears.first;
    final int baseOffer = widget.offerData['offeredSalary'] as int? ?? 20000;
    _demandedSalary = (baseOffer * 1.15).round();
  }

  int _calculateSuccessChance() {
    final int offeredSalary = widget.offerData['offeredSalary'] as int? ?? 20000;
    final double ratio = _demandedSalary / offeredSalary;
    int chance = 100 - ((ratio - 1.0) * 150).round();

    double totalRatingSum = 0.0;
    int ratingCount = 0;
    for (var s in widget.character.athleteSeasonStats) {
      final r = s['rating'];
      if (r is num) {
        totalRatingSum += r.toDouble();
        ratingCount++;
      }
    }
    if (ratingCount > 0) {
      final avgR = totalRatingSum / ratingCount;
      if (avgR >= 8.5) {
        chance += 15;
      } else if (avgR >= 7.5) {
        chance += 5;
      } else if (avgR < 6.5) {
        chance -= 15;
      }
    }

    return chance.clamp(5, 95);
  }

  void _submitNegotiation() {
    final int chance = _calculateSuccessChance();
    final rand = Random();
    final bool success = rand.nextInt(100) < chance;
    final String teamName = widget.offerData['teamName'] ?? 'Tim Balap';

    Navigator.pop(context);

    if (success) {
      widget.character.jobSalary = _demandedSalary;
      widget.character.athleteContractYears = _selectedYears;
      widget.character.lastContractSignedAge = widget.character.age;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 26),
              SizedBox(width: 8),
              Text('Negosiasi Berhasil! 🤝', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Manajemen $teamName menyetujui tuntutan kontramu!\n\n'
            '• Durasi: $_selectedYears Tahun\n'
            '• Gaji: ${CurrencySettings.format(_demandedSalary)} / tahun',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onDone();
              },
              child: const Text('Mantap!', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      final int originalOfferSalary = widget.offerData['offeredSalary'] as int? ?? 20000;
      final int originalOfferYears = widget.offerData['offeredYears'] as int? ?? 1;

      widget.character.jobSalary = originalOfferSalary;
      widget.character.athleteContractYears = originalOfferYears;
      widget.character.lastContractSignedAge = widget.character.age;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.amber, size: 26),
              SizedBox(width: 8),
              Text('Negosiasi Ditolak ⚠️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Manajemen $teamName menolak tuntutanmu, namun menyetujui kontrak awal ($originalOfferYears Tahun - ${CurrencySettings.format(originalOfferSalary)}/tahun).',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onDone();
              },
              child: const Text('Setuju', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int offeredSalary = widget.offerData['offeredSalary'] as int? ?? 20000;
    final int chance = _calculateSuccessChance();
    final validYears = LogikaPemainBalap.getOpsiDurasiKontrak(widget.character.age);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.handshake, color: Colors.red, size: 26),
          SizedBox(width: 8),
          Text('Negosiasi Kontrak Balap 🏎️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tawaran Awal: ${CurrencySettings.format(offeredSalary)} / tahun', style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 14),
            const Text('Pilih Durasi Kontrak:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Wrap(
              spacing: 8,
              children: validYears.map((yr) {
                final bool isSelected = _selectedYears == yr;
                return ChoiceChip(
                  label: Text('$yr Tahun'),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedYears = yr);
                  },
                  selectedColor: Colors.red.shade200,
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tuntutan Gaji/Tahun:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(CurrencySettings.format(_demandedSalary), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14)),
              ],
            ),
            Slider(
              value: _demandedSalary.toDouble(),
              min: (offeredSalary * 0.8).roundToDouble(),
              max: (offeredSalary * 2.0).roundToDouble(),
              divisions: 24,
              activeColor: Colors.red,
              onChanged: (val) {
                setState(() => _demandedSalary = val.round());
              },
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: chance >= 60 ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(chance >= 60 ? Icons.thumb_up : Icons.warning, color: chance >= 60 ? Colors.green : Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Text('Peluang Disetujui: $chance%', style: TextStyle(fontWeight: FontWeight.bold, color: chance >= 60 ? Colors.green : Colors.red, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, foregroundColor: Colors.white),
          onPressed: _submitNegotiation,
          child: const Text('Ajukan Negosiasi', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
