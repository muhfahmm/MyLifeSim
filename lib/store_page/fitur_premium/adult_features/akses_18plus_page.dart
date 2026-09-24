import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/pilih_karakter/settings/kategori_persentase/keluarga/keluarga_settings_page.dart';
import 'package:mylifesim/pilih_karakter/settings/kategori_persentase/teman_sekolah/teman_sekolah_settings_page.dart';
import 'package:mylifesim/pilih_karakter/settings/kategori_persentase/teman_kerja/teman_kerja_settings_page.dart';

class Akses18PlusPage extends StatelessWidget {
  const Akses18PlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyR) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Akses18PlusPage(),
              transitionDuration: Duration.zero,
            ),
          );
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
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
          actions: [
            ValueListenableBuilder<String>(
              valueListenable: GlobalSettings.userGender,
              builder: (context, genderVal, _) {
                final bool isFemale = genderVal.trim().toLowerCase() == 'perempuan' || genderVal.trim().toLowerCase() == 'female';
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isFemale ? 'Perempuan' : 'Laki-laki',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 12, bottom: 8),
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
            
            // CARD BERISI TOGGLE NONAKTIFKAN
            // CARD BERISI TOGGLE NONAKTIFKAN
            ListenableBuilder(
              listenable: Listenable.merge([
                GlobalSettings.isPremium,
                GlobalSettings.isMasturbationUnlocked,
                GlobalSettings.isMakeLoveUnlocked,
                GlobalSettings.isIncestUnlocked,
                GlobalSettings.isTeacherStudentUnlocked,
              ]),
              builder: (context, _) {
                final bool isFullPremium = GlobalSettings.isPremium.value;
                final bool isMasturbasiUnlocked = isFullPremium || GlobalSettings.isMasturbationUnlocked.value;
                final bool isMakeLoveUnlocked = isFullPremium || GlobalSettings.isMakeLoveUnlocked.value;
                final bool isIncestUnlocked = isFullPremium || GlobalSettings.isIncestUnlocked.value;

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      // Toggle Masturbasi (Keluarga) -> Butuh Masturbasi & Inses
                      _buildDisableSwitchTile(
                        context: context,
                        isDark: isDark,
                        icon: Icons.block,
                        iconColor: Colors.redAccent,
                        title: 'Nonaktifkan Ajakan Masturbasi (Keluarga)',
                        subtitle: 'Mencegah ajakan dari ayah, ibu, kakak, adik, paman, bibi, dll.',
                        valueNotifier: GlobalSettings.disableMasturbationFamily,
                        isUnlocked: isMasturbasiUnlocked && isIncestUnlocked,
                        lockReason: 'Membutuhkan Fitur Masturbasi & Hubungan Inses',
                      ),
                      const Divider(height: 1),
                      // Toggle Masturbasi (Non-Keluarga) -> Butuh Masturbasi
                      _buildDisableSwitchTile(
                        context: context,
                        isDark: isDark,
                        icon: Icons.group,
                        iconColor: Colors.orange,
                        title: 'Nonaktifkan Ajakan Masturbasi (Non-Keluarga)',
                        subtitle: 'Mencegah ajakan dari teman, guru, rekan kerja, atau orang lain.',
                        valueNotifier: GlobalSettings.disableMasturbationNonFamily,
                        isUnlocked: isMasturbasiUnlocked,
                        lockReason: 'Membutuhkan Fitur Masturbasi',
                      ),
                      const Divider(height: 1),
                      // Toggle Make Love (Keluarga) -> Butuh ML & Inses
                      _buildDisableSwitchTile(
                        context: context,
                        isDark: isDark,
                        icon: Icons.favorite,
                        iconColor: Colors.pinkAccent,
                        title: 'Nonaktifkan Ajakan Make Love (Keluarga)',
                        subtitle: 'Mencegah ajakan hubungan intim dari anggota keluarga.',
                        valueNotifier: GlobalSettings.disableMakeLoveFamily,
                        isUnlocked: isMakeLoveUnlocked && isIncestUnlocked,
                        lockReason: 'Membutuhkan Hubungan Dewasa (ML) & Hubungan Inses',
                      ),
                      const Divider(height: 1),
                      // Toggle Make Love (Non-Keluarga) -> Butuh ML
                      _buildDisableSwitchTile(
                        context: context,
                        isDark: isDark,
                        icon: Icons.people,
                        iconColor: Colors.blueAccent,
                        title: 'Nonaktifkan Ajakan Make Love (Non-Keluarga)',
                        subtitle: 'Mencegah ajakan hubungan intim dari teman, guru, rekan kerja, atau orang lain.',
                        valueNotifier: GlobalSettings.disableMakeLoveNonFamily,
                        isUnlocked: isMakeLoveUnlocked,
                        lockReason: 'Membutuhkan Hubungan Dewasa (ML)',
                      ),
                      const Divider(height: 1),
                      // Toggle Pacaran (Keluarga) -> Butuh Inses
                      _buildDisableSwitchTile(
                        context: context,
                        isDark: isDark,
                        icon: Icons.heart_broken,
                        iconColor: Colors.red,
                        title: 'Nonaktifkan Ajakan Pacaran (Keluarga)',
                        subtitle: 'Mencegah ajakan pacaran dari anggota keluarga.',
                        valueNotifier: GlobalSettings.disablePacaranFamily,
                        isUnlocked: isIncestUnlocked,
                        lockReason: 'Membutuhkan Hubungan Inses (Keluarga)',
                      ),
                      const Divider(height: 1),
                      // Toggle Pacaran (Non-Keluarga) -> Selalu Terbuka jika masuk 18+
                      _buildDisableSwitchTile(
                        context: context,
                        isDark: isDark,
                        icon: Icons.person_add_disabled,
                        iconColor: Colors.deepOrange,
                        title: 'Nonaktifkan Ajakan Pacaran (Non-Keluarga)',
                        subtitle: 'Mencegah ajakan pacaran dari teman, guru, rekan kerja, atau orang lain.',
                        valueNotifier: GlobalSettings.disablePacaranNonFamily,
                        isUnlocked: true,
                        lockReason: '',
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // HEADER PERSENTASE PER ANGGOTA (DENGAN GROUPING KATEGORI)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 12, bottom: 6, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PENGATURAN PERSENTASE AJAKAN PACARAN, MAKE LOVE & MASTURBASI',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
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
                ],
              ),
            ),
            const SizedBox(height: 8),

            // CARD NAVIGATION BUTTONS UNTUK 3 KATEGORI PERSENTASE (GROUPING)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.family_restroom, color: Colors.blueAccent, size: 28),
                    title: Text(
                      'Keluarga',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text(
                      'Atur persentase ajakan untuk Ayah, Ibu, Kakak, Adik, Paman, Sepupu, dll.',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const KeluargaSettingsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.school, color: Colors.amber, size: 28),
                    title: Text(
                      'Teman Sekolah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text(
                      'Atur persentase ajakan untuk Guru, Dosen, dan Teman Sekelas/Sekolah.',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TemanSekolahSettingsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.work, color: Colors.deepPurpleAccent, size: 28),
                    title: Text(
                      'Teman Kerja',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: const Text(
                      'Atur persentase ajakan untuk Bos, Atasan, Supervisor, dan Rekan Kerja.',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TemanKerjaSettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisableSwitchTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required ValueNotifier<bool> valueNotifier,
    required bool isUnlocked,
    required String lockReason,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, val, _) {
        return AbsorbPointer(
          absorbing: !isUnlocked,
          child: Opacity(
            opacity: isUnlocked ? 1.0 : 0.45,
            child: SwitchListTile(
              secondary: Icon(
                isUnlocked ? icon : Icons.lock,
                color: isUnlocked ? iconColor : Colors.grey,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
                      ),
                    ),
                  ),
                  if (!isUnlocked) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade300, width: 0.8),
                      ),
                      child: const Text(
                        'Tertutup 🔒',
                        style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: isUnlocked ? null : Colors.grey),
                  ),
                  if (!isUnlocked && lockReason.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '🔒 $lockReason',
                      style: const TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
              value: isUnlocked ? val : false,
              onChanged: isUnlocked ? (newVal) => valueNotifier.value = newVal : null,
            ),
          ),
        );
      },
    );
  }
}
