// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menu/ekstrakurikuler/ekstrakurikuler.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class EkstrakurikulerMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🏀 Ekstrakurikuler (SMP)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ikuti kegiatan ekstrakurikuler di SMP:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // 1. Pramuka (Penggalang)
          ListTile(
            leading: const Text('camping', style: TextStyle(fontSize: 24)),
            title: const Text('Pramuka (Penggalang)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pengembangan karakter dan jiwa kepemimpinan.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 3;
              int happyGain = random.nextInt(4) + 3;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Pramuka',
                content: Text('Kamu belajar memimpin tim dalam kegiatan perkemahan! Karma +$karmaGain%, Kebahagiaan +$happyGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 2. PMR (Palang Merah Remaja)
          ListTile(
            leading: const Text('✚', style: TextStyle(fontSize: 24)),
            title: const Text('PMR (Palang Merah Remaja)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pelatihan pertolongan pertama dan aksi sosial.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(5) + 4;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'PMR',
                content: Text('Kamu mengikuti pelatihan pertolongan pertama dan mengunjungi panti asuhan. Karma +$karmaGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 3. Olahraga (Basket, Voli, Futsal, Badminton)
          ListTile(
            leading: const Text('🏀', style: TextStyle(fontSize: 24)),
            title: const Text('Olahraga (Basket/Voli/Futsal/Badminton)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Olahraga tim dan individu.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(5) + 4;
              int happyGain = random.nextInt(4) + 3;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Olahraga',
                content: Text('Kamu memenangkan pertandingan futsal antar kelas! Kesehatan +$healthGain%, Kebahagiaan +$happyGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 4. Beladiri (Karate, Taekwondo, Pencak Silat)
          ListTile(
            leading: const Text('🥋', style: TextStyle(fontSize: 24)),
            title: const Text('Beladiri (Karate/Taekwondo/Pencak Silat)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melatih pengendalian diri dan pertahanan.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(5) + 4;
              int karmaGain = random.nextInt(3) + 2;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Beladiri',
                content: Text('Kamu berlatih jurus dan disiplin di dojo. Kesehatan +$healthGain%, Karma +$karmaGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 5. Seni (Teater, Tari, Paduan Suara, Band)
          ListTile(
            leading: const Text('🎭', style: TextStyle(fontSize: 24)),
            title: const Text('Seni (Teater/Tari/Paduan Suara/Band)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ekspresi kreativitas dan seni pertunjukan.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(5) + 4;
              int appGain = random.nextInt(4) + 3;
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Seni',
                content: Text('Kamu tampil di panggung pentas seni sekolah! Kebahagiaan +$happyGain%, Penampilan +$appGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 6. KIR (Karya Ilmiah Remaja)
          ListTile(
            leading: const Text('🔬', style: TextStyle(fontSize: 24)),
            title: const Text('KIR (Karya Ilmiah Remaja)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Penelitian sederhana, eksperimen sains, dan lomba KIR.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(6) + 4;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'KIR',
                content: Text('Kamu melakukan eksperimen kimia dan membuat laporan penelitian! Kecerdasan +$intGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 7. Jurnalistik & Fotografi
          ListTile(
            leading: const Text('📸', style: TextStyle(fontSize: 24)),
            title: const Text('Jurnalistik & Fotografi', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Menulis berita, majalah dinding, dan dokumentasi foto.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(4) + 3;
              int appGain = random.nextInt(3) + 2;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Jurnalistik & Fotografi',
                content: Text('Kamu menulis berita untuk majalah dinding dan mengambil foto acara sekolah. Kecerdasan +$intGain%, Penampilan +$appGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 8. Robotika & Coding
          ListTile(
            leading: const Text('🤖', style: TextStyle(fontSize: 24)),
            title: const Text('Robotika & Coding', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pemrograman tingkat menengah dan mikrokontroler.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(6) + 4;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Robotika & Coding',
                content: Text('Kamu memprogram Arduino untuk membuat robot pengikut garis! Kecerdasan +$intGain%!'),
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
      ],
    );
  }
}
