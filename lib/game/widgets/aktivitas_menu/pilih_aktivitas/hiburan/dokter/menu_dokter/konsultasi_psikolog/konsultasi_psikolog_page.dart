import 'package:flutter/material.dart';
import '../dokter_utils.dart';

class KonsultasiPsikologPage extends StatefulWidget {
  const KonsultasiPsikologPage({super.key});
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
    // (Dalam implementasi nyata, Anda akan menambahkan logika untuk sesi 15 menit vs 1 jam)
    int happyGain = 20;
    String detail = 'Sesi konsultasi sangat membantu. Pikiranmu terasa lebih ringan.';

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