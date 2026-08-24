// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/filantropi/filantropi.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN FILANTROPI
// ============================================================
class FilantropiPage extends StatelessWidget {
  final _KemewahanPageState state;
  const FilantropiPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    List<int> nominalList = [100000, 500000, 1000000, 5000000, 10000000];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filantropi'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Donasi Terkumpul', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('Rp ${formatRupiah(state.donasi.fold<int>(0, (sum, d) => sum + (d['jumlah'] as int)))}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    const SizedBox(height: 8),
                    Text('Jumlah Donasi: ${state.donasi.length} kali'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pilih nominal donasi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...nominalList.map((nominal) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text('Rp ${formatRupiah(nominal)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('+${10 + (nominal ~/ 1000000) * 2} Happiness'),
                trailing: ElevatedButton(
                  onPressed: () {
                    state.lakukanDonasi(nominal);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text('Donasi', style: TextStyle(color: Colors.white)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}