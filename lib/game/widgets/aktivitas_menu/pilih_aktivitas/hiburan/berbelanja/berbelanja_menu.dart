// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/berbelanja_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

import 'mall/pakaian_kasual/pakaian_kasual_page.dart';
import 'mall/sepatu_sneakers/sepatu_sneakers_page.dart';
import 'mall/tas_punggung/tas_punggung_page.dart';
import 'mall/gadget_elektronik/gadget_elektronik_page.dart';

import 'toko_online/buku_pengetahuan/buku_pengetahuan_page.dart';
import 'toko_online/alat_olahraga/alat_olahraga_page.dart';
import 'toko_online/dekorasi_rumah/dekorasi_rumah_page.dart';

class BerbelanjaMenuHelper {
  static void showBerbelanjaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk berbelanja sendiri.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BerbelanjaPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class BerbelanjaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const BerbelanjaPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<BerbelanjaPage> createState() => _BerbelanjaPageState();
}

class _BerbelanjaPageState extends State<BerbelanjaPage> {
  final List<Map<String, dynamic>> toko = [
    {
      'name': 'Mall / Pusat Perbelanjaan 🏬',
      'items': [
        {
          'id': 'pakaian_kasual',
          'name': 'Pakaian Kasual 👕',
          'cost': 300000,
          'page': (context, character, onComplete) => PakaianKasualPage(character: character, onComplete: onComplete),
        },
        {
          'id': 'sepatu_sneakers',
          'name': 'Sepatu Sneakers 👟',
          'cost': 600000,
          'page': (context, character, onComplete) => SepatuSneakersPage(character: character, onComplete: onComplete),
        },
        {
          'id': 'tas_punggung',
          'name': 'Tas Punggung 🎒',
          'cost': 400000,
          'page': (context, character, onComplete) => TasPunggungPage(character: character, onComplete: onComplete),
        },
        {
          'id': 'gadget_elektronik',
          'name': 'Gadget / Elektronik 📱',
          'cost': 3000000,
          'page': (context, character, onComplete) => GadgetElektronikPage(character: character, onComplete: onComplete),
        },
      ],
    },
    {
      'name': 'Toko Online 🛒',
      'items': [
        {
          'id': 'buku_pengetahuan',
          'name': 'Buku Pengetahuan 📚',
          'cost': 100000,
          'page': (context, character, onComplete) => BukuPengetahuanPage(character: character, onComplete: onComplete),
        },
        {
          'id': 'alat_olahraga',
          'name': 'Alat Olahraga 🏋️',
          'cost': 500000,
          'page': (context, character, onComplete) => AlatOlahragaPage(character: character, onComplete: onComplete),
        },
        {
          'id': 'dekorasi_rumah',
          'name': 'Dekorasi Rumah 🏠',
          'cost': 400000,
          'page': (context, character, onComplete) => DekorasiRumahPage(character: character, onComplete: onComplete),
        },
      ],
    },
  ];

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color containerBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF242424) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berbelanja 🛒', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: containerBg,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: ${_fmt(widget.character.money)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: toko.length,
                itemBuilder: (_, ti) {
                  final t = toko[ti];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        unselectedWidgetColor: isDark ? Colors.white70 : Colors.black54,
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: isDark ? Colors.orangeAccent : Colors.orange,
                        ),
                      ),
                      child: ExpansionTile(
                        iconColor: isDark ? Colors.orangeAccent : Colors.orange,
                        collapsedIconColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        leading: const Icon(Icons.store, color: Colors.orangeAccent),
                        title: Text(
                          t['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        children: (t['items'] as List<Map<String, dynamic>>).map((item) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            title: Text(
                              item['name'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Mulai dari ${_fmt(item['cost'] as int)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              final builder = item['page'] as Widget Function(BuildContext, Character, VoidCallback);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => builder(context, widget.character, widget.onComplete),
                                ),
                              ).then((_) => setState(() {}));
                            },
                          );
                        }).toList(),
                      ),
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
