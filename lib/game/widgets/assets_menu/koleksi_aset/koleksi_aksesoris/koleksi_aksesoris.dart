// lib/game/widgets/assets_menu/koleksi_aset/koleksi_aksesoris/koleksi_aksesoris.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class KoleksiAksorisPage extends StatefulWidget {
  final Character character;

  const KoleksiAksorisPage({super.key, required this.character});

  @override
  State<KoleksiAksorisPage> createState() => _KoleksiAksorisPageState();
}

class _KoleksiAksorisPageState extends State<KoleksiAksorisPage> {
  final List<Map<String, String>> categories = [
    {'type': 'jam_tangan', 'title': 'Jam Tangan ⌚'},
    {'type': 'kacamata_sunglasses', 'title': 'Kacamata Sunglasses 🕶️'},
    {'type': 'tas_branded', 'title': 'Tas Branded 👜'},
    {'type': 'gelang_kalung', 'title': 'Gelang / Kalung 📿'},
    {'type': 'topi_kekinian', 'title': 'Topi 🎩'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    final allAccessories = widget.character.ownedAccessories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Koleksi Aksesoris 💍', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.purple.shade700,
          foregroundColor: Colors.white,
          elevation: 1,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: categories.map((cat) => Tab(text: cat['title'])).toList(),
          ),
        ),
        body: Container(
          color: bgColor,
          child: TabBarView(
            children: categories.map((cat) {
              final type = cat['type']!;
              final items = allAccessories.where((e) => e['type'] == type).toList();

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: isDark ? Colors.white38 : Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada koleksi ${cat['title']?.split(' ')[0]}.',
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
                      leading: const Icon(Icons.style, color: Colors.purpleAccent),
                      title: Text(
                        item['name'] ?? 'Aksesoris',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                      ),
                      subtitle: Text(
                        item['brand'] != null ? 'Brand: ${item['brand']}' : 'Koleksi Pribadi',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      trailing: Text(
                        CurrencySettings.format(item['price'] ?? item['cost'] ?? 0),
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.greenAccent : Colors.green),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
