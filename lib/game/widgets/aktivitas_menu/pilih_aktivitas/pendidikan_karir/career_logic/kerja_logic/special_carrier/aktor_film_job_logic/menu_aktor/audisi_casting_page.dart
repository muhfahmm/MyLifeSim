// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/aktor_film_job_logic/menu_aktor/audisi_casting_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'pilih_durasi_kontrak_aktor_modal.dart';

class AudisiCastingPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AudisiCastingPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AudisiCastingPage> createState() => _AudisiCastingPageState();
}

class _AudisiCastingPageState extends State<AudisiCastingPage> {
  void _showAlert(String title, String desc) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(desc, style: const TextStyle(fontSize: 13)),
    );
  }

  void _ikutiCasting(
    String roleTitle,
    String filmGenre,
    int minApp,
    int salary,
    String roleName, {
    bool isAdult18Plus = false,
  }) {
    // SYARAT FITUR PREMIUM & DEWASA 18+
    if (isAdult18Plus) {
      if (!GlobalSettings.isPremium.value) {
        _showAlert(
          'Fitur Premium Terkunci 👑',
          'Kategori Audisi Film Dewasa (18+) memerlukan status Akun Premium.',
        );
        return;
      }

      final isFemale = widget.character.gender.toLowerCase() == 'perempuan';
      final minHealthNeeded = isFemale ? 80 : 75;

      if (widget.character.health < minHealthNeeded) {
        _showAlert(
          'Kesehatan Tidak Mencukupi 🩺',
          'Syarat stamina & kesehatan fisik untuk peran film dewasa (18+) $roleTitle adalah minimal $minHealthNeeded% (${isFemale ? "Wanita: Min 80%" : "Pria: Min 75%"}).\n\n'
          'Kesehatanmu saat ini: ${widget.character.health}%.',
        );
        return;
      }
    }

    // Hanya mengecek penampilan untuk film dewasa 18+ jika minApp > 0
    if (isAdult18Plus && minApp > 0 && widget.character.appearance < minApp) {
      _showAlert(
        'Casting Gagal 🎭',
        'Penampilan dan pesonamu belum memenuhi syarat minimal casting $roleTitle (Min. $minApp%).',
      );
      return;
    }

    final r = Random();
    final bool isPassed = r.nextInt(100) < (widget.character.appearance + widget.character.popularity) ~/ 2 + 20;

    if (isPassed) {
      PilihDurasiKontrakAktorModal.show(
        context,
        character: widget.character,
        roleTitle: roleTitle,
        filmGenre: filmGenre,
        roleName: roleName,
        salary: salary,
        onSelected: (int contractYears) {
          widget.character.jobName = 'Aktor Film: $roleName ($filmGenre)';
          widget.character.jobSalary = salary;
          widget.character.contractYears = contractYears;
          widget.character.popularity = (widget.character.popularity + 6).clamp(0, 100);
          widget.character.followers += r.nextInt(2000) + 1000;
          widget.character.generateCoworkersIfEmpty();
          if (mounted) setState(() {});
          widget.onRefresh();

          final pageContext = context;
          DialogHelper.show(
            context: pageContext,
            title: 'Lolos Casting & Kontrak Diteken! 🎬🌟',
            content: Text(
              'Selamat! Sutradara sangat terkesan dengan aktingmu!\n\n'
              '• Peran Resmi: $roleName ($filmGenre)\n'
              '• Durasi Kontrak: $contractYears Tahun\n'
              '• Gaji Per Film: ${CurrencySettings.format(salary.toDouble())}\n'
              '• Popularitas: +6%',
              style: const TextStyle(fontSize: 13),
            ),
            showCloseButton: false,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(pageContext);
                  Navigator.of(pageContext).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showAlert(
        'Belum Berhasil Lolos 🎭',
        'Sutradara memilih kandidat lain untuk peran ini. Cobalah mengasah akting dan penampilanmu lagi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isFemale = widget.character.gender.toLowerCase() == 'perempuan';
    final reqHealth = isFemale ? 80 : 75;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audisi & Casting Film 🎬'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // HEADER KARTU CASTING
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.theater_comedy, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pesona & Stamina Aktor', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(
                          'Penampilan: ${widget.character.appearance}% ✨ • Kesehatan: ${widget.character.health}% ❤️',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.purple.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text('Daftar Project Casting Terbuka 📽️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),

          _buildCastingCard('Aktor Utama Action Laga 💥', 'Film Action Blockbuster', 0, 450000, 'Aktor Utama Action', isDark),
          _buildCastingCard('Pemeran Utama Drama Romantis ❤️', 'Film Drama Layar Lebar', 0, 300000, 'Pemeran Utama Drama', isDark),
          _buildCastingCard('Pemeran Antagonis / Villain 🦹‍♂️', 'Film Thriller & Misteri', 0, 250000, 'Pemeran Antagonis', isDark),
          _buildCastingCard('Pemeran Pendukung (Supporting Actor) 🎭', 'Film Komedi / Horror', 0, 150000, 'Aktor Pendukung', isDark),
          _buildCastingCard('Pemeran Figuran (Extras) 🎬', 'Film FTV & Layar Lebar', 0, 50000, 'Pemeran Figuran', isDark),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                const Text('Kategori Film Dewasa (18+) 🔞', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.pink)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.amber.shade700, borderRadius: BorderRadius.circular(6)),
                  child: const Text('PREMIUM 👑', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),

          _buildCastingCard(
            'Bintang Utama Film Dewasa 18+ 🔥',
            'Film Dewasa Eksklusif 18+',
            0,
            600000,
            'Bintang Utama 18+',
            isDark,
            isAdult18Plus: true,
            reqHealth: reqHealth,
          ),
          _buildCastingCard(
            'Pemeran Film Glamour Sensual 💋',
            'Film Sensual & Glamour 18+',
            0,
            400000,
            'Pemeran Sensual 18+',
            isDark,
            isAdult18Plus: true,
            reqHealth: reqHealth,
          ),
        ],
      ),
    );
  }

  Widget _buildCastingCard(
    String title,
    String genre,
    int minApp,
    int salary,
    String roleName,
    bool isDark, {
    bool isAdult18Plus = false,
    int? reqHealth,
  }) {
    final String reqText = isAdult18Plus
        ? '$genre\nFee: ${CurrencySettings.format(salary.toDouble())} • Min. Kesehatan $reqHealth%'
        : '$genre\nFee: ${CurrencySettings.format(salary.toDouble())}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isAdult18Plus
              ? Colors.pink.shade400
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          width: isAdult18Plus ? 1.5 : 1.0,
        ),
      ),
      color: isAdult18Plus
          ? (isDark ? Colors.pink.shade900.withValues(alpha: 0.25) : Colors.pink.shade50)
          : (isDark ? Colors.grey.shade800 : Colors.white),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAdult18Plus ? Colors.pink : Colors.purple,
          child: Icon(isAdult18Plus ? Icons.explicit : Icons.movie, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isAdult18Plus ? (isDark ? Colors.pink.shade200 : Colors.pink.shade900) : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(reqText, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isAdult18Plus ? Colors.pink.shade700 : Colors.purple.shade700,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _ikutiCasting(
            title,
            genre,
            minApp,
            salary,
            roleName,
            isAdult18Plus: isAdult18Plus,
          ),
          child: const Text('Audisi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
