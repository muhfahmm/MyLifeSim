// lib/game/widgets/assets_menu/aset_premium/kasino/kasino.dart
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

part 'menu_kasino/slot_machine.dart';
part 'menu_kasino/blackjack.dart';
part 'menu_kasino/roulette.dart';
part 'menu_kasino/poker.dart';
part 'menu_kasino/lotere.dart';
part 'menu_kasino/statistik.dart';

String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
    buffer.write(parts[i]);
  }
  return value < 0 ? '-${buffer.toString()}' : buffer.toString();
}

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
        Navigator.push(context, MaterialPageRoute(builder: (_) => KasinoPage(character: character)))
            .then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.amber.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.amber.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.casino, color: isUnlocked ? Colors.amber : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(child: Text('Casino', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isUnlocked ? Colors.amber : Colors.grey))),
            const SizedBox(width: 8),
            Icon(isUnlocked ? Icons.check_circle : Icons.lock, color: isUnlocked ? Colors.green : Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    DialogHelper.show(
      context: context,
      title: 'Fitur Terkunci 🔒',
      isNotification: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur $feature terbuka saat karakter berusia $requiredAge tahun.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Usia saat ini: ${character.age} tahun',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== ROOT STATE =====================
class KasinoPage extends StatefulWidget {
  final Character character;
  const KasinoPage({super.key, required this.character});

  @override
  State<KasinoPage> createState() => _KasinoPageState();
}

class _KasinoPageState extends State<KasinoPage> {
  late Character character;

  // --- Statistik ---
  List<Map<String, dynamic>> history = [];
  int totalWin = 0;
  int totalLoss = 0;

  // --- Jackpot Progresif Slot ---
  int slotJackpot = 0;

  // --- Helper ---
  void _recordResult(String game, int amount, bool isWin, {String detail = ''}) {
    setState(() {
      history.insert(0, {'game': game, 'amount': amount, 'isWin': isWin, 'detail': detail, 'time': DateTime.now()});
      if (isWin) {
        totalWin += amount;
        character.casinoTotalWin = totalWin;
      } else {
        totalLoss += amount;
        character.casinoTotalLoss = totalLoss;
      }
    });
  }

  void _addToSlotJackpot(int amount) {
    setState(() {
      slotJackpot += amount;
      character.casinoSlotJackpot = slotJackpot;
    });
  }

  void _resetSlotJackpot() {
    setState(() {
      slotJackpot = 0;
      character.casinoSlotJackpot = 0;
    });
  }

  // --- Efek judi (tambahan penalti jika kalah besar) ---
  void _applyGamblingEffect(bool isWin, int bet, {int happinessBonus = 10, int happinessPenalty = 5, int healthPenalty = 3}) {
    character.gamblingAddictionLevel = (character.gamblingAddictionLevel + 3).clamp(0, 100);
    if (isWin) {
      character.happiness = (character.happiness + happinessBonus).clamp(0, 100);
    } else {
      character.happiness = (character.happiness - happinessPenalty).clamp(0, 100);
      if (bet > 1000000) character.health = (character.health - healthPenalty).clamp(0, 100);
    }
  }

  String _getGamblingNarrative(int level) {
    if (level == 0) return '0% • Rendah (Aman) - Bebas dari dorongan taruhan judi.';
    if (level < 34) return '$level% • Ringan (Iseng) - Hanya mencoba taruhan judi sesekali.';
    if (level < 67) return '$level% • Sedang (Ketergantungan) - Sering terbayang dorongan taruhan.';
    return '$level% • Tinggi (Kompulsif / Bahaya!) - Kecanduan berat taruhan judi.';
  }

  @override
  void initState() {
    super.initState();
    character = widget.character;
    history = character.casinoHistory;
    totalWin = character.casinoTotalWin;
    totalLoss = character.casinoTotalLoss;
    slotJackpot = character.casinoSlotJackpot;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int addictionLevel = character.gamblingAddictionLevel;

    // Color code untuk kecanduan judi
    Color statusColor;
    if (addictionLevel < 34) {
      statusColor = Colors.green;
    } else if (addictionLevel < 67) {
      statusColor = Colors.amber.shade800;
    } else {
      statusColor = Colors.redAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Casino', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.amber.shade900,
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh Saldo & Status',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Card Saldo & Statistik ---
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? Colors.amber.shade800.withValues(alpha: 0.4) : Colors.amber.shade200),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo Anda',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'USD ${formatRupiah(character.money)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Wrap mencegah horizontal overflow pada layar HP
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.trending_up, color: Colors.green, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              'Menang: USD ${formatRupiah(totalWin)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.trending_down, color: Colors.red, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              'Kalah: USD ${formatRupiah(totalLoss)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (slotJackpot > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '🎰 Jackpot Slot: USD ${formatRupiah(slotJackpot)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Card Bar Level Kecanduan Judi ---
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.casino, color: statusColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Level Kecanduan Judi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                          ),
                        ),
                      ),
                      Text(
                        '$addictionLevel%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (addictionLevel / 100).clamp(0.0, 1.0),
                      minHeight: 7,
                      backgroundColor: statusColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _getGamblingNarrative(addictionLevel),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuTile(Icons.casino, 'Slot Machine', '3 gulungan dengan jackpot progresif', Colors.deepPurple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => SlotMachinePage(state: this)))),
            const SizedBox(height: 8),
            _buildMenuTile(Icons.style, 'Blackjack', 'Kartu 21 melawan dealer', Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlackjackPage(state: this)))),
            const SizedBox(height: 8),
            _buildMenuTile(Icons.circle, 'Roulette', 'Tebak angka, warna, atau ganjil/genap', Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoulettePage(state: this)))),
            const SizedBox(height: 8),
            _buildMenuTile(Icons.card_travel, 'Poker', '5 kartu, bandingkan ranking', Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => PokerPage(state: this)))),
            const SizedBox(height: 8),
            _buildMenuTile(Icons.confirmation_number, 'Lotere', 'Beli tiket dengan hadiah bertingkat', Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoterePage(state: this)))),
            const SizedBox(height: 8),
            _buildMenuTile(Icons.history, 'Statistik & Riwayat', 'Lihat semua transaksi', Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => StatistikPage(state: this)))),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String label, String subtitle, Color color, VoidCallback onTap) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: isDark ? Colors.white54 : Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
