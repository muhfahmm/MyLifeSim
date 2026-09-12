import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class RekanTimPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanTimPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rekan Tim & Pelatih 🏸'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_alt, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                'Daftar Skuad & Pelatih',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Hubungan baik dengan rekan tim dan pelatih meningkatkan kekompakan bertanding!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
