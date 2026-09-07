import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'idol_manager.dart';

import 'idol_activity/staff_manajemen/staf_manajemen.dart';
import 'idol_activity/anggota_tim_utama/tim_utama.dart';
import 'idol_activity/anggota_trainee/anggota_trainee.dart';
import 'idol_activity/aktivitas/aktivitas_panggung.dart';
import 'idol_activity/berita_idol/berita_idol.dart';

class IdolMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const IdolMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<IdolMenuScreen> createState() => _IdolMenuScreenState();
}

class _IdolMenuScreenState extends State<IdolMenuScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.character.idolTrainees.isEmpty && widget.character.idolMainMembers.isEmpty) {
      if (widget.character.jobName == 'Idol (Main Performer)') {
        IdolManager.initializeMainTeam(widget.character);
      } else {
        IdolManager.initializeTraineeTeam(widget.character);
      }
    }
  }

  void _resignOrGraduate() {
    final char = widget.character;
    final isMain = char.jobName == 'Idol (Main Performer)';
    final String title = char.isIdol
        ? (isMain ? 'Resign / Lulus (Graduation)' : 'Resign / Keluar Trainee')
        : 'Resign / Keluar Kerja';
    final String content = char.isIdol
        ? (isMain
            ? 'Apakah kamu yakin ingin melangsungkan kelulusan (graduation) dari grup Idol ini?'
            : 'Apakah kamu yakin ingin mengundurkan diri sebagai Trainee Idol?')
        : 'Apakah kamu yakin ingin berhenti bekerja di grup Idol ini?';

    showDialog(
      context: context,
      builder: (dialogContext) {
        final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          content: Text(content, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            ),
            TextButton(
              onPressed: () {
                final bool wasIdol = char.isIdol;
                final bool wasMain = isMain;
                final navigator = Navigator.of(context);
                Navigator.pop(dialogContext); // Pop confirmation dialog

                setState(() {
                  if (wasIdol && wasMain) {
                    widget.character.hasGraduatedIdol = true;
                  }
                  widget.character.resignJob();
                  widget.character.idolTrainees.clear();
                  widget.character.idolMainMembers.clear();
                  widget.character.idolStaff.clear();
                });
                widget.onRefresh();

                DialogHelper.show(
                  context: context,
                  title: wasIdol 
                      ? (wasMain ? 'Kelulusan Resmi 🎉🎓' : 'Mengundurkan Diri 📢')
                      : 'Resign Kerja 📢',
                  content: Text(
                    wasIdol
                        ? (wasMain
                            ? 'Kamu telah mengadakan konser kelulusan terakhirmu yang mengharukan. Fans melambaikan lightstick mereka dan melepas kepergianmu menuju karir baru!'
                            : 'Kamu resmi mengundurkan diri dari posisi Trainee Idol dan meninggalkan asrama.')
                        : 'Kamu resmi mengundurkan diri dari pekerjaan staf manajemen.',
                  ),
                  actions: [
                    Builder(
                      builder: (btnContext) => TextButton(
                        onPressed: () {
                          Navigator.pop(btnContext); // Pop the dialog
                          navigator.pop(); // Pop the IdolMenu screen
                        },
                        child: const Text('Mulai Langkah Baru'),
                      ),
                    ),
                  ],
                );
              },
              child: const Text('Ya, Lakukan', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final char = widget.character;
    final isMain = char.jobName == 'Idol (Main Performer)';
    final String roleTitle;
    if (char.jobName == 'Idol (Main Performer)') {
      roleTitle = 'Anggota Tim Utama';
    } else if (char.jobName == 'Idol (Trainee)') {
      roleTitle = 'Anggota Trainee';
    } else {
      roleTitle = char.jobName ?? 'Staf';
    }

    // Ganti nama Grup Idol menjadi lebih umum
    final String appBarTitle = char.isIdol 
        ? (isMain ? 'Tim Utama Idol ⭐' : 'Trainee Idol ⭐️')
        : 'Agensi Idol 🎤';

    // PERBAIKAN ERROR: Model Character tidak memiliki getter 'salary'.
    // Menggunakan properti 'money' yang sudah ada sebagai placeholder gaji bulanan.
    // Jika nanti kamu menambahkan properti 'jobSalary' atau 'salary' di Character, ganti bagian ini.
    final int currentSalary = char.money ?? 0; 

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card
            Card(
              elevation: 2,
              color: isDark ? Colors.grey.shade800 : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.pink.shade50,
                      child: Icon(Icons.music_note, size: 40, color: Colors.pink.shade700),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      char.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${char.isIdol ? 'Idol' : 'Staf'} ($roleTitle) • Usia: ${char.age} tahun',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Kesehatan',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${char.health}%',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        Column(
                          children: [
                            Text(
                              'Kedisiplinan',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${char.discipline}%',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // MENU GAJI / PENGHASILAN
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withAlpha(26),
                  child: const Icon(Icons.payments, color: Colors.green),
                ),
                title: Text(
                  'Gaji Bulanan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Pendapatan yang kamu terima setiap bulan',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
                trailing: Text(
                  '\$${currentSalary.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Aktivitas Idol',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),

            // Staf & Manajemen
            _buildMenuTile(
              context: context,
              icon: Icons.supervisor_account,
              color: Colors.blue,
              title: 'Staf & Manajemen',
              subtitle: 'Berinteraksi dengan General Manager dan tim operasional',
              page: StafManajemenPage(
                character: char,
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),

            // Anggota Tim Utama
            _buildMenuTile(
              context: context,
              icon: Icons.star,
              color: Colors.amber,
              title: 'Anggota Tim Utama',
              subtitle: 'Berinteraksi dengan anggota tim utama',
              page: TimUtamaPage(
                character: char,
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),

            // Anggota Trainee
            _buildMenuTile(
              context: context,
              icon: Icons.star_border,
              color: Colors.purple,
              title: 'Anggota Trainee',
              subtitle: 'Berinteraksi dengan sesama trainee',
              page: AnggotaTraineePage(
                character: char,
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),

            if (char.isIdol) ...[
              // Aktivitas Panggung (Sub-menu)
              _buildMenuTile(
                context: context,
                icon: Icons.audiotrack,
                color: Colors.pink,
                title: 'Aktivitas',
                subtitle: 'Latihan vokal & koreografi, teater, dan media sosial',
                page: AktivitasPanggungPage(
                  character: char,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
            ],

            // Berita Grup Idol
            _buildMenuTile(
              context: context,
              icon: Icons.newspaper,
              color: Colors.teal,
              title: 'Berita Grup Idol',
              subtitle: 'Lihat berita generasi baru dan kelulusan anggota teater',
              page: BeritaIdolPage(
                character: char,
              ),
            ),

            // Keluar / Resign
            _buildMenuTile(
              context: context,
              icon: Icons.exit_to_app,
              color: Colors.red,
              title: char.isIdol 
                  ? (isMain ? 'Keluar / Kelulusan (Graduasi)' : 'Mengundurkan Diri')
                  : 'Resign / Keluar Kerja',
              subtitle: char.isIdol 
                  ? (isMain ? 'Menyelesaikan perjalananmu sebagai Idol' : 'Keluar dari grup trainee Idol')
                  : 'Berhenti bekerja sebagai staf Idol',
              onTap: _resignOrGraduate,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(26),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
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
        onTap: () {
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          } else if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}