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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // 1. Saham
    double sahamVal = 0;
    double sahamCost = 0;
    state.saham.forEach((nama, jumlah) {
      sahamVal += jumlah * (state.hargaSaham[nama] ?? 0.0);
      sahamCost += jumlah * (state.averageSahamBuyPrice[nama] ?? 0.0);
    });
    double sahamReturn = sahamVal - sahamCost;

    // 2. Emas
    double emasVal = state.emasGram * state.hargaEmasPerGram;
    double emasCost = state.emasGram * state.averageEmasBuyPrice;
    double emasReturn = emasVal - emasCost;

    // 3. Kripto
    double kriptoVal = 0;
    double kriptoCost = 0;
    state.kripto.forEach((nama, jumlah) {
      kriptoVal += jumlah * (state.hargaKripto[nama] ?? 0.0);
      kriptoCost += jumlah * (state.averageKriptoBuyPrice[nama] ?? 0.0);
    });
    double kriptoReturn = kriptoVal - kriptoCost;

    // Total
    double totalReturn = sahamReturn + emasReturn + kriptoReturn;
    double totalInvestasiVal = sahamVal + emasVal + kriptoVal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portofolio'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildCashHeader(context, state),
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
                    sahamVal.round(),
                    returnVal: sahamReturn,
                  ),
                  ...state.saham.entries.where((entry) => entry.value > 0).map((entry) {
                    final nama = entry.key;
                    final jumlah = entry.value;
                    final harga = state.hargaSaham[nama] ?? 0.0;
                    final buyPrice = state.averageSahamBuyPrice[nama] ?? 0.0;
                    final val = jumlah * harga;
                    final ret = (harga - buyPrice) * jumlah;
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(' • $nama ($jumlah lembar @ \$${formatRupiah(buyPrice.round())})', style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                          Text(
                            '\$${formatRupiah(val.round())} (${ret >= 0 ? '+' : ''}\$${formatRupiah(ret.round())})',
                            style: TextStyle(fontSize: 13, color: ret >= 0 ? Colors.green.shade700 : Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }),
                  _buildRow(
                    'Emas',
                    emasVal.round(),
                    returnVal: emasReturn,
                  ),
                  _buildRow(
                    'Kripto',
                    kriptoVal.round(),
                    returnVal: kriptoReturn,
                  ),
                  ...state.kripto.entries.where((entry) => entry.value > 0).map((entry) {
                    final nama = entry.key;
                    final jumlah = entry.value;
                    final harga = state.hargaKripto[nama] ?? 0.0;
                    final buyPrice = state.averageKriptoBuyPrice[nama] ?? 0.0;
                    final val = jumlah * harga;
                    final ret = (harga - buyPrice) * jumlah;
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(' • $nama (${jumlah.toStringAsFixed(4)} @ \$${formatRupiah(buyPrice.round())})', style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                          Text(
                            '\$${formatRupiah(val.round())} (${ret >= 0 ? '+' : ''}\$${formatRupiah(ret.round())})',
                            style: TextStyle(fontSize: 13, color: ret >= 0 ? Colors.green.shade700 : Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 24, thickness: 1.5),
                  _buildRow(
                    'Total Investasi',
                    totalInvestasiVal.round(),
                    returnVal: totalReturn,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, int value, {double? returnVal, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTotal ? 17 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                '\$${formatRupiah(value)}',
                style: TextStyle(
                  fontSize: isTotal ? 17 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (returnVal != null) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  returnVal >= 0 ? '  Return' : '  Loss',
                  style: TextStyle(
                    fontSize: 13,
                    color: returnVal >= 0 ? Colors.green : Colors.red,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '${returnVal >= 0 ? '+' : ''}\$${formatRupiah(returnVal.abs().round())}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: returnVal >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}