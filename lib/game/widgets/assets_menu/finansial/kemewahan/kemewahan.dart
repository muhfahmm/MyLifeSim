// lib/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// ============================================================
// PART FILES
// ============================================================
part 'menu_kemewahan/perhiasan/perhiasan_mewah.dart';
part 'menu_kemewahan/kendaraan_mewah/kendaraan_mewah.dart';
part 'menu_kemewahan/properti_eksklusif/properti_eksklusif.dart';
part 'menu_kemewahan/koleksi_seni_antik/koleksi_antik.dart';
part 'menu_kemewahan/gaya_hidup_premium/gaya_hidup_premium.dart';
part 'menu_kemewahan/filantropi/filantropi.dart';
part 'menu_kemewahan/koleksi_digital_nft/nft.dart';
part 'menu_kemewahan/layanan_pribadi/layanan_pribadi.dart';

// ============================================================
// UTILITY FORMAT RUPIAH
// ============================================================
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

// ============================================================
// WIDGET ITEM KEMEWAHAN (dashboard)
// ============================================================
class KemewahanItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const KemewahanItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 15;

    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Kemewahan', 15);
          return;
        }
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KemewahanPage(character: character),
          ),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.purple.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.purple.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.diamond, color: isUnlocked ? Colors.purple : Colors.grey, size: 28),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Kemewahan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '\$${formatRupiah(character.money)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.purple : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isUnlocked ? Icons.check_circle : Icons.lock,
              color: isUnlocked ? Colors.green : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey, size: 28),
            SizedBox(width: 8),
            Text('Fitur Terkunci', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur $feature akan terbuka saat karakter berusia $requiredAge tahun.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Usia saat ini: ${character.age} tahun',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HALAMAN KEMEWAHAN UTAMA (ROOT)
// ============================================================
class KemewahanPage extends StatefulWidget {
  final Character character;
  const KemewahanPage({super.key, required this.character});

  @override
  State<KemewahanPage> createState() => _KemewahanPageState();
}

class _KemewahanPageState extends State<KemewahanPage> {
  late Character character;

  // ---- DATA KEPEMILIKAN ----
  List<Map<String, dynamic>> perhiasan = [];
  List<Map<String, dynamic>> kendaraan = [];
  List<Map<String, dynamic>> propertiEksklusif = [];
  List<Map<String, dynamic>> koleksiSeni = [];
  List<Map<String, dynamic>> keanggotaan = [];
  List<Map<String, dynamic>> donasi = [];
  List<Map<String, dynamic>> koleksiDigital = [];
  List<Map<String, dynamic>> layananPribadi = [];

  List<String> penghargaan = [];

  // ---- DATA ITEM (DAFTAR YANG TERSEDIA UNTUK DIBELI) ----
  final List<Map<String, dynamic>> _perhiasanData = [
    {'nama': 'Jam Tangan Rolex', 'harga': 50000000, 'happiness': 15},
    {'nama': 'Kalung Berlian', 'harga': 75000000, 'happiness': 20},
    {'nama': 'Tas Hermès Birkin', 'harga': 120000000, 'happiness': 25},
    {'nama': 'Cincin Emas 24K', 'harga': 15000000, 'happiness': 10},
    {'nama': 'Koleksi Perhiasan Eksklusif', 'harga': 300000000, 'happiness': 30},
  ];

  final List<Map<String, dynamic>> _kendaraanData = [
    {'nama': 'Ferrari F8', 'harga': 2000000000, 'happiness': 25},
    {'nama': 'Lamborghini Aventador', 'harga': 3500000000, 'happiness': 30},
    {'nama': 'Rolls Royce Phantom', 'harga': 4000000000, 'happiness': 35},
    {'nama': 'Yacht 50 Kaki', 'harga': 7500000000, 'happiness': 40},
    {'nama': 'Jet Pribadi', 'harga': 15000000000, 'happiness': 50},
  ];

  final List<Map<String, dynamic>> _propertiData = [
    {'nama': 'Villa di Bali', 'harga': 5000000000, 'happiness': 30},
    {'nama': 'Penthouse di Jakarta', 'harga': 8000000000, 'happiness': 35},
    {'nama': 'Kastil di Eropa', 'harga': 15000000000, 'happiness': 45},
    {'nama': 'Pulau Pribadi', 'harga': 50000000000, 'happiness': 60},
  ];

  final List<Map<String, dynamic>> _seniData = [
    {'nama': 'Lukisan Monalisa (replika)', 'harga': 1000000000, 'happiness': 20},
    {'nama': 'Patung David (replika)', 'harga': 800000000, 'happiness': 18},
    {'nama': 'Koleksi Lukisan Modern', 'harga': 2000000000, 'happiness': 25},
    {'nama': 'Barang Antik Eropa', 'harga': 1500000000, 'happiness': 22},
  ];

  final List<Map<String, dynamic>> _keanggotaanData = [
    {'nama': 'Klub Golf Eksklusif', 'harga': 20000000, 'happiness': 12},
    {'nama': 'Spa Premium', 'harga': 15000000, 'happiness': 10},
    {'nama': 'Gym Elite', 'harga': 10000000, 'happiness': 8},
    {'nama': 'Klub Malam VIP', 'harga': 25000000, 'happiness': 15},
  ];

  final List<Map<String, dynamic>> _digitalData = [
    {'nama': 'NFT Karya Seni', 'harga': 50000000, 'happiness': 15},
    {'nama': 'NFT Koleksi Game', 'harga': 30000000, 'happiness': 12},
    {'nama': 'NFT Domain Premium', 'harga': 100000000, 'happiness': 20},
    {'nama': 'Koleksi Crypto Art', 'harga': 75000000, 'happiness': 18},
  ];

  final List<Map<String, dynamic>> _layananData = [
    {'nama': 'Asisten Pribadi', 'harga': 15000000, 'happiness': 15},
    {'nama': 'Koki Pribadi', 'harga': 12000000, 'happiness': 12},
    {'nama': 'Sopir Pribadi', 'harga': 10000000, 'happiness': 10},
    {'nama': 'Penata Gaya', 'harga': 8000000, 'happiness': 8},
  ];

  // ---- TOTAL ASET ----
  double get totalNilaiKemewahan {
    double total = 0;
    for (var item in perhiasan) { total += (item['harga'] as num).toDouble(); }
    for (var item in kendaraan) { total += (item['harga'] as num).toDouble(); }
    for (var item in propertiEksklusif) { total += (item['harga'] as num).toDouble(); }
    for (var item in koleksiSeni) { total += (item['harga'] as num).toDouble(); }
    for (var item in koleksiDigital) { total += (item['harga'] as num).toDouble(); }
    return total;
  }

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _checkAchievements();
  }

  // ---- PENCAPAIAN ----
  void _checkAchievements() {
    List<String> newAchievements = [];
    if (perhiasan.length >= 3 && !penghargaan.contains('Kolektor Perhiasan')) newAchievements.add('💎 Kolektor Perhiasan');
    if (kendaraan.length >= 2 && !penghargaan.contains('Pecinta Otomotif')) newAchievements.add('🚗 Pecinta Otomotif');
    if (propertiEksklusif.length >= 1 && !penghargaan.contains('Pemilik Properti Mewah')) newAchievements.add('🏰 Pemilik Properti Mewah');
    if (koleksiSeni.length >= 2 && !penghargaan.contains('Kolektor Seni')) newAchievements.add('🖼️ Kolektor Seni');
    if (donasi.fold<int>(0, (sum, d) => sum + (d['jumlah'] as int)) >= 5000000 && !penghargaan.contains('Dermawan')) newAchievements.add('🎗️ Dermawan');
    if (koleksiDigital.length >= 1 && !penghargaan.contains('NFT Enthusiast')) newAchievements.add('💻 NFT Enthusiast');
    if (newAchievements.isNotEmpty) {
      setState(() {
        penghargaan.addAll(newAchievements);
        character.happiness = (character.happiness + 5 * newAchievements.length).clamp(0, 100);
      });
      String msg = '🏆 Penghargaan baru: ${newAchievements.join(', ')}!';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  // ---- FUNGSI TRANSAKSI ----
  void beliPerhiasan(Map<String, dynamic> item) {
    _buyItem('perhiasan', item);
  }

  void beliKendaraan(Map<String, dynamic> item) {
    _buyItem('kendaraan', item);
  }

  void beliProperti(Map<String, dynamic> item) {
    _buyItem('properti', item);
  }

  void beliSeni(Map<String, dynamic> item) {
    _buyItem('seni', item);
  }

  void beliKeanggotaan(Map<String, dynamic> item) {
    setState(() {
      int harga = (item['harga'] as num).toInt();
      if (character.money >= harga) {
        character.money -= harga;
        keanggotaan.add(item);
        int h = item['happiness'] ?? 8;
        character.happiness = (character.happiness + h).clamp(0, 100);
        _checkAchievements();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bergabung dengan ${item['nama']}! +$h Happiness')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      }
    });
  }

  void beliDigital(Map<String, dynamic> item) {
    _buyItem('digital', item);
  }

  void beliLayanan(Map<String, dynamic> item) {
    setState(() {
      int harga = (item['harga'] as num).toInt();
      if (character.money >= harga) {
        character.money -= harga;
        layananPribadi.add(item);
        int h = item['happiness'] ?? 10;
        character.happiness = (character.happiness + h).clamp(0, 100);
        _checkAchievements();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menyewa ${item['nama']}! +$h Happiness')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      }
    });
  }

  void lakukanDonasi(int nominal) {
    setState(() {
      if (character.money >= nominal) {
        character.money -= nominal;
        donasi.add({'jumlah': nominal, 'tanggal': DateTime.now()});
        int bonus = 10 + (nominal ~/ 1000000) * 2;
        character.happiness = (character.happiness + bonus).clamp(0, 100);
        _checkAchievements();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Donasi \$${formatRupiah(nominal)} berhasil! +$bonus Happiness')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      }
    });
  }

  void _buyItem(String category, Map<String, dynamic> item) {
    setState(() {
      int harga = (item['harga'] as num).toInt();
      if (character.money >= harga) {
        character.money -= harga;
        switch (category) {
          case 'perhiasan': perhiasan.add(item); break;
          case 'kendaraan': kendaraan.add(item); break;
          case 'properti': propertiEksklusif.add(item); break;
          case 'seni': koleksiSeni.add(item); break;
          case 'digital': koleksiDigital.add(item); break;
        }
        int bonus = item['happiness'] ?? 10;
        character.happiness = (character.happiness + bonus).clamp(0, 100);
        _checkAchievements();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil membeli ${item['nama']}! +$bonus Happiness')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang tidak cukup!')));
      }
    });
  }


  // ---- HELPER GENERIK UNTUK MENAMPILKAN DAFTAR ITEM ----
  // Fungsi ini akan dipanggil oleh masing-masing part file untuk menampilkan halaman belanja.
  Widget _buildItemPage({
    required String title,
    required List<Map<String, dynamic>> items,
    required List<Map<String, dynamic>> ownedItems,
    required void Function(Map<String, dynamic>) onBuy,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          bool owned = ownedItems.any((e) => e['nama'] == item['nama']);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga: \$${formatRupiah(item['harga'])}'),
                  Text('+${item['happiness']} Happiness', style: const TextStyle(color: Colors.green)),
                ],
              ),
              trailing: owned
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : ElevatedButton(
                      onPressed: () {
                        onBuy(item);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      child: const Text('Beli', style: TextStyle(color: Colors.white)),
                    ),
            ),
          );
        },
      ),
    );
  }

  // ---- UI ROOT ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kemewahan'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Aset Kemewahan', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('\$${formatRupiah(totalNilaiKemewahan)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple)),
                    const SizedBox(height: 8),
                    Text('Uang Tunai: \$${formatRupiah(character.money)}'),
                    Text('Penghargaan: ${penghargaan.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Menu daftar (mengarah ke part files)
            _buildMenuTile(
              icon: Icons.weekend,
              label: 'Perhiasan & Aksesori Mewah',
              subtitle: 'Koleksi perhiasan, jam tangan, tas desainer',
              color: Colors.pink,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PerhiasanMewahPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.directions_car,
              label: 'Kendaraan Mewah',
              subtitle: 'Mobil sport, yacht, jet pribadi',
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KendaraanMewahPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.holiday_village,
              label: 'Properti Eksklusif',
              subtitle: 'Villa, penthouse, pulau pribadi',
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertiEksklusifPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.art_track,
              label: 'Koleksi Seni & Antik',
              subtitle: 'Lukisan, patung, barang antik',
              color: Colors.red,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KoleksiAntikPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.sports_golf,
              label: 'Gaya Hidup Premium',
              subtitle: 'Klub, spa, gym elit',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GayaHidupPremiumPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.favorite,
              label: 'Filantropi',
              subtitle: 'Donasi untuk amal dan yayasan',
              color: Colors.redAccent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FilantropiPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.image,
              label: 'Koleksi Digital & NFT',
              subtitle: 'Karya seni digital, NFT, domain premium',
              color: Colors.cyan,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NFTPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.person,
              label: 'Layanan Pribadi',
              subtitle: 'Asisten, koki, sopir, penata gaya',
              color: Colors.indigo,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LayananPribadiPage(state: this))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}