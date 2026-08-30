// lib/game/widgets/assets_menu/aset_premium/garasi_motor/garasi_motor.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/garasi_motor/database_motor.dart';

part 'menu_garasi_motor/koleksi_motor.dart';
part 'menu_garasi_motor/jual_beli_motor.dart';
part 'menu_garasi_motor/showroom_motor.dart';

String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
    buffer.write(parts[i]);
  }
  return value < 0 ? '-${buffer.toString()}' : buffer.toString();
}

class GarasiMotorItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;
  const GarasiMotorItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 16;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Garasi Motor', 16);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GarasiMotorPage(character: character)),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.orange.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.motorcycle, color: isUnlocked ? Colors.orange : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Garasi Motor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? Colors.orange : Colors.grey,
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.lock_outline, color: Colors.grey), SizedBox(width: 8), Text('Fitur Terkunci')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fitur $feature terbuka saat karakter berusia $requiredAge tahun.'),
            const SizedBox(height: 8),
            Text('Usia saat ini: ${character.age} tahun', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti'))],
      ),
    );
  }
}

class GarasiMotorPage extends StatefulWidget {
  final Character character;
  const GarasiMotorPage({super.key, required this.character});

  @override
  State<GarasiMotorPage> createState() => _GarasiMotorPageState();
}

class _GarasiMotorPageState extends State<GarasiMotorPage> {
  late Character character;

  List<Map<String, dynamic>> koleksiMotor = [];
  List<Map<String, dynamic>> showroomMotor = [];
  List<Map<String, dynamic>> riwayatTransaksi = [];

  int totalMotor = 0;
  int totalNilaiKoleksi = 0;
  int totalPendapatanShowroom = 0;
  int totalPengunjungShowroom = 0;

  final List<Map<String, dynamic>> _motorTersedia = motorTersediaList;

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _loadData();
  }

  void _loadData() {
    if (character.garasiMotor == null) {
      character.garasiMotor = {
        'koleksi': [],
        'showroom': [],
        'riwayat': [],
        'statistik': {
          'totalMotor': 0,
          'totalNilai': 0,
          'pendapatanShowroom': 0,
          'pengunjung': 0,
        },
      };
    }
    koleksiMotor = List.from(character.garasiMotor!['koleksi'] ?? []);
    showroomMotor = List.from(character.garasiMotor!['showroom'] ?? []);
    riwayatTransaksi = List.from(character.garasiMotor!['riwayat'] ?? []);
    _updateStatistik();
  }

  void _saveData() {
    character.garasiMotor!['koleksi'] = koleksiMotor;
    character.garasiMotor!['showroom'] = showroomMotor;
    character.garasiMotor!['riwayat'] = riwayatTransaksi;
    character.garasiMotor!['statistik'] = {
      'totalMotor': totalMotor,
      'totalNilai': totalNilaiKoleksi,
      'pendapatanShowroom': totalPendapatanShowroom,
      'pengunjung': totalPengunjungShowroom,
    };
  }

  void _updateStatistik() {
    totalMotor = koleksiMotor.length;
    totalNilaiKoleksi = koleksiMotor.fold<int>(0, (sum, m) => sum + (m['harga'] as num).toInt());
    _saveData();
  }

  void beliMotor(Map<String, dynamic> motor) {
    setState(() {
      int hargaMotor = (motor['harga'] as num).toInt();
      if (character.money >= hargaMotor) {
        character.money -= hargaMotor;
        Map<String, dynamic> newMotor = Map.from(motor);
        newMotor['tahunBeli'] = character.age;
        newMotor['kondisi'] = 'Baik';
        koleksiMotor.add(newMotor);
        riwayatTransaksi.insert(0, {
          'type': 'Beli',
          'nama': motor['nama'],
          'harga': motor['harga'],
          'tahun': character.age,
        });
        character.happiness = (character.happiness + 10).clamp(0, 100);
        _updateStatistik();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil membeli ${motor['nama']}! +10 Happiness'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uang tidak cukup!'), backgroundColor: Colors.red),
        );
      }
    });
  }

  void jualMotor(int index, {bool dariShowroom = false}) {
    setState(() {
      List<Map<String, dynamic>> source = dariShowroom ? showroomMotor : koleksiMotor;
      if (index < 0 || index >= source.length) return;
      var motor = source[index];
      int hargaJual = (motor['harga'] * 0.8).round();
      if (motor['kondisi'] == 'Baik') hargaJual = (hargaJual * 1.1).round();
      if (motor['kondisi'] == 'Sangat Baik') hargaJual = (hargaJual * 1.2).round();
      character.money += hargaJual;
      source.removeAt(index);
      riwayatTransaksi.insert(0, {
        'type': 'Jual',
        'nama': motor['nama'],
        'harga': hargaJual,
        'tahun': character.age,
      });
      character.happiness = (character.happiness + 5).clamp(0, 100);
      _updateStatistik();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil menjual ${motor['nama']} seharga USD ${formatRupiah(hargaJual)}! +5 Happiness'),
          backgroundColor: Colors.orange,
        ),
      );
    });
  }

  void pamerkanMotor(String motorId) {
    setState(() {
      int index = koleksiMotor.indexWhere((m) => m['id'] == motorId);
      if (index == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Motor tidak ditemukan!'), backgroundColor: Colors.red),
        );
        return;
      }
      var motor = koleksiMotor.removeAt(index);
      motor['tahunPamer'] = character.age;
      showroomMotor.add(motor);
      character.happiness = (character.happiness + 15).clamp(0, 100);
      _updateStatistik();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${motor['nama']} dipamerkan di showroom! +15 Happiness'),
          backgroundColor: Colors.blue,
        ),
      );
    });
  }

  void batalkanPameran(int index) {
    setState(() {
      if (index < 0 || index >= showroomMotor.length) return;
      var motor = showroomMotor.removeAt(index);
      koleksiMotor.add(motor);
      _updateStatistik();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${motor['nama']} dikembalikan ke garasi.'),
          backgroundColor: Colors.grey,
        ),
      );
    });
  }

  void nextYear() {
    setState(() {
      if (showroomMotor.isNotEmpty) {
        int pendapatan = showroomMotor.length * 2500000;
        int pengunjung = showroomMotor.length * 80 + Random().nextInt(150);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Showroom menghasilkan USD ${formatRupiah(pendapatan)}! +5 Happiness'),
            backgroundColor: Colors.teal,
          ),
        );
      }
      for (var m in koleksiMotor) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garasi Motor'),
        backgroundColor: Colors.orange,
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
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ringkasan Garasi', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Motor:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${koleksiMotor.length} (Showroom: ${showroomMotor.length})'),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Nilai:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('USD ${formatRupiah(totalNilaiKoleksi)}'),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pendapatan Showroom:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('USD ${formatRupiah(totalPendapatanShowroom)}'),
                      ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildMenuTile(
              icon: Icons.motorcycle,
              label: 'Koleksi Motor',
              subtitle: 'Lihat dan kelola semua motor yang dimiliki',
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KoleksiMotorPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.payments,
              label: 'Jual & Beli Motor',
              subtitle: 'Cari motor baru atau jual koleksi',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JualBeliMotorPage(state: this))),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.storefront,
              label: 'Showroom',
              subtitle: 'Pamerkan motor untuk pendapatan pasif',
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowroomMotorPage(state: this))),
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
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
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
