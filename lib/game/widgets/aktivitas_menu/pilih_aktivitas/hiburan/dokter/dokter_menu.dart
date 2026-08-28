import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'menu_dokter/pemeriksaan_umum/pemeriksaan_umum_page.dart';
import 'menu_dokter/tes_darah/tes_darah_page.dart';
import 'menu_dokter/konsultasi_psikolog/konsultasi_psikolog_page.dart';
import 'menu_dokter/operasi_kecil/operasi_kecil_page.dart';
import 'menu_dokter/medical_checkup/medical_checkup_page.dart';
// TAMBAHKAN BARIS INI DI BAWAHNYA:
import 'menu_dokter/dokter_utils.dart'; 

class DokterMenuHelper {
  static void showDokterMenu(BuildContext context, Character character, VoidCallback onComplete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DokterPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class DokterPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const DokterPage({super.key, required this.character, required this.onComplete});

  @override
  State<DokterPage> createState() => _DokterPageState();
}

class _DokterPageState extends State<DokterPage> {
  final List<Map<String, dynamic>> layanan = [
    {'name': 'Pemeriksaan Umum 🩺', 'desc': 'Cek kondisi kesehatan dasar', 'page': PemeriksaanUmumPage()},
    {'name': 'Tes Darah 💉', 'desc': 'Pemeriksaan darah lengkap', 'page': TesDarahPage()},
    {'name': 'Konsultasi Psikolog 🧠', 'desc': 'Sesi konsultasi kesehatan mental', 'page': KonsultasiPsikologPage()},
    {'name': 'Operasi Kecil 🏥', 'desc': 'Operasi untuk mengatasi masalah kesehatan', 'page': OperasiKecilPage()},
    {'name': 'Medical Check Up Lengkap 📋', 'desc': 'Pemeriksaan menyeluruh tubuh', 'page': MedicalCheckupPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pergi ke Dokter 🏥', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    // SEKARANG KODE INI SUDAH MENGENAL DokterUtils
                    'Saldo Anda: \$${DokterUtils.fmt(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: layanan.length,
                itemBuilder: (_, i) {
                  final l = layanan[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(l['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${l['desc']}\nBiaya: Gratis', style: const TextStyle(color: Colors.black54)),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => l['page'],
                          ),
                        ).then((_) => widget.onComplete()); // Memanggil onComplete setelah kembali
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}