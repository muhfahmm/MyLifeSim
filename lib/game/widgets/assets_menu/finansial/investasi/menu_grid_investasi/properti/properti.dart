// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/properti/properti.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN PROPERTI
// ============================================================
class PropertiPage extends StatefulWidget {
  final _InvestasiPageState state;
  const PropertiPage({super.key, required this.state});

  @override
  State<PropertiPage> createState() => _PropertiPageState();
}

class _PropertiPageState extends State<PropertiPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properti'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildCashHeader(state, assetType: 'properti'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.properti.length + 1,
              itemBuilder: (ctx, i) {
                if (i == state.properti.length) {
                  return ElevatedButton.icon(
                    onPressed: () => _showBeliPropertiDialog(context, state),
                    icon: const Icon(Icons.add_home),
                    label: const Text('Beli Properti Baru'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  );
                }
                var p = state.properti[i];
                int hargaJual = ((p['hargaBeli'] as num).toDouble() * (1 + (p['kenaikan'] as num).toDouble() / 100)).round();
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(p['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga beli: \$${formatRupiah(p['hargaBeli'] as num)}'),
                        Text('Sewa: \$${formatRupiah(p['hargaSewa'] as num)}/bulan'),
                        Text('Kenaikan: ${(p['kenaikan'] as num).toStringAsFixed(1)}%'),
                        Text('Nilai jual: \$${formatRupiah(hargaJual)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.sell, color: Colors.red),
                      onPressed: () {
                        state.jualProperti(i);
                        setState(() {});
                      },
                      tooltip: 'Jual properti',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBeliPropertiDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController namaCtrl = TextEditingController();
    TextEditingController hargaCtrl = TextEditingController();
    TextEditingController sewaCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            int harga = parseRupiah(hargaCtrl.text);
            return AlertDialog(
              title: const Text('Beli Properti Baru'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Properti')),
                  TextField(
                    controller: hargaCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    decoration: const InputDecoration(labelText: 'Harga Beli'),
                    onChanged: (val) {
                      setStateDialog(() {});
                    },
                  ),
                  TextField(
                    controller: sewaCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    decoration: const InputDecoration(labelText: 'Sewa Bulanan'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Bayar: \$${formatRupiah(harga)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                ElevatedButton(
                  onPressed: () {
                    String nama = namaCtrl.text;
                    int harga = parseRupiah(hargaCtrl.text);
                    int sewa = parseRupiah(sewaCtrl.text);
                    if (nama.isNotEmpty && harga > 0 && sewa > 0) {
                      state.beliProperti(nama, harga, sewa);
                      setState(() {});
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Beli'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}