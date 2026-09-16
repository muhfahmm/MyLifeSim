// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/rekan_bisnis/rekan_bisnis_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/rekan_bisnis/rekan_bisnis_interaction_page.dart';

class RekanBisnisPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanBisnisPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanBisnisPage> createState() => _RekanBisnisPageState();
}

class _RekanBisnisPageState extends State<RekanBisnisPage> {
  Character get character => widget.character;

  @override
  void initState() {
    super.initState();
    _adjustBusinessRoles();
  }

  void _adjustBusinessRoles() {
    if (character.coworkers.isEmpty) {
      final r = Random();
      final roles = ['Manajer Operasional', 'Staf Keuangan', 'Kepala Pemasaran', 'Supervisor Toko', 'Staf R&D'];
      for (int i = 0; i < 5; i++) {
        final gender = r.nextBool() ? 'Laki-laki' : 'Perempuan';
        final name = (gender == 'Laki-laki')
            ? ['Andi', 'Budi', 'Candra', 'Dedi', 'Eko'][i]
            : ['Anisa', 'Bunga', 'Citra', 'Dewi', 'Eka'][i];
        character.coworkers.add({
          'name': name,
          'gender': gender,
          'relationship': (50 + r.nextInt(30)).toString(),
          'age': (22 + r.nextInt(25)).toString(),
          'isDeceased': 'false',
          'sexuality': 'Heteroseksual',
          'role': roles[i],
        });
      }
    } else {
      final roles = ['Manajer Operasional', 'Staf Keuangan', 'Kepala Pemasaran', 'Supervisor Toko', 'Staf R&D'];
      for (int i = 0; i < character.coworkers.length; i++) {
        final cw = character.coworkers[i];
        if (cw['role'] == null || cw['role'] == 'Talent Esports' || cw['role'] == 'Rekan Kerja') {
          cw['role'] = roles[i % roles.length];
        }
      }
    }
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.shade800.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade700.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  void _showAlert(String title, String msg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
        content: SizedBox(
          width: double.infinity,
          child: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _beriBonusSemua() {
    const int bonusPerEmployee = 500;
    final int totalCost = character.coworkers.length * bonusPerEmployee;
    if (character.money < totalCost) {
      _showAlert('Uang Tidak Cukup 💸', 'Dibutuhkan ${CurrencySettings.format(totalCost.toDouble())} untuk memberi bonus kepada seluruh tim karyawan.');
      return;
    }

    setState(() {
      character.money -= totalCost;
      for (var cw in character.coworkers) {
        int rel = int.tryParse(cw['relationship'] ?? '50') ?? 50;
        cw['relationship'] = (rel + 10).clamp(0, 100).toString();
      }
      character.businessAnnualProfit += (character.businessAnnualProfit * 0.10).round();
    });
    widget.onRefresh();

    _showAlert('Bonus Dibagikan! 🎉', 'Kamu membagikan bonus masing-masing \$500 ke seluruh karyawan! Hubungan & moral tim meningkat pesat!');
  }

  void _instruksiKebijakan() {
    final profitBoost = (character.businessAnnualProfit * 0.05).round();
    setState(() {
      character.businessAnnualProfit += profitBoost;
      character.intelligence = (character.intelligence + 1).clamp(0, 100);
    });
    widget.onRefresh();

    _showAlert('Pengarahan CEO 📜', 'Sebagai Pemilik Usaha, kamu memimpin rapat manajerial dan memberikan instruksi strategis baru!\n\n• Profit Tahunan: +${CurrencySettings.format(profitBoost.toDouble())}\n• Kecerdasan Kepemimpinan: +1%');
  }

  void _interactWithEmployee(Map<String, String> employee, String action) {
    final name = employee['name'] ?? 'Karyawan';
    int rel = int.tryParse(employee['relationship'] ?? '50') ?? 50;

    if (action == 'puji') {
      rel = (rel + 8).clamp(0, 100);
      employee['relationship'] = rel.toString();
      _showAlert('Pujian Pemilik Usaha 👏', 'Kamu memuji kinerja luar biasa $name di hadapan tim. $name merasa bangga dan makin loyal!');
    } else if (action == 'traktir') {
      if (character.money < 100) {
        _showAlert('Uang Tidak Cukup 💸', 'Dibutuhkan \$100 untuk mentraktir.');
        return;
      }
      character.money -= 100;
      rel = (rel + 12).clamp(0, 100);
      employee['relationship'] = rel.toString();
      _showAlert('Makan Bersama 🍕', 'Kamu mengundang $name makan siang bersama. Hubunganmu dengannya semakin hangat (+12)!');
    } else if (action == 'bonus') {
      if (character.money < 1000) {
        _showAlert('Uang Tidak Cukup 💸', 'Dibutuhkan \$1,000 untuk bonus pribadi.');
        return;
      }
      character.money -= 1000;
      rel = (rel + 15).clamp(0, 100);
      employee['relationship'] = rel.toString();
      _showAlert('Bonus Pribadi 💵', 'Kamu memberikan bonus tunai khusus sebesar \$1,000 kepada $name!');
    } else if (action == 'interaksi') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RekanBisnisInteractionPage(
            character: character,
            coworker: employee,
            onRefresh: () {
              setState(() {});
              widget.onRefresh();
            },
          ),
        ),
      );
      return;
    }

    setState(() {});
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tim & Karyawan Usaha 🏢', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // KARTU ATASAN: USER SEBAGAI PEMILIK USAHA & CEO 👑
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.green.shade700, width: 1.2),
            ),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.amber.shade100,
                        child: const Icon(Icons.star, color: Colors.amber, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Text(
                                  character.name,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('PEMILIK USAHA & CEO 👑', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.brown)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pendiri & Pemilik Utama: ${character.businessName ?? "Usaha Mandiri"}',
                              style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _instruksiKebijakan,
                          icon: const Icon(Icons.assignment, size: 13),
                          label: const Text('Instruksi Kebijakan', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _beriBonusSemua,
                          icon: const Icon(Icons.card_giftcard, size: 13),
                          label: const Text('Bonus Semua Tim', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SUB-HEADER DAFTAR KARYAWAN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Daftar Staf & Karyawan (${character.coworkers.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Bawahan Langsung',
                  style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // LIST KARYAWAN PERUSAHAAN
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: character.coworkers.length,
            itemBuilder: (context, index) {
              final cw = character.coworkers[index];
              final name = cw['name'] ?? 'Karyawan';
              final gender = cw['gender'] ?? 'Laki-laki';
              final ageVal = int.tryParse(cw['age'] ?? '25') ?? 25;
              final rel = int.tryParse(cw['relationship'] ?? '50') ?? 50;
              final role = cw['role'] ?? 'Staf Karyawan';
              final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                name: name,
                gender: gender,
                age: ageVal,
                schoolLevel: 'SMA',
                happiness: rel,
              );

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                color: isDark ? Colors.grey.shade800 : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AvatarImageCache.buildAvatar(
                            url: avatarUrl,
                            width: 40,
                            height: 40,
                            gender: gender,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildRoleBadge(role),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('$gender, Usia $ageVal thn', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Hubungan: $rel%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                          ),
                        ],
                      ),
                      const Divider(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                            onPressed: () => _interactWithEmployee(cw, 'puji'),
                            icon: const Icon(Icons.thumb_up, size: 12, color: Colors.blue),
                            label: const Text('Puji Kinerja', style: TextStyle(fontSize: 10.5)),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                            onPressed: () => _interactWithEmployee(cw, 'traktir'),
                            icon: const Icon(Icons.local_pizza, size: 12, color: Colors.orange),
                            label: const Text('Traktir Makan', style: TextStyle(fontSize: 10.5)),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                            onPressed: () => _interactWithEmployee(cw, 'bonus'),
                            icon: const Icon(Icons.attach_money, size: 12, color: Colors.green),
                            label: const Text('Beri Bonus', style: TextStyle(fontSize: 10.5)),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                            onPressed: () => _interactWithEmployee(cw, 'interaksi'),
                            icon: const Icon(Icons.favorite, size: 12, color: Colors.pink),
                            label: const Text('Interaksi Dekat', style: TextStyle(fontSize: 10.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

