import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../dokter_utils.dart';

class MedicalCheckupPage extends StatefulWidget {
  final Character character;
  final VoidCallback? onComplete;
  const MedicalCheckupPage({super.key, required this.character, this.onComplete});

  @override
  State<MedicalCheckupPage> createState() => _MedicalCheckupPageState();
}

class _MedicalCheckupPageState extends State<MedicalCheckupPage> {
  void _treat(String disease) async {
    // Gunakan helper pengobatan dari DokterUtils
    await DokterUtils.handleDiseaseTreatment(context, widget.character, 'Medical Check Up');
    widget.onComplete?.call();
    setState(() {});
  }

  void _doMedicalCheckup(String packageName, int cost, int healthGain, int happyGain) async {
    bool paidByParent = false;
    if (widget.character.money < cost) {
      paidByParent = await DokterUtils.handleInsufficientMoney(context, widget.character, cost, packageName);
      if (!paidByParent) {
        return;
      }
    }

    if (!paidByParent) {
      widget.character.money -= cost;
    }
    widget.character.health = (widget.character.health + healthGain).clamp(0, 100);
    widget.character.happiness = (widget.character.happiness + happyGain).clamp(0, 100);
    widget.character.inbox.add('📋 $packageName: Pemeriksaan organ tubuh menyeluruh selesai. Kondisi organ vital baik! (-${DokterUtils.fmt(cost)}, +$healthGain% Kesehatan, +$happyGain% Kebahagiaan)');
    widget.onComplete?.call();
    setState(() {});

    DokterUtils.showResultDialog(
      context,
      'Hasil Medical Check Up 📋',
      'Tim medis telah selesai melakukan diagnostik organ vital tubuhmu.\n\nHasil Diagnostik: Seluruh fungsi organ utama (Jantung, Paru, Ginjal, Hati) dalam kondisi prima!\n\n(+$healthGain% Kesehatan, +$happyGain% Kebahagiaan, -${DokterUtils.fmt(cost)} biaya MCU)',
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Filter penyakit yang harus ditangani di Medical Check Up
    final activeDiseases = widget.character.riwayatPenyakit
        .where((d) => DokterUtils.getRequiredMenu(d) == 'Medical Check Up')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Check Up 📋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  // Paket 1: MCU Eksekutif Dasar
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
                      leading: const Icon(Icons.health_and_safety, color: Colors.blue, size: 24),
                      title: Text(
                        'MCU Eksekutif Dasar 🩺',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Pemeriksaan fungsi organ • ${DokterUtils.fmt(500)}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: () => _doMedicalCheckup('MCU Eksekutif Dasar', 500, 15, 10),
                    ),
                  ),

                  // Paket 2: MCU Full Body Scan
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
                      leading: const Icon(Icons.medical_information, color: Colors.purple, size: 24),
                      title: Text(
                        'MCU VIP Full Body Scanning 📑',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Pemindaian MRI & genetik • ${DokterUtils.fmt(1200)}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: () => _doMedicalCheckup('MCU VIP Full Body Scanning', 1200, 30, 15),
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
                      final int cost = costData['cost'] ?? 800;
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
                            'Terapi organ dalam • ${DokterUtils.fmt(cost)}',
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
