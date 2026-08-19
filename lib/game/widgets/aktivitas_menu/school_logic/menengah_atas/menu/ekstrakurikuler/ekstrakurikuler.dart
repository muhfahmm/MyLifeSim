// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/ekstrakurikuler/ekstrakurikuler.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class EkstrakurikulerMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🎯 Ekstrakurikuler (SMA)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ikuti klub ekstrakurikuler di SMA:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // 1. Pramuka (Penegak)
          ListTile(
            leading: const Text('camping', style: TextStyle(fontSize: 24)),
            title: const Text('Pramuka (Penegak)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Latihan survival dan kepemimpinan di alam terbuka.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(5) + 4;
              int healthGain = random.nextInt(4) + 3;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              character.health = (character.health + healthGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Pramuka',
                content: Text('Kamu mengikuti perkemahan 3 hari 2 malam dan memimpin regumu! Karma +$karmaGain%, Kesehatan +$healthGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 2. PMR (Palang Merah Remaja) / KSR
          ListTile(
            leading: const Text('✚', style: TextStyle(fontSize: 24)),
            title: const Text('PMR / KSR (KSR = Korps Sukarela)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Dasar-dasar kedokteran dan aksi kemanusiaan.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(6) + 4;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'PMR / KSR',
                content: Text('Kamu belajar pertolongan pertama, resusitasi jantung paru (RJP), dan donor darah. Karma +$karmaGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 3. OSN (Olimpiade Sains)
          ListTile(
            leading: const Text('🏆', style: TextStyle(fontSize: 24)),
            title: const Text('OSN (Olimpiade Sains)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Persiapan lomba olimpiade Fisika, Kimia, Biologi, Matematika, Astronomi, Ekonomi, Geografi.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(8) + 6;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'OSN',
                content: Text('Kamu belajar soal-soal olimpiade dan memenangkan lomba tingkat kabupaten! Kecerdasan +$intGain% (BESAR)!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 4. Olahraga & Beladiri (Futsal, Voli, Pencak Silat, Cheerleaders)
          ListTile(
            leading: const Text('⚽', style: TextStyle(fontSize: 24)),
            title: const Text('Olahraga & Beladiri (Futsal/Voli/Pencak Silat/Cheerleaders)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Kebugaran jasmani dan prestasi tingkat provinsi/nasional.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(6) + 4;
              int happyGain = random.nextInt(5) + 4;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Olahraga & Beladiri',
                content: Text('Kamu berlatih futsal dan mewakili sekolah di tingkat provinsi! Kesehatan +$healthGain%, Kebahagiaan +$happyGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 5. Seni (Paduan Suara, Band, Teater, Tari)
          ListTile(
            leading: const Text('🎭', style: TextStyle(fontSize: 24)),
            title: const Text('Seni (Paduan Suara/Band/Teater/Tari)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Kesenian tingkat profesional.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(6) + 4;
              int appGain = random.nextInt(5) + 3;
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Seni',
                content: Text('Kamu tampil di pentas akhir tahun dengan penampilan memukau! Kebahagiaan +$happyGain%, Penampilan +$appGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 6. Jurnalistik, Fotografi, & Film Maker
          ListTile(
            leading: const Text('🎥', style: TextStyle(fontSize: 24)),
            title: const Text('Jurnalistik, Fotografi, & Film Maker', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Media massa, pembuatan film pendek, dan dokumenter.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(6) + 4;
              int appGain = random.nextInt(4) + 3;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Jurnalistik & Film Maker',
                content: Text('Kamu membuat film dokumenter pendek dan artikel berita untuk website sekolah. Kecerdasan +$intGain%, Penampilan +$appGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 7. Robotika & Pemrograman
          ListTile(
            leading: const Text('🤖', style: TextStyle(fontSize: 24)),
            title: const Text('Robotika & Pemrograman', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pengembangan aplikasi, game dev, dan Arduino/Raspi.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(8) + 6;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Robotika & Pemrograman',
                content: Text('Kamu membuat game sederhana dengan Python dan mengontrol robot dengan Raspberry Pi! Kecerdasan +$intGain% (BESAR)!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 8. Desain Grafis & Multimedia
          ListTile(
            leading: const Text('🎨', style: TextStyle(fontSize: 24)),
            title: const Text('Desain Grafis & Multimedia', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Adobe Photoshop, Illustrator, dan animasi 2D/3D.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(6) + 4;
              int appGain = random.nextInt(5) + 3;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Desain Grafis & Multimedia',
                content: Text('Kamu membuat desain poster untuk acara sekolah dengan Photoshop! Kecerdasan +$intGain%, Penampilan +$appGain%!'),
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
