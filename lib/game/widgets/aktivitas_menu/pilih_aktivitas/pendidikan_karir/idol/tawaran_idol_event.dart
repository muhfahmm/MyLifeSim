// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/idol/tawaran_idol_event.dart
//
// Event: General Manager Idol menawarkan kontrak kepada karakter perempuan usia 10–15.
// Cara pakai:
//   TawaranIdolEvent.cekDanTampilkan(context: ctx, character: _character, onComplete: () => setState(() {}));

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'persentase_tawaran_idol.dart';

class TawaranIdolEvent {
  // ================================================================
  // DATA NAMA GM & AGENSI
  // ================================================================
  static const List<String> _namaGM = [
    'Kim Tae-yeon', 'Park Ji-hoon', 'Lee Soo-man',
    'Choi Yoo-jin', 'Han Seung-woo', 'Yoon Mi-rae',
  ];

  static const List<Map<String, String>> _agensi = [
    {'nama': 'StarLight Entertainment', 'emoji': '⭐'},
    {'nama': 'Nova Music Agency', 'emoji': '🌟'},
    {'nama': 'Lumina Idol Group', 'emoji': '💎'},
    {'nama': 'Harmony Records', 'emoji': '🎵'},
    {'nama': 'Crystal Star Management', 'emoji': '✨'},
  ];

  // Gaji kontrak (per bulan, dalam satuan game money)
  static const int gajiKontrak = 2500000;

  // ================================================================
  // ENTRY POINT
  // ================================================================

  /// Cek probabilitas dan tampilkan dialog jika event muncul.
  static void cekDanTampilkan({
    required BuildContext context,
    required Character character,
    required VoidCallback onComplete,
  }) {
    if (!PersentaseTawaranIdol.memenuhiSyarat(character)) return;
    final int roll = Random().nextInt(100);
    if (!PersentaseTawaranIdol.apakahEventMuncul(character, roll)) return;

    final String namaGM = _namaGM[Random().nextInt(_namaGM.length)];
    final Map<String, String> agensi = _agensi[Random().nextInt(_agensi.length)];
    final int prob = PersentaseTawaranIdol.hitungProbabilitas(character);

    _tampilkanDialogTawaran(
      context: context,
      character: character,
      namaGM: namaGM,
      namaAgensi: agensi['nama']!,
      emojiAgensi: agensi['emoji']!,
      probabilitas: prob,
      onComplete: onComplete,
    );
  }

  // ================================================================
  // DIALOG UTAMA: Tawaran Kontrak
  // ================================================================
  static void _tampilkanDialogTawaran({
    required BuildContext context,
    required Character character,
    required String namaGM,
    required String namaAgensi,
    required String emojiAgensi,
    required int probabilitas,
    required VoidCallback onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFFFF8E1),
          title: Row(
            children: [
              Text(emojiAgensi, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tawaran Kontrak Idol!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$namaGM, General Manager dari $namaAgensi, menemuimu dan menawarkan kontrak untuk menjadi idol profesional!',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBadge(
                icon: Icons.star,
                label: 'Agensi: $namaAgensi',
                color: Colors.amber,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              _buildBadge(
                icon: Icons.attach_money,
                label: 'Gaji: Rp ${_fmt(gajiKontrak)} / bulan',
                color: Colors.green,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              _buildBadge(
                icon: Icons.trending_up,
                label: 'Peluang tawaran ini: $probabilitas%',
                color: Colors.blue,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              Text(
                '⚠️ Latihan idol sangat intens. Kesehatanmu akan terkuras, namun ketenaran menantimu!',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.orangeAccent : Colors.orange.shade700,
                ),
              ),
            ],
          ),
          actions: [
            // Tolak
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _eksekusiTolak(context, character, namaGM, namaAgensi, onComplete);
              },
              child: Text(
                'Tolak',
                style: TextStyle(
                  color: isDark ? Colors.redAccent : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Terima
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.amber.shade900 : const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _eksekusiTerima(context, character, namaGM, namaAgensi, emojiAgensi, onComplete);
                },
                child: Text(
                  'Terima Kontrak $emojiAgensi',
                  style: TextStyle(
                    color: isDark ? Colors.amberAccent : Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // EKSEKUSI: Terima kontrak
  // ================================================================
  static void _eksekusiTerima(
    BuildContext context,
    Character character,
    String namaGM,
    String namaAgensi,
    String emojiAgensi,
    VoidCallback onComplete,
  ) {
    // Set status idol
    if (!character.ownedLicenses.contains('Idol')) {
      character.ownedLicenses.add('Idol');
    }

    // Efek statistik
    character.happiness = (character.happiness + 20).clamp(0, 100);
    character.health = (character.health - 10).clamp(0, 100); // latihan intensif

    character.inbox.add(
      '$emojiAgensi Kontrak Idol: Kamu resmi bergabung dengan $namaAgensi di bawah bimbingan GM $namaGM! '
      'Petualangan menjadi idol telah dimulai. (+20% Kebahagiaan, -10% Kesehatan)',
    );

    _tampilkanHasil(
      context: context,
      icon: emojiAgensi,
      judul: 'Selamat Datang, Idol Baru!',
      pesan: 'Kamu resmi menandatangani kontrak dengan $namaAgensi! '
          'Latihan intensif akan segera dimulai. Siapkan dirimu! '
          '+20% Kebahagiaan | -10% Kesehatan',
      warna: Colors.amber,
      onClose: onComplete,
    );
  }

  // ================================================================
  // EKSEKUSI: Tolak kontrak
  // ================================================================
  static void _eksekusiTolak(
    BuildContext context,
    Character character,
    String namaGM,
    String namaAgensi,
    VoidCallback onComplete,
  ) {
    character.inbox.add(
      '⭐ Tawaran Ditolak: Kamu menolak tawaran kontrak idol dari GM $namaGM ($namaAgensi). '
      'Mungkin lain kali ada kesempatan lebih baik.',
    );
    onComplete();
  }

  // ================================================================
  // DIALOG HASIL
  // ================================================================
  static void _tampilkanHasil({
    required BuildContext context,
    required String icon,
    required String judul,
    required String pesan,
    required Color warna,
    required VoidCallback onClose,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  judul,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            pesan,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onClose();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.amberAccent : warna,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // WIDGET HELPER: Badge
  // ================================================================
  static Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? color.withValues(alpha: 0.9) : color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
