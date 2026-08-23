// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/reksa_dana/reksa_dana.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN REKSA DANA
// ============================================================
class ReksaDanaPage extends StatelessWidget {
  final _InvestasiPageState state;
  const ReksaDanaPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reksa Dana'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Investasi: Rp ${formatRupiah(state.reksaDanaInvestasi)}'),
                    Text('Return: Rp ${formatRupiah(state.reksaDanaReturn)}'),
                    const Divider(),
                    Text(
                      'Total: Rp ${formatRupiah(state.reksaDanaInvestasi + state.reksaDanaReturn)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pilih Risiko:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['Rendah', 'Sedang', 'Tinggi'].map((r) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(r),
                    value: r,
                    groupValue: state.risikoReksa,
                    onChanged: (val) {
                      // Hanya ubah risiko, tidak langsung investasi
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showInvestDialog(context, state),
                    icon: const Icon(Icons.add),
                    label: const Text('Investasi Baru'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      state.cairkanReksaDana();
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Cairkan'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInvestDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController controller = TextEditingController();
    String selectedRisiko = state.risikoReksa;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Investasi Reksa Dana'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRisiko,
              items: ['Rendah', 'Sedang', 'Tinggi'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => selectedRisiko = val!,
              decoration: const InputDecoration(labelText: 'Risiko'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              int jumlah = parseRupiah(controller.text);
              if (jumlah > 0) {
                state.investasiReksaDana(jumlah.toDouble(), selectedRisiko);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Investasi'),
          ),
        ],
      ),
    );
  }
}