part of '../garasi_mobil.dart';

class KoleksiMobilPage extends StatefulWidget {
  final GarasiMobilPageState state;
  const KoleksiMobilPage({super.key, required this.state});

  @override
  State<KoleksiMobilPage> createState() => _KoleksiMobilPageState();
}

class _KoleksiMobilPageState extends State<KoleksiMobilPage> {
  String filterTipe = 'Semua';
  String sortBy = 'nama';

  List<Map<String, dynamic>> get filteredMobil {
    List<Map<String, dynamic>> list = List.from(widget.state.koleksiMobil);
    if (filterTipe != 'Semua') {
      list = list.where((m) => m['tipe'] == filterTipe).toList();
    }
    if (sortBy == 'nama') {
      list.sort((a, b) => a['nama'].compareTo(b['nama']));
    } else if (sortBy == 'harga') {
      list.sort((a, b) => b['harga'] - a['harga']);
    } else if (sortBy == 'tahun') {
      list.sort((a, b) => b['tahun'] - a['tahun']);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Mobil'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: filteredMobil.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car, size: 80, color: isDark ? Colors.white54 : Colors.grey),
                  const SizedBox(height: 16),
                  Text('Belum ada mobil di koleksi.', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.grey)),
                  Text('Belilah mobil di menu Jual & Beli.', style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMobil.length,
              itemBuilder: (ctx, i) {
                var mobil = filteredMobil[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.directions_car, color: Colors.red),
                    title: Text('${mobil['nama']} (${mobil['tahun']})', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${mobil['merek']} | ${mobil['tipe']} | ${mobil['kondisi']}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        Text('HP: ${mobil['hp']} | Top Speed: ${mobil['topSpeed']} km/h', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        Text('Harga: USD ${formatRupiah(mobil['harga'])}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'jual') {
                          int index = state.koleksiMobil.indexOf(mobil);
                          if (index != -1) state.jualMobil(index);
                          setState(() {});
                        } else if (value == 'pamer') {
                          state.pamerkanMobil(mobil['id']);
                          setState(() {});
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'pamer', child: Row(children: [Icon(Icons.storefront, color: isDark ? Colors.white70 : Colors.black87), const SizedBox(width: 8), Text('Pamerkan di Showroom', style: TextStyle(color: isDark ? Colors.white : Colors.black87))])),
                        PopupMenuItem(value: 'jual', child: Row(children: [Icon(Icons.sell, color: Colors.red), const SizedBox(width: 8), Text('Jual Mobil', style: TextStyle(color: isDark ? Colors.white : Colors.black87))])),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Filter & Urutkan', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tipe Mobil:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            DropdownButton<String>(
              value: filterTipe,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              items: ['Semua', 'SUV', 'Sedan', 'Sport', 'Hypercar', 'Classic']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(color: isDark ? Colors.white : Colors.black87))))
                  .toList(),
              onChanged: (val) => setState(() => filterTipe = val!),
            ),
            const SizedBox(height: 16),
            Text('Urutkan:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            DropdownButton<String>(
              value: sortBy,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              items: [
                DropdownMenuItem(value: 'nama', child: Text('Nama (A-Z)', style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
                DropdownMenuItem(value: 'harga', child: Text('Harga (Tertinggi)', style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
                DropdownMenuItem(value: 'tahun', child: Text('Tahun (Terbaru)', style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
              ],
              onChanged: (val) => setState(() => sortBy = val!),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }
}