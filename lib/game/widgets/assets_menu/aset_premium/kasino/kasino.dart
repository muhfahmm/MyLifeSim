// lib/game/widgets/assets_menu/aset_premium/kasino/kasino.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// ============================================================
// PART FILES
// ============================================================
part 'menu_kasino/slot_machine.dart';
part 'menu_kasino/blackjack.dart';
part 'menu_kasino/roulette.dart';
part 'menu_kasino/poker.dart';
part 'menu_kasino/lotere.dart';
part 'menu_kasino/statistik.dart';

// ============================================================
// UTILITY FORMAT RUPIAH (sama seperti kemewahan)
// ============================================================
String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(parts[i]);
  }
  final formatted = buffer.toString();
  return value < 0 ? '-$formatted' : formatted;
}

// ============================================================
// WIDGET ITEM CASINO (dashboard)
// ============================================================
class KasinoItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const KasinoItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 18;

    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Casino', 18);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KasinoPage(character: character),
          ),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.amber.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.amber.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.casino, color: isUnlocked ? Colors.amber : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Casino',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? Colors.amber : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isUnlocked ? Icons.check_circle : Icons.lock,
              color: isUnlocked ? Colors.green : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey, size: 28),
            SizedBox(width: 8),
            Text('Fitur Terkunci', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur $feature akan terbuka saat karakter berusia $requiredAge tahun.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Usia saat ini: ${character.age} tahun',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HALAMAN CASINO UTAMA (ROOT)
// ============================================================
class KasinoPage extends StatefulWidget {
  final Character character;
  const KasinoPage({super.key, required this.character});

  @override
  State<KasinoPage> createState() => _KasinoPageState();
}

class _KasinoPageState extends State<KasinoPage> {
  late Character character;

  @override
  void initState() {
    super.initState();
    character = widget.character;
  }

  // Riwayat transaksi (menang/kalah)
  List<Map<String, dynamic>> history = [];
  int totalWin = 0;
  int totalLoss = 0;

  // Helper untuk mencatat hasil
  void _recordResult(String game, int amount, bool isWin) {
    setState(() {
      history.insert(0, {
        'game': game,
        'amount': amount,
        'isWin': isWin,
        'time': DateTime.now(),
      });
      if (isWin) {
        totalWin += amount;
      } else {
        totalLoss += amount;
      }
    });
  }

  // Fungsi umum untuk efek judi
  void _applyGamblingEffect(bool isWin, int bet) {
    if (isWin) {
      character.happiness = (character.happiness + 10).clamp(0, 100);
      character.money += bet * 2; // contoh: menang 2x lipat (disesuaikan per game)
      _recordResult('Unknown', bet * 2, true);
    } else {
      character.happiness = (character.happiness - 5).clamp(0, 100);
      character.money -= bet;
      _recordResult('Unknown', bet, false);
      // jika kalah besar (> 1 juta) tambah stres
      if (bet > 1000000) {
        character.health = (character.health - 3).clamp(0, 100);
      }
    }
  }

  // ---- FUNGSI PERMAINAN (akan dipanggil dari part files) ----
  void playSlotMachine(int bet, VoidCallback onComplete) {
    // Implementasi di slot_machine.dart
  }

  void playBlackjack(int bet, VoidCallback onComplete) {
    // Implementasi di blackjack.dart
  }

  void playRoulette(int bet, int number, VoidCallback onComplete) {
    // Implementasi di roulette.dart
  }

  void playPoker(int bet, VoidCallback onComplete) {
    // Implementasi di poker.dart
  }

  void buyLottery(int bet, VoidCallback onComplete) {
    // Implementasi di lotere.dart
  }

  // ---- UI ROOT ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casino'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo Anda', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(
                      '\$${formatRupiah(character.money)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text('Total Menang: \$${formatRupiah(totalWin)}',
                            style: const TextStyle(color: Colors.green)),
                        const SizedBox(width: 16),
                        const Icon(Icons.trending_down, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text('Total Kalah: \$${formatRupiah(totalLoss)}',
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Menu daftar
            _buildMenuTile(
              icon: Icons.casino,
              label: 'Slot Machine',
              subtitle: 'Coba keberuntunganmu dengan 3 gulungan',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SlotMachinePage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.style,
              label: 'Blackjack',
              subtitle: 'Kartu 21 melawan dealer',
              color: Colors.red,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlackjackPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.circle,
              label: 'Roulette',
              subtitle: 'Tebak angka atau warna',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoulettePage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.card_travel,
              label: 'Poker',
              subtitle: 'Permainan kartu 5 kartu',
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PokerPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.confirmation_number,
              label: 'Lotere',
              subtitle: 'Beli tiket undian untuk jackpot besar',
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoterePage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.history,
              label: 'Statistik & Riwayat',
              subtitle: 'Lihat riwayat permainanmu',
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StatistikPage(state: this))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}