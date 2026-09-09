// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/semua_tim/daftar_tim_page.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import '../daftar_tim/database_tim_olahraga.dart';
import '../karir_pages/aktivitas_karir_atlet/sepakbola/sepakbola_logic/logika_pemain_sepakbola.dart';

class DaftarTimPage extends StatefulWidget {
  final Character character;
  final Map<String, dynamic> sportItem;
  final VoidCallback onRefresh;

  const DaftarTimPage({
    super.key,
    required this.character,
    required this.sportItem,
    required this.onRefresh,
  });

  @override
  State<DaftarTimPage> createState() => _DaftarTimPageState();
}

class _DaftarTimPageState extends State<DaftarTimPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedLeague;
  double _salaryMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _salaryMultiplier = getCountrySalaryMultiplier(widget.character.location);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyJob(Map<String, dynamic> positionItem, Map<String, String> teamItem, int contractYears) {
    final character = widget.character;
    final int minHealth = positionItem['minHealth'] ?? 0;
    final int minDiscipline = positionItem['minDiscipline'] ?? 0;
    final int minIntel = positionItem['minIntel'] ?? 0;

    if (character.health < minHealth || character.discipline < minDiscipline || character.intelligence < minIntel) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lamaran Ditolak 🚫'),
          content: Text(
            'Persyaratan menjadi ${positionItem['title']} tidak terpenuhi.\n\n'
            '• Kesehatan minimal: $minHealth% (Kesehatanmu: ${character.health}%)\n'
            '• Kedisiplinan minimal: $minDiscipline% (Kedisiplinanmu: ${character.discipline}%)\n'
            '• Kecerdasan minimal: $minIntel% (Kecerdasanmu: ${character.intelligence}%)',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Persentase peluang diterima berdasarkan Usia dan Durasi Kontrak
    final int age = character.age;
    final int successChance = LogikaPemainSepakbola.hitungPeluangDiterimaKontrak(
      usia: age,
      durasiKontrakTahun: contractYears,
    );

    final int roll = Random().nextInt(100);
    final bool isAccepted = roll < successChance;

    if (!isAccepted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Penawaran Ditolak 🚫', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Manajemen ${teamItem['name']} menolak pengajuan kontrak selama $contractYears tahun untuk posisimu (Peluang diterima: $successChance%).\n\nCoba ajukan durasi kontrak yang lebih pendek atau coba lagi!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
      return;
    }

    final int baseSalary = positionItem['baseSalary'] as int;
    final int finalSalary = (baseSalary * _salaryMultiplier).round();
    final String fullJobTitle = "${positionItem['title']} - ${teamItem['name']}";

    setState(() {
      character.setJob(fullJobTitle, finalSalary);
      character.athleteContractYears = contractYears;
    });
    widget.onRefresh();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kontrak Diterima! 🎉🏆'),
        content: Text(
          'Selamat! Manajemen ${teamItem['name']} menyetujui pengajuan kontrakmu selama $contractYears Tahun!\n\n'
          'Kamu resmi bergabung sebagai $fullJobTitle asal ${teamItem['origin']} (${teamItem['league']}) dengan nilai kontrak ${CurrencySettings.format(finalSalary)}/tahun.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
            },
            child: const Text('Luar Biasa!'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRequirementRow(String label, int currentVal, int minVal, bool isDark) {
    final bool isMet = currentVal >= minVal;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87),
        ),
        Row(
          children: [
            Text(
              '$currentVal% / $minVal%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isMet ? (isDark ? Colors.green.shade300 : Colors.green.shade700) : Colors.red,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isMet ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 14,
              color: isMet ? Colors.green : Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  void _showPositionSelectionModal(Map<String, String> teamItem) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, dynamic>> positions = List<Map<String, dynamic>>.from(widget.sportItem['positions']);

    Map<String, dynamic> selectedPosition = positions.first;
    int selectedContractYears = 3;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int minHealth = selectedPosition['minHealth'] ?? 0;
            final int minDiscipline = selectedPosition['minDiscipline'] ?? 0;
            final int minIntel = selectedPosition['minIntel'] ?? 0;

            final bool meetsHealth = widget.character.health >= minHealth;
            final bool meetsDiscipline = widget.character.discipline >= minDiscipline;
            final bool meetsIntel = widget.character.intelligence >= minIntel;
            final bool isQualified = meetsHealth && meetsDiscipline && meetsIntel;

            final int baseSal = selectedPosition['baseSalary'] as int;
            final int finalSalary = (baseSal * _salaryMultiplier).round();

            final int age = widget.character.age;
            final List<int> availableContractOptions = LogikaPemainSepakbola.getOpsiDurasiKontrak(age);
            if (!availableContractOptions.contains(selectedContractYears)) {
              selectedContractYears = 3;
            }

            int getChance(int yrs) {
              return LogikaPemainSepakbola.hitungPeluangDiterimaKontrak(
                usia: age,
                durasiKontrakTahun: yrs,
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (widget.sportItem['color'] as Color).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.sportItem['icon'] as IconData, color: widget.sportItem['color'] as Color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teamItem['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${teamItem['origin']} • ${teamItem['league']}',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Dropdown Pilihan Posisi
                    Text(
                      'PILIH POSISI KARIR:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: isDark ? Colors.white54 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.green.shade600, width: 1.5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, dynamic>>(
                          value: selectedPosition,
                          isExpanded: true,
                          dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green, size: 28),
                          items: positions.map((pos) {
                            final int sal = ((pos['baseSalary'] as int) * _salaryMultiplier).round();
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: pos,
                              child: Row(
                                children: [
                                  const Icon(Icons.sports_rounded, size: 18, color: Colors.green),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      pos['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${CurrencySettings.format(sal)}/thn',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedPosition = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Custom Dropdown Durasi Kontrak
                    Text(
                      'PILIH DURASI KONTRAK:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: isDark ? Colors.white54 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.blue.shade50.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.blue.shade600, width: 1.5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedContractYears,
                          isExpanded: true,
                          dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blue, size: 28),
                          items: availableContractOptions.map((yrs) {
                            final int ch = getChance(yrs);
                            return DropdownMenuItem<int>(
                              value: yrs,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kontrak $yrs Tahun',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : Colors.blue.shade900,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: ch >= 80 ? Colors.green.withValues(alpha: 0.15) : (ch >= 50 ? Colors.amber.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Peluang Diterima: $ch%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: ch >= 80 ? Colors.green : (ch >= 50 ? Colors.amber.shade900 : Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedContractYears = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Detail Kartu Posisi Terpilih
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.green.shade50.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Detail Kontrak',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isQualified ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isQualified ? 'Kualifikasi Sesuai ✅' : 'Terkunci 🔒',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Gaji Kontrak: ${CurrencySettings.format(finalSalary)} / tahun',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedPosition['desc'],
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 10),

                          // Detail Statistik Syarat
                          Text(
                            'PERSYARATAN KARIR:',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildStatRequirementRow('Kesehatan (Health)', widget.character.health, minHealth, isDark),
                          const SizedBox(height: 4),
                          _buildStatRequirementRow('Kedisiplinan', widget.character.discipline, minDiscipline, isDark),
                          const SizedBox(height: 4),
                          _buildStatRequirementRow('Kecerdasan (Intel)', widget.character.intelligence, minIntel, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isQualified ? Colors.green.shade600 : Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _applyJob(selectedPosition, teamItem, selectedContractYears);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isQualified) ...[
                        const Icon(Icons.lock, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        isQualified ? 'Lamar Posisi Ini' : 'Terkunci',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String sportName = widget.sportItem['name'] as String;
    final List<Map<String, String>> allTeams = TimOlahragaDatabase.getTeamsBySport(sportName);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedLeague != null) {
          setState(() {
            _selectedLeague = null;
            _searchController.clear();
            _searchQuery = '';
          });
        } else if (widget.character.jobName != null) {
          Navigator.of(context).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_selectedLeague != null) {
                setState(() {
                  _selectedLeague = null;
                  _searchController.clear();
                  _searchQuery = '';
                });
              } else if (widget.character.jobName != null) {
                Navigator.of(context).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            _selectedLeague == null ? 'Liga $sportName 🏆' : _selectedLeague!,
          ),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: _selectedLeague == null
            ? _buildLeagueList(isDark, sportName, allTeams)
            : _buildTeamList(isDark, sportName, allTeams),
      ),
    );
  }

  Widget _buildLeagueList(bool isDark, String sportName, List<Map<String, String>> allTeams) {
    final List<String> leagues = TimOlahragaDatabase.getLeaguesBySport(sportName);

    final filteredLeagues = leagues.where((league) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      if (league.toLowerCase().contains(query)) return true;
      // Juga cari jika nama tim di dalam liga ini mengandung query
      final teamsInLeague = allTeams.where((t) => t['league'] == league);
      return teamsInLeague.any((t) => t['name']!.toLowerCase().contains(query) || t['origin']!.toLowerCase().contains(query));
    }).toList();

    return Column(
      children: [
        // Header & Search Box
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                      Icon(widget.sportItem['icon'] as IconData, color: widget.sportItem['color'] as Color, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Liga & Kompetisi',
                              style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey),
                            ),
                            Text(
                              '$sportName (${leagues.length} Liga)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
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
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Cari Nama Liga / Negara / Tim...',
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

        // Sub-header
        if (filteredLeagues.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Liga (${filteredLeagues.length}):',
                  style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    'Pencarian: "$_searchQuery"',
                    style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                  ),
              ],
            ),
          ),

        // List Liga
        Expanded(
          child: filteredLeagues.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white38 : Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak ditemukan liga untuk kata kunci ini',
                        style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredLeagues.length,
                  itemBuilder: (context, index) {
                    final league = filteredLeagues[index];
                    final int teamCount = allTeams.where((t) => t['league'] == league).length;

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.shade700.withValues(alpha: 0.15),
                          child: const Icon(Icons.emoji_events_rounded, color: Colors.amber),
                        ),
                        title: Text(
                          league,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '$teamCount Tim / Klub Terdaftar',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedLeague = league;
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                          icon: const Text(
                            'Lihat Tim',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          label: const Icon(Icons.chevron_right_rounded, size: 18),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedLeague = league;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTeamList(bool isDark, String sportName, List<Map<String, String>> allTeams) {
    final List<Map<String, String>> teamsInLeague = allTeams.where((t) => t['league'] == _selectedLeague).toList();

    final List<Map<String, String>> filteredTeams = teamsInLeague.where((team) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final name = team['name']!.toLowerCase();
      final origin = team['origin']!.toLowerCase();
      return name.contains(query) || origin.contains(query);
    }).toList();

    return Column(
      children: [
        // Tombol Kembali ke Liga & Search Box
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Banner Liga Terpilih
              Card(
                elevation: 0,
                color: isDark ? Colors.grey.shade800 : Colors.green.shade50.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.green.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.emoji_events_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedLeague!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDark ? Colors.white : Colors.green.shade900,
                              ),
                            ),
                            Text(
                              '${teamsInLeague.length} Tim Terdaftar • $sportName',
                              style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white70 : Colors.green.shade800,
                          side: BorderSide(color: isDark ? Colors.grey.shade600 : Colors.green.shade400),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedLeague = null;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.arrow_back, size: 14),
                        label: const Text('Ganti Liga', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Search Input
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Cari Nama Tim / Asal Kota...',
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

        // Sub-header Hasil Tim
        if (filteredTeams.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Tim (${filteredTeams.length}):',
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

        // List Tim
        Expanded(
          child: filteredTeams.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white38 : Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak ditemukan tim untuk filter ini',
                        style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredTeams.length,
                  itemBuilder: (context, index) {
                    final team = filteredTeams[index];

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                      color: isDark ? Colors.grey.shade800 : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withValues(alpha: 0.1),
                          child: const Icon(Icons.shield_rounded, color: Colors.blue),
                        ),
                        title: Text(
                          team['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          'Asal: ${team['origin']} • ${team['league']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _showPositionSelectionModal(team),
                          child: const Text(
                            'Lamar Kerja',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        onTap: () => _showPositionSelectionModal(team),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
