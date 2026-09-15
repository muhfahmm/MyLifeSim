// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/menu_astronot/misi_luar_angkasa_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class MisiLuarAngkasaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const MisiLuarAngkasaPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<MisiLuarAngkasaPage> createState() => _MisiLuarAngkasaPageState();
}

class _MisiLuarAngkasaPageState extends State<MisiLuarAngkasaPage> {
  final List<Map<String, dynamic>> _missions = [
    {
      'title': 'Misi Perbaikan Teleskop Antariksa 📡',
      'desc': 'Melakukan Spacewalk (EVA) untuk mengganti panel surya & modul komputasi teleskop.',
      'rewardMoney': 120000,
      'popBonus': 8,
      'minHealth': 70,
      'icon': Icons.satellite,
      'color': Colors.indigo,
    },
    {
      'title': 'Ekspedisi Stasiun Luar Angkasa (ISS) 🛰️',
      'desc': 'Tinggal selama 6 bulan di ISS untuk eksperimen biologi mikro-gravitasi & riset fisik.',
      'rewardMoney': 250000,
      'popBonus': 12,
      'minHealth': 75,
      'icon': Icons.space_dashboard,
      'color': Colors.blue,
    },
    {
      'title': 'Misi Eksplorasi Bulan (Artemis) 🌕',
      'desc': 'Pendaratan manusia di kutub selatan bulan & pengumpulan sampel batuan langka.',
      'rewardMoney': 500000,
      'popBonus': 20,
      'minHealth': 80,
      'icon': Icons.brightness_3,
      'color': Colors.amber.shade800,
    },
    {
      'title': 'Misi Perintis Koloni Planet Mars 🔴',
      'desc': 'Misi berisiko tinggi meluncurkan wahana berawak menuju planet merah Mars.',
      'rewardMoney': 1000000,
      'popBonus': 35,
      'minHealth': 85,
      'icon': Icons.public,
      'color': Colors.deepOrange,
    },
  ];

  void _executeMission(Map<String, dynamic> mission) {
    final int minH = mission['minHealth'] as int;
    if (widget.character.health < minH) {
      DialogHelper.show(
        context: context,
        title: 'Kesehatan Tidak Mencukupi 🩺',
        content: Text(
          'Kesehatan fisikmu (${widget.character.health}%) kurang dari syarat minimal $minH% untuk misi ini. Lakukan latihan di pusat kosmonot terlebih dahulu.',
        ),
      );
      return;
    }

    final r = Random();
    final bool isSuccess = r.nextInt(100) < (widget.character.health + widget.character.intelligence) ~/ 2 + 10;

    if (isSuccess) {
      final int moneyEarned = mission['rewardMoney'] as int;
      final int popBonus = mission['popBonus'] as int;

      widget.character.money += moneyEarned;
      widget.character.popularity = (widget.character.popularity + popBonus).clamp(0, 100);
      widget.character.followers += r.nextInt(5000) + 2000;
      setState(() {});
      widget.onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Misi Sukses Besar! 🚀🥇',
        content: Text(
          'Selamat! Misi ${mission['title']} berhasil dilaksanakan sempurna!\n\n'
          '• Bonus Misi Diterima: ${CurrencySettings.format(moneyEarned.toDouble())}\n'
          '• Popularitas Dunia: +$popBonus%\n'
          '• Pengikut Baru: Tambah drastis di sosmed!',
        ),
      );
    } else {
      widget.character.health = (widget.character.health - 15).clamp(10, 100);
      setState(() {});
      widget.onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Kendala Teknis Misi ⚠️',
        content: const Text(
          'Misi mengalami sedikit anomali sistem roket. Beruntung kapsul darurat mendarat selamat! (Kesehatan -15%)',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peluncuran Misi Antariksa 🌌'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.rocket, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Popularitas & Pengikut', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        const SizedBox(height: 2),
                        Text(
                          'Popularitas: ${widget.character.popularity}% ⭐ • Pengikut: ${widget.character.followers}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.blue.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              'Daftar Misi Peluncuran Antariksa 🚀',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
            ),
          ),

          ..._missions.map((mission) {
            final int minH = mission['minHealth'] as int;
            final bool isReady = widget.character.health >= minH;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: mission['color'] as Color,
                          child: Icon(mission['icon'] as IconData, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            mission['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mission['desc'] as String,
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reward: ${CurrencySettings.format((mission['rewardMoney'] as int).toDouble())}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Text(
                            'Min. HP: $minH%',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isReady ? Colors.blue : Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isReady ? (mission['color'] as Color) : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.flight_takeoff_rounded, size: 18),
                        label: const Text('Luncurkan Misi Antariksa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        onPressed: () => _executeMission(mission),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
