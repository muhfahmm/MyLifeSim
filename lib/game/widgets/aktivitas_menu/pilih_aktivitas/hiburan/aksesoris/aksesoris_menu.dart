// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/aksesoris_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class AksesorisMenuHelper {
  static void showAksesorisMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk membeli aksesoris.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> items = [
      {'name': 'Jam Tangan ⌚', 'price': 500000, 'happiness': 8, 'desc': 'Jam tangan stylish untuk penampilan'},
      {'name': 'Kacamata Sunglasses 🕶️', 'price': 300000, 'happiness': 6, 'desc': 'Kacamata hitam keren'},
      {'name': 'Tas Branded 👜', 'price': 2000000, 'happiness': 15, 'desc': 'Tas mewah bermerek terkenal'},
      {'name': 'Gelang / Kalung 📿', 'price': 200000, 'happiness': 5, 'desc': 'Perhiasan sederhana namun elegan'},
      {'name': 'Topi Kekinian 🎩', 'price': 150000, 'happiness': 4, 'desc': 'Topi yang sedang tren'},
    ];

    DialogHelper.show(
      context: context,
      title: 'Toko Aksesoris 🛍️',
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final bool canAfford = character.money >= (item['price'] as int);
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: canAfford ? Colors.grey.shade50 : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(item['name'], style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13,
                color: canAfford ? Colors.black87 : Colors.grey,
              )),
              subtitle: Text('${item['desc']}\nHarga: \$${_formatMoney(item['price'] as int)}'),
              isThreeLine: true,
              trailing: Icon(canAfford ? Icons.shopping_cart : Icons.lock_outline,
                  color: canAfford ? Colors.pink : Colors.grey),
              onTap: canAfford ? () {
                Navigator.pop(context);
                character.money -= (item['price'] as int);
                character.happiness = (character.happiness + (item['happiness'] as int)).clamp(0, 100);
                final msg = '🛍️ Kamu membeli ${item['name']}! (-\$${_formatMoney(item['price'] as int)}, +${item['happiness']}% Kebahagiaan)';
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

  static String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
