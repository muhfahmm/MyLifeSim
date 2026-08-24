part of '../garasi_mobil.dart';

class JualBeliMobilPage extends StatefulWidget {
  final _GarasiMobilPageState state;
  const JualBeliMobilPage({super.key, required this.state});

  @override
  State<JualBeliMobilPage> createState() => _JualBeliMobilPageState();
}

class _JualBeliMobilPageState extends State<JualBeliMobilPage> {
  int tabIndex = 0; // 0 = Beli, 1 = Jual

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jual & Beli Mobil'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Beli Mobil'),
              Tab(text: 'Jual Koleksi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBeliTab(context, state),
            _buildJualTab(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildBeliTab(BuildContext context, _GarasiMobilPageState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state._mobilTersedia.length,
      itemBuilder: (ctx, i) {
        var mobil = state._mobilTersedia[i];
        bool owned = state.koleksiMobil.any((m) => m['id'] == mobil['id']);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(mobil['tipe'] == 'SUV' ? Icons.directions_car : Icons.directions_car, color: Colors.green),
            title: Text('${mobil['nama']} (${mobil['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${mobil['merek']} | ${mobil['tipe']} | ${mobil['kondisi']}'),
                Text('HP: ${mobil['hp']} | Top Speed: ${mobil['topSpeed']} km/h'),
                Text('Harga: USD ${formatRupiah(mobil['harga'])}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            trailing: owned
                ? const Icon(Icons.check_circle, color: Colors.green)
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

  Widget _buildJualTab(BuildContext context, _GarasiMobilPageState state) {
    if (state.koleksiMobil.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada mobil untuk dijual.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.koleksiMobil.length,
      itemBuilder: (ctx, i) {
        var mobil = state.koleksiMobil[i];
        int hargaJual = (mobil['harga'] * 0.8).round();
        if (mobil['kondisi'] == 'Baik') hargaJual = (hargaJual * 1.1).round();
        if (mobil['kondisi'] == 'Sangat Baik') hargaJual = (hargaJual * 1.2).round();
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.directions_car, color: Colors.orange),
            title: Text('${mobil['nama']} (${mobil['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${mobil['merek']} | ${mobil['kondisi']}'),
                Text('Harga Jual: USD ${formatRupiah(hargaJual)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                state.jualMobil(i);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Jual'),
            ),
          ),
        );
      },
    );
  }
}