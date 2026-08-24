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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              state.nextYear();
              setState(() {});
            },
            tooltip: 'Update Harga Pasar',
          ),
        ],
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
                  Text('Harga Saat Ini: \$${formatRupiah(harga)}'),
                  if (jumlah > 0) ...[
                    Builder(builder: (context) {
                      double buyPrice = state.averageSahamBuyPrice[nama] ?? 0.0;
                      return Text('Harga Beli Rata-Rata: \$${formatRupiah(buyPrice.round())}');
                    }),
                  ],
                  Builder(builder: (context) {
                    double buyPrice = state.averageSahamBuyPrice[nama] ?? 0.0;
                    double modal = jumlah * buyPrice;
                    return Text(
                      'Jumlah: $jumlah lembar ${jumlah > 0 ? '(Modal: \$${formatRupiah(modal.round())})' : ''}',
                      style: const TextStyle(fontSize: 12),
                    );
                  }),
                  if (jumlah > 0) ...[
                    const SizedBox(height: 2),
                    Builder(builder: (context) {
                      double buyPrice = state.averageSahamBuyPrice[nama] ?? 0.0;
                      double ret = (harga - buyPrice) * jumlah;
                      return Text(
                        'Return/Loss: ${ret >= 0 ? '+' : ''}\$${formatRupiah(ret.round())}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ret >= 0 ? Colors.green : Colors.red,
                        ),
                      );
                    }),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (jumlah > 0)
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => _showJualSahamDialog(context, nama),
                      child: const Text('Jual'),
                    ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () => _showBuySahamDialog(context, nama),
                    child: const Text('Beli'),
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

  void _showJualSahamDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '1');
    final state = widget.state;
    double harga = state.hargaSaham[nama]!;
    int maxJual = state.saham[nama] ?? 0;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            int jumlah = int.tryParse(controller.text.replaceAll(',', '')) ?? 0;
            double totalDapat = jumlah * harga;
            return AlertDialog(
              title: Text('Jual Saham $nama'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga saat ini: \$${formatRupiah(harga)}'),
                  Text('Maksimal Jual: $maxJual lembar'),
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
                    'Total Pendapatan: \$${formatRupiah(totalDapat)}',
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () {
                    final jumlah = int.tryParse(controller.text.replaceAll(',', '')) ?? 0;
                    if (jumlah > maxJual) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jumlah lembar melebihi kepemilikan!')),
                      );
                      return;
                    }
                    if (jumlah > 0) {
                      state.jualSaham(nama, jumlah);
                      setState(() {});
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Jual'),
                ),
              ],
            );
          },
        );
      },
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