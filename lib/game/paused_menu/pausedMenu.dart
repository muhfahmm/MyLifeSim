// lib/game/paused_menu/paused_menu.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/store_page/store_page.dart';
import 'package:bitlife/main.dart'; // Untuk mengakses themeNotifier
import 'package:bitlife/pilih_karakter/settings/settings.dart';

class PausedMenu extends StatefulWidget {
  final Character? character;
  final VoidCallback? onPurchaseCompleted;
  final VoidCallback? onRestart;
  final VoidCallback? onSaveProgress;
  final VoidCallback? onNewGame;

  const PausedMenu({
    super.key,
    this.character,
    this.onPurchaseCompleted,
    this.onRestart,
    this.onSaveProgress,
    this.onNewGame,
  });

  @override
  State<PausedMenu> createState() => _PausedMenuState();
}

class _PausedMenuState extends State<PausedMenu> {
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: iconColor ?? (isDark ? Colors.blueGrey.shade300 : Colors.blueGrey), size: 28),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive ? Colors.red : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isFemale = widget.character?.gender.trim().toLowerCase() == 'perempuan';
    final sameSexTitle = isFemale ? 'Nonaktifkan Ajakan Lesbian' : 'Nonaktifkan Ajakan Gay';
    final bool isSameSexDisabled = widget.character?.disableSameSexProposals ?? false;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Game Paused'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- HEADER ELEGAN ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 24, bottom: 24, left: 24, right: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5C3C10), Color(0xFF8A5A32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.pause_circle_filled, color: Colors.white, size: 48),
                SizedBox(height: 12),
                Text(
                  'BitLife',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Game Paused',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // --- LIST MENU PAUSED ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                // SECTION 1: KONTROL GAME
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 8),
                  child: Text(
                    'KONTROL GAME',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.play_arrow_rounded,
                  title: 'Lanjutkan Game',
                  iconColor: Colors.blue,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.refresh_rounded,
                  title: 'Restart (Reset Semua)',
                  iconColor: Colors.orange,
                  onTap: () {
                    widget.onRestart?.call();
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings_rounded,
                  title: 'Settingan',
                  iconColor: Colors.blueGrey,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),

                if (widget.character != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    child: Card(
                      elevation: 0,
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: SwitchListTile(
                        secondary: const Icon(Icons.block_rounded, color: Colors.purpleAccent, size: 28),
                        title: Text(
                          sameSexTitle,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          isSameSexDisabled ? 'Ajakan Dinonaktifkan' : 'Ajakan Aktif',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSameSexDisabled ? Colors.redAccent : Colors.grey,
                          ),
                        ),
                        value: isSameSexDisabled,
                        onChanged: (val) {
                          setState(() {
                            widget.character!.disableSameSexProposals = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],

                const Divider(height: 32, indent: 20, endIndent: 20),

                // SECTION 2: MANAJEMEN DATA
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 8),
                  child: Text(
                    'MANAJEMEN DATA',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.save_rounded,
                  title: 'Simpan Progress',
                  iconColor: Colors.green,
                  onTap: () {
                    widget.onSaveProgress?.call();
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.fiber_new_rounded,
                  title: 'Mulai Game Baru',
                  iconColor: Colors.purple,
                  onTap: () {
                    widget.onNewGame?.call();
                    Navigator.pop(context);
                  },
                ),

                const Divider(height: 32, indent: 20, endIndent: 20),

                // SECTION 3: TOKO
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 8),
                  child: Text(
                    'TOKO',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.storefront_rounded,
                  title: 'Toko',
                  iconColor: Colors.amber.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StorePage(
                          character: widget.character,
                          onPurchaseCompleted: widget.onPurchaseCompleted,
                        ),
                      ),
                    );
                  },
                ),

                // --- TAMBAHAN: DARK MODE DENGAN TOGGLE SWITCH ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Card(
                    elevation: 0,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ValueListenableBuilder<ThemeMode>(
                      valueListenable: themeNotifier,
                      builder: (context, mode, _) {
                        final bool isDarkMode = mode == ThemeMode.dark;
                        return SwitchListTile(
                          secondary: Icon(
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: isDarkMode ? Colors.yellow.shade700 : Colors.blue,
                            size: 28,
                          ),
                          title: Text(
                            'Mode Gelap',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            isDarkMode ? 'Mode gelap aktif' : 'Mode terang aktif',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.grey,
                            ),
                          ),
                          value: isDarkMode,
                          onChanged: (val) {
                            themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                          },
                        );
                      },
                    ),
                  ),
                ),

                const Divider(height: 32, indent: 20, endIndent: 20),

                // SECTION 4: NAVIGASI
                _buildMenuItem(
                  context,
                  icon: Icons.home_rounded,
                  title: 'Kembali ke Menu Utama',
                  iconColor: Colors.red,
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context); // Tutup Paused Menu
                    Navigator.pop(context); // Kembali ke Home Page
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}