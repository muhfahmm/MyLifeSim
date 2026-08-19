// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/guru/guru.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class GuruMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    final List<Map<String, String>> teachers = [
      {'name': 'Bu Sri (Wali Kelas)', 'subject': 'Tematik'},
      {'name': 'Pak Bambang', 'subject': 'Matematika'},
      {'name': 'Pak Joko', 'subject': 'Olahraga'},
    ];

    DialogHelper.show(
      context: context,
      title: '🧑‍🏫 Daftar Guru (SD)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
              leading: const Text('🧑‍🏫', style: TextStyle(fontSize: 24)),
              title: Text(teacher['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Guru Pelajaran: ${teacher['subject']}'),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
                _showTeacherInteraction(context, character, teacher['name']!, onRefresh);
              },
            ),
          )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
      ],
    );
  }

  static void _showTeacherInteraction(BuildContext context, Character character, String teacherName, VoidCallback onRefresh) {
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
            subtitle: const Text('Berperilaku sangat sopan di depan guru.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu membantu guru membawakan buku ke kantor. Guru merasa senang. Karma +$karmaGain%!'),
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
            leading: const Text('🙋‍♂️', style: TextStyle(fontSize: 24)),
            title: const Text('Tanya Pelajaran', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bertanya tentang tugas atau materi kelas.'),
            onTap: () {
              Navigator.pop(context);
              int smartGain = random.nextInt(4) + 3;
              character.intelligence = (character.intelligence + smartGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Tanya Pelajaran',
                content: Text('Kamu menanyakan bagian materi yang belum dipahami dan dijelaskan dengan detail. Kecerdasan +$smartGain%!'),
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
            title: const Text('Jahili Guru / Mengacau', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melakukan aksi nakal di kelas.'),
            onTap: () {
              Navigator.pop(context);
              int karmaLoss = random.nextInt(5) + 4;
              int happyGain = random.nextInt(5) + 3;
              character.karma = (character.karma - karmaLoss).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Mengacau',
                content: Text('Kamu menyembunyikan spidol guru! Teman-teman tertawa, tapi guru marah besar. Kebahagiaan +$happyGain%, Karma -$karmaLoss%!'),
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
