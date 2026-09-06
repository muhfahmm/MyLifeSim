// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/ekstrakurikuler.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class ExtracurricularActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const ExtracurricularActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<ExtracurricularActionPage> createState() => _ExtracurricularActionPageState();
}

class _ExtracurricularActionPageState extends State<ExtracurricularActionPage> {
  final Random _random = Random();

  List<String> _getAvailableClubs() {
    final int age = widget.character.age;
    if (age >= 6 && age <= 11) { // SD
      return [
        'Paduan Suara',
        'Seni Tari',
        'Olahraga',
        'Prakarya',
        'Robotic',
        'Coding',
        'English Club',
      ];
    } else if (age >= 12 && age <= 14) { // SMP
      return [
        'Klub Sains',
        'Olahraga',
        'Robotic',
        'Coding',
        'English Club',
      ];
    } else { // SMA (>=15)
      return [
        'Photography / Videography Club',
        'Klub Debat',
        'Klub Sains',
        'Olahraga',
        'Robotic',
        'Coding',
        'English Club',
      ];
    }
  }

  IconData _getClubIcon(String clubName) {
    if (clubName.contains('Paduan Suara')) return Icons.mic;
    if (clubName.contains('Seni Tari')) return Icons.directions_run;
    if (clubName.contains('Olahraga')) return Icons.sports_soccer;
    if (clubName.contains('Prakarya')) return Icons.brush;
    if (clubName.contains('Robotic')) return Icons.precision_manufacturing;
    if (clubName.contains('Coding')) return Icons.code;
    if (clubName.contains('English')) return Icons.language;
    if (clubName.contains('Sains')) return Icons.science;
    if (clubName.contains('Photography')) return Icons.camera_alt;
    if (clubName.contains('Debat')) return Icons.record_voice_over;
    return Icons.star;
  }

