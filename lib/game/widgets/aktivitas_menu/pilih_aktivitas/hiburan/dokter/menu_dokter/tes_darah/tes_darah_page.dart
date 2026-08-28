import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class TesDarahPage extends StatefulWidget {
  final Character character;
  const TesDarahPage({super.key, required this.character});
  @override
  State<TesDarahPage> createState() => _TesDarahPageState();
}

class _TesDarahPageState extends State<TesDarahPage> {
  final List<Map<String, dynamic>> tes = [
    {'nama': 'Cek Gula Darah', 'desc': 'Mendeteksi diabetes'},
    {'nama': 'Cek Kolesterol', 'desc': 'Mendeteksi lemak darah'},
    {'nama': 'Cek Hemoglobin (HB)', 'desc': 'Mendeteksi anemia'},
    {'nama': 'Tes Lengkap', 'desc': 'Semua parameter darah'},
  ];

  void _pilihTes(Map<String, dynamic> t) {
    final r = Random();
    int healthGain = 5;
    int intelGain = 3;
    String detail = 'Hasil tes darahmu normal. Dokter memberikan beberapa saran gizi.';
    
    // 20% kemungkinan abnormal untuk efek realistis
    if (r.nextInt(10) < 2) {
      healthGain = -5;
      detail = 'Hasil tes menunjukkan kadar ${t['nama']} sedikit tinggi. Dokter menyarankan diet.';
    }

    // Update real stats
    DokterUtils.updateStats(widget.character, healthGain, 0, intelGain);
    widget.character.inbox.add('💉 Tes Darah: ${t['nama']} - $detail (+$healthGain% Kesehatan, +$intelGain% Kecerdasan)');

    DokterUtils.showResultDialog(
      context, 
      'Tes Selesai', 
      '💉 ${t['nama']}: $detail (+$healthGain% Kesehatan, +$intelGain% Kecerdasan)', 
      () => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tes Darah 💉'), backgroundColor: Colors.white, foregroundColor: Colors.black87),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tes.length,
        itemBuilder: (_, i) {
          final t = tes[i];
          return Card(
            child: ListTile(
              title: Text(t['nama']),
              subtitle: Text(t['desc']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _pilihTes(t),
            ),
          );
        },
      ),
    );
  }
}