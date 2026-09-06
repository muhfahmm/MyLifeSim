// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/daftar_aksesoris/jam_tangan/jam_tangan_products_page.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class JamTanganProductsPage extends StatefulWidget {
  final Character character;
  final String brand;
  final VoidCallback onComplete;

  const JamTanganProductsPage({
    super.key,
    required this.character,
    required this.brand,
    required this.onComplete,
  });

  @override
  State<JamTanganProductsPage> createState() => _JamTanganProductsPageState();
}

class _JamTanganProductsPageState extends State<JamTanganProductsPage> {
  late final List<Map<String, dynamic>> products;

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  void initState() {
    super.initState();
    if (widget.brand.contains('Rolex')) {
      products = [
        {'name': 'Rolex Submariner 🌊', 'price': 150000000, 'happiness': 20, 'desc': 'Jam tangan selam legendaris'},
        {'name': 'Rolex Daytona 🏎️', 'price': 300000000, 'happiness': 25, 'desc': 'Krono ikonik bagi pecinta balap'},
      ];
    } else if (widget.brand.contains('Casio')) {
      products = [
        {'name': 'Casio G-Shock 💪', 'price': 2500000, 'happiness': 10, 'desc': 'Jam tangan tangguh anti benturan'},
        {'name': 'Casio Edifice 🏎️', 'price': 4500000, 'happiness': 12, 'desc': 'Desain sporty yang elegan'},
      ];
    } else {
      products = [
        {'name': 'Seiko 5 Sports 🏃', 'price': 3500000, 'happiness': 12, 'desc': 'Jam tangan mekanik harian tangguh'},
        {'name': 'Seiko Prospex 🏔️', 'price': 9000000, 'happiness': 15, 'desc': 'Seri spesifikasi profesional seiko'},
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
                          widget.character.ownedAccessories.add({
                            'type': 'jam_tangan',
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
