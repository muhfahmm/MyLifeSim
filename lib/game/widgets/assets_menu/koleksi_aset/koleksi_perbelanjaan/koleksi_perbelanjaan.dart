// lib/game/widgets/assets_menu/koleksi_aset/koleksi_perbelanjaan/koleksi_perbelanjaan.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class KoleksiPerbelanjaanPage extends StatefulWidget {
  final Character character;

  const KoleksiPerbelanjaanPage({super.key, required this.character});

  @override
  State<KoleksiPerbelanjaanPage> createState() => _KoleksiPerbelanjaanPageState();
}

class _KoleksiPerbelanjaanPageState extends State<KoleksiPerbelanjaanPage> {
  final List<Map<String, String>> categories = [
    {'name': 'Pakaian Kasual 👕', 'type': 'pakaian_kasual'},
    {'name': 'Sepatu Sneakers 👟', 'type': 'sepatu_sneakers'},
    {'name': 'Tas Punggung 🎒', 'type': 'tas_punggung'},
    {'name': 'Gadget / Elektronik 📱', 'type': 'gadget_barang_elektronik'},
    {'name': 'Buku Pengetahuan 📚', 'type': 'buku_pengetahuan'},
    {'name': 'Alat Olahraga 🏋️', 'type': 'alat_olahraga'},
    {'name': 'Dekorasi Rumah 🏠', 'type': 'dekorasi_rumah'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    final allShopping = widget.character.ownedShopping;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Koleksi Hasil Belanja 🛒', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          elevation: 1,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: 'Mall / Pusat Perbelanjaan 🏬'),
              Tab(text: 'Toko Online 🛒'),
            ],
          ),
        ),
        body: Container(
          color: bgColor,
          child: TabBarView(
            children: [
              // Mall Section
              _buildSection(
                context,
                isDark,
                cardBg,
                textColor,
                borderColor,
                allShopping.where((e) => e['category'] == 'Mall / Pusat Perbelanjaan 🏬').toList(),
                'Belum ada barang belanjaan dari Mall.',
              ),
              // Toko Online Section
              _buildSection(
                context,
                isDark,
                cardBg,
                textColor,
                borderColor,
                allShopping.where((e) => e['category'] == 'Toko Online 🛒').toList(),
                'Belum ada barang belanjaan dari Toko Online.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    bool isDark,
    Color cardBg,
    Color textColor,
    Color borderColor,
    List<Map<String, dynamic>> items,
    String emptyMessage,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: isDark ? Colors.white38 : Colors.grey),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          color: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor),
          ),
          child: ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.tealAccent),
            title: Text(
              item['name'] ?? 'Barang',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            subtitle: Text(
              'Dibeli pada usia ${item['boughtAge'] ?? '?'} tahun',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
            ),
            trailing: Text(
              CurrencySettings.format(item['cost'] ?? 0),
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.greenAccent : Colors.green),
            ),
          ),
        );
      },
    );
  }
}
