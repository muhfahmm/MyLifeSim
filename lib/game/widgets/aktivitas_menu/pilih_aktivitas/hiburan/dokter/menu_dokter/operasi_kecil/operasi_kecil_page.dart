import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class OperasiKecilPage extends StatefulWidget {
  final Character character;
  final VoidCallback? onComplete;
  const OperasiKecilPage({super.key, required this.character, this.onComplete});
  @override
  State<OperasiKecilPage> createState() => _OperasiKecilPageState();
}

class _OperasiKecilPageState extends State<OperasiKecilPage> {
  final List<Map<String, dynamic>> operasi = [
    {'nama': 'Cabut Gigi Bungsu', 'desc': 'Menghilangkan sakit gigi'},
    {'nama': 'Operasi Mata (LASIK)', 'desc': 'Mengembalikan penglihatan'},
    {'nama': 'Operasi Amandel', 'desc': 'Mengatasi infeksi tenggorokan'},
    {'nama': 'Operasi Kutil', 'desc': 'Membersihkan kulit'},
  ];

  void _pilihOperasi(Map<String, dynamic> o) {
    int healthGain = 30;
    int happyPenalty = 5; // Efek samping pusing
    String detail = 'Operasi berjalan lancar. Kesehatanmu meningkat signifikan.';

    // Update real stats
    DokterUtils.updateStats(widget.character, healthGain, -happyPenalty, 0);
    widget.character.inbox.add('🏥 Operasi Kecil: ${o['nama']} - $detail (+$healthGain% Kesehatan, -$happyPenalty% Kebahagiaan)');
    widget.onComplete?.call();

    DokterUtils.showResultDialog(
      context, 
      'Operasi Sukses', 
      '🏥 ${o['nama']}: $detail (+$healthGain% Kesehatan, -$happyPenalty% Kebahagiaan sementara)', 
      () => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operasi Kecil 🏥'), backgroundColor: Colors.white, foregroundColor: Colors.black87),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: operasi.length,
        itemBuilder: (_, i) {
          final o = operasi[i];
          return Card(
            child: ListTile(
              title: Text(o['nama']),
              subtitle: Text(o['desc']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _pilihOperasi(o),
            ),
          );
        },
      ),
    );
  }
}