import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'dart:math';
import 'actions/belajar.dart';
import 'actions/kelas.dart';
import 'actions/guru.dart';
import 'actions/pindah_sekolah.dart';
import 'actions/ekstrakurikuler.dart';

class SchoolMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const SchoolMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<SchoolMenuPage> createState() => _SchoolMenuPageState();
}

class _SchoolMenuPageState extends State<SchoolMenuPage> {
  void _showBolosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rencana Membolos 🏃‍♂️', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah kamu yakin ingin membolos sekolah hari ini? '
          'Tindakan ini berisiko ketahuan guru atau orang tuamu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              _executeBolosSekolah(context);
            },
            child: const Text('Membolos Sekarang', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _executeBolosSekolah(BuildContext context) {
    final character = widget.character;
    final success = Random().nextBool();

    if (success) {
      character.happiness = (character.happiness + 15).clamp(0, 100);
      character.intelligence = (character.intelligence - 8).clamp(0, 100);
      character.discipline = (character.discipline - 2).clamp(0, 100);
      character.karma = (character.karma - 5).clamp(0, 100);
      widget.onRefresh();
      _showOutcomeDialog(context, 'Berhasil Membolos! 🎉', 'Kamu membolos sekolah seharian dan bermain game di rental internet. Rasanya sangat bebas dan menyenangkan! (Kebahagiaan +15, Kecerdasan -8, Disiplin -2)');
    } else {
      character.happiness = (character.happiness - 15).clamp(0, 100);
      character.discipline = (character.discipline - 2).clamp(0, 100);
      character.karma = (character.karma - 5).clamp(0, 100);
      
      if (character.fatherRelationship != null) {
        character.fatherRelationship = (character.fatherRelationship! - 10).clamp(0, 100);
      }
      if (character.motherRelationship != null) {
        character.motherRelationship = (character.motherRelationship! - 10).clamp(0, 100);
      }

      widget.onRefresh();
      _showOutcomeDialog(context, 'Ketahuan Membolos! 🚨', 'Kamu tertangkap basah oleh gurumu saat hendak melompati pagar sekolah. Sekolah melaporkannya ke orang tuamu, dan kamu dihukum berat di rumah! (Kebahagiaan -15, Disiplin -2, Hubungan Orang Tua Berkurang)');
    }
  }

  void _showKeluarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar / Putus Sekolah 🚪', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Keluar dari sekolah secara sepihak akan membatasi opsi karir berkualitas di masa depan. '
          'Apakah kamu yakin ingin putus sekolah sekarang?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(dialogContext);
              _executeKeluarSekolah(context);
            },
            child: const Text('Putus Sekolah', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _executeKeluarSekolah(BuildContext context) {
    final character = widget.character;
    character.classmates.clear();
    character.sdTeachers.clear();
    character.smpTeachers.clear();
    character.smaTeachers.clear();
    character.headmaster = null;
    character.bkTeacher = null;
    character.happiness = (character.happiness - 20).clamp(0, 100);
    
    String currentStage = 'SD';
    if (character.age >= 12 && character.age <= 14) currentStage = 'SMP';
    if (character.age >= 15 && character.age <= 17) currentStage = 'SMA';
    character.educationHistory[currentStage] = 'Putus Sekolah';
    character.inbox.add('🎓 Keluar Sekolah: Kamu memutuskan untuk putus sekolah di usia ${character.age} tahun.');
    widget.onRefresh();
    Navigator.pop(context);

    _showOutcomeDialog(context, 'Putus Sekolah 🛑', 'Kamu resmi keluar dari sekolah. Sekarang kamu tidak memiliki kewajiban sekolah lagi, namun mencari pekerjaan tanpa ijazah akan menjadi lebih menantang!');
  }

  void _showOutcomeDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final int age = character.age;
    String schoolType = 'Sekolah';
    Color themeColor = Colors.blue;

    if (age >= 6 && age <= 11) {
      schoolType = 'Sekolah Dasar (SD)';
      themeColor = Colors.blue;
    } else if (age >= 12 && age <= 14) {
      schoolType = 'Sekolah Menengah Pertama (SMP)';
      themeColor = Colors.blueAccent;
    } else if (age >= 15 && age <= 17) {
      schoolType = 'Sekolah Menengah Atas (SMA)';
      themeColor = Colors.purple;
    }

    final String typeSuffix = character.schoolType != null ? ' (${character.schoolType})' : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(schoolType + typeSuffix),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: themeColor.withOpacity(0.1),
                      child: Icon(Icons.school, size: 40, color: themeColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      character.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Siswa$typeSuffix • Usia: $age tahun',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStat('Kecerdasan', '${character.intelligence}%', Colors.blue),
                        _buildHeaderStat('Kebahagiaan', '${character.happiness}%', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aktivitas Sekolah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            _buildMenuTile(
              context: context,
              icon: Icons.menu_book,
              color: Colors.blue,
              title: 'Belajar Lebih Giat',
              subtitle: 'Meningkatkan tingkat kecerdasan akademik',
              page: BelajarActionPage(character: character, onRefresh: widget.onRefresh),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.group,
              color: Colors.blue,
              title: 'Kelas',
              subtitle: 'Berinteraksi dengan rekan sekelas',
              page: KelasActionPage(character: character, onRefresh: widget.onRefresh),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.person,
              color: Colors.blue,
              title: 'Guru / Staff',
              subtitle: 'Interaksi dengan guru pengajar dan BK',
              page: GuruActionPage(character: character, onRefresh: widget.onRefresh),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.sports_basketball,
              color: Colors.indigo,
              title: 'Ikut Ekstrakurikuler',
              subtitle: 'Mengikuti kegiatan klub & ekstrakurikuler sekolah',
              page: ExtracurricularActionPage(character: character, onRefresh: widget.onRefresh),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.swap_horiz,
              color: Colors.blue,
              title: 'Pindah Sekolah',
              subtitle: 'Mengajukan pindah ke sekolah lain',
              page: PindahSekolahActionPage(character: character, onRefresh: widget.onRefresh),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.directions_run,
              color: Colors.redAccent,
              title: 'Bolos Sekolah',
              subtitle: 'Skip sekolah hari ini untuk main',
              onTap: () => _showBolosDialog(context),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.exit_to_app,
              color: Colors.black87,
              title: 'Keluar Sekolah',
              subtitle: 'Putus sekolah secara mandiri',
              onTap: () => _showKeluarDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () async {
          if (onTap != null) {
            onTap();
          } else if (page != null) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
            setState(() {});
          }
        },
      ),
    );
  }
}
