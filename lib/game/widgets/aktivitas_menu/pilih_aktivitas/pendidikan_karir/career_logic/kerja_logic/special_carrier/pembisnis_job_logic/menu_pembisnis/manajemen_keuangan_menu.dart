// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/menu_pembisnis/manajemen_keuangan_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class ManajemenKeuanganMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const ManajemenKeuanganMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<ManajemenKeuanganMenuPage> createState() => _ManajemenKeuanganMenuPageState();
}

class _ManajemenKeuanganMenuPageState extends State<ManajemenKeuanganMenuPage> {
  String _formatCurrency(int amount) => CurrencySettings.format(amount.toDouble());

  void _suntikModalDialog() {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Suntik Modal Usaha 📥', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saldo Uang Pribadi: ${_formatCurrency(widget.character.money)}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Modal (\$)',
                  hintText: 'Contoh: 5000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Setiap suntikan modal akan meningkatkan profit tahunan sekitar 15% dari nilai yang disuntikkan.', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            onPressed: () {
              final int inputAmount = int.tryParse(amountController.text) ?? 0;
              if (inputAmount <= 0) return;
              if (widget.character.money < inputAmount) {
                Navigator.pop(ctx);
                _showMessageDialog('Uang Tidak Cukup 💸', 'Saldo uang pribadi kamu tidak mencukupi.');
                return;
              }

              setState(() {
                widget.character.money -= inputAmount;
                widget.character.businessModal += inputAmount;
                final int profitBoost = (inputAmount * 0.15).round();
                widget.character.businessAnnualProfit += profitBoost;
              });
              widget.onRefresh();
              Navigator.pop(ctx);
              _showMessageDialog('Suntik Modal Sukses! 🎉', 'Berhasil menyuntikkan ${_formatCurrency(inputAmount)} ke modal usaha. Profit tahunan bertambah ${_formatCurrency((inputAmount * 0.15).round())}.');
            },
            child: const Text('Transfer Modal'),
          ),
        ],
      ),
    );
  }

  void _tarikLabaDialog() {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tarik Laba Usaha / Dividen 💸', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Modal Usaha: ${_formatCurrency(widget.character.businessModal)}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Penarikan (\$)',
                  hintText: 'Contoh: 2000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Penarikan dividen akan mengurangi modal usaha secara langsung.', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
            onPressed: () {
              final int inputAmount = int.tryParse(amountController.text) ?? 0;
              if (inputAmount <= 0) return;
              if (widget.character.businessModal < inputAmount) {
                Navigator.pop(ctx);
                _showMessageDialog('Modal Tidak Cukup ⚠️', 'Jumlah penarikan melebihi modal usaha yang tersedia.');
                return;
              }

              setState(() {
                widget.character.businessModal -= inputAmount;
                widget.character.money += inputAmount;
              });
              widget.onRefresh();
              Navigator.pop(ctx);
              _showMessageDialog('Penarikan Sukses! 💰', 'Berhasil menarik ${_formatCurrency(inputAmount)} dari modal usaha ke dompet pribadi.');
            },
            child: const Text('Tarik ke Dompet'),
          ),
        ],
      ),
    );
  }

  void _ajukanPinjamanBank(int amount) {
    setState(() {
      widget.character.businessBankLoan += amount;
      widget.character.money += amount;
      widget.character.businessModal += amount;
    });
    widget.onRefresh();
    _showMessageDialog('Pinjaman Diterima! 🏦', 'Pinjaman sebesar ${_formatCurrency(amount)} dari Bank telah cair dan masuk ke saldo modal usahamu!');
  }

  void _bayarPinjamanBank() {
    if (widget.character.businessBankLoan <= 0) {
      _showMessageDialog('Bebas Hutang ℹ️', 'Kamu tidak memiliki pinjaman bank aktif.');
      return;
    }
    if (widget.character.money < widget.character.businessBankLoan) {
      _showMessageDialog('Uang Tidak Cukup 💸', 'Saldo uang pribadi kamu belum cukup untuk melunasi seluruh pinjaman bank (${_formatCurrency(widget.character.businessBankLoan)}).');
      return;
    }

    final int totalPaid = widget.character.businessBankLoan;
    setState(() {
      widget.character.money -= totalPaid;
      widget.character.businessBankLoan = 0;
    });
    widget.onRefresh();
    _showMessageDialog('Lunas! 🎊', 'Pinjaman bank sebesar ${_formatCurrency(totalPaid)} telah lunas sepenuhnya!');
  }

  void _beliAsuransi() {
    if (widget.character.businessHasInsurance) {
      _showMessageDialog('Sudah Terlindungi 🛡️', 'Usahamu sudah terproteksi asuransi bisnis.');
      return;
    }
    const int insuranceCost = 10000;
    if (widget.character.money < insuranceCost) {
      _showMessageDialog('Uang Tidak Cukup 💸', 'Dibutuhkan ${_formatCurrency(insuranceCost)} untuk polis asuransi.');
      return;
    }

    setState(() {
      widget.character.money -= insuranceCost;
      widget.character.businessHasInsurance = true;
    });
    widget.onRefresh();
    _showMessageDialog('Asuransi Aktif! 🛡️', 'Usahamu kini dilindungi oleh Polis Asuransi Bisnis & Kerugian Kerusakan.');
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
        title: const Text('Manajemen Keuangan 💰', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Ringkasan Finansial Usaha
          Card(
            elevation: 2,
            color: isDark ? Colors.grey.shade800 : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Laporan Keuangan Bisnis 📊', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFinTile('Modal Bisnis 🏢', _formatCurrency(widget.character.businessModal), Colors.blue, isDark),
                      _buildFinTile('Profit / Tahun 📈', _formatCurrency(widget.character.businessAnnualProfit), Colors.green, isDark),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFinTile('Pinjaman Bank 🏦', _formatCurrency(widget.character.businessBankLoan), widget.character.businessBankLoan > 0 ? Colors.red : Colors.grey, isDark),
                      _buildFinTile('Status Asuransi 🛡️', widget.character.businessHasInsurance ? 'Terlindungi' : 'Belum Ada', widget.character.businessHasInsurance ? Colors.blue : Colors.grey, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 1: Alokasi Modal & Dividen
          _buildSectionHeader('Alokasi Modal & Dividen 💸', isDark),
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
                  leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.move_to_inbox, color: Colors.white, size: 20)),
                  title: const Text('Suntik Modal Usaha 📥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Tambah modal dari dompet pribadi ke bisnis'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: _suntikModalDialog,
                    child: const Text('Suntik'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.outbox, color: Colors.white, size: 20)),
                  title: const Text('Tarik Laba / Dividen 💸', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Tarik saldo usaha ke uang pribadi'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    onPressed: _tarikLabaDialog,
                    child: const Text('Tarik'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KELOMPOK 2: Kredit Bank & Asuransi
          _buildSectionHeader('Kredit Bank & Asuransi 🏦', isDark),
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
                  leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.account_balance, color: Colors.white, size: 20)),
                  title: const Text('Pinjaman Bank (\$25,000)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Cairkan kredit usaha dari bank nasional'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                    onPressed: () => _ajukanPinjamanBank(25000),
                    child: const Text('Pinjam'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.payment, color: Colors.white, size: 20)),
                  title: const Text('Pelunasan Pinjaman Bank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Sisa Hutang: ${_formatCurrency(widget.character.businessBankLoan)}'),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: widget.character.businessBankLoan > 0 ? _bayarPinjamanBank : null,
                    child: const Text('Pelunasan'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.shield, color: Colors.white, size: 20)),
                  title: const Text('Beli Asuransi Bisnis 🛡️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Biaya Polis: ${_formatCurrency(10000)}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.character.businessHasInsurance ? Colors.grey : Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.character.businessHasInsurance ? null : _beliAsuransi,
                    child: Text(widget.character.businessHasInsurance ? 'Aktif' : 'Beli'),
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

  Widget _buildFinTile(String label, String value, Color color, bool isDark) {
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
