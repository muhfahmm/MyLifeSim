// lib/game/paused_menu/pausedMenu.dart
import 'package:flutter/material.dart';

class PausedMenu extends StatelessWidget {
  final VoidCallback? onRestart;
  final VoidCallback? onSaveProgress;
  final VoidCallback? onNewGame;

  const PausedMenu({
    super.key,
    this.onRestart,
    this.onSaveProgress,
    this.onNewGame,
  });

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.blueGrey, size: 28),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive ? Colors.red : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  icon: Icons.play_arrow_rounded,
                  title: 'Lanjutkan Game',
                  iconColor: Colors.blue,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
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
                  icon: Icons.save_rounded,
                  title: 'Simpan Progress',
                  iconColor: Colors.green,
                  onTap: () {
                    onSaveProgress?.call();
                    // Tidak langsung pop agar user bisa lihat SnackBar feedback
                  },
                ),
                _buildMenuItem(
                  icon: Icons.fiber_new_rounded,
                  title: 'Mulai Game Baru',
                  iconColor: Colors.purple,
                  onTap: () {
                    onNewGame?.call();
                    Navigator.pop(context);
                  },
                ),

                const Divider(height: 32, indent: 20, endIndent: 20),

                // SECTION 3: NAVIGASI
                _buildMenuItem(
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