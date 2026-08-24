part of '../kasino.dart';

class PokerPage extends StatefulWidget {
  final _KasinoPageState state;
  const PokerPage({super.key, required this.state});

  @override
  State<PokerPage> createState() => _PokerPageState();
}

class _PokerPageState extends State<PokerPage> {
  List<int> playerHand = [];
  List<int> dealerHand = [];
  int bet = 100000;
  bool gameOver = false;
  String result = '';

  int _rankHand(List<int> hand) => hand.fold(0, (a, b) => a + b);

  void startGame() {
    if (widget.state.character.money < bet) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      return;
    }
    setState(() {
      playerHand = List.generate(5, (_) => Random().nextInt(13) + 2);
      dealerHand = List.generate(5, (_) => Random().nextInt(13) + 2);
      gameOver = false;
      result = '';
    });
  }

  void compareHands() {
    int playerVal = _rankHand(playerHand);
    int dealerVal = _rankHand(dealerHand);
    setState(() {
      gameOver = true;
      if (playerVal > dealerVal) {
        int win = bet * 2;
        widget.state.character.money += win;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 12);
        widget.state._recordResult('Poker', win, true);
        result = '🎉 Menang! +\$${formatRupiah(win)}';
      } else if (playerVal < dealerVal) {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 3);
        widget.state._recordResult('Poker', bet, false);
        result = '💸 Kalah, - \$${formatRupiah(bet)}';
      } else {
        result = '🤝 Seri!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poker'), backgroundColor: Colors.blue),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Saldo: \$${formatRupiah(widget.state.character.money)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!gameOver && playerHand.isNotEmpty) ...[
                Text('Kartu Anda: ${playerHand.map((c) => c == 14 ? 'A' : c > 10 ? 'JQK'[c-11] : c.toString()).join(' ')}'),
                Text('Kartu Dealer: ${dealerHand.map((c) => c == 14 ? 'A' : c > 10 ? 'JQK'[c-11] : c.toString()).join(' ')}'),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: compareHands, child: const Text('Bandingkan')),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: playerHand.isEmpty ? startGame : () => setState(() { playerHand.clear(); dealerHand.clear(); gameOver = false; result = ''; }),
                child: Text(playerHand.isEmpty ? 'Mulai Game' : 'Main Lagi'),
              ),
              const SizedBox(height: 16),
              if (result.isNotEmpty) Text(result, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (bet > 10000) bet -= 10000; })),
                Text('\$${formatRupiah(bet)}', style: const TextStyle(fontSize: 18)),
                IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { if (bet < 10000000) bet += 10000; })),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}