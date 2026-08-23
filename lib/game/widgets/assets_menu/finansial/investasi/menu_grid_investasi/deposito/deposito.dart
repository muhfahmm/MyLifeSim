// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/deposito/deposito.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN DEPOSITO
// ============================================================
class DepositoPage extends StatelessWidget {
  final _InvestasiPageState state;
  const DepositoPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposito'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.deposito.length + 1,
        itemBuilder: (ctx, i) {
          if (i == state.deposito.length) {
            return ElevatedButton.icon(
              onPressed: () => _showBukaDepositoDialog(context, state),
              icon: const Icon(Icons.add),
              label: const Text('Buka Deposito Baru'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
            );
          }
          var d = state.deposito[i];
          int tahunBerjalan = state.character.age - (d['tahunMulai'] as int);
          double bungaTotal = (d['jumlah'] as num).toDouble() * (d['bunga'] as num).toDouble() / 100 * tahunBerjalan;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text('Tenor ${d['tenor']} tahun', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pokok: Rp ${formatRupiah(d['jumlah'] as num)}'),
                  Text('Bunga: ${d['bunga']}% per tahun'),
                  Text('Bunga terkumpul: Rp ${formatRupiah(bungaTotal)}'),
                  Text('Total: Rp ${formatRupiah((d['jumlah'] as num).toDouble() + bungaTotal)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBukaDepositoDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController jumlahCtrl = TextEditingController();
    int selectedTenor = 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buka Deposito Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: selectedTenor,
              items: [1, 3, 5].map((t) => DropdownMenuItem(value: t, child: Text('$t tahun'))).toList(),
              onChanged: (val) => selectedTenor = val!,
              decoration: const InputDecoration(labelText: 'Tenor'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              int jumlah = parseRupiah(jumlahCtrl.text);
              if (jumlah > 0) {
                double bunga = selectedTenor == 1 ? 4 : (selectedTenor == 3 ? 5 : 6);
                state.buatDeposito(jumlah, selectedTenor, bunga);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Buka Deposito'),
          ),
        ],
      ),
    );
  }
}