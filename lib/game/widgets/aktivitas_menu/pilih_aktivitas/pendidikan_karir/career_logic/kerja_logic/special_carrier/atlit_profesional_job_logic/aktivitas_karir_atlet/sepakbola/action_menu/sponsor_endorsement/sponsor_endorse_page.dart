// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/sponsor_endorsement/sponsor_endorse_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class SponsorEndorsePage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const SponsorEndorsePage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<SponsorEndorsePage> createState() => _SponsorEndorsePageState();
}

class _SponsorEndorsePageState extends State<SponsorEndorsePage> {
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

  void _tandaTanganSponsor(String brand, int basePay, int minFollowers) {
    if (widget.character.followers < minFollowers) {
      _showAlert(
        'Syarat Belum Terpenuhi',
        'Sponsor $brand membutuhkan minimal $minFollowers followers!\n'
        'Jumlah followersmu saat ini: ${widget.character.followers}.',
      );
      return;
    }

    final r = Random();
    final bonusMoney = basePay + (r.nextInt(2000) * 10);
    widget.character.money += bonusMoney;
    widget.character.popularity = (widget.character.popularity + 4).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Kontrak Sponsor Disetujui! ✍️👟',
      'Kamu resmi menandatangani kontrak eksklusif dengan $brand!\n\n'
      '• Imbalan Sponsor: ${CurrencySettings.format(bonusMoney.toDouble())}\n'
      '• Popularitas: +4%',
    );
  }

  void _syutingIklan() {
    final r = Random();
    final pay = 2500000 + (r.nextInt(1000) * 1000);
    widget.character.money += pay;
    widget.character.followers += r.nextInt(1500) + 500;
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Syuting Iklan Komersial TV 🎬',
      'Kamu menjadi bintang utama dalam iklan komersial minuman berenergi!\n\n'
      '• Fee Syuting: ${CurrencySettings.format(pay.toDouble())}\n'
      '• Tambahan Fans & Followers!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsor & Commercial Deals 👟💼'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // HEADER KARTU SPONSOR
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.monetization_on, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nilai Komersial Atlet',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                            Text(
                              'Popularitas: ${widget.character.popularity}% ⭐',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.amber.shade900),
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
                      Text('Jumlah Followers:', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                      Text('${widget.character.followers} Fans', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // PENWARAN KONTRAK SEPATU / APPAREL
          _buildSectionTitle('Kontrak Apparel & Shoes Sponsor 👟', isDark),
          _buildSponsorCard('Nike Global Elite ⚡', 'Fee Kontrak: Rp 50.000.000', 5000, 50000000, isDark),
          _buildSponsorCard('Adidas World Ambassador 👟', 'Fee Kontrak: Rp 35.000.000', 2500, 35000000, isDark),
          _buildSponsorCard('Puma Speedster Pro 🐆', 'Fee Kontrak: Rp 20.000.000', 1000, 20000000, isDark),

          const SizedBox(height: 16),

          // IKLAN & ENDORSEMENT
          _buildSectionTitle('Aktivitas Komersial & Endorse 🎬', isDark),
          _buildActionCard(
            title: 'Syuting Iklan Komersial TV & Billboard 📺',
            desc: 'Bintangi iklan produk olahraga & minuman energi (+Uang & Followers)',
            icon: Icons.movie_creation_rounded,
            color: Colors.purple,
            onTap: _syutingIklan,
          ),
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

  Widget _buildSponsorCard(String brand, String desc, int minFollowers, int basePay, bool isDark) {
    final bool canSign = widget.character.followers >= minFollowers;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: canSign ? Colors.amber.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
          child: Icon(Icons.star, color: canSign ? Colors.amber : Colors.grey, size: 20),
        ),
        title: Text(brand, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text('$desc\nMin. $minFollowers followers', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canSign ? Colors.amber.shade800 : Colors.grey,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _tandaTanganSponsor(brand, basePay, minFollowers),
          child: const Text('Kontrak', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
