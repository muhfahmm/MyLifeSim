// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/daftar_aksesoris/topi_kekinian/topi_kekinian_page.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'topi_kekinian_products_page.dart';

class TopiKekinianBrandPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const TopiKekinianBrandPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<TopiKekinianBrandPage> createState() => _TopiKekinianBrandPageState();
}

class _TopiKekinianBrandPageState extends State<TopiKekinianBrandPage> {
  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color containerBg = isDark ? Colors.grey.shade900 : Colors.white;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;

    final List<String> brands = ['New Era 🧢', 'Nike ✔️', 'Adidas 🏁'];
    final owned = widget.character.ownedAccessories.where((e) => e['type'] == 'topi_kekinian').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Toko Topi Kekinian', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: containerBg,
          foregroundColor: textColor,
          elevation: 0.5,
          bottom: TabBar(
            labelColor: isDark ? Colors.pinkAccent : Colors.pink,
            unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
            indicatorColor: isDark ? Colors.pinkAccent : Colors.pink,
            tabs: const [
              Tab(text: 'Brand'),
              Tab(text: 'Koleksi'),
            ],
          ),
        ),
        body: Container(
          color: bgColor,
          child: TabBarView(
            children: [
              // Tab Brand
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: brands.length,
                itemBuilder: (context, i) {
                  final brand = brands[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: ListTile(
                      title: Text(
                        brand,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopiKekinianProductsPage(
                              character: widget.character,
                              brand: brand,
                              onComplete: widget.onComplete,
                            ),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  );
                },
              ),
              // Tab Koleksi
              owned.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada koleksi topi.',
                            style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: owned.length,
                      itemBuilder: (context, i) {
                        final item = owned[i];
                        final price = item['price'] as int;
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: cardBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: borderColor),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Merek: ${item['brand']}\nHarga: ${_fmt(price)}',
                                style: TextStyle(color: subtextColor),
                              ),
                            ),
                            trailing: const Icon(Icons.check_circle, color: Colors.green),
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
