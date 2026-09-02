// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// Import Lomba SD
import 'lomba_logic/lomba_sd/lomba_gambar.dart';
import 'lomba_logic/lomba_sd/lomba_menyanyi.dart';
import 'lomba_logic/lomba_sd/lomba_matematika.dart';
import 'lomba_logic/lomba_sd/lomba_hafalan.dart';
import 'lomba_logic/lomba_sd/lomba_lari.dart';
import 'lomba_logic/lomba_sd/lomba_science_fair.dart';

// Import Lomba SMP
import 'lomba_logic/lomba_smp/lomba_osn_smp.dart';
import 'lomba_logic/lomba_smp/lomba_debat_smp.dart';
import 'lomba_logic/lomba_smp/lomba_essay_smp.dart';
import 'lomba_logic/lomba_smp/lomba_robotik_smp.dart';
import 'lomba_logic/lomba_smp/lomba_turnamen_olahraga_smp.dart';
import 'lomba_logic/lomba_smp/lomba_musik_smp.dart';
import 'lomba_logic/lomba_smp/lomba_pramuka_smp.dart';

// Import Lomba SMA
import 'lomba_logic/lomba_sma/lomba_mun_sma.dart';
import 'lomba_logic/lomba_sma/lomba_osn_sma.dart';
import 'lomba_logic/lomba_sma/lomba_film_sma.dart';
import 'lomba_logic/lomba_sma/lomba_esports_sma.dart';
import 'lomba_logic/lomba_sma/lomba_desain_sma.dart';
import 'lomba_logic/lomba_sma/lomba_riset_sma.dart';
import 'lomba_logic/lomba_sma/lomba_jurnalistik_sma.dart';

class LombaActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const LombaActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<LombaActionPage> createState() => _LombaActionPageState();
}

