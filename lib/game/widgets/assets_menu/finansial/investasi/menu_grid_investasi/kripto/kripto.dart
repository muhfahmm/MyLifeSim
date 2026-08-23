// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/kripto/kripto.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN KRIPTO
// ============================================================
class KriptoPage extends StatefulWidget {
  final _InvestasiPageState state;
  const KriptoPage({super.key, required this.state});

  @override
  State<KriptoPage> createState() => _KriptoPageState();
}

class _KriptoPageState extends State<KriptoPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kripto'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.hargaKripto.keys.length,
        itemBuilder: (ctx, i) {
          String nama = state.hargaKripto.keys.elementAt(i);
          double harga = state.hargaKripto[nama]!;
          double jumlah = state.kripto[nama] ?? 0;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga: Rp ${formatRupiah(harga)}'),
                  Text('Jumlah: ${jumlah.toStringAsFixed(4)}'),
                  Text('Nilai: Rp ${formatRupiah(jumlah * harga)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () {
                      if (jumlah > 0.01) {
                        state.jualKripto(nama, 0.01);
                        setState(() {});
                      }
                    },
                    tooltip: 'Jual 0.01',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () => _showBuyKriptoDialog(context, nama),
                    tooltip: 'Beli',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBuyKriptoDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '0.01');
    final state = widget.state;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Beli Kripto $nama'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga saat ini: Rp ${formatRupiah(state.hargaKripto[nama]!)}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
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
              final jumlah = double.tryParse(controller.text) ?? 0;
              if (jumlah > 0) {
                state.beliKripto(nama, jumlah);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }
}