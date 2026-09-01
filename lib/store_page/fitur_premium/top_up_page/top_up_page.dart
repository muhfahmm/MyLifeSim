// lib/store_page/fitur_premium/top_up_page/top_up_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class TopUpPage extends StatefulWidget {
  final Character? character;

  const TopUpPage({
    super.key,
    this.character,
  });

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  void _simulatePurchase(String itemName, int amount) {
    if (widget.character == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda belum memiliki karakter aktif!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.shopping_bag_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Konfirmasi Pembelian'),
          ],
        ),
        content: Text('Simulasi transaksi untuk "$itemName". Lanjutkan pembayaran?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.character!.money += amount;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🎉 Berhasil Top Up $itemName! +\$${_fmt(amount)} telah ditambahkan ke dompet.'),
                  backgroundColor: Colors.green.shade700,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Bayar Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _fmt(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Widget _buildTopUpItem({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String description,
    required String price,
    required int amount,
    required bool isDark,
    bool isPopular = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPopular
            ? Border.all(color: Colors.amber.shade600, width: 2)
            : Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconBgColor, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => _simulatePurchase(title, amount),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5C3C10), Color(0xFF8A5A32)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5C3C10).withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  'POPULER',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final character = widget.character;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Dana / Koin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5C3C10), Color(0xFF8A5A32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            // Status Keuangan Karakter
            if (character != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade700, Colors.amber.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade900.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 36),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo Dompet Karakter', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          '\$${_fmt(character.money)}',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'PILIH PAKET DANA / KOIN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : Colors.grey.shade700,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            _buildTopUpItem(
              icon: Icons.monetization_on_rounded,
              iconBgColor: Colors.amber.shade600,
              title: 'Tabungan Pemula',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Tambahkan ekstra +\$50,000 ke dompet karakter.',
              price: 'Rp 9.000',
              amount: 50000,
              isDark: isDark,
            ),
            _buildTopUpItem(
              icon: Icons.cases_rounded,
              iconBgColor: Colors.amber.shade800,
              title: 'Koper Jutawan',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Tambahkan ekstra +\$1,000,000 ke dompet karakter.',
              price: 'Rp 29.000',
              amount: 1000000,
              isDark: isDark,
              isPopular: true,
            ),
            _buildTopUpItem(
              icon: Icons.account_balance_rounded,
              iconBgColor: Colors.purple.shade700,
              title: 'Gudang Harta',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Tambahkan ekstra +\$50,000,000 ke dompet karakter.',
              price: 'Rp 99.000',
              amount: 50000000,
              isDark: isDark,
            ),
            _buildTopUpItem(
              icon: Icons.diamond_rounded,
              iconBgColor: Colors.blue.shade700,
              title: 'Brankas Sultan',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Tambahkan ekstra +\$500,000,000 ke dompet karakter.',
              price: 'Rp 199.000',
              amount: 500000000,
              isDark: isDark,
            ),
            _buildTopUpItem(
              icon: Icons.stars_rounded,
              iconBgColor: Colors.deepOrange.shade600,
              title: 'Triliuner Instan',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Tambahkan ekstra +\$10,000,000,000 ke dompet karakter.',
              price: 'Rp 499.000',
              amount: 10000000000,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
