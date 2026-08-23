// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/love/love_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class LoveMenuHelper {
  static void showLoveMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 16) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 16 tahun untuk memulai hubungan percintaan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    DialogHelper.show(
      context: context,
      title: 'Love & Asmara 💕',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Row(children: [
              Text('❤️', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Expanded(
                child: Text('Temukan belahan jiwamu melalui aplikasi kencan atau cari jodoh secara acak.',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 12)),
              ),
            ]),
          ),
          
          // Opsi 1: Aplikasi Kencan
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: const Icon(Icons.phone_iphone, color: Colors.pinkAccent),
              title: const Text('Aplikasi Kencan (Dating App) 📱', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Cari pasangan ideal berdasarkan kriteria umur (Biaya: Rp 50.000)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
                _showDatingAppConfig(context, character, onComplete);
              },
            ),
          ),

          // Opsi 2: Cari Jodoh Acak
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: const Icon(Icons.favorite_border, color: Colors.redAccent),
              title: const Text('Cari Pacar Acak 💘', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Coba keberuntunganmu dengan mengajak kencan orang asing secara acak (Gratis)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
                _executeCariJodohAcak(context, character, onComplete);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  // Konfigurasi Kriteria Aplikasi Kencan
  static void _showDatingAppConfig(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.money < 50000) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Uang Tidak Cukup'),
          content: const Text('Kamu butuh minimal Rp 50.000 untuk menggunakan aplikasi kencan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    String selectedGender = character.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
    String selectedAgeRange = '18-25';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(children: [
              Icon(Icons.tune, color: Colors.pinkAccent),
              SizedBox(width: 8),
              Text('Kriteria Kencan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilih Gender Target:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Laki-laki',
                      groupValue: selectedGender,
                      onChanged: (val) => setState(() => selectedGender = val!),
                    ),
                    const Text('Laki-laki'),
                    Radio<String>(
                      value: 'Perempuan',
                      groupValue: selectedGender,
                      onChanged: (val) => setState(() => selectedGender = val!),
                    ),
                    const Text('Perempuan'),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Pilih Rentang Usia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                DropdownButton<String>(
                  value: selectedAgeRange,
                  isExpanded: true,
                  items: <String>['18-25', '26-35', '36+'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedAgeRange = val!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  Navigator.pop(ctx);
                  character.money -= 50000;
                  _generateDatingAppCandidate(context, character, selectedGender, selectedAgeRange, onComplete);
                },
                child: const Text('Cari Pasangan (Rp 50.000)', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  // Generate Kandidat Aplikasi Kencan
  static void _generateDatingAppCandidate(
      BuildContext context, Character character, String gender, String ageRange, VoidCallback onComplete) {
    final r = Random();
    final List<String> boys = ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi', 'Rehan', 'Fadel', 'Budi', 'Aditya', 'Rian', 'Fahmi', 'Aris'];
    final List<String> girls = ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra', 'Keysha', 'Aurel', 'Santi', 'Putri', 'Sari', 'Indah', 'Dewi'];

    final name = gender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
    
    int age = 18;
    if (ageRange == '18-25') age = 18 + r.nextInt(8);
    else if (ageRange == '26-35') age = 26 + r.nextInt(10);
    else age = 36 + r.nextInt(15);

    final looks = 40 + r.nextInt(60);
    final smart = 40 + r.nextInt(60);
    final moneyValue = r.nextInt(100) < 50 ? 500000 + r.nextInt(2000000) : 3000000 + r.nextInt(15000000);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.favorite, color: Colors.pink),
          SizedBox(width: 8),
          Text('Kandidat Ditemukan!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Gender: $gender'),
            Text('Usia: $age tahun'),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Penampilan: '),
              Expanded(child: LinearProgressIndicator(value: looks / 100, color: Colors.pinkAccent, backgroundColor: Colors.pink.shade50)),
              Text(' $looks%'),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Text('Kecerdasan: '),
              Expanded(child: LinearProgressIndicator(value: smart / 100, color: Colors.blue, backgroundColor: Colors.blue.shade50)),
              Text(' $smart%'),
            ]),
            const SizedBox(height: 8),
            Text('Perkiraan Uang/Gaji: Rp ${moneyValue.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete();
            },
            child: const Text('Abaikan'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(ctx);
              _askOutCandidate(context, character, name, gender, age, looks, smart, moneyValue, onComplete);
            },
            child: const Text('Ajak Pacaran 💖', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Aksi Mengajak Pacaran
  static void _askOutCandidate(
      BuildContext context, Character character, String name, String gender, int age, int looks, int smart, int moneyValue, VoidCallback onComplete) {
    final r = Random();
    
    // Peluang diterima didasarkan pada ketertarikan (penampilan & uang)
    final chance = (looks + (character.appearance) + 20) ~/ 3;
    final success = r.nextInt(100) < chance;

    String msg;
    if (success) {
      final partnerMap = {
        'name': name,
        'gender': gender,
        'relationship': '70',
        'relation': 'Pacar',
        'age': age.toString(),
        'looks': looks.toString(),
        'smart': smart.toString(),
        'money': moneyValue.toString(),
      };
      character.addPartnerToFreeSlot(partnerMap);
      msg = '🎉 Berhasil! $name menerima ajakan kencanmu. Sekarang kalian resmi berpacaran!';
    } else {
      msg = '😔 Sayang sekali. $name menolak ajakan kencanmu dengan halus.';
    }

    character.inbox.add(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(success ? Icons.check_circle : Icons.cancel, color: success ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Text(success ? 'Sukses!' : 'Ditolak', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // Aksi Cari Pacar Acak (Cari Jodoh)
  static void _executeCariJodohAcak(BuildContext context, Character character, VoidCallback onComplete) {
    final r = Random();
    final List<String> boys = ['Reza', 'Gani', 'Dimas', 'Kevin', 'Iqbal', 'Arie', 'Wisnu', 'Diki', 'Indra'];
    final List<String> girls = ['Siska', 'Rina', 'Clara', 'Mila', 'Alya', 'Nabila', 'Vania', 'Riska', 'Laras'];
    
    final gender = character.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
    final name = gender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
    
    final age = (character.age - 2) + r.nextInt(5);
    final looks = 30 + r.nextInt(70);
    final smart = 30 + r.nextInt(70);
    final moneyValue = 100000 + r.nextInt(5000000);

    _generateDatingAppCandidate(context, character, gender, '${age}-${age}', onComplete);
  }
}
