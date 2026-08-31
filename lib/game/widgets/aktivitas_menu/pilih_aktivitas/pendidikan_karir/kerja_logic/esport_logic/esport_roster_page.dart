// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/esport_roster_page.dart
import 'package:flutter/material.dart';
import 'esport_roster.dart';

class EsportRosterPage extends StatelessWidget {
  final String teamName;
  final bool isViewingBA; // true if viewing BAs, false if viewing Pro Player divisions

  const EsportRosterPage({
    super.key,
    required this.teamName,
    required this.isViewingBA,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // PERBAIKAN DI SINI: Ganti shade950 menjadi shade900
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50, 
      appBar: AppBar(
        title: Text(
          isViewingBA ? 'Brand Ambassador - $teamName' : 'Divisi & Roster - $teamName',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: isViewingBA ? _buildBAView(context, isDark) : _buildDivisionsView(context, isDark),
    );
  }

  Widget _buildBAView(BuildContext context, bool isDark) {
    final List<String> bas = EsportRoster.generateBAs(teamName);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bas.length,
      itemBuilder: (context, index) {
        final baName = bas[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink.shade50,
              child: const Icon(Icons.star, color: Colors.pinkAccent),
            ),
            title: Text(
              baName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: const Text(
              'Brand Ambassador Resmi',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'BA 🌟',
                style: TextStyle(color: Colors.pinkAccent, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivisionsView(BuildContext context, bool isDark) {
    final Map<String, List<String>> divisions = EsportRoster.generateProPlayers(teamName);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: divisions.entries.map((entry) {
        final divName = entry.key;
        final players = entry.value;

        IconData gameIcon = Icons.sports_esports;
        Color accentColor = Colors.blue;
        if (divName.contains('Legends')) {
          gameIcon = Icons.security;
          accentColor = Colors.orange;
        } else if (divName.contains('PUBG')) {
          gameIcon = Icons.gps_fixed;
          accentColor = Colors.green;
        } else if (divName.contains('Free Fire')) {
          gameIcon = Icons.local_fire_department;
          accentColor = Colors.red;
        } else if (divName.contains('Valorant')) {
          gameIcon = Icons.flash_on;
          accentColor = Colors.indigo;
        }

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Division Header
                Row(
                  children: [
                    Icon(gameIcon, color: accentColor, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        divName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                // Player List
                ...players.map((player) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: accentColor.withValues(alpha: 0.1),
                          child: Icon(Icons.person, color: accentColor, size: 14),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            player,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          'Pro Player 🎮',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}