// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/guru/guru.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class GuruMenu {
  static void _generateTeachersIfNeeded(Character character) {
    // Jika sudah ada, jangan generate ulang
    if (character.smaTeachers.isNotEmpty && character.headmaster != null && character.bkTeacher != null) return;

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

    // --- 1. Generate Kepala Sekolah (30% wanita, 70% pria) ---
    final bool isHeadmasterMale = random.nextInt(100) < 70; // 70% pria
    final String headmasterGender = isHeadmasterMale ? 'Laki-laki' : 'Perempuan';
    final String headmasterPrefix = isHeadmasterMale ? 'Pak ' : 'Bu ';
    character.headmaster = {
      'name': headmasterPrefix + _genName(headmasterGender),
      'gender': headmasterGender,
      'age': _genAge(),
      'role': 'Kepala Sekolah',
    };

    // --- 2. Generate Guru BK (40% wanita, 60% pria) ---
    final bool isBkMale = random.nextInt(100) < 60; // 60% pria
    final String bkGender = isBkMale ? 'Laki-laki' : 'Perempuan';
    final String bkPrefix = isBkMale ? 'Pak ' : 'Bu ';
    character.bkTeacher = {
      'name': bkPrefix + _genName(bkGender),
      'gender': bkGender,
      'age': _genAge(),
      'role': 'Guru BK',
    };

    // --- 3. Generate 20 guru mata pelajaran (seperti sebelumnya) ---
    final List<Map<String, String>> temp = [];
    for (int i = 0; i < 20; i++) {
      final String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final String prefix = gender == 'Laki-laki' ? 'Pak ' : 'Bu ';
      temp.add({
        'name': prefix + _genName(gender),
        'gender': gender,
        'age': _genAge(),
      });
    }
    character.smaTeachers = temp;
  }

  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();
    _generateTeachersIfNeeded(character);

    // 1. Mata Pelajaran Wajib (Semua Jurusan)
    final List<Map<String, dynamic>> subjectTemplates = [
      {
        'subject': 'Matematika Wajib',
        'statistic': 'Kecerdasan',
        'desc': 'Melatih kemampuan analitis dasar.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Bahasa Indonesia',
        'statistic': 'Kecerdasan & Karma',
        'desc': 'Membuat esai dan presentasi.',
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
        'desc': 'Meningkatkan kemampuan bahasa global.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'Pendidikan Agama',
        'statistic': 'Karma',
        'desc': 'Memperdalam moralitas dan spiritualitas.',
        'apply': () {
          int gain = random.nextInt(5) + 3;
          character.karma = (character.karma + gain).clamp(0, 100);
          return 'Karma +$gain%';
        }
      },
      {
        'subject': 'PJOK (Olahraga)',
        'statistic': 'Kesehatan',
        'desc': 'Menjaga stamina dan kesehatan tubuh.',
        'apply': () {
          int gain = random.nextInt(6) + 3;
          character.health = (character.health + gain).clamp(0, 100);
          return 'Kesehatan +$gain%';
        }
      },
      {
        'subject': 'Sejarah Indonesia',
        'statistic': 'Kecerdasan',
        'desc': 'Memahami perjuangan bangsa.',
        'apply': () {
          int gain = random.nextInt(4) + 3;
          character.intelligence = (character.intelligence + gain).clamp(0, 100);
          return 'Kecerdasan +$gain%';
        }
      },
      {
        'subject': 'PPKn',
        'statistic': 'Karma',
        'desc': 'Mempelajari kewarganegaraan dan hukum.',
        'apply': () {
          int gain = random.nextInt(4) + 2;
          character.karma = (character.karma + gain).clamp(0, 100);
          return 'Karma +$gain%';
        }
      },
    ];

    // 2. Mata Pelajaran Peminatan Berdasarkan Jurusan
    final String major = character.smaMajor ?? 'IPA';
    final List<Map<String, dynamic>> peminatanTemplates = [];

    if (major == 'IPA') {
      peminatanTemplates.addAll([
        {
          'subject': 'Matematika Peminatan',
          'statistic': 'Kecerdasan',
          'desc': 'Mempelajari kalkulus tingkat lanjut.',
          'apply': () {
            int gain = random.nextInt(6) + 4;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Fisika',
          'statistic': 'Kecerdasan',
          'desc': 'Memahami mekanika dan termodinamika.',
          'apply': () {
            int gain = random.nextInt(5) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Kimia',
          'statistic': 'Kecerdasan',
          'desc': 'Eksperimen reaksi dan senyawa unsur kimia.',
          'apply': () {
            int gain = random.nextInt(5) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Biologi',
          'statistic': 'Kecerdasan',
          'desc': 'Mempelajari genetika dan evolusi makhluk hidup.',
          'apply': () {
            int gain = random.nextInt(5) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
      ]);
    } else if (major == 'IPS') {
      peminatanTemplates.addAll([
        {
          'subject': 'Geografi',
          'statistic': 'Kecerdasan',
          'desc': 'Mempelajari peta dan tata surya.',
          'apply': () {
            int gain = random.nextInt(4) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Sejarah Peminatan',
          'statistic': 'Kecerdasan',
          'desc': 'Mempelajari sejarah peradaban dunia.',
          'apply': () {
            int gain = random.nextInt(5) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Sosiologi',
          'statistic': 'Kecerdasan',
          'desc': 'Menganalisis interaksi sosial masyarakat.',
          'apply': () {
            int gain = random.nextInt(4) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Ekonomi',
          'statistic': 'Kecerdasan',
          'desc': 'Dasar akuntansi dan kebijakan moneter.',
          'apply': () {
            int gain = random.nextInt(5) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
      ]);
    } else if (major == 'Bahasa') {
      peminatanTemplates.addAll([
        {
          'subject': 'Sastra Indonesia',
          'statistic': 'Kecerdasan & Kebahagiaan',
          'desc': 'Menelaah puisi, prosa, dan novel sastra klasik.',
          'apply': () {
            int intGain = random.nextInt(3) + 2;
            int happyGain = random.nextInt(3) + 2;
            character.intelligence = (character.intelligence + intGain).clamp(0, 100);
            character.happiness = (character.happiness + happyGain).clamp(0, 100);
            return 'Kecerdasan +$intGain%, Kebahagiaan +$happyGain%';
          }
        },
        {
          'subject': 'Antropologi',
          'statistic': 'Kecerdasan',
          'desc': 'Mempelajari kebudayaan dan evolusi budaya manusia.',
          'apply': () {
            int gain = random.nextInt(4) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
        {
          'subject': 'Bahasa Asing (Jepang)',
          'statistic': 'Kecerdasan',
          'desc': 'Dasar komunikasi dan tata bahasa asing pilihan.',
          'apply': () {
            int gain = random.nextInt(5) + 3;
            character.intelligence = (character.intelligence + gain).clamp(0, 100);
            return 'Kecerdasan +$gain%';
          }
        },
      ]);
    }

    final List<Map<String, dynamic>> allSubjects = [...subjectTemplates, ...peminatanTemplates];
    final List<Map<String, dynamic>> teachers = [];

    for (int i = 0; i < allSubjects.length; i++) {
      if (i < character.smaTeachers.length) {
        teachers.add({
          'name': character.smaTeachers[i]['name'],
          'gender': character.smaTeachers[i]['gender'],
          'age': character.smaTeachers[i]['age'],
          'subject': allSubjects[i]['subject'],
          'statistic': allSubjects[i]['statistic'],
          'desc': allSubjects[i]['desc'],
          'apply': allSubjects[i]['apply'],
        });
      }
    }

    // --- KARTU KHUSUS: KEPALA SEKOLAH & GURU BK (di bagian paling atas) ---
    final List<Map<String, dynamic>> specialTeachers = [];
    if (character.headmaster != null) {
      specialTeachers.add({
        'name': character.headmaster!['name'],
        'gender': character.headmaster!['gender'],
        'age': character.headmaster!['age'],
        'role': character.headmaster!['role'],
        'isSpecial': true,
        'type': 'headmaster',
      });
    }
    if (character.bkTeacher != null) {
      specialTeachers.add({
        'name': character.bkTeacher!['name'],
        'gender': character.bkTeacher!['gender'],
        'age': character.bkTeacher!['age'],
        'role': character.bkTeacher!['role'],
        'isSpecial': true,
        'type': 'bk',
      });
    }

    DialogHelper.show(
      context: context,
      title: '🧑‍🏫 Daftar Guru (SMA) - $major',
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Pilih guru jurusan $major yang ingin kamu ajak interaksi:',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
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

            // --- TAMPILKAN DAFTAR GURU MATA PELAJARAN (SISANYA) ---
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
                content: Text('$headmasterName memberikan arahan tentang jurusan kuliah yang sesuai dengan bakatmu. Kecerdasan +$intGain%!'),
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
            subtitle: const Text('Membantu mengurus surat izin / dokumen sekolah.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 3;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Bantuan Administrasi',
                content: Text('Kamu membantu $headmasterName merapikan berkas-berkas sekolah. Karma +$karmaGain%!'),
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
            title: const Text('Cari Muka (Bersih-bersih Ruang Guru)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Membantu membersihkan ruang kepala sekolah.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu menyapu dan merapikan ruangan $headmasterName. Beliau tersenyum dan mengangguk setuju. Karma +$karmaGain%!'),
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
                content: Text('Kamu bercerita tentang rasa cemas menghadapi ujian. $bkName memberimu semangat dan tips rileks. Kebahagiaan +$happyGain%!'),
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
            subtitle: const Text('Mengikuti sesi konseling bersama teman sekelas.'),
            onTap: () {
              Navigator.pop(context);
              int socialGain = random.nextInt(4) + 3;
              character.karma = (character.karma + socialGain).clamp(0, 100);
              character.happiness = (character.happiness + socialGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Diskusi Kelompok BK',
                content: Text('Kamu berbagi cerita dan saling mendukung dengan teman-teman. Karma +$socialGain%, Kebahagiaan +$socialGain%!'),
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
            subtitle: const Text('Mengikuti tes untuk mengetahui potensi diri.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(4) + 2;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Tes Minat Bakat',
                content: Text('$bkName memberikan lembaran tes minat bakat. Kamu mengisinya dengan serius. Kecerdasan +$intGain%!'),
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

  // --- INTERAKSI BIASA: GURU MATA PELAJARAN (SEPERTI SEBELUMNYA) ---
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
            subtitle: const Text('Membantu membersihkan ruangan kelas/kantor.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu menawarkan bantuan merapikan buku pelajaran milik $teacherName. Guru merasa dihargai. Karma +$karmaGain%!'),
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
            subtitle: const Text('Membuat aksi jahil saat kelas berlangsung.'),
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
                content: Text('Kamu meniru suara lucu saat $teacherName menghadap ke papan tulis. Teman-teman tertawa lebar, namun guru memberikan hukuman berdiri! Kebahagiaan +$happyGain%, Karma -$karmaLoss%!'),
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