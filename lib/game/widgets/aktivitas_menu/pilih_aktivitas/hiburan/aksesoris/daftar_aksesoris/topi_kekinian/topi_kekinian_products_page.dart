// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/daftar_aksesoris/topi_kekinian/topi_kekinian_products_page.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TopiKekinianProductsPage extends StatefulWidget {
  final Character character;
  final String brand;
  final VoidCallback onComplete;

  const TopiKekinianProductsPage({
    super.key,
    required this.character,
    required this.brand,
    required this.onComplete,
  });

  @override
  State<TopiKekinianProductsPage> createState() => _TopiKekinianProductsPageState();
}

class _TopiKekinianProductsPageState extends State<TopiKekinianProductsPage> {
  late final List<Map<String, dynamic>> products;

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  void initState() {
    super.initState();
    if (widget.brand.contains('New Era')) {
      products = [
        {'name': 'New Era 9FORTY 🧢', 'price': 450000, 'happiness': 8, 'desc': 'Topi baseball klasik terpopuler', 'topType': 'hat'},
        {'name': 'New Era 59FIFTY 🧢', 'price': 650000, 'happiness': 10, 'desc': 'Topi datar bersertifikasi street style', 'topType': 'hat'},
      ];
    } else if (widget.brand.contains('Nike')) {
      products = [
        {'name': 'Nike Heritage86 🧢', 'price': 350000, 'happiness': 8, 'desc': 'Topi olahraga katun berdesain simpel', 'topType': 'hat'},
        {'name': 'Nike Dri-FIT Pro 🧢', 'price': 500000, 'happiness': 9, 'desc': 'Topi bersirkulasi udara terbaik untuk lari', 'topType': 'hat'},
      ];
    } else {
      products = [
        {'name': 'Adidas Trefoil Cap 🧢', 'price': 380000, 'happiness': 8, 'desc': 'Topi kasual berlogo trefoil retro klasik', 'topType': 'hat'},
        {'name': 'Adidas Superlite Cap 🏃', 'price': 450000, 'happiness': 7, 'desc': 'Topi lari super ringan anti gerah', 'topType': 'hat'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk ${widget.brand}'),
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
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final p = products[i];
                  final price = p['price'] as int;
                  final bool isOwned = widget.character.ownedAccessories.any((e) => e['name'] == p['name']);
                  final bool canAfford = widget.character.money >= price;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isOwned
                        ? Colors.green.shade50
                        : (canAfford ? Colors.white : Colors.grey.shade50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isOwned ? Colors.green.shade200 : Colors.grey.shade200,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(p['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: isOwned ? Colors.green.shade900 : (canAfford ? Colors.black87 : Colors.grey),
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          isOwned
                              ? '${p['desc']}\nStatus: Sudah Dimiliki'
                              : '${p['desc']}\nHarga: \$${_fmt(price)}',
                          style: TextStyle(
                            color: isOwned
                                ? Colors.green.shade700
                                : (canAfford ? Colors.black54 : Colors.grey),
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(
                        isOwned
                            ? Icons.check_circle
                            : (canAfford ? Icons.shopping_cart : Icons.lock_outline),
                        color: isOwned ? Colors.green : (canAfford ? Colors.pink : Colors.grey),
                      ),
                      onTap: isOwned ? null : (canAfford ? () {
                        setState(() {
                          widget.character.money -= price;
                          widget.character.happiness = (widget.character.happiness + (p['happiness'] as int)).clamp(0, 100);
                          // Hubungkan aksesoris topi ke avatar karakter agar terupdate di 3D View
                          widget.character.avatarTopType = p['topType'] as String;
                          widget.character.ownedAccessories.add({
                            'type': 'topi_kekinian',
                            'name': p['name'],
                            'price': price,
                            'brand': widget.brand,
                            'desc': p['desc'],
                          });
                        });
                        final msg = '🛍️ Kamu membeli ${p['name']}! (-\$${_fmt(price)}, +${p['happiness']}% Kebahagiaan)';
                        widget.character.inbox.add(msg);
                        showDialog(
                          context: context,
                          builder: (ctx2) => AlertDialog(
                            title: const Row(children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Pembelian Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      } : null),
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
