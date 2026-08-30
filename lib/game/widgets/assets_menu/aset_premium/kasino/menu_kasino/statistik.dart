part of '../kasino.dart';

class StatistikPage extends StatelessWidget {
  final _KasinoPageState state;
  const StatistikPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik & Riwayat'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: isDark ? Colors.grey.shade800 : Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Menang:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        Text('USD ${formatRupiah(state.totalWin)}', style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Kalah:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        Text('USD ${formatRupiah(state.totalLoss)}', style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Net:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        Text(
                          'USD ${formatRupiah(state.totalWin - state.totalLoss)}',
                          style: TextStyle(
                            color: (state.totalWin - state.totalLoss) >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Riwayat Transaksi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            if (state.history.isEmpty)
              Text('Belum ada riwayat.', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.history.length,
                  itemBuilder: (ctx, i) {
                    final record = state.history[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        leading: Icon(record['isWin'] ? Icons.arrow_upward : Icons.arrow_downward,
                            color: record['isWin'] ? Colors.green : Colors.red),
                        title: Text(record['game'], style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                        subtitle: Text('USD ${formatRupiah(record['amount'])}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        trailing: Text(
                          record['isWin'] ? 'Menang' : 'Kalah',
                          style: TextStyle(color: record['isWin'] ? Colors.green : Colors.red),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}