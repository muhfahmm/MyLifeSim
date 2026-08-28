// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/adopsi_anak/pilih_anak/pilih_anak_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class PilihAnakPage extends StatefulWidget {
  final Character character;
  final Map<String, dynamic> category;
  final VoidCallback onComplete;

  const PilihAnakPage({
    super.key,
    required this.character,
    required this.category,
    required this.onComplete,
  });

  @override
  State<PilihAnakPage> createState() => _PilihAnakPageState();
}

class _PilihAnakPageState extends State<PilihAnakPage> {
  late List<Map<String, dynamic>> _availableChildren;
  final Random _random = Random();

  String _getChildAvatarUrl(String name, String gender, int age, String skinColor) {
    return AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: 90, // smile expression matching the game
      forcedSkinColor: skinColor,
    );
  }

  static const List<String> _descriptions = [
    'Ceria dan suka bermain',
    'Pemalu tapi penyayang',
    'Sangat aktif dan energik',
    'Pintar dan cepat belajar',
    'Suka menggambar dan musik',
    'Ramah dan mudah bergaul',
    'Tenang dan penuh perhatian',
    'Suka membaca dan bercerita',
  ];

  @override
  void initState() {
    super.initState();
    _generateChildren();
  }

  void _generateChildren() {
    final int minAge = widget.category['minAge'] as int;
    final int maxAge = widget.category['maxAge'] as int;
    final int baseCost = widget.category['baseCost'] as int;

    // Jumlah anak antara 5-10
    final int count = 5 + _random.nextInt(6); // 5..10

    final List<String> maleFirst = (widget.character.maleFirstNames != null && widget.character.maleFirstNames!.isNotEmpty)
        ? widget.character.maleFirstNames!
        : Character.globalMaleFirstNames;
    final List<String> femaleFirst = (widget.character.femaleFirstNames != null && widget.character.femaleFirstNames!.isNotEmpty)
        ? widget.character.femaleFirstNames!
        : Character.globalFemaleFirstNames;
    final List<String> lastList = (widget.character.lastNames != null && widget.character.lastNames!.isNotEmpty)
        ? widget.character.lastNames!
        : Character.globalLastNames;

    _availableChildren = List.generate(count, (i) {
      final String gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final String firstName = gender == 'Laki-laki'
          ? maleFirst[_random.nextInt(maleFirst.length)]
          : femaleFirst[_random.nextInt(femaleFirst.length)];
      final String lastName = lastList[_random.nextInt(lastList.length)];
      final String fullName = '$firstName $lastName';

      final int age = minAge + _random.nextInt(maxAge - minAge + 1);
      // Biaya bervariasi ±10% dari biaya dasar
      final int cost = (baseCost * (0.9 + _random.nextDouble() * 0.2)).round();

      final String desc = _descriptions[_random.nextInt(_descriptions.length)];

      final String skinColor = AvatarGenerator.skinColors.values.elementAt(_random.nextInt(AvatarGenerator.skinColors.length));

      return {
        'name': fullName,
        'gender': gender,
        'age': age,
        'cost': cost,
        'desc': desc,
        'skinColor': skinColor,
      };
    });
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _showAdoptionDialog(Map<String, dynamic> child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Adopsi', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin mengadopsi ${child['name']} (${child['gender']}, ${child['age']} tahun) dengan biaya \$${_fmt(child['cost'] as int)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(ctx); // Close confirmation dialog
              final int cost = child['cost'] as int;
              if (widget.character.money >= cost) {
                _adoptChild(child);
              } else {
                _showNotEnoughMoneyDialog();
              }
            },
            child: const Text('Adopsi'),
          ),
        ],
      ),
    );
  }

  void _showNotEnoughMoneyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Dana Kurang', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Maaf, uang Anda tidak cukup untuk mengadopsi anak ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _adoptChild(Map<String, dynamic> child) {
    // Proses adopsi: kurangi uang, tambah kebahagiaan, simpan anak
    setState(() {
      widget.character.money -= (child['cost'] as int);
      widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
    });

    // Tambahkan anak ke daftar anak karakter
    widget.character.children.add({
      'name': child['name'],
      'age': child['age'].toString(),
      'gender': child['gender'],
      'relation': 'Anak Adopsi',
      'relationship': '80',
      'skinColor': child['skinColor'],
    });

    // Kirim pesan ke inbox
    final String msg = '👨‍👩‍👧 Kamu berhasil mengadopsi ${child['name']} (${child['gender']}, ${child['age']} tahun)!'
        ' (+20% Kebahagiaan, -\$${_fmt(child['cost'] as int)})';
    widget.character.inbox.add(msg);

    // Tampilkan dialog sukses
    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Adopsi Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx2); // tutup dialog
              // Kembali ke halaman utama setelah adopsi selesai
              Navigator.of(context).pop(); // tutup PilihAnakPage
              Navigator.of(context).pop(); // tutup AdopsiAnakPage
              widget.onComplete();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Anak (${widget.category['name']})', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                itemCount: _availableChildren.length,
                itemBuilder: (_, i) {
                  final child = _availableChildren[i];
                  final int cost = child['cost'] as int;
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _getChildAvatarUrl(
                              child['name'] as String,
                              child['gender'] as String,
                              child['age'] as int,
                              child['skinColor'] as String,
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        '${child['name']} (${child['gender']})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Umur: ${child['age']} tahun\n${child['desc']}\nBiaya: \$${_fmt(cost)}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.favorite,
                        color: Colors.orange,
                      ),
                      onTap: () => _showAdoptionDialog(child),
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