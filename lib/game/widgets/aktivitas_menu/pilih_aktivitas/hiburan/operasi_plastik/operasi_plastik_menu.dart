// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/operasi_plastik/operasi_plastik_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class OperasiPlastikMenuHelper {
  static void showOperasiPlastikMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk operasi plastik.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> operasi = [
      {'name': 'Rhinoplasty (Hidung) 👃', 'cost': 15000000, 'happiness': 15, 'risk': 10, 'desc': 'Operasi bentuk hidung agar lebih proporsional'},
      {'name': 'Blepharoplasty (Mata) 👁️', 'cost': 10000000, 'happiness': 12, 'risk': 8, 'desc': 'Operasi kelopak mata untuk tampak lebih segar'},
      {'name': 'Lip Filler (Bibir) 💋', 'cost': 5000000, 'happiness': 10, 'risk': 5, 'desc': 'Filler untuk bibir lebih penuh dan seksi'},
      {'name': 'Liposuction (Tubuh) 🏃', 'cost': 25000000, 'happiness': 20, 'risk': 20, 'desc': 'Sedot lemak untuk tubuh lebih ideal'},
      {'name': 'Facelift (Wajah) ✨', 'cost': 40000000, 'happiness': 25, 'risk': 15, 'desc': 'Operasi menyeluruh untuk tampak lebih muda'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.face, color: Colors.cyan),
          SizedBox(width: 8),
          Text('Operasi Plastik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Text('⚠️ Operasi plastik memiliki risiko komplikasi. Pertimbangkan baik-baik!',
                  style: TextStyle(fontSize: 12, color: Colors.orange)),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: operasi.length,
                itemBuilder: (_, i) {
                  final o = operasi[i];
                  final bool canAfford = character.money >= (o['cost'] as int);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      title: Text(o['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${o['desc']}\nBiaya: Rp ${_fmt(o['cost'] as int)} | Risiko: ${o['risk']}%'),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                          size: 14, color: canAfford ? Colors.cyan : Colors.grey),
                      onTap: canAfford ? () {
                        Navigator.pop(ctx);
                        _executeOperasi(context, character, o, onComplete);
                      } : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal'))],
      ),
    );
  }

  static void _executeOperasi(BuildContext context, Character character, Map<String, dynamic> o, VoidCallback onComplete) {
    final r = Random();
    character.money -= (o['cost'] as int);
    final bool komplikasi = r.nextInt(100) < (o['risk'] as int);
    String msg;

    if (komplikasi) {
      character.health = (character.health - 20).clamp(0, 100);
      character.happiness = (character.happiness - 15).clamp(0, 100);
      msg = '😨 Komplikasi! Operasi ${o['name']} mengalami masalah. Kesehatanmu turun drastis (-20% Kesehatan, -15% Kebahagiaan).';
    } else {
      character.happiness = (character.happiness + (o['happiness'] as int)).clamp(0, 100);
      msg = '✨ ${o['name']} berhasil! Kamu sangat puas dengan hasilnya. (+${o['happiness']}% Kebahagiaan)';
    }

    character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(komplikasi ? Icons.warning : Icons.check_circle,
              color: komplikasi ? Colors.red : Colors.green),
          const SizedBox(width: 8),
          Text(komplikasi ? 'Komplikasi!' : 'Operasi Berhasil', style: const TextStyle(fontWeight: FontWeight.bold)),
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
