// lib/pilih_karakter/customization/settings.dart

import 'package:flutter/material.dart';
import 'package:bitlife/main.dart'; // Untuk mengakses themeNotifier
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';
import 'package:bitlife/store_page/store_page.dart'; // Tambahkan Import ini

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Semua Data?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Semua progres game, karakter, dan pengaturan akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              GlobalSettings.resetAll();
              themeNotifier.value = ThemeMode.light;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua data dan pengaturan berhasil direset!'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('⚙️ Settingan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
          // --- SEKSI TAMPILAN ---
          _buildSectionTitle('Tampilan', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                final bool isDarkMode = mode == ThemeMode.dark;
                return SwitchListTile(
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: isDarkMode ? Colors.yellow.shade700 : Colors.blue,
                  ),
                  title: Text(
                    'Mode Gelap (Dark Mode)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    isDarkMode ? 'Mode gelap aktif' : 'Mode terang aktif',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                  ),
                  value: isDarkMode,
                  onChanged: (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // --- SEKSI AUDIO ---
          _buildSectionTitle('Audio', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.musicEnabled,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.music_note, color: Colors.purple),
                    title: Text(
                      'Musik Latar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.musicEnabled.value = newVal,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.soundEffectsEnabled,
                  builder: (context, val, _) => SwitchListTile(
                    secondary: const Icon(Icons.volume_up, color: Colors.orange),
                    title: Text(
                      'Efek Suara',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.soundEffectsEnabled.value = newVal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // --- SEKSI GAMEPLAY ---
          _buildSectionTitle('Gameplay', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.animationsEnabled,
              builder: (context, val, _) => SwitchListTile(
                secondary: const Icon(Icons.animation, color: Colors.teal),
                title: Text(
                  'Animasi UI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: const Text(
                  'Aktifkan atau nonaktifkan animasi halus',
                  style: TextStyle(fontSize: 12),
                ),
                value: val,
                onChanged: (newVal) => GlobalSettings.animationsEnabled.value = newVal,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // =========================================================
          // --- SEKSI PREFERENSI KONTEN DEWASA (DENGAN PREMIUM GATE) ---
          // =========================================================
          _buildSectionTitle('Preferensi Konten Dewasa', isDark),
          
          // Bungkus seluruh Card dengan ValueListenableBuilder yang mendengarkan status Premium
          ValueListenableBuilder<bool>(
            valueListenable: GlobalSettings.isPremium,
            builder: (context, isPremium, _) {
              
              // Jika BELUM premium, tampilkan tampilan Terkunci (Lock)
              if (!isPremium) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 48,
                          color: isDark ? Colors.orange.shade200 : Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '🔒 Fitur Dewasa Terkunci',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fitur ini hanya tersedia untuk pengguna Premium.\nSilakan aktifkan untuk membuka semua pengaturan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8A5A32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // MENGUBAH ONPRESSED: Arahkan ke Store Page dulu!
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StorePage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.diamond),
                            label: const Text(
                              'Aktifkan Premium Sekarang 💎',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Jika SUDAH premium, tampilkan Toggle seperti biasa
              return Card(
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
                        subtitle: const Text(
                          'Mencegah ajakan dari ayah, ibu, kakak, adik, paman, bibi, dll.',
                          style: TextStyle(fontSize: 12),
                        ),
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
                        subtitle: const Text(
                          'Mencegah ajakan dari teman, guru, rekan kerja, atau orang lain.',
                          style: TextStyle(fontSize: 12),
                        ),
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
                        subtitle: const Text(
                          'Mencegah ajakan hubungan intim dari anggota keluarga.',
                          style: TextStyle(fontSize: 12),
                        ),
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
                        subtitle: const Text(
                          'Mencegah ajakan hubungan intim dari teman, guru, rekan kerja, atau orang lain.',
                          style: TextStyle(fontSize: 12),
                        ),
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
                        subtitle: const Text(
                          'Mencegah ajakan pacaran dari anggota keluarga.',
                          style: TextStyle(fontSize: 12),
                        ),
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
                        subtitle: const Text(
                          'Mencegah ajakan pacaran dari teman, guru, rekan kerja, atau orang lain.',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disablePacaranNonFamily.value = newVal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // =========================================================
          // --- AKHIR SEKSI PREMIUM GATE ---
          // =========================================================
          const SizedBox(height: 8),

          // --- SEKSI DATA & PRIVASI ---
          _buildSectionTitle('Data & Privasi', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(
                'Reset Semua Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: const Text(
                'Hapus semua progres dan mulai dari awal',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: _showResetConfirmation,
            ),
          ),
          const SizedBox(height: 8),

          // --- SEKSI TENTANG ---
          _buildSectionTitle('Tentang', isDark),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: const ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text('Versi Aplikasi', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('v1.0.0 (Latest)', style: TextStyle(fontSize: 12)),
              trailing: Text('Game Simulasi Kehidupan', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}