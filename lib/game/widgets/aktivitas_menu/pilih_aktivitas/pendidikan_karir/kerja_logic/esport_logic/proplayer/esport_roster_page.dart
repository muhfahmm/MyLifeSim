// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/esport_roster_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/interactions/classmate_interaction_page.dart';
import 'esport_roster.dart';

class EsportRosterPage extends StatefulWidget {
  final String teamName;
  final bool isViewingBA;
  final Character character;
  final VoidCallback onRefresh;

  const EsportRosterPage({
    super.key,
    required this.teamName,
    required this.isViewingBA,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<EsportRosterPage> createState() => _EsportRosterPageState();
}

class _EsportRosterPageState extends State<EsportRosterPage> {
  // Cache untuk menyimpan data person agar interaksi & relasi persisten selama halaman dibuka
  final Map<String, Map<String, String>> _personCache = {};

  Map<String, String> _getPersonMap(String name, bool isBA) {
    if (_personCache.containsKey(name)) {
      return _personCache[name]!;
    }

    final random = Random(name.hashCode);
    final String gender = isBA ? 'Perempuan' : (random.nextDouble() < 0.75 ? 'Laki-laki' : 'Perempuan');
    int age = 18 + random.nextInt(20);
    if (isBA) {
      age = 15 + random.nextInt(9); // 15-23
    } else {
      age = 13 + random.nextInt(13); // 13-25 (Pro Player)
    }
    final int relationship = 30 + random.nextInt(41); // Hubungan awal 30 - 70%
    final int intelligence = 40 + random.nextInt(51); // 40 - 90%

    final Map<String, String> person = {
      'name': name,
      'gender': gender,
      'age': '$age',
      'relationship': '$relationship',
      'intelligence': '$intelligence',
      'role': isBA ? 'Brand Ambassador' : 'Rekan Kerja',
      'sexuality': 'Heteroseksual',
      'isDeceased': 'false',
    };

    _personCache[name] = person;
    return person;
  }

  String _getAvatarUrl(String name, String genderStr) {
    final gender = genderStr == 'Perempuan' ? 'female' : 'male';
    final random = Random(name.hashCode);
    final avatarData = AvatarGenerator.generateRandomAvatar(gender);

    return AvatarGenerator.buildCustomAvatarUrl(
      topType: avatarData['topType']!,
      accessoriesType: avatarData['accessoriesType']!,
      hairColor: avatarData['hairColor']!,
      clotheType: avatarData['clotheType']!,
      clotheColor: avatarData['clotheColor']!,
      skinColor: avatarData['skinColor']!,
      eyeType: 'default',
      eyebrowType: 'default',
      mouthType: 'default',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.isViewingBA ? 'Brand Ambassador - ${widget.teamName}' : 'Divisi & Roster - ${widget.teamName}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: widget.isViewingBA ? _buildBAView(context, isDark) : _buildDivisionsView(context, isDark),
    );
  }

  // Layout untuk Brand Ambassador (Meniru gaya "Tim Kerja")
  Widget _buildBAView(BuildContext context, bool isDark) {
    final List<String> bas = EsportRoster.generateBAs(widget.teamName);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          context: context,
          icon: Icons.group,
          title: 'Brand Ambassador',
          titleColor: Colors.green.shade700,
          badgeText: 'Dikontrol oleh Manajemen',
          badgeColor: Colors.green,
        ),
        const SizedBox(height: 8),
        ...bas.map((baName) {
          final personMap = _getPersonMap(baName, true);
          return _buildPersonCard(
            context: context,
            isDark: isDark,
            name: baName,
            role: 'Brand Ambassador • Umur: ${personMap['age']} tahun • Hubungan: ${personMap['relationship']}% • Kecerdasan: ${personMap['intelligence']}%',
            badgeText: null,
            showArrow: true,
            onTap: () => _navigateToInteraction(personMap),
          );
        }),
      ],
    );
  }

  // Layout untuk Pro Player (Meniru gaya "Atasan / Supervisor" + "Tim Kerja")
  Widget _buildDivisionsView(BuildContext context, bool isDark) {
    final Map<String, List<String>> divisions = EsportRoster.generateProPlayers(widget.teamName);
    
    // Ambil pemain pertama sebagai "Atasan / Supervisor" (Mockup Kapten Tim)
    final String supervisorName = divisions.values.isNotEmpty && divisions.values.first.isNotEmpty 
        ? divisions.values.first.first 
        : 'Kapten Tim';

    final supervisorMap = _getPersonMap(supervisorName, false);
    supervisorMap['role'] = 'Atasan';

    final List<Widget> divisionWidgets = [];
    divisions.forEach((divName, players) {
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

      // Filter out the supervisor from the division roster list if they are in it,
      // so they are not shown twice (both at top as supervisor and inside division list).
      final List<String> filteredPlayers = players.where((p) => p != supervisorName).toList();

      divisionWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                context: context,
                icon: gameIcon,
                title: divName,
                titleColor: accentColor,
                badgeText: 'Pro Player 🎮',
                badgeColor: accentColor,
              ),
              const SizedBox(height: 8),
              ...filteredPlayers.map((playerName) {
                final personMap = _getPersonMap(playerName, false);
                return _buildPersonCard(
                  context: context,
                  isDark: isDark,
                  name: playerName,
                  role: 'Rekan Kerja • Umur: ${personMap['age']} tahun • Hubungan: ${personMap['relationship']}% • Kecerdasan: ${personMap['intelligence']}%',
                  badgeText: null,
                  showArrow: true,
                  onTap: () => _navigateToInteraction(personMap),
                );
              }),
            ],
          ),
        ),
      );
    });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bagian 1: Atasan
        _buildSectionHeader(
          context: context,
          icon: Icons.supervisor_account,
          title: 'Atasan / Supervisor',
          titleColor: Colors.blue,
          badgeText: 'Supervisor',
          badgeColor: Colors.blue,
        ),
        const SizedBox(height: 8),
        _buildPersonCard(
          context: context,
          isDark: isDark,
          name: supervisorName,
          role: 'Atasan • Umur: ${supervisorMap['age']} tahun • Hubungan: ${supervisorMap['relationship']}% • Kecerdasan: ${supervisorMap['intelligence']}%',
          badgeText: 'Supervisor',
          showArrow: true,
          onTap: () => _navigateToInteraction(supervisorMap),
        ),
        ...divisionWidgets,
      ],
    );
  }

  void _navigateToInteraction(Map<String, String> personMap) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassmateInteractionPage(
          classmate: personMap,
          character: widget.character,
          onRefresh: () {
            if (mounted) setState(() {});
            widget.onRefresh();
          },
        ),
      ),
    );
  }

  // Widget Header Section (Identik dengan Rekan Kerja)
  Widget _buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color titleColor,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, color: titleColor, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: badgeColor.withOpacity(0.3)),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Person (Identik dengan Rekan Kerja)
  Widget _buildPersonCard({
    required BuildContext context,
    required bool isDark,
    required String name,
    required String role,
    String? badgeText,
    required bool showArrow,
    required VoidCallback onTap,
  }) {
    final gender = _getPersonMap(name, badgeText != 'Supervisor')['gender']!;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    _getAvatarUrl(name, gender),
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.person, color: Colors.grey, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Bagian Tengah (Nama + Info)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: badgeText == 'Supervisor' 
                                  ? Colors.blue 
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeText == 'Supervisor' 
                                  ? Colors.blue.withOpacity(0.1) 
                                  : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: badgeText == 'Supervisor' 
                                    ? Colors.blue.withOpacity(0.3) 
                                    : Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: badgeText == 'Supervisor' 
                                    ? Colors.blue 
                                    : Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              // Panah di Kanan (Jika ada)
              if (showArrow)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}