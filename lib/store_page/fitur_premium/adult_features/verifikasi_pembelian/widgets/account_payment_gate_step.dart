import 'package:flutter/material.dart';

class AccountPaymentGateStep extends StatelessWidget {
  final String? selectedAccount;
  final bool isVerified;
  final ValueChanged<String?> onAccountSelected;

  const AccountPaymentGateStep({
    super.key,
    required this.selectedAccount,
    required this.isVerified,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E2B) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVerified ? Colors.teal : Colors.teal.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Akun & Payment Gate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.teal.shade100 : Colors.teal.shade900,
                      ),
                    ),
                    const Text(
                      'Mencegah anonimitas & pembayaran via pulsa.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Untuk perlindungan anak di bawah umur, transaksi 18+ mewajibkan autentikasi akun resmi (Google / Apple ID) dan Payment Gateway yang valid (Kartu Kredit/Debit/E-Wallet). Pembelian anonim via pulsa tidak diizinkan.',
            style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87, height: 1.35),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedAccount,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Pilih Akun Terhubung',
              labelStyle: TextStyle(fontSize: 12, color: isDark ? Colors.teal.shade200 : Colors.teal.shade800),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: const [
              DropdownMenuItem(
                value: 'google_account',
                child: Row(
                  children: [
                    Icon(Icons.g_mobiledata, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Google Play Account (Terverifikasi)',
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'apple_id',
                child: Row(
                  children: [
                    Icon(Icons.apple, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apple ID Account (Terverifikasi)',
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'verified_email',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Email ID Terverifikasi',
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: onAccountSelected,
          ),
        ],
      ),
    );
  }
}
