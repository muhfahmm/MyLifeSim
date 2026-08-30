import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'ujian_lisensi_page.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/garasi_mobil/database_mobil.dart';

class LisensiMenuHelper {
  static void showLisensiMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 17) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 17 tahun untuk mengurus lisensi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LisensiPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class LisensiPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const LisensiPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<LisensiPage> createState() => _LisensiPageState();
}

class _LisensiPageState extends State<LisensiPage> {
  final List<Map<String, dynamic>> lisensi = [
    {'name': 'SIM A (Mobil) 🚗', 'cost': 500000, 'minAge': 17, 'desc': 'Surat Izin Mengemudi kendaraan roda empat'},
    {'name': 'SIM C (Motor) 🏍️', 'cost': 300000, 'minAge': 17, 'desc': 'Surat Izin Mengemudi kendaraan roda dua'},
    {'name': 'SIM B (Truk) 🚛', 'cost': 800000, 'minAge': 21, 'desc': 'SIM untuk kendaraan berat'},
    {'name': 'Paspor 🛂', 'cost': 700000, 'minAge': 17, 'desc': 'Dokumen perjalanan internasional'},
    {'name': 'Lisensi Pilot ✈️', 'cost': 50000000, 'minAge': 21, 'desc': 'Lisensi untuk menerbangkan pesawat'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urus Lisensi 📋', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: \$${_fmt(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: lisensi.length,
                itemBuilder: (_, i) {
                  final l = lisensi[i];
                  final String name = l['name'];
                  final int minAge = l['minAge'] as int;
                  final int cost = l['cost'] as int;
                  
                  final bool owned = widget.character.ownedLicenses.contains(name);
                  final bool isPilotLocked = name.contains('Pilot') && (widget.character.intelligence < 80 || widget.character.age < 21);
                  
                  Widget trailingWidget;
                  Color titleColor = Colors.black87;
                  Color subtitleColor = Colors.black54;
                  Color cardBg = Colors.white;

                  if (owned) {
                    trailingWidget = const Text(
                      'Sudah Dimiliki',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                    );
                    titleColor = Colors.green.shade800;
                    cardBg = Colors.green.shade50.withOpacity(0.3);
                  } else if (isPilotLocked) {
                    trailingWidget = const Icon(Icons.lock, size: 16, color: Colors.grey);
                    titleColor = Colors.grey;
                    subtitleColor = Colors.grey;
                    cardBg = Colors.grey.shade50;
                  } else {
                    trailingWidget = const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.brown);
                  }

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: owned ? Colors.green.shade200 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(name, style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: titleColor,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          isPilotLocked 
                              ? '${l['desc']}\nLisensi Terkunci 🔒 Butuh [Kecerdasan 80+] & Umur 21 thn.'
                              : '${l['desc']}\nBiaya: \$${_fmt(cost)} | Min. usia: $minAge thn',
                          style: TextStyle(color: subtitleColor),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: trailingWidget,
                      onTap: () {
                        // 1. Check if already owned
                        if (owned) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Lisensi Dimiliki ✅', style: TextStyle(fontWeight: FontWeight.bold)),
                              content: Text('Kamu sudah memiliki lisensi $name.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // 2. Check Pilot Lock
                        if (isPilotLocked) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Lisensi Terkunci 🔒', style: TextStyle(fontWeight: FontWeight.bold)),
                              content: const Text('Lisensi ini terkunci. Kamu membutuhkan [Kecerdasan 80+] dan Umur 21 tahun untuk membukanya.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // 3. Check Age
                        if (widget.character.age < minAge) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Belum Cukup Umur 🔞', style: TextStyle(fontWeight: FontWeight.bold)),
                              content: Text('Kamu belum cukup umur. Kamu baru berumur ${widget.character.age} tahun. Minimal $minAge tahun untuk $name.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // 4. Check Money
                        if (widget.character.money < cost) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Saldo Kurang 💸', style: TextStyle(fontWeight: FontWeight.bold)),
                              content: Text('Uang kamu tidak cukup! Harga lisensi \$${_fmt(cost)}, saldo kamu hanya \$${_fmt(widget.character.money)}.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // Proceed to Ujian Teori
                        Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UjianLisensiPage(
                              character: widget.character,
                              license: l,
                              onComplete: () {
                                setState(() {});
                                widget.onComplete();
                              },
                            ),
                          ),
                        ).then((passed) {
                          if (passed == true) {
                            _checkParentGiftOffer(context, l);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkParentGiftOffer(BuildContext context, Map<String, dynamic> license) {
    final String licenseName = license['name'];
    if (!licenseName.contains('SIM')) return;

    final random = Random();
    // 50% kesempatan ditawari mobil oleh orang tua
    if (random.nextInt(100) >= 50) return;

    String? parentName;
    String? parentRole;
    int parentWealth = 0;

    if (widget.character.fatherName != null && !widget.character.isFatherDeceased) {
      final w = widget.character.getFatherWealth();
      if (w > parentWealth) {
        parentWealth = w;
        parentName = widget.character.fatherName;
        parentRole = 'Ayah';
      }
    }
    if (widget.character.motherName != null && !widget.character.isMotherDeceased) {
      final w = widget.character.getMotherWealth();
      if (w > parentWealth) {
        parentWealth = w;
        parentName = widget.character.motherName;
        parentRole = 'Ibu';
      }
    }

    if (parentName == null || parentRole == null || parentWealth <= 0) return;

    // Filter mobil yang sesuai lisensi & harganya mampu dibeli orang tua
    List<Map<String, dynamic>> matchingCars = [];
    for (var car in mobilTersediaList) {
      final int price = (car['harga'] as num).toInt();
      if (price <= parentWealth) {
        final String typeLower = car['tipe'].toString().toLowerCase();
        if (licenseName.contains('SIM C')) {
          if (typeLower.contains('motor') || typeLower.contains('dua roda') || typeLower.contains('sport')) {
            matchingCars.add(car);
          }
        } else if (licenseName.contains('SIM B')) {
          if (typeLower.contains('truk') || typeLower.contains('heavy') || typeLower.contains('pickup')) {
            matchingCars.add(car);
          }
        } else if (licenseName.contains('SIM A')) {
          if (!typeLower.contains('truk') && !typeLower.contains('motor')) {
            matchingCars.add(car);
          }
        }
      }
    }

    if (matchingCars.isEmpty) return;

    final giftCar = matchingCars[random.nextInt(matchingCars.length)];
    final int carPrice = (giftCar['harga'] as num).toInt();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (giftCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.card_giftcard, color: Colors.pink, size: 28),
            const SizedBox(width: 8),
            Text('Hadiah dari $parentRole! 🎁', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Karena kamu baru saja mendapatkan $licenseName, $parentRole-mu ($parentName) menawarkan untuk membelikanmu kendaraan sebagai hadiah!\n\n'
          '🚗 Kendaraan: ${giftCar['nama']} (${giftCar['merek']})\n'
          '💰 Nilai: \$${_fmt(giftCar['harga'] as int)}\n\n'
          'Apakah kamu mau menerima hadiah ini?',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(giftCtx);
            },
            child: const Text('Tolak', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              widget.character.addCarToGarage(giftCar, widget.character.age);
              widget.character.setTargetWealth(parentName!, parentRole!, parentWealth - carPrice);
              widget.character.happiness = (widget.character.happiness + 30).clamp(0, 100);
              widget.character.inbox.add('🎁 Hadiah Kendaraan: Menerima ${giftCar['nama']} dari $parentRole ($parentName)! (+30% Kebahagiaan)');
              
              Navigator.pop(giftCtx);
              setState(() {});
              widget.onComplete();
            },
            child: const Text('Terima', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
