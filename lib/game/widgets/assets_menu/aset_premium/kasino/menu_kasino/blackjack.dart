part of '../kasino.dart';

class PlayingCard {
  final int rank; // 1 (Ace) to 13 (King)
  final String suit; // '♠️', '♥️', '♦️', '♣️'

  PlayingCard({required this.rank, required this.suit});

  String get rankString {
    if (rank == 1) return 'A';
    if (rank == 11) return 'J';
    if (rank == 12) return 'Q';
    if (rank == 13) return 'K';
    return rank.toString();
  }

  bool get isRed => suit == '♥️' || suit == '♦️';

  int get blackjackValue {
    if (rank == 1) return 11;
    if (rank >= 10) return 10;
    return rank;
  }
}

class BlackjackPage extends StatefulWidget {
  final _KasinoPageState state;
  const BlackjackPage({super.key, required this.state});

  @override
  State<BlackjackPage> createState() => _BlackjackPageState();
}

class _BlackjackPageState extends State<BlackjackPage> {
  List<PlayingCard> deck = [];
  List<PlayingCard> playerCards = [];
  List<PlayingCard> dealerCards = [];
  int bet = 100000;
  bool gameStarted = false;
  bool gameOver = true;
  String result = '';
  final List<int> quickBets = [10000, 50000, 100000, 500000, 1000000];

  List<PlayingCard> _buildDeck() {
    final suits = ['♠️', '♥️', '♦️', '♣️'];
    List<PlayingCard> d = [];
    for (var suit in suits) {
      for (int r = 1; r <= 13; r++) {
        d.add(PlayingCard(rank: r, suit: suit));
      }
    }
    d.shuffle();
    return d;
  }

  int _handValue(List<PlayingCard> hand) {
    int total = hand.fold(0, (sum, card) => sum + card.blackjackValue);
    int aces = hand.where((c) => c.rank == 1).length;
    while (total > 21 && aces > 0) {
      total -= 10;
      aces--;
    }
    return total;
  }

  bool _isBlackjack(List<PlayingCard> hand) => hand.length == 2 && _handValue(hand) == 21;

