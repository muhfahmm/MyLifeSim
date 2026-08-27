// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/salon_spa/salon_spa_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class SalonSpaMenuHelper {
  static void showSalonSpaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 15) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 15 tahun untuk pergi to salon & spa.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonSpaPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class SalonSpaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const SalonSpaPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<SalonSpaPage> createState() => _SalonSpaPageState();
}

class _SalonSpaPageState extends State<SalonSpaPage> {
  final List<Map<String, dynamic>> layanan = [
    {'name': 'Potong Rambut ✂️', 'cost': 100000, 'happiness': 8, 'desc': 'Tampilan baru yang segar dan stylish'},
    {'name': 'Creambath & Masker 🧖', 'cost': 200000, 'happiness': 10, 'health': 5, 'desc': 'Perawatan rambut intensif'},
    {'name': 'Full Body Massage 💆', 'cost': 500000, 'happiness': 20, 'health': 10, 'desc': 'Pijat seluruh tubuh untuk relaksasi'},
    {'name': 'Facial & Peeling 🌸', 'cost': 300000, 'happiness': 15, 'desc': 'Perawatan kulit wajah intensif'},
    {'name': 'Mewarnai Rambut 🎨', 'cost': 400000, 'happiness': 12, 'desc': 'Warna rambut baru sesuai selera'},
    {'name': 'Nail Art 💅', 'cost': 150000, 'happiness': 8, 'desc': 'Hiasan kuku yang cantik dan kreatif'},
    {'name': 'Spa Package Lengkap 🌺', 'cost': 1500000, 'happiness': 35, 'health': 15, 'desc': 'Paket spa menyeluruh premium'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeLayanan(BuildContext context, Map<String, dynamic> l) {
    setState(() {
      widget.character.money -= (l['cost'] as int);
      widget.character.happiness = (widget.character.happiness + (l['happiness'] as int)).clamp(0, 100);
      if (l.containsKey('health')) {
        widget.character.health = (widget.character.health + (l['health'] as int)).clamp(0, 100);
      }
    });

    final extraHealth = l.containsKey('health') ? ', +${l['health']}% Kesehatan' : '';
    final msg = '💅 ${l['name']} selesai! Kamu tampak lebih segar dan cantik/ganteng. (+${l['happiness']}% Kebahagiaan$extraHealth)';
    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Perawatan Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
        title: const Text('Salon & Spa 💅', style: TextStyle(fontWeight: FontWeight.bold)),
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
                itemCount: layanan.length,
                itemBuilder: (_, i) {
                  final l = layanan[i];
                  final bool canAfford = widget.character.money >= (l['cost'] as int);
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
                      title: Text(l['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: canAfford ? Colors.black87 : Colors.grey,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${l['desc']}\nHarga: \$${_fmt(l['cost'] as int)}',
                          style: TextStyle(color: canAfford ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                          size: 14, color: canAfford ? Colors.pink : Colors.grey),
                      onTap: canAfford ? () => _executeLayanan(context, l) : null,
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
