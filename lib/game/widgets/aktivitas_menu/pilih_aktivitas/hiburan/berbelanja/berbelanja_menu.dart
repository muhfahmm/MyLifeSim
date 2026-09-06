// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/berbelanja_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BerbelanjaPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class BerbelanjaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const BerbelanjaPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<BerbelanjaPage> createState() => _BerbelanjaPageState();
}

class _BerbelanjaPageState extends State<BerbelanjaPage> {
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

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berbelanja 🛒', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: \$${_fmt(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: toko.length,
                itemBuilder: (_, ti) {
                  final t = toko[ti];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ExpansionTile(
                      leading: const Icon(Icons.store, color: Colors.orangeAccent),
                      title: Text(t['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      children: (t['items'] as List<Map<String, dynamic>>).map((item) {
                        final bool canAfford = widget.character.money >= (item['cost'] as int);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          title: Text(item['name'] as String, style: TextStyle(
                              fontSize: 13, color: canAfford ? Colors.black87 : Colors.grey)),
                          subtitle: Text('\$${_fmt(item['cost'] as int)}',
                              style: TextStyle(fontSize: 12, color: canAfford ? Colors.green : Colors.grey)),
                          trailing: Icon(canAfford ? Icons.add_shopping_cart : Icons.lock_outline,
                              size: 18, color: canAfford ? Colors.orangeAccent : Colors.grey),
                          onTap: canAfford ? () {
                            setState(() {
                              widget.character.money -= (item['cost'] as int);
                              widget.character.happiness = (widget.character.happiness + (item['happiness'] as int)).clamp(0, 100);
                              if (item.containsKey('intelligence')) {
                                widget.character.intelligence = (widget.character.intelligence + (item['intelligence'] as int)).clamp(0, 100);
                              }
                              if (item.containsKey('health')) {
                                widget.character.health = (widget.character.health + (item['health'] as int)).clamp(0, 100);
                              }
                            });
                            final msg = '🛍️ Kamu membeli ${item['name']} seharga \$${_fmt(item['cost'] as int)}! (+${item['happiness']}% Kebahagiaan)';
                            widget.character.inbox.add(msg);
                            showDialog(
                              context: context,
                              builder: (ctx2) => AlertDialog(
                                title: const Row(children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Pembelian Berhasil', style: TextStyle(fontWeight: FontWeight.bold)),
                                ]),
                                content: Text(msg),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx2);
                                      widget.onComplete();
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              ),
                            );
                          } : null,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
