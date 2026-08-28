// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/dokter/dokter_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class DokterMenuHelper {
  static void showDokterMenu(BuildContext context, Character character, VoidCallback onComplete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DokterPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class DokterPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const DokterPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<DokterPage> createState() => _DokterPageState();
}

class _DokterPageState extends State<DokterPage> {
  // Ubah cost menjadi 0 agar tidak ada biaya
  final List<Map<String, dynamic>> layanan = [
    {'name': 'Pemeriksaan Umum 🩺', 'cost': 0, 'desc': 'Cek kondisi kesehatan dasar'},
    {'name': 'Tes Darah 💉', 'cost': 0, 'desc': 'Pemeriksaan darah lengkap'},
    {'name': 'Konsultasi Psikolog 🧠', 'cost': 0, 'desc': 'Sesi konsultasi kesehatan mental'},
    {'name': 'Operasi Kecil 🏥', 'cost': 0, 'desc': 'Operasi untuk mengatasi masalah kesehatan'},
    {'name': 'Medical Check Up Lengkap 📋', 'cost': 0, 'desc': 'Pemeriksaan menyeluruh tubuh'},
  ];

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _executeDokter(BuildContext context, Map<String, dynamic> l) {
    final r = Random();
    // Hapus baris pengurangan uang
    // widget.character.money -= (l['cost'] as int);

    int healthGain = 0;
    int happinessGain = 0;
    int intelligenceGain = 0;
    String detail = '';

    if (l['name'].toString().contains('Umum')) {
      healthGain = 10 + r.nextInt(10);
      detail = 'Dokter menyatakan kondisimu cukup baik.';
    } else if (l['name'].toString().contains('Darah')) {
      healthGain = 5;
      intelligenceGain = 3;
      detail = 'Hasil tes darahmu normal. Dokter memberikan beberapa saran gizi.';
    } else if (l['name'].toString().contains('Psikolog')) {
      happinessGain = 20;
      detail = 'Sesi konsultasi sangat membantu. Pikiranmu terasa lebih ringan.';
    } else if (l['name'].toString().contains('Operasi')) {
      healthGain = 30;
      detail = 'Operasi berjalan lancar. Kesehatanmu meningkat signifikan.';
    } else if (l['name'].toString().contains('Check Up')) {
      healthGain = 15 + r.nextInt(10);
      happinessGain = 5;
      intelligenceGain = 2;
      detail = 'Medical check up lengkap selesai. Semua dalam kondisi prima.';
    }

    widget.character.health = (widget.character.health + healthGain).clamp(0, 100);
    widget.character.happiness = (widget.character.happiness + happinessGain).clamp(0, 100);
    widget.character.intelligence = (widget.character.intelligence + intelligenceGain).clamp(0, 100);

    // Ubah pesan agar tidak menampilkan biaya
    final msg = '🏥 ${l['name']}: $detail (+${healthGain}% Kesehatan${happinessGain > 0 ? ', +${happinessGain}% Kebahagiaan' : ''}) | Biaya: Gratis';
    widget.character.inbox.add(msg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Pemeriksaan Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
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
        title: const Text('Pergi ke Dokter 🏥', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  
                  // Hapus logika canAfford, langsung aktif
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.white, // Selalu putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(l['name'], style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,
                        color: Colors.black87,
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${l['desc']}\nBiaya: Gratis', // Ubah teks biaya
                          style: const TextStyle(color: Colors.black54)),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.blue), // Ikon panah aktif
                      onTap: () => _executeDokter(context, l), // Langsung bisa diklik
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