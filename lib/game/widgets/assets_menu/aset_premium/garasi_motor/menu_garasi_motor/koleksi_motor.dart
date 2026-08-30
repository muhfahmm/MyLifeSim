part of '../garasi_motor.dart';

class KoleksiMotorPage extends StatefulWidget {
  final GarasiMotorPageState state;
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.motorcycle, size: 80, color: isDark ? Colors.white54 : Colors.grey),
                  const SizedBox(height: 16),
                  Text('Belum ada motor di koleksi.', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.grey)),
                  Text('Belilah motor di menu Jual & Beli.', style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.grey)),
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
                    leading: Icon(Icons.motorcycle, color: Colors.orange),
                    title: Text('${motor['nama']} (${motor['tahun']})', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${motor['merek']} | ${motor['tipe']} | ${motor['kondisi']}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        Text('HP: ${motor['hp']} | Top Speed: ${motor['topSpeed']} km/h', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        Text('Harga: USD ${formatRupiah(motor['harga'])}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
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
                        PopupMenuItem(value: 'pamer', child: Row(children: [Icon(Icons.storefront, color: isDark ? Colors.white70 : Colors.black87), const SizedBox(width: 8), Text('Pamerkan di Showroom', style: TextStyle(color: isDark ? Colors.white : Colors.black87))])),
                        PopupMenuItem(value: 'jual', child: Row(children: [Icon(Icons.sell, color: Colors.red), const SizedBox(width: 8), Text('Jual Motor', style: TextStyle(color: isDark ? Colors.white : Colors.black87))])),
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
            Text('Tipe Motor:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            DropdownButton<String>(
              value: filterTipe,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              items: ['Semua', 'Matic', 'Sport', 'Adventure', 'Hyperbike', 'Cruiser', 'Classic']
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