// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/ajakan_luar_negeri_event.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/persentase_ajakan_luar_negeri.dart';

class AjakanLuarNegeriEvent {
  // ================================================================
  // ENTRY POINT
  // ================================================================
  static void cekDanTampilkan({
    required BuildContext context,
    required Character character,
    required VoidCallback onComplete,
  }) {
    // Gunakan logika persentase dari file yang sudah Anda buat
    final int roll = Random().nextInt(100);
    if (!PersentaseAjakanLuarNegeri.apakahEventMuncul(character, roll)) return;

    final List<Map<String, dynamic>> semuaNegara = negaraList;
    if (semuaNegara.isEmpty) return;

    final Map<String, dynamic> negaraTujuan =
        semuaNegara[Random().nextInt(semuaNegara.length)];
    final String namaNegaraTujuan = negaraTujuan['name'] as String? ?? 'Singapura';
    final String emojiNegara = '✈️';

    final String namaAjakan = _getNamaOrangTuaAjakan(character);

    _tampilkanDialogUtama(
      context: context,
      character: character,
      namaAjakan: namaAjakan,
      namaNegaraTujuan: namaNegaraTujuan,
      emojiNegara: emojiNegara,
      onComplete: onComplete,
    );
  }

  // ================================================================
  // DIALOG UTAMA
  // ================================================================
  static void _tampilkanDialogUtama({
    required BuildContext context,
    required Character character,
    required String namaAjakan,
    required String namaNegaraTujuan,
    required String emojiNegara,
    required VoidCallback onComplete,
  }) {
    final bool sudahPunyaPaspor = character.ownedLicenses.contains('Paspor');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFEEF7FF),
          title: Row(
            children: [
              Text('$emojiNegara', style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ajakan Liburan Keluarga!',
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
                '$namaAjakan mengajakmu pergi ke $namaNegaraTujuan! Ini kesempatan langka untuk menjelajah bersama keluarga.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBadge(
                icon: sudahPunyaPaspor ? Icons.check_circle : Icons.warning_amber_rounded,
                label: sudahPunyaPaspor
                    ? 'Kamu sudah punya Paspor ✓'
                    : 'Kamu belum punya Paspor',
                color: sudahPunyaPaspor ? Colors.green : Colors.orange,
                isDark: isDark,
              ),
              if (!sudahPunyaPaspor) ...[
                const SizedBox(height: 8),
                Text(
                  'Kamu bisa meminta orang tua menguruskan paspor anak jika mereka mampu dan punya paspor sendiri.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _eksekusiTolak(context, character, namaAjakan, onComplete);
              },
              child: Text(
                'Tidak, terima kasih',
                style: TextStyle(
                  color: isDark ? Colors.redAccent : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!sudahPunyaPaspor)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _alurMintaOrangTuaUrus(
                    context: context,
                    character: character,
                    namaAjakan: namaAjakan,
                    namaNegaraTujuan: namaNegaraTujuan,
                    emojiNegara: emojiNegara,
                    onComplete: onComplete,
                  );
                },
                child: Text(
                  'Minta ${_namaOrangTuaShort(character)} urus pasporku',
                  style: TextStyle(
                    color: isDark ? Colors.amberAccent : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (sudahPunyaPaspor)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.shade900 : const Color(0xFFD0E8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _eksekusiPergi(
                      context: context,
                      character: character,
                      namaNegaraTujuan: namaNegaraTujuan,
                      emojiNegara: emojiNegara,
                      ditanggungOrangTua: true,
                      onComplete: onComplete,
                    );
                  },
                  child: Text(
                    'Ayo pergi! $emojiNegara',
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
  // ALUR: MINTA ORANG TUA URUS PASPOR
  // ================================================================
  static void _alurMintaOrangTuaUrus({
    required BuildContext context,
    required Character character,
    required String namaAjakan,
    required String namaNegaraTujuan,
    required String emojiNegara,
    required VoidCallback onComplete,
  }) {
    final bool orangTuaPunyaPaspor = PersentaseAjakanLuarNegeri.orangTuaPunyaPaspor(character);
    final bool orangTuaMampu = PersentaseAjakanLuarNegeri.orangTuaMampu(character);

    if (!orangTuaPunyaPaspor) {
      _tampilkanHasil(
        context: context,
        icon: '😔',
        judul: 'Perjalanan Dibatalkan',
        pesan: '$namaAjakan juga belum punya paspor! Perjalanan ke $namaNegaraTujuan terpaksa dibatalkan. Urus paspor bersama terlebih dahulu.',
        warna: Colors.red,
        onClose: onComplete,
      );
      return;
    }

    if (!orangTuaMampu) {
      _tampilkanHasil(
        context: context,
        icon: '💸',
        judul: 'Dana Tidak Cukup',
        pesan: '$namaAjakan ingin menguruskan paspormu, tapi dana keluarga tidak cukup untuk menanggung biaya paspor anak (Rp ${_fmt(PersentaseAjakanLuarNegeri.biayaPasporAnak)}) + perjalanan. Perjalanan ditunda.',
        warna: Colors.orange,
        onClose: onComplete,
      );
      return;
    }

    // Konfirmasi Pengurusan Paspor
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF0FFF4),
          title: Row(
            children: [
              const Text('🛂', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pengurusan Paspor Anak',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                '$namaAjakan bersedia menguruskan Paspor Anak untukmu agar bisa pergi ke $namaNegaraTujuan $emojiNegara bersama.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBadge(
                icon: Icons.attach_money,
                label: 'Biaya paspor: Rp ${_fmt(PersentaseAjakanLuarNegeri.biayaPasporAnak)} (Ditanggung keluarga)',
                color: Colors.green,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              _buildBadge(
                icon: Icons.airplanemode_active,
                label: 'Biaya perjalanan: Rp ${_fmt(PersentaseAjakanLuarNegeri.biayaPerjalanan)} (Ditanggung keluarga)',
                color: Colors.blue,
                isDark: isDark,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onComplete();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.green.shade900 : const Color(0xFFD4EDDA),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Berikan paspor anak
                  if (!character.ownedLicenses.contains('Paspor')) {
                    character.ownedLicenses.add('Paspor');
                  }
                  
                  const int totalBiaya = PersentaseAjakanLuarNegeri.biayaPasporAnak +
                      PersentaseAjakanLuarNegeri.biayaPerjalanan;

                  // PERBAIKAN: Gunakan method getter & setter yang aman dari Character
                  // Jangan menggunakan `character.familyWealth` atau `-=` pada int? 
                  if (character.fatherName != null && namaAjakan.contains(character.fatherName!)) {
                    int newWealth = character.getFatherWealth() - totalBiaya;
                    character.setTargetWealth(character.fatherName!, 'Kandung', newWealth);
                  } else if (character.motherName != null && namaAjakan.contains(character.motherName!)) {
                    int newWealth = character.getMotherWealth() - totalBiaya;
                    character.setTargetWealth(character.motherName!, 'Kandung', newWealth);
                  }

                  // Catat di inbox
                  character.inbox.add(
                    '🛂 Paspor Anak: $namaAjakan menguruskan paspor untukmu! Kamu sekarang memiliki Paspor Anak dan siap bepergian.',
                  );

                  _eksekusiPergi(
                    context: context,
                    character: character,
                    namaNegaraTujuan: namaNegaraTujuan,
                    emojiNegara: emojiNegara,
                    ditanggungOrangTua: true,
                    onComplete: onComplete,
                  );
                },
                child: Text(
                  'Ya, urus paspor & pergi!',
                  style: TextStyle(
                    color: isDark ? Colors.greenAccent : const Color(0xFF28A745),
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
  // EKSEKUSI PERGI
  // ================================================================
  static void _eksekusiPergi({
    required BuildContext context,
    required Character character,
    required String namaNegaraTujuan,
    required String emojiNegara,
    required bool ditanggungOrangTua,
    required VoidCallback onComplete,
  }) {
    character.happiness = (character.happiness + 15).clamp(0, 100);
    character.inbox.add(
      '$emojiNegara Perjalanan Keluarga: Kamu berhasil mengunjungi $namaNegaraTujuan bersama keluarga! Pengalaman berharga yang tak terlupakan.',
    );

    _tampilkanHasil(
      context: context,
      icon: emojiNegara,
      judul: 'Selamat Tiba di $namaNegaraTujuan! ✈️',
      pesan: 'Perjalanan keluargamu ke $namaNegaraTujuan berjalan lancar dan menyenangkan! '
          '${ditanggungOrangTua ? "Semua biaya ditanggung keluarga. " : ""}'
          '+15% Kebahagiaan. Kenangan indah ini tersimpan selamanya.',
      warna: Colors.blue,
      onClose: onComplete,
    );
  }

  // ================================================================
  // EKSEKUSI TOLAK
  // ================================================================
  static void _eksekusiTolak(
    BuildContext context,
    Character character,
    String namaAjakan,
    VoidCallback onComplete,
  ) {
    if (character.fatherName != null && namaAjakan.contains(character.fatherName!)) {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) - 5).clamp(0, 100);
    } else if (character.motherName != null && namaAjakan.contains(character.motherName!)) {
      character.motherRelationship = ((character.motherRelationship ?? 50) - 5).clamp(0, 100);
    }
    character.inbox.add(
      '✈️ Ajakan Ditolak: Kamu menolak ajakan $namaAjakan untuk pergi ke luar negeri. Hubungan sedikit renggang (-5% Relasi).',
    );
    onComplete();
  }

  // ================================================================
  // HELPER: HASIL AKHIR
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

  // ================================================================
  // INTERNAL UTILS
  // ================================================================
  static String _getNamaOrangTuaAjakan(Character character) {
    if (character.fatherName != null && !character.isFatherDeceased) {
      return character.fatherName!;
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      return character.motherName!;
    }
    if (character.stepFatherName != null && !character.isStepFatherDeceased) {
      return character.stepFatherName!;
    }
    return 'Orang Tuamu';
  }

  static String _namaOrangTuaShort(Character character) {
    if (character.fatherName != null && !character.isFatherDeceased) {
      return 'Ayah';
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      return 'Ibu';
    }
    return 'Orang Tua';
  }

  static String _fmt(int amount) {
    return amount
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}