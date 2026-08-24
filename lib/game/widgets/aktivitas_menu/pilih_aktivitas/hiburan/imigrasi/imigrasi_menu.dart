// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/imigrasi_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class ImigrasimMenuHelper {
  static void showImigrasimMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk berimigrasi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> negara = [
      {'name': '🇺🇸 Amerika Serikat', 'cost': 50000000, 'happiness': 20, 'desc': 'Tanah peluang besar'},
      {'name': '🇦🇺 Australia', 'cost': 40000000, 'happiness': 18, 'desc': 'Kualitas hidup tinggi'},
      {'name': '🇯🇵 Jepang', 'cost': 35000000, 'happiness': 15, 'desc': 'Teknologi dan budaya unik'},
      {'name': '🇩🇪 Jerman', 'cost': 30000000, 'happiness': 17, 'desc': 'Eropa yang stabil dan maju'},
      {'name': '🇸🇬 Singapura', 'cost': 20000000, 'happiness': 15, 'desc': 'Negara kota yang modern'},
      {'name': '🇲🇾 Malaysia', 'cost': 5000000, 'happiness': 8, 'desc': 'Negara tetangga yang ramah'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Pilih Negara Imigrasi ✈️',
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: negara.length,
        itemBuilder: (_, i) {
          final n = negara[i];
          final bool canAfford = character.money >= (n['cost'] as int);
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(n['name'], style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13,
                color: canAfford ? Colors.black87 : Colors.grey,
              )),
              subtitle: Text('${n['desc']}\nBiaya: \$${_fmt(n['cost'] as int)}'),
              isThreeLine: true,
              trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                  size: 14, color: canAfford ? Colors.teal : Colors.grey),
              onTap: canAfford ? () {
                Navigator.pop(context);
                character.money -= (n['cost'] as int);
                character.happiness = (character.happiness + (n['happiness'] as int)).clamp(0, 100);
                final msg = '✈️ Kamu pindah ke ${n['name']}! Kehidupan baru menanti. (+${n['happiness']}% Kebahagiaan)';
                character.inbox.add(msg);
                showDialog(
                  context: context,
                  builder: (ctx2) => AlertDialog(
                    title: const Row(children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Imigrasi Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
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
          child: const Text('Batal'),
        ),
      ],
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
