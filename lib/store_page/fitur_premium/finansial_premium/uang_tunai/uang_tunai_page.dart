// lib/store_page/fitur_premium/finansial_premium/uang_tunai/uang_tunai_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class UangTunaiPage extends StatelessWidget {
  final Character character;

  const UangTunaiPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uang Tunai 💵'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Fitur Uang Tunai (Finansial Premium)'),
      ),
    );
  }
}
