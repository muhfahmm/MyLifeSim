import 'package:flutter/material.dart';
import '../dokter_utils.dart';

class MedicalCheckupPage extends StatefulWidget {
  const MedicalCheckupPage({super.key});
  @override
  State<MedicalCheckupPage> createState() => _MedicalCheckupPageState();
}

class _MedicalCheckupPageState extends State<MedicalCheckupPage> {
  final List<Map<String, dynamic>> paket = [
    {'nama': 'Basic', 'desc': 'Cek jantung & paru-paru'},
    {'nama': 'Standard', 'desc': 'Tambah cek mata & gigi'},
    {'nama': 'Premium', 'desc': 'Semua organ + konsultasi gizi'},
  ];

  void _pilihPaket(Map<String, dynamic> p) {
    int healthGain = 15;
    int happyGain = 5;
    int intelGain = 2;
    String detail = 'Medical check up lengkap selesai. Semua dalam kondisi prima.';

    DokterUtils.showResultDialog(
      context, 
      'Check Up Selesai', 
      '📋 Paket ${p['nama']}: $detail (+$healthGain% Kesehatan, +$happyGain% Kebahagiaan, +$intelGain% Kecerdasan)', 
      () => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Check Up 📋'), backgroundColor: Colors.white, foregroundColor: Colors.black87),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: paket.length,
        itemBuilder: (_, i) {
          final p = paket[i];
          return Card(
            child: ListTile(
              title: Text(p['nama']),
              subtitle: Text(p['desc']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _pilihPaket(p),
            ),
          );
        },
      ),
    );
  }
}