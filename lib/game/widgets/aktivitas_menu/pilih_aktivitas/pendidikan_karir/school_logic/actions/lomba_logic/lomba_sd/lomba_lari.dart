// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_lari.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaLariSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaLariTappingDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaLariTappingDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaLariTappingDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaLariTappingDialog> createState() => _LombaLariTappingDialogState();
}

class _LombaLariTappingDialogState extends State<_LombaLariTappingDialog> {
  int _tapCount = 0;
  int _npcPosition = 0;
  int _timeLeft = 8;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
          _npcPosition += 4 + Random().nextInt(4); // NPC berlari konsisten 4-7 langkah/dtk
        });
      } else {
        t.cancel();
        _finishRace();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finishRace() {
    Navigator.pop(context);

    Future.microtask(() {
      if (_tapCount > _npcPosition && _tapCount >= 38) {
        // Juara 1
        int rewardMoney = 90 + Random().nextInt(41); // $90-$130
        widget.character.health = (widget.character.health + 15).clamp(0, 100);
        widget.character.willpower = (widget.character.willpower + 12).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 1 Lomba Lari Estafet! 🥇🏃‍♂️',
          'Lari sprint kilatmu ($_tapCount langkah) berhasil menyalip pelari sekolah lawan di detik terakhir!\n\n'
          'Kesehatan +15%\nTekad +12%\nHadiah Uang: \$$rewardMoney\n\n'
          'Posisi Akhir: Kamu ($_tapCount m) vs Lawan ($_npcPosition m)',
          onConfirm: widget.onRefresh,
        );
      } else if (_tapCount >= _npcPosition) {
        // Juara 2
        int rewardMoney = 40 + Random().nextInt(26); // $40-$65
        widget.character.health = (widget.character.health + 10).clamp(0, 100);
        widget.character.willpower = (widget.character.willpower + 6).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 2 Lomba Lari! 🥈🏃‍♂️',
          'Kamu memberikan performa luar biasa dan berhasil meraih posisi podium 2!\n\n'
          'Kesehatan +10%\nTekad +6%\nHadiah Uang: \$$rewardMoney\n\n'
          'Posisi Akhir: Kamu ($_tapCount m) vs Lawan ($_npcPosition m)',
          onConfirm: widget.onRefresh,
        );
      } else {
        // Partisipasi
        widget.character.health = (widget.character.health + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Finisher Lomba Lari 🏃‍♂️',
          'Kamu berhasil finis sampai garis akhir dan mendapat kebugaran tubuh!\n\n'
          'Kesehatan +5%\n\n'
          'Posisi Akhir: Kamu ($_tapCount m) vs Lawan ($_npcPosition m)',
          onConfirm: widget.onRefresh,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double playerProgress = (_tapCount / 40.0).clamp(0.0, 1.0);
    double npcProgress = (_npcPosition / 40.0).clamp(0.0, 1.0);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.directions_run, color: Colors.orange, size: 28),
          SizedBox(width: 8),
          Text('Tapping Race (Sprint)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('⏱️ Waktu: $_timeLeft dtk', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  Text('Langkah: $_tapCount m', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 12),

              // Track Lari Kamu
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('🏃 Kamu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                      Text('${(playerProgress * 100).toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: playerProgress,
                      minHeight: 14,
                      backgroundColor: Colors.blue.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Track Lari Lawan NPC
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('👟 Pelari Lawan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                      Text('${(npcProgress * 100).toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: npcProgress,
                      minHeight: 14,
                      backgroundColor: Colors.red.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tap Button Area
              GestureDetector(
                onTap: () {
                  setState(() {
                    _tapCount++;
                  });
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade500,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, size: 44, color: Colors.white),
                      SizedBox(height: 4),
                      Text('KETUK SECEPAT MUNGKIN!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.flag_outlined, color: Colors.red, size: 18),
          label: const Text('Menyerah', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
