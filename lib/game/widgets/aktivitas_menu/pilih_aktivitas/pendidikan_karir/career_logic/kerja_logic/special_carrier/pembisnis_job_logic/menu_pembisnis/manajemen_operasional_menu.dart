// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/menu_pembisnis/manajemen_operasional_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class ManajemenOperasionalMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const ManajemenOperasionalMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<ManajemenOperasionalMenuPage> createState() => _ManajemenOperasionalMenuPageState();
}

class _ManajemenOperasionalMenuPageState extends State<ManajemenOperasionalMenuPage> {
  String _formatCurrency(int amount) => CurrencySettings.format(amount.toDouble());

  String _getQualityLabel(int level) {
    switch (level) {
      case 2:
        return 'Premium ⭐';
      case 3:
        return 'Super Premium 💎';
      default:
        return 'Standard 📦';
    }
  }

  String _getMarketingLabel(int level) {
    switch (level) {
      case 1:
        return 'Brosur & Spanduk 📄';
      case 2:
        return 'Media Sosial 📱';
      case 3:
        return 'Endorse Influencer 🌟';
      case 4:
        return 'Iklan TV & Billboard 📺';
      default:
        return 'Tanpa Iklan 🚫';
    }
  }

  void _rekrutKaryawan(int count, int annualCost) {
    if (widget.character.money < annualCost) {
      _showMessageDialog('Dana Tidak Cukup 💸', 'Kamu membutuhkan ${_formatCurrency(annualCost)} untuk proses rekrutmen karyawan.');
      return;
    }

    setState(() {
      widget.character.money -= annualCost;
      widget.character.businessEmployees += count;
      final int profitBoost = (widget.character.businessAnnualProfit * 0.08).round();
      widget.character.businessAnnualProfit += profitBoost;
    });
    widget.onRefresh();

    _showMessageDialog('Karyawan Berhasil Direkrut 🎉', 'Kamu berhasil merekrut $count karyawan baru! Keuntungan tahunan meningkat sekitar 8%.');
  }

  void _phkKaryawan(int count) {
    if (widget.character.businessEmployees < count) {
      _showMessageDialog('Tidak Bisa PHK ⚠️', 'Jumlah karyawan saat ini (${widget.character.businessEmployees}) lebih sedikit dari $count.');
      return;
    }

    setState(() {
      widget.character.businessEmployees -= count;
      final int profitDecrease = (widget.character.businessAnnualProfit * 0.05).round();
      widget.character.businessAnnualProfit = (widget.character.businessAnnualProfit - profitDecrease).clamp(10, 999999999);
    });
    widget.onRefresh();

    _showMessageDialog('Pengurangan Karyawan 📉', '$count karyawan telah di-PHK untuk menghemat biaya operasional.');
  }

  void _upgradeKualitas(int targetLevel, int upgradeCost) {
    if (widget.character.businessQualityLevel >= targetLevel) {
      _showMessageDialog('Sudah Dicapai ℹ️', 'Kualitas usahamu sudah berada di tingkat ini atau lebih tinggi.');
      return;
    }
    if (widget.character.money < upgradeCost) {
      _showMessageDialog('Dana Tidak Cukup 💸', 'Dibutuhkan ${_formatCurrency(upgradeCost)} untuk upgrade kualitas.');
      return;
    }

    setState(() {
      widget.character.money -= upgradeCost;
      widget.character.businessQualityLevel = targetLevel;
      final int profitBoost = (widget.character.businessAnnualProfit * 0.25).round();
      widget.character.businessAnnualProfit += profitBoost;
    });
    widget.onRefresh();

    _showMessageDialog('Kualitas Meningkat! 🚀', 'Kualitas produk usahamu kini ${_getQualityLabel(targetLevel)}! Profit tahunan melonjak +25%.');
  }