class _LombaActionPageState extends State<LombaActionPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int age = widget.character.age;

    String schoolTitle = 'Lomba Sekolah';
    String focusText = '';
    List<Map<String, dynamic>> lombaList = [];

    if (age >= 6 && age <= 11) {
      schoolTitle = 'Lomba Jenjang SD (Usia 6-11)';
      focusText = 'Fokus: Kreativitas & Kesenangan • Lomba ringan dan menumbuhkan kepercayaan diri.';
      lombaList = [
        {
          'title': 'Lomba Menggambar & Mewarnai',
          'category': 'Seni',
          'effect': 'Kebahagiaan +, Penampilan +. Hadiah Uang (jika menang).',
          'icon': Icons.palette,
          'color': Colors.pink,
          'action': () => runLombaGambarSD(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Menyanyi Solo / Paduan Suara',
          'category': 'Musik',
          'effect': 'Kebahagiaan +, Penampilan +.',
          'icon': Icons.mic,
          'color': Colors.purple,
          'action': () => runLombaMenyanyiSD(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Matematika & Berhitung Cepat',
          'category': 'Akademik',
          'effect': 'Kecerdasan +, Tekad +.',
          'icon': Icons.calculate,
          'color': Colors.blue,
          'action': () => runLombaMatematikaSD(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Mengingat Pengetahuan Umum / Cerdas Cermat Memory',
          'category': 'Pengetahuan Umum & Sains',
          'effect': 'Kecerdasan +, Disiplin +.',
          'icon': Icons.psychology,
          'color': Colors.teal,
          'action': () => runLombaHafalanSD(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Lari / Estafet / Olahraga Dasar',
          'category': 'Fisik',
          'effect': 'Kesehatan +, Tekad +.',
          'icon': Icons.directions_run,
          'color': Colors.orange,
          'action': () => runLombaLariSD(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Science Fair Sederhana',
          'category': 'Sains',
          'effect': 'Kecerdasan + (eksplorasi awal).',
          'icon': Icons.science,
          'color': Colors.indigo,
          'action': () => runLombaScienceFairSD(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
      ];
    } else if (age >= 12 && age <= 14) {
      schoolTitle = 'Lomba Jenjang SMP (Usia 12-14)';
      focusText = 'Fokus: Pengembangan Skill & Kompetisi • Berkompetisi dan berorientasi pada prestasi.';
      lombaList = [
        {
          'title': 'Olimpiade Sains Nasional (Fisika, Biologi, Kimia, Matematika)',
          'category': 'Akademik',
          'effect': 'Kecerdasan ++, Tekad +. Hadiah Uang (\$100-\$500) + Beasiswa SMA.',
          'icon': Icons.school,
          'color': Colors.blue,
          'action': () => runLombaOsnSMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Debat & Retorika',
          'category': 'Bahasa & Logika',
          'effect': 'Kecerdasan +, Penampilan (public speaking) +.',
          'icon': Icons.record_voice_over,
          'color': Colors.deepOrange,
          'action': () => runLombaDebatSMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Essay & Cerpen',
          'category': 'Bahasa & Sastra',
          'effect': 'Kecerdasan +. Hadiah Uang + kesempatan diterbitkan.',
          'icon': Icons.edit_note,
          'color': Colors.amber.shade800,
          'action': () => runLombaEssaySMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Robotik & Coding',
          'category': 'Teknologi',
          'effect': 'Kecerdasan ++, Tekad +. Hadiah Uang besar + kesempatan lomba internasional.',
          'icon': Icons.precision_manufacturing,
          'color': Colors.cyan,
          'action': () => runLombaRobotikSMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Turnamen Badminton / Basket / Voli',
          'category': 'Olahraga',
          'effect': 'Kesehatan +, Tekad +, Kerja sama +. Hadiah Uang (jika menang).',
          'icon': Icons.sports_basketball,
          'color': Colors.green,
          'action': () => runLombaOlahragaSMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Band / Musik Akustik',
          'category': 'Seni & Musik',
          'effect': 'Kebahagiaan +, Penampilan +. Hadiah Uang + rekaman demo.',
          'icon': Icons.music_note,
          'color': Colors.purple,
          'action': () => runLombaMusikSMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Jambore Pramuka / Scouts Competition',
          'category': 'Outdoor',
          'effect': 'Disiplin +, Kesehatan +, Tekad +.',
          'icon': Icons.forest,
          'color': Colors.brown,
          'action': () => runLombaPramukaSMP(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
      ];
    } else {
      schoolTitle = 'Lomba Jenjang SMA (Usia 15-18)';
      focusText = 'Fokus: Prestige, Karier, & Jalur Universitas • Sangat berdampak pada masa depan karakter.';
      lombaList = [
        {
          'title': 'Model United Nations (MUN) / Debat Nasional',
          'category': 'Sosial & Diplomasi',
          'effect': 'Kecerdasan ++, Penampilan ++. Hadiah Uang + kesempatan karier Diplomat/Pengacara.',
          'icon': Icons.public,
          'color': Colors.blue.shade800,
          'action': () => runLombaMunSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Olimpiade Sains Tingkat Nasional/Internasional',
          'category': 'Akademik',
          'effect': 'Kecerdasan +++, Tekad ++. Hadiah Uang besar (\$1000+) + Beasiswa Universitas.',
          'icon': Icons.stars,
          'color': Colors.amber.shade700,
          'action': () => runLombaOsnSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Film Pendek / Fotografi / Videografi',
          'category': 'Multimedia',
          'effect': 'Penampilan +, Kecerdasan (produksi) +. Hadiah Uang + kesempatan Content Creator.',
          'icon': Icons.videocam,
          'color': Colors.redAccent,
          'action': () => runLombaFilmSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Turnamen Esports Profesional',
          'category': 'Gaming',
          'effect': 'Kecerdasan +, Kebahagiaan +, Uang sangat besar (\$2000+). Membuka karier Pro Player.',
          'icon': Icons.sports_esports,
          'color': Colors.deepPurple,
          'action': () => runLombaEsportsSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Desain Grafis / UI/UX',
          'category': 'Teknologi & Kreatif',
          'effect': 'Kecerdasan +, Penampilan +. Hadiah Uang + portofolio untuk kerja.',
          'icon': Icons.design_services,
          'color': Colors.teal,
          'action': () => runLombaDesainSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Sains Fair / Riset Ilmiah Remaja',
          'category': 'Riset',
          'effect': 'Kecerdasan ++, Tekad +. Hadiah Uang + peluang publikasi.',
          'icon': Icons.science,
          'color': Colors.indigo,
          'action': () => runLombaRisetSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
        {
          'title': 'Lomba Menulis Jurnalistik / Feature',
          'category': 'Media',
          'effect': 'Kecerdasan +. Hadiah Uang + kesempatan magang.',
          'icon': Icons.newspaper,
          'color': Colors.orange.shade800,
          'action': () => runLombaJurnalistikSMA(context, widget.character, () {
                setState(() {});
                widget.onRefresh();
              }),
        },
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(schoolTitle),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              color: isDark ? Colors.amber.shade900.withOpacity(0.3) : Colors.amber.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        focusText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar Lomba Tersedia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lombaList.length,
              itemBuilder: (context, index) {
                final item = lombaList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (item['color'] as Color).withOpacity(0.15),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color),
                    ),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          'Kategori: ${item['category']}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item['color'] as Color),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['effect'] as String,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.emoji_events_outlined, color: Colors.amber),
                    onTap: item['action'] as VoidCallback,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
