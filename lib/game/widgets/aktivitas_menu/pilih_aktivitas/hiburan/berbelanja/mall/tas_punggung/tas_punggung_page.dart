// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/tas_punggung/tas_punggung_page.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'database_brand.dart';

class TasPunggungPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const TasPunggungPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<TasPunggungPage> createState() => _TasPunggungPageState();
}

class _TasPunggungPageState extends State<TasPunggungPage> {
  static String _fmt(int amount) => CurrencySettings.format(amount);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    final brands = TasPunggungDatabase.brands;
    final owned = widget.character.ownedShopping.where((e) => e['type'] == 'tas_punggung').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Toko Tas Punggung 🎒', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          elevation: 1,
          bottom: const TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: 'Brand'),
              Tab(text: 'Koleksi'),
            ],
          ),
        ),
        body: Container(
          color: bgColor,
          child: TabBarView(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: brands.length,
                itemBuilder: (context, i) {
                  final b = brands[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.storefront, color: Colors.teal),
                      title: Text(b, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _TasPunggungProductsPage(
                              character: widget.character,
                              brandName: b,
                              products: TasPunggungDatabase.products[b] ?? [],
                              onComplete: widget.onComplete,
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  );
                },
              ),
              owned.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: isDark ? Colors.white38 : Colors.grey),
                          const SizedBox(height: 12),
                          Text('Belum ada koleksi tas punggung.', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: owned.length,
                      itemBuilder: (context, i) {
                        final item = owned[i];
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: cardBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: borderColor),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle, color: Colors.green),
                            title: Text(item['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            subtitle: Text('Brand: ${item['brand'] ?? '-'}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                            trailing: Text(_fmt(item['cost'] ?? 0), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TasPunggungProductsPage extends StatefulWidget {
  final Character character;
  final String brandName;
  final List<Map<String, dynamic>> products;
  final VoidCallback onComplete;

  const _TasPunggungProductsPage({
    required this.character,
    required this.brandName,
    required this.products,
    required this.onComplete,
  });

  @override
  State<_TasPunggungProductsPage> createState() => _TasPunggungProductsPageState();
}

class _TasPunggungProductsPageState extends State<_TasPunggungProductsPage> {
  static String _fmt(int amount) => CurrencySettings.format(amount);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: bgColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.products.length,
          itemBuilder: (context, i) {
            final p = widget.products[i];
            final int cost = p['cost'];
            final bool isOwned = widget.character.ownedShopping.any((e) => e['name'] == p['name']);
            final bool canAfford = widget.character.money >= cost;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: isOwned
                  ? (isDark ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50)
                  : cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isOwned ? Colors.green : borderColor),
              ),
              child: ListTile(
                title: Text(p['name'], style: TextStyle(fontWeight: FontWeight.bold, color: isOwned ? Colors.green : textColor)),
                subtitle: Text('${p['desc']}\nHarga: ${_fmt(cost)}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                isThreeLine: true,
                trailing: Icon(
                  isOwned ? Icons.check_circle : (canAfford ? Icons.shopping_cart : Icons.lock_outline),
                  color: isOwned ? Colors.green : (canAfford ? Colors.teal : Colors.grey),
                ),
                onTap: isOwned
                    ? null
                    : (canAfford
                        ? () {
                            setState(() {
                              widget.character.money -= cost;
                              widget.character.happiness = (widget.character.happiness + (p['happiness'] as int)).clamp(0, 100);
                              widget.character.ownedShopping.add({
                                'type': 'tas_punggung',
                                'name': p['name'],
                                'brand': widget.brandName,
                                'cost': cost,
                                'category': 'Mall / Pusat Perbelanjaan 🏬',
                                'boughtAge': widget.character.age,
                              });
                            });
                            final msg = '🛍️ Kamu membeli ${p['name']} dari ${widget.brandName} seharga ${_fmt(cost)}!';
                            widget.character.inbox.add(msg);
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                titlePadding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                                contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Row(children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Pembelian Berhasil',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),
                                content: Text(msg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      widget.onComplete();
                                    },
                                    child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  )
                                ],
                              ),
                            );
                          }
                        : null),
              ),
            );
          },
        ),
      ),
    );
  }
}
