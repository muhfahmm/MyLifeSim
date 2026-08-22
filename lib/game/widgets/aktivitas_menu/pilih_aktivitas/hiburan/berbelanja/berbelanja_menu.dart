// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/berbelanja_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BerbelanjaMenuHelper {
  static void showBerbelanjaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk berbelanja sendiri.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> toko = [
      {
        'name': 'Mall / Pusat Perbelanjaan 🏬',
        'items': [
          {'name': 'Pakaian Kasual 👕', 'cost': 300000, 'happiness': 8},
          {'name': 'Sepatu Sneakers 👟', 'cost': 600000, 'happiness': 10},
          {'name': 'Tas Punggung 🎒', 'cost': 400000, 'happiness': 7},
          {'name': 'Gadget / Elektronik 📱', 'cost': 3000000, 'happiness': 20},
        ],
      },
      {
        'name': 'Toko Online 🛒',
        'items': [
          {'name': 'Buku Pengetahuan 📚', 'cost': 100000, 'happiness': 5, 'intelligence': 5},
          {'name': 'Alat Olahraga 🏋️', 'cost': 500000, 'happiness': 8, 'health': 5},
          {'name': 'Dekorasi Rumah 🏠', 'cost': 400000, 'happiness': 10},
          {'name': 'Makanan & Minuman Fancy 🍣', 'cost': 200000, 'happiness': 12},
        ],
      },
      {
        'name': 'Pasar Tradisional 🏪',
        'items': [
          {'name': 'Kebutuhan Sehari-hari 🛍️', 'cost': 50000, 'happiness': 3, 'health': 2},
          {'name': 'Sayur & Buah Segar 🥦', 'cost': 30000, 'happiness': 2, 'health': 5},
          {'name': 'Makanan Jajanan 🍜', 'cost': 15000, 'happiness': 8},
        ],
      },
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.shopping_cart, color: Colors.orangeAccent),
          SizedBox(width: 8),
          Text('Berbelanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(children: [
                const Text('💰', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text('Saldo: Rp ${_fmt(character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ]),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: toko.length,
                itemBuilder: (_, ti) {
                  final t = toko[ti];
                  return ExpansionTile(
                    leading: const Icon(Icons.store, color: Colors.orangeAccent),
                    title: Text(t['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    children: (t['items'] as List<Map<String, dynamic>>).map((item) {
                      final bool canAfford = character.money >= (item['cost'] as int);
                      return ListTile(
                        dense: true,
                        title: Text(item['name'] as String, style: TextStyle(
                            fontSize: 12, color: canAfford ? Colors.black87 : Colors.grey)),
                        subtitle: Text('Rp ${_fmt(item['cost'] as int)}',
                            style: TextStyle(fontSize: 11, color: canAfford ? Colors.green : Colors.grey)),
                        trailing: Icon(canAfford ? Icons.add_shopping_cart : Icons.lock_outline,
                            size: 18, color: canAfford ? Colors.orangeAccent : Colors.grey),
                        onTap: canAfford ? () {
                          Navigator.pop(ctx);
                          character.money -= (item['cost'] as int);
                          character.happiness = (character.happiness + (item['happiness'] as int)).clamp(0, 100);
                          if (item.containsKey('intelligence')) {
                            character.intelligence = (character.intelligence + (item['intelligence'] as int)).clamp(0, 100);
                          }
                          if (item.containsKey('health')) {
                            character.health = (character.health + (item['health'] as int)).clamp(0, 100);
                          }
                          final msg = '🛍️ Kamu membeli ${item['name']} seharga Rp ${_fmt(item['cost'] as int)}! (+${item['happiness']}% Kebahagiaan)';
                          character.inbox.add(msg);
                          showDialog(
                            context: context,
                            builder: (ctx2) => AlertDialog(
                              title: const Row(children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Pembelian Berhasil', style: TextStyle(fontWeight: FontWeight.bold)),
                              ]),
                              content: Text(msg),
                              actions: [TextButton(onPressed: () { Navigator.pop(ctx2); onComplete(); }, child: const Text('OK'))],
                            ),
                          );
                        } : null,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup'))],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
