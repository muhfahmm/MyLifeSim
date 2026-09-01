// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_menyanyi.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaMenyanyiSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaMenyanyiDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaMenyanyiDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaMenyanyiDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaMenyanyiDialog> createState() => _LombaMenyanyiDialogState();
}

class _LombaMenyanyiDialogState extends State<_LombaMenyanyiDialog> {
  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _targetIndex = 0;
  int _timeLeft = 15;
  Timer? _timer;
  String _feedbackText = '';
  Color _feedbackColor = Colors.transparent;

  final List<Map<String, dynamic>> _notes = [
    {'name': 'Do 🎵', 'color': Colors.red},
    {'name': 'Re 🎶', 'color': Colors.orange},
    {'name': 'Mi 🎼', 'color': Colors.amber.shade700},
    {'name': 'Fa 🎤', 'color': Colors.green},
    {'name': 'Sol 🎷', 'color': Colors.blue},
    {'name': 'La 🎸', 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _targetIndex = Random().nextInt(_notes.length);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        t.cancel();
        _finishGame();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tapNote(int index) {
    if (index == _targetIndex) {
      setState(() {
        _score += 10 + (_combo * 2);
        _combo++;
        if (_combo > _maxCombo) _maxCombo = _combo;
        _feedbackText = _combo > 3 ? 'SUPER RHYTHM! 🔥 x$_combo' : 'PERFECT! 🎵';
        _feedbackColor = Colors.green;
        _targetIndex = Random().nextInt(_notes.length);
      });
    } else {
      setState(() {
        _combo = 0;
        _feedbackText = 'MISS! ❌';
        _feedbackColor = Colors.red;
        _targetIndex = Random().nextInt(_notes.length);
      });
    }
  }

  void _finishGame() {
    Navigator.pop(context);

    Future.microtask(() {
      if (_score >= 120) {
        // Juara 1
        int rewardMoney = 80 + Random().nextInt(41); // $80-$120
        widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
        widget.character.appearance = (widget.character.appearance + 10).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 1 Lomba Menyanyi Solo! 🥇🎤',
          'Harmoni nada dan ritme lagu buatanmu memukau dewan juri dan penonton!\n\n'
          'Kebahagiaan +15%\nPenampilan +10%\nHadiah Uang: \$$rewardMoney\n\n'
          'Statistik: Skor $_score | Max Combo $_maxCombo',
          onConfirm: widget.onRefresh,
        );
      } else if (_score >= 70) {
        // Juara 2
        int rewardMoney = 40 + Random().nextInt(21); // $40-$60
        widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
        widget.character.appearance = (widget.character.appearance + 5).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 2 Lomba Menyanyi! 🥈🎼',
          'Suaramu sangat merdu dan menghibur seluruh penonton!\n\n'
          'Kebahagiaan +10%\nPenampilan +5%\nHadiah Uang: \$$rewardMoney\n\n'
          'Statistik: Skor $_score | Max Combo $_maxCombo',
          onConfirm: widget.onRefresh,
        );
      } else {
        // Partisipasi
        widget.character.happiness = (widget.character.happiness + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Apresiasi Pentas Musik 🎤',
          'Kamu bernyanyi penuh semangat, meskipun ada beberapa nada yang sedikit fals!\n\n'
          'Kebahagiaan +4%\n\n'
          'Statistik: Skor $_score | Max Combo $_maxCombo',
          onConfirm: widget.onRefresh,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTarget = _notes[_targetIndex];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.mic, color: Colors.purple, size: 28),
          SizedBox(width: 8),
          Text('Rhythm Hero Menyanyi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Text('Waktu: $_timeLeft dtk', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  Text('Combo: x$_combo', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  Text('Skor: $_score', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 24,
                child: Text(
                  _feedbackText,
                  style: TextStyle(fontWeight: FontWeight.bold, color: _feedbackColor, fontSize: 13),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: (currentTarget['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: currentTarget['color'] as Color, width: 2.5),
                ),
                child: Column(
                  children: [
                    const Text('TEKAN NADA SECEPAT MUNGKIN:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      currentTarget['name'] as String,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: currentTarget['color'] as Color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: note['color'] as Color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _tapNote(index),
                    child: Text(note['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
