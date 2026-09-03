// lib/pilih_karakter/customization/settings.dart

import 'package:flutter/material.dart';
import 'package:bitlife/main.dart'; // Untuk mengakses themeNotifier
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Pengaturan Persentase Per-Anggota', isDark),
                      ValueListenableBuilder<String>(
                        valueListenable: GlobalSettings.userGender,
                        builder: (context, genderVal, _) {
                          final bool isFemale = genderVal.trim().toLowerCase() == 'perempuan' || genderVal.trim().toLowerCase() == 'female';
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              final String nextGender = isFemale ? 'Laki-laki' : 'Perempuan';
                              GlobalSettings.userGender.value = nextGender;
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gender karakter aktif diubah ke $nextGender'),
                                  duration: const Duration(milliseconds: 900),
                                  backgroundColor: isFemale ? Colors.blue : Colors.pink,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12, top: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isFemale ? Colors.pink.withValues(alpha: 0.15) : Colors.blue.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isFemale ? Icons.female : Icons.male,
                                    color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isFemale ? 'Perempuan' : 'Laki-laki',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade300.withValues(alpha: 0.4), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blueAccent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Catatan: Persentase pada slider di bawah mengatur peluang inisiatif ajakan DARI NPC KE KARAKTER USER (Bukan peluang ajakan user yang diterima oleh NPC).',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.blue.shade100 : Colors.blue.shade900,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              ProposalPercentageSettings.enableAllRelations();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua anggota berhasil DIAKTIFKAN'),
                                  duration: Duration(milliseconds: 900),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.shade400, width: 1),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Aktifkan Semua',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              ProposalPercentageSettings.disableAllRelations();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua anggota berhasil DIMATIKAN'),
                                  duration: Duration(milliseconds: 900),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade400, width: 1),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.highlight_off, color: Colors.redAccent, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Matikan Semua',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Ayah Kandung',
                    icon: Icons.person,
                    iconColor: Colors.blue,
                    relationKey: 'Ayah Kandung',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Ayah Tiri',
                    icon: Icons.person_outline,
                    iconColor: Colors.lightBlue,
                    relationKey: 'Ayah Tiri',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Ayah Mertua',
                    icon: Icons.person_add_alt_1,
                    iconColor: Colors.cyan,
                    relationKey: 'Ayah Mertua',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Ibu Kandung',
                    icon: Icons.face,
                    iconColor: Colors.pink,
                    relationKey: 'Ibu Kandung',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Ibu Tiri',
                    icon: Icons.face_retouching_natural,
                    iconColor: Colors.pinkAccent,
                    relationKey: 'Ibu Tiri',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Ibu Mertua',
                    icon: Icons.face_3,
                    iconColor: Colors.purpleAccent,
                    relationKey: 'Ibu Mertua',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Kakak Laki-laki',
                    icon: Icons.escalator_warning,
                    iconColor: Colors.orange,
                    relationKey: 'Kakak Laki-laki',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Kakak Perempuan',
                    icon: Icons.person_3,
                    iconColor: Colors.deepOrange,
                    relationKey: 'Kakak Perempuan',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Adik Laki-laki',
                    icon: Icons.child_care,
                    iconColor: Colors.teal,
                    relationKey: 'Adik Laki-laki',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Adik Perempuan',
                    icon: Icons.face_6,
                    iconColor: Colors.greenAccent,
                    relationKey: 'Adik Perempuan',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Paman',
                    icon: Icons.record_voice_over,
                    iconColor: Colors.indigo,
                    relationKey: 'Paman',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Pasangan Paman',
                    icon: Icons.people_outline,
                    iconColor: Colors.indigoAccent,
                    relationKey: 'Pasangan Paman',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Bibi',
                    icon: Icons.woman,
                    iconColor: Colors.purple,
                    relationKey: 'Bibi',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Sepupu',
                    icon: Icons.people_alt,
                    iconColor: Colors.amber,
                    relationKey: 'Sepupu',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Kakek',
                    icon: Icons.elderly,
                    iconColor: Colors.brown,
                    relationKey: 'Kakek',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Nenek',
                    icon: Icons.elderly_woman,
                    iconColor: Colors.deepOrange,
                    relationKey: 'Nenek',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Anak / Keponakan',
                    icon: Icons.child_friendly,
                    iconColor: Colors.lightGreen,
                    relationKey: 'Anak / Keponakan',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Guru / Dosen',
                    icon: Icons.school,
                    iconColor: Colors.blueGrey,
                    relationKey: 'Guru / Dosen',
                  ),
                  const RelationPercentageGroupCard(
                    title: 'Teman Sekolah / Rekan Kerja / Idols',
                    icon: Icons.groups,
                    iconColor: Colors.cyan,
                    relationKey: 'Teman Sekolah / Rekan Kerja / Idols',
                  ),
                ],
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