  void startGame() {
    if (widget.state.character.money < bet) {
      DialogHelper.show(
        context: context,
        title: 'Saldo Tidak Cukup ⚠️',
        content: const Text('Uang Anda tidak mencukupi untuk memasang taruhan ini!'),
      );
      return;
    }

    setState(() {
      deck = _buildDeck();
      playerCards = [deck.removeLast(), deck.removeLast()];
      dealerCards = [deck.removeLast(), deck.removeLast()];
      gameStarted = true;
      gameOver = false;
      result = '';

      if (_isBlackjack(playerCards) && _isBlackjack(dealerCards)) {
        result = 'TIE! Kedua pihak Blackjack (Push)';
        gameOver = true;
      } else if (_isBlackjack(playerCards)) {
        int win = (bet * 1.5).round();
        widget.state.character.money += win;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 20);
        widget.state._recordResult('Blackjack', win, true);
        result = 'BLACKJACK! 🎉 Menang 1.5x (+\$${formatRupiah(win)})';
        gameOver = true;
      } else if (_isBlackjack(dealerCards)) {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 10, healthPenalty: 5);
        widget.state._recordResult('Blackjack', bet, false);
        result = 'DEALER BLACKJACK! Kalah -\$${formatRupiah(bet)}';
        gameOver = true;
      }
    });
  }

  void hit() {
    if (gameOver || !gameStarted) return;
    setState(() {
      playerCards.add(deck.removeLast());
      if (_handValue(playerCards) > 21) {
        _finishGame(false, reason: 'BUST! Nilai kartu melebihi 21.');
      }
    });
  }

  void doubleDown() {
    if (gameOver || !gameStarted || playerCards.length != 2) return;
    if (widget.state.character.money < bet * 2) {
      DialogHelper.show(
        context: context,
        title: 'Saldo Tidak Cukup ⚠️',
        content: const Text('Saldo uang Anda tidak mencukupi untuk Double Down!'),
      );
      return;
    }

    setState(() {
      bet = bet * 2;
      playerCards.add(deck.removeLast());
      if (_handValue(playerCards) > 21) {
        _finishGame(false, reason: 'BUST pada Double Down!');
      } else {
        stand();
      }
    });
  }

  void stand() {
    if (gameOver || !gameStarted) return;
    setState(() {
      while (_handValue(dealerCards) < 17) {
        dealerCards.add(deck.removeLast());
      }
      int pVal = _handValue(playerCards);
      int dVal = _handValue(dealerCards);

      if (dVal > 21) {
        _finishGame(true, reason: 'Dealer BUST! ($dVal)');
      } else if (pVal > dVal) {
        _finishGame(true, reason: 'Kartu Anda ($pVal) > Dealer ($dVal)');
      } else if (pVal == dVal) {
        _finishGame(null, reason: 'SERI! ($pVal vs $dVal)');
      } else {
        _finishGame(false, reason: 'Dealer Menang ($dVal vs $pVal)');
      }
    });
  }

  void _finishGame(bool? isWin, {String reason = ''}) {
    gameOver = true;
    if (isWin == true) {
      int win = bet * 2;
      widget.state.character.money += win;
      widget.state._applyGamblingEffect(true, bet, happinessBonus: 12);
      widget.state._recordResult('Blackjack', win, true);
      result = 'MENANG! 🏆 $reason (+\$${formatRupiah(win)})';
    } else if (isWin == false) {
      widget.state.character.money -= bet;
      widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 3);
      widget.state._recordResult('Blackjack', bet, false);
      result = 'KALAH! ❌ $reason (-\$${formatRupiah(bet)})';
    } else {
      result = 'SERI! 🤝 $reason (Taruhan Kembali)';
    }
  }

  Widget _buildCardWidget(PlayingCard card, {bool hidden = false}) {
    if (hidden) {
      return Container(
        width: 50,
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.style, color: Colors.amber, size: 24),
        ),
      );
    }

    return Container(
      width: 52,
      height: 74,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26, width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.rankString,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: card.isRed ? Colors.red.shade700 : Colors.black87,
              ),
            ),
            Center(
              child: Text(
                card.suit,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                card.rankString,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: card.isRed ? Colors.red.shade700 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classic Blackjack 21 ♠️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: isDark ? const Color(0xFF022C22) : const Color(0xFF064E3B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Saldo Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade400, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('SALDO MEJA:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('\$${formatRupiah(widget.state.character.money)}', style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dealer Card Felt Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade900.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade600, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_pin, color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'DEALER ${gameStarted && !gameOver ? '' : '(${_handValue(dealerCards)})'}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (gameStarted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dealerCards.asMap().entries.map((entry) {
                        int idx = entry.key;
                        PlayingCard card = entry.value;
                        bool isHidden = idx == 1 && !gameOver;
                        return _buildCardWidget(card, hidden: isHidden);
                      }).toList(),
                    )
                  else
                    const Text('KARTU BELUM DIBAGIKAN', style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Player Card Felt Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade900.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade400, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle, color: Colors.amberAccent, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'KARTU ANDA ${gameStarted ? '(${_handValue(playerCards)})' : ''}',
                        style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (gameStarted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: playerCards.map((card) => _buildCardWidget(card)).toList(),
                    )
                  else
                    const Text('TEKAN MULAI UNTUK TARUHAN', style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Game Result Banner
            if (result.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            if (gameStarted && !gameOver) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: hit,
                      icon: const Icon(Icons.add_card, size: 18),
                      label: const Text('HIT', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: stand,
                      icon: const Icon(Icons.pan_tool, size: 18),
                      label: const Text('STAND', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  if (playerCards.length == 2) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: doubleDown,
                        icon: const Icon(Icons.electric_bolt, size: 18),
                        label: const Text('DOUBLE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: startGame,
                  icon: const Icon(Icons.play_circle_fill, size: 22),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      gameStarted ? 'MAIN LAGI (\$${formatRupiah(bet)})' : 'PASANG TARUHAN & DEAL (\$${formatRupiah(bet)})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Chip Selector
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PILIH TARUHAN CHIP:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: quickBets.map((amount) {
                final bool isSelected = bet == amount;
                return ChoiceChip(
                  label: Text('\$${formatRupiah(amount)}'),
                  selected: isSelected,
                  selectedColor: Colors.amber.shade800,
                  backgroundColor: Colors.white,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.amberAccent : Colors.grey.shade400,
                    width: isSelected ? 1.5 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (gameStarted && !gameOver)
                      ? null
                      : (sel) {
                          if (sel) setState(() => bet = amount);
                        },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
