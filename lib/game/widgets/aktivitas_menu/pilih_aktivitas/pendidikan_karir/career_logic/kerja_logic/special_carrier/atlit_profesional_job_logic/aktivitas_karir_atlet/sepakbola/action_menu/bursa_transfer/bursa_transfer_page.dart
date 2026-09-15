// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/bursa_transfer/bursa_transfer_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class BursaTransferPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BursaTransferPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<BursaTransferPage> createState() => _BursaTransferPageState();
}

class _BursaTransferPageState extends State<BursaTransferPage> {
  void _showAlert(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(desc, style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _ajukanTransferRequest() {
    final r = Random();
    final bool isAccepted = r.nextBool();
    if (isAccepted) {
      _showAlert(
        'Transfer Request Disetujui 📄',
        'Manajemen klub menyetujui permohonan transfermu! Agenmu kini dapat berkomunikasi bebas dengan klub peminat luar negeri.',
      );
    } else {
      _showAlert(
        'Transfer Request Ditolak 🚫',
        'Pelatih dan manajemen klub menolak menjualmu musim ini karena peranmu sangat vital dalam skuad utama!',
      );
    }
  }

  void _pindahKlub(String targetClub, int offeredSalary, String league) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Terima Tawaran $targetClub? ⚽', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Klub $targetClub ($league) mengajukan kontrak transfer resmi!', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Text('• Gaji Baru: ${CurrencySettings.format(offeredSalary.toDouble())}/tahun\n• Durasi Kontrak: 3 Tahun', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tolak')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              widget.character.jobSalary = offeredSalary;
              widget.character.athleteContractYears = 3;
              widget.character.coworkers.clear();
              widget.character.generateCoworkersIfEmpty();
              setState(() {});
              widget.onRefresh();

              _showAlert(
                'Resmi Pindah Klub! 🎉',
                'Selamat! Kamu resmi bergabung dengan $targetClub ($league) dengan durasi kontrak 3 tahun!',
              );
            },
            child: const Text('Terima & Tanda Tangan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bursa Transfer & Agen Pemain ✈️⚽'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // STATUS KONTRAK SAAT INI
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.swap_horiz_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pekerjaan / Klub Saat Ini',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                            Text(
                              widget.character.jobName ?? 'Pemain Bebas Transfer',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.blue.shade900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sisa Kontrak:', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                      Text('${widget.character.athleteContractYears} Tahun', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // AKSI TRANSFER
          _buildSectionTitle('Manajemen Transfer Request 📄', isDark),
          _buildActionCard(
            title: 'Ajukan Official Transfer Request 📝',
            desc: 'Minta dijual ke klub luar negeri jika ingin mencari tantangan baru',
            icon: Icons.post_add_rounded,
            color: Colors.deepOrange,
            onTap: _ajukanTransferRequest,
          ),

          const SizedBox(height: 16),

          // TAWARAN KLUB MINAT
          _buildSectionTitle('Tawaran Klub Berminat 🌍', isDark),
          _buildClubOfferCard('Real Madrid FC 👑', 'La Liga Spanyol', 120000000, isDark),
          _buildClubOfferCard('Manchester City 🌐', 'Premier League', 110000000, isDark),
          _buildClubOfferCard('Paris Saint-Germain 🇫🇷', 'Ligue 1 Prancis', 95000000, isDark),
          _buildClubOfferCard('Bayern Munchen 🇩🇪', 'Bundesliga Jerman', 90000000, isDark),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildClubOfferCard(String club, String league, int offeredSalary, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.sports_soccer, color: Colors.white, size: 20),
        ),
        title: Text(club, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text('$league\nGaji: ${CurrencySettings.format(offeredSalary.toDouble())}/thn', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _pindahKlub(club, offeredSalary, league),
          child: const Text('Negosiasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
