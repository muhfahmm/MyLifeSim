// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/peliharaan_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class PeliharaanMenuHelper {
  static void showPeliharaanMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 10) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 10 tahun untuk memelihara hewan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PeliharaanPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class PeliharaanPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PeliharaanPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<PeliharaanPage> createState() => _PeliharaanPageState();
}

class _PeliharaanPageState extends State<PeliharaanPage> {
  final List<Map<String, dynamic>> hewan = [
    {'name': 'Anjing 🐕', 'cost': 2000000, 'happiness': 20, 'desc': 'Sahabat setia yang selalu ada'},
    {'name': 'Kucing 🐈', 'cost': 1500000, 'happiness': 15, 'desc': 'Hewan mandiri yang menggemaskan'},
    {'name': 'Burung 🦜', 'cost': 500000, 'happiness': 10, 'desc': 'Hewan cantik yang bisa bernyanyi'},
    {'name': 'Ikan 🐠', 'cost': 200000, 'happiness': 8, 'desc': 'Hewan tenang dan menenangkan'},
    {'name': 'Kelinci 🐇', 'cost': 800000, 'happiness': 12, 'desc': 'Hewan lucu dan jinak'},
    {'name': 'Reptil 🦎', 'cost': 3000000, 'happiness': 10, 'desc': 'Hewan unik untuk kolektor'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeAdopsi(BuildContext context, Map<String, dynamic> h) {
    setState(() {
      widget.character.money -= (h['cost'] as int);
      widget.character.happiness = (widget.character.happiness + (h['happiness'] as int)).clamp(0, 100);
    });
    final names = ['Buddy', 'Luna', 'Max', 'Bella', 'Charlie', 'Mochi'];
    final petName = names[Random().nextInt(names.length)];
    final msg = '🐾 Kamu mengadopsi ${h['name']} bernama $petName! (+${h['happiness']}% Kebahagiaan, -\$${_fmt(h['cost'] as int)})';
    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Selamat Datang!', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx2);
              widget.onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopsi Peliharaan 🐾', style: TextStyle(fontWeight: FontWeight.bold)),
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
                itemCount: hewan.length,
                itemBuilder: (_, i) {
                  final h = hewan[i];
                  final bool canAfford = widget.character.money >= (h['cost'] as int);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: canAfford ? Colors.white : Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(h['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: canAfford ? Colors.black87 : Colors.grey,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${h['desc']}\nHarga: \$${_fmt(h['cost'] as int)}',
                          style: TextStyle(color: canAfford ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.favorite : Icons.lock_outline,
                          color: canAfford ? Colors.green : Colors.grey),
                      onTap: canAfford ? () => _executeAdopsi(context, h) : null,
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
