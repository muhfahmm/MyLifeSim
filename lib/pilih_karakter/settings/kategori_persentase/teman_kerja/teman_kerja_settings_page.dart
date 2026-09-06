import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/pilih_karakter/settings/proposal_percentage_settings.dart';

class TemanKerjaSettingsPage extends StatelessWidget {
  const TemanKerjaSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pengaturan Persentase Teman Kerja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: GlobalSettings.userGender,
            builder: (context, genderVal, _) {
              final bool isFemale = genderVal.trim().toLowerCase() == 'perempuan' || genderVal.trim().toLowerCase() == 'female';
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isFemale ? Colors.pink.withValues(alpha: 0.15) : Colors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFemale ? Icons.female : Icons.male,
                          color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isFemale ? 'Perempuan' : 'Laki-laki',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      ProposalPercentageSettings.enableAllRelations();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Semua teman kerja berhasil DIAKTIFKAN'),
                          duration: Duration(milliseconds: 900),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade400, width: 1),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Aktifkan Semua',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      ProposalPercentageSettings.disableAllRelations();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Semua teman kerja berhasil DIMATIKAN'),
                          duration: Duration(milliseconds: 900),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade400, width: 1),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.highlight_off, color: Colors.redAccent, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Matikan Semua',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RelationPercentageGroupCard(
            title: 'Rekan Kerja & Atasan',
            icon: Icons.work,
            iconColor: Colors.deepPurple,
            relationKey: 'Non-Keluarga Lain',
          ),
        ],
      ),
    );
  }
}
