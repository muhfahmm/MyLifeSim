// lib/store_page/fitur_premium/finansial_premium/kemewahan/kemewahan_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class KemewahanPage extends StatelessWidget {
  final Character character;

  const KemewahanPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kemewahan 💎', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Fitur Kemewahan (Finansial Premium)'),
      ),
    );
  }
}
