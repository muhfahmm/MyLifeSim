// lib/game/widgets/assets_menu/finansial/uang_tunai/uang_tunai.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';
import 'package:flutter/services.dart';

// ============================================================
// PART FILES
// ============================================================
part 'menu/transfer.dart';
part 'menu/pinjaman.dart';

// ============================================================
// UTILITY FORMATTER (dari investasi.dart, kita reuse)
// ============================================================
class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll(',', '');
    if (raw.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      return oldValue;
    }
    final formatted = _formatThousands(parsed);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatThousands(int value) {
    final digits = value.toString().split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}

int parseRupiah(String value) {
  return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
}

String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(parts[i]);
  }
  final formatted = buffer.toString();
  return value < 0 ? '-$formatted' : formatted;
}

// ============================================================
// WIDGET ITEM UANG TUNAI (di dashboard)
// ============================================================
class UangTunaiItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;
  const UangTunaiItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 12;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Uang Tunai', 12);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UangTunaiPage(character: character),
          ),
        ).then((_) {
          if (onPop != null) onPop!();
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.green, size: 28),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Uang Tunai',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '\$${formatRupiah(character.money)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isUnlocked ? Icons.check_circle : Icons.lock,
              color: isUnlocked ? Colors.green : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey, size: 28),
            SizedBox(width: 8),
            Text('Fitur Terkunci', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur $feature akan terbuka saat karakter berusia $requiredAge tahun.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Usia saat ini: ${character.age} tahun',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HALAMAN UANG TUNAI (Root State)
// ============================================================
class UangTunaiPage extends StatefulWidget {
  final Character character;
  const UangTunaiPage({super.key, required this.character});

  @override
  State<UangTunaiPage> createState() => _UangTunaiPageState();
}

class _UangTunaiPageState extends State<UangTunaiPage> {
  // Data transaksi dinamis dari objek karakter
  List<Map<String, dynamic>> get transactions => widget.character.cashTransactions;
  // Data pinjaman dinamis dari objek karakter
  List<Map<String, dynamic>> get loans => widget.character.cashLoans;

  // Ringkasan perubahan saldo dari seluruh transaksi
  int get netChange {
    return transactions.fold<int>(0, (total, transaction) {
      return total + (transaction['amount'] as int);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _addTransaction(int amount, String desc) {
    setState(() {
      transactions.insert(0, {
        'amount': amount,
        'desc': desc,
      });
      if (transactions.length > 50) transactions.removeLast();
    });
  }

  // ========== METODE TRANSFER & PINJAMAN (akan dipanggil dari part) ==========
  // Kita panggil method dari part dengan melewatkan state dan context
  void showTransferDialog() {
    showTransferDialogInternal(context, this);
  }

  void showAjukanPinjamanDialog() {
    showAjukanPinjamanDialogInternal(context, this);
  }

  void bayarCicilan(int index) {
    bayarCicilanInternal(context, this, index);
  }

  void showLoanManagementDialog() {
    showLoanManagementDialogInternal(context, this);
  }

  // ========== UI ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uang Tunai'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. SALDO & RINGKASAN
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo Anda',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '\$${formatRupiah(widget.character.money)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        netChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: netChange >= 0 ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${netChange >= 0 ? '+' : ''}${formatRupiah(netChange.abs())}',
                        style: TextStyle(
                          fontSize: 14,
                          color: netChange >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total transaksi: ${transactions.length}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. TRANSFER & PEMBAYARAN
          _buildMenuCard(
            icon: Icons.swap_horiz,
            title: 'Transfer & Pembayaran',
            subtitle: 'Transfer ke rekening lain atau bayar tagihan',
            color: Colors.blue,
            onTap: showTransferDialog,
          ),
          const SizedBox(height: 12),

          // 3. PINJAMAN / HUTANG
          _buildMenuCard(
            icon: Icons.credit_card,
            title: 'Pinjaman / Hutang',
            subtitle: 'Kelola pinjaman aktif',
            color: Colors.orange,
            onTap: showLoanManagementDialog,
          ),
          const SizedBox(height: 12),

          // 4. TOMBOL INVESTASI
          _buildMenuCard(
            icon: Icons.trending_up,
            title: 'Investasi',
            subtitle: 'Kelola portofolio investasi Anda',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvestasiPage(character: widget.character),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // RIWAYAT TRANSAKSI
          const Text(
            'Riwayat Transaksi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (transactions.isEmpty)
            const Text('Belum ada transaksi')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 10 ? 10 : transactions.length,
              itemBuilder: (ctx, i) {
                final t = transactions[i];
                final amount = t['amount'] as int;
                return ListTile(
                  leading: Icon(
                    amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: amount >= 0 ? Colors.green : Colors.red,
                  ),
                  title: Text(t['desc']),
                  trailing: Text(
                    '\$${amount >= 0 ? '+' : ''}${formatRupiah(amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: amount >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}