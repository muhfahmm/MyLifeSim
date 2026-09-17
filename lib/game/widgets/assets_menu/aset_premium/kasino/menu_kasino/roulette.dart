part of '../kasino.dart';

class RoulettePage extends StatefulWidget {
  final _KasinoPageState state;
  const RoulettePage({super.key, required this.state});

  @override
  State<RoulettePage> createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage> {
  int bet = 100000;
  int selectedNumber = 0;
  String betType = 'number';
  bool isSpinning = false;
  String resultText = '';
  int? lastOutcome;

  final List<int> redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];
  final List<int> quickBets = [10000, 50000, 100000, 500000, 1000000];

  bool isNumberRed(int num) => redNumbers.contains(num);

  void spin() {
    if (isSpinning) return;
    if (widget.state.character.money < bet) {
      DialogHelper.show(
        context: context,
        title: 'Saldo Tidak Cukup ⚠️',
        content: const Text('Saldo uang Anda tidak mencukupi untuk taruhan Roulette!'),
      );
      return;
    }

    setState(() {
      isSpinning = true;
      resultText = '';
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      final int outcome = Random().nextInt(37);
      final bool isRed = isNumberRed(outcome);
      bool isWin = false;
      int winAmount = 0;
      String detail = '';

      switch (betType) {
        case 'number':
          isWin = outcome == selectedNumber;
          winAmount = isWin ? bet * 35 : 0;
          detail = 'Angka $outcome ${outcome == 0 ? '(Hijau)' : (isRed ? '(Merah)' : '(Hitam)')}';
          break;
        case 'color':
          bool betRed = selectedNumber == 1;
          isWin = (betRed && isRed) || (!betRed && !isRed && outcome != 0);
          winAmount = isWin ? bet * 2 : 0;
          detail = outcome == 0 ? '0 (Hijau)' : (isRed ? 'Merah' : 'Hitam');
          break;
        case 'oddEven':
          bool betOdd = selectedNumber == 1;
          if (outcome == 0) {
            isWin = false;
          } else {
            isWin = (outcome % 2 == 1) == betOdd;
          }
          winAmount = isWin ? bet * 2 : 0;
          detail = outcome == 0 ? '0 (Nol)' : (outcome % 2 == 1 ? 'Ganjil' : 'Genap');
          break;
        case 'highLow':
          bool betHigh = selectedNumber == 1;
          if (outcome == 0) {
            isWin = false;
          } else {
            isWin = (outcome >= 19 && outcome <= 36) == betHigh;
          }
          winAmount = isWin ? bet * 2 : 0;
          detail = outcome == 0 ? '0 (Nol)' : (outcome >= 19 ? 'High (19-36)' : 'Low (1-18)');
          break;
      }

      if (!mounted) return;

      setState(() {
        isSpinning = false;
        lastOutcome = outcome;
        if (isWin) {
          widget.state.character.money += winAmount;
          widget.state._applyGamblingEffect(true, bet, happinessBonus: 20);
          widget.state._recordResult('Roulette', winAmount, true, detail: detail);
          resultText = 'MENANG! 🎉 Hasil: $detail (+\$${formatRupiah(winAmount)})';
        } else {
          widget.state.character.money -= bet;
          widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 2);
          widget.state._recordResult('Roulette', bet, false, detail: detail);
          resultText = 'KALAH! ❌ Hasil: $detail (-\$${formatRupiah(bet)})';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('European Roulette 🎡', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        backgroundColor: const Color(0xFF15803D),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF166534),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SALDO ROULETTE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('USD MEJA', style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                    ],
                  ),
                  Text('\$${formatRupiah(widget.state.character.money)}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Wheel Outcome Box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade600, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                children: [
                  if (isSpinning) ...[
                    const CircularProgressIndicator(color: Colors.green),
                    const SizedBox(height: 12),
                    const Text('BOLA SEDANG BERPUTAR...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                  ] else if (lastOutcome != null) ...[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: lastOutcome == 0
                            ? Colors.green.shade700
                            : (isNumberRed(lastOutcome!) ? Colors.red.shade700 : Colors.black87),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amberAccent, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          '$lastOutcome',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      resultText,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    const Icon(Icons.casino_outlined, size: 48, color: Colors.green),
                    const SizedBox(height: 6),
                    const Text('PILIH TARUHAN DENGAN CHIP & TEKAN SPIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bet Type Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: betType,
                  isExpanded: true,
                  dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'number', child: Text('🎯 Angka Tunggal 0-36 (Bayaran 35x)')),
                    DropdownMenuItem(value: 'color', child: Text('🔴/⚫ Warna Merah atau Hitam (Bayaran 2x)')),
                    DropdownMenuItem(value: 'oddEven', child: Text('🔢 Ganjil atau Genap (Bayaran 2x)')),
                    DropdownMenuItem(value: 'highLow', child: Text('📊 High (19-36) / Low (1-18) (Bayaran 2x)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        betType = val;
                        selectedNumber = 0;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options depending on Bet Type
            if (betType == 'number') ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('PILIH NOMOR (0-36):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: 37,
                itemBuilder: (ctx, i) {
                  final bool isSel = selectedNumber == i;
                  final Color numBg = i == 0
                      ? Colors.green.shade700
                      : (isNumberRed(i) ? Colors.red.shade700 : Colors.black87);
                  return GestureDetector(
                    onTap: () => setState(() => selectedNumber = i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: numBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSel ? Colors.amberAccent : Colors.white24, width: isSel ? 3 : 1),
                      ),
                      child: Center(
                        child: Text(
                          '$i',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSel ? FontWeight.w900 : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ] else if (betType == 'color') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedNumber = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: selectedNumber == 1 ? Colors.amberAccent : Colors.transparent, width: 3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('🔴 MERAH (RED)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedNumber = 2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: selectedNumber == 2 ? Colors.amberAccent : Colors.transparent, width: 3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('⚫ HITAM (BLACK)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ] else if (betType == 'oddEven') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedNumber = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: selectedNumber == 1 ? Colors.amberAccent : Colors.transparent, width: 3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('GANJIL (ODD)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedNumber = 2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: selectedNumber == 2 ? Colors.amberAccent : Colors.transparent, width: 3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('GENAP (EVEN)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ] else if (betType == 'highLow') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedNumber = 2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: selectedNumber == 2 ? Colors.amberAccent : Colors.transparent, width: 3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('LOW (1 - 18)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedNumber = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade700,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: selectedNumber == 1 ? Colors.amberAccent : Colors.transparent, width: 3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('HIGH (19 - 36)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),

            // Quick Chips Selector
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
                  selectedColor: Colors.green.shade800,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.greenAccent : Colors.grey.shade400,
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
            const SizedBox(height: 20),

            // Spin Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isSpinning ? null : spin,
                icon: const Icon(Icons.refresh, size: 22),
                label: Text(
                  isSpinning ? 'SPINNING ROULETTE...' : 'PUTAR ROULETTE (\$${formatRupiah(bet)})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
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
