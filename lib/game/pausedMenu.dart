// lib/game/pausedMenu.dart
import 'package:flutter/material.dart';

class PausedMenu extends StatelessWidget {
  final VoidCallback? onRestart;

  const PausedMenu({super.key, this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pause_circle, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'Game Paused',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('Lanjutkan Game'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Restart (Reset Semua)'),
            onTap: () {
              onRestart?.call(); // Jalankan reset karakter
              Navigator.pop(context); // Tutup menu
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Kembali ke Menu Utama'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}