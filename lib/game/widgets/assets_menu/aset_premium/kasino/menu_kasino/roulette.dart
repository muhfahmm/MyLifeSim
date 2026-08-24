part of '../kasino.dart';

class RoulettePage extends StatefulWidget {
  final _KasinoPageState state;
  const RoulettePage({super.key, required this.state});

  @override
  State<RoulettePage> createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage> {
  int bet = 100000;
  int selectedNumber = 0; // 0-36
  bool isSpinning = false;
  String result = '';

  void spin() {
    if (isSpinning) return;
    if (widget.state.character.money < bet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uang tidak cukup!')),
      );
      return;
    }
    setState(() { isSpinning = true; });
    Future.delayed(const Duration(seconds: 2), () {
      final int outcome = Random().nextInt(37);
      final bool isWin = outcome == selectedNumber;
      setState(() {
        isSpinning = false;
        if (isWin) {
          final int winAmount = bet * 35; // odds 35:1
          widget.state.character.money += winAmount;
          widget.state.character.happiness = (widget.state.character.happiness + 20).clamp(0, 100);
          widget.state._recordResult('Roulette', winAmount, true);
          result = '🎉 Angka $outcome! Kamu menang \$${formatRupiah(winAmount)}!';
        } else {
          widget.state.character.money -= bet;
          widget.state.character.happiness = (widget.state.character.happiness - 5).clamp(0, 100);
          widget.state._recordResult('Roulette', bet, false);
          result = '💸 Angka $outcome. Kamu kalah \$${formatRupiah(bet)}';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roulette'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Saldo: \$${formatRupiah(widget.state.character.money)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Pilih angka 0-36:', style: const TextStyle(fontSize: 16)),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 37,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => setState(() { selectedNumber = i; }),
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: selectedNumber == i ? Colors.amber : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('$i', style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSpinning ? null : spin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(isSpinning ? 'Memutar...' : 'Spin 🎡'),
            ),
            const SizedBox(height: 16),
            Text(result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}