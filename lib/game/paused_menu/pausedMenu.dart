import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/store_page/store_page.dart';
import 'package:bitlife/game/paused_menu/darkmode.dart';

class PausedMenu extends StatelessWidget {
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
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // --- HEADER ELEGAN ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 48, bottom: 24, left: 24, right: 24),
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
                Text(
                  'Game Paused',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- LIST MENU ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
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
                    onRestart?.call();
                    Navigator.pop(context);
                  },
                ),

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
                    onSaveProgress?.call();
                    // Tidak langsung pop agar user bisa lihat SnackBar feedback
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.fiber_new_rounded,
                  title: 'Mulai Game Baru',
                  iconColor: Colors.purple,
                  onTap: () {
                    onNewGame?.call();
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
                          character: character,
                          onPurchaseCompleted: onPurchaseCompleted,
                        ),
                      ),
                    );
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DarkModeButton(),
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
                    Navigator.pop(context); // Tutup Drawer
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