import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/aksi/aksi_ke_teman/teman_profile_screen.dart';

class ClassmateHelper {
  /// Menghasilkan daftar teman sekelas secara persisten jika belum ada
  static void generateClassmatesIfNeeded(Character character) {
    if (character.classmates.isNotEmpty) return;

    final Random random = Random();
    final int count = 15 + random.nextInt(11); // Minimal 15, maksimal 25 orang

    final List<String> mFirsts = character.maleFirstNames ?? [];
    final List<String> fFirsts = character.femaleFirstNames ?? [];
    final List<String> lasts = character.lastNames ?? [];

    final List<String> usedNames = [];

    for (int i = 0; i < count; i++) {
      final String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final List<String> firstNames = gender == 'Laki-laki' ? mFirsts : fFirsts;

      // Cari nama yang belum digunakan
      String name = '';
      int attempts = 0;
      do {
        final String first = firstNames[random.nextInt(firstNames.length)];
        final String last = lasts.isNotEmpty ? lasts[random.nextInt(lasts.length)] : '';
        name = last.isNotEmpty ? '$first $last' : first;
        attempts++;
      } while (usedNames.contains(name) && attempts < 100);

      usedNames.add(name);

      // Usia: 70% persis sama, 30% terpaut 1-2 tahun
      int age = character.age;
      if (random.nextInt(100) < 30) {
        final List<int> offsets = [-2, -1, 1, 2];
        final int offset = offsets[random.nextInt(offsets.length)];
        age = (character.age + offset).clamp(0, 100);
      }

      character.classmates.add({
        'name': name,
        'gender': gender,
        'relationship': '50',
        'age': age.toString(),
        'isDeceased': 'false',
      });
    }
  }

  /// Menampilkan dialog teman sekelas
  static void showClassmatesDialog({
    required BuildContext context,
    required Character character,
    required String title,
    required VoidCallback onRefresh,
  }) {
    generateClassmatesIfNeeded(character);

    DialogHelper.show(
      context: context,
      title: title,
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 400),
        child: character.classmates.isEmpty
            ? const Center(child: Text('Tidak ada teman sekelas.'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: character.classmates.length,
                itemBuilder: (context, index) {
                  final classmate = character.classmates[index];
                  final String name = classmate['name'] ?? 'Teman';
                  final String gender = classmate['gender'] ?? 'Laki-laki';
                  final int age = int.tryParse(classmate['age'] ?? '12') ?? 12;
                  final int relationship = int.tryParse(classmate['relationship'] ?? '50') ?? 50;

                  final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                    name: name,
                    gender: gender,
                    age: age,
                    happiness: relationship,
                  );

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: gender == 'Laki-laki' ? Colors.blue.shade50 : Colors.purple.shade50,
                        radius: 20,
                        child: Image.network(
                          avatarUrl,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(gender == 'Laki-laki' ? Icons.male : Icons.female, color: Colors.blueGrey),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          if ((character.partner != null && character.partner!['name'] == name) ||
                              (character.secondPartner != null && character.secondPartner!['name'] == name))
                            const Text(
                              '(pacar)',
                              style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Umur: $age tahun | Gender: $gender', style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          // Relationship Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationship / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationship >= 50 ? Colors.green : Colors.red,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context); // Tutup dialog list teman sekelas
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TemanProfileScreen(
                              character: character,
                              temanName: name,
                              temanGender: gender,
                              temanAge: age,
                              initialRelationship: relationship,
                              onRefresh: onRefresh,
                            ),
                          ),
                        ).then((_) => onRefresh());
                      },
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
      ],
    );
  }
}
