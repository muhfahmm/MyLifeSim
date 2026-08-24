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
  String result = '';

  final List<int> redNumbers = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];

  void spin() {
    if (isSpinning || widget.state.character.money < bet) {
      if (widget.state.character.money < bet) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      }
      return;
    }
    setState(() => isSpinning = true);
    Future.delayed(const Duration(seconds: 2), () {
      final int outcome = Random().nextInt(37);
      final bool isRed = redNumbers.contains(outcome);
      bool isWin = false;
      int winAmount = 0;
      String detail = '';

      switch (betType) {
        case 'number':
          isWin = outcome == selectedNumber;
          winAmount = isWin ? bet * 35 : 0;
          detail = 'Angka $outcome';
          break;
        case 'color':
          bool betRed = selectedNumber == 1;
          isWin = (betRed && isRed) || (!betRed && !isRed && outcome != 0);
          winAmount = isWin ? bet * 2 : 0;
          detail = outcome == 0 ? '0 (hijau)' : (isRed ? 'Merah' : 'Hitam');
          break;
        case 'oddEven':
          bool betOdd = selectedNumber == 1;
          if (outcome == 0) isWin = false;
          else isWin = (outcome % 2 == 1) == betOdd;
          winAmount = isWin ? bet * 2 : 0;
          detail = outcome == 0 ? '0' : (outcome % 2 == 1 ? 'Ganjil' : 'Genap');
          break;
        case 'highLow':
          bool betHigh = selectedNumber == 1;
          if (outcome == 0) isWin = false;
          else isWin = (outcome >= 19 && outcome <= 36) == betHigh;
          winAmount = isWin ? bet * 2 : 0;
          detail = outcome == 0 ? '0' : (outcome >= 19 ? 'High (19-36)' : 'Low (1-18)');
          break;
      }

      setState(() {
        isSpinning = false;
        if (isWin) {
          widget.state.character.money += winAmount;
          widget.state._applyGamblingEffect(true, bet, happinessBonus: 20);
          widget.state._recordResult('Roulette', winAmount, true, detail: detail);
          result = '🎉 Menang! $detail -> +\$${formatRupiah(winAmount)}';
        } else {
          widget.state.character.money -= bet;
          widget.state._applyGamblingEffect(false, bet, happinessPenalty: 5, healthPenalty: 2);
          widget.state._recordResult('Roulette', bet, false, detail: detail);
          result = '💸 Kalah! $detail -> -\$${formatRupiah(bet)}';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roulette'), backgroundColor: Colors.green),
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
              DropdownButton<String>(
                value: betType,
                items: const [
                  DropdownMenuItem(value: 'number', child: Text('Angka Tunggal (35x)')),
                  DropdownMenuItem(value: 'color', child: Text('Warna (Merah/Hitam) 2x')),
                  DropdownMenuItem(value: 'oddEven', child: Text('Ganjil/Genap 2x')),
                  DropdownMenuItem(value: 'highLow', child: Text('High/Low 2x')),
                ],
                onChanged: (val) => setState(() => betType = val!),
              ),
              const SizedBox(height: 16),
              if (betType == 'number') ...[
                const Text('Pilih angka 0-36:', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 37,
                    itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () => setState(() => selectedNumber = i),
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: selectedNumber == i ? Colors.amber : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text('$i', style: const TextStyle(fontSize: 18))),
                      ),
                    ),
                  ),
                ),
              ] else if (betType == 'color') ...[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: () => setState(() => selectedNumber = 1), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Merah')),
                  const SizedBox(width: 16),
                  ElevatedButton(onPressed: () => setState(() => selectedNumber = 0), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white), child: const Text('Hitam')),
                ]),
              ] else if (betType == 'oddEven') ...[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: () => setState(() => selectedNumber = 1), child: const Text('Ganjil')),
                  const SizedBox(width: 16),
                  ElevatedButton(onPressed: () => setState(() => selectedNumber = 0), child: const Text('Genap')),
                ]),
              ] else if (betType == 'highLow') ...[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: () => setState(() => selectedNumber = 1), child: const Text('High (19-36)')),
                  const SizedBox(width: 16),
                  ElevatedButton(onPressed: () => setState(() => selectedNumber = 0), child: const Text('Low (1-18)')),
                ]),
              ],
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (bet > 10000) bet -= 10000; })),
                Text('\$${formatRupiah(bet)}', style: const TextStyle(fontSize: 18)),
                IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { if (bet < 10000000) bet += 10000; })),
              ]),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: isSpinning ? null : spin, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: Text(isSpinning ? 'Memutar...' : 'Spin 🎡')),
              const SizedBox(height: 16),
              Text(result, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}