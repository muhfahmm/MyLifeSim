// lib/game/widgets/assets_menu/finansial/uang_tunai/uang_tunai.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// WIDGET ITEM UANG TUNAI (di dashboard)
// ============================================================
class UangTunaiItem extends StatelessWidget {
  final Character character;

  const UangTunaiItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 12;

    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Uang Tunai', 12);
          return;
        }
        Navigator.pop(context); // tutup dashboard
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UangTunaiPage(character: character),
          ),
        );
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
              'Rp ${formatRupiah(character.money)}',
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
// HALAMAN UANG TUNAI
// ============================================================
class UangTunaiPage extends StatefulWidget {
  final Character character;

  const UangTunaiPage({super.key, required this.character});

  @override
  State<UangTunaiPage> createState() => _UangTunaiPageState();
}

class _UangTunaiPageState extends State<UangTunaiPage> {
  // Data transaksi (simulasi)
  List<Map<String, dynamic>> transactions = [];
  // Data pinjaman
  List<Map<String, dynamic>> loans = [];

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
      // Batasi jumlah transaksi agar tidak terlalu banyak
      if (transactions.length > 50) transactions.removeLast();
    });
  }

  // ========== TRANSFER & PEMBAYARAN ==========
  void _showTransferDialog() {
    final formKey = GlobalKey<FormState>();
    String? tujuan;
    int? nominal;
    TextEditingController nominalCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transfer / Pembayaran'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tujuan'),
                items: [
                  'Bayar Listrik',
                  'Bayar Air',
                  'Bayar Internet',
                  'Transfer ke Teman',
                  'Transfer ke Keluarga',
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => tujuan = val,
                validator: (val) => val == null ? 'Pilih tujuan' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nominalCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                decoration: const InputDecoration(labelText: 'Nominal (Rp)'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Masukkan nominal';
                  if (parseRupiah(val) <= 0) return 'Masukkan angka';
                  return null;
                },
                onSaved: (val) => nominal = parseRupiah(val ?? ''),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                if (nominal! <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nominal harus lebih dari 0')),
                  );
                  return;
                }
                if (widget.character.money < nominal!) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saldo tidak cukup!')),
                  );
                  return;
                }
                // Proses transfer
                setState(() {
                  widget.character.money -= nominal!;
                  _addTransaction(-nominal!, 'Transfer: $tujuan');
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Berhasil transfer Rp ${formatRupiah(nominal!)} untuk $tujuan')),
                );
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  // ========== PINJAMAN ==========
  void _showAjukanPinjamanDialog() {
    final formKey = GlobalKey<FormState>();
    int? jumlah;
    int? tenor; // bulan
    TextEditingController jumlahCtrl = TextEditingController();
    TextEditingController tenorCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajukan Pinjaman'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: jumlahCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                decoration: const InputDecoration(labelText: 'Jumlah Pinjaman (Rp)'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Masukkan jumlah';
                  if (parseRupiah(val) <= 0) return 'Masukkan angka';
                  return null;
                },
                onSaved: (val) => jumlah = parseRupiah(val ?? ''),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: tenorCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tenor'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Masukkan tenor';
                  if (int.tryParse(val) == null) return 'Masukkan angka';
                  return null;
                },
                onSaved: (val) => tenor = int.tryParse(val!),
              ),
              const SizedBox(height: 10),
              const Text('Bunga: 5% per tahun', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                if (jumlah! <= 0 || tenor! <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jumlah dan tenor harus lebih dari 0')),
                  );
                  return;
                }
                // Simulasi persetujuan (selalu disetujui)
                double bungaPerBulan = 0.05 / 12;
                double totalBunga = jumlah! * bungaPerBulan * tenor!;
                  double totalBayar = jumlah! + totalBunga;
                  double cicilanPerBulan = totalBayar / tenor!;

                setState(() {
                  widget.character.money += jumlah!;
                  loans.add({
                    'jumlah': jumlah,
                    'bunga': 5, // per tahun
                    'tenor': tenor,
                    'sisaCicilan': tenor,
                    'cicilanPerBulan': cicilanPerBulan.round(),
                  });
                  _addTransaction(jumlah!, 'Pinjaman diterima');
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pinjaman Rp ${formatRupiah(jumlah!)} disetujui!')),
                );
              }
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  void _bayarCicilan(int index) {
    final loan = loans[index];
    if (loan['sisaCicilan'] <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pinjaman sudah lunas')),
      );
      return;
    }
    int cicilan = loan['cicilanPerBulan'] as int;
    if (widget.character.money < cicilan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak cukup untuk membayar cicilan!')),
      );
      return;
    }
    setState(() {
      widget.character.money -= cicilan;
      loan['sisaCicilan'] = loan['sisaCicilan'] - 1;
      _addTransaction(-cicilan, 'Bayar cicilan pinjaman');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cicilan Rp ${formatRupiah(cicilan)} dibayar. Sisa ${loan['sisaCicilan']} kali lagi.')),
    );
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
                    'Rp ${formatRupiah(widget.character.money)}',
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
                        '${netChange >= 0 ? '+' : ''}Rp ${formatRupiah(netChange.abs())}',
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
            onTap: _showTransferDialog,
          ),
          const SizedBox(height: 12),

          // 3. PINJAMAN / HUTANG
          _buildMenuCard(
            icon: Icons.credit_card,
            title: 'Pinjaman / Hutang',
            subtitle: 'Kelola pinjaman aktif',
            color: Colors.orange,
            onTap: () => _showLoanManagementDialog(),
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

          // RIWAYAT TRANSAKSI (opsional)
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
                    '${amount >= 0 ? '+' : ''}Rp ${formatRupiah(amount)}',
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

  // ========== DIALOG MANAJEMEN PINJAMAN ==========
  void _showLoanManagementDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              title: const Text('Manajemen Pinjaman'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (loans.isEmpty)
                      const Text('Tidak ada pinjaman aktif.'),
                    ...loans.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var loan = entry.value;
                      int sisa = loan['sisaCicilan'] as int;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text('Pinjaman Rp ${formatRupiah(loan['jumlah'] as num)}'),
                          subtitle: Text(
                            'Tenor ${loan['tenor']}, sisa $sisa cicilan, cicilan Rp ${formatRupiah(loan['cicilanPerBulan'] as num)}',
                          ),
                          trailing: sisa > 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    _bayarCicilan(idx);
                                    setStateDialog(() {});
                                    Navigator.pop(ctx); // tutup dialog
                                    _showLoanManagementDialog(); // buka ulang
                                  },
                                  child: const Text('Bayar Cicilan'),
                                )
                              : const Icon(Icons.check_circle, color: Colors.green),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showAjukanPinjamanDialog();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajukan Pinjaman Baru'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
