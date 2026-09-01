// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_matematika.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaMatematikaSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaMatematikaBattleDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaMatematikaBattleDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaMatematikaBattleDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaMatematikaBattleDialog> createState() => _LombaMatematikaBattleDialogState();
}

class _LombaMatematikaBattleDialogState extends State<_LombaMatematikaBattleDialog> {
  int _playerScore = 0;
  int _npcScore = 0;
  int _currentQuestionIndex = 0;
  final int _totalQuestions = 6;
  int _timeLeft = 7;
  Timer? _timer;
  late int _num1;
  late int _num2;
  late String _operator;
  late int _correctAnswer;
  late List<int> _options;

  final List<String> _npcNames = ['Budi', 'Siti', 'Rian', 'Dewi', 'Andi'];
  late String _npcName;

  @override
  void initState() {
    super.initState();
    _npcName = _npcNames[Random().nextInt(_npcNames.length)];
    _generateQuestion();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 7;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        // Waktu habis, NPC merebut poin jika hoki
        t.cancel();
        if (Random().nextInt(100) < 65) {
          _npcScore += 10;
        }
        _nextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateQuestion() {
    final rand = Random();
    int opType = rand.nextInt(3); // 0: +, 1: -, 2: x
    if (opType == 0) {
      _num1 = 6 + rand.nextInt(25);
      _num2 = 4 + rand.nextInt(25);
      _operator = '+';
      _correctAnswer = _num1 + _num2;
    } else if (opType == 1) {
      _num1 = 15 + rand.nextInt(35);
      _num2 = 5 + rand.nextInt(_num1 - 5);
      _operator = '-';
      _correctAnswer = _num1 - _num2;
    } else {
      _num1 = 2 + rand.nextInt(8);
      _num2 = 2 + rand.nextInt(9);
      _operator = '×';
      _correctAnswer = _num1 * _num2;
    }

    Set<int> opts = {_correctAnswer};
    while (opts.length < 4) {
      int wrong = _correctAnswer + (rand.nextInt(12) - 6);
      if (wrong >= 0 && wrong != _correctAnswer) opts.add(wrong);
    }
    _options = opts.toList()..shuffle();
  }

  void _answer(int val) {
    _timer?.cancel();
    if (val == _correctAnswer) {
      int speedBonus = _timeLeft * 2;
      _playerScore += 10 + speedBonus;
    } else {
      // NPC merebut kesempatan jika salah
      if (Random().nextInt(100) < 60) _npcScore += 10;
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentQuestionIndex + 1 < _totalQuestions) {
      setState(() {
        _currentQuestionIndex++;
        _generateQuestion();
      });
      _startTimer();
    } else {
      _finishGame();
    }
  }

  void _finishGame() {
    Navigator.pop(context);

    Future.microtask(() {
      if (_playerScore > _npcScore && _playerScore >= 60) {
        // Juara 1
        int rewardMoney = 100 + Random().nextInt(51); // $100-$150
        widget.character.intelligence = (widget.character.intelligence + 15).clamp(0, 100);
        widget.character.willpower = (widget.character.willpower + 10).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 1 Math Battle! 🧮🏆',
          'Kecepatan hitung kilatmu berhasil mengalahkan $_npcName!\n\n'
          'Kecerdasan +15%\nTekad +10%\nHadiah Uang: \$$rewardMoney\n\n'
          'Hasil Akhir: Kamu ($_playerScore Poin) vs $_npcName ($_npcScore Poin)',
          onConfirm: widget.onRefresh,
        );
      } else if (_playerScore >= _npcScore) {
        // Juara 2
        int rewardMoney = 50 + Random().nextInt(26); // $50-$75
        widget.character.intelligence = (widget.character.intelligence + 10).clamp(0, 100);
        widget.character.willpower = (widget.character.willpower + 5).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 2 Math Battle! 🥈🧮',
          'Pertandingan sengit! Kamu dan lawan bertarung sengit sampai soal terakhir.\n\n'
          'Kecerdasan +10%\nTekad +5%\nHadiah Uang: \$$rewardMoney\n\n'
          'Hasil Akhir: Kamu ($_playerScore Poin) vs $_npcName ($_npcScore Poin)',
          onConfirm: widget.onRefresh,
        );
      } else {
        // Partisipasi
        widget.character.intelligence = (widget.character.intelligence + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Apresiasi Lomba Matematika 🧮',
          '$_npcName sedikit lebih cepat dalam menjawab beberapa soal berhitung cepat!\n\n'
          'Kecerdasan +5%\n\n'
          'Hasil Akhir: Kamu ($_playerScore Poin) vs $_npcName ($_npcScore Poin)',
          onConfirm: widget.onRefresh,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.calculate, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text('Math Battle vs NPC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Text('Soal ${_currentQuestionIndex + 1}/$_totalQuestions', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Battle Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kamu: $_playerScore', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(10)),
                    child: Text('⏱️ $_timeLeft dtk', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                  Text('Lawan ($_npcName): $_npcScore', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: _timeLeft / 7.0,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(_timeLeft > 2 ? Colors.blue : Colors.red),
              ),
              const SizedBox(height: 16),
              // Soal Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade300, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$_num1 $_operator $_num2 = ?',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final val = _options[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _answer(val),
                    child: Text('$val', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
