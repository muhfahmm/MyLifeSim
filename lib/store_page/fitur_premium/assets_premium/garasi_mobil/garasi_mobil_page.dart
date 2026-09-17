// lib/store_page/fitur_premium/assets_premium/garasi_mobil/garasi_mobil_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class GarasiMobilPage extends StatelessWidget {
  final Character character;

  const GarasiMobilPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garasi Mobil 🚗', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Fitur Garasi Mobil (Assets Premium)'),
      ),
    );
  }
}
