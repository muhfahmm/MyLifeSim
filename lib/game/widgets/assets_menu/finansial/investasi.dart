// lib/game/widgets/assets_menu/finansial/investasi.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll('.', '');
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
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}

int parseRupiah(String value) {
  return int.tryParse(value.replaceAll('.', '').trim()) ?? 0;
}

String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(parts[i]);
  }
  final formatted = buffer.toString();
  return value < 0 ? '-$formatted' : formatted;
}

// Widget item untuk ditampilkan di dashboard
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
        navigator.pop();
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
// HALAMAN INVESTASI UTAMA
// ============================================================
class InvestasiPage extends StatefulWidget {
  final Character character;
  const InvestasiPage({super.key, required this.character});

  @override
  State<InvestasiPage> createState() => _InvestasiPageState();
}

class _InvestasiPageState extends State<InvestasiPage> {
  late Character character;

  // ---- DATA INVESTASI ----
  Map<String, int> saham = {};
  Map<String, double> hargaSaham = {};

  double reksaDanaInvestasi = 0;
  String risikoReksa = 'Sedang';
  double reksaDanaReturn = 0;

  List<Map<String, dynamic>> properti = [];

  double emasGram = 0;
  double hargaEmasPerGram = 0;

  Map<String, double> kripto = {};
  Map<String, double> hargaKripto = {};

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

  void nextYear() {
    setState(() {
      for (var key in hargaSaham.keys) {
        double change = (Random().nextDouble() * 0.4) - 0.2;
        hargaSaham[key] = (hargaSaham[key]! * (1 + change)).clamp(100.0, 10000.0);
      }

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

      for (var p in properti) {
        double kenaikan = 5 + Random().nextDouble() * 10;
        p['kenaikan'] = (p['kenaikan'] as num).toDouble() + kenaikan;
        double sewaNaik = 3 + Random().nextDouble() * 2;
        p['hargaSewa'] = ((p['hargaSewa'] as num).toDouble() * (1 + sewaNaik / 100)).round();
      }

      double emasChange = (Random().nextDouble() * 0.10) - 0.05;
      hargaEmasPerGram = (hargaEmasPerGram * (1 + emasChange)).clamp(500000.0, 2000000.0);

      for (var key in hargaKripto.keys) {
        double change = (Random().nextDouble() * 1.0) - 0.5;
        hargaKripto[key] = (hargaKripto[key]! * (1 + change)).clamp(1000.0, 500000.0);
      }

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
        saham[nama] = (saham[nama] ?? 0) + jumlah;
        berita.add('Beli $jumlah lembar $nama seharga Rp ${formatRupiah(totalBiaya)}');
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
        berita.add('Jual $jumlah lembar $nama seharga Rp ${formatRupiah(totalDapat)}');
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
        kripto[nama] = (kripto[nama] ?? 0) + jumlah;
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
        berita.add('Investasi Reksa Dana sebesar Rp ${jumlah.toString()} (risiko $risiko)');
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
      berita.add('Cairkan Reksa Dana senilai Rp ${nilai.toInt().toString()}');
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
        berita.add('Beli properti $nama seharga Rp ${formatRupiah(harga)}');
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
      berita.add('Jual properti ${p['nama']} seharga Rp ${formatRupiah(hargaJual)}');
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
        berita.add('Buka deposito Rp ${formatRupiah(jumlah)}, tenor $tenor tahun, bunga $bunga%');
      } else {
        _showSnackbar('Uang tidak cukup!');
      }
    });
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---- UI ----
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
                      'Rp ${formatRupiah(totalKekayaan)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Text('Uang Tunai: Rp ${formatRupiah(character.money)}'),
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
                _buildMenuCard(Icons.support_agent, 'Konsultasi', () => _navigateTo(KonsultasiPage(state: this))),
                _buildMenuCard(Icons.newspaper, 'Berita', () => _navigateTo(BeritaPage(state: this))),
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

// ============================================================
// HALAMAN-HALAMAN MENU INVESTASI
// ============================================================

// ---- SAHAM ----
class SahamPage extends StatefulWidget {
  final _InvestasiPageState state;
  const SahamPage({super.key, required this.state});

