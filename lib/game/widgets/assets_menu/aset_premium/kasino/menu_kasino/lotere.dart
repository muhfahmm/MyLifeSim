part of '../kasino.dart';

class LoterePage extends StatefulWidget {
  final _KasinoPageState state;
  const LoterePage({super.key, required this.state});

  @override
  State<LoterePage> createState() => _LoterePageState();
}

class _LoterePageState extends State<LoterePage> {
  int bet = 100000;

  void buyTicket() {
    if (widget.state.character.money < bet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uang tidak cukup!')),
      );
      return;
    }
    final Random rand = Random();
    final int jackpot = rand.nextInt(100); // 0-99
    final bool isWin = jackpot < 5; // 5% chance menang
    setState(() {
      if (isWin) {
        final int winAmount = bet * 50; // jackpot 50x
        widget.state.character.money += winAmount;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 25);
        widget.state._recordResult('Lotere', winAmount, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('JACKPOT LOTERE! Menang USD ${formatRupiah(winAmount)}!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 3);
        widget.state._recordResult('Lotere', bet, false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tiket tidak beruntung. Kehilangan USD ${formatRupiah(bet)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lotere'), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Saldo: USD ${formatRupiah(widget.state.character.money)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Beli tiket undian dengan peluang jackpot 5%!'),
            const SizedBox(height: 10),
            const Text('Menang dapat 50x lipat taruhan.'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() { if (bet > 10000) bet -= 10000; }),
                ),
                Text('USD ${formatRupiah(bet)}', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() { if (bet < 10000000) bet += 10000; }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: buyTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Beli Tiket'),
            ),
          ],
        ),
      ),
    );
  }
}