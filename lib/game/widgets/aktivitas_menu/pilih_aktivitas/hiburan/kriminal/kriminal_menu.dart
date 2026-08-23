// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/kriminal/kriminal_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KriminalMenuHelper {
  static void showKriminalMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk melakukan tindakan kriminal.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> crimes = [
      {'name': 'Copet Dompet 👜', 'risk': 30, 'gain': 200000, 'jail': 1, 'desc': 'Mencuri dompet orang di keramaian'},
      {'name': 'Penipuan Online 💻', 'risk': 25, 'gain': 1000000, 'jail': 2, 'desc': 'Menipu orang melalui internet'},
      {'name': 'Perampokan Toko 🏪', 'risk': 60, 'gain': 5000000, 'jail': 5, 'desc': 'Merampok toko kecil'},
      {'name': 'Perjudian Ilegal 🎲', 'risk': 20, 'gain': 500000, 'jail': 1, 'desc': 'Berjudi di tempat terlarang'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Aksi Kriminal ⚠️',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Text('⚠️ Tindakan kriminal berisiko dipenjara! Pilih dengan bijak.',
                style: TextStyle(fontSize: 12, color: Colors.red)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: crimes.length,
            itemBuilder: (_, i) {
              final crime = crimes[i];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(crime['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('${crime['desc']}\nRisiko: ${crime['risk']}% | Penjara: ${crime['jail']} thn'),
                  isThreeLine: true,
                  trailing: Text('+Rp ${_fmt(crime['gain'] as int)}',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    _executeCrime(context, character, crime, onComplete);
                  },
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ],
    );
  }

  static void _executeCrime(BuildContext context, Character character, Map<String, dynamic> crime, VoidCallback onComplete) {
    final r = Random();
    final bool tertangkap = r.nextInt(100) < (crime['risk'] as int);

    String msg;
    if (tertangkap) {
      final jailYears = crime['jail'] as int;
      character.happiness = (character.happiness - 40).clamp(0, 100);
      character.health = (character.health - 10).clamp(0, 100);
      // TODO: implementasi logika penjara lengkap
      msg = '🚔 TERTANGKAP! Kamu ditangkap polisi saat ${crime['name']} dan dihukum $jailYears tahun penjara! (-40% Kebahagiaan, -10% Kesehatan)';
    } else {
      character.money += (crime['gain'] as int);
      character.happiness = (character.happiness + 10).clamp(0, 100);
      msg = '😈 BERHASIL! Kamu berhasil melakukan ${crime['name']} dan mendapatkan Rp ${_fmt(crime['gain'] as int)}! (+10% Kebahagiaan)';
    }

    character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(tertangkap ? Icons.local_police : Icons.check_circle,
              color: tertangkap ? Colors.red : Colors.green),
          const SizedBox(width: 8),
          Text(tertangkap ? 'Tertangkap!' : 'Berhasil!', style: const TextStyle(fontWeight: FontWeight.bold)),
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
