// lib/game/widgets/assets_menu/finansial/investasi/investasi.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// ============================================================
// PART FILES (setiap menu akan menjadi part)
// ============================================================
part 'menu_grid_investasi/saham/saham.dart';
part 'menu_grid_investasi/emas/emas.dart';
part 'menu_grid_investasi/kripto/kripto.dart';
part 'menu_grid_investasi/portofolio/portofolio.dart';

// ============================================================
// UTILITY FUNCTIONS & FORMATTERS
// ============================================================
class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll(',', '');
    if (raw.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      return oldValue;
    }
    final formatted = _formatThousands(parsed);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatThousands(int value) {
    final digits = value.toString().split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}

int parseRupiah(String value) {
  return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
}

String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(parts[i]);
  }
  final formatted = buffer.toString();
  return value < 0 ? '-$formatted' : formatted;
}

Widget _buildCashHeader(BuildContext context, _InvestasiPageState state, {String? assetType}) {
  double returnVal = 0.0;
  bool showReturn = false;

  if (assetType == 'saham') {
    double sahamVal = 0;
    double sahamCost = 0;
    state.saham.forEach((nama, jumlah) {
      sahamVal += jumlah * (state.hargaSaham[nama] ?? 0.0);
      sahamCost += jumlah * (state.averageSahamBuyPrice[nama] ?? 0.0);
    });
    returnVal = sahamVal - sahamCost;
    showReturn = true;
  } else if (assetType == 'emas') {
    returnVal = (state.emasGram * state.hargaEmasPerGram) - (state.emasGram * state.averageEmasBuyPrice);
    showReturn = true;
  } else if (assetType == 'kripto') {
    double kriptoVal = 0;
    double kriptoCost = 0;
    state.kripto.forEach((nama, jumlah) {
      kriptoVal += jumlah * (state.hargaKripto[nama] ?? 0.0);
      kriptoCost += jumlah * (state.averageKriptoBuyPrice[nama] ?? 0.0);
    });
    returnVal = kriptoVal - kriptoCost;
    showReturn = true;
  }

  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: isDark ? Colors.green.shade900 : Colors.green.shade50,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Uang Tunai:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            Text('\$${formatRupiah(state.character.money)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        if (showReturn) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(returnVal >= 0 ? 'Return:' : 'Loss:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: returnVal >= 0 ? Colors.green : Colors.red)),
              Text(
                '${returnVal >= 0 ? '+' : ''}\$${formatRupiah(returnVal.abs())}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: returnVal >= 0 ? Colors.green : Colors.red),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}


// ============================================================
// WIDGET INVESTASI ITEM (untuk dashboard)
// ============================================================
class InvestasiItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;
  const InvestasiItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final int age = character.age;
    final bool isUnlocked = age >= 12;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Fitur Terkunci'),
              content: Text('Investasi akan terbuka saat karakter berusia 12 tahun. Usia saat ini: $age tahun.'),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti'))],
            ),
          );
          return;
        }
        final navigator = Navigator.of(context, rootNavigator: true);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => InvestasiPage(character: character),
          ),
        ).then((_) {
          if (onPop != null) onPop!();
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.blue.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.trending_up, color: isUnlocked ? Colors.blue : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Investasi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            Icon(Icons.check_circle, color: isUnlocked ? Colors.green : Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HALAMAN INVESTASI UTAMA (State)
// ============================================================
class InvestasiPage extends StatefulWidget {
  final Character character;
  const InvestasiPage({super.key, required this.character});

  @override
  State<InvestasiPage> createState() => _InvestasiPageState();
}

class _InvestasiPageState extends State<InvestasiPage> {
  late Character character;

  // ---- DATA INVESTASI DINAMIS & PERSISTEN DARI OBJEK KARAKTER ----
  Map<String, int> get saham => character.saham;
  set saham(Map<String, int> val) => character.saham = val;

  Map<String, double> get averageSahamBuyPrice => character.averageSahamBuyPrice;
  set averageSahamBuyPrice(Map<String, double> val) => character.averageSahamBuyPrice = val;

  double get emasGram => character.emasGram;
  set emasGram(double val) => character.emasGram = val;

  double get averageEmasBuyPrice => character.averageEmasBuyPrice;
  set averageEmasBuyPrice(double val) => character.averageEmasBuyPrice = val;

  Map<String, double> get kripto => character.kripto;
  set kripto(Map<String, double> val) => character.kripto = val;

  Map<String, double> get averageKriptoBuyPrice => character.averageKriptoBuyPrice;
  set averageKriptoBuyPrice(Map<String, double> val) => character.averageKriptoBuyPrice = val;

  Map<String, double> hargaSaham = {};
  double hargaEmasPerGram = 0;
  Map<String, double> hargaKripto = {};

  List<String> berita = [];

  double get totalKekayaan {
    double total = character.money.toDouble();
    saham.forEach((nama, jumlah) {
      total += jumlah * (hargaSaham[nama] ?? 0);
    });
    total += emasGram * hargaEmasPerGram;
    kripto.forEach((nama, jumlah) {
      total += jumlah * (hargaKripto[nama] ?? 0);
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _initData();
  }

  void _initData() {
    final List<String> sahamList = ['Tech Corp', 'Energy Giant', 'Health Plus', 'Fin Bank', 'Auto Drive'];
    for (var s in sahamList) {
      hargaSaham[s] = (1000 + Random().nextInt(4000)).toDouble();
      if (!saham.containsKey(s)) {
        saham[s] = 0;
      }
      if (saham[s]! > 0 && (averageSahamBuyPrice[s] == null || averageSahamBuyPrice[s] == 0.0)) {
        averageSahamBuyPrice[s] = hargaSaham[s]!;
      }
    }
    hargaEmasPerGram = (800000 + Random().nextInt(400000)).toDouble();
    if (emasGram > 0 && averageEmasBuyPrice == 0.0) {
      averageEmasBuyPrice = hargaEmasPerGram;
    }
    
    final List<String> kriptoList = ['Bitcoin', 'Ethereum', 'Dogecoin', 'Solana'];
    for (var k in kriptoList) {
      hargaKripto[k] = (10000 + Random().nextInt(90000)).toDouble();
      if (!kripto.containsKey(k)) {
        kripto[k] = 0;
      }
      if (kripto[k]! > 0 && (averageKriptoBuyPrice[k] == null || averageKriptoBuyPrice[k] == 0.0)) {
        averageKriptoBuyPrice[k] = hargaKripto[k]!;
      }
    }
    berita.add('Selamat datang di dunia investasi! Mulailah dengan bijak.');
  }

  // ---- FUNGSI UPDATE TAHUN ----
  void nextYear() {
    setState(() {
      // Update harga saham
      for (var key in hargaSaham.keys) {
        double change = (Random().nextDouble() * 0.4) - 0.2;
        hargaSaham[key] = (hargaSaham[key]! * (1 + change)).clamp(100.0, 10000.0);
      }

      // Update emas
      double emasChange = (Random().nextDouble() * 0.10) - 0.05;
      hargaEmasPerGram = (hargaEmasPerGram * (1 + emasChange)).clamp(500000.0, 2000000.0);

      // Update kripto
      for (var key in hargaKripto.keys) {
        double change = (Random().nextDouble() * 1.0) - 0.5;
        hargaKripto[key] = (hargaKripto[key]! * (1 + change)).clamp(1000.0, 500000.0);
      }

      // Event acak
      if (Random().nextDouble() < 0.10) {
        _generateRandomEvent();
      }
      _generateMarketNews();
    });
  }

  void _generateRandomEvent() {
    List<String> events = [
      '🔥 Krisis ekonomi! Semua harga saham turun 15%.',
      '🚀 Booming teknologi! Saham Tech Corp naik 30%.',
      '💰 Penemuan tambang emas baru! Harga emas turun 8%.',
      '📈 Bitcoin mencapai ATH! Harga Bitcoin naik 40%.',
    ];
    String event = events[Random().nextInt(events.length)];
    berita.add('⚠️ EVENT: $event');

    if (event.contains('Tech Corp')) {
      hargaSaham['Tech Corp'] = (hargaSaham['Tech Corp']! * 1.3).clamp(100.0, 10000.0);
    } else if (event.contains('krisis ekonomi')) {
      for (var key in hargaSaham.keys) {
        hargaSaham[key] = (hargaSaham[key]! * 0.85).clamp(100.0, 10000.0);
      }
    } else if (event.contains('emas turun')) {
      hargaEmasPerGram *= 0.92;
    } else if (event.contains('Bitcoin')) {
      hargaKripto['Bitcoin'] = (hargaKripto['Bitcoin']! * 1.4).clamp(1000.0, 500000.0);
    }
  }

  void _generateMarketNews() {
    List<String> news = [
      '📊 Pasar saham mixed hari ini.',
      '💹 Indeks Dow Jones naik 0.5%.',
      '📉 Inflasi meningkat, bank sentral waspada.',
      '🏭 Sektor energi menunjukkan pertumbuhan.',
      '🛒 Konsumen lebih percaya diri.',
    ];
    berita.add(news[Random().nextInt(news.length)]);
    if (berita.length > 20) berita.removeAt(0);
  }

  // ---- FUNGSI TRANSAKSI ----
  void beliSaham(String nama, int jumlah) {
    setState(() {
      double harga = hargaSaham[nama]!;
      int totalBiaya = (harga * jumlah).round();
      if (character.money >= totalBiaya) {
        character.money -= totalBiaya;
        int count = saham[nama] ?? 0;
        double oldCost = count * (averageSahamBuyPrice[nama] ?? 0.0);
        double newCost = jumlah * harga;
        averageSahamBuyPrice[nama] = (oldCost + newCost) / (count + jumlah);
        saham[nama] = count + jumlah;
        berita.add('Beli $jumlah lembar $nama seharga \$${formatRupiah(totalBiaya)}');
        
        // Catat transaksi uang tunai
        character.cashTransactions.insert(0, {
          'amount': -totalBiaya,
          'desc': 'Beli Saham $nama ($jumlah lembar)',
        });
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void jualSaham(String nama, int jumlah) {
    setState(() {
      if ((saham[nama] ?? 0) >= jumlah) {
        double harga = hargaSaham[nama]!;
        int totalDapat = (harga * jumlah).round();
        character.money += totalDapat;
        saham[nama] = saham[nama]! - jumlah;
        if (saham[nama] == 0) {
          averageSahamBuyPrice[nama] = 0.0;
        }
        berita.add('Jual $jumlah lembar $nama seharga \$${formatRupiah(totalDapat)}');
        
        // Catat transaksi uang tunai
        character.cashTransactions.insert(0, {
          'amount': totalDapat,
          'desc': 'Jual Saham $nama ($jumlah lembar)',
        });
      } else {
        _showSnackbar('Saham tidak cukup!');
      }
    });
  }

  void beliEmas(double gram) {
    setState(() {
      int biaya = (hargaEmasPerGram * gram).round();
      if (character.money >= biaya) {
        character.money -= biaya;
        double oldCost = emasGram * averageEmasBuyPrice;
        double newCost = gram * hargaEmasPerGram;
        averageEmasBuyPrice = (oldCost + newCost) / (emasGram + gram);
        emasGram += gram;
        berita.add('Beli emas $gram gram');
        
        // Catat transaksi uang tunai
        character.cashTransactions.insert(0, {
          'amount': -biaya,
          'desc': 'Beli Emas (${gram.toStringAsFixed(2)} gram)',
        });
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void jualEmas(double gram) {
    setState(() {
      if (emasGram >= gram) {
        int hasil = (hargaEmasPerGram * gram).round();
        character.money += hasil;
        emasGram -= gram;
        if (emasGram == 0) {
          averageEmasBuyPrice = 0.0;
        }
        berita.add('Jual emas $gram gram');
        
        // Catat transaksi uang tunai
        character.cashTransactions.insert(0, {
          'amount': hasil,
          'desc': 'Jual Emas (${gram.toStringAsFixed(2)} gram)',
        });
      } else {
        _showSnackbar('Emas tidak cukup!');
      }
    });
  }

  void beliKripto(String nama, double jumlah) {
    setState(() {
      int biaya = (hargaKripto[nama]! * jumlah).round();
      if (character.money >= biaya) {
        character.money -= biaya;
        double count = kripto[nama] ?? 0.0;
        double oldCost = count * (averageKriptoBuyPrice[nama] ?? 0.0);
        double newCost = jumlah * hargaKripto[nama]!;
        averageKriptoBuyPrice[nama] = (oldCost + newCost) / (count + jumlah);
        kripto[nama] = count + jumlah;
        berita.add('Beli $jumlah $nama');
        
        // Catat transaksi uang tunai
        character.cashTransactions.insert(0, {
          'amount': -biaya,
          'desc': 'Beli Kripto $nama (${jumlah.toStringAsFixed(4)})',
        });
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void jualKripto(String nama, double jumlah) {
    setState(() {
      if ((kripto[nama] ?? 0) >= jumlah) {
        int hasil = (hargaKripto[nama]! * jumlah).round();
        character.money += hasil;
        kripto[nama] = kripto[nama]! - jumlah;
        if (kripto[nama] == 0.0) {
          averageKriptoBuyPrice[nama] = 0.0;
        }
        berita.add('Jual $jumlah $nama');
        
        // Catat transaksi uang tunai
        character.cashTransactions.insert(0, {
          'amount': hasil,
          'desc': 'Jual Kripto $nama (${jumlah.toStringAsFixed(4)})',
        });
      } else {
        _showSnackbar('Kripto tidak cukup!');
      }
    });
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---- UI ROOT (Tampilan daftar / Column) ----
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investasi'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: nextYear,
            tooltip: 'Update Harga Pasar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan kekayaan (seperti halaman lain)
            Card(
              color: isDark ? Colors.blue.shade900 : Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Kekayaan', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey)),
                    Text(
                      '\$${formatRupiah(totalKekayaan)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Text('Uang Tunai: \$${formatRupiah(character.money)}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Menu dalam bentuk daftar vertikal
            _buildMenuTile(
              icon: Icons.trending_up,
              label: 'Saham',
              subtitle: 'Beli & jual saham perusahaan',
              color: Colors.blue,
              onTap: () => _navigateTo(SahamPage(state: this)),
            ),
            const SizedBox(height: 8),
            _buildMenuTile(
              icon: Icons.monetization_on,
              label: 'Emas',
              subtitle: 'Investasi emas batangan',
              color: Colors.amber,
              onTap: () => _navigateTo(EmasPage(state: this)),
            ),
            const SizedBox(height: 8),
            _buildMenuTile(
              icon: Icons.currency_bitcoin,
              label: 'Kripto',
              subtitle: 'Trading cryptocurrency',
              color: Colors.orange,
              onTap: () => _navigateTo(KriptoPage(state: this)),
            ),
            const SizedBox(height: 8),
            _buildMenuTile(
              icon: Icons.pie_chart,
              label: 'Portofolio',
              subtitle: 'Lihat semua aset investasi',
              color: Colors.purple,
              onTap: () => _navigateTo(PortofolioPage(state: this)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Helper untuk menu tile (sama seperti di UangTunai & Kemewahan) ----
  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) {
      setState(() {});
    });
  }
}