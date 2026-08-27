// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/aksesoris_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TokoAksesorisPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class TokoAksesorisPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const TokoAksesorisPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<TokoAksesorisPage> createState() => _TokoAksesorisPageState();
}

class _TokoAksesorisPageState extends State<TokoAksesorisPage> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Jam Tangan ⌚', 'price': 500000, 'happiness': 8, 'desc': 'Jam tangan stylish untuk penampilan'},
    {'name': 'Kacamata Sunglasses 🕶️', 'price': 300000, 'happiness': 6, 'desc': 'Kacamata hitam keren'},
    {'name': 'Tas Branded 👜', 'price': 2000000, 'happiness': 15, 'desc': 'Tas mewah bermerek terkenal'},
    {'name': 'Gelang / Kalung 📿', 'price': 200000, 'happiness': 5, 'desc': 'Perhiasan sederhana namun elegan'},
    {'name': 'Topi Kekinian 🎩', 'price': 150000, 'happiness': 4, 'desc': 'Topi yang sedang tren'},
  ];

  static String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Aksesoris 🛍️', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    'Saldo Anda: \$${_formatMoney(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  final bool canAfford = widget.character.money >= (item['price'] as int);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: canAfford ? Colors.white : Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(item['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: canAfford ? Colors.black87 : Colors.grey,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${item['desc']}\nHarga: \$${_formatMoney(item['price'] as int)}',
                          style: TextStyle(color: canAfford ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.shopping_cart : Icons.lock_outline,
                          color: canAfford ? Colors.pink : Colors.grey),
                      onTap: canAfford ? () {
                        setState(() {
                          widget.character.money -= (item['price'] as int);
                          widget.character.happiness = (widget.character.happiness + (item['happiness'] as int)).clamp(0, 100);
                        });
                        final msg = '🛍️ Kamu membeli ${item['name']}! (-\$${_formatMoney(item['price'] as int)}, +${item['happiness']}% Kebahagiaan)';
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
