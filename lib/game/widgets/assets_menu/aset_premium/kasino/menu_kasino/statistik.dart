part of '../kasino.dart';

class StatistikPage extends StatelessWidget {
  final _KasinoPageState state;
  const StatistikPage({super.key, required this.state});

  IconData _getGameIcon(String gameName) {
    if (gameName.contains('Slot')) return Icons.casino;
    if (gameName.contains('Blackjack')) return Icons.style;
    if (gameName.contains('Roulette')) return Icons.circle;
    if (gameName.contains('Poker')) return Icons.card_travel;
    if (gameName.contains('Lotere')) return Icons.confirmation_number;
    return Icons.casino_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int netProfit = state.totalWin - state.totalLoss;
    final int totalRounds = state.history.length;
    final int wins = state.history.where((r) => r['isWin'] == true).length;
    final double winRate = totalRounds > 0 ? (wins / totalRounds) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik & History Kasino 📊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: isDark ? const Color(0xFF042F2E) : const Color(0xFFF0FDFA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF115E59) : const Color(0xFFCCFBF1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal.shade400, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LABA / RUGI BERSIH (NET)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.tealAccent : Colors.teal.shade900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: netProfit >= 0 ? Colors.green.shade800 : Colors.red.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          netProfit >= 0 ? 'PROFIT' : 'RUGI',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'USD ${netProfit >= 0 ? '+' : ''}${formatRupiah(netProfit)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: netProfit >= 0 ? (isDark ? Colors.greenAccent : Colors.green.shade800) : Colors.red.shade700,
                      ),
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('Menang: USD ${formatRupiah(state.totalWin)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text('Kalah: USD ${formatRupiah(state.totalLoss)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Putaran Game: $totalRounds', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87)),
                      Text('Win Rate: ${winRate.toStringAsFixed(1)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.tealAccent : Colors.teal.shade900)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'RIWAYAT TARUHAN TERAKHIR:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            if (state.history.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 48, color: isDark ? Colors.white38 : Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Belum Ada Riwayat Taruhan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white70 : Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Mainkan salah satu permainan kasino untuk melihat statistik.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.history.length,
                  itemBuilder: (ctx, i) {
                    final record = state.history[i];
                    final bool isWin = record['isWin'] == true;
                    final String game = record['game'] ?? 'Kasino';
                    final int amount = record['amount'] ?? 0;
                    final String detail = record['detail'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F766E).withValues(alpha: 0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isWin ? Colors.green.withValues(alpha: 0.4) : Colors.red.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isWin ? Colors.green.withValues(alpha: 0.12) : Colors.red.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_getGameIcon(game), color: isWin ? Colors.green : Colors.red, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                if (detail.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    detail,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isWin ? '+' : '-'}\$${formatRupiah(amount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: isWin ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isWin ? Colors.green.shade800 : Colors.red.shade900,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isWin ? 'MENANG' : 'KALAH',
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
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
