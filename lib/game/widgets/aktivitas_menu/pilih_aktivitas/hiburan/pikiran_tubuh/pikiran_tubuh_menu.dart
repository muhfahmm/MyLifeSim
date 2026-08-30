// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/pikiran_tubuh/pikiran_tubuh_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class PikiranTubuhMenuHelper {
  static void showPikiranTubuhMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk melakukan latihan pikiran dan tubuh.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PikiranTubuhPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class PikiranTubuhPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PikiranTubuhPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<PikiranTubuhPage> createState() => _PikiranTubuhPageState();
}

class _PikiranTubuhPageState extends State<PikiranTubuhPage> {
  final List<Map<String, dynamic>> aktivitas = [
    {'name': 'Meditasi 🧘', 'cost': 0, 'happiness': 15, 'intelligence': 5, 'health': 5, 'desc': 'Latihan pernapasan dan ketenangan batin'},
    {'name': 'Yoga 🌿', 'cost': 100000, 'happiness': 12, 'intelligence': 3, 'health': 8, 'desc': 'Gerakan tubuh untuk fleksibilitas dan ketenangan'},
    {'name': 'Terapi Pikiran 🧠', 'cost': 800000, 'happiness': 20, 'intelligence': 8, 'health': 5, 'desc': 'Sesi terapi kognitif dengan psikolog'},
    {'name': 'Tai Chi ☯️', 'cost': 150000, 'happiness': 10, 'intelligence': 4, 'health': 6, 'desc': 'Seni bela diri lembut untuk keseimbangan'},
    {'name': 'Journaling ✍️', 'cost': 0, 'happiness': 8, 'intelligence': 7, 'health': 2, 'desc': 'Menulis jurnal untuk ekspresi diri'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeAktivitas(BuildContext context, Map<String, dynamic> a) {
    setState(() {
      if (a['cost'] as int > 0) widget.character.money -= (a['cost'] as int);
      widget.character.happiness = (widget.character.happiness + (a['happiness'] as int)).clamp(0, 100);
      widget.character.intelligence = (widget.character.intelligence + (a['intelligence'] as int)).clamp(0, 100);
      widget.character.health = (widget.character.health + (a['health'] as int)).clamp(0, 100);
    });

    final msg = '${a['name']} selesai! Kamu merasa lebih tenang dan fokus. (+${a['happiness']}% Kebahagiaan, +${a['intelligence']}% Kecerdasan, +${a['health']}% Kesehatan)';
    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Sesi Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pikiran & Tubuh 🧘', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: \$${_fmt(widget.character.money)}',
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
                itemCount: aktivitas.length,
                itemBuilder: (_, i) {
                  final a = aktivitas[i];
                  final bool canAfford = a['cost'] == 0 || widget.character.money >= (a['cost'] as int);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: canAfford ? (isDark ? Colors.grey.shade800 : Colors.white) : (isDark ? Colors.grey.shade700 : Colors.grey.shade50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        a['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: canAfford ? (isDark ? Colors.white : Colors.black87) : (isDark ? Colors.white54 : Colors.grey),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${a['desc']}\n${a['cost'] == 0 ? "Gratis ✅" : "Biaya: \$${_fmt(a['cost'] as int)}"}',
                          style: TextStyle(
                            color: canAfford ? (isDark ? Colors.white70 : Colors.black54) : (isDark ? Colors.white38 : Colors.grey),
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(
                        canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                        size: 14,
                        color: canAfford ? (isDark ? Colors.indigoAccent : Colors.indigo) : (isDark ? Colors.white54 : Colors.grey),
                      ),
                      onTap: canAfford ? () => _executeAktivitas(context, a) : null,
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