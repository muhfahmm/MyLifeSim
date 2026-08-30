part of '../garasi_motor.dart';

class JualBeliMotorPage extends StatefulWidget {
  final _GarasiMotorPageState state;
  const JualBeliMotorPage({super.key, required this.state});

  @override
  State<JualBeliMotorPage> createState() => _JualBeliMotorPageState();
}

class _JualBeliMotorPageState extends State<JualBeliMotorPage> {
  final List<String> filterTypes = ['Semua', 'Matic', 'Sport', 'Adventure', 'Classic'];

  List<Map<String, dynamic>> _filteredMotor(int index) {
    final all = widget.state._motorTersedia;
    if (index == 0) return all;
    final type = filterTypes[index];
    return all.where((m) => m['tipe'] == type).toList();
  }

  Widget _buildBeliTab(BuildContext context, _GarasiMotorPageState state, int index) {
    final list = _filteredMotor(index);
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.motorcycle, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada motor di kategori ini.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        var motor = list[i];
        bool owned = state.koleksiMotor.any((m) => m['id'] == motor['id']);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.motorcycle, color: Colors.green),
            title: Text('${motor['nama']} (${motor['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${motor['merek']} | ${motor['tipe']} | ${motor['kondisi']}'),
                Text('HP: ${motor['hp']} | Top Speed: ${motor['topSpeed']} km/h'),
                Text('Harga: \$${formatRupiah(motor['harga'])}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            trailing: owned
                ? const Icon(Icons.check_circle, color: Colors.green)
                : ElevatedButton(
                    onPressed: () {
                      state.beliMotor(motor);
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
          title: const Text('Jual & Beli Motor'),
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

  void _showJualDialog(BuildContext context, _GarasiMotorPageState state) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Jual Koleksi'),
          content: state.koleksiMotor.isEmpty
              ? const Text('Tidak ada motor untuk dijual.')
              : SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: state.koleksiMotor.length,
                    itemBuilder: (ctx2, i) {
                      var motor = state.koleksiMotor[i];
                      int hargaJual = (motor['harga'] * 0.8).round();
                      if (motor['kondisi'] == 'Baik') hargaJual = (hargaJual * 1.1).round();
                      if (motor['kondisi'] == 'Sangat Baik') hargaJual = (hargaJual * 1.2).round();
                      return ListTile(
                        title: Text(motor['nama']),
                        subtitle: Text('Harga Jual: \$${formatRupiah(hargaJual)}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            state.jualMotor(i);
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