  void _upgradeMarketing(int targetLevel, int cost, double profitMultiplier) {
    if (widget.character.businessMarketingLevel >= targetLevel) {
      _showMessageDialog('Sudah Aktif ℹ️', 'Kampanye pemasaran tingkat ini sudah aktif.');
      return;
    }
    if (widget.character.money < cost) {
      _showMessageDialog('Dana Tidak Cukup 💸', 'Dibutuhkan ${_formatCurrency(cost)} untuk kampanye ini.');
      return;
    }

    setState(() {
      widget.character.money -= cost;
      widget.character.businessMarketingLevel = targetLevel;
      final int profitBoost = (widget.character.businessAnnualProfit * profitMultiplier).round();
      widget.character.businessAnnualProfit += profitBoost;
    });
    widget.onRefresh();

    _showMessageDialog('Kampanye Diluncurkan! 📣', 'Pemasaran ${_getMarketingLabel(targetLevel)} diluncurkan! Profit tahunan melonjak +${(profitMultiplier * 100).toInt()}%.');
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Operasional ⚙️', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Status Operasional
          Card(
            elevation: 2,
            color: isDark ? Colors.grey.shade800 : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business, color: Colors.orange, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.character.businessName ?? 'Nama Usaha',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Lokasi: ${widget.character.businessLocation ?? "Indonesia"}',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatTile('Karyawan 👥', '${widget.character.businessEmployees} orang', Colors.blue, isDark),
                      _buildStatTile('Kualitas 📦', _getQualityLabel(widget.character.businessQualityLevel), Colors.green, isDark),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatTile('Pemasaran 📣', _getMarketingLabel(widget.character.businessMarketingLevel), Colors.purple, isDark),
                      _buildStatTile('Profit/Thn 💰', _formatCurrency(widget.character.businessAnnualProfit), Colors.amber.shade800, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 1: Sumber Daya Manusia (HRD)
          _buildSectionHeader('Sumber Daya Manusia (HRD) 👥', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.person_add, color: Colors.white, size: 20)),
                  title: const Text('Rekrut Karyawan Baru (+5 orang)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya rekrutmen: ${_formatCurrency(1000)} • Profit +8%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    onPressed: () => _rekrutKaryawan(5, 1000),
                    child: const Text('Rekrut'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.person_remove, color: Colors.white, size: 20)),
                  title: const Text('PHK Karyawan (-5 orang)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Hemat biaya operasional gaji'),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => _phkKaryawan(5),
                    child: const Text('PHK'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 2: Kontrol Kualitas & Produk
          _buildSectionHeader('Kontrol Kualitas & Produk 📦', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.verified, color: Colors.white, size: 20)),
                  title: const Text('Upgrade ke Premium Quality ⭐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(15000)} • Profit +25%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.character.businessQualityLevel >= 2 ? Colors.grey : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.character.businessQualityLevel >= 2 ? null : () => _upgradeKualitas(2, 15000),
                    child: Text(widget.character.businessQualityLevel >= 2 ? 'Aktif' : 'Upgrade'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.diamond, color: Colors.white, size: 20)),
                  title: const Text('Upgrade ke Super Premium 💎', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(75000)} • Profit +25%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.character.businessQualityLevel >= 3 ? Colors.grey : Colors.amber.shade700,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.character.businessQualityLevel >= 3 ? null : () => _upgradeKualitas(3, 75000),
                    child: Text(widget.character.businessQualityLevel >= 3 ? 'Aktif' : 'Upgrade'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 3: Pemasaran & Iklan
          _buildSectionHeader('Pemasaran & Iklan 📣', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.campaign, color: Colors.white, size: 20)),
                  title: const Text('Iklan Media Sosial 📱', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(2500)} • Profit +15%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.character.businessMarketingLevel >= 2 ? Colors.grey : Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.character.businessMarketingLevel >= 2 ? null : () => _upgradeMarketing(2, 2500, 0.15),
                    child: Text(widget.character.businessMarketingLevel >= 2 ? 'Aktif' : 'Pasang'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.star, color: Colors.white, size: 20)),
                  title: const Text('Endorsement Influencer 🌟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(12000)} • Profit +30%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.character.businessMarketingLevel >= 3 ? Colors.grey : Colors.pink,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.character.businessMarketingLevel >= 3 ? null : () => _upgradeMarketing(3, 12000, 0.30),
                    child: Text(widget.character.businessMarketingLevel >= 3 ? 'Aktif' : 'Endorse'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.deepOrange, child: Icon(Icons.tv, color: Colors.white, size: 20)),
                  title: const Text('Iklan TV & Billboard Nasional 📺', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(60000)} • Profit +60%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.character.businessMarketingLevel >= 4 ? Colors.grey : Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.character.businessMarketingLevel >= 4 ? null : () => _upgradeMarketing(4, 60000, 0.60),
                    child: Text(widget.character.businessMarketingLevel >= 4 ? 'Aktif' : 'Tayang'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
