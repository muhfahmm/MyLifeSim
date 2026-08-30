part of '../garasi_motor.dart';

class KoleksiMotorPage extends StatefulWidget {
  final _GarasiMotorPageState state;
  const KoleksiMotorPage({super.key, required this.state});

  @override
  State<KoleksiMotorPage> createState() => _KoleksiMotorPageState();
}

class _KoleksiMotorPageState extends State<KoleksiMotorPage> {
  String filterTipe = 'Semua';
  String sortBy = 'nama';

  List<Map<String, dynamic>> get filteredMotor {
    List<Map<String, dynamic>> list = List.from(widget.state.koleksiMotor);
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
        title: const Text('Koleksi Motor'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: filteredMotor.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.motorcycle, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Belum ada motor di koleksi.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('Belilah motor di menu Jual & Beli.', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMotor.length,
              itemBuilder: (ctx, i) {
                var motor = filteredMotor[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.motorcycle, color: Colors.orange),
                    title: Text('${motor['nama']} (${motor['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${motor['merek']} | ${motor['tipe']} | ${motor['kondisi']}'),
                        Text('HP: ${motor['hp']} | Top Speed: ${motor['topSpeed']} km/h'),
                        Text('Harga: USD ${formatRupiah(motor['harga'])}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'jual') {
                          int index = state.koleksiMotor.indexOf(motor);
                          if (index != -1) state.jualMotor(index);
                          setState(() {});
                        } else if (value == 'pamer') {
                          state.pamerkanMotor(motor['id']);
                          setState(() {});
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'pamer', child: Row(children: [Icon(Icons.storefront), SizedBox(width: 8), Text('Pamerkan di Showroom')])),
                        const PopupMenuItem(value: 'jual', child: Row(children: [Icon(Icons.sell, color: Colors.red), SizedBox(width: 8), Text('Jual Motor')])),
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
            const Text('Tipe Motor:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: filterTipe,
              items: ['Semua', 'Matic', 'Sport', 'Adventure', 'Hyperbike', 'Cruiser', 'Classic']
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
