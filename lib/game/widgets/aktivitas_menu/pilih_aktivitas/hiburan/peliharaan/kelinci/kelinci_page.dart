// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/kelinci/kelinci_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/pet_lifespan_logic.dart';
import 'database_kelinci.dart';

class KelinciPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const KelinciPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<KelinciPage> createState() => _KelinciPageState();
}

class _KelinciPageState extends State<KelinciPage> {
  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  static const _names = [
    'Bunny', 'Snowball', 'Cotton', 'Clover', 'Mimi', 'Pompom', 'Bibi', 'Thumper', 'Peter', 'Bugs',
    'Fluffy', 'Hazel', 'Pip', 'Hop', 'Nibbles', 'Patches', 'Oreo', 'Coco', 'Pepper', 'Cinnamon',
    'Honey', 'Sugar', 'Butter', 'Muffin', 'Cookie', 'Cupcake', 'Brownie', 'Pudding', 'Caramel', 'Marshmallow',
    'Waffles', 'Pancake', 'Noodle', 'Tofu', 'Boba', 'Cheeto', 'Salami', 'Biscuit', 'Kiwi', 'Mango',
    'Peach', 'Pumpkin', 'Daisy', 'Poppy', 'Rosie', 'Ruby', 'Penny', 'Zelda', 'Willow', 'Olive',
    'Stella', 'Lulu', 'Maya', 'Sophie', 'Piper', 'Angel', 'Princess', 'Bella', 'Lucy', 'Lily',
    'Chloe', 'Zoe', 'Mia', 'Nala', 'Sassy', 'Cleo', 'Penelope', 'Fiona', 'Sadie', 'Lola',
    'Gigi', 'Kiki', 'Dixie', 'Roxy', 'Macy', 'Callie', 'Sasha', 'Phoebe', 'Dakota', 'Lila',
    'Izzy', 'Gracie', 'Abby', 'Ella', 'Molly', 'Maggie', 'Bailey', 'Hannah', 'Marley', 'Harley',
    'Lia', 'Trixie', 'Fifi', 'Snickers', 'Teddy', 'Bumper', 'Skippy', 'Hoppy', 'Jumper', 'Ziggy'
  ];

  void _executeAdopsi(BuildContext context, Map<String, dynamic> h) {
    final int cost = h['cost'] as int;
    final int happinessBoost = h['happiness'] as int;
    final petName = _names[Random().nextInt(_names.length)];

    setState(() {
      widget.character.money -= cost;
      widget.character.happiness = (widget.character.happiness + happinessBoost).clamp(0, 100);
      widget.character.pets.add({
        'name': petName,
        'breed': h['name'] as String,
        'type': 'Kelinci',
        'emoji': '🐇',
        'gender': Random().nextBool() ? 'Jantan' : 'Betina',
        'age': PetLifespanLogic.generateInitialAge(),
        'maxAge': PetLifespanLogic.generateMaxAge('Kelinci'),
        'happiness': happinessBoost,
        'relationship': 80,
        'cost': cost,
      });
    });

    final msg = '🐇 Kamu mengadopsi ${h['name']} bernama $petName! (+${h['happiness']}% Kebahagiaan, -${_fmt(cost)})';
    widget.character.inbox.add(msg);

    showDialog(
      context: context,
      builder: (ctx2) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Selamat Datang!', style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _executeMintaOrangTua(BuildContext context, Map<String, dynamic> h) {
    final int happinessBoost = h['happiness'] as int;
    final int cost = h['cost'] as int;
    final String itemName = h['name'] as String;

    final bool success = Random().nextInt(100) < 80;

    if (success) {
      final petName = _names[Random().nextInt(_names.length)];
      setState(() {
        widget.character.happiness = (widget.character.happiness + happinessBoost).clamp(0, 100);
        widget.character.pets.add({
          'name': petName,
          'breed': itemName,
          'type': 'Kelinci',
          'emoji': '🐇',
          'gender': Random().nextBool() ? 'Jantan' : 'Betina',
          'age': PetLifespanLogic.generateInitialAge(),
          'maxAge': PetLifespanLogic.generateMaxAge('Kelinci'),
          'happiness': happinessBoost,
          'relationship': 80,
          'cost': cost,
        });
      });

      final msg = '🐇 Orang tua kamu menyetujui permintaanmu dan membelikan $itemName bernama $petName! (+$happinessBoost% Kebahagiaan)';
      widget.character.inbox.add(msg);

      showDialog(
        context: context,
        builder: (ctx2) => AlertDialog(
          title: const Row(children: [
            Icon(Icons.sentiment_very_satisfied, color: Colors.green),
            SizedBox(width: 8),
            Text('Disetujui! 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
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
    } else {
      final msg = '🐇 Orang tua kamu menolak untuk membelikan $itemName.';
      widget.character.inbox.add(msg);

      showDialog(
        context: context,
        builder: (ctx2) => AlertDialog(
          title: const Row(children: [
            Icon(Icons.sentiment_dissatisfied, color: Colors.red),
            SizedBox(width: 8),
            Text('Ditolak! 😔', style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx2),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void _showPurchaseOptions(BuildContext context, Map<String, dynamic> h) {
    final int cost = h['cost'] as int;
    final String itemName = h['name'] as String;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bool canAfford = widget.character.money >= cost;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🐇', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Harga: ${_fmt(cost)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.greenAccent : Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                h['desc'] ?? '',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Metode Pembelian:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
                title: const Text('Beli Sendiri', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  canAfford
                      ? 'Saldo Anda: ${_fmt(widget.character.money)}'
                      : 'Saldo Anda tidak cukup (${_fmt(widget.character.money)})',
                  style: TextStyle(color: canAfford ? Colors.grey : Colors.red),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  if (canAfford) {
                    _executeAdopsi(context, h);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Uang Anda tidak cukup untuk membeli $itemName secara mandiri.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                leading: const Icon(Icons.family_restroom, color: Colors.blue),
                title: const Text('Minta Orang Tua Membelikan', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Peluang disetujui: 80%', style: TextStyle(color: Colors.blueAccent)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  _executeMintaOrangTua(context, h);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color containerBg = isDark ? Colors.grey.shade900 : Colors.white;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;

    const list = DatabaseKelinci.listKelinci;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopsi Kelinci 🐇', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: containerBg,
        foregroundColor: textColor,
        elevation: 0.5,
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: containerBg,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: ${_fmt(widget.character.money)}',
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
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final h = list[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        h['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${h['desc']}\nHarga: ${_fmt(h['cost'] as int)}',
                          style: TextStyle(
                            color: subtextColor,
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Icon(
                        Icons.favorite,
                        color: isDark ? Colors.pinkAccent : Colors.pink,
                      ),
                      onTap: () => _showPurchaseOptions(context, h),
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
