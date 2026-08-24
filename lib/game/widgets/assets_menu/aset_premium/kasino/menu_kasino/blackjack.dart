part of '../kasino.dart';

class BlackjackPage extends StatefulWidget {
  final _KasinoPageState state;
  const BlackjackPage({super.key, required this.state});

  @override
  State<BlackjackPage> createState() => _BlackjackPageState();
}

class _BlackjackPageState extends State<BlackjackPage> {
  List<int> deck = [];
  List<int> playerCards = [];
  List<int> dealerCards = [];
  int bet = 100000;
  bool gameOver = false;
  String result = '';

  List<int> _buildDeck() {
    List<int> d = [];
    for (int i = 0; i < 4; i++) {
      for (int v = 1; v <= 13; v++) d.add(v);
    }
    d.shuffle();
    return d;
  }

  int _handValue(List<int> hand) {
    int total = hand.fold(0, (a, b) => a + b);
    int aces = hand.where((c) => c == 1).length;
    while (total > 21 && aces > 0) {
      total -= 10;
      aces--;
    }
    return total;
  }

  bool _isBlackjack(List<int> hand) => hand.length == 2 && _handValue(hand) == 21;

  void startGame() {
    if (widget.state.character.money < bet) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      return;
    }
    setState(() {
      deck = _buildDeck();
      playerCards = [deck.removeLast(), deck.removeLast()];
      dealerCards = [deck.removeLast(), deck.removeLast()];
      gameOver = false;
      result = '';

      if (_isBlackjack(playerCards) && _isBlackjack(dealerCards)) {
        result = '🤝 Kedua blackjack! Seri.';
        gameOver = true;
      } else if (_isBlackjack(playerCards)) {
        int win = (bet * 1.5).round();
        widget.state.character.money += win;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 20);
        widget.state._recordResult('Blackjack', win, true);
        result = '🎉 BLACKJACK! Kamu menang \$${formatRupiah(win)}!';
        gameOver = true;
      } else if (_isBlackjack(dealerCards)) {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 10, healthPenalty: 5);
        widget.state._recordResult('Blackjack', bet, false);
        result = '💸 Dealer blackjack! Kamu kalah \$${formatRupiah(bet)}';
        gameOver = true;
      }
    });
  }

  void hit() {
    if (gameOver) return;
    setState(() {
      playerCards.add(deck.removeLast());
      if (_handValue(playerCards) > 21) _finishGame(false);
    });
  }

  void stand() {
    if (gameOver) return;
    setState(() {
      while (_handValue(dealerCards) < 17) dealerCards.add(deck.removeLast());
      int playerVal = _handValue(playerCards);
      int dealerVal = _handValue(dealerCards);
      if (dealerVal > 21 || playerVal > dealerVal) _finishGame(true);
      else if (playerVal == dealerVal) _finishGame(null);
      else _finishGame(false);
    });
  }

  void _finishGame(bool? isWin) {
    setState(() {
      gameOver = true;
      if (isWin == true) {
        int win = bet * 2;
        widget.state.character.money += win;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 12);
        widget.state._recordResult('Blackjack', win, true);
        result = '🎉 Kamu menang! +\$${formatRupiah(win)}';
      } else if (isWin == false) {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 3);
        widget.state._recordResult('Blackjack', bet, false);
        result = '💸 Kalah, - \$${formatRupiah(bet)}';
      } else {
        result = '🤝 Seri! Uang kembali.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blackjack'), backgroundColor: Colors.red),
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
              if (!gameOver) ...[
                Text('Dealer: ${dealerCards.map((c) => c == 1 ? 'A' : c > 10 ? 'JQK'[c-11] : c.toString()).join(' ')}  (${_handValue(dealerCards)})'),
                const Divider(),
                Text('Anda: ${playerCards.map((c) => c == 1 ? 'A' : c > 10 ? 'JQK'[c-11] : c.toString()).join(' ')}  (${_handValue(playerCards)})'),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: hit, child: const Text('Hit')),
                  const SizedBox(width: 16),
                  ElevatedButton(onPressed: stand, child: const Text('Stand')),
                ]),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: startGame, child: const Text('Mulai')),
              ] else ...[
                Text(result, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: startGame, child: const Text('Main Lagi')),
              ],
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