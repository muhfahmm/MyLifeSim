import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class PemeriksaanUmumPage extends StatefulWidget {
  final Character character;
  final VoidCallback? onComplete;
  const PemeriksaanUmumPage({super.key, required this.character, this.onComplete});

  @override
  State<PemeriksaanUmumPage> createState() => _PemeriksaanUmumPageState();
}

class _PemeriksaanUmumPageState extends State<PemeriksaanUmumPage> {
  void _treat(String disease) async {
    // Gunakan helper pengobatan dari DokterUtils
    await DokterUtils.handleDiseaseTreatment(context, widget.character, 'Pemeriksaan Umum');
    widget.onComplete?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Filter penyakit yang harus ditangani di Pemeriksaan Umum
    final activeDiseases = widget.character.riwayatPenyakit
        .where((d) => DokterUtils.getRequiredMenu(d) == 'Pemeriksaan Umum')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemeriksaan Umum 🩺', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    'Saldo Anda: \$${DokterUtils.fmt(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: activeDiseases.isEmpty
                  ? const Center(
                      child: Text(
                        'kamu sehat',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: activeDiseases.length,
                      itemBuilder: (context, index) {
                        final disease = activeDiseases[index];
                        final costData = DokterUtils.getDiseaseCostAndSuccessRate(disease);
                        final int cost = costData['cost'] ?? 100;
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
                            title: Text(
                              disease,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                            ),
                            subtitle: const Text(
                              'Membutuhkan tindakan pemeriksaan umum.',
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _treat(disease),
                              child: Text('Obati (\$${DokterUtils.fmt(cost)})'),
                            ),
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