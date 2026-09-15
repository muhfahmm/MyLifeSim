// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/aktivitas_peran/korporasi_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../rekan_bisnis/rekan_bisnis_page.dart';
import '../menu_pembisnis/manajemen_operasional_menu.dart';
import '../menu_pembisnis/manajemen_keuangan_menu.dart';
import '../menu_pembisnis/ekspansi_strategi_menu.dart';
import '../menu_pembisnis/buat_usaha_menu.dart';

class KorporasiPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KorporasiPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<KorporasiPage> createState() => _KorporasiPageState();
}

class _KorporasiPageState extends State<KorporasiPage> {
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

  void _rapatDireksi() {
    final r = Random();
    final intelGain = 3 + r.nextInt(4);
    final discGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Rapat Direksi & Dewan Komisaris 💼',
      'Kamu memimpin rapat strategis korporasi bersama dewan direksi dan investor eksekutif!\n\n'
      '• Kecerdasan Eksekutif: +$intelGain%\n'
      '• Kedisiplinan Korporat: +$discGain%',
    );
  }

  void _pitchingInvestor() {
    final r = Random();
    final profitBoost = (character.businessAnnualProfit * 0.12).round() + 1500;
    character.businessAnnualProfit += profitBoost;
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Investor Pitching & VC Funding 🚀',
      'Kamu berhasil melakukan presentasi proyek inovasi kepada konsorsium investor global!\n\n'
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
    final String businessTitle = character.businessName ?? 'Usaha Besar (Korporasi)';

    return Scaffold(
      appBar: AppBar(
        title: Text(businessTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple.shade800,
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
          // KARTU DASHBOARD KORPORASI 🚀
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
                          color: Colors.purple.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.rocket_launch_rounded, size: 36, color: Colors.purple),
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
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple),
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

          // AKTIVITAS CEO KORPORASI
          _buildSectionTitle('Aktivitas Pendiri & CEO Korporasi 🚀', isDark),
          _buildActionCard(
            context: context,
            title: 'Rapat Direksi & Dewan Komisaris',
            desc: 'Pimpin penentuan target kuartalan dan eksekusi manajerial',
            icon: Icons.business_center,
            color: Colors.purple,
            onTap: _rapatDireksi,
          ),
          _buildActionCard(
            context: context,
            title: 'Investor Pitching & Venture Capital',
            desc: 'Presentasikan inovasi teknologi ke konsorsium investor dunia',
            icon: Icons.monetization_on,
            color: Colors.amber.shade800,
            onTap: _pitchingInvestor,
          ),
          _buildActionCard(
            context: context,
            title: 'Jajaran Direksi & Karyawan Staf',
            desc: 'Interaksi langsung ke jajaran direksi & staf (User sebagai Pemilik Utama)',
            icon: Icons.badge,
            color: Colors.blue,
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

          // STRATEGI KORPORASI
          _buildSectionTitle('Manajemen & Strategi Usaha 📊', isDark),
          _buildActionCard(
            context: context,
            title: 'Ekspansi & Strategi (IPO / R&D) 📈',
            desc: 'Riset produk baru, akuisisi pesaing, dan peluncuran IPO',
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
            title: 'Manajemen Keuangan 💰',
            desc: 'Laporan laba rugi, dividen pemegang saham, dan asuransi',
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
            title: 'Manajemen Operasional ⚙️',
            desc: 'Kelola tim karyawan, standardisasi, dan kampanye iklan TV/Billboard',
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
            title: 'Buat Usaha Baru / Tambah Ide',
            desc: 'Mulai ide bisnis korporasi lain',
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
            title: 'Bubarkan Usaha & Likuidasi ⚠️',
            desc: 'Tutup bisnis ini dan cairkan aset (70% modal)',
            icon: Icons.delete_forever,
            color: Colors.red,
            titleFontSize: 12,
            subtitleFontSize: 10.5,
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
