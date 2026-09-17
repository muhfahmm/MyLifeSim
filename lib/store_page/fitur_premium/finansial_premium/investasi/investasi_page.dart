// lib/store_page/fitur_premium/finansial_premium/investasi/investasi_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class InvestasiPage extends StatelessWidget {
  final Character character;

  const InvestasiPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investasi 📈'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Fitur Investasi (Finansial Premium)'),
      ),
    );
  }
}
