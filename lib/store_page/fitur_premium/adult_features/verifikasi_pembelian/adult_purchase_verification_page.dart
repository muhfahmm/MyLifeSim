import 'package:flutter/material.dart';
import 'adult_verification_controller.dart';
import 'widgets/age_gate_step.dart';
import 'widgets/dob_verification_step.dart';
import 'widgets/account_payment_gate_step.dart';
import 'widgets/parental_pin_step.dart';

class AdultPurchaseVerificationPage extends StatefulWidget {
  final String itemName;
  final VoidCallback onVerificationSuccess;

  const AdultPurchaseVerificationPage({
    super.key,
    required this.itemName,
    required this.onVerificationSuccess,
  });

  @override
  State<AdultPurchaseVerificationPage> createState() => _AdultPurchaseVerificationPageState();
}

class _AdultPurchaseVerificationPageState extends State<AdultPurchaseVerificationPage> {
  final AdultVerificationController _controller = AdultVerificationController();

  void _submitVerification() {
    final error = _controller.getValidationError();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Verifikasi Lolos -> Kembali & jalankan callback sukses
    Navigator.pop(context);
    widget.onVerificationSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifikasi Pembelian 18+',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header Info Item
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PROSES VERIFIKASI PEMBELIAN',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.itemName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Banner Proteksi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade700, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Sistem Verifikasi Pembelian 18+: Mengamankan transaksi & mencegah akses anak di bawah umur.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lapis 1
                  AgeGateStep(
                    isConfirmed: _controller.model.isAgeGateConfirmed,
                    onChanged: (val) {
                      setState(() {
                        _controller.updateAgeGate(val);
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  // Lapis 2
                  DobVerificationStep(
                    birthDate: _controller.model.birthDate,
                    onDateSelected: (dob) {
                      setState(() {
                        _controller.updateBirthDate(dob);
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  // Lapis 3 & 4
                  AccountPaymentGateStep(
                    selectedAccount: _controller.model.selectedAccountType,
                    isVerified: _controller.model.isAccountVerified,
                    onAccountSelected: (acc) {
                      setState(() {
                        _controller.updateAccount(acc);
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  // Lapis 5
                  ParentalPinStep(
                    isPinEnabled: _controller.model.isParentalPinEnabled,
                    onTogglePin: (val) {
                      setState(() {
                        _controller.toggleParentalPin(val);
                      });
                    },
                    onPinEntered: (pin) {
                      _controller.updateParentalPin(pin);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submitVerification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Verifikasi & Lanjut',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
