// lib/store_page/fitur_premium/assets_premium/casino/casino_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CasinoPage extends StatelessWidget {
  final Character character;

  const CasinoPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casino 🎲'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Fitur Casino (Assets Premium)'),
      ),
    );
  }
}
