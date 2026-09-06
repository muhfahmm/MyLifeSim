import 'package:flutter/material.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class AgeCategoryButton extends StatelessWidget {
  final Character character;
  final Map<String, dynamic> ageData;
  final int age;
  
  // Parameter tambahan untuk data karakter
  final String gender;
  final String location;
  final int health;
  final int happiness;
  final int intelligence;
  final int money;
  final int appearance;

  const AgeCategoryButton({
    super.key,
    required this.character,
    required this.ageData,
    required this.age,
    required this.gender,
    required this.location,
    required this.health,
    required this.happiness,
    required this.intelligence,
    required this.money,
    required this.appearance,
  });
  Widget _buildEducationHistorySection(BuildContext context) {
    final history = character.educationHistory;
    final int age = character.age;

    // Auto-sync history values based on age to guarantee synchronization
    if (age >= 6) {
      if (history['SD'] == null || (history['SD'] == 'Belum Lulus' && age >= 12)) {
        history['SD'] = age >= 12 ? 'Lulus' : 'Belum Lulus';
      }
    }
    if (age >= 12) {
      if (history['SMP'] == null || (history['SMP'] == 'Belum Lulus' && age >= 15)) {
        history['SMP'] = age >= 15 ? 'Lulus' : 'Belum Lulus';
      }
    }
    if (age >= 15) {
      if (history['SMA'] == null || (history['SMA'] == 'Belum Lulus' && age >= 18)) {
        history['SMA'] = age >= 18 ? 'Lulus' : 'Belum Lulus';
      }
    }

    final List<String> displayStages = [];

    if (character.age < 6) {
      return const Text(
        'Belum Memulai Pendidikan',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }

    // Selalu tampilkan SD
    displayStages.add('SD');

    if (history['SD'] == 'Lulus') {
      displayStages.add('SMP');
      if (history['SMP'] == 'Lulus') {
        displayStages.add('SMA');
        if (history['SMA'] == 'Lulus') {
          if (history['S1'] != null) {
            displayStages.add('S1');
            if (history['S1'] == 'Lulus') {
              if (history['S2'] != null) {
                displayStages.add('S2');
                if (history['S2'] == 'Lulus') {
                  if (history['S3'] != null) {
                    displayStages.add('S3');
                  }
                }
              }
            }
          }
        }
      }
    }

    // Ambil tema untuk menyesuaikan warna
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade50;
    final cardBorderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      children: displayStages.map((stage) {
        final status = history[stage] ?? 'Belum Lulus';
        Color badgeColor = Colors.grey;
        String statusLabel = 'Belum Lulus';

        if (status == 'Lulus') {
          badgeColor = Colors.green;
          statusLabel = 'Lulus';
        } else if (status == 'Putus Sekolah') {
          badgeColor = Colors.red;
          statusLabel = 'Putus Sekolah';
        } else {
          badgeColor = Colors.blue;
          statusLabel = 'Sedang Ditempuh';
        }

        String stageLabel = stage;
        if (stage == 'S1') {
          if (status == 'Lulus' && character.graduatedMajors.isNotEmpty) {
            stageLabel = 'S1 - ${character.graduatedMajors[0]}';
          } else if (statusLabel == 'Sedang Ditempuh' && character.univMajor != null) {
            stageLabel = 'S1 - ${character.univMajor!.split(" (").first}';
          }
        } else if (stage == 'S2') {
          if (status == 'Lulus' && character.graduatedMajors.length >= 2) {
            stageLabel = 'S2 - ${character.graduatedMajors[1]}';
          } else if (statusLabel == 'Sedang Ditempuh' && character.univMajor != null) {
            stageLabel = 'S2 - ${character.univMajor!.split(" (").first}';
          }
        } else if (stage == 'S3') {
          if (status == 'Lulus' && character.graduatedMajors.length >= 3) {
            stageLabel = 'S3 - ${character.graduatedMajors[2]}';
          } else if (statusLabel == 'Sedang Ditempuh' && character.univMajor != null) {
            stageLabel = 'S3 - ${character.univMajor!.split(" (").first}';
          }
        }

        return Card(
          elevation: 0,
          color: cardBgColor, // Sesuaikan warna background dengan tema
          margin: const EdgeInsets.only(bottom: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: cardBorderColor), // Sesuaikan warna border dengan tema
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    stageLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textColor, // Tambahkan warna teks yang sesuai tema
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = ageData['color'];
    return InkWell(
      onTap: () {
        DialogHelper.show(
          context: context,
          title: '📊 Kategori & Status',
          isNotification: false,
          content: (() {
            int activeTab = 0; // 0: Pendidikan, 1: Pekerjaan
            return StatefulBuilder(
              builder: (context, setDialogState) {
                final theme = Theme.of(context);
                final isDark = theme.brightness == Brightness.dark;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- HEADER: IKON USIA ---
                    Center(
                      child: Column(
                        children: [
                          Icon(ageData['icon'], size: 56, color: color),
                          const SizedBox(height: 8),
                          Text(
                            '${ageData['label']}',
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- INFO DASAR (Gender, Usia, Lokasi) ---
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoItem(context, Icons.wc, 'Gender', gender, Colors.purple),
                          _buildInfoItem(context, Icons.cake, 'Usia', '$age Tahun', Colors.blue),
                          _buildInfoItem(context, Icons.location_on, 'Lokasi', location, Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- STATISTIK KARAKTER ---
                    const Text('📈 Statistik Karakter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildStatChip(context, Icons.favorite, 'Kesehatan', health, Colors.red),
                        _buildStatChip(context, Icons.sentiment_satisfied, 'Kebahagiaan', happiness, Colors.green),
                        _buildStatChip(context, Icons.psychology, 'Kecerdasan', intelligence, Colors.blue),
                        _buildStatChip(context, Icons.monetization_on, 'Uang', money, Colors.amber, isMoney: true),
                        _buildStatChip(context, Icons.face, 'Penampilan', appearance, Colors.pink),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- TAB MENU ---
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setDialogState(() => activeTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: activeTab == 0 ? color : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '🎓 Pendidikan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: activeTab == 0 ? color : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setDialogState(() => activeTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: activeTab == 1 ? color : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '💼 Pekerjaan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: activeTab == 1 ? color : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (activeTab == 0)
                      _buildEducationHistorySection(context)
                    else
                      _buildJobHistorySection(context),
                  ],
                );
              },
            );
          }()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ageData['icon'], color: color, size: 20),
              Text(
                ageData['label'],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET PEMBANTU UNTUK INFO DASAR ---
  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value, 
          style: TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  // --- WIDGET PEMBANTU UNTUK CHIP STATISTIK ---
  Widget _buildStatChip(BuildContext context, IconData icon, String label, int value, Color color, {bool isMoney = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        isMoney ? '\$$value' : '$value%',
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildJobHistorySection(BuildContext context) {
    final history = character.jobHistory;
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          'Belum memiliki riwayat pekerjaan.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade50;
    final cardBorderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      children: history.map((job) {
        final title = job['title'] as String? ?? 'Pekerjaan';
        final salary = job['salary'] as int? ?? 0;
        final startAge = job['startAge'] as int? ?? 0;
        final endAge = job['endAge'] as int?;
        final endAgeStr = endAge != null ? '$endAge Tahun' : 'Sekarang';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBgColor,
            border: Border.all(color: cardBorderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: const Icon(Icons.work, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Gaji: \$$salary/tahun',
                      style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Masa Kerja: $startAge Tahun - $endAgeStr',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}