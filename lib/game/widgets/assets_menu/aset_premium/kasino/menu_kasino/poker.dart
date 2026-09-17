part of '../kasino.dart';

enum PokerHandRank {
  highCard('High Card', 1),
  onePair('One Pair', 2),
  twoPair('Two Pair', 3),
  threeOfAKind('Three of a Kind', 4),
  straight('Straight', 5),
  flush('Flush', 6),
  fullHouse('Full House', 7),
  fourOfAKind('Four of a Kind', 8),
  straightFlush('Straight Flush', 9),
  royalFlush('Royal Flush', 10);

  final String label;
  final int multiplier;
  const PokerHandRank(this.label, this.multiplier);
}

class PokerHandEvaluator {
  static PokerHandRank evaluate(List<PlayingCard> hand) {
    if (hand.length < 5) return PokerHandRank.highCard;
    final sorted = List<PlayingCard>.from(hand)..sort((a, b) => a.rank.compareTo(b.rank));
    
    bool isFlush = hand.every((c) => c.suit == hand[0].suit);
    
    bool isStraight = false;
    // Check normal straight
    if (sorted[4].rank - sorted[0].rank == 4 &&
        sorted[1].rank - sorted[0].rank == 1 &&
        sorted[2].rank - sorted[1].rank == 1 &&
        sorted[3].rank - sorted[2].rank == 1) {
      isStraight = true;
    }
    // Check Ace-low straight (A, 2, 3, 4, 5)
    if (sorted[0].rank == 1 && sorted[1].rank == 2 && sorted[2].rank == 3 && sorted[3].rank == 4 && sorted[4].rank == 5) {
      isStraight = true;
    }

    if (isFlush && isStraight) {
      if (sorted[0].rank == 1 && sorted[4].rank == 13) return PokerHandRank.royalFlush;
      return PokerHandRank.straightFlush;
    }

    final Map<int, int> counts = {};
    for (var c in hand) {
      counts[c.rank] = (counts[c.rank] ?? 0) + 1;
    }

    final values = counts.values.toList()..sort((a, b) => b.compareTo(a));

    if (values[0] == 4) return PokerHandRank.fourOfAKind;
    if (values[0] == 3 && values[1] == 2) return PokerHandRank.fullHouse;
    if (isFlush) return PokerHandRank.flush;
    if (isStraight) return PokerHandRank.straight;
    if (values[0] == 3) return PokerHandRank.threeOfAKind;
    if (values[0] == 2 && values[1] == 2) return PokerHandRank.twoPair;
    if (values[0] == 2) return PokerHandRank.onePair;

    return PokerHandRank.highCard;
  }
}

class PokerPage extends StatefulWidget {
  final _KasinoPageState state;
  const PokerPage({super.key, required this.state});

  @override
  State<PokerPage> createState() => _PokerPageState();
}

class _PokerPageState extends State<PokerPage> {
  List<PlayingCard> deck = [];
  List<PlayingCard> playerHand = [];
  List<PlayingCard> dealerHand = [];
  List<bool> heldCards = [false, false, false, false, false];

  int bet = 100000;
  int phase = 0; // 0: deal, 1: draw hold, 2: showdown
  String result = '';
  PokerHandRank? playerRank;
  PokerHandRank? dealerRank;

  final List<int> quickBets = [10000, 50000, 100000, 500000, 1000000];

  List<PlayingCard> _buildDeck() {
    final suits = ['♠️', '♥️', '♦️', '♣️'];
    List<PlayingCard> d = [];
    for (var s in suits) {
      for (int r = 1; r <= 13; r++) {
        d.add(PlayingCard(rank: r, suit: s));
      }
    }
    d.shuffle();
    return d;
  }

  void dealInitialCards() {
    if (widget.state.character.money < bet) {
      DialogHelper.show(
        context: context,
        title: 'Saldo Tidak Cukup ⚠️',
        content: const Text('Saldo uang Anda tidak mencukupi untuk taruhan Poker!'),
      );
      return;
    }

    setState(() {
      deck = _buildDeck();
      playerHand = List.generate(5, (_) => deck.removeLast());
      dealerHand = List.generate(5, (_) => deck.removeLast());
      heldCards = [false, false, false, false, false];
      phase = 1;
      result = '';
      playerRank = PokerHandEvaluator.evaluate(playerHand);
      dealerRank = PokerHandEvaluator.evaluate(dealerHand);
    });
  }

