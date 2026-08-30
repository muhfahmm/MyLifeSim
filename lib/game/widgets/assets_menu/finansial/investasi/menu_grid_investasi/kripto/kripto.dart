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
          _buildCashHeader(context, state, assetType: 'kripto'),
          Expanded(
            child: ListView.builder(
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
                        Text('Harga Saat Ini: \$${formatRupiah(harga)}'),
                        if (jumlah > 0) ...[
                          Builder(builder: (context) {
                            double buyPrice = state.averageKriptoBuyPrice[nama] ?? 0.0;
                            return Text('Harga Beli Rata-Rata: \$${formatRupiah(buyPrice.round())}');
                          }),
                        ],
                        Builder(builder: (context) {
                          double buyPrice = state.averageKriptoBuyPrice[nama] ?? 0.0;
                          double modal = jumlah * buyPrice;
                          return Text(
                            'Jumlah: ${jumlah.toStringAsFixed(4)} ${jumlah > 0 ? '(Modal: \$${formatRupiah(modal.round())})' : ''}',
                          );
                        }),
                        Text('Nilai: \$${formatRupiah(jumlah * harga)}'),
                        if (jumlah > 0) ...[
                          const SizedBox(height: 2),
                          Builder(builder: (context) {
                            double buyPrice = state.averageKriptoBuyPrice[nama] ?? 0.0;
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
                            onPressed: () => _showJualKriptoDialog(context, nama),
                            child: const Text('Jual'),
                          ),
                        TextButton(
                          style: TextButton.styleFrom(foregroundColor: Colors.green),
                          onPressed: () => _showBuyKriptoDialog(context, nama),
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

  void _showJualKriptoDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '0.01');
    final state = widget.state;
    double harga = state.hargaKripto[nama]!;
    double maxJual = state.kripto[nama] ?? 0.0;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            double jumlah = double.tryParse(controller.text) ?? 0.0;
            double totalDapat = jumlah * harga;
            return AlertDialog(
              title: Text('Jual Kripto $nama'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga saat ini: \$${formatRupiah(harga)}'),
                  Text('Maksimal Jual: ${maxJual.toStringAsFixed(4)}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
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
                    final jumlah = double.tryParse(controller.text) ?? 0.0;
                    if (jumlah > maxJual) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jumlah kripto melebihi kepemilikan!')),
                      );
                      return;
                    }
                    if (jumlah > 0) {
                      state.jualKripto(nama, jumlah);
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

  void _showBuyKriptoDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '0.01');
    final state = widget.state;
    double harga = state.hargaKripto[nama]!;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            double jumlah = double.tryParse(controller.text) ?? 0;
            double totalBayar = jumlah * harga;
            return AlertDialog(
              title: Text('Beli Kripto $nama'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga saat ini: \$${formatRupiah(harga)}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
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
            );
          },
        );
      },
    );
  }
}