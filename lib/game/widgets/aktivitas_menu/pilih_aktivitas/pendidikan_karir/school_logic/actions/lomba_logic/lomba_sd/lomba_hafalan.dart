// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_hafalan.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaHafalanSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaHafalanDragDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaHafalanDragDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaHafalanDragDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaHafalanDragDialog> createState() => _LombaHafalanDragDialogState();
}

class _LombaHafalanDragDialogState extends State<_LombaHafalanDragDialog> {
  final List<Map<String, dynamic>> _quranVerses = [
    {
      'title': 'Surah Al-Ikhlas (Ayat 1-2)',
      'target': ['Katakanlah', 'Dialah', 'Allah', 'Yang', 'Maha', 'Esa'],
    },
    {
      'title': 'Surah Al-Asr (Ayat 1-2)',
      'target': ['Demi', 'masa', 'sungguh', 'manusia', 'berada', 'dalam', 'kerugian'],
    },
    {
      'title': 'Deklamasi Puisi Anak',
      'target': ['Aku', 'ingin', 'meraih', 'cita-cita', 'setinggi', 'bintang', 'di', 'langit'],
    },
  ];

  late Map<String, dynamic> _selectedTopic;
  late List<String> _targetSentence;
  final List<String> _userArrangement = [];
  final List<String> _scrambledPool = [];

  @override
  void initState() {
    super.initState();
    _selectedTopic = _quranVerses[Random().nextInt(_quranVerses.length)];
    _targetSentence = List<String>.from(_selectedTopic['target'] as List);
    _scrambledPool.addAll(List<String>.from(_targetSentence)..shuffle(Random()));
  }

  void _addWord(String word) {
    setState(() {
      _userArrangement.add(word);
      _scrambledPool.remove(word);
    });
  }

  void _removeWord(String word) {
    setState(() {
      _userArrangement.remove(word);
      _scrambledPool.add(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isComplete = _scrambledPool.isEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.auto_stories, color: Colors.teal, size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedTopic['title'] as String,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seret/ketuk kata-kata di bawah untuk menyusun urutan kalimat hafalan yang sempurna!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 14),

              // Papan Susunan Kata
              Container(
                constraints: const BoxConstraints(minHeight: 85),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade300, width: 2),
                ),
                child: _userArrangement.isEmpty
                    ? const Center(child: Text('Ketuk kata pilihan di bawah...', style: TextStyle(color: Colors.grey, fontSize: 13)))
                    : Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _userArrangement.map((word) {
                          return ActionChip(
                            avatar: const Icon(Icons.close, size: 14, color: Colors.white),
                            label: Text(word, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            backgroundColor: Colors.teal,
                            onPressed: () => _removeWord(word),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 14),

              // Pool Kata Teracak
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _scrambledPool.map((word) {
                  return ActionChip(
                    label: Text(word, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    backgroundColor: Colors.teal.shade100,
                    onPressed: () => _addWord(word),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: !isComplete
              ? null
              : () {
                  Navigator.pop(context);

                  int correctCount = 0;
                  for (int i = 0; i < _targetSentence.length; i++) {
                    if (i < _userArrangement.length && _userArrangement[i] == _targetSentence[i]) {
                      correctCount++;
                    }
                  }

                  Future.microtask(() {
                    if (correctCount == _targetSentence.length) {
                      // Juara 1
                      int rewardMoney = 80 + Random().nextInt(41); // $80-$120
                      widget.character.discipline = (widget.character.discipline + 15).clamp(0, 100);
                      widget.character.karma = (widget.character.karma + 12).clamp(0, 100);
                      widget.character.money += rewardMoney;

                      showLombaOutcome(
                        context,
                        'Juara 1 Lomba Menghafal & Deklamasi! 📖🏆',
                        'Pelafalan hafalanmu sangat sempurna, fasih, dan menyentuh hati para juri!\n\n'
                        'Disiplin +15%\nKarma +12%\nHadiah Uang: \$$rewardMoney',
                        onConfirm: widget.onRefresh,
                      );
                    } else if (correctCount >= (_targetSentence.length / 2).ceil()) {
                      // Juara 2
                      int rewardMoney = 40 + Random().nextInt(21); // $40-$60
                      widget.character.discipline = (widget.character.discipline + 10).clamp(0, 100);
                      widget.character.karma = (widget.character.karma + 6).clamp(0, 100);
                      widget.character.money += rewardMoney;

                      showLombaOutcome(
                        context,
                        'Juara 2 Lomba Hafalan! 🥈📖',
                        'Hafalanmu hampir sempurna dengan irama bacaan yang merdu!\n\n'
                        'Disiplin +10%\nKarma +6%\nHadiah Uang: \$$rewardMoney',
                        onConfirm: widget.onRefresh,
                      );
                    } else {
                      // Partisipasi
                      widget.character.discipline = (widget.character.discipline + 4).clamp(0, 100);
                      showLombaOutcome(
                        context,
                        'Apresiasi Lomba Hafalan 📖',
                        'Urutan kata hafalanmu kurang pas, namun keberanianmu tampil mendapat pujian juri!\n\n'
                        'Disiplin +4%',
                        onConfirm: widget.onRefresh,
                      );
                    }
                  });
                },
          child: const Text('Kirim Hafalan'),
        ),
      ],
    );
  }
}
