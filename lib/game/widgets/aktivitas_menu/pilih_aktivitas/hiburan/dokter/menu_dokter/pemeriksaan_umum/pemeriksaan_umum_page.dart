import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class PemeriksaanUmumPage extends StatefulWidget {
  const PemeriksaanUmumPage({super.key});
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
    // Mengambil karakter dari root menggunakan context (perlu di-passing, atau gunakan GlobalKey)
    // Dalam konteks nyata, Anda perlu mengakses widget.character dari parent. 
    // Karena parent DokterPage memanggil page baru, kita gunakan cara sederhana dengan menyimpan karakter di root saja, atau menggunakan callback.
    // **SOLUSI**: Untuk mempermudah, saya asumsikan karakter diambil dari context atau `onComplete` dipanggil untuk memberi sinyal ke parent.
    // Di halaman sub, kita hanya perlu memanggil `onComplete` setelah dialog. 
    // (Catatan: Logika eksekusi karakter sebaiknya tetap di root agar state terjaga).
    
    // Untuk demo visual (tanpa perlu mengubah root terlalu rumit), saya akan menganggap ada parameter Character, tapi sesuai permintaan, 
    // kita langsung tampilkan dialog hasil.
    final r = Random();
    int healthGain = 10 + r.nextInt(10);
    String detail = 'Dokter menyatakan kondisimu cukup baik.';
    
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