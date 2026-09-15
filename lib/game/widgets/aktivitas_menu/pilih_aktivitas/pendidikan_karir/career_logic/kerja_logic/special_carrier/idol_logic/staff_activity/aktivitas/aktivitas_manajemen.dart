import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class AktivitasManajemenPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AktivitasManajemenPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AktivitasManajemenPage> createState() => _AktivitasManajemenPageState();
}

class _AktivitasManajemenPageState extends State<AktivitasManajemenPage> {
  void _lakukanAktivitasStaf(String tipe, int stressCost, int disciplineGain) {
    setState(() {
      widget.character.happiness = (widget.character.happiness - stressCost).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + disciplineGain).clamp(0, 100);
      
      // Improve relationship with a random staff member or idol member
      final sourceList = widget.character.idolStaff.isNotEmpty
          ? widget.character.idolStaff
          : widget.character.idolMainMembers;
      if (sourceList.isNotEmpty) {
        final rand = Random();
        final idx = rand.nextInt(sourceList.length);
        final person = sourceList[idx];
        int currentRel = int.tryParse(person['relationship'] ?? '50') ?? 50;
        person['relationship'] = (currentRel + rand.nextInt(5) + 3).clamp(0, 100).toString();
      }
    });
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Aktivitas Staf & Manajemen 💼✨',
      content: Text(
        'Kamu melaksanakan "$tipe". Manajerial dan kedisiplinan tim meningkat (Kedisiplinan: ${widget.character.discipline}%).\n'
        'Hubungan dengan rekan kerja/idol juga semakin erat! Kebahagiaanmu berkurang -$stressCost% karena mengurus operasional.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kerja Bagus!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivitas Staf & Manajemen 💼'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildActionCard(
            title: 'Perekrutan Generasi Trainee Baru 📋',
            desc: 'Mengorganisir audisi dan seleksi kandidat member idol generasi baru (Disiplin +6%, Kebahagiaan -4%)',
            onTap: () => _lakukanAktivitasStaf('Perekrutan Generasi Trainee Baru', 4, 6),
          ),
          _buildActionCard(
            title: 'Evaluasi Kinerja Idol & Trainer 📊',
            desc: 'Meninjau perkembangan kemampuan vokal, tari, dan performa teater member (Disiplin +5%, Kebahagiaan -3%)',
            onTap: () => _lakukanAktivitasStaf('Evaluasi Kinerja Idol & Trainer', 3, 5),
          ),
          _buildActionCard(
            title: 'Perencanaan Konser & Show Teater 🎪',
            desc: 'Menyusun setlist, konsep lighting, sound system, serta jadwal pertunjukan panggung (Disiplin +8%, Kebahagiaan -5%)',
            onTap: () => _lakukanAktivitasStaf('Perencanaan Konser & Show Teater', 5, 8),
          ),
          _buildActionCard(
            title: 'Kampanye Promosi & Media Sosial 📣',
            desc: 'Mengkoordinasi perilisan media, jadwal interview, serta konten digital resmi (Disiplin +4%, Kebahagiaan -2%)',
            onTap: () => _lakukanAktivitasStaf('Kampanye Promosi & Media Sosial', 2, 4),
          ),
          _buildActionCard(
            title: 'Rapat Anggaran & Keuangan Agensi 💰',
            desc: 'Mengatur alokasi anggaran operasional teater, kostum, dan gaji staf (Disiplin +7%, Kebahagiaan -4%)',
            onTap: () => _lakukanAktivitasStaf('Rapat Anggaran & Keuangan Agensi', 4, 7),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.pink.shade700 : Colors.pink.shade100.withOpacity(0.5),
        ),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
