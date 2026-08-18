// lib/pilih_gender/gender.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/karakter.dart'; // Arahkan ke halaman input nama

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Gender'), backgroundColor: Colors.white, foregroundColor: Colors.black87, elevation: 0, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Apa jenis kelamin karaktermu?', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 32),
                _buildGenderOption(context, gender: 'Laki-laki', icon: Icons.male, iconColor: Colors.blue),
                const SizedBox(height: 16),
                _buildGenderOption(context, gender: 'Perempuan', icon: Icons.female, iconColor: Colors.pink),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(BuildContext context, {required String gender, required IconData icon, required Color iconColor}) {
    return MouseRegion(cursor: SystemMouseCursors.click, child: InkWell(
      onTap: () {
        // Pindah ke halaman Karakter (Input Nama) sambil membawa data gender
        // Konversi gender ke format lowercase untuk sesuai dengan folder assets
        String genderKey = gender.toLowerCase();
        Navigator.push(context, MaterialPageRoute(builder: (context) => KarakterScreen(gender: genderKey)));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300, width: 1.5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 40, color: iconColor), const SizedBox(width: 16), Text(gender, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))]),
      ),
    ));
  }
}