// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/operasi_plastik/operasi_plastik_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class OperasiPlastikMenuHelper {
  static void showOperasiPlastikMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk operasi plastik.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OperasiPlastikPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class OperasiPlastikPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const OperasiPlastikPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<OperasiPlastikPage> createState() => _OperasiPlastikPageState();
}

class _OperasiPlastikPageState extends State<OperasiPlastikPage> {
  final List<Map<String, dynamic>> operasi = [
    {'name': 'Rhinoplasty (Hidung) 👃', 'cost': 15000000, 'happiness': 15, 'risk': 10, 'desc': 'Operasi bentuk hidung agar lebih proporsional'},
    {'name': 'Blepharoplasty (Mata) 👁️', 'cost': 10000000, 'happiness': 12, 'risk': 8, 'desc': 'Operasi kelopak mata untuk tampak lebih segar'},
    {'name': 'Lip Filler (Bibir) 💋', 'cost': 5000000, 'happiness': 10, 'risk': 5, 'desc': 'Filler untuk bibir lebih penuh dan seksi'},
    {'name': 'Liposuction (Tubuh) 🏃', 'cost': 25000000, 'happiness': 20, 'risk': 20, 'desc': 'Sedot lemak untuk tubuh lebih ideal'},
    {'name': 'Facelift (Wajah) ✨', 'cost': 40000000, 'happiness': 25, 'risk': 15, 'desc': 'Operasi menyeluruh untuk tampak lebih muda'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeOperasi(BuildContext context, Map<String, dynamic> o) {
    final r = Random();
    setState(() {
      widget.character.money -= (o['cost'] as int);
    });
    final bool komplikasi = r.nextInt(100) < (o['risk'] as int);
    String msg;

    if (komplikasi) {
      setState(() {
        widget.character.health = (widget.character.health - 20).clamp(0, 100);
        widget.character.happiness = (widget.character.happiness - 15).clamp(0, 100);
      });
      msg = '😨 Komplikasi! Operasi ${o['name']} mengalami masalah. Kesehatanmu turun drastis (-20% Kesehatan, -15% Kebahagiaan).';
    } else {
      setState(() {
        widget.character.happiness = (widget.character.happiness + (o['happiness'] as int)).clamp(0, 100);
      });
      msg = '✨ ${o['name']} berhasil! Kamu sangat puas dengan hasilnya. (+${o['happiness']}% Kebahagiaan)';
    }

    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(komplikasi ? Icons.warning : Icons.check_circle,
              color: komplikasi ? Colors.red : Colors.green),
          const SizedBox(width: 8),
          Text(komplikasi ? 'Komplikasi!' : 'Operasi Berhasil', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
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
        title: const Text('Operasi Plastik 🏥', style: TextStyle(fontWeight: FontWeight.bold)),
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
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Operasi plastik memiliki risiko komplikasi. Pertimbangkan baik-baik!',
                      style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: operasi.length,
                itemBuilder: (_, i) {
                  final o = operasi[i];
                  final bool canAfford = widget.character.money >= (o['cost'] as int);
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
                      title: Text(o['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: canAfford ? Colors.black87 : Colors.grey,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${o['desc']}\nBiaya: \$${_fmt(o['cost'] as int)} | Risiko: ${o['risk']}%',
                          style: TextStyle(color: canAfford ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                          size: 14, color: canAfford ? Colors.cyan : Colors.grey),
                      onTap: canAfford ? () => _executeOperasi(context, o) : null,
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
