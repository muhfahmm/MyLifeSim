// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/lotre/lotre_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class LotreMenuHelper {
  static void showLotreMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk main lotre.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LotrePage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class LotrePage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const LotrePage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<LotrePage> createState() => _LotrePageState();
}

class _LotrePageState extends State<LotrePage> {
  final List<Map<String, dynamic>> jenis = [
    {'name': 'Tiket Lotre Biasa 🎟️', 'cost': 10000, 'prize': 50000000, 'chance': 5, 'desc': 'Tiket murah, jackpot lumayan'},
    {'name': 'Tiket Lotre Premium 🏆', 'cost': 100000, 'prize': 500000000, 'chance': 3, 'desc': 'Tiket mahal, jackpot besar'},
    {'name': 'Scratch Card 🃏', 'cost': 5000, 'prize': 1000000, 'chance': 15, 'desc': 'Kartu gosok dengan peluang lebih tinggi'},
    {'name': 'Mega Jackpot 💰', 'cost': 500000, 'prize': 5000000000, 'chance': 1, 'desc': 'Jackpot terbesar, peluang sangat kecil'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeLottery(BuildContext context, Map<String, dynamic> j) {
    final r = Random();
    setState(() {
      widget.character.money -= (j['cost'] as int);
    });
    final bool menang = r.nextInt(100) < (j['chance'] as int);

    String msg;
    if (menang) {
      setState(() {
        widget.character.money += (j['prize'] as int);
        widget.character.happiness = (widget.character.happiness + 30).clamp(0, 100);
      });
      msg = '🎉 SELAMAT! Kamu MENANG ${j['name']}! Hadiahnya: \$${_fmt(j['prize'] as int)}! (+30% Kebahagiaan)';
    } else {
      setState(() {
        widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
      });
      msg = '😢 Kamu tidak menang ${j['name']} kali ini. Mungkin lain kali lebih beruntung! (-5% Kebahagiaan, -\$${_fmt(j['cost'] as int)})';
    }

    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Text(menang ? '🎊' : '😔', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(menang ? 'JACKPOT!' : 'Tidak Menang', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Lotre 🍀', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: \$${_fmt(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: jenis.length,
                itemBuilder: (_, i) {
                  final j = jenis[i];
                  final bool canAfford = widget.character.money >= (j['cost'] as int);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: canAfford ? Colors.white : Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(j['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: canAfford ? Colors.black87 : Colors.grey,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${j['desc']}\nHarga: \$${_fmt(j['cost'] as int)} | Peluang menang: ${j['chance']}%',
                          style: TextStyle(color: canAfford ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Text('\$${_fmt(j['prize'] as int)}',
                          style: TextStyle(color: canAfford ? Colors.amber.shade700 : Colors.grey,
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      onTap: canAfford ? () => _executeLottery(context, j) : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
