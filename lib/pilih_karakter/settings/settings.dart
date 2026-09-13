// lib/pilih_karakter/customization/settings.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/main.dart'; // Untuk mengakses themeNotifier
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/store_page/store_page.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showResetConfirmation() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              'Reset Semua Data?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          'Semua progres game, karakter, dan pengaturan akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              GlobalSettings.resetAll();
              themeNotifier.value = ThemeMode.light;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua data dan pengaturan berhasil direset!'), backgroundColor: Colors.redAccent),
              );
            },
            child: const Text('Reset Permanen', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          '⚙️ Settingan',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textColor),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, size: 18, color: textColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // --- SEKSI TAMPILAN ---
          _buildSectionTitle('Tampilan', subtextColor),
          Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) {
                    final bool isDarkMode = mode == ThemeMode.dark;
                    return SwitchListTile(
                      activeThumbColor: Colors.amber,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      secondary: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (isDarkMode ? Colors.amber : Colors.blue).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: isDarkMode ? Colors.amber : Colors.blue,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Mode Gelap (Dark Mode)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        isDarkMode ? 'Mode gelap aktif' : 'Mode terang aktif',
                        style: TextStyle(fontSize: 12, color: subtextColor),
                      ),
                      value: isDarkMode,
                      onChanged: (val) {
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      },
                    );
                  },
                ),
                Divider(height: 1, color: borderColor),
                ValueListenableBuilder<CurrencyModel>(
                  valueListenable: CurrencySettings.selectedCurrency,
                  builder: (context, curr, _) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                          shape: BoxShape.circle,
                        ),
                        child: Text(curr.flag, style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(
                        'Mata Uang Game',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        '${curr.name} (${curr.code} / ${curr.symbol})',
                        style: TextStyle(fontSize: 12, color: subtextColor),
                      ),
                      trailing: Icon(Icons.chevron_right_rounded, size: 18, color: subtextColor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CurrencySettingsPage()),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // --- SEKSI AUDIO ---
          _buildSectionTitle('Audio', subtextColor),
          Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.musicEnabled,
                  builder: (context, val, _) => SwitchListTile(
                    activeThumbColor: Colors.purpleAccent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.music_note_rounded, color: Colors.purpleAccent, size: 20),
                    ),
                    title: Text(
                      'Musik Latar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text('Aktifkan musik latar game', style: TextStyle(fontSize: 12, color: subtextColor)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.musicEnabled.value = newVal,
                  ),
                ),
                Divider(height: 1, color: borderColor),
                ValueListenableBuilder<bool>(
                  valueListenable: GlobalSettings.soundEffectsEnabled,
                  builder: (context, val, _) => SwitchListTile(
                    activeThumbColor: Colors.orangeAccent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.volume_up_rounded, color: Colors.orangeAccent, size: 20),
                    ),
                    title: Text(
                      'Efek Suara',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text('Efek suara tombol & aktivitas', style: TextStyle(fontSize: 12, color: subtextColor)),
                    value: val,
                    onChanged: (newVal) => GlobalSettings.soundEffectsEnabled.value = newVal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // --- SEKSI GAMEPLAY ---
          _buildSectionTitle('Gameplay', subtextColor),
          Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.animationsEnabled,
              builder: (context, val, _) => SwitchListTile(
                activeThumbColor: Colors.tealAccent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.animation_rounded, color: Colors.teal, size: 20),
                ),
                title: Text(
                  'Animasi UI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: textColor,
                  ),
                ),
                subtitle: Text(
                  'Aktifkan atau nonaktifkan animasi halus',
                  style: TextStyle(fontSize: 12, color: subtextColor),
                ),
                value: val,
                onChanged: (newVal) => GlobalSettings.animationsEnabled.value = newVal,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // =========================================================
          // --- SEKSI PREFERENSI KONTEN DEWASA (DENGAN PREMIUM GATE) ---
          // =========================================================
          _buildSectionTitle('Preferensi Konten Dewasa', subtextColor),

          ValueListenableBuilder<bool>(
            valueListenable: GlobalSettings.isPremium,
            builder: (context, isPremium, _) {
              if (!isPremium) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.lock_rounded, size: 26, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '🔒 Fitur Dewasa Terkunci',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Fitur ini hanya tersedia untuk pengguna Premium.\nAktifkan untuk membuka semua kontrol preferensi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: subtextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD97706),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StorePage()),
                            );
                          },
                          icon: const Icon(Icons.diamond_rounded, size: 18),
                          label: const Text(
                            'Aktifkan Premium Sekarang 💎',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Jika SUDAH premium
              return Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.disableMasturbationFamily,
                      builder: (context, val, _) => SwitchListTile(
                        activeThumbColor: Colors.redAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        secondary: const Icon(Icons.block, color: Colors.redAccent),
                        title: Text(
                          'Nonaktifkan Ajakan Masturbasi (Keluarga)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
                        ),
                        subtitle: Text('Mencegah ajakan dari anggota keluarga.', style: TextStyle(fontSize: 11.5, color: subtextColor)),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disableMasturbationFamily.value = newVal,
                      ),
                    ),
                    Divider(height: 1, color: borderColor),
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.disableMasturbationNonFamily,
                      builder: (context, val, _) => SwitchListTile(
                        activeThumbColor: Colors.orangeAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        secondary: const Icon(Icons.group, color: Colors.orange),
                        title: Text(
                          'Nonaktifkan Ajakan Masturbasi (Non-Keluarga)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
                        ),
                        subtitle: Text('Mencegah ajakan dari teman, guru, atau rekan kerja.', style: TextStyle(fontSize: 11.5, color: subtextColor)),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disableMasturbationNonFamily.value = newVal,
                      ),
                    ),
                    Divider(height: 1, color: borderColor),
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.disableMakeLoveFamily,
                      builder: (context, val, _) => SwitchListTile(
                        activeThumbColor: Colors.pinkAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        secondary: const Icon(Icons.favorite, color: Colors.pinkAccent),
                        title: Text(
                          'Nonaktifkan Ajakan Make Love (Keluarga)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
                        ),
                        subtitle: Text('Mencegah ajakan hubungan intim dari keluarga.', style: TextStyle(fontSize: 11.5, color: subtextColor)),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disableMakeLoveFamily.value = newVal,
                      ),
                    ),
                    Divider(height: 1, color: borderColor),
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.disableMakeLoveNonFamily,
                      builder: (context, val, _) => SwitchListTile(
                        activeThumbColor: Colors.blueAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        secondary: const Icon(Icons.people, color: Colors.blueAccent),
                        title: Text(
                          'Nonaktifkan Ajakan Make Love (Non-Keluarga)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
                        ),
                        subtitle: Text('Mencegah ajakan hubungan intim dari non-keluarga.', style: TextStyle(fontSize: 11.5, color: subtextColor)),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disableMakeLoveNonFamily.value = newVal,
                      ),
                    ),
                    Divider(height: 1, color: borderColor),
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.disablePacaranFamily,
                      builder: (context, val, _) => SwitchListTile(
                        activeThumbColor: Colors.redAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        secondary: const Icon(Icons.heart_broken, color: Colors.red),
                        title: Text(
                          'Nonaktifkan Ajakan Pacaran (Keluarga)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
                        ),
                        subtitle: Text('Mencegah ajakan pacaran dari anggota keluarga.', style: TextStyle(fontSize: 11.5, color: subtextColor)),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disablePacaranFamily.value = newVal,
                      ),
                    ),
                    Divider(height: 1, color: borderColor),
                    ValueListenableBuilder<bool>(
                      valueListenable: GlobalSettings.disablePacaranNonFamily,
                      builder: (context, val, _) => SwitchListTile(
                        activeThumbColor: Colors.deepOrangeAccent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        secondary: const Icon(Icons.person_add_disabled, color: Colors.deepOrange),
                        title: Text(
                          'Nonaktifkan Ajakan Pacaran (Non-Keluarga)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textColor),
                        ),
                        subtitle: Text('Mencegah ajakan pacaran dari non-keluarga.', style: TextStyle(fontSize: 11.5, color: subtextColor)),
                        value: val,
                        onChanged: (newVal) => GlobalSettings.disablePacaranNonFamily.value = newVal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // --- SEKSI DATA & PRIVASI ---
          _buildSectionTitle('Data & Privasi', subtextColor),
          Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 20),
              ),
              title: const Text(
                'Reset Semua Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                  color: Colors.redAccent,
                ),
              ),
              subtitle: Text(
                'Hapus semua progres dan mulai dari awal',
                style: TextStyle(fontSize: 12, color: subtextColor),
              ),
              trailing: Icon(Icons.chevron_right_rounded, size: 18, color: subtextColor),
              onTap: _showResetConfirmation,
            ),
          ),
          const SizedBox(height: 12),

          // --- SEKSI TENTANG ---
          _buildSectionTitle('Tentang', subtextColor),
          Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 20),
              ),
              title: Text('Versi Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textColor)),
              subtitle: Text('v1.0.0 (Latest)', style: TextStyle(fontSize: 12, color: subtextColor)),
              trailing: Text('MyLifeSim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: subtextColor)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color subtextColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: subtextColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
