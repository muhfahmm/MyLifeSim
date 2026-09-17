import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class TesDarahPage extends StatefulWidget {
  final Character character;
  final VoidCallback? onComplete;
  const TesDarahPage({super.key, required this.character, this.onComplete});

  @override
  State<TesDarahPage> createState() => _TesDarahPageState();
}

class _TesDarahPageState extends State<TesDarahPage> {
  void _doRoutineTest() async {
    const int cost = 150;
    bool paidByParent = false;
    if (widget.character.money < cost) {
      paidByParent = await DokterUtils.handleInsufficientMoney(context, widget.character, cost, 'Tes Darah Rutin');
      if (!paidByParent) {
        return;
      }
    }

    if (!paidByParent) {
      widget.character.money -= cost;
    }
    widget.character.health = (widget.character.health + 10).clamp(0, 100);
    widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
    widget.character.inbox.add('💉 Tes Darah Rutin: Hasil tes darah sampel menunjukkan kondisi sel dan kadar gula dalam batas normal! (-${DokterUtils.fmt(cost)}, +10% Kesehatan, +5% Kebahagiaan)');
    widget.onComplete?.call();
    setState(() {});

    DokterUtils.showResultDialog(
      context,
      'Hasil Tes Darah 💉',
      'Dokter mengambil sampel darahmu.\n\nHasil Uji Lab: Sampel darah dalam keadaan prima dan sehat!\n\n(+10% Kesehatan, +5% Kebahagiaan, -${DokterUtils.fmt(cost)} biaya lab)',
      () {},
    );
  }

  void _treat(String disease) async {
    await DokterUtils.handleDiseaseTreatment(context, widget.character, 'Tes Darah', specificDisease: disease);
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
        title: const Text('Tes Darah 💉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 1,
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
                    'Saldo Anda: ${DokterUtils.fmt(widget.character.money)}',
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // Menu Tes Rutin
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.bloodtype, color: Colors.red, size: 24),
                      title: Text(
                        'Tes Darah Rutin & Skrining 🩸',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Cek hemoglobin & gula darah • ${DokterUtils.fmt(150)}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: _doRoutineTest,
                    ),
                  ),

                  if (activeDiseases.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Penyakit Terdeteksi:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    ...activeDiseases.map((disease) {
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
                          dense: true,
                          leading: const Icon(Icons.medical_services, color: Colors.blue, size: 24),
                          title: Text(
                            disease,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'Terapi darah spesifik • ${DokterUtils.fmt(cost)}',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                          onTap: () => _treat(disease),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
