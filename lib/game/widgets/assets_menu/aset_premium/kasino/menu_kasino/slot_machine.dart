part of '../kasino.dart';

class SlotMachinePage extends StatefulWidget {
  final _KasinoPageState state;
  const SlotMachinePage({super.key, required this.state});

  @override
  State<SlotMachinePage> createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage> {
  final List<String> symbols = ['CH', 'LE', 'OR', 'GR', 'BL', 'ST', '7'];
  List<String> currentSymbols = ['?', '?', '?', '?', '?'];
  bool isSpinning = false;
  int bet = 100000;
  int jackpot = 0;

  @override
  void initState() {
    super.initState();
    jackpot = widget.state.slotJackpot;
  }

  void spin() {
    if (isSpinning || widget.state.character.money < bet) {
      if (widget.state.character.money < bet) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      }
      return;
    }

    setState(() => isSpinning = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      final rand = Random();
      final newSymbols = List.generate(5, (_) => symbols[rand.nextInt(symbols.length)]);

      // Hitung frekuensi
      Map<String, int> freq = {};
      for (var s in newSymbols) freq[s] = (freq[s] ?? 0) + 1;
      int maxCount = freq.values.fold(0, (a, b) => a > b ? a : b);

      int winAmount = 0;
      bool isWin = false;
      String msg = '';

      // Tambah jackpot (5% dari taruhan)
      widget.state._addToSlotJackpot((bet * 0.05).round());

      if (maxCount >= 3) {
        int multiplier = 0;
        if (maxCount == 3) multiplier = 3;
        else if (maxCount == 4) multiplier = 10;
        else if (maxCount == 5) {
          multiplier = 50;
          if (newSymbols.every((s) => s == '7')) {
            winAmount = widget.state.slotJackpot;
            widget.state._resetSlotJackpot();
            msg = 'JACKPOT! Kamu memenangkan seluruh jackpot \$${formatRupiah(winAmount)}!';
            isWin = true;
          }
        }
        if (!isWin && multiplier > 0) {
          winAmount = bet * multiplier;
          msg = 'Menang $multiplier x! +\$${formatRupiah(winAmount)}';
          isWin = true;
        }
      }

      setState(() {
        currentSymbols = newSymbols;
        isSpinning = false;
        jackpot = widget.state.slotJackpot;
      });

      if (isWin) {
        widget.state.character.money += winAmount;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 15);
        widget.state._recordResult('Slot Machine', winAmount, true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
      } else {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 3);
        widget.state._recordResult('Slot Machine', bet, false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kalah, - \$${formatRupiah(bet)}'), backgroundColor: Colors.red));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Slot Machine'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Saldo: \$${formatRupiah(widget.state.character.money)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            Text('Jackpot: \$${formatRupiah(jackpot)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center,
                children: currentSymbols.map((s) => Container(
                  width: 70, height: 70, margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber, width: 2)),
                  child: Center(child: Text(s, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
                )).toList()
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (bet > 10000) bet -= 10000; })),
              Text('\$${formatRupiah(bet)}', style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
              IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { if (bet < 10000000) bet += 10000; })),
            ]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSpinning ? null : spin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              child: Text(isSpinning ? 'Memutar...' : 'Spin'),
            ),
          ],
        ),
      ),
    );
  }
}