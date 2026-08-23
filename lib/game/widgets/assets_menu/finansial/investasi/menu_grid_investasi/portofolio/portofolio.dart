// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/portofolio/portofolio.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN PORTOFOLIO
// ============================================================
class PortofolioPage extends StatelessWidget {
  final _InvestasiPageState state;
  const PortofolioPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portofolio'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildCashHeader(state),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Divider(),
                  _buildRow('Uang Tunai', state.character.money),
                  _buildRow(
                    'Saham',
                    state.saham.entries.fold<int>(0, (sum, entry) {
                      final harga = state.hargaSaham[entry.key] ?? 0.0;
                      return sum + (entry.value * harga).round();
                    }),
                  ),
                  _buildRow('Reksa Dana', (state.reksaDanaInvestasi + state.reksaDanaReturn).round()),
                  _buildRow(
                    'Properti',
                    state.properti.fold<int>(
                      0,
                      (sum, p) => sum + ((p['hargaBeli'] as num).toDouble() * (1 + (p['kenaikan'] as num).toDouble() / 100)).round(),
                    ),
                  ),
                  _buildRow('Emas', (state.emasGram * state.hargaEmasPerGram).round()),
                  _buildRow(
                    'Kripto',
                    state.kripto.entries.fold<int>(
                      0,
                      (sum, entry) => sum + (entry.value * (state.hargaKripto[entry.key] ?? 0.0)).round(),
                    ),
                  ),
                  _buildRow('Deposito', state.deposito.fold<int>(0, (sum, d) {
                    int tahun = state.character.age - (d['tahunMulai'] as int);
                    double bunga = (d['jumlah'] as num).toDouble() * (d['bunga'] as num).toDouble() / 100 * tahun;
                    return sum + ((d['jumlah'] as num).toDouble() + bunga).round();
                  })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text('\$${formatRupiah(value)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}