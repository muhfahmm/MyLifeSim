// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_hafalan.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaHafalanSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaMengingatUmumDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaMengingatUmumDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaMengingatUmumDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaMengingatUmumDialog> createState() => _LombaMengingatUmumDialogState();
}

class _LombaMengingatUmumDialogState extends State<_LombaMengingatUmumDialog> {
  // 10 Topik dengan tingkat kesulitan yang bervariasi
  final List<Map<String, dynamic>> _topics = [
    {
      'title': 'Urutan Planet dari Matahari 🪐',
      'items': ['Merkurius', 'Venus', 'Bumi', 'Mars', 'Jupiter', 'Saturnus', 'Uranus', 'Neptunus'],
    },
    {
      'title': 'Urutan Warna Pelangi 🌈',
      'items': ['Merah', 'Jingga', 'Kuning', 'Hijau', 'Biru', 'Nila', 'Ungu'],
    },
    {
      'title': 'Urutan Abjad Bahasa Indonesia 🔤',
      'items': ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
    },
    {
      'title': 'Urutan Angka Genap 2-20 🧮',
      'items': ['2', '4', '6', '8', '10', '12', '14', '16', '18', '20'],
    },
    {
      'title': 'Urutan Langkah Mencuci Tangan 🧼',
      'items': ['Basahi tangan', 'Pakai sabun', 'Gosok telapak', 'Bilas bersih', 'Keringkan'],
    },
    {
      'title': 'Urutan Proses Fotosintesis 🌱',
      'items': ['Akar menyerap air', 'Daun menangkap cahaya', 'Terjadi reaksi kimia', 'Menghasilkan oksigen'],
    },
    {
      'title': 'Urutan Hari dalam Seminggu 📅',
      'items': ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'],
    },
    {
      'title': 'Urutan Bulan dalam Setahun 🗓️',
      'items': ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'],
    },
    {
      'title': 'Urutan Metamorfosis Kupu-Kupu 🦋',
      'items': ['Telur', 'Ulat', 'Kepompong', 'Kupu-kupu'],
    },
    {
      'title': 'Urutan Peristiwa Pagi Hari ⏰',
      'items': ['Bangun tidur', 'Mandi', 'Sarapan', 'Berangkat sekolah'],
    },
  ];

  late Map<String, dynamic> _selectedTopic;
  late List<String> _sequenceToMemorize;
  bool _isMemorizingPhase = true;
  int _memorizeTimeLeft = 7; // Memberi waktu lebih lama untuk urutan yang lebih panjang
  Timer? _timer;

  int _score = 0;
  int _currentIndex = 0;
  List<String> _shuffledChoices = [];

  @override
  void initState() {
    super.initState();
    _selectedTopic = _topics[Random().nextInt(_topics.length)];
    _sequenceToMemorize = List<String>.from(_selectedTopic['items'] as List);
    _shuffledChoices = List<String>.from(_sequenceToMemorize)..shuffle(Random());

    // Atur waktu hafalan berdasarkan panjang urutan
    _memorizeTimeLeft = _sequenceToMemorize.length >= 10 ? 10 : (_sequenceToMemorize.length >= 7 ? 8 : 6);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_memorizeTimeLeft > 1) {
        setState(() {
          _memorizeTimeLeft--;
        });
      } else {
        t.cancel();
        setState(() {
          _isMemorizingPhase = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _chooseItem(String item) {
    bool isCorrect = item == _sequenceToMemorize[_currentIndex];
    if (isCorrect) {
      _score += 10;
    }

    if (_currentIndex + 1 < _sequenceToMemorize.length) {
      setState(() {
        _currentIndex++;
        _shuffledChoices.shuffle(Random());
      });
    } else {
      _finishGame();
    }
  }

  void _finishGame() {
    Navigator.pop(context);

    Future.microtask(() {
      int totalMaxScore = _sequenceToMemorize.length * 10;
      if (_score == totalMaxScore) {
        // Juara 1: Skor Sempurna
        int rewardMoney = 80 + Random().nextInt(41); // $80-$120
        widget.character.intelligence = (widget.character.intelligence + 15).clamp(0, 100);
        widget.character.discipline = (widget.character.discipline + 12).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 1 Lomba Cerdas Cermat Memory! 🏆💡',
          'Daya ingatmu luar biasa presisi! Kamu menghafal urutan panjang tanpa salah sedikit pun (Skor: $_score/$totalMaxScore)!\n\n'
          'Kecerdasan +15%\nDisiplin +12%\nHadiah Uang: \$$rewardMoney',
          onConfirm: widget.onRefresh,
        );
      } else if (_score >= (totalMaxScore * 0.7)) {
        // Juara 2: Benar 70% ke atas
        int rewardMoney = 40 + Random().nextInt(21); // $40-$60
        widget.character.intelligence = (widget.character.intelligence + 10).clamp(0, 100);
        widget.character.discipline = (widget.character.discipline + 8).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 2 Lomba Mengingat! 🥈💡',
          'Ingatanmu cukup tajam, hanya beberapa urutan yang tertukar (Skor: $_score/$totalMaxScore)!\n\n'
          'Kecerdasan +10%\nDisiplin +8%\nHadiah Uang: \$$rewardMoney',
          onConfirm: widget.onRefresh,
        );
      } else if (_score >= (totalMaxScore * 0.4)) {
        // Juara 3: Benar 40% ke atas
        int rewardMoney = 15 + Random().nextInt(16); // $15-$30
        widget.character.intelligence = (widget.character.intelligence + 6).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 3 Lomba Mengingat! 🥉💡',
          'Usahamu sudah bagus, coba tingkatkan fokus untuk urutan yang lebih panjang lagi (Skor: $_score/$totalMaxScore)!\n\n'
          'Kecerdasan +6%\nHadiah Uang: \$$rewardMoney',
          onConfirm: widget.onRefresh,
        );
      } else {
        // Partisipasi
        widget.character.intelligence = (widget.character.intelligence + 3).clamp(0, 100);
        showLombaOutcome(
          context,
          'Apresiasi Lomba Mengingat 💡',
          'Beberapa urutan terlewat, namun latihan memori ini melatih fokus pikiranmu!\n\n'
          'Kecerdasan +3%',
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
        children: [
          const Icon(Icons.psychology, color: Colors.teal, size: 28),
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
        width: 360, // Lebih lebar agar grid muat
        child: SingleChildScrollView(
          child: _isMemorizingPhase
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(10)),
                      child: Text('👀 HAFALKAN DALAM $_memorizeTimeLeft DETIK!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.shade300, width: 2),
                      ),
                      child: Column(
                        children: _sequenceToMemorize.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '${entry.key + 1}. ${entry.value}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mana item urutan ke-${_currentIndex + 1}?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _shuffledChoices.length,
                      itemBuilder: (context, index) {
                        final choice = _shuffledChoices[index];
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _chooseItem(choice),
                          child: Text(choice, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        );
                      },
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