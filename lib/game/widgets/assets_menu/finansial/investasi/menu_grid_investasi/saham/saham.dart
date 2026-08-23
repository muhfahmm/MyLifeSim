// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/saham/saham.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN SAHAM
// ============================================================
class SahamPage extends StatefulWidget {
  final _InvestasiPageState state;
  const SahamPage({super.key, required this.state});

  @override
  State<SahamPage> createState() => _SahamPageState();
}

class _SahamPageState extends State<SahamPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saham'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildCashHeader(state, assetType: 'saham'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
        itemCount: state.hargaSaham.keys.length,
        itemBuilder: (ctx, i) {
          String nama = state.hargaSaham.keys.elementAt(i);
          double harga = state.hargaSaham[nama]!;
          int jumlah = state.saham[nama] ?? 0;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga: \$${formatRupiah(harga)}'),
                  Text('Jumlah: $jumlah lembar', style: const TextStyle(fontSize: 12)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () {
                      if (jumlah > 0) {
                        state.jualSaham(nama, 1);
                        setState(() {});
                      }
                    },
                    tooltip: 'Jual 1 lembar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () => _showBuySahamDialog(context, nama),
                    tooltip: 'Beli',
                  ),
                ],
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

  void _showBuySahamDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '1');
    final state = widget.state;
    double harga = state.hargaSaham[nama]!;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            int jumlah = int.tryParse(controller.text.replaceAll(',', '')) ?? 0;
            double totalBayar = jumlah * harga;
            return AlertDialog(
              title: Text('Beli Saham $nama'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga saat ini: \$${formatRupiah(harga)}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Jumlah lembar',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setStateDialog(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Bayar: \$${formatRupiah(totalBayar)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final jumlah = int.tryParse(controller.text.replaceAll(',', '')) ?? 0;
                    if (jumlah > 0) {
                      state.beliSaham(nama, jumlah);
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