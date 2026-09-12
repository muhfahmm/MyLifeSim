// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pekerjaan_spesial_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/store_page/store_page.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'military_job_logic/army_menu.dart';
import 'politikus_job_logic/politik_menu.dart';
import 'pembisnis_job_logic/pembisnis_menu.dart';
import 'atlit_profesional_job_logic/atlit_profesional_menu.dart';
import 'aktor_film_job_logic/aktor_film_menu.dart';
import 'astronot_job_logic/astronot_menu.dart';
import 'models_job_logic/models_menu.dart';
import 'idol_logic/idol_menu.dart';
import 'idol_logic/syarat_ketentuan_idol_modal.dart';
import 'esport_logic/esport_activities_page.dart';
import 'esport_logic/syarat_ketentuan_esport_modal.dart';

class PekerjaanSpesialMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PekerjaanSpesialMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PekerjaanSpesialMenuScreen> createState() => _PekerjaanSpesialMenuScreenState();
}

class _PekerjaanSpesialMenuScreenState extends State<PekerjaanSpesialMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karir Spesial 🌟', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Pilih Jalur Karir Spesial:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuTile(
              context: context,
              icon: Icons.military_tech,
              color: Colors.green.shade800,
              title: 'Militer',
              subtitle: 'Bergabung dengan karir militer pertahanan negara',
              minAge: 18,
              page: ArmyMenuPage(
                character: character,
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isPolitikusUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.account_balance,
                  color: Colors.amber.shade800,
                  title: 'Karier Politik 🏛️',
                  subtitle: 'Jalur kekuasaan: Dewan, Walikota, Gubernur hingga Presiden',
                  minAge: 18,
                  isPurchased: isUnlocked,
                  onTap: () {
                    PolitikMenuHelper.showPolitikMenu(
                      context,
                      character,
                      () {
                        if (mounted) setState(() {});
                        widget.onRefresh();
                      },
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isPebisnisUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.business_center,
                  color: Colors.blue.shade800,
                  title: 'Pembisnis 💼',
                  subtitle: 'Mulai startup, kelola bisnis, dan bangun kekayaan impian',
                  minAge: 18,
                  isPurchased: isUnlocked,
                  page: PembisnisMenuPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isAtlitUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.sports_soccer,
                  color: Colors.deepOrange.shade800,
                  title: 'Atlit Profesional ⚽',
                  subtitle: 'Karir olahraga profesional & ikuti turnamen kelas dunia',
                  minAge: 6,
                  isPurchased: isUnlocked,
                  page: AtlitProfesionalMenuPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isAktorFilmUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.movie_creation,
                  color: Colors.purple.shade800,
                  title: 'Aktor Film 🎬',
                  subtitle: 'Bintang layar lebar, audisi perfilman, dan selebriti Hollywood',
                  minAge: 18,
                  isPurchased: isUnlocked,
                  page: AktorFilmMenuPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isAstronotUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.rocket_launch,
                  color: Colors.indigo.shade800,
                  title: 'Astronot 🚀',
                  subtitle: 'Misi antariksa, latihan kosmonot, dan penjelajahan tata surya',
                  minAge: 18,
                  isPurchased: isUnlocked,
                  page: AstronotMenuPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isModelUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.style,
                  color: Colors.pink.shade800,
                  title: 'Model 💃',
                  subtitle: 'Catwalk fashion show, majalah ternama, dan brand ambassador',
                  minAge: 18,
                  isPurchased: isUnlocked,
                  page: ModelsMenuPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isIdolUnlocked,
              builder: (context, isUnlocked, _) {
                return _buildMenuTile(
                  context: context,
                  icon: Icons.mic,
                  color: Colors.pinkAccent.shade400,
                  title: 'Idol 🎤',
                  subtitle: 'Latihan vokal & dance, konser panggung, dan agensi entertainment',
                  minAge: 10,
                  isPurchased: isUnlocked,
                  onTap: () async {
                    if (character.isIdol || character.isIdolStaff) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IdolMenuScreen(
                            character: character,
                            onRefresh: () {
                              if (mounted) setState(() {});
                              widget.onRefresh();
                            },
                          ),
                        ),
                      );
                      if (mounted) setState(() {});
                    } else {
                      SyaratKetentuanIdolModal.show(
                        context: context,
                        character: character,
                        onRefresh: () {
                          if (mounted) setState(() {});
                          widget.onRefresh();
                        },
                      );
                    }
                  },
                );
              },
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.sports_esports,
              color: Colors.teal.shade700,
              title: 'E-Sports 🎮',
              subtitle: 'Pro Player, Talent, dan Brand Ambassador tim esports terkenal',
              minAge: 12,
              onTap: () async {
                final String j = character.jobName ?? '';
                if (j.contains('Esport') || j.contains('E-Sport')) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EsportActivitiesPage(
                        character: character,
                        onRefresh: () {
                          if (mounted) setState(() {});
                          widget.onRefresh();
                        },
                      ),
                    ),
                  );
                  if (mounted) setState(() {});
                } else {
                  SyaratKetentuanEsportModal.show(
                    context: context,
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  );
                }
              },
            ),
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
    int minAge = 18,
    bool isPurchased = true,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int currentAge = widget.character.age;
    final bool isAgeUnlocked = currentAge >= minAge;
    final bool isUnlocked = isAgeUnlocked && isPurchased;
    final Color effectiveColor = isUnlocked ? color : Colors.grey;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isUnlocked
          ? (isDark ? Colors.grey.shade800 : Colors.white)
          : (isDark ? Colors.grey.shade900.withValues(alpha: 0.5) : Colors.grey.shade100),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: effectiveColor, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? (isDark ? Colors.white : Colors.black87) : Colors.grey.shade600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isUnlocked ? (isDark ? Colors.white60 : Colors.grey.shade600) : Colors.grey.shade500,
            ),
          ),
        ),
        trailing: isUnlocked
            ? Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark ? Colors.white54 : Colors.grey,
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Terkunci',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
        onTap: () {
          if (!isAgeUnlocked) {
            DialogHelper.show(
              context: context,
              title: 'Akses Dibatasi',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🔒', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kamu harus berusia minimal $minAge tahun untuk membuka jalur karir ini.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFB74D)),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          'Usia saat ini: $currentAge tahun',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
            return;
          }

          if (!isPurchased) {
            DialogHelper.show(
              context: context,
              title: 'Fitur Terkunci 🔒',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jalur $title ini memerlukan akses fitur Karir Spesial. Silakan beli terlebih dahulu di Toko MyLifeSim.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A5A32),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StorePage(
                            character: widget.character,
                            onPurchaseCompleted: () {
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      ).then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                    icon: const Icon(Icons.shopping_bag_rounded, size: 18),
                    label: const Text('Buka di Toko MyLifeSim', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ],
            );
            return;
          }

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

