part of '../garasi_mobil.dart';

class KoleksiMobilPage extends StatefulWidget {
  final _GarasiMobilPageState state;
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
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Belum ada mobil di koleksi.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('Belilah mobil di menu Jual & Beli.', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                    leading: Icon(mobil['tipe'] == 'SUV' ? Icons.directions_car : Icons.directions_car, color: Colors.red),
                    title: Text('${mobil['nama']} (${mobil['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${mobil['merek']} | ${mobil['tipe']} | ${mobil['kondisi']}'),
                        Text('HP: ${mobil['hp']} | Top Speed: ${mobil['topSpeed']} km/h'),
                        Text('Harga: USD ${formatRupiah(mobil['harga'])}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
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
                        const PopupMenuItem(value: 'pamer', child: Row(children: [Icon(Icons.storefront), SizedBox(width: 8), Text('Pamerkan di Showroom')])),
                        const PopupMenuItem(value: 'jual', child: Row(children: [Icon(Icons.sell, color: Colors.red), SizedBox(width: 8), Text('Jual Mobil')])),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter & Urutkan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tipe Mobil:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: filterTipe,
              items: ['Semua', 'SUV', 'Sedan', 'Sport', 'Hypercar', 'Classic']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => filterTipe = val!),
            ),
            const SizedBox(height: 16),
            const Text('Urutkan:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: sortBy,
              items: const [
                DropdownMenuItem(value: 'nama', child: Text('Nama (A-Z)')),
                DropdownMenuItem(value: 'harga', child: Text('Harga (Tertinggi)')),
                DropdownMenuItem(value: 'tahun', child: Text('Tahun (Terbaru)')),
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