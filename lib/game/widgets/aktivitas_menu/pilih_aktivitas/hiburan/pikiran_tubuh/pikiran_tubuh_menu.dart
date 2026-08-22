// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/pikiran_tubuh/pikiran_tubuh_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class PikiranTubuhMenuHelper {
  static void showPikiranTubuhMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk melakukan latihan pikiran dan tubuh.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> aktivitas = [
      {'name': 'Meditasi 🧘', 'cost': 0, 'happiness': 15, 'intelligence': 5, 'health': 5, 'desc': 'Latihan pernapasan dan ketenangan batin'},
      {'name': 'Yoga 🌿', 'cost': 100000, 'happiness': 12, 'intelligence': 3, 'health': 8, 'desc': 'Gerakan tubuh untuk fleksibilitas dan ketenangan'},
      {'name': 'Terapi Pikiran 🧠', 'cost': 800000, 'happiness': 20, 'intelligence': 8, 'health': 5, 'desc': 'Sesi terapi kognitif dengan psikolog'},
      {'name': 'Tai Chi ☯️', 'cost': 150000, 'happiness': 10, 'intelligence': 4, 'health': 6, 'desc': 'Seni bela diri lembut untuk keseimbangan'},
      {'name': 'Journaling ✍️', 'cost': 0, 'happiness': 8, 'intelligence': 7, 'health': 2, 'desc': 'Menulis jurnal untuk ekspresi diri'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.self_improvement, color: Colors.indigo),
          SizedBox(width: 8),
          Text('Pikiran & Tubuh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: aktivitas.length,
            itemBuilder: (_, i) {
              final a = aktivitas[i];
              final bool canAfford = a['cost'] == 0 || character.money >= (a['cost'] as int);
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(a['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('${a['desc']}\n${a['cost'] == 0 ? "Gratis ✅" : "Biaya: Rp ${_fmt(a['cost'] as int)}"}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.indigo),
                  onTap: canAfford ? () {
                    Navigator.pop(ctx);
                    if (a['cost'] as int > 0) character.money -= (a['cost'] as int);
                    character.happiness = (character.happiness + (a['happiness'] as int)).clamp(0, 100);
                    character.intelligence = (character.intelligence + (a['intelligence'] as int)).clamp(0, 100);
                    character.health = (character.health + (a['health'] as int)).clamp(0, 100);
                    final msg = '${a['name']} selesai! Kamu merasa lebih tenang dan fokus. (+${a['happiness']}% Kebahagiaan, +${a['intelligence']}% Kecerdasan, +${a['health']}% Kesehatan)';
                    character.inbox.add(msg);
                    showDialog(
                      context: context,
                      builder: (ctx2) => AlertDialog(
                        title: const Row(children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Sesi Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup'))],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
