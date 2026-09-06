import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'menu_dokter/pemeriksaan_umum/pemeriksaan_umum_page.dart';
import 'menu_dokter/tes_darah/tes_darah_page.dart';
import 'menu_dokter/operasi_kecil/operasi_kecil_page.dart';
import 'menu_dokter/medical_checkup/medical_checkup_page.dart';
// TAMBAHKAN BARIS INI DI BAWAHNYA:
import 'menu_dokter/dokter_utils.dart'; 
import 'riwayat_penyakit_page.dart';

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
    {'name': 'Pemeriksaan Umum 🩺', 'desc': 'Cek kondisi kesehatan dasar'},
    {'name': 'Tes Darah 💉', 'desc': 'Pemeriksaan darah lengkap'},
    {'name': 'Operasi Kecil 🏥', 'desc': 'Operasi untuk mengatasi masalah kesehatan'},
    {'name': 'Medical Check Up Lengkap 📋', 'desc': 'Pemeriksaan menyeluruh tubuh'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pergi ke Dokter 🏥', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              icon: Icon(Icons.sick_outlined, size: 18, color: isDark ? Colors.redAccent : Colors.red),
              label: Text(
                'Penyakit (${widget.character.riwayatPenyakit.length})', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.redAccent : Colors.red, 
                  fontSize: 13,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiwayatPenyakitPage(
                      character: widget.character,
                      onComplete: widget.onComplete,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                  widget.onComplete();
                });
              },
            ),
          )
        ],
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    // SEKARANG KODE INI SUDAH MENGENAL DokterUtils
                    'Saldo Anda: \$${DokterUtils.fmt(widget.character.money)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
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
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        l['name'], 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14, 
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${l['desc']}\nBiaya: Gratis', 
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                      onTap: () {
                        Widget page;
                        if (l['name'].toString().contains('Umum')) {
                          page = PemeriksaanUmumPage(character: widget.character, onComplete: widget.onComplete);
                        } else if (l['name'].toString().contains('Darah')) {
                          page = TesDarahPage(character: widget.character, onComplete: widget.onComplete);
                        } else if (l['name'].toString().contains('Operasi')) {
                          page = OperasiKecilPage(character: widget.character, onComplete: widget.onComplete);
                        } else {
                          page = MedicalCheckupPage(character: widget.character, onComplete: widget.onComplete);
                        }
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => page,
                          ),
                        ).then((_) {
                          setState(() {});
                          widget.onComplete();
                        });
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