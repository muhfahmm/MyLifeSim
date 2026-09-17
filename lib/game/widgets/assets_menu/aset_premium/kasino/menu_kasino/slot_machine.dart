part of '../kasino.dart';

class SlotMachinePage extends StatefulWidget {
  final _KasinoPageState state;
  const SlotMachinePage({super.key, required this.state});

  @override
  State<SlotMachinePage> createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage>
    with SingleTickerProviderStateMixin {
  final List<String> symbols = ['💎', '👑', '7️⃣', '🍒', '🔔', '💵', '🍀'];
  List<String> currentSymbols = ['🎰', '🎰', '🎰', '🎰', '🎰'];
  bool isSpinning = false;
  int bet = 100000;
  int jackpot = 0;
  String lastResultText = '';
  bool lastWinStatus = false;
  int lastWinAmount = 0;

  final List<int> quickBets = [10000, 50000, 100000, 500000, 1000000];

  @override
  void initState() {
    super.initState();
    jackpot = widget.state.slotJackpot;
  }

  void spin() {
    if (isSpinning) return;
    if (widget.state.character.money < bet) {
      DialogHelper.show(
        context: context,
        title: 'Saldo Tidak Cukup ⚠️',
        content: const Text(
            'Saldo uang Anda tidak mencukupi untuk melakukan taruhan ini!'),
      );
      return;
    }

    setState(() {
      isSpinning = true;
      lastResultText = '';
    });

    // Rapid randomizing spin animation preview
    int ticks = 0;
    Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final rand = Random();
      setState(() {
        currentSymbols =
            List.generate(5, (_) => symbols[rand.nextInt(symbols.length)]);
      });
      ticks++;
      if (ticks >= 14) {
        timer.cancel();
        _finalizeSpin();
      }
    });
  }

  void _finalizeSpin() {
    final rand = Random();
    final finalSymbols =
        List.generate(5, (_) => symbols[rand.nextInt(symbols.length)]);

    // Calculate symbol frequency
    final Map<String, int> freq = {};
    for (var s in finalSymbols) {
      freq[s] = (freq[s] ?? 0) + 1;
    }
    int maxCount = freq.values.fold(0, (a, b) => a > b ? a : b);

    int winAmount = 0;
    bool isWin = false;
    String resultMsg = '';

    // Add 5% of bet to progressive jackpot pool
    widget.state._addToSlotJackpot((bet * 0.05).round());

    if (maxCount >= 3) {
      int multiplier = 0;
      if (maxCount == 3) {
        multiplier = 5;
      } else if (maxCount == 4) {
        multiplier = 25;
      } else if (maxCount == 5) {
        multiplier = 100;
        if (finalSymbols.every((s) => s == '7️⃣')) {
          winAmount = widget.state.slotJackpot;
          widget.state._resetSlotJackpot();
          resultMsg = '🎉 GRAND JACKPOT! Menang \$${formatRupiah(winAmount)}!';
          isWin = true;
        }
      }
      if (!isWin && multiplier > 0) {
        winAmount = bet * multiplier;
        resultMsg = '🔥 MEGA WIN ${multiplier}x! +\$${formatRupiah(winAmount)}';
        isWin = true;
      }
    }

    if (!mounted) return;

    setState(() {
      currentSymbols = finalSymbols;
      isSpinning = false;
      jackpot = widget.state.slotJackpot;
      lastWinStatus = isWin;
      lastWinAmount = winAmount;
    });

    if (isWin) {
      widget.state.character.money += winAmount;
      widget.state._applyGamblingEffect(true, bet, happinessBonus: 15);
      widget.state._recordResult('Slot Machine', winAmount, true);
      lastResultText = resultMsg;
    } else {
      widget.state.character.money -= bet;
      widget.state._applyGamblingEffect(false, bet,
          happinessPenalty: 5, healthPenalty: 3);
      widget.state._recordResult('Slot Machine', bet, false);
      lastResultText = 'Kalah -\$${formatRupiah(bet)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP Slot Machine 🎰',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        backgroundColor: const Color(0xFF3B0764),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Jackpot & Balance Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF581C87), Color(0xFF7E22CE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade900.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SALDO ANDA',
                            style: TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${formatRupiah(widget.state.character.money)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.stars,
                                color: Colors.amberAccent, size: 16),
                            SizedBox(width: 4),
                            Text('PROGRESSIVE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                      color: Colors.purpleAccent, height: 24, thickness: 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎰 JACKPOT SLOTS: ',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      Text('\$${formatRupiah(jackpot)}',
                          style: const TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Slot Machine Reel Display Container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF1E1B4B) : const Color(0xFF312E81),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.amber.shade600, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade700.withValues(alpha: 0.25),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Reels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: currentSymbols.map((sym) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: 54,
                        height: 64,
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF0F172A) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSpinning
                                ? Colors.purpleAccent
                                : Colors.amber.shade400,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSpinning
                                  ? Colors.purple.withValues(alpha: 0.4)
                                  : Colors.black12,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            sym,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  if (lastResultText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: lastWinStatus
                            ? Colors.green.shade800
                            : Colors.red.shade900,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lastResultText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Bet Selectors
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PILIH CHIP TARUHAN:',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1),
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
                  selectedColor: Colors.purple.shade700,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.purpleAccent : Colors.grey.shade400,
                    width: isSelected ? 1.5 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: isSpinning
                      ? null
                      : (sel) {
                          if (sel) setState(() => bet = amount);
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Custom Stepper Bet
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.purple),
                  onPressed: isSpinning
                      ? null
                      : () {
                          if (bet > 10000) setState(() => bet -= 10000);
                        },
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Taruhan: \$${formatRupiah(bet)}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.purple),
                  onPressed: isSpinning
                      ? null
                      : () {
                          if (bet < 10000000) setState(() => bet += 10000);
                        },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Spin Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSpinning ? null : spin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: isSpinning
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Text('MEMUTAR REEL...',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app_rounded, size: 22),
                          SizedBox(width: 8),
                          Text('SPIN SEKARANG',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.1)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
