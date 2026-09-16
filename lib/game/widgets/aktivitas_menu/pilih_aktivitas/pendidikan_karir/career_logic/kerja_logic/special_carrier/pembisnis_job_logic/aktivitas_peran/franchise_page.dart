// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/aktivitas_peran/franchise_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../rekan_bisnis/rekan_bisnis_page.dart';
import '../menu_pembisnis/manajemen_operasional_menu.dart';
import '../menu_pembisnis/manajemen_keuangan_menu.dart';
import '../menu_pembisnis/ekspansi_strategi_menu.dart';
import '../menu_pembisnis/buat_usaha_menu.dart';

class FranchisePage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const FranchisePage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<FranchisePage> createState() => _FranchisePageState();
}

class _FranchisePageState extends State<FranchisePage> {
  Character get character => widget.character;

  void _showAlert(String title, String msg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
        content: SizedBox(
          width: double.infinity,
          child: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _inspeksiCabang() {
    final r = Random();
    final intelGain = 2 + r.nextInt(4);
    final discGain = 2 + r.nextInt(4);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Inspeksi Standar Cabang & Sop 🏬',
      'Kamu meninjau langsung operasional outlet franchise dan memastikan standar layanan terbaik!\n\n'
      '• Kecerdasan Manajemen: +$intelGain%\n'
      '• Kedisiplinan Karyawan: +$discGain%',
    );
  }

  void _meetingMitra() {
    final profitBoost = (character.businessAnnualProfit * 0.08).round() + 250;
    character.businessAnnualProfit += profitBoost;
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Meeting Mitra & Franchisee 🤝',
      'Kamu memimpin konsolidasi outlet dan menyetujui kemitraan baru!\n\n'
      '• Estimasi Profit Tahunan: +${CurrencySettings.format(profitBoost.toDouble())}',
    );
  }

  void _bubarkanUsahaDialog() {
    final int returnCash = (character.businessModal * 0.7).round();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Bubarkan Usaha & Likuidasi ⚠️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)),
        content: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apakah kamu yakin ingin membubarkan "${character.businessName}"?', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Text('• Hasil likuidasi aset sebesar ${CurrencySettings.format(returnCash.toDouble())} (70% modal) akan dicairkan ke dompetmu.\n• Perusahaan ini akan ditutup secara permanen dan seluruh operasional dihentikan.', style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(fontSize: 12))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              final String oldName = character.businessName ?? 'Perusahaan';
              Navigator.pop(ctx);
              character.dissolveCurrentBusiness();
              widget.onRefresh();

              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Usaha Dibubarkan 💥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  content: Text(
                    'Usaha "$oldName" telah resmi dibubarkan! Hasil likuidasi sebesar ${CurrencySettings.format(returnCash.toDouble())} telah masuk ke saldo dompetmu.',
                    style: const TextStyle(fontSize: 12),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(c);
                        Navigator.pop(context);
                      },
                      child: const Text('OK', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Ya, Likuidasi & Bubarkan', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String businessTitle = character.businessName ?? 'Usaha Menengah (Franchise)';

    return Scaffold(
      appBar: AppBar(
        title: Text(businessTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Tim Karyawan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RekanBisnisPage(character: character, onRefresh: widget.onRefresh),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // KARTU DASHBOARD FRANCHISE 🏬
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.apartment_rounded, size: 36, color: Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              businessTitle,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Pemilik & Direktur Utama: ${character.name} 👑',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange),
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
                      _buildInfoTile('Modal Usaha', CurrencySettings.format(character.businessModal.toDouble()), Colors.blue, isDark),
                      _buildInfoTile('Profit/Tahun', CurrencySettings.format(character.businessAnnualProfit.toDouble()), Colors.green, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // AKTIVITAS DIREKTUR FRANCHISE
          _buildSectionTitle('Aktivitas Direktur Franchise 🏬', isDark),
          _buildActionCard(
            context: context,
            title: 'Inspeksi Standar Cabang & SOP',
            desc: 'Pastikan kualitas makanan/jasa di seluruh cabang terjaga',
            icon: Icons.assignment_turned_in,
            color: Colors.orange,
            onTap: _inspeksiCabang,
          ),
          _buildActionCard(
            context: context,
            title: 'Meeting Mitra & Franchisee',
            desc: 'Perluas jaringan kemitraan franchise dan royalti',
            icon: Icons.handshake,
            color: Colors.blue,
            onTap: _meetingMitra,
          ),
          _buildActionCard(
            context: context,
            title: 'Kelola Manajer & Tim Karyawan',
            desc: 'Instruksi langsung ke bawahan (User sebagai Owner/CEO)',
            icon: Icons.badge,
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RekanBisnisPage(character: character, onRefresh: widget.onRefresh),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // MANAJEMEN & EKPANSI
          _buildSectionTitle('Manajemen & Strategi Usaha 📊', isDark),
          _buildActionCard(
            context: context,
            title: 'Manajemen Operasional ⚙️',
            desc: 'Rekrut karyawan, upgrade kualitas, dan kampanye iklan',
            icon: Icons.settings,
            color: Colors.deepOrange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManajemenOperasionalMenuPage(character: character, onRefresh: widget.onRefresh),
                ),
              );
            },
          ),
          _buildActionCard(
            context: context,
            title: 'Manajemen Keuangan 💰',
            desc: 'Laporan laba rugi, dividen, dan kredit bank',
            icon: Icons.account_balance_wallet,
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManajemenKeuanganMenuPage(character: character, onRefresh: widget.onRefresh),
                ),
              );
            },
          ),
          _buildActionCard(
            context: context,
            title: 'Ekspansi & Strategi 📈',
            desc: 'Buka cabang luar negeri, riset R&D, dan IPO',
            icon: Icons.trending_up,
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EkspansiStrategiMenuPage(character: character, onRefresh: widget.onRefresh),
                ),
              );
            },
          ),
          _buildActionCard(
            context: context,
            title: 'Buat Usaha Baru / Tambah Ide',
            desc: 'Mulai ide bisnis lain',
            icon: Icons.add_business,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BuatUsahaMenuPage(character: character, onRefresh: widget.onRefresh),
                ),
              );
            },
          ),
          _buildActionCard(
            context: context,
            title: 'Resign / Keluar Kerja',
            desc: 'Tutup bisnis ini & cairkan hasil likuidasi aset ke dompet pribadi',
            icon: Icons.exit_to_app,
            color: Colors.red,
            titleFontSize: 14,
            subtitleFontSize: 12,
            onTap: _bubarkanUsahaDialog,
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

  Widget _buildInfoTile(String label, String val, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double titleFontSize = 14,
    double subtitleFontSize = 12,
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
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: subtitleFontSize, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
