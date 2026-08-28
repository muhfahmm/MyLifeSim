import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class PemeriksaanUmumPage extends StatefulWidget {
  final Character character;
  const PemeriksaanUmumPage({super.key, required this.character});
  @override
  State<PemeriksaanUmumPage> createState() => _PemeriksaanUmumPageState();
}

class _PemeriksaanUmumPageState extends State<PemeriksaanUmumPage> {
  final List<Map<String, dynamic>> gejala = [
    {'nama': 'Batuk', 'desc': 'Cek tenggorokan dan paru-paru'},
    {'nama': 'Pilek', 'desc': 'Cek hidung dan sinus'},
    {'nama': 'Demam', 'desc': 'Cek suhu tubuh'},
    {'nama': 'Sehat Saja', 'desc': 'Cek kondisi umum'},
  ];

  void _pilihGejala(Map<String, dynamic> g) {
    final r = Random();
    int healthGain = 10 + r.nextInt(10);
    String detail = 'Dokter menyatakan kondisimu cukup baik.';
    
    // Update real stats
    DokterUtils.updateStats(widget.character, healthGain, 0, 0);
    widget.character.inbox.add('🏥 Pemeriksaan Umum: Gejala ${g['nama']} - $detail (+$healthGain% Kesehatan)');
    
    DokterUtils.showResultDialog(
      context, 
      'Pemeriksaan Selesai', 
      '🏥 Gejala: ${g['nama']}\n$detail (+$healthGain% Kesehatan)', 
      () => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemeriksaan Umum 🩺'), backgroundColor: Colors.white, foregroundColor: Colors.black87),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: gejala.length,
        itemBuilder: (_, i) {
          final g = gejala[i];
          return Card(
            child: ListTile(
              title: Text(g['nama']),
              subtitle: Text(g['desc']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _pilihGejala(g),
            ),
          );
        },
      ),
    );
  }
}