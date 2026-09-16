import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';

class HalamanRekrutTraineeBaru extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const HalamanRekrutTraineeBaru({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<HalamanRekrutTraineeBaru> createState() => _HalamanRekrutTraineeBaruState();
}

class _HalamanRekrutTraineeBaruState extends State<HalamanRekrutTraineeBaru> {
  final Random _random = Random();
  final List<Map<String, dynamic>> _candidates = [];
  final Set<int> _selectedIndices = {};

  static const List<String> _skinColors = [
    'ffdbb4', 'edb98a', 'f8d25c', 'fd9841', 'ae5d29', 'd08b5b'
  ];

  @override
  void initState() {
    super.initState();
    _generate20Candidates();
  }

  void _generate20Candidates() {
    _candidates.clear();
    _selectedIndices.clear();

    final firstList = widget.character.femaleFirstNames ?? [];
    final lastList = widget.character.lastNames ?? [];

    final resolvedFirst = firstList.isNotEmpty ? firstList : Character.globalFemaleFirstNames;
    final resolvedLast = lastList.isNotEmpty ? lastList : Character.globalLastNames;

    for (int i = 0; i < 20; i++) {
      final fName = resolvedFirst.isNotEmpty
          ? resolvedFirst[_random.nextInt(resolvedFirst.length)]
          : 'Trainee';
      final lName = resolvedLast.isNotEmpty
          ? resolvedLast[_random.nextInt(resolvedLast.length)]
          : 'Candidate';
      final name = '$fName $lName'.trim();

      final age = 12 + _random.nextInt(3); // Usia 12-14 th untuk trainee baru
      final vokal = 45 + _random.nextInt(46);
      final tarian = 45 + _random.nextInt(46);
      final pesona = 50 + _random.nextInt(41);
      final stamina = 50 + _random.nextInt(41);
      final overall = (vokal + tarian + pesona + stamina) ~/ 4;
      final skinColor = _skinColors[_random.nextInt(_skinColors.length)];

      _candidates.add({
        'name': name,
        'gender': 'Perempuan',
        'age': age.toString(),
        'yearsInTrainee': '0',
        'skinColor': skinColor,
        'vokal': vokal,
        'tarian': tarian,
        'pesona': pesona,
        'stamina': stamina,
        'overall': overall,
        'relationship': (50 + _random.nextInt(21)).toString(),
      });
    }
  }

  void _rekrutCandidates() {
    final int count = _selectedIndices.length;
    if (count < 8 || count > 15) {
      DialogHelper.show(
        context: context,
        title: 'Jumlah Rekrutmen Tidak Sesuai ⚠️',
        content: Text(
          'Anda memilih $count kandidat.\nPilih minimal 8 dan maksimal 15 kandidat trainee untuk membentuk generasi baru.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
      return;
    }

    // Tentukan nomor generasi baru (Generasi terbesar + 1)
    int maxGen = 7;
    for (var list in [widget.character.idolTrainees, widget.character.idolMainMembers, widget.character.idolGraduatedMembers]) {
      for (var m in list) {
        final g = int.tryParse(m['generation'] ?? '0') ?? 0;
        if (g > maxGen) maxGen = g;
      }
    }
    int nextGenNum = maxGen + 1;

    setState(() {
      for (int idx in _selectedIndices) {
        final cand = _candidates[idx];
        widget.character.idolTrainees.add({
          'name': cand['name'],
          'gender': cand['gender'],
          'age': cand['age'],
          'yearsInTrainee': '0',
          'generation': nextGenNum.toString(),
          'relationship': cand['relationship'],
          'skinColor': cand['skinColor'],
        });
      }

      // Catat usia karakter saat merekrut agar batas 1 tahun 1x berlaku
      widget.character.lastRecruitAge = widget.character.age;

      // Kurangi kebahagiaan & tambah kedisiplinan sebagai efek aktivitas staf GM
      widget.character.happiness = (widget.character.happiness - 4).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + 6).clamp(0, 100);

      final notice = '🆕 Generasi Baru Resmi Direkrut: Gen $nextGenNum dengan $count anggota trainee baru telah resmi bergabung!';
      widget.character.idolNews.add(notice);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Rekrutmen Trainee Sukses! 🎉',
      content: Text(
        'Selamat! Anda telah memilih dan merekrut $count anggota trainee baru untuk Gen $nextGenNum.\n'
        'Jumlah personil trainee grup idol kini bertambah!',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Pop dialog
            Navigator.pop(context); // Kembali dari halaman rekrutmen
          },
          child: const Text('Selesai'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int selectedCount = _selectedIndices.length;
    final bool isValidCount = selectedCount >= 8 && selectedCount <= 15;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleksi Generasi Trainee Baru 📋'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: Column(
        children: [
          // Banner Status Seleksi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isDark ? Colors.grey.shade800 : Colors.pink.shade50,
            child: Row(
              children: [
                Icon(
                  isValidCount ? Icons.check_circle : Icons.info_outline,
                  color: isValidCount ? Colors.green : Colors.pink.shade700,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih 8 - 15 Kandidat (Terpilih: $selectedCount/20)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: isValidCount
                              ? (isDark ? Colors.greenAccent : Colors.green.shade800)
                              : (isDark ? Colors.white : Colors.pink.shade900),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Centang kandidat berbakat yang ingin dimasukkan ke generasi trainee baru.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white60 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar 20 Kandidat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _candidates.length,
              itemBuilder: (context, index) {
                final cand = _candidates[index];
                final bool isSelected = _selectedIndices.contains(index);

                final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                  name: cand['name'],
                  gender: cand['gender'],
                  age: int.parse(cand['age']),
                  happiness: 80,
                  forcedSkinColor: cand['skinColor'],
                );

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  color: isSelected
                      ? (isDark ? Colors.pink.shade900.withOpacity(0.4) : Colors.pink.shade50)
                      : (isDark ? Colors.grey.shade800 : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.pink.shade400
                          : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedIndices.remove(index);
                        } else {
                          if (_selectedIndices.length < 15) {
                            _selectedIndices.add(index);
                          } else {
                            DialogHelper.show(
                              context: context,
                              title: 'Batas Maksimal Ditecapai ⚠️',
                              content: const Text('Anda hanya dapat memilih maksimal 15 kandidat trainee.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          }
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            activeColor: Colors.pink.shade700,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  if (_selectedIndices.length < 15) {
                                    _selectedIndices.add(index);
                                  }
                                } else {
                                  _selectedIndices.remove(index);
                                }
                              });
                            },
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.pink.shade100,
                            radius: 20,
                            child: ClipOval(
                              child: Image(
                                image: AvatarImageCache.getImageProvider(avatarUrl),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cand['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Usia: ${cand['age']} th • Potensi Overall: ${cand['overall']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white60 : Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _buildMiniChip('Vokal: ${cand['vokal']}%', Colors.blue, isDark),
                                    const SizedBox(width: 4),
                                    _buildMiniChip('Tari: ${cand['tarian']}%', Colors.pink, isDark),
                                    const SizedBox(width: 4),
                                    _buildMiniChip('Pesona: ${cand['pesona']}%', Colors.purple, isDark),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Tombol Rekrut
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isValidCount ? Colors.pink.shade700 : Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isValidCount ? _rekrutCandidates : null,
              child: Text(
                'Rekrut Generasi Baru ($selectedCount Terpilih)',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
