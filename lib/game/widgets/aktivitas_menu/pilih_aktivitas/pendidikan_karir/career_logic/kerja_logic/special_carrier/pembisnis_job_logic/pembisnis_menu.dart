// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/pembisnis_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'menu_pembisnis/buat_usaha_menu.dart';
import 'menu_pembisnis/manajemen_operasional_menu.dart';
import 'menu_pembisnis/manajemen_keuangan_menu.dart';
import 'menu_pembisnis/ekspansi_strategi_menu.dart';

class PembisnisMenuPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PembisnisMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _showLockedDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usaha Belum Didirikan 🔒'),
        content: Text(
          'Kamu belum memiliki usaha! Buat usaha terlebih dahulu di menu "Buat Usaha & Ide Bisnis" untuk mengakses $featureName.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasBusiness = character.hasBusiness;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembisnis 💼'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kartu Ringkasan Bisnis (Overview)
          Card(
            elevation: 2,
            color: isDark ? Colors.grey.shade800 : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.business_center_rounded, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasBusiness ? (character.businessName ?? 'Pemilik Usaha') : 'Modal Bisnis Kamu',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencySettings.format(character.money.toDouble()),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Menu 1: Buat Usaha & Ide Bisnis (Selalu Terbuka)
          _buildMenuTile(
            context: context,
            icon: Icons.add_business_rounded,
            color: Colors.blue,
            title: 'Buat Usaha & Ide Bisnis',
            subtitle: hasBusiness 
                ? 'Usaha aktif: ${character.businessName ?? "-"}'
                : 'Mulai dari warung kecil hingga startup teknologi',
            isLocked: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BuatUsahaMenuPage(character: character, onRefresh: onRefresh),
                ),
              );
            },
          ),

          // Menu 2: Manajemen Operasional (Hanya Terbuka Jika Sudah Punya Usaha)
          _buildMenuTile(
            context: context,
            icon: Icons.supervisor_account_rounded,
            color: Colors.orange,
            title: 'Manajemen Operasional',
            subtitle: hasBusiness
                ? 'Kelola karyawan, inventaris, dan pemasaran'
                : '🔒 Membutuhkan usaha aktif terlebih dahulu',
            isLocked: !hasBusiness,
            onTap: () {
              if (!hasBusiness) {
                _showLockedDialog(context, 'Manajemen Operasional');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ManajemenOperasionalMenuPage(character: character, onRefresh: onRefresh),
                  ),
                );
              }
            },
          ),

          // Menu 3: Manajemen Keuangan (Hanya Terbuka Jika Sudah Punya Usaha)
          _buildMenuTile(
            context: context,
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.green,
            title: 'Manajemen Keuangan',
            subtitle: hasBusiness
                ? 'Laporan laba rugi, pinjaman bank, dan investasi'
                : '🔒 Membutuhkan usaha aktif terlebih dahulu',
            isLocked: !hasBusiness,
            onTap: () {
              if (!hasBusiness) {
                _showLockedDialog(context, 'Manajemen Keuangan');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ManajemenKeuanganMenuPage(character: character, onRefresh: onRefresh),
                  ),
                );
              }
            },
          ),

          // Menu 4: Ekspansi & Strategi (Hanya Terbuka Jika Sudah Punya Usaha)
          _buildMenuTile(
            context: context,
            icon: Icons.trending_up_rounded,
            color: Colors.purple,
            title: 'Ekspansi & Strategi',
            subtitle: hasBusiness
                ? 'Ambil alih pesaing, buka cabang baru, dan IPO'
                : '🔒 Membutuhkan usaha aktif terlebih dahulu',
            isLocked: !hasBusiness,
            onTap: () {
              if (!hasBusiness) {
                _showLockedDialog(context, 'Ekspansi & Strategi');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EkspansiStrategiMenuPage(character: character, onRefresh: onRefresh),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk menu tile
  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color displayColor = isLocked ? Colors.grey : color;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: displayColor.withValues(alpha: 0.1),
          child: Icon(isLocked ? Icons.lock_outline_rounded : icon, color: displayColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isLocked
                ? (isDark ? Colors.white38 : Colors.grey.shade500)
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isLocked
                ? (isDark ? Colors.white30 : Colors.grey.shade400)
                : (isDark ? Colors.white70 : Colors.grey.shade600),
          ),
        ),
        trailing: Icon(
          isLocked ? Icons.lock_rounded : Icons.arrow_forward_ios,
          size: isLocked ? 18 : 14,
          color: isLocked
              ? (isDark ? Colors.white30 : Colors.grey.shade400)
              : (isDark ? Colors.white54 : Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}