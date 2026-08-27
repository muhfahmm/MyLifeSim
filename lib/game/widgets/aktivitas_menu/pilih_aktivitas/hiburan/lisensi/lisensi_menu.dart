// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/lisensi/lisensi_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

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

  void _executeUrus(BuildContext context, Map<String, dynamic> l) {
    setState(() {
      widget.character.money -= (l['cost'] as int);
    });
    widget.character.intelligence = (widget.character.intelligence + 3).clamp(0, 100);
    final msg = '📋 Kamu berhasil mendapatkan ${l['name']}! (+3% Kecerdasan, -\$${_fmt(l['cost'] as int)})';
    widget.character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Lisensi Diperoleh!', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  final bool ageOk = widget.character.age >= (l['minAge'] as int);
                  final bool canAfford = widget.character.money >= (l['cost'] as int);
                  final bool available = ageOk && canAfford;
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: available ? Colors.white : Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(l['name'], style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: available ? Colors.black87 : Colors.grey,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${l['desc']}\nBiaya: \$${_fmt(l['cost'] as int)} | Min. usia: ${l['minAge']} thn',
                          style: TextStyle(color: available ? Colors.black54 : Colors.grey)),
                      ),
                      isThreeLine: true,
                      trailing: Icon(available ? Icons.arrow_forward_ios : Icons.lock_outline,
                          size: 14, color: available ? Colors.brown : Colors.grey),
                      onTap: available ? () => _executeUrus(context, l) : null,
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