  void _showOutcome(String title, String content) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {});
            widget.onRefresh();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  void _showSportsModal() {
    final sports = ['Sepakbola', 'Voli', 'Basket', 'Badminton', 'Renang'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sports_soccer, color: Colors.orange),
            SizedBox(width: 8),
            Text('Pilih Cabang Olahraga'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sports.map((sport) {
            IconData sportIcon = Icons.sports;
            if (sport == 'Sepakbola') sportIcon = Icons.sports_soccer;
            if (sport == 'Voli') sportIcon = Icons.sports_volleyball;
            if (sport == 'Basket') sportIcon = Icons.sports_basketball;
            if (sport == 'Badminton') sportIcon = Icons.sports_tennis;
            if (sport == 'Renang') sportIcon = Icons.pool;

            bool isSportJoined = widget.character.joinedExtracurriculars.contains('Olahraga ($sport)');

            return ListTile(
              leading: Icon(sportIcon, color: isSportJoined ? Colors.green : Colors.orange),
              title: Row(
                children: [
                  Text(sport, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (isSportJoined) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ],
              ),
              subtitle: isSportJoined ? const Text('Sudah diikuti (Ketuk untuk latihan)', style: TextStyle(color: Colors.green, fontSize: 12)) : null,
              onTap: () {
                Navigator.pop(ctx);
                _joinOrPracticeSport(sport);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _joinOrPracticeSport(String sportName) {
    bool isAlreadyMember = widget.character.joinedExtracurriculars.contains('Olahraga ($sportName)');
    if (!isAlreadyMember) {
      widget.character.joinedExtracurriculars.add('Olahraga ($sportName)');
      widget.character.health = (widget.character.health + 5).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
      _showOutcome(
        'Bergabung Ekstrakurikuler! ⚽',
        'Kamu resmi bergabung dengan tim Ekstrakurikuler Olahraga ($sportName)!\n\n'
        'Kesehatan +5%\n'
        'Kebahagiaan +5%',
      );
    } else {
      int healthGain = 2 + _random.nextInt(4);
      int hapGain = 2 + _random.nextInt(3);
      widget.character.health = (widget.character.health + healthGain).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness + hapGain).clamp(0, 100);
      _showOutcome(
        'Latihan Olahraga 🏃‍♂️',
        'Kamu mengikuti sesi latihan $sportName dengan penuh semangat!\n\n'
        'Kesehatan +$healthGain%\n'
        'Kebahagiaan +$hapGain%',
      );
    }
  }

  void _handleClubTap(String clubName) {
    if (clubName == 'Olahraga') {
      _showSportsModal();
      return;
    }

    bool isAlreadyMember = widget.character.joinedExtracurriculars.contains(clubName);
    if (!isAlreadyMember) {
      widget.character.joinedExtracurriculars.add(clubName);
      
      int smartsGain = 0;
      int hapGain = 5;
      if (clubName.contains('Robotic') || clubName.contains('Coding') || clubName.contains('Sains') || clubName.contains('Debat')) {
        smartsGain = 5;
      }

      widget.character.happiness = (widget.character.happiness + hapGain).clamp(0, 100);
      if (smartsGain > 0) {
        widget.character.intelligence = (widget.character.intelligence + smartsGain).clamp(0, 100);
      }

      _showOutcome(
        'Bergabung Ekstrakurikuler! 🎉',
        'Kamu resmi mendaftar dan bergabung dalam $clubName!\n\n'
        'Kebahagiaan +$hapGain%${smartsGain > 0 ? '\nKecerdasan +$smartsGain%' : ''}',
      );
    } else {
      int smartsGain = 0;
      int hapGain = 2 + _random.nextInt(3);
      if (clubName.contains('Robotic') || clubName.contains('Coding') || clubName.contains('Sains') || clubName.contains('Debat')) {
        smartsGain = 2 + _random.nextInt(3);
      }

      widget.character.happiness = (widget.character.happiness + hapGain).clamp(0, 100);
      if (smartsGain > 0) {
        widget.character.intelligence = (widget.character.intelligence + smartsGain).clamp(0, 100);
      }

      _showOutcome(
        'Kegiatan Ekstrakurikuler 🌟',
        'Kamu aktif mengikuti kegiatan rutin $clubName bersama teman-teman!\n\n'
        'Kebahagiaan +$hapGain%${smartsGain > 0 ? '\nKecerdasan +$smartsGain%' : ''}',
      );
    }
  }

  void _quitClub(String clubName) {
    widget.character.joinedExtracurriculars.remove(clubName);
    _showOutcome('Keluar dari Ekstrakurikuler 🚪', 'Kamu telah mengundurkan diri dari $clubName.');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final clubs = _getAvailableClubs();
    final joined = widget.character.joinedExtracurriculars;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekstrakurikuler Sekolah'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (joined.isNotEmpty) ...[
              const Text(
                'Ekstrakurikuler Yang Diikuti',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: joined.map((jClub) {
                    return ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(jClub, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Ketuk untuk latihan • Status: Anggota Aktif', style: TextStyle(color: Colors.green, fontSize: 12)),
                      trailing: IconButton(
                        icon: const Icon(Icons.exit_to_app, color: Colors.red),
                        tooltip: 'Keluar Ekskul',
                        onPressed: () => _quitClub(jClub),
                      ),
                      onTap: () {
                        if (jClub.startsWith('Olahraga (')) {
                          final sportName = jClub.replaceFirst('Olahraga (', '').replaceAll(')', '');
                          _joinOrPracticeSport(sportName);
                        } else {
                          _handleClubTap(jClub);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Text(
              'Pilihan Ekstrakurikuler Sekolah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                final clubName = clubs[index];
                bool hasAnySport = joined.any((j) => j.startsWith('Olahraga ('));
                bool isMember = (clubName == 'Olahraga')
                    ? hasAnySport
                    : joined.contains(clubName);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isMember ? Colors.green.shade100 : Colors.indigo.shade50,
                      child: Icon(_getClubIcon(clubName), color: isMember ? Colors.green : Colors.indigo),
                    ),
                    title: Text(
                      clubName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      clubName == 'Olahraga'
                          ? (hasAnySport ? 'Sudah mendaftar cabor (Ketuk untuk pilih cabor lagi)' : 'Ketuk untuk mendaftar/pilih cabang olahraga')
                          : (isMember ? 'Sudah bergabung (Ketuk untuk latihan)' : 'Ketuk untuk mendaftar & bergabung'),
                      style: TextStyle(fontSize: 12, color: isMember ? Colors.green : Colors.grey),
                    ),
                    trailing: Icon(
                      isMember ? Icons.play_arrow : Icons.add_circle_outline,
                      color: isMember ? Colors.green : Colors.indigo,
                    ),
                    onTap: () => _handleClubTap(clubName),
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
