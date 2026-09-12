import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/store_page/fitur_premium/karir_spesial/militer/darat/darat_store.dart';
import 'package:mylifesim/store_page/fitur_premium/karir_spesial/militer/laut/laut_store.dart';
import 'package:mylifesim/store_page/fitur_premium/karir_spesial/militer/udara/udara_store.dart';

class MiliterStorePage extends StatelessWidget {
  const MiliterStorePage({super.key});

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
          'Militer 🪖',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade800, Colors.green.shade900],
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
          valueListenable: GlobalSettings.isMiliterADUnlocked,
          builder: (context, isADUnlocked, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isMiliterALUnlocked,
              builder: (context, isALUnlocked, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.isMiliterAUUnlocked,
                  builder: (context, isAUUnlocked, _) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildBranchTile(
                          context: context,
                          icon: Icons.military_tech,
                          iconBgColor: Colors.green.shade100,
                          iconColor: Colors.green.shade800,
                          title: 'Tentara Angkatan Darat (TNI AD)',
                          subtitle: 'Menjaga pertahanan wilayah daratan dan pertahanan nasional',
                          price: 'Rp 99.000',
                          isUnlocked: isADUnlocked,
                          onActiveTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DaratStorePage()),
                            );
                          },
                          onTapPrice: () {
                            _simulatePurchase(context, 'Tentara Angkatan Darat (TNI AD)', () {
                              GlobalSettings.isMiliterADUnlocked.value = true;
                            });
                          },
                        ),
                        _buildBranchTile(
                          context: context,
                          icon: Icons.directions_boat_rounded,
                          iconBgColor: Colors.blue.shade100,
                          iconColor: Colors.blue.shade800,
                          title: 'Tentara Angkatan Laut (TNI AL)',
                          subtitle: 'Menjaga kedaulatan laut dan wilayah perairan kedaulatan negara',
                          price: 'Rp 149.000',
                          isUnlocked: isALUnlocked,
                          onActiveTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LautStorePage()),
                            );
                          },
                          onTapPrice: () {
                            _simulatePurchase(context, 'Tentara Angkatan Laut (TNI AL)', () {
                              GlobalSettings.isMiliterALUnlocked.value = true;
                            });
                          },
                        ),
                        _buildBranchTile(
                          context: context,
                          icon: Icons.flight_takeoff_rounded,
                          iconBgColor: Colors.lightBlue.shade100,
                          iconColor: Colors.lightBlue.shade800,
                          title: 'Tentara Angkatan Udara (TNI AU)',
                          subtitle: 'Mengamankan wilayah udara nasional dan armada skuad tempur',
                          price: 'Rp 189.000',
                          isUnlocked: isAUUnlocked,
                          onActiveTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const UdaraStorePage()),
                            );
                          },
                          onTapPrice: () {
                            _simulatePurchase(context, 'Tentara Angkatan Udara (TNI AU)', () {
                              GlobalSettings.isMiliterAUUnlocked.value = true;
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

  Widget _buildBranchTile({
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
