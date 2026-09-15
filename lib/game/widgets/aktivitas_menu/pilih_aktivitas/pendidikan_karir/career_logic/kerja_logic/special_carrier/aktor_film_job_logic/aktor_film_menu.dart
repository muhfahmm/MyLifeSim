// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/aktor_film_job_logic/aktor_film_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

import 'menu_aktor/audisi_casting_page.dart';
import 'menu_aktor/syuting_produksi_page.dart';
import 'menu_aktor/agensi_kontrak_page.dart';
import 'menu_aktor/festival_penghargaan_page.dart';
import 'menu_aktor/rekan_artis_page.dart';

class AktorFilmMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AktorFilmMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AktorFilmMenuPage> createState() => _AktorFilmMenuPageState();
}

class _AktorFilmMenuPageState extends State<AktorFilmMenuPage> {
  void _triggerRefresh() {
    if (mounted) setState(() {});
    widget.onRefresh();
  }

  void _showLockedDialog(BuildContext context, String featureName) {
    DialogHelper.show(
      context: context,
      title: 'Peran Film Belum Diterima 🔒',
      content: Text(
        'Kamu belum memiliki project peran film aktif! Ikuti menu "Audisi & Casting Film Terbuka" terlebih dahulu untuk mengakses $featureName.',
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;
    final bool hasActorRole = character.jobName != null && character.jobName!.startsWith('Aktor Film:');
    final String currentRole = hasActorRole ? character.jobName! : 'Belum Memiliki Project Film (Figuran / Audisi)';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karir Aktor Film 🎬', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Rekan Artis & Sutradara',
            onPressed: () {
              if (!hasActorRole) {
                _showLockedDialog(context, 'Rekan Artis & Sutradara');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RekanArtisPage(character: character, onRefresh: _triggerRefresh),
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
          // HEADER KARTU INFORMASI AKTOR
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
                          color: Colors.purple.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.movie_creation_rounded, size: 36, color: Colors.purple),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentRole,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: hasActorRole ? Colors.purple : Colors.orange.shade800,
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
                      _buildInfoTile('Fee Per Film', CurrencySettings.format((character.jobSalary ?? 0).toDouble()), Colors.green, isDark),
                      _buildInfoTile('Kontrak', hasActorRole ? '${character.contractYears ?? 1} Thn' : '-', Colors.blue, isDark),
                      _buildInfoTile('Popularitas', '${character.popularity}% ⭐', Colors.amber.shade800, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SEKSI MENU AKTOR FILM
          _buildSectionTitle('Manajemen & Modul Karir Aktor 🎭', isDark),

          _buildActionCard(
            title: 'Audisi & Casting Film Terbuka 🎬',
            desc: 'Pilih peran film & ikuti audisi Action, Drama, Thriller, atau Figuran',
            icon: Icons.theater_comedy,
            color: Colors.purple,
            isLocked: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AudisiCastingPage(character: character, onRefresh: _triggerRefresh),
                ),
              );
            },
            isDark: isDark,
          ),

          _buildActionCard(
            title: 'Lokasi Syuting & Produksi Film 🎥',
            desc: hasActorRole
                ? 'Pendalaman karakter method acting & aksi stunt berbahaya'
                : '🔒 Harus lolos audisi film terlebih dahulu',
            icon: Icons.video_camera_back,
            color: Colors.deepPurple,
            isLocked: !hasActorRole,
            onTap: () {
              if (!hasActorRole) {
                _showLockedDialog(context, 'Lokasi Syuting & Produksi Film');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SyutingProduksiPage(character: character, onRefresh: _triggerRefresh),
                  ),
                );
              }
            },
            isDark: isDark,
          ),

          _buildActionCard(
            title: 'Manajemen Agen & Kontrak Fee 💼',
            desc: hasActorRole
                ? 'Gabung agensi bakat ternama & naikkan nilai fee per film'
                : '🔒 Harus memiliki peran film aktif terlebih dahulu',
            icon: Icons.business_center,
            color: Colors.indigo,
            isLocked: !hasActorRole,
            onTap: () {
              if (!hasActorRole) {
                _showLockedDialog(context, 'Manajemen Agen & Kontrak');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AgensiKontrakPage(character: character, onRefresh: _triggerRefresh),
                  ),
                );
              }
            },
            isDark: isDark,
          ),

          _buildActionCard(
            title: 'Red Carpet & Festival Film 🏆',
            desc: hasActorRole
                ? 'Hadiri Gala Academy Awards Oscar, Cannes, & Piala Citra'
                : '🔒 Harus memiliki peran film aktif terlebih dahulu',
            icon: Icons.emoji_events,
            color: Colors.amber.shade900,
            isLocked: !hasActorRole,
            onTap: () {
              if (!hasActorRole) {
                _showLockedDialog(context, 'Red Carpet & Festival Film');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FestivalPenghargaanPage(character: character, onRefresh: _triggerRefresh),
                  ),
                );
              }
            },
            isDark: isDark,
          ),

          _buildActionCard(
            title: 'Co-Star, Sutradara & Kru Produksi 👥',
            desc: hasActorRole
                ? 'Interaksi & ngopi bersama rekan artis di lokasi syuting'
                : '🔒 Harus memiliki peran film aktif terlebih dahulu',
            icon: Icons.groups,
            color: Colors.teal,
            isLocked: !hasActorRole,
            onTap: () {
              if (!hasActorRole) {
                _showLockedDialog(context, 'Co-Star, Sutradara & Kru Produksi');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RekanArtisPage(character: character, onRefresh: _triggerRefresh),
                  ),
                );
              }
            },
            isDark: isDark,
          ),

          if (hasActorRole) ...[
            const SizedBox(height: 16),
            // BUTTON RESIGN / KELUAR KARIR AKTOR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Resign / Keluar Pekerjaan Aktor 🚪', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                onPressed: () => _showResignModal(context, character),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showResignModal(BuildContext context, Character character) {
    DialogHelper.show(
      context: context,
      title: 'Resign / Keluar Karir Aktor 🚪',
      content: Text(
        'Apakah kamu yakin ingin mengundurkan diri dan mengakhiri karirmu sebagai ${character.jobName}?',
        style: const TextStyle(fontSize: 13),
      ),
      showCloseButton: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.pop(context);
            character.resignJob();
            _triggerRefresh();
            Navigator.pop(context);
          },
          child: const Text('Ya, Resign', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildInfoTile(String label, String val, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
    bool isLocked = false,
  }) {
    final Color displayColor = isLocked ? Colors.grey : color;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: displayColor.withValues(alpha: 0.15),
          child: Icon(isLocked ? Icons.lock_outline_rounded : icon, color: displayColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isLocked
                ? (isDark ? Colors.white38 : Colors.grey.shade500)
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(
            fontSize: 12,
            color: isLocked
                ? (isDark ? Colors.white30 : Colors.grey.shade500)
                : (isDark ? Colors.white70 : Colors.grey.shade600),
          ),
        ),
        trailing: Icon(
          isLocked ? Icons.lock : Icons.arrow_forward_ios,
          size: 14,
          color: isLocked ? Colors.grey : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
