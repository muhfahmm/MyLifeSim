// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/kesuburan/kesuburan_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'page_donor_sperma.dart';

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

  List<Map<String, dynamic>> layanan = [];

  @override
  void initState() {
    super.initState();
    _updateLayananList();
  }

  void _updateLayananList() {
    layanan = [
      {'name': 'Cek Kesuburan 🔬', 'cost': 15000, 'desc': 'Periksa tingkat kesuburan saat ini'},
      {'name': 'Terapi Hormon 💊', 'cost': 35000, 'desc': 'Meningkatkan kesuburan dengan terapi hormon'},
      {'name': 'Bayi Tabung (IVF) 🧪', 'cost': 30000, 'desc': 'Program bayi tabung untuk kehamilan'},
    ];

    final String genderClean = widget.character.gender.trim().toLowerCase();
    final isMale = genderClean == 'laki-laki' || genderClean == 'male' || genderClean == 'l';
    if (isMale) {
      layanan.add({
        'name': 'Donor Sperma 🧬',
        'cost': 0,
        'desc': 'Donorkan sperma Anda ke bank sperma untuk membantu orang lain (Dapat uang \$5.000)',
      });
    } else {
      layanan.add({
        'name': widget.character.birthControlActive ? 'Matikan Kontrol Kehamilan (KB) ❌' : 'Aktifkan Kontrol Kehamilan (KB) 🛡️',
        'cost': 1000,
        'desc': widget.character.birthControlActive 
            ? 'Nonaktifkan perlindungan KB' 
            : 'Aktifkan perlindungan KB untuk mengurangi risiko hamil menjadi 5%',
      });
    }
  }

  static String _fmt(int amount) {
    // Menghindari minus uang saat donor sperma (cost: 0)
    final absVal = amount.abs();
    return absVal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
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
    } else if (l['name'].toString().contains('Donor')) {
      // Dapatkan uang $5.000
      setState(() {
        widget.character.money += 5000;
      });
      final bool berhasil = r.nextInt(100) < (kesuburan + 20).clamp(0, 100);
      if (berhasil) {
        final List<String> girls = (Character.globalFemaleFirstNames.isNotEmpty) ? Character.globalFemaleFirstNames : ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra'];
        final List<String> boys = (Character.globalMaleFirstNames.isNotEmpty) ? Character.globalMaleFirstNames : ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi'];
        final List<String> lastNamesList = (Character.globalLastNames.isNotEmpty) ? Character.globalLastNames : ['Pratama', 'Saputra', 'Wijaya', 'Kusuma'];
        
        final String ibuNama = '${girls[r.nextInt(girls.length)]} ${lastNamesList[r.nextInt(lastNamesList.length)]}';
        final String anakGender = r.nextBool() ? 'Laki-laki' : 'Perempuan';
        final String anakNamaDepan = anakGender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
        final String anakNama = '$anakNamaDepan ${lastNamesList[r.nextInt(lastNamesList.length)]}';

        widget.character.children.add({
          'name': anakNama,
          'gender': anakGender,
          'relationship': '50',
          'age': '0',
          'father': widget.character.name,
          'mother': ibuNama,
          'isDeceased': 'false',
        });

        msg = '🧬 Donor Sperma Berhasil!\n\nSeorang penerima bernama Ibu $ibuNama telah berhasil menggunakan sperma Anda untuk melahirkan bayi $anakGender bernama $anakNama. Anda mendapatkan \$5.000 untuk kontribusi ini!';
      } else {
        msg = '🧬 Donor Anda disimpan di bank sperma, namun belum ada penerima yang berhasil membuahi dengannya tahun ini. Anda tetap mendapatkan \$5.000 untuk donor ini!';
      }
    } else if (l['name'].toString().contains('Kontrol Kehamilan') || l['name'].toString().contains('KB')) {
      setState(() {
        widget.character.birthControlActive = !widget.character.birthControlActive;
        _updateLayananList();
      });
      msg = widget.character.birthControlActive
          ? '🛡️ Kontrol Kehamilan (KB) telah diaktifkan! Risiko kehamilan tidak sengaja kini ditekan hingga 5%.'
          : '❌ Kontrol Kehamilan (KB) dinonaktifkan. Risiko kehamilan kembali normal.';
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
    _updateLayananList();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Hitung tingkat kesuburan berdasarkan kesehatan dan usia
    int kesuburan = widget.character.health;
    if (widget.character.age > 35) kesuburan = (kesuburan * 0.7).round();
    if (widget.character.age > 45) kesuburan = (kesuburan * 0.4).round();
    kesuburan = kesuburan.clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesuburan 🌱', style: TextStyle(fontWeight: FontWeight.bold)),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Saldo Anda: \$${_fmt(widget.character.money)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14, 
                          color: isDark ? Colors.greenAccent : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.purple.shade900 : Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? Colors.purple.shade700 : Colors.purple.shade200),
                    ),
                    child: Text('Kesuburan: $kesuburan%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 13, 
                          color: isDark ? Colors.purpleAccent : Colors.purple,
                        )),
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
                    color: canAfford 
                        ? (isDark ? Colors.grey.shade800 : Colors.white)
                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        l['name'], 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                          color: canAfford 
                              ? (isDark ? Colors.white : Colors.black87)
                              : (isDark ? Colors.white54 : Colors.grey),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${l['desc']}\nBiaya: \$${_fmt(l['cost'] as int)}',
                          style: TextStyle(
                            color: canAfford 
                                ? (isDark ? Colors.white70 : Colors.black54)
                                : (isDark ? Colors.white38 : Colors.grey),
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(
                        canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                        size: 14, 
                        color: canAfford 
                            ? (isDark ? Colors.purpleAccent : Colors.purple)
                            : (isDark ? Colors.white54 : Colors.grey),
                      ),
                      onTap: canAfford ? () {
                        if (l['name'].toString().contains('Donor')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageDonorSperma(
                                character: widget.character,
                                onComplete: () {
                                  setState(() {});
                                  widget.onComplete();
                                },
                              ),
                            ),
                          );
                        } else {
                          _executeLayanan(context, l, kesuburan);
                        }
                      } : null,
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