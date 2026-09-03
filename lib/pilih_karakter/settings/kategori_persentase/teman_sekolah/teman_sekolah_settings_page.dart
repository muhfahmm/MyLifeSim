import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class TemanSekolahSettingsPage extends StatelessWidget {
  const TemanSekolahSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pengaturan Persentase Teman Sekolah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      final String nextGender = isFemale ? 'Laki-laki' : 'Perempuan';
                      GlobalSettings.userGender.value = nextGender;
                    },
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
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        children: const [
          RelationPercentageGroupCard(
            title: 'Guru & Dosen',
            icon: Icons.school,
            iconColor: Colors.blueAccent,
            relationKey: 'Guru / Dosen',
          ),
          RelationPercentageGroupCard(
            title: 'Teman Sekelas / Sekolah',
            icon: Icons.groups,
            iconColor: Colors.orange,
            relationKey: 'Non-Keluarga Lain',
          ),
        ],
      ),
    );
  }
}
