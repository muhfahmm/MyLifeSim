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
    {'nama': 'Cabut Gigi Bungsu', 'cost': 200, 'desc': 'Menghilangkan sakit gigi'},
    {'nama': 'Operasi Mata (LASIK)', 'cost': 1500, 'desc': 'Mengembalikan penglihatan'},
    {'nama': 'Operasi Amandel', 'cost': 600, 'desc': 'Mengatasi infeksi tenggorokan'},
    {'nama': 'Operasi Kutil', 'cost': 150, 'desc': 'Membersihkan kulit'},
  ];

  void _pilihOperasi(Map<String, dynamic> o) async {
    final int cost = o['cost'] as int;
    bool paidByParent = false;
    if (widget.character.money < cost) {
      paidByParent = await DokterUtils.handleInsufficientMoney(context, widget.character, cost, o['nama']);
      if (!paidByParent) {
        return;
      }
    }

    int healthGain = 30;
    int happyPenalty = 5; // Efek samping pusing
    String detail = 'Operasi berjalan lancar. Kesehatanmu meningkat signifikan.';

    // Update real stats
    if (!paidByParent) {
      widget.character.money -= cost;
    }
    DokterUtils.updateStats(widget.character, healthGain, -happyPenalty, 0);
    widget.character.inbox.add('🏥 Operasi Kecil: ${o['nama']} - $detail (-${DokterUtils.fmt(cost)}, +$healthGain% Kesehatan, -$happyPenalty% Kebahagiaan)');
    widget.onComplete?.call();

    DokterUtils.showResultDialog(
      context, 
      'Operasi Sukses', 
      '🏥 ${o['nama']}: $detail\n\n(+$healthGain% Kesehatan, -$happyPenalty% Kebahagiaan sementara, -${DokterUtils.fmt(cost)} biaya operasi)', 
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operasi Kecil 🏥', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: operasi.length,
        itemBuilder: (_, i) {
          final o = operasi[i];
          final int cost = o['cost'] as int;
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            ),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.medical_services, color: Colors.blue, size: 24),
              title: Text(o['nama'], style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text('${o['desc']} • ${DokterUtils.fmt(cost)}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12)),
              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
              onTap: () => _pilihOperasi(o),
            ),
          );
        },
      ),
    );
  }
}
