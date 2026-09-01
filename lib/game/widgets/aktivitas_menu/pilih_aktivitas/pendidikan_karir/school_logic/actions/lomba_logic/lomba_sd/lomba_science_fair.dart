// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_science_fair.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaScienceFairSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaScienceLabDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaScienceLabDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaScienceLabDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaScienceLabDialog> createState() => _LombaScienceLabDialogState();
}

class _LombaScienceLabDialogState extends State<_LombaScienceLabDialog> {
  final List<Map<String, dynamic>> _addedIngredients = [];

  final List<Map<String, dynamic>> _allIngredients = [
    {'name': 'Air Murni (H2O)', 'type': 'neutral', 'color': Colors.blue},
    {'name': 'Asam Sitrat 🍋', 'type': 'acid', 'color': Colors.red},
    {'name': 'Baking Soda 🧼', 'type': 'base', 'color': Colors.amber.shade700},
    {'name': 'Pewarna Biru 💙', 'type': 'color', 'color': Colors.indigo},
    {'name': 'Bubuk Magnesit ✨', 'type': 'catalyst', 'color': Colors.purple},
    {'name': 'Minyak Nabati 🛢️', 'type': 'oil', 'color': Colors.orange},
  ];

  void _addIngredient(Map<String, dynamic> item) {
    if (_addedIngredients.length < 3) {
      setState(() {
        _addedIngredients.add(item);
      });
    }
  }

  void _resetLab() {
    setState(() {
      _addedIngredients.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isComplete = _addedIngredients.length == 3;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.science, color: Colors.indigo, size: 28),
          SizedBox(width: 8),
          Text('Lab Eksperimen Gunung Berapi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih 3 bahan kimia di bawah untuk menciptakan reaksi erupsi sains terbaik!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 14),

              // Tabung Reaksi
              Container(
                width: 100,
                height: 135,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  border: Border.all(color: Colors.indigo, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _addedIngredients.map((item) {
                    final color = item['color'] as Color;
                    final name = item['name'] as String;
                    return Container(
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Text('Bahan Terisi: ${_addedIngredients.length}/3', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 14),

              // Pilihan Bahan
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _allIngredients.length,
                itemBuilder: (context, index) {
                  final item = _allIngredients[index];
                  final String name = item['name'] as String;
                  final Color color = item['color'] as Color;
                  final bool isUsed = _addedIngredients.contains(item);

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUsed ? Colors.grey : color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: isUsed || isComplete ? null : () => _addIngredient(item),
                    child: Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  );
                },
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16, color: Colors.red),
                label: const Text('Bersihkan Tabung', style: TextStyle(color: Colors.red, fontSize: 12)),
                onPressed: _resetLab,
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
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: !isComplete
              ? null
              : () {
                  Navigator.pop(context);

                  bool hasAcid = _addedIngredients.any((i) => i['type'] == 'acid');
                  bool hasBase = _addedIngredients.any((i) => i['type'] == 'base');
                  bool hasCatalyst = _addedIngredients.any((i) => i['type'] == 'catalyst');

                  Future.microtask(() {
                    if (hasAcid && hasBase && hasCatalyst) {
                      // Juara 1
                      int rewardMoney = 100 + Random().nextInt(51); // $100-$150
                      widget.character.intelligence = (widget.character.intelligence + 15).clamp(0, 100);
                      widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                      widget.character.money += rewardMoney;

                      showLombaOutcome(
                        context,
                        'Juara 1 Science Fair SD! 🔬🏆',
                        'REAKSI ERUPSI SPEKTAKULER! Kombinasi Asam, Basa, dan Katalis buatanmu memukau profesor juri!\n\n'
                        'Kecerdasan +15%\nKebahagiaan +10%\nHadiah Uang: \$$rewardMoney',
                        onConfirm: widget.onRefresh,
                      );
                    } else if (hasAcid && hasBase) {
                      // Juara 2
                      int rewardMoney = 50 + Random().nextInt(26); // $50-$75
                      widget.character.intelligence = (widget.character.intelligence + 10).clamp(0, 100);
                      widget.character.happiness = (widget.character.happiness + 6).clamp(0, 100);
                      widget.character.money += rewardMoney;

                      showLombaOutcome(
                        context,
                        'Juara 2 Science Fair! 🥈🔬',
                        'Busa reaksi kimia gunung berapi buatanmu meletup dengan manis di depan para juri!\n\n'
                        'Kecerdasan +10%\nKebahagiaan +6%\nHadiah Uang: \$$rewardMoney',
                        onConfirm: widget.onRefresh,
                      );
                    } else {
                      // Partisipasi
                      widget.character.intelligence = (widget.character.intelligence + 5).clamp(0, 100);
                      showLombaOutcome(
                        context,
                        'Pameran Sains 🔬',
                        'Campuran bahan kimia dalam tabung tidak menghasilkan reaksi erupsi, tapi kamu belajar dari eksperimen ini!\n\n'
                        'Kecerdasan +5%',
                        onConfirm: widget.onRefresh,
                      );
                    }
                  });
                },
          child: const Text('Uji Reaksi Erupsi'),
        ),
      ],
    );
  }
}
