// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/guru/guru.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class GuruMenu {
  static void _generateTeachersIfNeeded(Character character) {
    if (character.sdTeachers.isNotEmpty && character.sdHeadmaster != null && character.sdBkTeacher != null) return;

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

    String _genAge() => (35 + random.nextInt(25)).toString();

    if (character.sdHeadmaster == null) {
      final bool isHeadmasterMale = random.nextInt(100) < 70;
      final String headmasterGender = isHeadmasterMale ? 'Laki-laki' : 'Perempuan';
      final String headmasterPrefix = isHeadmasterMale ? 'Pak ' : 'Bu ';
      character.sdHeadmaster = {
        'name': headmasterPrefix + _genName(headmasterGender),
        'gender': headmasterGender,
        'age': _genAge(),
        'role': 'Kepala Sekolah',
      };
    }

    if (character.sdBkTeacher == null) {
      final bool isBkMale = random.nextInt(100) < 60;
      final String bkGender = isBkMale ? 'Laki-laki' : 'Perempuan';
      final String bkPrefix = isBkMale ? 'Pak ' : 'Bu ';
      character.sdBkTeacher = {
        'name': bkPrefix + _genName(bkGender),
        'gender': bkGender,
        'age': _genAge(),
        'role': 'Guru BK',
      };
    }

    if (character.sdTeachers.isEmpty) {
      character.sdTeachers = [
        {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
        {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
        {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
        {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
        {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
        {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
        {'name': 'Bu ' + _genName('Perempuan'), 'gender': 'Perempuan', 'age': _genAge()},
        {'name': 'Pak ' + _genName('Laki-laki'), 'gender': 'Laki-laki', 'age': _genAge()},
      ];
    }
  }

  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();
    _generateTeachersIfNeeded(character);

    final List<Map<String, dynamic>> subjectTemplates = [
      {
        'subject': 'Matematika',
        'statistic': 'Kecerdasan',
        'desc': 'Melatih logika dan hitungan.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Bahasa Indonesia',
        'statistic': 'Kecerdasan & Karma',
        'desc': 'Memperbaiki cara berbicara dan menulis.',
        'apply': () {
          int intGain = random.nextInt(3) + 2;
          int karmaGain = random.nextInt(3) + 2;
          character.intelligence = (character.intelligence + intGain).clamp(0, 100);
          character.karma = (character.karma + karmaGain).clamp(0, 100);
          return 'Kecerdasan +$intGain%, Karma +$karmaGain%';
        }
      },
      {
        'subject': 'IPA (Sains)',
        'statistic': 'Kecerdasan',
        'desc': 'Memahami alam sekitar.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'IPS (Sosial)',
        'statistic': 'Kecerdasan',
        'desc': 'Memahami geografi dan sejarah sederhana.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Pendidikan Agama',
        'statistic': 'Karma',
        'desc': 'Menambah nilai moral dan spiritual.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.karma = (character.karma + gain).clamp(0, 100);
          return 'Karma +$gain%';
        }
      },
      {
        'subject': 'PJOK (Olahraga)',
        'statistic': 'Kesehatan',
        'desc': 'Meningkatkan kebugaran jasmani.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.health = (character.health + gain).clamp(0, 100);
          return 'Kesehatan +$gain%';
        }
      },
      {
        'subject': 'Seni Budaya',
        'statistic': 'Kebahagiaan & Penampilan',
        'desc': 'Mengekspresikan kreativitas (menggambar, menyanyi).',
        'apply': () {
          int happyGain = random.nextInt(4) + 2;
          int appGain = random.nextInt(3) + 1;
          character.happiness = (character.happiness + happyGain).clamp(0, 100);
          character.appearance = (character.appearance + appGain).clamp(0, 100);
          return 'Kebahagiaan +$happyGain%, Penampilan +$appGain%';
        }
      },
      {
        'subject': 'Bahasa Inggris',
        'statistic': 'Kecerdasan',
        'desc': 'Dasar bahasa asing.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
    ];

    final List<Map<String, dynamic>> teachers = [];
    for (int i = 0; i < character.sdTeachers.length; i++) {
      if (i < subjectTemplates.length) {
        teachers.add({
          'name': character.sdTeachers[i]['name'],
          'gender': character.sdTeachers[i]['gender'],
          'age': character.sdTeachers[i]['age'],
          'subject': subjectTemplates[i]['subject'],
          'statistic': subjectTemplates[i]['statistic'],
          'desc': subjectTemplates[i]['desc'],
          'apply': subjectTemplates[i]['apply'],
        });
      }
    }

    final List<Map<String, dynamic>> specialTeachers = [];
    if (character.sdHeadmaster != null) {
      specialTeachers.add({
        'name': character.sdHeadmaster!['name'],
        'gender': character.sdHeadmaster!['gender'],
        'age': character.sdHeadmaster!['age'],
        'role': character.sdHeadmaster!['role'],
        'isSpecial': true,
        'type': 'headmaster',
      });
    }
    if (character.sdBkTeacher != null) {
      specialTeachers.add({
        'name': character.sdBkTeacher!['name'],
        'gender': character.sdBkTeacher!['gender'],
        'age': character.sdBkTeacher!['age'],
        'role': character.sdBkTeacher!['role'],
        'isSpecial': true,
        'type': 'bk',
      });
    }

    DialogHelper.show(
      context: context,
      title: '🧑‍🏫 Daftar Guru (SD)',
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

            // --- TAMPILKAN KEPALA SEKOLAH & GURU BK ---
            ...specialTeachers.map((teacher) => Card(
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
                subtitle: Text(teacher['role']!),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  if (teacher['type'] == 'headmaster') {
                    _showHeadmasterInteraction(context, character, teacher['name']!, onRefresh);
                  } else if (teacher['type'] == 'bk') {
                    _showBkInteraction(context, character, teacher['name']!, onRefresh);
                  }
                },
              ),
            )),

            // --- TAMPILKAN GURU MATA PELAJARAN ---
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

  // --- INTERAKSI KHUSUS: KEPALA SEKOLAH ---
  static void _showHeadmasterInteraction(
    BuildContext context,
    Character character,
    String headmasterName,
    VoidCallback onRefresh,
  ) {
    final Random random = Random();
    DialogHelper.show(
      context: context,
      title: 'Interaksi dengan Kepala Sekolah $headmasterName',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Text('🗣️', style: TextStyle(fontSize: 24)),
            title: const Text('Konsultasi Akademik', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mendapatkan saran tentang masa depan pendidikan.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(4) + 3;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Konsultasi dengan Kepsek',
                content: Text('$headmasterName memberikan arahan tentang cara belajar efektif di sekolah dasar. Kecerdasan +$intGain%!'),
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
            leading: const Text('📋', style: TextStyle(fontSize: 24)),
            title: const Text('Bantuan Administrasi', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Membantu merapikan berkas sekolah sederhana.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 3;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Bantuan Administrasi',
                content: Text('Kamu membantu $headmasterName menata dokumen di lemari. Karma +$karmaGain%!'),
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
            leading: const Text('🧹', style: TextStyle(fontSize: 24)),
            title: const Text('Cari Muka', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Membantu membersihkan ruangan kepala sekolah.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu membersihkan debu di meja kerja $headmasterName. Beliau sangat senang. Karma +$karmaGain%!'),
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

  // --- INTERAKSI KHUSUS: GURU BK ---
  static void _showBkInteraction(
    BuildContext context,
    Character character,
    String bkName,
    VoidCallback onRefresh,
  ) {
    final Random random = Random();
    DialogHelper.show(
      context: context,
      title: 'Interaksi dengan Guru BK $bkName',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Text('🧠', style: TextStyle(fontSize: 24)),
            title: const Text('Konsultasi Pribadi', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bicara tentang masalah pribadi atau tekanan belajar.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(5) + 4;
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Konsultasi BK',
                content: Text('Kamu bercerita tentang kesulitan bersosialisasi. $bkName mendengarkan dengan penuh empati. Kebahagiaan +$happyGain%!'),
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
            leading: const Text('👥', style: TextStyle(fontSize: 24)),
            title: const Text('Diskusi Kelompok', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Konseling kelompok tentang persahabatan.'),
            onTap: () {
              Navigator.pop(context);
              int socialGain = random.nextInt(4) + 3;
              character.karma = (character.karma + socialGain).clamp(0, 100);
              character.happiness = (character.happiness + socialGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Konseling Kelompok',
                content: Text('Kamu bermain peran persahabatan yang harmonis bersama teman-teman dibimbing $bkName. Karma +$socialGain%, Kebahagiaan +$socialGain%!'),
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
            leading: const Text('📝', style: TextStyle(fontSize: 24)),
            title: const Text('Tes Minat Bakat', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mengikuti tes gambar psikologi sederhana.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(4) + 2;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Tes Minat Bakat',
                content: Text('$bkName mengajakmu menggambar pohon dan rumah untuk tes kepribadian. Kecerdasan +$intGain%!'),
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
            subtitle: const Text('Membantu membawakan buku ke kantor guru.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu membantu $teacherName membawakan tumpukan buku ke kantor. Guru merasa senang. Karma +$karmaGain%!'),
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
            subtitle: const Text('Melakukan aksi usil di kelas saat jam pelajaran.'),
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
                content: Text('Kamu menyembunyikan penghapus papan tulis milik $teacherName! Teman sekelasmu tertawa, tapi guru memarahimu. Kebahagiaan +$happyGain%, Karma -$karmaLoss%!'),
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
