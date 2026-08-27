// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/aksesoris_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'daftar_aksesoris/jam_tangan/jam_tangan_page.dart';
import 'daftar_aksesoris/kacamata_sunglasses/kacamata_sunglasses_page.dart';
import 'daftar_aksesoris/tas_branded/tas_branded_page.dart';
import 'daftar_aksesoris/gelang_kalung/gelang_kalung_page.dart';
import 'daftar_aksesoris/topi_kekinian/topi_kekinian_page.dart';

class AksesorisMenuHelper {
  static void showAksesorisMenu(BuildContext context, Character character, VoidCallback onComplete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TokoAksesorisPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class TokoAksesorisPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const TokoAksesorisPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<TokoAksesorisPage> createState() => _TokoAksesorisPageState();
}

class _TokoAksesorisPageState extends State<TokoAksesorisPage> {
  final List<Map<String, dynamic>> items = [
    {
      'id': 'jam_tangan',
      'name': 'Jam Tangan ⌚',
      'happiness': 8,
      'desc': 'Jam tangan stylish untuk penampilan'
    },
    {
      'id': 'kacamata_sunglasses',
      'name': 'Kacamata Sunglasses 🕶️',
      'happiness': 6,
      'desc': 'Kacamata hitam keren'
    },
    {
      'id': 'tas_branded',
      'name': 'Tas Branded 👜',
      'happiness': 15,
      'desc': 'Tas mewah bermerek terkenal'
    },
    {
      'id': 'gelang_kalung',
      'name': 'Gelang / Kalung 📿',
      'happiness': 5,
      'desc': 'Perhiasan sederhana namun elegan'
    },
    {
      'id': 'topi_kekinian',
      'name': 'Topi Kekinian 🎩',
      'happiness': 4,
      'desc': 'Topi yang sedang tren'
    },
  ];

  static String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Aksesoris 🛍️', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    'Saldo Anda: \$${_formatMoney(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item['desc'],
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      isThreeLine: false,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.pink,
                        size: 16,
                      ),
                      onTap: () {
                        final String itemId = item['id'] as String;
                        Widget nextPage;
                        switch (itemId) {
                          case 'jam_tangan':
                            nextPage = JamTanganBrandPage(character: widget.character, onComplete: widget.onComplete);
                            break;
                          case 'kacamata_sunglasses':
                            nextPage = KacamataSunglassesBrandPage(character: widget.character, onComplete: widget.onComplete);
                            break;
                          case 'tas_branded':
                            nextPage = TasBrandedBrandPage(character: widget.character, onComplete: widget.onComplete);
                            break;
                          case 'gelang_kalung':
                            nextPage = GelangKalungBrandPage(character: widget.character, onComplete: widget.onComplete);
                            break;
                          case 'topi_kekinian':
                            nextPage = TopiKekinianBrandPage(character: widget.character, onComplete: widget.onComplete);
                            break;
                          default:
                            return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => nextPage),
                        );
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
}