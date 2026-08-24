part of '../kasino.dart';

class BlackjackPage extends StatefulWidget {
  final _KasinoPageState state;
  const BlackjackPage({super.key, required this.state});

  @override
  State<BlackjackPage> createState() => _BlackjackPageState();
}

class _BlackjackPageState extends State<BlackjackPage> {
  List<int> playerCards = [];
  List<int> dealerCards = [];
  int bet = 100000;
  bool gameOver = false;
  String result = '';

  void startGame() {
    if (widget.state.character.money < bet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uang tidak cukup!')),
      );
      return;
    }
    setState(() {
      playerCards = [_drawCard(), _drawCard()];
      dealerCards = [_drawCard(), _drawCard()];
      gameOver = false;
      result = '';
    });
  }

  int _drawCard() => Random().nextInt(11) + 2; // 2-12 (sederhana, Ace = 11)

  int _sumCards(List<int> cards) => cards.fold(0, (a, b) => a + b);

  void hit() {
    setState(() {
      playerCards.add(_drawCard());
      if (_sumCards(playerCards) > 21) {
        _finishGame(false);
      }
    });
  }

  void stand() {
    setState(() {
      // Dealer mainkan otomatis sampai >=17
      while (_sumCards(dealerCards) < 17) {
        dealerCards.add(_drawCard());
      }
      final int playerTotal = _sumCards(playerCards);
      final int dealerTotal = _sumCards(dealerCards);
      if (dealerTotal > 21 || playerTotal > dealerTotal) {
        _finishGame(true);
      } else if (playerTotal == dealerTotal) {
        _finishGame(null); // draw
      } else {
        _finishGame(false);
      }
    });
  }

  void _finishGame(bool? isWin) {
    setState(() {
      gameOver = true;
      if (isWin == true) {
        final int winAmount = bet * 2;
        widget.state.character.money += winAmount;
        widget.state.character.happiness = (widget.state.character.happiness + 12).clamp(0, 100);
        widget.state._recordResult('Blackjack', winAmount, true);
        result = '🎉 Kamu menang! +\$${formatRupiah(winAmount)}';
      } else if (isWin == false) {
        widget.state.character.money -= bet;
        widget.state.character.happiness = (widget.state.character.happiness - 5).clamp(0, 100);
        widget.state._recordResult('Blackjack', bet, false);
        if (bet > 1000000) {
          widget.state.character.health = (widget.state.character.health - 3).clamp(0, 100);
        }
        result = '💸 Kamu kalah, kehilangan \$${formatRupiah(bet)}';
      } else {
        result = '🤝 Seri! Uang kembali';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blackjack'), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Saldo: \$${formatRupiah(widget.state.character.money)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (!gameOver) ...[
              Text('Kartu Dealer: ${dealerCards.map((c) => c.toString()).join(' ')}'),
              const SizedBox(height: 8),
              Text('Kartu Anda: ${playerCards.map((c) => c.toString()).join(' ')}'),
              const SizedBox(height: 8),
              Text('Total: ${_sumCards(playerCards)}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (gameOver || playerCards.isEmpty) ? null : hit,
                    child: const Text('Hit'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: (gameOver || playerCards.isEmpty) ? null : stand,
                    child: const Text('Stand'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: playerCards.isEmpty ? startGame : null,
                child: const Text('Mulai Game'),
              ),
            ] else ...[
              Text(result, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() { playerCards.clear(); dealerCards.clear(); gameOver = false; result = ''; });
                },
                child: const Text('Main Lagi'),
              ),
            ],
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
          ],
        ),
      ),
    );
  }
}