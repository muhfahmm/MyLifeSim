// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/kesuburan/kesuburan_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class KesuburanMenuHelper {
  static void showKesuburanMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk mengakses layanan kesuburan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KesuburanPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class KesuburanPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const KesuburanPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<KesuburanPage> createState() => _KesuburanPageState();
}

class _KesuburanPageState extends State<KesuburanPage> {
  final List<Map<String, dynamic>> layanan = [
    {'name': 'Cek Kesuburan 🔬', 'cost': 1000000, 'desc': 'Periksa tingkat kesuburan saat ini'},
    {'name': 'Terapi Hormon 💊', 'cost': 3000000, 'desc': 'Meningkatkan kesuburan dengan terapi hormon'},
    {'name': 'Bayi Tabung (IVF) 🧪', 'cost': 30000000, 'desc': 'Program bayi tabung untuk kehamilan'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeLayanan(BuildContext context, Map<String, dynamic> l, int kesuburan) {
    final r = Random();
    setState(() {
      widget.character.money -= (l['cost'] as int);
    });

    String msg;
    if (l['name'].toString().contains('Cek')) {
      msg = '🔬 Hasil tes: Tingkat kesuburanmu adalah $kesuburan%. ${kesuburan > 70 ? 'Sangat subur!' : kesuburan > 40 ? 'Cukup subur.' : 'Kesuburanmu rendah, pertimbangkan terapi.'}';
    } else if (l['name'].toString().contains('Hormon')) {
      widget.character.health = (widget.character.health + 5).clamp(0, 100);
      msg = '💊 Terapi hormon berhasil! Kesuburanmu meningkat (+5% Kesehatan).';
    } else {
      final berhasil = r.nextInt(100) < kesuburan;
      msg = berhasil
          ? '🎉 Program IVF berhasil! Kemungkinan kehamilan meningkat pesat!'
          : '😔 Program IVF kali ini belum berhasil. Dokter menyarankan untuk mencoba lagi.';
    }

    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.info, color: Colors.purple),
          SizedBox(width: 8),
          Text('Hasil Layanan', style: TextStyle(fontWeight: FontWeight.bold)),
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
    // Hitung tingkat kesuburan berdasarkan kesehatan dan usia
    int kesuburan = widget.character.health;
    if (widget.character.age > 35) kesuburan = (kesuburan * 0.7).round();
    if (widget.character.age > 45) kesuburan = (kesuburan * 0.4).round();
    kesuburan = kesuburan.clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesuburan 🌱', style: TextStyle(fontWeight: FontWeight.bold)),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Saldo Anda: \$${_fmt(widget.character.money)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Text('Kesuburan: $kesuburan%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.purple)),
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
                        child: Text('${l['desc']}\nBiaya: \$${_fmt(l['cost'] as int)}',
                          style: TextStyle(color: canAfford ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                          size: 14, color: canAfford ? Colors.purple : Colors.grey),
                      onTap: canAfford ? () => _executeLayanan(context, l, kesuburan) : null,
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
