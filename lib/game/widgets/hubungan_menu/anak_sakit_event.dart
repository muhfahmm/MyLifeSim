// lib/game/widgets/hubungan_menu/anak_sakit_event.dart
//
// Event: Anak user jatuh sakit secara acak setiap giliran.
// Pilihan yang tersedia untuk orang tua:
//   1. Bawa ke Dokter   → kesehatan anak pulih, uang berkurang
//   2. Berobat Sendiri  → kemungkinan 60% sembuh, 40% memburuk
//   3. Biarkan          → anak semakin parah, hubungan memburuk
//
// Cara pakai (di akhir giliran / advanceAge):
//   AnakSakitEvent.cekDanTampilkan(context: ctx, character: _character, onComplete: () => setState(() {}));

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class AnakSakitEvent {
  // ================================================================
  // KONSTANTA
  // ================================================================

  /// Peluang anak sakit per giliran (per anak).
  static const double chancePerChild = 0.08; // 8% per anak per giliran

  /// Biaya bawa ke dokter.
  static const int biayaDokter = 500000;

  /// Daftar jenis penyakit anak yang mungkin muncul.
  static const List<Map<String, String>> _daftarPenyakit = [
    {'nama': 'Demam Tinggi', 'emoji': '🤒', 'parah': 'rendah'},
    {'nama': 'Flu & Batuk', 'emoji': '🤧', 'parah': 'rendah'},
    {'nama': 'Diare', 'emoji': '🚽', 'parah': 'rendah'},
    {'nama': 'Infeksi Telinga', 'emoji': '👂', 'parah': 'sedang'},
    {'nama': 'Cacar Air', 'emoji': '💊', 'parah': 'sedang'},
    {'nama': 'Radang Tenggorokan', 'emoji': '😷', 'parah': 'sedang'},
    {'nama': 'Pneumonia', 'emoji': '🫁', 'parah': 'tinggi'},
    {'nama': 'Demam Berdarah', 'emoji': '🦟', 'parah': 'tinggi'},
  ];

  // ================================================================
  // ENTRY POINT
  // ================================================================

  /// Cek setiap anak, jika ada yang sakit tampilkan dialog.
  /// Hanya muncul untuk anak yang masih hidup dan belum sakit.
  static void cekDanTampilkan({
    required BuildContext context,
    required Character character,
    required VoidCallback onComplete,
  }) {
    if (character.children.isEmpty) return;

    final Random rng = Random();

    // Cari anak yang belum sakit dan masih hidup
    final List<Map<String, String>> anakHidup = character.children
        .where((c) => c['isDeceased'] != 'true' && c['isSick'] != 'true')
        .toList();

    if (anakHidup.isEmpty) return;

    // Roll per anak
    Map<String, String>? anakSakit;
    for (final anak in anakHidup) {
      if (rng.nextDouble() < chancePerChild) {
        anakSakit = anak;
        break; // satu event per giliran
      }
    }

    if (anakSakit == null) return;

    // Pilih penyakit acak
    final Map<String, String> penyakit =
        _daftarPenyakit[rng.nextInt(_daftarPenyakit.length)];

    // Tandai anak sakit
    anakSakit['isSick'] = 'true';
    anakSakit['sickDisease'] = penyakit['nama']!;

    character.inbox.add(
      '🤒 Anak Sakit: ${anakSakit['name']} (${anakSakit['age']} thn) '
      'tiba-tiba sakit ${penyakit['nama']}! Kamu perlu mengambil tindakan.',
    );

    _tampilkanDialog(
      context: context,
      character: character,
      anak: anakSakit,
      penyakit: penyakit,
      onComplete: onComplete,
    );
  }

  // ================================================================
  // DIALOG UTAMA
  // ================================================================
  static void _tampilkanDialog({
    required BuildContext context,
    required Character character,
    required Map<String, String> anak,
    required Map<String, String> penyakit,
    required VoidCallback onComplete,
  }) {
    final String namaAnak = anak['name'] ?? 'Anakmu';
    final String usia = anak['age'] ?? '?';
    final String emoji = penyakit['emoji']!;
    final String namaPenyakit = penyakit['nama']!;
    final String tingkatParah = penyakit['parah']!;

    final Color warnaParah = tingkatParah == 'tinggi'
        ? Colors.red
        : tingkatParah == 'sedang'
            ? Colors.orange
            : Colors.yellow.shade700;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFFFF3F3),
          title: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$namaAnak Sakit!',
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
                '$namaAnak ($usia tahun) tiba-tiba menderita $namaPenyakit. '
                'Sebagai orang tua, kamu harus memutuskan apa yang akan dilakukan.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBadge(
                icon: Icons.sick,
                label: 'Penyakit: $namaPenyakit',
                color: warnaParah,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              _buildBadge(
                icon: Icons.warning_amber_rounded,
                label: 'Tingkat keparahan: ${tingkatParah[0].toUpperCase()}${tingkatParah.substring(1)}',
                color: warnaParah,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              _buildBadge(
                icon: Icons.medical_services,
                label: 'Biaya dokter: Rp ${_fmt(biayaDokter)}',
                color: Colors.blue,
                isDark: isDark,
              ),
            ],
          ),
          actions: [
            // Biarkan
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _eksekusiBiarkan(context, character, anak, namaAnak, namaPenyakit, onComplete);
              },
              child: Text(
                'Biarkan',
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Berobat Sendiri
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _eksekusiBerobatSendiri(context, character, anak, namaAnak, namaPenyakit, onComplete);
              },
              child: Text(
                'Berobat Sendiri',
                style: TextStyle(
                  color: isDark ? Colors.orangeAccent : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Bawa ke Dokter
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.blue.shade900 : const Color(0xFFD0E8FF),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _eksekusiBawaDokter(context, character, anak, namaAnak, namaPenyakit, onComplete);
                },
                child: Text(
                  'Bawa ke Dokter 🏥',
                  style: TextStyle(
                    color: isDark ? Colors.lightBlueAccent : Colors.blue.shade800,
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
  // PILIHAN 1: Bawa ke Dokter (100% sembuh, potong uang)
  // ================================================================
  static void _eksekusiBawaDokter(
    BuildContext context,
    Character character,
    Map<String, String> anak,
    String namaAnak,
    String namaPenyakit,
    VoidCallback onComplete,
  ) {
    if (character.money < biayaDokter) {
      // Uang tidak cukup
      _tampilkanHasil(
        context: context,
        icon: '💸',
        judul: 'Uang Tidak Cukup',
        pesan: 'Kamu tidak punya cukup uang untuk membawa $namaAnak ke dokter. '
            'Kamu harus mencari cara lain.',
        warna: Colors.orange,
        onClose: onComplete,
      );
      return;
    }

    character.money -= biayaDokter;
    anak['isSick'] = 'false';
    anak['sickDisease'] = '';

    // Tingkatkan relasi dengan anak
    int relasi = int.tryParse(anak['relationship'] ?? '50') ?? 50;
    anak['relationship'] = (relasi + 10).clamp(0, 100).toString();

    character.inbox.add(
      '🏥 $namaAnak Sembuh: Kamu membawa $namaAnak ke dokter dan berhasil sembuh dari $namaPenyakit. '
      '(-Rp ${_fmt(biayaDokter)}, +10% Hubungan dengan anak)',
    );

    _tampilkanHasil(
      context: context,
      icon: '🏥',
      judul: '$namaAnak Sembuh!',
      pesan: 'Dokter berhasil mengobati $namaAnak dari $namaPenyakit. '
          '$namaAnak sangat berterima kasih. '
          '-Rp ${_fmt(biayaDokter)} | +10% Hubungan',
      warna: Colors.blue,
      onClose: onComplete,
    );
  }

  // ================================================================
  // PILIHAN 2: Berobat Sendiri (60% sembuh, 40% memburuk)
  // ================================================================
  static void _eksekusiBerobatSendiri(
    BuildContext context,
    Character character,
    Map<String, String> anak,
    String namaAnak,
    String namaPenyakit,
    VoidCallback onComplete,
  ) {
    final bool berhasil = Random().nextDouble() < 0.60;

    if (berhasil) {
      anak['isSick'] = 'false';
      anak['sickDisease'] = '';
      character.inbox.add(
        '💊 $namaAnak Sembuh: Pengobatan sendiri berhasil! $namaAnak pulih dari $namaPenyakit.',
      );
      _tampilkanHasil(
        context: context,
        icon: '💊',
        judul: 'Berhasil Sembuh!',
        pesan: 'Pengobatan rumahan berhasil! $namaAnak sembuh dari $namaPenyakit. '
            'Kamu menghemat biaya dokter.',
        warna: Colors.green,
        onClose: onComplete,
      );
    } else {
      // Kondisi memburuk
      int relasi = int.tryParse(anak['relationship'] ?? '50') ?? 50;
      anak['relationship'] = (relasi - 5).clamp(0, 100).toString();
      character.inbox.add(
        '😔 Kondisi Memburuk: Pengobatan sendiri tidak berhasil, kondisi $namaAnak '
        'semakin parah. Sebaiknya segera bawa ke dokter! (-5% Hubungan)',
      );
      _tampilkanHasil(
        context: context,
        icon: '😔',
        judul: 'Kondisi Memburuk',
        pesan: 'Pengobatan sendiri tidak cukup. Kondisi $namaAnak justru semakin parah. '
            'Sebaiknya segera bawa ke dokter sebelum terlambat! -5% Hubungan',
        warna: Colors.orange,
        onClose: onComplete,
      );
    }
  }

  // ================================================================
  // PILIHAN 3: Biarkan (anak memburuk, hubungan turun drastis)
  // ================================================================
  static void _eksekusiBiarkan(
    BuildContext context,
    Character character,
    Map<String, String> anak,
    String namaAnak,
    String namaPenyakit,
    VoidCallback onComplete,
  ) {
    // Hubungan turun drastis
    int relasi = int.tryParse(anak['relationship'] ?? '50') ?? 50;
    anak['relationship'] = (relasi - 20).clamp(0, 100).toString();

    // Kebahagiaan user sedikit turun (rasa bersalah)
    character.happiness = (character.happiness - 5).clamp(0, 100);

    character.inbox.add(
      '😞 Diabaikan: Kamu memilih untuk mengabaikan penyakit $namaAnak ($namaPenyakit). '
      'Kondisinya semakin memburuk dan $namaAnak sangat kecewa. '
      '(-20% Hubungan, -5% Kebahagiaanmu)',
    );

    _tampilkanHasil(
      context: context,
      icon: '😞',
      judul: 'Anak Diabaikan',
      pesan: '$namaAnak sangat kecewa karena kamu tidak peduli pada sakitnya. '
          'Kondisinya memburuk dan hubungan kalian merenggang. '
          '-20% Hubungan | -5% Kebahagiaanmu',
      warna: Colors.red,
      onClose: onComplete,
    );
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
                  color: isDark ? Colors.white70 : warna,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // WIDGET HELPER
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
