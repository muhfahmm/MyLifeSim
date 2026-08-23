// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/lotre/lotre_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

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

    final List<Map<String, dynamic>> jenis = [
      {'name': 'Tiket Lotre Biasa 🎟️', 'cost': 10000, 'prize': 50000000, 'chance': 5, 'desc': 'Tiket murah, jackpot lumayan'},
      {'name': 'Tiket Lotre Premium 🏆', 'cost': 100000, 'prize': 500000000, 'chance': 3, 'desc': 'Tiket mahal, jackpot besar'},
      {'name': 'Scratch Card 🃏', 'cost': 5000, 'prize': 1000000, 'chance': 15, 'desc': 'Kartu gosok dengan peluang lebih tinggi'},
      {'name': 'Mega Jackpot 💰', 'cost': 500000, 'prize': 5000000000, 'chance': 1, 'desc': 'Jackpot terbesar, peluang sangat kecil'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Main Lotre 🍀',
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: jenis.length,
        itemBuilder: (_, i) {
          final j = jenis[i];
          final bool canAfford = character.money >= (j['cost'] as int);
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(j['name'], style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13,
                color: canAfford ? Colors.black87 : Colors.grey,
              )),
              subtitle: Text('${j['desc']}\nHarga: Rp ${_fmt(j['cost'] as int)} | Peluang menang: ${j['chance']}%'),
              isThreeLine: true,
              trailing: Text('Rp ${_fmt(j['prize'] as int)}',
                  style: TextStyle(color: canAfford ? Colors.amber.shade700 : Colors.grey,
                      fontWeight: FontWeight.bold, fontSize: 11)),
              onTap: canAfford ? () {
                Navigator.pop(context);
                _executeLottery(context, character, j, onComplete);
              } : null,
            ),
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

  static void _executeLottery(BuildContext context, Character character, Map<String, dynamic> j, VoidCallback onComplete) {
    final r = Random();
    character.money -= (j['cost'] as int);
    final bool menang = r.nextInt(100) < (j['chance'] as int);

    String msg;
    if (menang) {
      character.money += (j['prize'] as int);
      character.happiness = (character.happiness + 30).clamp(0, 100);
      msg = '🎉 SELAMAT! Kamu MENANG ${j['name']}! Hadiahnya: Rp ${_fmt(j['prize'] as int)}! (+30% Kebahagiaan)';
    } else {
      character.happiness = (character.happiness - 5).clamp(0, 100);
      msg = '😢 Kamu tidak menang ${j['name']} kali ini. Mungkin lain kali lebih beruntung! (-5% Kebahagiaan, -Rp ${_fmt(j['cost'] as int)})';
    }

    character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Text(menang ? '🎊' : '😔', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(menang ? 'JACKPOT!' : 'Tidak Menang', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [TextButton(onPressed: () { Navigator.pop(ctx); onComplete(); }, child: const Text('OK'))],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
