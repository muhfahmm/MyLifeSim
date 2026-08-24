// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/dokter/dokter_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class DokterMenuHelper {
  static void showDokterMenu(BuildContext context, Character character, VoidCallback onComplete) {
    final List<Map<String, dynamic>> layanan = [
      {'name': 'Pemeriksaan Umum 🩺', 'cost': 200000, 'desc': 'Cek kondisi kesehatan dasar'},
      {'name': 'Tes Darah 💉', 'cost': 500000, 'desc': 'Pemeriksaan darah lengkap'},
      {'name': 'Konsultasi Psikolog 🧠', 'cost': 800000, 'desc': 'Sesi konsultasi kesehatan mental'},
      {'name': 'Operasi Kecil 🏥', 'cost': 5000000, 'desc': 'Operasi untuk mengatasi masalah kesehatan'},
      {'name': 'Medical Check Up Lengkap 📋', 'cost': 2000000, 'desc': 'Pemeriksaan menyeluruh tubuh'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Pergi ke Dokter 🏥',
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: layanan.length,
        itemBuilder: (_, i) {
          final l = layanan[i];
          final bool canAfford = character.money >= (l['cost'] as int);
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(l['name'], style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13,
                color: canAfford ? Colors.black87 : Colors.grey,
              )),
              subtitle: Text('${l['desc']}\nBiaya: \$${_fmt(l['cost'] as int)}'),
              isThreeLine: true,
              trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                  size: 14, color: canAfford ? Colors.blue : Colors.grey),
              onTap: canAfford ? () {
                Navigator.pop(context);
                _executeDokter(context, character, l, onComplete);
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

  static void _executeDokter(BuildContext context, Character character, Map<String, dynamic> l, VoidCallback onComplete) {
    final r = Random();
    character.money -= (l['cost'] as int);

    int healthGain = 0;
    int happinessGain = 0;
    int intelligenceGain = 0;
    String detail = '';

    if (l['name'].toString().contains('Umum')) {
      healthGain = 10 + r.nextInt(10);
      detail = 'Dokter menyatakan kondisimu cukup baik.';
    } else if (l['name'].toString().contains('Darah')) {
      healthGain = 5;
      intelligenceGain = 3;
      detail = 'Hasil tes darahmu normal. Dokter memberikan beberapa saran gizi.';
    } else if (l['name'].toString().contains('Psikolog')) {
      happinessGain = 20;
      detail = 'Sesi konsultasi sangat membantu. Pikiranmu terasa lebih ringan.';
    } else if (l['name'].toString().contains('Operasi')) {
      healthGain = 30;
      detail = 'Operasi berjalan lancar. Kesehatanmu meningkat signifikan.';
    } else if (l['name'].toString().contains('Check Up')) {
      healthGain = 15 + r.nextInt(10);
      happinessGain = 5;
      intelligenceGain = 2;
      detail = 'Medical check up lengkap selesai. Semua dalam kondisi prima.';
    }

    character.health = (character.health + healthGain).clamp(0, 100);
    character.happiness = (character.happiness + happinessGain).clamp(0, 100);
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100);

    final msg = '🏥 ${l['name']}: $detail (+${healthGain}% Kesehatan${happinessGain > 0 ? ', +${happinessGain}% Kebahagiaan' : ''}) | Biaya: -\$${_fmt(l['cost'] as int)}';
    character.inbox.add(msg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Pemeriksaan Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
