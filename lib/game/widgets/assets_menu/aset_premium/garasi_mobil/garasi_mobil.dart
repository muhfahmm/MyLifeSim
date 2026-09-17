// lib/game/widgets/assets_menu/aset_premium/garasi_mobil/garasi_mobil.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/assets_menu/aset_premium/garasi_mobil/database_mobil.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

// ============================================================
// PART FILES
// ============================================================
part 'menu_garasi/koleksi_mobil.dart';
part 'menu_garasi/jual_beli_mobil.dart';
part 'menu_garasi/showroom.dart';

// ============================================================
// UTILITY FORMAT RUPIAH
// ============================================================
String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
    buffer.write(parts[i]);
  }
  return value < 0 ? '-${buffer.toString()}' : buffer.toString();
}

// ============================================================
// WIDGET ITEM GARASI MOBIL (dashboard)
// ============================================================
class GarasiMobilItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;
  const GarasiMobilItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 16;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Garasi Mobil', 16);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GarasiMobilPage(character: character)),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.red.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.red.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.directions_car, color: isUnlocked ? Colors.red : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Garasi Mobil',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.red : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(isUnlocked ? Icons.check_circle : Icons.lock, color: isUnlocked ? Colors.green : Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    DialogHelper.show(
      context: context,
      title: 'Fitur Terkunci 🔒',
      isNotification: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur $feature terbuka saat karakter berusia $requiredAge tahun.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Usia saat ini: ${character.age} tahun',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HALAMAN GARASI MOBIL UTAMA (ROOT)
// ============================================================
class GarasiMobilPage extends StatefulWidget {
  final Character character;
  const GarasiMobilPage({super.key, required this.character});

  @override
  State<GarasiMobilPage> createState() => GarasiMobilPageState();
}

class GarasiMobilPageState extends State<GarasiMobilPage> {
  late Character character;

  // ---- DATA MOBIL ----
  List<Map<String, dynamic>> koleksiMobil = [];
  List<Map<String, dynamic>> showroom = [];
  List<Map<String, dynamic>> riwayatTransaksi = [];

  // ---- STATISTIK ----
  int totalMobil = 0;
  int totalNilaiKoleksi = 0;
  int totalPendapatanShowroom = 0;
  int totalPengunjungShowroom = 0;

  // ---- DATA MOBIL YANG TERSEDIA UNTUK DIBELI ----
  final List<Map<String, dynamic>> _mobilTersedia = mobilTersediaList;

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _loadData();
  }

  void _loadData() {
    // Jika character belum punya data garasi, inisialisasi
    if (character.garasiMobil == null) {
      character.garasiMobil = {
        'koleksi': [],
        'showroom': [],
        'riwayat': [],
        'statistik': {
          'totalMobil': 0,
          'totalNilai': 0,
          'pendapatanShowroom': 0,
          'pengunjung': 0,
        },
      };
    }
    koleksiMobil = List.from(character.garasiMobil!['koleksi'] ?? []);
    showroom = List.from(character.garasiMobil!['showroom'] ?? []);
    riwayatTransaksi = List.from(character.garasiMobil!['riwayat'] ?? []);
    _updateStatistik();
  }

  void _saveData() {
    character.garasiMobil!['koleksi'] = koleksiMobil;
    character.garasiMobil!['showroom'] = showroom;
    character.garasiMobil!['riwayat'] = riwayatTransaksi;
    character.garasiMobil!['statistik'] = {
      'totalMobil': totalMobil,
      'totalNilai': totalNilaiKoleksi,
      'pendapatanShowroom': totalPendapatanShowroom,
      'pengunjung': totalPengunjungShowroom,
    };
  }

  void _updateStatistik() {
    totalMobil = koleksiMobil.length;
    totalNilaiKoleksi = koleksiMobil.fold<int>(0, (sum, m) => sum + (m['harga'] as num).toInt());
    _saveData();
  }

  // ---- FUNGSI TRANSAKSI ----
  void beliMobil(Map<String, dynamic> mobil) {
    setState(() {
      int hargaMobil = (mobil['harga'] as num).toInt();
      if (character.money >= hargaMobil) {
        character.money -= hargaMobil;
        Map<String, dynamic> newMobil = Map.from(mobil);
        newMobil['tahunBeli'] = character.age;
        newMobil['kondisi'] = 'Baik';
        koleksiMobil.add(newMobil);
        riwayatTransaksi.insert(0, {
          'type': 'Beli',
          'nama': mobil['nama'],
          'harga': mobil['harga'],
          'tahun': character.age,
        });
        character.happiness = (character.happiness + 10).clamp(0, 100);
        _updateStatistik();
        DialogHelper.show(
          context: context,
          title: 'Pembelian Berhasil',
          content: Text('Berhasil membeli ${mobil['nama']}! +10 Happiness'),
        );
      } else {
        DialogHelper.show(
          context: context,
          title: 'Transaksi Gagal',
          content: const Text('Uang tidak cukup!'),
        );
      }
    });
  }

  void jualMobil(int index, {bool dariShowroom = false}) {
    setState(() {
      List<Map<String, dynamic>> source = dariShowroom ? showroom : koleksiMobil;
      if (index < 0 || index >= source.length) return;
      var mobil = source[index];
      int hargaJual = (mobil['harga'] * 0.8).round(); // 80% dari harga beli
      if (mobil['kondisi'] == 'Baik') hargaJual = (hargaJual * 1.1).round();
      if (mobil['kondisi'] == 'Sangat Baik') hargaJual = (hargaJual * 1.2).round();
      character.money += hargaJual;
      source.removeAt(index);
      riwayatTransaksi.insert(0, {
        'type': 'Jual',
        'nama': mobil['nama'],
        'harga': hargaJual,
        'tahun': character.age,
      });
      character.happiness = (character.happiness + 5).clamp(0, 100);
      _updateStatistik();
      DialogHelper.show(
        context: context,
        title: 'Penjualan Berhasil',
        content: Text('Berhasil menjual ${mobil['nama']} seharga USD ${formatRupiah(hargaJual)}! +5 Happiness'),
      );
    });
  }

  void pamerkanMobil(String mobilId) {
    setState(() {
      int index = koleksiMobil.indexWhere((m) => m['id'] == mobilId);
      if (index == -1) {
        DialogHelper.show(
          context: context,
          title: 'Error',
          content: const Text('Mobil tidak ditemukan!'),
        );
        return;
      }
      var mobil = koleksiMobil.removeAt(index);
      mobil['tahunPamer'] = character.age;
      showroom.add(mobil);
      character.happiness = (character.happiness + 15).clamp(0, 100);
      _updateStatistik();
      DialogHelper.show(
        context: context,
        title: 'Showroom',
        content: Text('${mobil['nama']} dipamerkan di showroom! +15 Happiness'),
      );
    });
  }

  void batalkanPameran(int index) {
    setState(() {
      if (index < 0 || index >= showroom.length) return;
      var mobil = showroom.removeAt(index);
      koleksiMobil.add(mobil);
      _updateStatistik();
      DialogHelper.show(
        context: context,
        title: 'Garasi',
        content: Text('${mobil['nama']} dikembalikan ke garasi.'),
      );
    });
  }

  void nextYear() {
    setState(() {
      // Showroom menghasilkan pendapatan per tahun
      if (showroom.isNotEmpty) {
        int pendapatan = showroom.length * 5000000;
        int pengunjung = showroom.length * 100 + Random().nextInt(200);
        totalPendapatanShowroom += pendapatan;
        totalPengunjungShowroom += pengunjung;
        character.money += pendapatan;
        character.happiness = (character.happiness + 5).clamp(0, 100);
        riwayatTransaksi.insert(0, {
          'type': 'Showroom',
          'nama': 'Pendapatan Showroom',
          'harga': pendapatan,
          'tahun': character.age,
        });
        DialogHelper.show(
          context: context,
          title: 'Pendapatan Showroom',
          content: Text('Showroom menghasilkan USD ${formatRupiah(pendapatan)}! +5 Happiness'),
        );
      }
      // Depresiasi mobil (jika tidak dirawat)
      for (var m in koleksiMobil) {
        if (m['kondisi'] == 'Baik' && Random().nextDouble() < 0.3) {
          m['kondisi'] = 'Sedang';
        }
        if (m['kondisi'] == 'Sedang' && Random().nextDouble() < 0.2) {
          m['kondisi'] = 'Kurang';
        }
      }
      _updateStatistik();
    });
  }

  // ---- UI ROOT ----
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garasi Mobil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: nextYear,
            tooltip: 'Tahun Berikutnya (Showroom)',
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
              color: isDark ? Colors.grey.shade800 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan Garasi', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Mobil:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        Text('${koleksiMobil.length} (Showroom: ${showroom.length})', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Nilai:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        Text('USD ${formatRupiah(totalNilaiKoleksi)}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pendapatan Showroom:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        Text('USD ${formatRupiah(totalPendapatanShowroom)}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Menu daftar
            _buildMenuTile(
              icon: Icons.directions_car,
              label: 'Koleksi Mobil',
              subtitle: 'Lihat dan kelola semua mobil yang dimiliki',
              color: Colors.red,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KoleksiMobilPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.payments,
              label: 'Jual & Beli Mobil',
              subtitle: 'Cari mobil baru atau jual koleksi',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JualBeliMobilPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.storefront,
              label: 'Showroom',
              subtitle: 'Pamerkan mobil untuk pendapatan pasif',
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowroomPage(state: this))),
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
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
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
}
