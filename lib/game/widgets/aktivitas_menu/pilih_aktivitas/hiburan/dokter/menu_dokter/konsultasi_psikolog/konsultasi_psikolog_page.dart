import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class KonsultasiPsikologPage extends StatefulWidget {
  final Character character;
  const KonsultasiPsikologPage({super.key, required this.character});
  @override
  State<KonsultasiPsikologPage> createState() => _KonsultasiPsikologPageState();
}

class _KonsultasiPsikologPageState extends State<KonsultasiPsikologPage> {
  final List<Map<String, dynamic>> topik = [
    {'nama': 'Stres Kerja', 'desc': 'Beban pekerjaan yang menumpuk'},
    {'nama': 'Masalah Keluarga', 'desc': 'Konflik dengan orang terdekat'},
    {'nama': 'Percintaan', 'desc': 'Masalah asmara'},
    {'nama': 'Kesehatan Mental', 'desc': 'Kecemasan berlebih'},
  ];

  void _pilihTopik(Map<String, dynamic> t) {
    int happyGain = 20;
    String detail = 'Sesi konsultasi sangat membantu. Pikiranmu terasa lebih ringan.';

    // Update real stats
    DokterUtils.updateStats(widget.character, 0, happyGain, 0);
    widget.character.inbox.add('🧠 Konsultasi Psikolog: Topik ${t['nama']} - $detail (+$happyGain% Kebahagiaan)');

    DokterUtils.showResultDialog(
      context, 
      'Sesi Selesai', 
      '🧠 Topik: ${t['nama']}\n$detail (+$happyGain% Kebahagiaan)', 
      () => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konsultasi Psikolog 🧠'), backgroundColor: Colors.white, foregroundColor: Colors.black87),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topik.length,
        itemBuilder: (_, i) {
          final t = topik[i];
          return Card(
            child: ListTile(
              title: Text(t['nama']),
              subtitle: Text(t['desc']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _pilihTopik(t),
            ),
          );
        },
      ),
    );
  }
}