// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/esport_logic/syarat_ketentuan_esport_modal.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'tim_esport.dart';
import 'BA/ba_esport_percentage.dart';
import 'proplayer/pro_player_percentage.dart';
import 'talent/talent_esport_percentage.dart';

class SyaratKetentuanEsportModal extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const SyaratKetentuanEsportModal({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  /// Static helper untuk menampilkan Modal Pendaftaran & Pilihan Tim Esports
  static void show({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SyaratKetentuanEsportModal(
        character: character,
        onRefresh: onRefresh,
      ),
    );
  }

  @override
  State<SyaratKetentuanEsportModal> createState() => _SyaratKetentuanEsportModalState();
}

class _SyaratKetentuanEsportModalState extends State<SyaratKetentuanEsportModal> {
  // Roles
  String _selectedRole = 'Pro Player Esport';
  String? _selectedTeam;
  int _currentStep = 1; // Step 1: Modals Syarat & Peran, Step 2: Pilihan Tim

  final List<Map<String, dynamic>> _roles = [
    {
      'title': 'Pro Player Esport',
      'icon': Icons.sports_esports,
      'color': Colors.deepOrange,
      'minAge': 12,
      'salary': 2500, // $2500 USD
      'desc': 'Fokus latihan scrim, mekanik tinggi & ikuti turnamen utama.',
    },
    {
      'title': 'Talent Esports',
      'icon': Icons.videocam,
      'color': Colors.purple,
      'minAge': 13,
      'salary': 1500, // $1500 USD
      'desc': 'Membuat konten streaming, acara publik & promosi tim.',
    },
    {
      'title': 'Brand Ambassador Esport',
      'icon': Icons.star,
      'color': Colors.amber,
      'minAge': 15,
      'salary': 2000, // $2000 USD
      'desc': 'Wajah utama tim esport di event majalah, iklan & sponsor besar.',
    },
  ];

  Map<String, dynamic> get _currentRoleData =>
      _roles.firstWhere((r) => r['title'] == _selectedRole);

  int _calculateChance() {
    final char = widget.character;
    double baseChance = 0.5;

    if (_selectedRole == 'Pro Player Esport') {
      baseChance = ProPlayerPercentage.getApplyChance(char.gender, char.specialTalent);
    } else if (_selectedRole == 'Brand Ambassador Esport') {
      baseChance = BaEsportPercentage.getApplyChance(char.gender, hasIdolHistory: char.hasIdolHistory);
    } else if (_selectedRole == 'Talent Esports') {
      baseChance = TalentEsportPercentage.getApplyChance(char.gender, hasIdolHistory: char.hasIdolHistory);
    }

    // Bonus dari atribut karakter (Kedisiplinan, Penampilan, Kecerdasan)
    double attrBonus = 0.0;
    if (_selectedRole == 'Pro Player Esport') {
      attrBonus = (char.discipline / 100.0) * 0.10 + (char.intelligence / 100.0) * 0.05;
    } else {
      attrBonus = (char.appearance / 100.0) * 0.10 + (char.happiness / 100.0) * 0.05;
    }

    double finalPercent = (baseChance + attrBonus) * 100.0;
    return finalPercent.clamp(10.0, 95.0).round();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final char = widget.character;
    final roleData = _currentRoleData;
    final int chancePercent = _calculateChance();

    final int minAge = roleData['minAge'] as int;
    final bool isAgeValid = char.age >= minAge;
    final bool isDisciplineValid = char.discipline >= 60;
    final bool isEligible = isAgeValid && isDisciplineValid;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER MODAL
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (roleData['color'] as Color).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(roleData['icon'] as IconData, color: roleData['color'] as Color, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentStep == 1 ? 'Karir E-Sports 🎮' : 'Pilih Tim Esport Impian 🛡️',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _currentStep == 1 ? 'Syarat, Ketentuan & Peran' : 'Langkah 2 dari 2: Pilih Organisasi',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: isDark ? Colors.white54 : Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 10),

              if (_currentStep == 1) ...[
                // STEP 1: PILIH PERAN & SYARAT KETENTUAN
                Text(
                  'Pilih Peran E-Sports:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),

                // ROLE SELECTOR CARDS
                Column(
                  children: _roles.map((r) {
                    final bool isSelected = r['title'] == _selectedRole;
                    final Color rColor = r['color'] as Color;
                    return InkWell(
                      onTap: () => setState(() => _selectedRole = r['title'] as String),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? rColor.withValues(alpha: 0.15)
                              : (isDark ? Colors.grey.shade800.withValues(alpha: 0.4) : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? rColor : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(r['icon'] as IconData, color: isSelected ? rColor : Colors.grey, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['title'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    r['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle, color: rColor, size: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // PELUANG KELULUSAN BADGE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.teal.shade900.withValues(alpha: 0.5) : const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.teal.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.analytics_outlined, color: Colors.teal, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peluang Diterima ($_selectedRole):',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.teal.shade200 : Colors.teal.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '$chancePercent%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : Colors.teal.shade800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: chancePercent / 100.0,
                                      minHeight: 6,
                                      backgroundColor: Colors.teal.withValues(alpha: 0.2),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // SYARAT & KETENTUAN LIST
                Text(
                  'Kualifikasi Minimal Karir:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.blueGrey.shade800),
                ),
                const SizedBox(height: 8),
                _buildCheckRow(
                  isDark: isDark,
                  title: 'Batas Usia Minimal',
                  subtitle: 'Syarat: Min $minAge Tahun (Usia Karakter: ${char.age} Thn)',
                  isValid: isAgeValid,
                ),
                _buildCheckRow(
                  isDark: isDark,
                  title: 'Kedisiplinan Minimal (60%)',
                  subtitle: 'Kedisiplinan Karakter: ${char.discipline}%',
                  isValid: isDisciplineValid,
                ),

                const SizedBox(height: 10),

                // GAJI & INFO
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800.withValues(alpha: 0.5) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payments_outlined, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Estimasi Gaji: ${CurrencySettings.format(roleData['salary'] as int)} / bulan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.greenAccent : Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // TOMBOL STEP 1
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEligible ? Colors.teal.shade700 : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isEligible
                            ? () => setState(() => _currentStep = 2)
                            : () {
                                DialogHelper.show(
                                  context: context,
                                  title: 'Kualifikasi Belum Terpenuhi 🚫',
                                  content: Text('Usiamu minimal harus $minAge tahun dan kedisiplinan minimal 60% untuk mendaftar posisi ini.'),
                                );
                              },
                        child: const Text('Lanjut Pilih Tim 🛡️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // STEP 2: PILIHAN TIM ESPORT
                Text(
                  'Pilih Organisasi / Tim Esport:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),

                // GRID/LIST TIM ESPORT
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    itemCount: EsportsTeams.list.length,
                    itemBuilder: (ctx, idx) {
                      final teamName = EsportsTeams.list[idx];
                      final bool isSelected = _selectedTeam == teamName;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.teal.withValues(alpha: 0.15)
                              : (isDark ? Colors.grey.shade800.withValues(alpha: 0.3) : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.teal : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            teamName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.teal, size: 20)
                              : const Icon(Icons.circle_outlined, color: Colors.grey, size: 18),
                          onTap: () => setState(() => _selectedTeam = teamName),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // TOMBOL EKSEKUSI STEP 2
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => setState(() => _currentStep = 1),
                        child: const Text('Kembali'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedTeam != null ? Colors.teal.shade700 : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _selectedTeam != null
                            ? () {
                                Navigator.pop(context);
                                _submitEsportApplication(
                                  context,
                                  _selectedRole,
                                  _selectedTeam!,
                                  roleData['salary'] as int,
                                  chancePercent,
                                );
                              }
                            : null,
                        child: const Text('Kirim Lamaran 🚀', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckRow({
    required bool isDark,
    required String title,
    required String subtitle,
    required bool isValid,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(isValid ? Icons.check_circle : Icons.cancel, color: isValid ? Colors.green : Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $subtitle',
              style: TextStyle(
                fontSize: 11,
                color: isValid ? (isDark ? Colors.greenAccent : Colors.green.shade800) : (isDark ? Colors.redAccent : Colors.red.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Eksekusi pengiriman lamaran karir Esport
  void _submitEsportApplication(
    BuildContext context,
    String role,
    String team,
    int salary,
    int chancePercent,
  ) {
    final int roll = Random().nextInt(100);
    final bool isSuccess = roll < chancePercent;
    final String fullJobTitle = '$role ($team)';

    if (isSuccess) {
      // DITERIMA DI TIM ESPORT!
      widget.character.setJob(fullJobTitle, salary);
      widget.character.inbox.add(
        '🎮 Kontrak Esport Diterima: Kamu resmi bergabung dengan $team sebagai $role dengan gaji ${CurrencySettings.format(salary)}/bulan!',
      );

      widget.onRefresh();

      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('🎮', style: TextStyle(fontSize: 26)),
              SizedBox(width: 8),
              Expanded(
                child: Text('Kontrak Diterima! 🎉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          content: Text(
            'Selamat! Pihak manajemen $team terkesan dengan profilmu dan menyetujui kontrak sebagai $role!\n\n'
            'Gaji: ${CurrencySettings.format(salary)}/bulan',
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nav = Navigator.of(context);
                Navigator.pop(dialogCtx); // Pop alert dialog
                Navigator.pop(context);   // Pop SyaratKetentuanEsportModal
                nav.pop();                // Pop PekerjaanSpesialMenuScreen (returns to Pekerjaan & Karir)
              },
              child: const Text('Buka HQ Esport 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      // PENOLAKAN DARI TIM ESPORT
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('📢', style: TextStyle(fontSize: 26)),
              SizedBox(width: 8),
              Expanded(
                child: Text('Lamaran Ditolak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          content: Text(
            'Pihak manajemen $team mengapresiasi minatmu, namun saat ini kualifikasimu belum memenuhi standar roster tim.\n\n'
            'Tingkatkan kedisiplinan dan kecerdasanmu sebelum mencoba melamar lagi!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }
}
