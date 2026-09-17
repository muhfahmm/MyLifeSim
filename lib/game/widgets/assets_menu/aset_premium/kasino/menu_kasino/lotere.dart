part of '../kasino.dart';

class LoterePage extends StatefulWidget {
  final _KasinoPageState state;
  const LoterePage({super.key, required this.state});

  @override
  State<LoterePage> createState() => _LoterePageState();
}

class _LoterePageState extends State<LoterePage> {
  int bet = 100000;
  List<int> selectedNumbers = [];
  List<int> winningNumbers = [];
  bool isDrawing = false;
  String resultText = '';
  final List<int> quickBets = [10000, 50000, 100000, 500000, 1000000];

  void quickPick() {
    final rand = Random();
    final Set<int> picked = {};
    while (picked.length < 4) {
      picked.add(rand.nextInt(20) + 1);
    }
    setState(() {
      selectedNumbers = picked.toList()..sort();
    });
  }

  void buyTicket() {
    if (isDrawing) return;
    if (selectedNumbers.length < 4) {
      DialogHelper.show(
        context: context,
        title: 'Nomor Belum Lengkap ⚠️',
        content: const Text('Silakan pilih 4 nomor keberuntungan Anda atau gunakan tombol Quick Pick!'),
      );
      return;
    }

    if (widget.state.character.money < bet) {
      DialogHelper.show(
        context: context,
        title: 'Saldo Tidak Cukup ⚠️',
        content: const Text('Saldo uang Anda tidak mencukupi untuk membeli tiket lotere!'),
      );
      return;
    }

    setState(() {
      isDrawing = true;
      resultText = '';
      winningNumbers = [];
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      final rand = Random();
      final Set<int> drawn = {};
      while (drawn.length < 4) {
        drawn.add(rand.nextInt(20) + 1);
      }
      final finalWinning = drawn.toList()..sort();

      int matchCount = selectedNumbers.where((n) => finalWinning.contains(n)).length;
      int winAmount = 0;
      bool isWin = false;
      String msg = '';

      if (matchCount == 4) {
        winAmount = bet * 100;
        isWin = true;
        msg = '🎉 MEGA JACKPOT 100x! Cocok 4 Nomor (+\$${formatRupiah(winAmount)})';
      } else if (matchCount == 3) {
        winAmount = bet * 10;
        isWin = true;
        msg = '🔥 PRIZE 10x! Cocok 3 Nomor (+\$${formatRupiah(winAmount)})';
      } else if (matchCount == 2) {
        winAmount = bet * 2;
        isWin = true;
        msg = '✨ PRIZE 2x! Cocok 2 Nomor (+\$${formatRupiah(winAmount)})';
      } else {
        msg = '❌ Belum beruntung (Cocok $matchCount nomor). -\$${formatRupiah(bet)}';
      }

      if (!mounted) return;

      setState(() {
        isDrawing = false;
        winningNumbers = finalWinning;
        resultText = msg;
      });

      if (isWin) {
        widget.state.character.money += winAmount;
        widget.state._applyGamblingEffect(true, bet, happinessBonus: 25);
        widget.state._recordResult('Lotere', winAmount, true, detail: 'Match $matchCount/4');
      } else {
        widget.state.character.money -= bet;
        widget.state._applyGamblingEffect(false, bet, happinessPenalty: 3);
        widget.state._recordResult('Lotere', bet, false, detail: 'Match $matchCount/4');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP Golden Lottery 🎟️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        backgroundColor: const Color(0xFFC2410C),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: isDark ? const Color(0xFF1C1917) : const Color(0xFFFFF7ED),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Saldo Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SALDO TIKET', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('LOTTERY CLUB', style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text('\$${formatRupiah(widget.state.character.money)}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Golden Ticket Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF292524) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.amber.shade600, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number, color: Colors.amber, size: 22),
                      SizedBox(width: 8),
                      Text('GOLDEN TICKET (PILIH 4 NOMOR)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selected 4 Numbers Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (idx) {
                      bool hasVal = idx < selectedNumbers.length;
                      int val = hasVal ? selectedNumbers[idx] : 0;
                      return Container(
                        width: 52,
                        height: 58,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: hasVal ? Colors.amber.shade700 : (isDark ? const Color(0xFF1C1917) : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: hasVal ? Colors.amberAccent : Colors.grey.shade400, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            hasVal ? '$val' : '?',
                            style: TextStyle(
                              color: hasVal ? Colors.white : Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  TextButton.icon(
                    onPressed: isDrawing ? null : quickPick,
                    icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.amber),
                    label: const Text('QUICK PICK (ACAK AUTOMATIS)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Drawn Winning Numbers Box
            if (isDrawing || winningNumbers.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF292524) : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade600, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text('HASIL NOMOR UNDIAN KASINO:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.orange)),
                    const SizedBox(height: 12),
                    if (isDrawing) ...[
                      const CircularProgressIndicator(color: Colors.orange),
                      const SizedBox(height: 8),
                      const Text('MENGUNDI TIKET...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12)),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: winningNumbers.map((n) {
                          bool isMatched = selectedNumbers.contains(n);
                          return Container(
                            width: 44,
                            height: 44,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isMatched ? Colors.green.shade700 : Colors.red.shade800,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('$n', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(resultText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Number Matrix Selector (1 to 20)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('MATRIKS NOMOR (TEKUK UNTUK PILIH/BATAL):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: 20,
              itemBuilder: (ctx, i) {
                int n = i + 1;
                bool isSel = selectedNumbers.contains(n);
                return GestureDetector(
                  onTap: isDrawing
                      ? null
                      : () {
                          setState(() {
                            if (isSel) {
                              selectedNumbers.remove(n);
                            } else {
                              if (selectedNumbers.length < 4) {
                                selectedNumbers.add(n);
                                selectedNumbers.sort();
                              }
                            }
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSel ? Colors.amber.shade700 : (isDark ? const Color(0xFF292524) : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSel ? Colors.amberAccent : Colors.grey.shade400, width: isSel ? 2 : 1),
                    ),
                    child: Center(
                      child: Text(
                        '$n',
                        style: TextStyle(
                          color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: isSel ? FontWeight.w900 : FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Quick Chips Selector
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('PILIH HARGA TIKET:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
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
                  selectedColor: Colors.orange.shade800,
                  backgroundColor: isDark ? const Color(0xFF292524) : Colors.white,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.orangeAccent : Colors.grey.shade400,
                    width: isSelected ? 1.5 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: isDrawing
                      ? null
                      : (sel) {
                          if (sel) setState(() => bet = amount);
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Buy Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isDrawing ? null : buyTicket,
                icon: const Icon(Icons.shopping_cart_checkout, size: 20),
                label: Text(
                  isDrawing ? 'MEMPROSES LOTERE...' : 'BELI TIKET LOTERE (\$${formatRupiah(bet)})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
