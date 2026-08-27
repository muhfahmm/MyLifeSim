// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/daftar_aksesoris/jam_tangan/jam_tangan_page.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'jam_tangan_products_page.dart';

class JamTanganBrandPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const JamTanganBrandPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<JamTanganBrandPage> createState() => _JamTanganBrandPageState();
}

class _JamTanganBrandPageState extends State<JamTanganBrandPage> {
  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> brands = ['Rolex 👑', 'Casio ⌚', 'Seiko 🇯🇵'];
    final owned = widget.character.ownedAccessories.where((e) => e['type'] == 'jam_tangan').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Toko Jam Tangan', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          bottom: const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(text: 'Brand'),
              Tab(text: 'Koleksi'),
            ],
          ),
        ),
        body: Container(
          color: Colors.grey.shade100,
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
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      title: Text(brand, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JamTanganProductsPage(
                              character: widget.character,
                              brand: brand,
                              onComplete: widget.onComplete,
                            ),
                          ),
                        ).then((_) {
                          // Refresh page when back
                          setState(() {});
                        });
                      },
                    ),
                  );
                },
              ),
              // Tab Koleksi
              owned.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('Belum ada koleksi jam tangan.', style: TextStyle(color: Colors.grey)),
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
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('Merek: ${item['brand']}\nHarga: \$${_fmt(price)}', style: const TextStyle(color: Colors.black54)),
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
