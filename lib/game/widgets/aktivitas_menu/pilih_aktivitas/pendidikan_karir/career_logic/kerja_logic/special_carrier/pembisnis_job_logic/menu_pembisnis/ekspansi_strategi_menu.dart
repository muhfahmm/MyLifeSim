// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/menu_pembisnis/ekspansi_strategi_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class EkspansiStrategiMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const EkspansiStrategiMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<EkspansiStrategiMenuPage> createState() => _EkspansiStrategiMenuPageState();
}

class _EkspansiStrategiMenuPageState extends State<EkspansiStrategiMenuPage> {
  String _formatCurrency(int amount) => CurrencySettings.format(amount.toDouble());

  int get _businessValuation => (widget.character.businessModal * 2) + (widget.character.businessAnnualProfit * 5);

  void _bukaCabang(String locationType, int cost, double profitMultiplier) {
    if (widget.character.money < cost) {
      _showMessageDialog('Dana Tidak Cukup 💸', 'Kamu membutuhkan ${_formatCurrency(cost)} untuk membuka cabang baru.');
      return;
    }

    setState(() {
      widget.character.money -= cost;
      widget.character.businessBranchCount += 1;
      widget.character.businessModal += (cost * 0.7).round();
      final int profitBoost = (widget.character.businessAnnualProfit * profitMultiplier).round();
      widget.character.businessAnnualProfit += profitBoost;
    });
    widget.onRefresh();

    _showMessageDialog('Cabang Baru Resmi Dibuka! 🏢', 'Selamat! Cabang baru di $locationType telah beroperasi! Profit tahunan melonjak +${(profitMultiplier * 100).toInt()}%.');
  }

  void _biayaiRiset(int cost, double profitMultiplier) {
    if (widget.character.money < cost) {
      _showMessageDialog('Dana Tidak Cukup 💸', 'Dibutuhkan ${_formatCurrency(cost)} untuk proyek R&D ini.');
      return;
    }

    setState(() {
      widget.character.money -= cost;
      widget.character.businessResearchLevel += 1;
      final int profitBoost = (widget.character.businessAnnualProfit * profitMultiplier).round();
      widget.character.businessAnnualProfit += profitBoost;
    });
    widget.onRefresh();

    _showMessageDialog('Inovasi Berhasil! 🔬', 'Riset produk baru berhasil diselesaikan! Profit tahunan bertambah +${(profitMultiplier * 100).toInt()}%.');
  }

  void _akuisisiKompetitor(int cost) {
    if (widget.character.money < cost) {
      _showMessageDialog('Dana Tidak Cukup 💸', 'Dibutuhkan ${_formatCurrency(cost)} untuk proses akuisisi kompetitor.');
      return;
    }

    setState(() {
      widget.character.money -= cost;
      widget.character.businessModal += cost;
      final int profitBoost = (widget.character.businessAnnualProfit * 0.50).round();
      widget.character.businessAnnualProfit += profitBoost;
    });
    widget.onRefresh();

    _showMessageDialog('Akuisisi Berhasil! ⚔️', 'Perusahaan pesaing telah resmi diakuisisi! Profit tahunan bertambah +50%.');
  }

  void _goPublicIPO() {
    final int valuation = _businessValuation;
    if (valuation < 500000) {
      _showMessageDialog('Valuasi Belum Cukup 📊', 'Syarat IPO adalah Valuasi Perusahaan minimal ${_formatCurrency(500000)}. Saat ini valuasi usahamu adalah ${_formatCurrency(valuation)}.');
      return;
    }

    const int ipoBonusCash = 350000;
    setState(() {
      widget.character.money += ipoBonusCash;
      widget.character.businessName = '${widget.character.businessName ?? "Usaha"} Tbk.';
    });
    widget.onRefresh();

    _showMessageDialog('RESMI IPO DI BURSA EFEK! 🔔', 'Selamat! Perusahaanmu kini resmi menjadi perseroan terbuka (Tbk.)! Kamu menerima dana segar dari investor publik sebesar ${_formatCurrency(ipoBonusCash)}!');
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
        title: const Text('Ekspansi & Strategi 📈', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Summary Ekspansi
          Card(
            elevation: 2,
            color: isDark ? Colors.grey.shade800 : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.character.businessName ?? 'Nama Usaha',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildExpTile('Cabang Usaha 🏢', '${widget.character.businessBranchCount} Cabang', Colors.purple, isDark),
                      _buildExpTile('Level Riset 🔬', 'Level ${widget.character.businessResearchLevel}', Colors.blue, isDark),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildExpTile('Estimasi Valuasi 📊', _formatCurrency(_businessValuation), Colors.green, isDark),
                      _buildExpTile('Profit/Thn 💰', _formatCurrency(widget.character.businessAnnualProfit), Colors.amber.shade800, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 1: Pembukaan Cabang Baru
          _buildSectionHeader('Ekspansi Cabang Baru 🏢', isDark),
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
                  leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.store, color: Colors.white, size: 20)),
                  title: const Text('Buka Cabang Kota Lain 🏢', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(35000)} • Profit +40%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                    onPressed: () => _bukaCabang('Kota Lain', 35000, 0.40),
                    child: const Text('Buka'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.public, color: Colors.white, size: 20)),
                  title: const Text('Buka Cabang Luar Negeri 🌐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(180000)} • Profit +80%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                    onPressed: () => _bukaCabang('Luar Negeri', 180000, 0.80),
                    child: const Text('Ekspansi'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 2: Riset & Inovasi (R&D)
          _buildSectionHeader('Riset & Pengembangan (R&D) 🔬', isDark),
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
                  leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.science, color: Colors.white, size: 20)),
                  title: const Text('Inovasi Produk Baru 🧪', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(15000)} • Profit +20%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: () => _biayaiRiset(15000, 0.20),
                    child: const Text('Riset'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.deepOrange, child: Icon(Icons.precision_manufacturing, color: Colors.white, size: 20)),
                  title: const Text('Akuisisi Perusahaan Pesaing ⚔️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya: ${_formatCurrency(90000)} • Profit +50%'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                    onPressed: () => _akuisisiKompetitor(90000),
                    child: const Text('Akuisisi'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 3: Go Public (IPO)
          _buildSectionHeader('Bursa Saham & IPO 🔔', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.notifications_active, color: Colors.white, size: 20)),
              title: const Text('Initial Public Offering (IPO) 🔔', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text('Syarat: Valuasi > ${_formatCurrency(500000)} • Suntikan Dana +${_formatCurrency(350000)}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.character.businessName?.contains('Tbk') ?? false ? Colors.grey : Colors.amber.shade800,
                  foregroundColor: Colors.white,
                ),
                onPressed: (widget.character.businessName?.contains('Tbk') ?? false) ? null : _goPublicIPO,
                child: Text((widget.character.businessName?.contains('Tbk') ?? false) ? 'Tbk (Lulus)' : 'Go Public'),
              ),
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

  Widget _buildExpTile(String label, String value, Color color, bool isDark) {
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
