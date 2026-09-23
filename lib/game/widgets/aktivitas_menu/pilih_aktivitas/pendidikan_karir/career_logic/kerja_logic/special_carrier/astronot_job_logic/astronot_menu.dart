// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/astronot_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

import 'menu_astronot/pendaftaran_astronot_page.dart';
import 'menu_astronot/pelatihan_astronot_page.dart';
import 'menu_astronot/misi_luar_angkasa_page.dart';
import 'menu_astronot/stasiun_ruang_angkasa_page.dart';
import 'menu_astronot/rekan_astronot_page.dart';

class AstronotMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AstronotMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AstronotMenuPage> createState() => _AstronotMenuPageState();
}

class _AstronotMenuPageState extends State<AstronotMenuPage> {
  void _triggerRefresh() {
    if (mounted) setState(() {});
    widget.onRefresh();
  }

  void _showLockedDialog(BuildContext context, String featureName) {
    DialogHelper.show(
      context: context,
      title: 'Status Astronot Belum Aktif',
      content: Text(
        'Kamu belum terdaftar di lembaga antariksa mana pun! Ikuti menu "Rekrutmen & Seleksi Astronot Baru" terlebih dahulu untuk membuka $featureName.',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  void _showResignDialog() {
    DialogHelper.show(
      context: context,
      title: 'Pengunduran Diri Astronot 👨‍🚀❌',
      content: Text(
        'Apakah kamu yakin ingin mengundurkan diri dan mengakhiri kontrak kerjamu di ${widget.character.jobName}?',
        style: const TextStyle(fontSize: 12),
      ),
      showCloseButton: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            setState(() {
              widget.character.resignJob();
              widget.character.contractYears = null;
            });
            _triggerRefresh();

            DialogHelper.show(
              context: context,
              title: 'Resign Berhasil 📜',
              content: const Text('Kamu telah mengundurkan diri secara resmi dari lembaga antariksa.'),
            );
          },
          child: const Text('Ya, Mengundurkan Diri', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;
    final bool hasAstronotJob = character.jobName != null && character.jobName!.startsWith('Astronot:');
    final String currentRank = hasAstronotJob ? character.jobName! : 'Belum Terdaftar (Calon Kosmonot / Trainee)';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karir Astronot & Antariksa 🚀', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFF311B92)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Rekan Kosmonot & Kru',
            onPressed: () {
              if (!hasAstronotJob) {
                _showLockedDialog(context, 'Rekan Kosmonot & Kru');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RekanAstronotPage(character: character, onRefresh: _triggerRefresh),
                  ),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // HEADER KARTU INFORMASI ASTRONOT
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.rocket_launch, size: 36, color: Colors.indigo),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentRank,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: hasAstronotJob ? Colors.indigo : Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTile('Gaji Tahunan', CurrencySettings.format((character.jobSalary ?? 0).toDouble()), Colors.green, isDark),
                      _buildInfoTile('Popularitas', '${character.popularity}% ⭐', Colors.amber.shade800, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SEKSI DOKUMEN & AUDISI
          _buildSectionTitle('Rekrutmen & Misi Antariksa 👨‍🚀', isDark),

          if (!hasAstronotJob)
            _buildMenuCard(
              title: 'Rekrutmen & Seleksi Astronot Baru 🛰️',
              subtitle: 'Daftar rekrutmen astronot NASA, ESA, JAXA & BRIN Antariksa',
              icon: Icons.assignment_ind_rounded,
              color: Colors.indigo,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PendaftaranAstronotPage(
                      character: character,
                      onRefresh: _triggerRefresh,
                    ),
                  ),
                );
              },
            ),

          _buildMenuCard(
            title: 'Pusat Pelatihan Kosmonot & G-Force 🌀',
            subtitle: 'Simulasi Zero-G, mesin sentrifugal 9G, & latihan EVA air',
            icon: Icons.fitness_center_rounded,
            color: hasAstronotJob ? Colors.deepPurple : Colors.grey,
            isLocked: !hasAstronotJob,
            isDark: isDark,
            onTap: () {
              if (!hasAstronotJob) {
                _showLockedDialog(context, 'Pusat Pelatihan Kosmonot');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PelatihanAstronotPage(
                      character: character,
                      onRefresh: _triggerRefresh,
                    ),
                  ),
                );
              }
            },
          ),

          _buildMenuCard(
            title: 'Peluncuran Misi Luar Angkasa 🌌',
            subtitle: 'Spacewalk, Misi ISS, Ekspedisi Bulan Artemis, & Koloni Mars',
            icon: Icons.public_rounded,
            color: hasAstronotJob ? Colors.blue.shade800 : Colors.grey,
            isLocked: !hasAstronotJob,
            isDark: isDark,
            onTap: () {
              if (!hasAstronotJob) {
                _showLockedDialog(context, 'Misi Luar Angkasa');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MisiLuarAngkasaPage(
                      character: character,
                      onRefresh: _triggerRefresh,
                    ),
                  ),
                );
              }
            },
          ),

          _buildMenuCard(
            title: 'Laboratorium Stasiun Antariksa (ISS) 🛰️',
            subtitle: 'Riset tanaman mikro-gravitasi, biomedis & siaran live Bumi',
            icon: Icons.space_dashboard_rounded,
            color: hasAstronotJob ? Colors.teal.shade800 : Colors.grey,
            isLocked: !hasAstronotJob,
            isDark: isDark,
            onTap: () {
              if (!hasAstronotJob) {
                _showLockedDialog(context, 'Laboratorium Stasiun Antariksa');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StasiunRuangAngkasaPage(
                      character: character,
                      onRefresh: _triggerRefresh,
                    ),
                  ),
                );
              }
            },
          ),

          _buildMenuCard(
            title: 'Rekan Kosmonot & Kru Stasiun 👨‍🚀',
            subtitle: 'Interaksi, diskusi strategi misi, & ngopi di modul stasiun',
            icon: Icons.groups_rounded,
            color: hasAstronotJob ? Colors.cyan.shade800 : Colors.grey,
            isLocked: !hasAstronotJob,
            isDark: isDark,
            onTap: () {
              if (!hasAstronotJob) {
                _showLockedDialog(context, 'Rekan Kosmonot & Kru Stasiun');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RekanAstronotPage(
                      character: character,
                      onRefresh: _triggerRefresh,
                    ),
                  ),
                );
              }
            },
          ),

          if (hasAstronotJob)
            _buildMenuCard(
              title: 'Resign / Keluar Kerja',
              subtitle: 'Berhenti bekerja sebagai Astronot',
              icon: Icons.exit_to_app,
              color: Colors.red,
              isDark: isDark,
              onTap: _showResignDialog,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: isLocked ? Colors.grey : color.withValues(alpha: 0.15),
          child: Icon(isLocked ? Icons.lock : icon, color: isLocked ? Colors.white : color, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isLocked ? (isDark ? Colors.white54 : Colors.grey) : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
            if (isLocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('TERKUNCI', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}
