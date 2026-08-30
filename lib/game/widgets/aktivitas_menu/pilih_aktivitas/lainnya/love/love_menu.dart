// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/love/love_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoveMenuPage(character: character, onComplete: onComplete),
      ),
    );
  }
}

class LoveMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const LoveMenuPage({super.key, required this.character, required this.onComplete});

  @override
  State<LoveMenuPage> createState() => _LoveMenuPageState();
}

class _LoveMenuPageState extends State<LoveMenuPage> {
  Character get character => widget.character;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Love & Asmara 💕'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? Colors.red.shade700 : Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Temukan belahan jiwamu melalui aplikasi kencan atau cari jodoh secara acak.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.redAccent : Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone_iphone, color: Colors.pinkAccent),
                title: Text(
                  'Aplikasi Kencan (Dating App) 📱',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Cari pasangan ideal berdasarkan kriteria umur (Biaya: \$50.000)',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DatingAppConfigPage(character: character, onComplete: widget.onComplete)),
                  );
                },
              ),
            ),

            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.redAccent),
                title: Text(
                  'Cari Pacar Acak 💘',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Coba keberuntunganmu dengan mengajak kencan orang asing secara acak (Gratis)',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                onTap: () {
                  final r = Random();
                  final List<String> boys = ['Reza', 'Gani', 'Dimas', 'Kevin', 'Iqbal', 'Arie', 'Wisnu', 'Diki', 'Indra'];
                  final List<String> girls = ['Siska', 'Rina', 'Clara', 'Mila', 'Alya', 'Nabila', 'Vania', 'Riska', 'Laras'];
                  
                  final gender = character.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
                  final name = gender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
                  
                  final age = (character.age - 2) + r.nextInt(5);
                  final looks = 30 + r.nextInt(70);
                  final smart = 30 + r.nextInt(70);
                  final moneyValue = 100000 + r.nextInt(5000000);

                  _showCandidateDialog(
                    context,
                    character,
                    {
                      'name': name,
                      'gender': gender,
                      'age': age.toString(),
                      'looks': looks.toString(),
                      'smart': smart.toString(),
                      'money': moneyValue.toString(),
                    },
                    widget.onComplete,
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

class DatingAppConfigPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const DatingAppConfigPage({super.key, required this.character, required this.onComplete});

  @override
  State<DatingAppConfigPage> createState() => _DatingAppConfigPageState();
}

class _DatingAppConfigPageState extends State<DatingAppConfigPage> {
  String selectedGender = '';
  String selectedAgeRange = '18-25';

  @override
  void initState() {
    super.initState();
    selectedGender = widget.character.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kriteria Kencan'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih Gender Target:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: 'Laki-laki',
                  groupValue: selectedGender,
                  activeColor: Colors.pinkAccent,
                  onChanged: (val) => setState(() => selectedGender = val!),
                ),
                Text('Laki-laki', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: selectedGender,
                  activeColor: Colors.pinkAccent,
                  onChanged: (val) => setState(() => selectedGender = val!),
                ),
                Text('Perempuan', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Rentang Usia:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedAgeRange,
              isExpanded: true,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: <String>['18-25', '26-35', '36+'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedAgeRange = val!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (widget.character.money < 50000) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Uang Tidak Cukup'),
                      content: const Text('Kamu butuh minimal \$50.000 untuk menggunakan aplikasi kencan.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                    ),
                  );
                  return;
                }
                widget.character.money -= 50000;
                
                final r = Random();
                final List<String> boys = ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi', 'Rehan', 'Fadel', 'Budi', 'Aditya', 'Rian', 'Fahmi', 'Aris'];
                final List<String> girls = ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra', 'Keysha', 'Aurel', 'Santi', 'Putri', 'Sari', 'Indah', 'Dewi'];

                final name = selectedGender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
                
                int age = 18;
                if (selectedAgeRange == '18-25') age = 18 + r.nextInt(8);
                else if (selectedAgeRange == '26-35') age = 26 + r.nextInt(10);
                else age = 36 + r.nextInt(15);

                final looks = 40 + r.nextInt(60);
                final smart = 40 + r.nextInt(60);
                final moneyValue = r.nextInt(100) < 50 ? 500000 + r.nextInt(2000000) : 3000000 + r.nextInt(15000000);

                // Tampilkan dialog kandidat tanpa pindah halaman
                _showCandidateDialog(
                  context,
                  widget.character,
                  {
                    'name': name,
                    'gender': selectedGender,
                    'age': age.toString(),
                    'looks': looks.toString(),
                    'smart': smart.toString(),
                    'money': moneyValue.toString(),
                  },
                  widget.onComplete,
                );
              },
              child: const Text('Cari Pasangan (\$50.000)', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Fungsi untuk menampilkan dialog kandidat (modal)
void _showCandidateDialog(
  BuildContext context,
  Character character,
  Map<String, dynamic> candidate,
  VoidCallback onComplete,
) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final r = Random();
  final c = candidate;
  final String name = c['name']!;
  final String gender = c['gender']!;
  final int age = int.tryParse(c['age'] ?? '18') ?? 18;
  final int looks = int.tryParse(c['looks'] ?? '50') ?? 50;
  final int smart = int.tryParse(c['smart'] ?? '50') ?? 50;
  final int moneyValue = int.tryParse(c['money'] ?? '0') ?? 0;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      title: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.pink),
          const SizedBox(width: 8),
          Text('Kandidat Ditemukan!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama: $name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          Text('Gender: $gender', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          Text('Usia: $age tahun', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          const SizedBox(height: 8),
          Row(children: [
            Text('Penampilan: ', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            Expanded(
              child: LinearProgressIndicator(
                value: looks / 100,
                color: Colors.pinkAccent,
                backgroundColor: isDark ? Colors.grey.shade700 : Colors.pink.shade50,
              ),
            ),
            Text(' $looks%', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Text('Kecerdasan: ', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            Expanded(
              child: LinearProgressIndicator(
                value: smart / 100,
                color: Colors.blue,
                backgroundColor: isDark ? Colors.grey.shade700 : Colors.blue.shade50,
              ),
            ),
            Text(' $smart%', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          ]),
          const SizedBox(height: 8),
          Text(
            'Perkiraan Uang/Gaji: \$${moneyValue.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx); // Tutup dialog kandidat
            onComplete();
            // Kembali ke halaman love menu jika berasal dari config
            Navigator.pop(context); // Pop halaman config
          },
          child: Text('Abaikan', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: () {
            Navigator.pop(ctx); // Tutup dialog kandidat
            // Proses ajakan
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
            onComplete();

            // Tampilkan dialog hasil
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: isDark ? Colors.grey.shade900 : null,
                title: Row(children: [
                  Icon(success ? Icons.check_circle : Icons.cancel, color: success ? Colors.green : Colors.red),
                  const SizedBox(width: 8),
                  Text(success ? 'Sukses!' : 'Ditolak', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                ]),
                content: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      // Kembali ke halaman love menu
                      Navigator.pop(context); // Pop halaman config
                    },
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          },
          child: const Text('Ajak Pacaran 💖', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}