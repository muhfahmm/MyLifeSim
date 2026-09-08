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
}