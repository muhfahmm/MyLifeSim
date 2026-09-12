// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/daftar_aksesoris/gelang_kalung/gelang_kalung_products_page.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class GelangKalungProductsPage extends StatefulWidget {
  final Character character;
  final String brand;
  final VoidCallback onComplete;

  const GelangKalungProductsPage({
    super.key,
    required this.character,
    required this.brand,
    required this.onComplete,
  });

  @override
  State<GelangKalungProductsPage> createState() => _GelangKalungProductsPageState();
}

class _GelangKalungProductsPageState extends State<GelangKalungProductsPage> {
  late final List<Map<String, dynamic>> products;

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  @override
  void initState() {
    super.initState();
    if (widget.brand.contains('Tiffany & Co.')) {
      products = [
        {'name': 'Tiffany T Bracelet 💫', 'price': 15000000, 'happiness': 15, 'desc': 'Desain gelang minimalis dengan inisial T'},
        {'name': 'Tiffany Lock Pendant 📿', 'price': 18000000, 'happiness': 18, 'desc': 'Kalung gembok dengan nilai keindahan tinggi'},
      ];
    } else if (widget.brand.contains('Cartier')) {
      products = [
        {'name': 'Cartier Love Bracelet 💍', 'price': 45000000, 'happiness': 25, 'desc': 'Gelang legendaris lambang komitmen abadi'},
        {'name': 'Cartier Juste un Clou 📿', 'price': 38000000, 'happiness': 24, 'desc': 'Desain kalung/gelang berbentuk paku mewah'},
      ];
    } else {
      products = [
        {'name': 'Pandora Moments Bracelet ✨', 'price': 3500000, 'happiness': 10, 'desc': 'Gelang charm yang dapat dipersonalisasi'},
        {'name': 'Pandora Signature Pendant 📿', 'price': 2800000, 'happiness': 12, 'desc': 'Kalung perak dengan logo khas pandora'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color containerBg = isDark ? Colors.grey.shade900 : Colors.white;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color disabledCardBg = isDark ? Colors.grey.shade700 : Colors.grey.shade50;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color disabledTextColor = isDark ? Colors.white54 : Colors.grey;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;
    final Color disabledSubtextColor = isDark ? Colors.white38 : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Text('Produk ${widget.brand}'),
        backgroundColor: containerBg,
        foregroundColor: textColor,
        elevation: 0.5,
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: containerBg,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: ${_fmt(widget.character.money)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
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

                  final Color currentCardBg = isOwned
                      ? (isDark ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50)
                      : (canAfford ? cardBg : disabledCardBg);

                  final Color currentBorderColor = isOwned
                      ? (isDark ? Colors.green.shade700 : Colors.green.shade200)
                      : borderColor;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: currentCardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: currentBorderColor),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        p['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isOwned
                              ? (isDark ? Colors.greenAccent : Colors.green.shade900)
                              : (canAfford ? textColor : disabledTextColor),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          isOwned
                              ? '${p['desc']}\nStatus: Sudah Dimiliki'
                              : '${p['desc']}\nHarga: ${_fmt(price)}',
                          style: TextStyle(
                            color: isOwned
                                ? (isDark ? Colors.greenAccent.shade100 : Colors.green.shade700)
                                : (canAfford ? subtextColor : disabledSubtextColor),
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(
                        isOwned
                            ? Icons.check_circle
                            : (canAfford ? Icons.shopping_cart : Icons.lock_outline),
                        color: isOwned
                            ? Colors.green
                            : (canAfford ? Colors.pinkAccent : (isDark ? Colors.white54 : Colors.grey)),
                      ),
                      onTap: isOwned ? null : (canAfford ? () {
                        setState(() {
                          widget.character.money -= price;
                          widget.character.happiness = (widget.character.happiness + (p['happiness'] as int)).clamp(0, 100);
                          widget.character.ownedAccessories.add({
                            'type': 'gelang_kalung',
                            'name': p['name'],
                            'price': price,
                            'brand': widget.brand,
                            'desc': p['desc'],
                          });
                        });
                        final msg = '🛍️ Kamu membeli ${p['name']}! (-${_fmt(price)}, +${p['happiness']}% Kebahagiaan)';
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
