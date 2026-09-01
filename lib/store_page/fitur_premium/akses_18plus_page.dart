  // lib/store_page/fitur_premium/akses_18plus.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';

class Akses18PlusPage extends StatelessWidget {
  const Akses18PlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Akses 18+ Premium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
            child: Text(
              'PREFERENSI KONTEN DEWASA',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          // CARD BERISI TOGGLE (SAMA PERSIS DENGAN SETTINGS)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.disableMasturbationFamily,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.block, color: Colors.redAccent),
                    title: Text(
                      'Nonaktifkan Ajakan Masturbasi (Keluarga)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text('Mencegah ajakan dari ayah, ibu, kakak, adik, paman, bibi, dll.', style: TextStyle(fontSize: 12)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.disableMasturbationFamily.value = newVal,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.disableMasturbationNonFamily,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.group, color: Colors.orange),
                    title: Text(
                      'Nonaktifkan Ajakan Masturbasi (Non-Keluarga)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text('Mencegah ajakan dari teman, guru, rekan kerja, atau orang lain.', style: TextStyle(fontSize: 12)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.disableMasturbationNonFamily.value = newVal,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.disableMakeLoveFamily,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.favorite, color: Colors.pinkAccent),
                    title: Text(
                      'Nonaktifkan Ajakan Make Love (Keluarga)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text('Mencegah ajakan hubungan intim dari anggota keluarga.', style: TextStyle(fontSize: 12)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.disableMakeLoveFamily.value = newVal,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.disableMakeLoveNonFamily,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.people, color: Colors.blueAccent),
                    title: Text(
                      'Nonaktifkan Ajakan Make Love (Non-Keluarga)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text('Mencegah ajakan hubungan intim dari teman, guru, rekan kerja, atau orang lain.', style: TextStyle(fontSize: 12)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.disableMakeLoveNonFamily.value = newVal,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.disablePacaranFamily,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.heart_broken, color: Colors.red),
                    title: Text(
                      'Nonaktifkan Ajakan Pacaran (Keluarga)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text('Mencegah ajakan pacaran dari anggota keluarga.', style: TextStyle(fontSize: 12)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.disablePacaranFamily.value = newVal,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.disablePacaranNonFamily,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.person_add_disabled, color: Colors.deepOrange),
                    title: Text(
                      'Nonaktifkan Ajakan Pacaran (Non-Keluarga)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text('Mencegah ajakan pacaran dari teman, guru, rekan kerja, atau orang lain.', style: TextStyle(fontSize: 12)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.disablePacaranNonFamily.value = newVal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}