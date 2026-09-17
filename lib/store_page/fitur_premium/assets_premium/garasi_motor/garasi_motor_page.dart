// lib/store_page/fitur_premium/assets_premium/garasi_motor/garasi_motor_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class GarasiMotorPage extends StatelessWidget {
  final Character character;

  const GarasiMotorPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garasi Motor 🏍️'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Fitur Garasi Motor (Assets Premium)'),
      ),
    );
  }
}
