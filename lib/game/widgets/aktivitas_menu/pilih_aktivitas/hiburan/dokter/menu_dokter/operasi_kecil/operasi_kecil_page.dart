import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operasi Kecil 🏥'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: operasi.length,
        itemBuilder: (_, i) {
          final o = operasi[i];
          return Card(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            ),
            child: ListTile(
              leading: Icon(Icons.medical_services, color: Colors.blue, size: 28),
              title: Text(o['nama'], style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
              subtitle: Text(o['desc'], style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
              onTap: () => _pilihOperasi(o),
            ),
          );
        },
      ),
    );
  }
}