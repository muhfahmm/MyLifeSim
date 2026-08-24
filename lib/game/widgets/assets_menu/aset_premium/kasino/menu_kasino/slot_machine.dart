part of '../kasino.dart';

class SlotMachinePage extends StatefulWidget {
  final _KasinoPageState state;
  const SlotMachinePage({super.key, required this.state});

  @override
  State<SlotMachinePage> createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage> {
  final List<String> symbols = ['🍒', '🍋', '🍊', '🍇', '🔔', '⭐', '7️⃣'];
  List<String> currentSymbols = ['?', '?', '?'];
  bool isSpinning = false;
  int bet = 100000;

  void spin() {
    if (isSpinning) return;
    if (widget.state.character.money < bet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uang tidak cukup!')),
      );
      return;
    }

    setState(() {
      isSpinning = true;
    });

    // Simulasi spin
    Future.delayed(const Duration(milliseconds: 800), () {
      final Random rand = Random();
      final newSymbols = List.generate(3, (_) => symbols[rand.nextInt(symbols.length)]);
      final bool isWin = newSymbols[0] == newSymbols[1] && newSymbols[1] == newSymbols[2];

      setState(() {
        currentSymbols = newSymbols;
        isSpinning = false;
      });

      // Efek
      if (isWin) {
        final int winAmount = bet * 5; // jackpot 5x
        widget.state.character.money += winAmount;
        widget.state.character.happiness = (widget.state.character.happiness + 15).clamp(0, 100);
        widget.state._recordResult('Slot Machine', winAmount, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 JACKPOT! Menang \$${formatRupiah(winAmount)}!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        widget.state.character.money -= bet;
        widget.state.character.happiness = (widget.state.character.happiness - 5).clamp(0, 100);
        widget.state._recordResult('Slot Machine', bet, false);
        if (bet > 1000000) {
          widget.state.character.health = (widget.state.character.health - 3).clamp(0, 100);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('💸 Kalah, kehilangan \$${formatRupiah(bet)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot Machine'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Saldo: \$${formatRupiah(widget.state.character.money)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentSymbols.map((s) {
                return Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Center(
                    child: Text(s, style: const TextStyle(fontSize: 40)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() { if (bet > 10000) bet -= 10000; }),
                ),
                Text('\$${formatRupiah(bet)}', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() { if (bet < 10000000) bet += 10000; }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSpinning ? null : spin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(isSpinning ? 'Memutar...' : 'Spin 🎰'),
            ),
          ],
        ),
      ),
    );
  }
}