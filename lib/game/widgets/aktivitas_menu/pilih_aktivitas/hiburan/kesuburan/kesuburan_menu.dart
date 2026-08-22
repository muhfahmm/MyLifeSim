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

    final r = Random();
    // Hitung tingkat kesuburan berdasarkan kesehatan dan usia
    int kesuburan = character.health;
    if (character.age > 35) kesuburan = (kesuburan * 0.7).round();
    if (character.age > 45) kesuburan = (kesuburan * 0.4).round();
    kesuburan = kesuburan.clamp(0, 100);

    final List<Map<String, dynamic>> layanan = [
      {'name': 'Cek Kesuburan 🔬', 'cost': 1000000, 'desc': 'Periksa tingkat kesuburan saat ini'},
      {'name': 'Terapi Hormon 💊', 'cost': 3000000, 'desc': 'Meningkatkan kesuburan dengan terapi hormon'},
      {'name': 'Bayi Tabung (IVF) 🧪', 'cost': 30000000, 'desc': 'Program bayi tabung untuk kehamilan'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.egg, color: Colors.purple),
          SizedBox(width: 8),
          Text('Kesuburan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(children: [
                const Text('🌱', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('Estimasi Kesuburanmu: $kesuburan%',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
              ]),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: layanan.length,
                itemBuilder: (_, i) {
                  final l = layanan[i];
                  final bool canAfford = character.money >= (l['cost'] as int);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      title: Text(l['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${l['desc']}\nBiaya: Rp ${_fmt(l['cost'] as int)}'),
                      isThreeLine: true,
                      trailing: Icon(canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                          size: 14, color: canAfford ? Colors.purple : Colors.grey),
                      onTap: canAfford ? () {
                        Navigator.pop(ctx);
                        character.money -= (l['cost'] as int);
                        String msg;
                        if (l['name'].toString().contains('Cek')) {
                          msg = '🔬 Hasil tes: Tingkat kesuburanmu adalah $kesuburan%. ${kesuburan > 70 ? 'Sangat subur!' : kesuburan > 40 ? 'Cukup subur.' : 'Kesuburanmu rendah, pertimbangkan terapi.'}';
                        } else if (l['name'].toString().contains('Hormon')) {
                          character.health = (character.health + 5).clamp(0, 100);
                          msg = '💊 Terapi hormon berhasil! Kesuburanmu meningkat (+5% Kesehatan).';
                        } else {
                          final berhasil = r.nextInt(100) < kesuburan;
                          msg = berhasil
                              ? '🎉 Program IVF berhasil! Kemungkinan kehamilan meningkat pesat!'
                              : '😔 Program IVF kali ini belum berhasil. Dokter menyarankan untuk mencoba lagi.';
                        }
                        character.inbox.add(msg);
                        showDialog(
                          context: context,
                          builder: (ctx2) => AlertDialog(
                            title: const Row(children: [
                              Icon(Icons.info, color: Colors.purple),
                              SizedBox(width: 8),
                              Text('Hasil Layanan', style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            content: Text(msg),
                            actions: [TextButton(onPressed: () { Navigator.pop(ctx2); onComplete(); }, child: const Text('OK'))],
                          ),
                        );
                      } : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup'))],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
