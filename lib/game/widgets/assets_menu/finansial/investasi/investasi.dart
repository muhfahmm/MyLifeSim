// lib/game/widgets/assets_menu/finansial/investasi/investasi.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// ============================================================
// PART FILES (setiap menu akan menjadi part)
// ============================================================
part 'menu_grid_investasi/saham/saham.dart';
part 'menu_grid_investasi/reksa_dana/reksa_dana.dart';
part 'menu_grid_investasi/properti/properti.dart';
part 'menu_grid_investasi/emas/emas.dart';
part 'menu_grid_investasi/kripto/kripto.dart';
part 'menu_grid_investasi/deposito/deposito.dart';
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

Widget _buildCashHeader(dynamic state, {String? assetType}) {
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
  } else if (assetType == 'reksa') {
    returnVal = state.reksaDanaReturn;
    showReturn = true;
  } else if (assetType == 'properti') {
    double propertiReturn = 0;
    for (var p in state.properti) {
      int hargaJual = ((p['hargaBeli'] as num).toDouble() * (1 + (p['kenaikan'] as num).toDouble() / 100)).round();
      propertiReturn += hargaJual - (p['hargaBeli'] as num);
    }
    returnVal = propertiReturn;
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
  } else if (assetType == 'deposito') {
    double depositoReturn = 0;
    for (var d in state.deposito) {
      int tahun = state.character.age - (d['tahunMulai'] as int);
      depositoReturn += (d['jumlah'] as num).toDouble() * (d['bunga'] as num).toDouble() / 100 * tahun;
    }
    returnVal = depositoReturn;
    showReturn = true;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: Colors.green.shade50,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Uang Tunai:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('\$${formatRupiah(state.character.money)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        if (showReturn) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(returnVal >= 0 ? 'Return:' : 'Loss:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: returnVal >= 0 ? Colors.blue : Colors.red)),
              Text(
                '${returnVal >= 0 ? '+' : ''}\$${formatRupiah(returnVal.abs())}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: returnVal >= 0 ? Colors.blue : Colors.red),
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
  const InvestasiItem({super.key, required this.character});

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
        );
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

  // ---- DATA INVESTASI (state bersama untuk semua menu) ----
  Map<String, int> saham = {};
  Map<String, double> hargaSaham = {};
  Map<String, double> averageSahamBuyPrice = {};

  double reksaDanaInvestasi = 0;
  String risikoReksa = 'Sedang';
  double reksaDanaReturn = 0;

  List<Map<String, dynamic>> properti = [];

  double emasGram = 0;
  double hargaEmasPerGram = 0;
  double averageEmasBuyPrice = 0.0;

  Map<String, double> kripto = {};
  Map<String, double> hargaKripto = {};
  Map<String, double> averageKriptoBuyPrice = {};

  List<Map<String, dynamic>> deposito = [];

  List<String> berita = [];

  double get totalKekayaan {
    double total = character.money.toDouble();
    saham.forEach((nama, jumlah) {
      total += jumlah * (hargaSaham[nama] ?? 0);
    });
    total += reksaDanaInvestasi + reksaDanaReturn;
    for (var p in properti) {
      total += (p['hargaBeli'] as num).toDouble() * (1 + (p['kenaikan'] as num).toDouble() / 100);
    }
    total += emasGram * hargaEmasPerGram;
    kripto.forEach((nama, jumlah) {
      total += jumlah * (hargaKripto[nama] ?? 0);
    });
    for (var d in deposito) {
      int tahunBerjalan = character.age - (d['tahunMulai'] as int);
      double bunga = (d['jumlah'] as num).toDouble() * (d['bunga'] as num).toDouble() / 100 * tahunBerjalan;
      total += (d['jumlah'] as num).toDouble() + bunga;
    }
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
      saham[s] = 0;
    }
    hargaEmasPerGram = (800000 + Random().nextInt(400000)).toDouble();
    final List<String> kriptoList = ['Bitcoin', 'Ethereum', 'Dogecoin', 'Solana'];
    for (var k in kriptoList) {
      hargaKripto[k] = (10000 + Random().nextInt(90000)).toDouble();
      kripto[k] = 0;
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

      // Update reksa dana
      double returnRate;
      switch (risikoReksa) {
        case 'Rendah':
          returnRate = 0.05 + (Random().nextDouble() * 0.03 - 0.015);
          break;
        case 'Sedang':
          returnRate = 0.10 + (Random().nextDouble() * 0.06 - 0.03);
          break;
        case 'Tinggi':
          returnRate = 0.15 + (Random().nextDouble() * 0.10 - 0.05);
          break;
        default:
          returnRate = 0.08;
      }
      reksaDanaReturn += reksaDanaInvestasi * returnRate;

      // Update properti
      for (var p in properti) {
        double kenaikan = 5 + Random().nextDouble() * 10;
        p['kenaikan'] = (p['kenaikan'] as num).toDouble() + kenaikan;
        double sewaNaik = 3 + Random().nextDouble() * 2;
        p['hargaSewa'] = ((p['hargaSewa'] as num).toDouble() * (1 + sewaNaik / 100)).round();
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
      '🏠 Gelembung properti pecah! Harga properti turun 10%.',
      '💰 Penemuan tambang emas baru! Harga emas turun 8%.',
      '📈 Bitcoin mencapai ATH! Harga Bitcoin naik 40%.',
      '🏦 Suku bunga naik, deposito lebih menguntungkan.',
    ];
    String event = events[Random().nextInt(events.length)];
    berita.add('⚠️ EVENT: $event');

    if (event.contains('Tech Corp')) {
      hargaSaham['Tech Corp'] = (hargaSaham['Tech Corp']! * 1.3).clamp(100.0, 10000.0);
    } else if (event.contains('krisis ekonomi')) {
      for (var key in hargaSaham.keys) {
        hargaSaham[key] = (hargaSaham[key]! * 0.85).clamp(100.0, 10000.0);
      }
    } else if (event.contains('properti turun')) {
      for (var p in properti) {
        p['kenaikan'] = (p['kenaikan'] as num).toDouble() - 10;
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
      } else {
        _showSnackbar('Kripto tidak cukup!');
      }
    });
  }

  void investasiReksaDana(double jumlah, String risiko) {
    setState(() {
      if (character.money >= jumlah.toInt()) {
        character.money -= jumlah.toInt();
        reksaDanaInvestasi += jumlah;
        risikoReksa = risiko;
        berita.add('Investasi Reksa Dana sebesar \$${formatRupiah(jumlah)} (risiko $risiko)');
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void cairkanReksaDana() {
    setState(() {
      double nilai = reksaDanaInvestasi + reksaDanaReturn;
      character.money += nilai.toInt();
      reksaDanaInvestasi = 0;
      reksaDanaReturn = 0;
      berita.add('Cairkan Reksa Dana senilai \$${formatRupiah(nilai)}');
    });
  }

  void beliProperti(String nama, int harga, int sewa) {
    setState(() {
      if (character.money >= harga) {
        character.money -= harga;
        properti.add({
          'nama': nama,
          'hargaBeli': harga,
          'hargaSewa': sewa,
          'kenaikan': 0.0,
        });
        berita.add('Beli properti $nama seharga \$${formatRupiah(harga)}');
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void jualProperti(int index) {
    setState(() {
      var p = properti[index];
      int hargaJual = ((p['hargaBeli'] as num).toDouble() * (1 + (p['kenaikan'] as num).toDouble() / 100)).round();
      character.money += hargaJual;
      properti.removeAt(index);
      berita.add('Jual properti ${p['nama']} seharga \$${formatRupiah(hargaJual)}');
    });
  }

  void buatDeposito(int jumlah, int tenor, double bunga) {
    setState(() {
      if (character.money >= jumlah) {
        character.money -= jumlah;
        deposito.add({
          'jumlah': jumlah,
          'tenor': tenor,
          'bunga': bunga,
          'tahunMulai': character.age,
        });
        berita.add('Buka deposito \$${formatRupiah(jumlah)}, tenor $tenor tahun, bunga $bunga%');
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---- UI ROOT (Grid Menu) ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investasi'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: nextYear,
            tooltip: 'Tahun Berikutnya',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Kekayaan', style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                    Text(
                      '\$${formatRupiah(totalKekayaan)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Text('Uang Tunai: \$${formatRupiah(character.money)}'),
                    Text('Usia: ${character.age} tahun'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildMenuCard(Icons.trending_up, 'Saham', () => _navigateTo(SahamPage(state: this))),
                _buildMenuCard(Icons.account_balance, 'Reksa Dana', () => _navigateTo(ReksaDanaPage(state: this))),
                _buildMenuCard(Icons.house, 'Properti', () => _navigateTo(PropertiPage(state: this))),
                _buildMenuCard(Icons.monetization_on, 'Emas', () => _navigateTo(EmasPage(state: this))),
                _buildMenuCard(Icons.currency_bitcoin, 'Kripto', () => _navigateTo(KriptoPage(state: this))),
                _buildMenuCard(Icons.savings, 'Deposito', () => _navigateTo(DepositoPage(state: this))),
                _buildMenuCard(Icons.pie_chart, 'Portofolio', () => _navigateTo(PortofolioPage(state: this))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String label, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}