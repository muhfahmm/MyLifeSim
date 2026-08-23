// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/lisensi/lisensi_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class LisensiMenuHelper {
  static void showLisensiMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 17) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 17 tahun untuk mengurus lisensi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> lisensi = [
      {'name': 'SIM A (Mobil) 🚗', 'cost': 500000, 'minAge': 17, 'desc': 'Surat Izin Mengemudi kendaraan roda empat'},
      {'name': 'SIM C (Motor) 🏍️', 'cost': 300000, 'minAge': 17, 'desc': 'Surat Izin Mengemudi kendaraan roda dua'},
      {'name': 'SIM B (Truk) 🚛', 'cost': 800000, 'minAge': 21, 'desc': 'SIM untuk kendaraan berat'},
      {'name': 'Paspor 🛂', 'cost': 700000, 'minAge': 17, 'desc': 'Dokumen perjalanan internasional'},
      {'name': 'Lisensi Pilot ✈️', 'cost': 50000000, 'minAge': 21, 'desc': 'Lisensi untuk menerbangkan pesawat'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Urus Lisensi 📋',
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lisensi.length,
        itemBuilder: (_, i) {
          final l = lisensi[i];
          final bool ageOk = character.age >= (l['minAge'] as int);
          final bool canAfford = character.money >= (l['cost'] as int);
          final bool available = ageOk && canAfford;
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
                color: available ? Colors.black87 : Colors.grey,
              )),
              subtitle: Text('${l['desc']}\nBiaya: Rp ${_fmt(l['cost'] as int)} | Min. usia: ${l['minAge']} thn'),
              isThreeLine: true,
              trailing: Icon(available ? Icons.arrow_forward_ios : Icons.lock_outline,
                  size: 14, color: available ? Colors.brown : Colors.grey),
              onTap: available ? () {
                Navigator.pop(context);
                character.money -= (l['cost'] as int);
                character.intelligence = (character.intelligence + 3).clamp(0, 100);
                final msg = '📋 Kamu berhasil mendapatkan ${l['name']}! (+3% Kecerdasan, -Rp ${_fmt(l['cost'] as int)})';
                character.inbox.add(msg);
                showDialog(
                  context: context,
                  builder: (ctx2) => AlertDialog(
                    title: const Row(children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Lisensi Diperoleh!', style: TextStyle(fontWeight: FontWeight.bold)),
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
