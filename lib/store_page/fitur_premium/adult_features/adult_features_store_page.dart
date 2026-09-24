import 'dart:async';
import 'package:flutter/material.dart';
import 'bundle_adult/bundle_adult_card.dart';
import 'masturbasi/masturbasi_store_card.dart';
import 'make_love/make_love_store_card.dart';
import 'inses/inses_store_card.dart';
import 'guru_murid/guru_murid_store_card.dart';
import 'akses_18plus_page.dart';
import 'verifikasi_pembelian/adult_purchase_verification_page.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class AdultFeaturesStorePage extends StatelessWidget {
  const AdultFeaturesStorePage({super.key});

  void _simulatePurchase(BuildContext context, String itemName, VoidCallback onPurchased) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdultPurchaseVerificationPage(
          itemName: itemName,
          onVerificationSuccess: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return _PurchaseSimulationDialog(itemName: itemName);
              },
            ).then((success) {
              if (success == true) {
                onPurchased();
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: Listenable.merge([
        GlobalSettings.isPremium,
        GlobalSettings.isMasturbationUnlocked,
        GlobalSettings.isMakeLoveUnlocked,
        GlobalSettings.isIncestUnlocked,
        GlobalSettings.isTeacherStudentUnlocked,
      ]),
      builder: (context, _) {
        final bool isAnyAdultFeatureUnlocked = GlobalSettings.isPremium.value ||
            GlobalSettings.isMasturbationUnlocked.value ||
            GlobalSettings.isMakeLoveUnlocked.value ||
            GlobalSettings.isIncestUnlocked.value ||
            GlobalSettings.isTeacherStudentUnlocked.value;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Fitur Dewasa (18+) 🔞',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A148C), Color(0xFF8E24AA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              if (isAnyAdultFeatureUnlocked)
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: 'Pengaturan Preferensi 18+',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Akses18PlusPage()),
                    );
                  },
                ),
            ],
          ),
          body: Container(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Kartu Paket Bundle All
                BundleAdultCard(
                  onPurchase: (itemName, onPurchased) => _simulatePurchase(context, itemName, onPurchased),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
                  child: Text(
                    'PILIH KATEGORI FITUR 18+ INDIVIDUAL:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.purple.shade200 : Colors.purple.shade800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),

                // Kartu Fitur Terpisah
                MasturbasiStoreCard(
                  onPurchase: (itemName, onPurchased) => _simulatePurchase(context, itemName, onPurchased),
                ),
                MakeLoveStoreCard(
                  onPurchase: (itemName, onPurchased) => _simulatePurchase(context, itemName, onPurchased),
                ),
                InsesStoreCard(
                  onPurchase: (itemName, onPurchased) => _simulatePurchase(context, itemName, onPurchased),
                ),
                GuruMuridStoreCard(
                  onPurchase: (itemName, onPurchased) => _simulatePurchase(context, itemName, onPurchased),
                ),

                if (isAnyAdultFeatureUnlocked) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                    ),
                    color: isDark ? const Color(0xFF262626) : Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.tune, color: Colors.purpleAccent),
                      title: const Text('Buka Pengaturan Preferensi 18+'),
                      subtitle: const Text('Atur persentase ajakan NPC & sakelar privasi.'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Akses18PlusPage()),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PurchaseSimulationDialog extends StatefulWidget {
  final String itemName;
  const _PurchaseSimulationDialog({required this.itemName});

  @override
  State<_PurchaseSimulationDialog> createState() => _PurchaseSimulationDialogState();
}

class _PurchaseSimulationDialogState extends State<_PurchaseSimulationDialog> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _loading = false;
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
            if (_loading) ...[
              const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
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
                'Fitur "${widget.itemName}" telah aktif.',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
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
