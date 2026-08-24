// lib/game/widgets/assets_menu/aset_premium/kasino/kasino.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

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
          color: isUnlocked ? Colors.amber.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.amber.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.casino, color: isUnlocked ? Colors.amber : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(child: Text('Casino', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isUnlocked ? Colors.amber : Colors.grey))),
            const SizedBox(width: 8),
            Icon(isUnlocked ? Icons.check_circle : Icons.lock, color: isUnlocked ? Colors.green : Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.lock_outline, color: Colors.grey), SizedBox(width: 8), Text('Fitur Terkunci')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fitur $feature terbuka saat karakter berusia $requiredAge tahun.'),
            const SizedBox(height: 8),
            Text('Usia saat ini: ${character.age} tahun', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti'))],
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
    if (isWin) {
      character.happiness = (character.happiness + happinessBonus).clamp(0, 100);
    } else {
      character.happiness = (character.happiness - happinessPenalty).clamp(0, 100);
      if (bet > 1000000) character.health = (character.health - healthPenalty).clamp(0, 100);
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casino'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {}))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo Anda', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('\$${formatRupiah(character.money)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text('Total Menang: \$${formatRupiah(totalWin)}', style: const TextStyle(color: Colors.green)),
                        const SizedBox(width: 16),
                        const Icon(Icons.trending_down, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text('Total Kalah: \$${formatRupiah(totalLoss)}', style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    if (slotJackpot > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('🎰 Jackpot Slot: \$${formatRupiah(slotJackpot)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color.withOpacity(0.3))),
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
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
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