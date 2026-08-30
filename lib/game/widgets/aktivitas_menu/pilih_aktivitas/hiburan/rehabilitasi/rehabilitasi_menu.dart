// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/rehabilitasi/rehabilitasi_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class RehabilitasiMenuHelper {
  static void showRehabilitasiMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk program rehabilitasi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RehabilitasiPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class RehabilitasiPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const RehabilitasiPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<RehabilitasiPage> createState() => _RehabilitasiPageState();
}

class _RehabilitasiPageState extends State<RehabilitasiPage> {
  final List<Map<String, dynamic>> program = [
    {'name': 'Rehabilitasi Alkohol 🍺', 'cost': 10000000, 'duration': 30, 'happiness': 20, 'health': 25, 'desc': 'Program detoks dari ketergantungan alkohol'},
    {'name': 'Rehabilitasi Narkoba 💊', 'cost': 25000000, 'duration': 90, 'happiness': 25, 'health': 30, 'desc': 'Program pemulihan dari ketergantungan narkoba'},
    {'name': 'Rehabilitasi Judi 🎲', 'cost': 5000000, 'duration': 14, 'happiness': 15, 'health': 10, 'desc': 'Terapi mengatasi kecanduan berjudi'},
    {'name': 'Terapi Perilaku 🧠', 'cost': 3000000, 'duration': 7, 'happiness': 18, 'health': 5, 'desc': 'Terapi kognitif untuk mengubah pola pikir negatif'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeRehab(BuildContext context, Map<String, dynamic> p) {
    setState(() {
      widget.character.money -= (p['cost'] as int);
      widget.character.happiness = (widget.character.happiness + (p['happiness'] as int)).clamp(0, 100);
      widget.character.health = (widget.character.health + (p['health'] as int)).clamp(0, 100);
    });

    final msg = '💚 Program ${p['name']} selesai! Kamu pulih dan siap menjalani hidup lebih baik. (+${p['happiness']}% Kebahagiaan, +${p['health']}% Kesehatan)';
    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Program Selesai!', style: TextStyle(fontWeight: FontWeight.bold)),
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
        title: const Text('Program Rehabilitasi 💚', style: TextStyle(fontWeight: FontWeight.bold)),
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
                itemCount: program.length,
                itemBuilder: (_, i) {
                  final p = program[i];
                  final bool canAfford = widget.character.money >= (p['cost'] as int);
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
                        p['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: canAfford ? (isDark ? Colors.white : Colors.black87) : (isDark ? Colors.white54 : Colors.grey),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${p['desc']}\nBiaya: \$${_fmt(p['cost'] as int)} | Durasi: ${p['duration']} hari',
                          style: TextStyle(
                            color: canAfford ? (isDark ? Colors.white70 : Colors.black54) : (isDark ? Colors.white38 : Colors.grey),
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(
                        canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                        size: 14,
                        color: canAfford ? (isDark ? Colors.deepPurpleAccent : Colors.deepPurple) : (isDark ? Colors.white54 : Colors.grey),
                      ),
                      onTap: canAfford ? () => _executeRehab(context, p) : null,
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