  void drawCards() {
    if (phase != 1) return;

    setState(() {
      for (int i = 0; i < 5; i++) {
        if (!heldCards[i]) {
          playerHand[i] = deck.removeLast();
        }
      }
      phase = 2;
      playerRank = PokerHandEvaluator.evaluate(playerHand);
      dealerRank = PokerHandEvaluator.evaluate(dealerHand);

      int pScore = playerRank!.multiplier;
      int dScore = dealerRank!.multiplier;

      if (pScore > dScore) {
        int win = bet * (pScore + 1);
        widget.state.character.money += win;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 15);
        widget.state._recordResult('Poker', win, true, detail: '${playerRank!.label} vs ${dealerRank!.label}');
        result = 'MENANG! 🎉 ${playerRank!.label} kalahkan ${dealerRank!.label} (+\$${formatRupiah(win)})';
      } else if (pScore < dScore) {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 3);
        widget.state._recordResult('Poker', bet, false, detail: '${playerRank!.label} vs ${dealerRank!.label}');
        result = 'KALAH! ❌ ${dealerRank!.label} mengalahkan ${playerRank!.label} (-\$${formatRupiah(bet)})';
      } else {
        result = 'SERI! 🤝 Keduanya memiliki ${playerRank!.label}';
      }
    });
  }

  Widget _buildPokerCard(PlayingCard card, {bool isHeld = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 74,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isHeld ? Colors.amberAccent : Colors.black26, width: isHeld ? 2.5 : 1),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
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
                      fontSize: 13,
                      color: card.isRed ? Colors.red.shade700 : Colors.black87,
                    ),
                  ),
                  Center(child: Text(card.suit, style: const TextStyle(fontSize: 17))),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      card.rankString,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: card.isRed ? Colors.red.shade700 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (phase == 1) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isHeld ? Colors.amber.shade900 : Colors.grey.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isHeld ? 'HOLD' : 'DRAW',
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Card Draw Poker 🃏', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Saldo Card Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('POKER CASH TABLE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text('\$${formatRupiah(widget.state.character.money)}', style: const TextStyle(color: Colors.amberAccent, fontSize: 20, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Dealer Hand Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade700, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.psychology, color: Colors.blue, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'DEALER POKER ${phase == 2 && dealerRank != null ? '(${dealerRank!.label})' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (phase > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dealerHand.map((card) {
                        return _buildPokerCard(card);
                      }).toList(),
                    )
                  else
                    const Text('TEKAN BAGI KARTU UNTUK MULAI', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Player Hand Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.shade600, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'KARTU ANDA ${playerRank != null ? '(${playerRank!.label})' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (phase > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(playerHand.length, (idx) {
                        return _buildPokerCard(
                          playerHand[idx],
                          isHeld: heldCards[idx],
                          onTap: phase == 1
                              ? () {
                                  setState(() => heldCards[idx] = !heldCards[idx]);
                                }
                              : null,
                        );
                      }),
                    )
                  else
                    const Text('KARTU BELUM DIBAGIKAN', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  if (phase == 1) ...[
                    const SizedBox(height: 10),
                    const Text('*Ketuk kartu untuk TAHAN (HOLD) sebelum tukar kartu', style: TextStyle(fontSize: 11, color: Colors.amber, fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Result Banner
            if (result.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Button
            if (phase == 0 || phase == 2) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: dealInitialCards,
                  icon: const Icon(Icons.style, size: 20),
                  label: Text('BAGI KARTU POKER (\$${formatRupiah(bet)})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ] else if (phase == 1) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: drawCards,
                  icon: const Icon(Icons.swap_calls, size: 20),
                  label: const Text('TUKAR KARTU (DRAW)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
              child: Text('PILIH CHIP TARUHAN:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
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
                  selectedColor: Colors.blue.shade800,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.blueAccent : Colors.grey.shade400,
                    width: isSelected ? 1.5 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: phase == 1
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
