import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class KeluargaSettingsPage extends StatelessWidget {
  const KeluargaSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pengaturan Persentase Keluarga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
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
                          content: Text('Semua anggota keluarga berhasil DIAKTIFKAN'),
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
                          content: Text('Semua anggota keluarga berhasil DIMATIKAN'),
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
            title: 'Ayah Kandung',
            icon: Icons.person,
            iconColor: Colors.blue,
            relationKey: 'Ayah Kandung',
          ),
          RelationPercentageGroupCard(
            title: 'Ayah Tiri',
            icon: Icons.person_outline,
            iconColor: Colors.lightBlue,
            relationKey: 'Ayah Tiri',
          ),
          RelationPercentageGroupCard(
            title: 'Ayah Mertua',
            icon: Icons.person_add,
            iconColor: Colors.indigo,
            relationKey: 'Ayah Mertua',
          ),
          RelationPercentageGroupCard(
            title: 'Ibu Kandung',
            icon: Icons.face_3,
            iconColor: Colors.pink,
            relationKey: 'Ibu Kandung',
          ),
          RelationPercentageGroupCard(
            title: 'Ibu Tiri',
            icon: Icons.face_3_outlined,
            iconColor: Colors.pinkAccent,
            relationKey: 'Ibu Tiri',
          ),
          RelationPercentageGroupCard(
            title: 'Ibu Mertua',
            icon: Icons.face_2,
            iconColor: Colors.purpleAccent,
            relationKey: 'Ibu Mertua',
          ),
          RelationPercentageGroupCard(
            title: 'Kakak Laki-laki',
            icon: Icons.groups,
            iconColor: Colors.cyan,
            relationKey: 'Kakak Laki-laki',
          ),
          RelationPercentageGroupCard(
            title: 'Kakak Perempuan',
            icon: Icons.groups_3,
            iconColor: Colors.teal,
            relationKey: 'Kakak Perempuan',
          ),
          RelationPercentageGroupCard(
            title: 'Adik Laki-laki',
            icon: Icons.sentiment_satisfied,
            iconColor: Colors.deepOrange,
            relationKey: 'Adik Laki-laki',
          ),
          RelationPercentageGroupCard(
            title: 'Adik Perempuan',
            icon: Icons.sentiment_satisfied_alt,
            iconColor: Colors.amber,
            relationKey: 'Adik Perempuan',
          ),
          RelationPercentageGroupCard(
            title: 'Paman',
            icon: Icons.people_outline,
            iconColor: Colors.brown,
            relationKey: 'Paman',
          ),
          RelationPercentageGroupCard(
            title: 'Pasangan Paman',
            icon: Icons.people,
            iconColor: Colors.deepPurple,
            relationKey: 'Pasangan Paman',
          ),
          RelationPercentageGroupCard(
            title: 'Bibi',
            icon: Icons.woman,
            iconColor: Colors.purpleAccent,
            relationKey: 'Bibi',
          ),
          RelationPercentageGroupCard(
            title: 'Sepupu',
            icon: Icons.group_add,
            iconColor: Colors.lightGreen,
            relationKey: 'Sepupu',
          ),
          RelationPercentageGroupCard(
            title: 'Kakek',
            icon: Icons.elderly,
            iconColor: Colors.grey,
            relationKey: 'Kakek',
          ),
          RelationPercentageGroupCard(
            title: 'Nenek',
            icon: Icons.elderly_woman,
            iconColor: Colors.blueGrey,
            relationKey: 'Nenek',
          ),
          RelationPercentageGroupCard(
            title: 'Anak / Keponakan',
            icon: Icons.child_care,
            iconColor: Colors.orangeAccent,
            relationKey: 'Anak / Keponakan',
          ),
        ],
      ),
    );
  }
}
