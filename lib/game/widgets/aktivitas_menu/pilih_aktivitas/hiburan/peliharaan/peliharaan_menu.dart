// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/peliharaan_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class PeliharaanMenuHelper {
  static void showPeliharaanMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 10) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 10 tahun untuk memelihara hewan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> hewan = [
      {'name': 'Anjing 🐕', 'cost': 2000000, 'happiness': 20, 'desc': 'Sahabat setia yang selalu ada'},
      {'name': 'Kucing 🐈', 'cost': 1500000, 'happiness': 15, 'desc': 'Hewan mandiri yang menggemaskan'},
      {'name': 'Burung 🦜', 'cost': 500000, 'happiness': 10, 'desc': 'Hewan cantik yang bisa bernyanyi'},
      {'name': 'Ikan 🐠', 'cost': 200000, 'happiness': 8, 'desc': 'Hewan tenang dan menenangkan'},
      {'name': 'Kelinci 🐇', 'cost': 800000, 'happiness': 12, 'desc': 'Hewan lucu dan jinak'},
      {'name': 'Reptil 🦎', 'cost': 3000000, 'happiness': 10, 'desc': 'Hewan unik untuk kolektor'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.pets, color: Colors.green),
          SizedBox(width: 8),
          Text('Adopsi Hewan Peliharaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: hewan.length,
            itemBuilder: (_, i) {
              final h = hewan[i];
              final bool canAfford = character.money >= (h['cost'] as int);
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(h['name'], style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13,
                    color: canAfford ? Colors.black87 : Colors.grey,
                  )),
                  subtitle: Text('${h['desc']}\nHarga: Rp ${_fmt(h['cost'] as int)}'),
                  isThreeLine: true,
                  trailing: Icon(canAfford ? Icons.favorite : Icons.lock_outline,
                      color: canAfford ? Colors.green : Colors.grey),
                  onTap: canAfford ? () {
                    Navigator.pop(ctx);
                    character.money -= (h['cost'] as int);
                    character.happiness = (character.happiness + (h['happiness'] as int)).clamp(0, 100);
                    final names = ['Buddy', 'Luna', 'Max', 'Bella', 'Charlie', 'Mochi'];
                    final petName = names[Random().nextInt(names.length)];
                    final msg = '🐾 Kamu mengadopsi ${h['name']} bernama $petName! (+${h['happiness']}% Kebahagiaan, -Rp ${_fmt(h['cost'] as int)})';
                    character.inbox.add(msg);
                    showDialog(
                      context: context,
                      builder: (ctx2) => AlertDialog(
                        title: const Row(children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Selamat Datang!', style: TextStyle(fontWeight: FontWeight.bold)),
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
