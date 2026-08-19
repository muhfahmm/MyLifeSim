// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menu/guru/guru.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class GuruMenu {
  static void _generateTeachersIfNeeded(Character character) {
    if (character.smpTeachers.isNotEmpty) return;

    final Random random = Random();
    final List<String> mFirsts = character.maleFirstNames ?? [];
    final List<String> fFirsts = character.femaleFirstNames ?? [];
    final List<String> lasts = character.lastNames ?? [];

    String _genName(String gender) {
      final List<String> firsts = gender == 'Laki-laki' ? mFirsts : fFirsts;
      if (firsts.isEmpty) return gender == 'Laki-laki' ? 'Budi' : 'Siti';
      final String first = firsts[random.nextInt(firsts.length)];
      final String last = lasts.isNotEmpty ? lasts[random.nextInt(lasts.length)] : '';
      return last.isNotEmpty ? '$first $last' : first;
    }

    String _genAge() => (30 + random.nextInt(25)).toString();

    character.smpTeachers = [
      {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
      {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
      {'name': 'Mr. ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
      {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
      {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
      {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
      {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
      {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
      {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
      {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
    ];
  }

  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();
    _generateTeachersIfNeeded(character);

    final List<Map<String, dynamic>> subjectTemplates = [
      {
        'subject': 'Matematika',
        'statistic': 'Kecerdasan',
        'desc': 'Aljabar, geometri, dan statistika dasar.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Bahasa Indonesia',
        'statistic': 'Kecerdasan & Karma',
        'desc': 'Membuat karya tulis dan pidato.',
        'apply': () {
          int intGain = random.nextInt(3) + 2;
          int karmaGain = random.nextInt(3) + 2;
          character.intelligence = (character.intelligence + intGain).clamp(0, 100);
          character.karma = (character.karma + karmaGain).clamp(0, 100);
          return 'Kecerdasan +$intGain%, Karma +$karmaGain%';
        }
      },
      {
        'subject': 'Bahasa Inggris',
        'statistic': 'Kecerdasan',
        'desc': 'Grammar dan percakapan.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'IPA (Fisika, Biologi, Kimia)',
        'statistic': 'Kecerdasan',
        'desc': 'Dasar-dasar alam semesta.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'IPS (Geografi, Sejarah, Ekonomi)',
        'statistic': 'Kecerdasan',
        'desc': 'Memahami peta, peristiwa, dan ekonomi.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Pendidikan Agama',
        'statistic': 'Karma',
        'desc': 'Etika, moral, dan toleransi.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.karma = (character.karma + gain).clamp(0, 100);
          return 'Karma +$gain%';
        }
      },
      {
        'subject': 'PJOK (Olahraga)',
        'statistic': 'Kesehatan',
        'desc': 'Olahraga tim dan individu.',
        'apply': () {
          int gain = random.nextInt(6) + 3;
          character.health = (character.health + gain).clamp(0, 100);
          return 'Kesehatan +$gain%';
        }
      },
      {
        'subject': 'Seni Budaya',
        'statistic': 'Kebahagiaan',
        'desc': 'Seni rupa atau seni musik.',
        'apply': () {
          int gain = random.nextInt(6) + 4;
          character.happiness = (character.happiness + gain).clamp(0, 100);
          return 'Kebahagiaan +$gain%';
        }
      },
      {
        'subject': 'Prakarya',
        'statistic': 'Kecerdasan',
        'desc': 'Kerajinan tangan, memasak, atau berkebun.',
        'apply': () {
          int gain = random.nextInt(4) + 2;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Informatika / TIK',
        'statistic': 'Kecerdasan',
        'desc': 'Mengenal komputer, coding, atau desain grafis.',
        'apply': () {
          int gain = random.nextInt(6) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
    ];

    final List<Map<String, dynamic>> teachers = [];
    for (int i = 0; i < character.smpTeachers.length; i++) {
      if (i < subjectTemplates.length) {
        teachers.add({
          'name': character.smpTeachers[i]['name'],
          'gender': character.smpTeachers[i]['gender'],
          'age': character.smpTeachers[i]['age'],
          'subject': subjectTemplates[i]['subject'],
          'statistic': subjectTemplates[i]['statistic'],
          'desc': subjectTemplates[i]['desc'],
          'apply': subjectTemplates[i]['apply'],
        });
      }
    }

    DialogHelper.show(
      context: context,
      title: '🧑‍🏫 Daftar Guru (SMP)',
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'Pilih guru yang ingin kamu ajak interaksi:',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ...teachers.map((teacher) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: teacher['gender'] == 'Laki-laki' ? Colors.blue.shade50 : Colors.purple.shade50,
                  radius: 20,
                  child: Image.network(
                    AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: teacher['name']!,
                      gender: teacher['gender'] ?? 'Perempuan',
                      age: int.tryParse(teacher['age'] ?? '40') ?? 40,
                    ),
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(teacher['gender'] == 'Laki-laki' ? Icons.male : Icons.female, color: Colors.blueGrey),
                  ),
                ),
                title: Text(teacher['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Mata Pelajaran: ${teacher['subject']}\nEfek: ${teacher['statistic']}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  _showTeacherInteraction(
                    context,
                    character,
                    teacher['name']!,
                    teacher['subject']!,
                    teacher['desc']!,
                    teacher['apply'] as String Function(),
                    onRefresh,
                  );
                },
              ),
            )),
          ],
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

  static void _showTeacherInteraction(
    BuildContext context,
    Character character,
    String teacherName,
    String subject,
    String subjectDesc,
    String Function() applyEffects,
    VoidCallback onRefresh,
  ) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: 'Interaksi dengan $teacherName',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Text('🙇‍♂️', style: TextStyle(fontSize: 24)),
            title: const Text('Cari Muka', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Membantu menghapus papan tulis kelas.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu membantu $teacherName membersihkan papan tulis dan merapikan spidol. Guru merasa dihargai. Karma +$karmaGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: Text('Belajar $subject', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subjectDesc),
            onTap: () {
              Navigator.pop(context);
              String effectText = applyEffects();
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Belajar Pelajaran $subject',
                content: Text('Kamu fokus belajar materi $subject bersama $teacherName. $subjectDesc\n\nEfek: $effectText'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Text('😜', style: TextStyle(fontSize: 24)),
            title: const Text('Iseng / Mengacau', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Membisiki teman sekelas hingga tertawa.'),
            onTap: () {
              Navigator.pop(context);
              int karmaLoss = random.nextInt(5) + 4;
              int happyGain = random.nextInt(5) + 3;
              character.karma = (character.karma - karmaLoss).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Mengacau di Kelas',
                content: Text('Kamu membuat lelucon saat $teacherName sedang menerangkan pelajaran. Kelas riuh, tapi kamu ditegur keras! Kebahagiaan +$happyGain%, Karma -$karmaLoss%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => showMenu(context, character, onRefresh),
          child: const Text('Kembali'),
        ),
      ],
    );
  }
}
