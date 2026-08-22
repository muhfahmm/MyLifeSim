// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/adopsi_anak/adopsi_anak_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class AdopsiAnakMenuHelper {
  static void showAdopsiAnakMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 21) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 21 tahun untuk mengadopsi anak.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    if (character.money < 5000000) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Dana Tidak Cukup'),
          content: const Text('Proses adopsi memerlukan biaya minimal Rp 5.000.000 untuk biaya administrasi dan perawatan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> children = [
      {'name': 'Bayi (0-1 tahun) 👶', 'age': 0, 'cost': 10000000, 'desc': 'Bayi yang membutuhkan kasih sayang penuh'},
      {'name': 'Balita (2-4 tahun) 🧒', 'age': 3, 'cost': 7000000, 'desc': 'Anak kecil yang aktif dan ceria'},
      {'name': 'Anak Kecil (5-8 tahun) 🧒', 'age': 6, 'cost': 5000000, 'desc': 'Anak yang sudah bisa mandiri sebagian'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.child_care, color: Colors.orange),
          SizedBox(width: 8),
          Text('Adopsi Anak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (_, i) {
              final c = children[i];
              final bool canAfford = character.money >= (c['cost'] as int);
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('${c['desc']}\nBiaya: Rp ${_fmt(c['cost'] as int)}'),
                  isThreeLine: true,
                  trailing: Icon(canAfford ? Icons.favorite : Icons.lock_outline,
                      color: canAfford ? Colors.orange : Colors.grey),
                  onTap: canAfford ? () {
                    Navigator.pop(ctx);
                    character.money -= (c['cost'] as int);
                    character.happiness = (character.happiness + 20).clamp(0, 100);
                    final r = Random();
                    final names = ['Budi', 'Siti', 'Reza', 'Ayu', 'Dian', 'Fajar', 'Lina', 'Eko'];
                    final childName = names[r.nextInt(names.length)];
                    final childGender = r.nextBool() ? 'Laki-laki' : 'Perempuan';
                    character.children.add({
                      'name': childName,
                      'age': c['age'].toString(),
                      'gender': childGender,
                      'relation': 'Anak Adopsi',
                      'relationship': '80',
                    });
                    final msg = '👨‍👩‍👧 Kamu berhasil mengadopsi $childName ($childGender, ${c['age']} tahun)! (+20% Kebahagiaan, -Rp ${_fmt(c['cost'] as int)})';
                    character.inbox.add(msg);
                    showDialog(
                      context: context,
                      builder: (ctx2) => AlertDialog(
                        title: const Row(children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Adopsi Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
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
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal'))],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
