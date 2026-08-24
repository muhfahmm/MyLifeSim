// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/emas/emas.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN EMAS
// ============================================================
class EmasPage extends StatefulWidget {
  final _InvestasiPageState state;
  const EmasPage({super.key, required this.state});

  @override
  State<EmasPage> createState() => _EmasPageState();
}

class _EmasPageState extends State<EmasPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emas'),
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
          _buildCashHeader(state, assetType: 'emas'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.yellow.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Harga Emas Saat Ini: \$${formatRupiah(state.hargaEmasPerGram)}/gram'),
                          if (state.emasGram > 0) ...[
                            Text('Harga Beli Rata-Rata: \$${formatRupiah(state.averageEmasBuyPrice.round())}/gram'),
                          ],
                          const SizedBox(height: 8),
                          Builder(builder: (context) {
                            double modal = state.emasGram * state.averageEmasBuyPrice;
                            return Text(
                              'Emas dimiliki: ${state.emasGram.toStringAsFixed(2)} gram ${state.emasGram > 0 ? '(Modal: \$${formatRupiah(modal.round())})' : ''}',
                            );
                          }),
                          Text('Nilai: \$${formatRupiah(state.emasGram * state.hargaEmasPerGram)}'),
                          if (state.emasGram > 0) ...[
                            const SizedBox(height: 8),
                            Builder(builder: (context) {
                              double ret = (state.hargaEmasPerGram - state.averageEmasBuyPrice) * state.emasGram;
                              return Text(
                                'Return/Loss: ${ret >= 0 ? '+' : ''}\$${formatRupiah(ret.round())}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ret >= 0 ? Colors.green : Colors.red,
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showBeliEmasDialog(context, state),
                          icon: const Icon(Icons.add),
                          label: const Text('Beli Emas'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showJualEmasDialog(context, state),
                          icon: const Icon(Icons.remove),
                          label: const Text('Jual Emas'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBeliEmasDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            double gram = double.tryParse(ctrl.text) ?? 0;
            double totalBayar = gram * state.hargaEmasPerGram;
            return AlertDialog(
              title: const Text('Beli Emas'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Harga: \$${formatRupiah(state.hargaEmasPerGram)}/gram'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Gram'),
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
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                ElevatedButton(
                  onPressed: () {
                    double gram = double.tryParse(ctrl.text) ?? 0;
                    if (gram > 0) {
                      state.beliEmas(gram);
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

  void _showJualEmasDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Jual Emas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Emas dimiliki: ${state.emasGram.toStringAsFixed(2)} gram'),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Gram'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              double gram = double.tryParse(ctrl.text) ?? 0;
              if (gram > 0) {
                state.jualEmas(gram);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Jual'),
          ),
        ],
      ),
    );
  }
}