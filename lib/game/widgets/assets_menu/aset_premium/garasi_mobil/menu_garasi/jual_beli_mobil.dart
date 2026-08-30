part of '../garasi_mobil.dart';

class JualBeliMobilPage extends StatefulWidget {
  final GarasiMobilPageState state;
  const JualBeliMobilPage({super.key, required this.state});

  @override
  State<JualBeliMobilPage> createState() => _JualBeliMobilPageState();
}

class _JualBeliMobilPageState extends State<JualBeliMobilPage> {
  final List<String> filterTypes = ['Semua', 'SUV', 'Sedan', 'Sport', 'Hypercar'];

  List<Map<String, dynamic>> _filteredMobil(int index) {
    final all = widget.state._mobilTersedia;
    if (index == 0) return all;
    final type = filterTypes[index];
    return all.where((m) => m['tipe'] == type).toList();
  }

  Widget _buildBeliTab(BuildContext context, GarasiMobilPageState state, int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final list = _filteredMobil(index);
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 80, color: isDark ? Colors.white54 : Colors.grey),
            const SizedBox(height: 16),
            Text('Tidak ada mobil di kategori ini.', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        var mobil = list[i];
        bool owned = state.koleksiMobil.any((m) => m['id'] == mobil['id']);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.directions_car, color: Colors.green),
            title: Text('${mobil['nama']} (${mobil['tahun']})', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${mobil['merek']} | ${mobil['tipe']} | ${mobil['kondisi']}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                Text('HP: ${mobil['hp']} | Top Speed: ${mobil['topSpeed']} km/h', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                Text('Harga: \$${formatRupiah(mobil['harga'])}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            trailing: owned
                ? Icon(Icons.check_circle, color: Colors.green)
                : ElevatedButton(
                    onPressed: () {
                      state.beliMobil(mobil);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Beli'),
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return DefaultTabController(
      length: filterTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jual & Beli Mobil'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.sell),
              onPressed: () => _showJualDialog(context, state),
              tooltip: 'Jual Koleksi',
            ),
          ],
          bottom: TabBar(
            tabs: filterTypes.map((label) => Tab(text: label)).toList(),
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: List.generate(
            filterTypes.length,
            (index) => _buildBeliTab(context, state, index),
          ),
        ),
      ),
    );
  }

  void _showJualDialog(BuildContext context, GarasiMobilPageState state) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Jual Koleksi', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          content: state.koleksiMobil.isEmpty
              ? Text('Tidak ada mobil untuk dijual.', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54))
              : SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: state.koleksiMobil.length,
                    itemBuilder: (ctx2, i) {
                      var mobil = state.koleksiMobil[i];
                      int hargaJual = (mobil['harga'] * 0.8).round();
                      if (mobil['kondisi'] == 'Baik') hargaJual = (hargaJual * 1.1).round();
                      if (mobil['kondisi'] == 'Sangat Baik') hargaJual = (hargaJual * 1.2).round();
                      return ListTile(
                        title: Text(mobil['nama'], style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                        subtitle: Text('Harga Jual: \$${formatRupiah(hargaJual)}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        trailing: ElevatedButton(
                          onPressed: () {
                            state.jualMobil(i);
                            Navigator.pop(ctx);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) setState(() {});
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          child: const Text('Jual'),
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() {});
                });
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}