// lib/store_page/fitur_premium/karir_spesial/esports/talent/talent_store.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class TalentStorePage extends StatelessWidget {
  const TalentStorePage({super.key});

  void _simulatePurchase(BuildContext context, String itemName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _PurchaseSimulationDialog(itemName: itemName);
      },
    ).then((success) {
      if (success == true) {
        GlobalSettings.isEsportsTalentUnlocked.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Talent E-Sports 🎙️', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.purple.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.mic_external_on, size: 56, color: Colors.purple.shade800),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Talent & Caster E-Sports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Menjadi pemandu acara, caster turnamen, dan entertainer resmi organisasi E-Sports.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.isEsportsTalentUnlocked,
                      builder: (context, isUnlocked, _) {
                        if (isUnlocked) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.green.shade900.withValues(alpha: 0.5) : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isDark ? Colors.green.shade600 : Colors.green.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Akses Aktif',
                                  style: TextStyle(
                                    color: isDark ? Colors.greenAccent : Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.check_circle_rounded, size: 18, color: isDark ? Colors.greenAccent : Colors.green.shade700),
                              ],
                            ),
                          );
                        }

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: const Color(0xFF8A5A32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            _simulatePurchase(context, 'Talent E-Sports');
                          },
                          child: const Text(
                            'Rp 119.000',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PurchaseSimulationDialog extends StatefulWidget {
  final String itemName;
  const _PurchaseSimulationDialog({required this.itemName});

  @override
  State<_PurchaseSimulationDialog> createState() => __PurchaseSimulationDialogState();
}

class __PurchaseSimulationDialogState extends State<_PurchaseSimulationDialog> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _step = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogWidth = (screenWidth - 32).clamp(280.0, 400.0);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_step == 0) ...[
              const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A5A32)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Menghubungkan ke App Store...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Memproses pembelian "${widget.itemName}"',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
              const SizedBox(height: 14),
              Text(
                'Pembayaran Berhasil!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: isDark ? Colors.white : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Akses karir "${widget.itemName}" telah aktif.',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A5A32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  elevation: 2,
                ),
                child: const Text('Mantap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