  @override
  State<SahamPage> createState() => _SahamPageState();
}

class _SahamPageState extends State<SahamPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(title: const Text('Saham'), backgroundColor: Colors.blue),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.hargaSaham.keys.length,
        itemBuilder: (ctx, i) {
          String nama = state.hargaSaham.keys.elementAt(i);
          double harga = state.hargaSaham[nama]!;
          int jumlah = state.saham[nama] ?? 0;
          return Card(
            child: ListTile(
              title: Text(nama),
              subtitle: Text('Harga: Rp ${formatRupiah(harga)}\nJumlah: $jumlah lembar'),
              trailing: ElevatedButton(
                onPressed: () => _showBuySahamDialog(context, nama),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                child: const Text('Beli'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBuySahamDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '1');
    final state = widget.state;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Beli Saham $nama'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga saat ini: Rp ${formatRupiah(state.hargaSaham[nama]!)}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah lembar',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final jumlah = int.tryParse(controller.text) ?? 0;
              if (jumlah > 0) {
                state.beliSaham(nama, jumlah);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }
}

// ---- REKSA DANA ----
class ReksaDanaPage extends StatelessWidget {
  final _InvestasiPageState state;
  const ReksaDanaPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reksa Dana'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Investasi: Rp ${formatRupiah(state.reksaDanaInvestasi)}'),
            Text('Return: Rp ${formatRupiah(state.reksaDanaReturn)}'),
            Text('Total: Rp ${formatRupiah(state.reksaDanaInvestasi + state.reksaDanaReturn)}'),
            const SizedBox(height: 20),
            const Text('Pilih Risiko:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['Rendah', 'Sedang', 'Tinggi'].map((r) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(r),
                    value: r,
                    groupValue: state.risikoReksa,
                    onChanged: (val) {
                      // Ubah risiko saja, tidak langsung investasi
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showInvestDialog(context, state);
              },
              child: const Text('Investasi Baru'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: state.cairkanReksaDana,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cairkan Semua'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvestDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController controller = TextEditingController();
    String selectedRisiko = state.risikoReksa;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Investasi Reksa Dana'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRisiko,
              items: ['Rendah', 'Sedang', 'Tinggi'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => selectedRisiko = val!,
              decoration: const InputDecoration(labelText: 'Risiko'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              int jumlah = parseRupiah(controller.text);
              if (jumlah > 0) {
                state.investasiReksaDana(jumlah.toDouble(), selectedRisiko);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Investasi'),
          ),
        ],
      ),
    );
  }
}

// ---- PROPERTI ----
class PropertiPage extends StatefulWidget {
  final _InvestasiPageState state;
  const PropertiPage({super.key, required this.state});

  @override
  State<PropertiPage> createState() => _PropertiPageState();
}

class _PropertiPageState extends State<PropertiPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(title: const Text('Properti'), backgroundColor: Colors.blue),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.properti.length + 1,
        itemBuilder: (ctx, i) {
          if (i == state.properti.length) {
            return ElevatedButton(
              onPressed: () => _showBeliPropertiDialog(context, state),
              child: const Text('Beli Properti Baru'),
            );
          }
          var p = state.properti[i];
          return Card(
            child: ListTile(
              title: Text(p['nama']),
              subtitle: Text('Harga beli: Rp ${formatRupiah(p['hargaBeli'] as num)}\nSewa: Rp ${formatRupiah(p['hargaSewa'] as num)}/bulan\nKenaikan: ${(p['kenaikan'] as num).toStringAsFixed(1)}%'),
              trailing: IconButton(
                icon: const Icon(Icons.sell, color: Colors.red),
                onPressed: () => state.jualProperti(i),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBeliPropertiDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController namaCtrl = TextEditingController();
    TextEditingController hargaCtrl = TextEditingController();
    TextEditingController sewaCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Beli Properti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Properti')),
            TextField(
              controller: hargaCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Harga Beli'),
            ),
            TextField(
              controller: sewaCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Sewa Bulanan'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              String nama = namaCtrl.text;
              int harga = parseRupiah(hargaCtrl.text);
              int sewa = parseRupiah(sewaCtrl.text);
              if (nama.isNotEmpty && harga > 0 && sewa > 0) {
                state.beliProperti(nama, harga, sewa);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }
}

// ---- EMAS ----
class EmasPage extends StatefulWidget {
  final _InvestasiPageState state;
  const EmasPage({super.key, required this.state});

  @override
  State<EmasPage> createState() => _EmasPageState();
}

class _EmasPageState extends State<EmasPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(title: const Text('Emas'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga Emas: Rp ${formatRupiah(state.hargaEmasPerGram)}/gram'),
            Text('Emas yang dimiliki: ${state.emasGram.toStringAsFixed(2)} gram'),
            Text('Nilai: Rp ${formatRupiah(state.emasGram * state.hargaEmasPerGram)}'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBeliEmasDialog(context, state),
                    icon: const Icon(Icons.add),
                    label: const Text('Beli'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showJualEmasDialog(context, state),
                    icon: const Icon(Icons.remove),
                    label: const Text('Jual'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBeliEmasDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Beli Emas'),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gram')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              double gram = double.tryParse(ctrl.text) ?? 0;
              if (gram > 0) {
                state.beliEmas(gram);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }

  void _showJualEmasDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Jual Emas'),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gram')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              double gram = double.tryParse(ctrl.text) ?? 0;
              if (gram > 0) {
                state.jualEmas(gram);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Jual'),
          ),
        ],
      ),
    );
  }
}

// ---- KRIPTO ----
class KriptoPage extends StatefulWidget {
  final _InvestasiPageState state;
  const KriptoPage({super.key, required this.state});

  @override
  State<KriptoPage> createState() => _KriptoPageState();
}

class _KriptoPageState extends State<KriptoPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(title: const Text('Kripto'), backgroundColor: Colors.blue),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.hargaKripto.keys.length,
        itemBuilder: (ctx, i) {
          String nama = state.hargaKripto.keys.elementAt(i);
          double harga = state.hargaKripto[nama]!;
          double jumlah = state.kripto[nama] ?? 0;
          return Card(
            child: ListTile(
              title: Text(nama),
              subtitle: Text('Harga: Rp ${formatRupiah(harga)}\nJumlah: ${jumlah.toStringAsFixed(4)}'),
              trailing: ElevatedButton(
                onPressed: () => _showBuyKriptoDialog(context, nama),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                child: const Text('Beli'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBuyKriptoDialog(BuildContext context, String nama) {
    final controller = TextEditingController(text: '0.01');
    final state = widget.state;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Beli Kripto $nama'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga saat ini: Rp ${formatRupiah(state.hargaKripto[nama]!)}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final jumlah = double.tryParse(controller.text) ?? 0;
              if (jumlah > 0) {
                state.beliKripto(nama, jumlah);
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }
}

// ---- DEPOSITO ----
class DepositoPage extends StatelessWidget {
  final _InvestasiPageState state;
  const DepositoPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposito'), backgroundColor: Colors.blue),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.deposito.length + 1,
        itemBuilder: (ctx, i) {
          if (i == state.deposito.length) {
            return ElevatedButton(
              onPressed: () => _showBukaDepositoDialog(context, state),
              child: const Text('Buka Deposito Baru'),
            );
          }
          var d = state.deposito[i];
          int tahunBerjalan = state.character.age - (d['tahunMulai'] as int);
          double bungaTotal = (d['jumlah'] as num).toDouble() * (d['bunga'] as num).toDouble() / 100 * tahunBerjalan;
          return Card(
            child: ListTile(
              title: Text('Tenor ${d['tenor']} tahun'),
              subtitle: Text('Pokok: Rp ${formatRupiah(d['jumlah'] as num)}\nBunga: ${d['bunga']}%\nBunga terkumpul: Rp ${formatRupiah(bungaTotal)}'),
            ),
          );
        },
      ),
    );
  }

  void _showBukaDepositoDialog(BuildContext context, _InvestasiPageState state) {
    TextEditingController jumlahCtrl = TextEditingController();
    int selectedTenor = 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buka Deposito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: selectedTenor,
              items: [1, 3, 5].map((t) => DropdownMenuItem(value: t, child: Text('$t tahun'))).toList(),
              onChanged: (val) => selectedTenor = val!,
              decoration: const InputDecoration(labelText: 'Tenor'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              int jumlah = parseRupiah(jumlahCtrl.text);
              if (jumlah > 0) {
                double bunga = selectedTenor == 1 ? 4 : (selectedTenor == 3 ? 5 : 6);
                state.buatDeposito(jumlah, selectedTenor, bunga);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Buka'),
          ),
        ],
      ),
    );
  }
}

// ---- PORTOFOLIO ----
class PortofolioPage extends StatelessWidget {
  final _InvestasiPageState state;
  const PortofolioPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portofolio'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Kekayaan: Rp ${formatRupiah(state.totalKekayaan)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildRow('Uang Tunai', state.character.money),
            _buildRow(
              'Saham',
              state.saham.entries.fold<int>(0, (sum, entry) {
                final harga = state.hargaSaham[entry.key] ?? 0.0;
                return sum + (entry.value * harga).round();
              }),
            ),
            _buildRow('Reksa Dana', (state.reksaDanaInvestasi + state.reksaDanaReturn).round()),
            _buildRow(
              'Properti',
              state.properti.fold<int>(
                0,
                (sum, p) => sum + ((p['hargaBeli'] as num).toDouble() * (1 + (p['kenaikan'] as num).toDouble() / 100)).round(),
              ),
            ),
            _buildRow('Emas', (state.emasGram * state.hargaEmasPerGram).round()),
            _buildRow(
              'Kripto',
              state.kripto.entries.fold<int>(
                0,
                (sum, entry) => sum + (entry.value * (state.hargaKripto[entry.key] ?? 0.0)).round(),
              ),
            ),
            _buildRow('Deposito', state.deposito.fold<int>(0, (sum, d) {
              int tahun = state.character.age - (d['tahunMulai'] as int);
              double bunga = (d['jumlah'] as num).toDouble() * (d['bunga'] as num).toDouble() / 100 * tahun;
              return sum + ((d['jumlah'] as num).toDouble() + bunga).round();
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text('Rp ${formatRupiah(value)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---- KONSULTASI ----
class KonsultasiPage extends StatelessWidget {
  final _InvestasiPageState state;
  const KonsultasiPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konsultasi Keuangan'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Bayar Rp 500.000 untuk mendapatkan saran investasi.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (state.character.money >= 500000) {
                  state.character.money -= 500000;
                  List<String> saran = [
                    'Saran: Beli saham Tech Corp, prospek cerah.',
                    'Saran: Jual properti di daerah padat, harga akan turun.',
                    'Saran: Investasi emas untuk lindung nilai inflasi.',
                    'Saran: Kripto terlalu volatil, hindari.',
                    'Saran: Deposito jangka panjang aman.',
                  ];
                  String pesan = saran[Random().nextInt(saran.length)];
                  state.berita.add('💡 Konsultasi: $pesan');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
                }
              },
              child: const Text('Konsultasi (Rp 500.000)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- BERITA ----
class BeritaPage extends StatelessWidget {
  final _InvestasiPageState state;
  const BeritaPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berita Pasar'), backgroundColor: Colors.blue),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.berita.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.newspaper),
            title: Text(state.berita[i]),
          ),
        ),
      ),
    );
  }
}
