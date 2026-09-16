import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';

class RekamJejakGenerasiPage extends StatefulWidget {
  final Character character;

  const RekamJejakGenerasiPage({
    super.key,
    required this.character,
  });

  @override
  State<RekamJejakGenerasiPage> createState() => _RekamJejakGenerasiPageState();
}

class _RekamJejakGenerasiPageState extends State<RekamJejakGenerasiPage> {
  String _searchQuery = '';

  Widget _buildGenBadge(String genStr) {
    final String text = 'Gen $genStr';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.purple.shade300, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.purple.shade800,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getMemberGen(Map<String, String> m) {
    final genStr = m['generation'];
    if (genStr != null && int.tryParse(genStr) != null) {
      return genStr;
    }
    final age = int.tryParse(m['age'] ?? '16') ?? 16;
    if (age >= 26) return '1';
    if (age >= 23) return '2';
    if (age >= 20) return '3';
    if (age >= 17) return '4';
    return '5';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Collect all generation numbers from active members and graduated members
    final Set<int> genSet = {};

    // Active members
    for (var m in widget.character.idolMainMembers) {
      final genStr = _getMemberGen(m);
      if (int.tryParse(genStr) != null) {
        genSet.add(int.parse(genStr));
      }
    }

    // Graduated members
    for (var m in widget.character.idolGraduatedMembers) {
      final genStr = _getMemberGen(m);
      if (int.tryParse(genStr) != null) {
        genSet.add(int.parse(genStr));
      }
    }

    // Include standard Gen 1-5 even if empty
    for (int g = 1; g <= 5; g++) {
      genSet.add(g);
    }

    final sortedGens = genSet.toList()..sort();

    return Column(
      children: [
        // Search filter if needed
        Container(
          padding: const EdgeInsets.all(12),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Cari generasi atau nama member...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              filled: true,
              fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedGens.length,
            itemBuilder: (context, index) {
              final genNum = sortedGens[index];
              final genStr = genNum.toString();

              // Filter active members for this gen
              final activeMembers = widget.character.idolMainMembers.where((m) {
                return _getMemberGen(m) == genStr;
              }).toList();

              // Filter graduated members for this gen
              final graduatedMembers = widget.character.idolGraduatedMembers.where((m) {
                return _getMemberGen(m) == genStr;
              }).toList();

              // Apply search query if typed
              final filteredActive = activeMembers.where((m) {
                if (_searchQuery.isEmpty) return true;
                if ('gen $genStr'.contains(_searchQuery) || 'generasi $genStr'.contains(_searchQuery)) return true;
                final name = (m['name'] ?? '').toLowerCase();
                return name.contains(_searchQuery);
              }).toList();

              final filteredGraduated = graduatedMembers.where((m) {
                if (_searchQuery.isEmpty) return true;
                if ('gen $genStr'.contains(_searchQuery) || 'generasi $genStr'.contains(_searchQuery)) return true;
                final name = (m['name'] ?? '').toLowerCase();
                return name.contains(_searchQuery);
              }).toList();

              if (_searchQuery.isNotEmpty && filteredActive.isEmpty && filteredGraduated.isEmpty) {
                return const SizedBox.shrink();
              }

              final int totalOriginal = activeMembers.length + graduatedMembers.length;
              final int activeCount = activeMembers.length;
              final int gradCount = graduatedMembers.length;

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isDark ? Colors.grey.shade700 : Colors.purple.shade100,
                    width: 1,
                  ),
                ),
                color: isDark ? Colors.grey.shade800 : Colors.purple.shade50.withAlpha(50),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: _buildGenBadge(genStr),
                    title: Text(
                      'Generasi $genStr',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.purple.shade900,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green.shade300, width: 0.5),
                            ),
                            child: Text(
                              'Aktif: $activeCount',
                              style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade400, width: 0.5),
                            ),
                            child: Text(
                              'Lulus: $gradCount',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '• Total $totalOriginal member',
                            style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(height: 1),
                      if (activeMembers.isEmpty && graduatedMembers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Belum ada rekam jejak untuk Generasi $genStr.',
                            style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                          ),
                        )
                      else ...[
                        // Active members section
                        if (filteredActive.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                            child: Row(
                              children: [
                                const Icon(Icons.circle, size: 8, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                  'Anggota Aktif (${filteredActive.length})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...filteredActive.map((member) => _buildMemberTile(context, member, isGraduated: false)),
                        ],

                        // Graduated members section
                        if (filteredGraduated.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                            child: Row(
                              children: [
                                const Icon(Icons.school, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  'Alumni / Lulus (Graduate) (${filteredGraduated.length})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...filteredGraduated.map((member) => _buildMemberTile(context, member, isGraduated: true)),
                        ],
                      ],
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemberTile(BuildContext context, Map<String, String> member, {required bool isGraduated}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String name = member['name'] ?? '';
    final String gender = member['gender'] ?? 'Perempuan';
    final int age = int.tryParse(member['age'] ?? '18') ?? 18;
    final int rel = int.tryParse(member['relationship'] ?? '50') ?? 50;
    final String gradAgeStr = member['graduatedAge'] ?? member['age'] ?? age.toString();

    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: rel,
      forcedSkinColor: member['skinColor'],
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: ListTile(
        dense: true,
        leading: ColorFiltered(
          colorFilter: isGraduated
              ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
              : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
          child: AvatarImageCache.buildAvatar(
            url: avatarUrl,
            width: 36,
            height: 36,
            gender: gender,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isGraduated
                ? (isDark ? Colors.white60 : Colors.grey.shade700)
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          isGraduated
              ? 'Lulus pada usia $gradAgeStr th 🎓'
              : 'Usia: $age th • Hubungan: $rel%',
          style: TextStyle(
            fontSize: 11,
            color: isGraduated
                ? Colors.purple.shade400
                : (isDark ? Colors.white54 : Colors.grey.shade600),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isGraduated ? Colors.grey.shade200 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isGraduated ? 'Graduated 🎓' : 'Aktif ⭐',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isGraduated ? Colors.grey.shade700 : Colors.green.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
