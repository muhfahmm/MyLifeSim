import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class TesDarahPage extends StatefulWidget {
  final Character character;
  final VoidCallback? onComplete;
  const TesDarahPage({super.key, required this.character, this.onComplete});

  @override
  State<TesDarahPage> createState() => _TesDarahPageState();
}

class _TesDarahPageState extends State<TesDarahPage> {
  void _treat(String disease) async {
    // Gunakan helper pengobatan dari DokterUtils
    await DokterUtils.handleDiseaseTreatment(context, widget.character, 'Tes Darah');
    widget.onComplete?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Filter penyakit yang harus ditangani di Tes Darah
    final activeDiseases = widget.character.riwayatPenyakit
        .where((d) => DokterUtils.getRequiredMenu(d) == 'Tes Darah')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes Darah 💉', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
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
              child: activeDiseases.isEmpty
                  ? Center(
                      child: Text(
                        'kamu sehat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: activeDiseases.length,
                      itemBuilder: (context, index) {
                        final disease = activeDiseases[index];
                        final costData = DokterUtils.getDiseaseCostAndSuccessRate(disease);
                        final int cost = costData['cost'] ?? 250;
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
                              disease,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Membutuhkan tindakan tes darah.',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
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