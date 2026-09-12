// lib/store_page/fitur_premium/karir_spesial/esports/esports_store.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'pro_player/pro_player_store.dart';
import 'talent/talent_store.dart';
import 'brand_ambassador/brand_ambassador_store.dart';

class EsportsStorePage extends StatelessWidget {
  const EsportsStorePage({super.key});

  void _simulatePurchase(BuildContext context, String itemName, VoidCallback onPurchased) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _PurchaseSimulationDialog(itemName: itemName);
      },
    ).then((success) {
      if (success == true) {
        onPurchased();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Berhasil membeli akses: $itemName!'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Sports 🎮',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ValueListenableBuilder<bool>(
          valueListenable: GlobalSettings.isEsportsProPlayerUnlocked,
          builder: (context, isProUnlocked, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isEsportsTalentUnlocked,
              builder: (context, isTalentUnlocked, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.isEsportsBAUnlocked,
                  builder: (context, isBAUnlocked, _) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildCategoryTile(
                          context: context,
                          icon: Icons.sports_esports,
                          iconBgColor: Colors.teal.shade100,
                          iconColor: Colors.teal.shade800,
                          title: 'Pro Player E-Sports',
                          subtitle: 'Bertanding di turnamen dan liga profesional kelas dunia',
                          price: 'Rp 199.000',
                          isUnlocked: isProUnlocked,
                          onActiveTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ProPlayerStorePage()),
                            );
                          },
                          onTapPrice: () {
                            _simulatePurchase(context, 'Pro Player E-Sports', () {
                              GlobalSettings.isEsportsProPlayerUnlocked.value = true;
                            });
                          },
                        ),
                        _buildCategoryTile(
                          context: context,
                          icon: Icons.mic_external_on,
                          iconBgColor: Colors.purple.shade100,
                          iconColor: Colors.purple.shade800,
                          title: 'Talent & Caster E-Sports',
                          subtitle: 'Kreator konten, caster turnamen, dan talent acara esports',
                          price: 'Rp 119.000',
                          isUnlocked: isTalentUnlocked,
                          onActiveTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TalentStorePage()),
                            );
                          },
                          onTapPrice: () {
                            _simulatePurchase(context, 'Talent & Caster E-Sports', () {
                              GlobalSettings.isEsportsTalentUnlocked.value = true;
                            });
                          },
                        ),
                        _buildCategoryTile(
                          context: context,
                          icon: Icons.stars_rounded,
                          iconBgColor: Colors.amber.shade100,
                          iconColor: Colors.amber.shade800,
                          title: 'Brand Ambassador (BA)',
                          subtitle: 'Wajah utama representasi tim & endorsement brand papan atas',
                          price: 'Rp 159.000',
                          isUnlocked: isBAUnlocked,
                          onActiveTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const BrandAmbassadorStorePage()),
                            );
                          },
                          onTapPrice: () {
                            _simulatePurchase(context, 'Brand Ambassador E-Sports', () {
                              GlobalSettings.isEsportsBAUnlocked.value = true;
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryTile({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String price,
    required bool isUnlocked,
    required VoidCallback onActiveTap,
    required VoidCallback onTapPrice,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ),
        trailing: isUnlocked
            ? InkWell(
                onTap: onActiveTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.green.shade900.withValues(alpha: 0.5) : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.green.shade600 : Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Aktif',
                        style: TextStyle(
                          color: isDark ? Colors.greenAccent : Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16, color: isDark ? Colors.greenAccent : Colors.green.shade700),
                    ],
                  ),
                ),
              )
            : InkWell(
                onTap: onTapPrice,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
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
        onTap: isUnlocked ? onActiveTap : onTapPrice,
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
    return Dialog(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_step == 0) ...[
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A5A32))),
              const SizedBox(height: 20),
              Text('Menghubungkan ke App Store...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 8),
              Text('Memproses pembelian "${widget.itemName}"', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 12), textAlign: TextAlign.center),
            ] else ...[
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text('Pembayaran Berhasil!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 8),
              Text('Akses karir "${widget.itemName}" telah aktif.', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8A5A32), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(120, 44)),
                child: const Text('Mantap'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
