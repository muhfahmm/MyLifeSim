// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/rehabilitasi/rehabilitasi_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class RehabilitasiMenuHelper {
  static void showRehabilitasiMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk program rehabilitasi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> program = [
      {'name': 'Rehabilitasi Alkohol 🍺', 'cost': 10000000, 'duration': 30, 'happiness': 20, 'health': 25, 'desc': 'Program detoks dari ketergantungan alkohol'},
      {'name': 'Rehabilitasi Narkoba 💊', 'cost': 25000000, 'duration': 90, 'happiness': 25, 'health': 30, 'desc': 'Program pemulihan dari ketergantungan narkoba'},
      {'name': 'Rehabilitasi Judi 🎲', 'cost': 5000000, 'duration': 14, 'happiness': 15, 'health': 10, 'desc': 'Terapi mengatasi kecanduan berjudi'},
      {'name': 'Terapi Perilaku 🧠', 'cost': 3000000, 'duration': 7, 'happiness': 18, 'health': 5, 'desc': 'Terapi kognitif untuk mengubah pola pikir negatif'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Program Rehabilitasi 💚',
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: program.length,
        itemBuilder: (_, i) {
          final p = program[i];
          final bool canAfford = character.money >= (p['cost'] as int);
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text('${p['desc']}\nBiaya: Rp ${_fmt(p['cost'] as int)} | Durasi: ${p['duration']} hari'),
              isThreeLine: true,
              trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                  size: 14, color: canAfford ? Colors.deepPurple : Colors.grey),
              onTap: canAfford ? () {
                Navigator.pop(context);
                character.money -= (p['cost'] as int);
                character.happiness = (character.happiness + (p['happiness'] as int)).clamp(0, 100);
                character.health = (character.health + (p['health'] as int)).clamp(0, 100);
                final msg = '💚 Program ${p['name']} selesai! Kamu pulih dan siap menjalani hidup lebih baik. (+${p['happiness']}% Kebahagiaan, +${p['health']}% Kesehatan)';
                character.inbox.add(msg);
                showDialog(
                  context: context,
                  builder: (ctx2) => AlertDialog(
                    title: const Row(children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Program Selesai!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                    content: Text(msg),
                    actions: [TextButton(onPressed: () { Navigator.pop(ctx2); onComplete(); }, child: const Text('OK'))],
                  ),
                );
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

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
