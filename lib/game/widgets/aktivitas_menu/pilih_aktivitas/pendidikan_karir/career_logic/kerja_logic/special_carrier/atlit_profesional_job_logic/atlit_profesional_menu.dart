// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/atlit_profesional_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'daftar_olahraga/database_olahraga.dart';
import 'semua_tim/daftar_tim_page.dart';

class AtlitProfesionalMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitProfesionalMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AtlitProfesionalMenuPage> createState() => _AtlitProfesionalMenuPageState();
}

class _AtlitProfesionalMenuPageState extends State<AtlitProfesionalMenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openTeamPage(Map<String, dynamic> sportItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DaftarTimPage(
          character: widget.character,
          sportItem: sportItem,
          onRefresh: widget.onRefresh,
        ),
      ),
    );
  }

  void _handleBack() {
    if (widget.character.jobName != null) {
      Navigator.of(context).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;
    final bool isAthlete = character.jobName != null &&
        (character.jobName!.contains('Sepakbola') ||
            character.jobName!.contains('Basket') ||
            character.jobName!.contains('Pebalap') ||
            character.jobName!.contains('Petenis') ||
            character.jobName!.contains('MMA') ||
            character.jobName!.contains('Petinju') ||
            character.jobName!.contains('Renang'));

    final List<Map<String, dynamic>> filteredSports = OlahragaDatabase.getSportsForCharacter(character.gender).where((sport) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final name = (sport['name'] as String).toLowerCase();
      final desc = (sport['desc'] as String).toLowerCase();
      final positions = List<Map<String, dynamic>>.from(sport['positions']);
      final hasMatchingPos = positions.any((pos) => (pos['title'] as String).toLowerCase().contains(query));
      return name.contains(query) || desc.contains(query) || hasMatchingPos;
    }).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          title: const Text('Atlit Profesional ⚽'),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
      body: Column(
        children: [
          // Filter & Search Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Status Atlit Card
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Pekerjaan Saat Ini',
                                style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey),
                              ),
                              Text(
                                character.jobName ?? 'Belum Bekerja',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isAthlete ? Colors.green : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Search Field (Samakan persis dengan Pekerjaan Umum)
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari Cabang Olahraga...',
                    hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 20, color: isDark ? Colors.white70 : Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Sub-header Hasil
          if (filteredSports.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cabang Olahraga (${filteredSports.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                  if (_searchQuery.isNotEmpty)
                    Text(
                      'Filter: "$_searchQuery"',
                      style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                    ),
                ],
              ),
            ),

          // List Cabang Olahraga
          Expanded(
            child: filteredSports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white38 : Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ditemukan cabang olahraga untuk "$_searchQuery"',
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredSports.length,
                    itemBuilder: (context, index) {
                      final sport = filteredSports[index];
                      final int minAge = sport['minAge'] as int? ?? 6;
                      final bool isUnlocked = character.age >= minAge;
                      final Color sportColor = isUnlocked ? (sport['color'] as Color) : Colors.grey;

                      void handleTap() {
                        if (isUnlocked) {
                          _openTeamPage(sport);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              title: const Row(
                                children: [
                                  Icon(Icons.lock, color: Colors.orange, size: 28),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Cabor Terkunci 🔒',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Kamu harus berusia minimal $minAge tahun untuk bisa membuka dan mendaftar di cabang olahraga ${sport['name']}!\n\n'
                                '(Usiamu saat ini: ${character.age} tahun).',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                        ),
                        color: isUnlocked
                            ? (isDark ? Colors.grey.shade800 : null)
                            : (isDark ? Colors.grey.shade900.withValues(alpha: 0.5) : Colors.grey.shade100),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: sportColor.withValues(alpha: 0.1),
                            child: Icon(sport['icon'] as IconData, color: sportColor),
                          ),
                          title: Text(
                            sport['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.grey.shade600,
                            ),
                          ),
                          subtitle: Text(
                            sport['desc'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isUnlocked
                                  ? (isDark ? Colors.white70 : Colors.black54)
                                  : Colors.grey.shade500,
                            ),
                          ),
                          trailing: isUnlocked
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: handleTap,
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Lihat Tim',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                                    ],
                                  ),
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
                                        'Terkunci (Min $minAge thn)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          onTap: handleTap,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
}
