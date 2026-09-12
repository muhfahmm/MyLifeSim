// lib/store_page/fitur_premium/karir_spesial/karir_spesial_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'militer/militer_store.dart';
import 'esports/esports_store.dart';
import 'bundle_all_careers/bundle_all_careers_card.dart';

class KarirSpesialPage extends StatelessWidget {
  const KarirSpesialPage({super.key});

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
          'Karir Spesial 🌟',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
        child: ValueListenableBuilder<bool>(
          valueListenable: GlobalSettings.isPolitikusUnlocked,
          builder: (context, isPolitikusUnlocked, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isPebisnisUnlocked,
              builder: (context, isPebisnisUnlocked, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.isAtlitUnlocked,
                  builder: (context, isAtlitUnlocked, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.isAktorFilmUnlocked,
                      builder: (context, isAktorUnlocked, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: GlobalSettings.isAstronotUnlocked,
                          builder: (context, isAstronotUnlocked, _) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: GlobalSettings.isModelUnlocked,
                              builder: (context, isModelUnlocked, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable: GlobalSettings.isIdolUnlocked,
                                  builder: (context, isIdolUnlocked, _) {
                                    return ListView(
                                      padding: const EdgeInsets.all(16),
                                      children: [
                                        const BundleAllCareersCard(),
                                        Text(
                                          'Pilih Kategori Karir Spesial:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white70 : Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.military_tech,
                                          iconBgColor: Colors.green.shade100,
                                          iconColor: Colors.green.shade800,
                                          title: 'Militer',
                                          subtitle: 'Bergabung dengan karir militer pertahanan negara',
                                          targetPage: const MiliterStorePage(),
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.account_balance,
                                          iconBgColor: Colors.amber.shade100,
                                          iconColor: Colors.amber.shade800,
                                          title: 'Karier Politik 🏛️',
                                          subtitle: 'Jalur kekuasaan: Dewan, Walikota, Gubernur hingga Presiden',
                                          price: 'Rp 249.000',
                                          isUnlocked: isPolitikusUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Karier Politik', () {
                                              GlobalSettings.isPolitikusUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.business_center,
                                          iconBgColor: Colors.blue.shade100,
                                          iconColor: Colors.blue.shade800,
                                          title: 'Pembisnis 💼',
                                          subtitle: 'Mulai startup, kelola bisnis, dan bangun kekayaan impian',
                                          price: 'Rp 199.000',
                                          isUnlocked: isPebisnisUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Pembisnis', () {
                                              GlobalSettings.isPebisnisUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.sports_soccer,
                                          iconBgColor: Colors.orange.shade100,
                                          iconColor: Colors.deepOrange.shade800,
                                          title: 'Atlit Profesional ⚽',
                                          subtitle: 'Karir olahraga profesional & ikuti turnamen kelas dunia',
                                          price: 'Rp 149.000',
                                          isUnlocked: isAtlitUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Atlit Profesional', () {
                                              GlobalSettings.isAtlitUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.movie_creation,
                                          iconBgColor: Colors.purple.shade100,
                                          iconColor: Colors.purple.shade800,
                                          title: 'Aktor Film 🎬',
                                          subtitle: 'Bintang layar lebar, audisi perfilman, dan selebriti Hollywood',
                                          price: 'Rp 179.000',
                                          isUnlocked: isAktorUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Aktor Film', () {
                                              GlobalSettings.isAktorFilmUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.rocket_launch,
                                          iconBgColor: Colors.indigo.shade100,
                                          iconColor: Colors.indigo.shade800,
                                          title: 'Astronot 🚀',
                                          subtitle: 'Misi antariksa, latihan kosmonot, dan penjelajahan tata surya',
                                          price: 'Rp 259.000',
                                          isUnlocked: isAstronotUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Astronot', () {
                                              GlobalSettings.isAstronotUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.style,
                                          iconBgColor: Colors.pink.shade100,
                                          iconColor: Colors.pink.shade800,
                                          title: 'Model 💃',
                                          subtitle: 'Catwalk fashion show, majalah ternama, dan brand ambassador',
                                          price: 'Rp 99.000',
                                          isUnlocked: isModelUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Model', () {
                                              GlobalSettings.isModelUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.mic,
                                          iconBgColor: Colors.pinkAccent.shade100,
                                          iconColor: Colors.pinkAccent.shade400,
                                          title: 'Idol 🎤',
                                          subtitle: 'Latihan vokal & dance, konser panggung, dan agensi entertainment',
                                          price: 'Rp 129.000',
                                          isUnlocked: isIdolUnlocked,
                                          onActiveTap: () {},
                                          onTapPrice: () {
                                            _simulatePurchase(context, 'Idol', () {
                                              GlobalSettings.isIdolUnlocked.value = true;
                                            });
                                          },
                                        ),
                                        _buildCareerTile(
                                          context: context,
                                          icon: Icons.sports_esports,
                                          iconBgColor: Colors.teal.shade100,
                                          iconColor: Colors.teal.shade700,
                                          title: 'E-Sports 🎮',
                                          subtitle: 'Pro Player, Talent, dan Brand Ambassador tim esports terkenal',
                                          targetPage: const EsportsStorePage(),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
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

  Widget _buildCareerTile({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? targetPage,
    String? price,
    bool isUnlocked = false,
    VoidCallback? onActiveTap,
    VoidCallback? onTapPrice,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
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
            ),
          ),
        ),
        trailing: price != null
            ? (isUnlocked
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
                  ))
            : Icon(
                Icons.chevron_right,
                size: 20,
                color: isDark ? Colors.white54 : Colors.grey,
              ),
        onTap: () {
          if (price != null) {
            if (isUnlocked) {
              onActiveTap?.call();
            } else {
              onTapPrice?.call();
            }
          } else if (targetPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage),
            );
          }
        },
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

