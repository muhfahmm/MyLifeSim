// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/efek_samping.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'persentase_efek_samping/wanita.dart';
import 'persentase_efek_samping/pria.dart';
import 'beritahu_orang_tua.dart';

class EfekSampingMasturbasi {
  // ============================================================
  // HELPER BADGE (sama dengan gaya di ajakan_masturbasi_dialog)
  // ============================================================
  static Widget _buildEffectBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Memicu risiko efek samping untuk aktivitas masturbasi SOLO.
  static void checkSoloEffect(BuildContext context, Character character, String relationType, VoidCallback? onComplete) {
    final random = Random();
    final bool isMale = character.gender.toLowerCase() == 'laki-laki';
    
    final int chance = isMale 
        ? PersentaseEfekSampingPria.getChance(relationType)
        : PersentaseEfekSampingWanita.getChance(relationType);

    if (random.nextInt(100) >= chance) {
      onComplete?.call();
      return;
    }

    final List<Map<String, dynamic>> possibleEffects = [];

    // 1. Lecet pada Jaringan Kulit Luar
    possibleEffects.add({
      'title': 'Lecet pada Jaringan Kulit Luar 🩹',
      'desc': 'Gesekan berlebihan tanpa pelumas menyebabkan kulit di area bawah tubuh terasa perih, merah, dan mengelupas ringan.',
      'health': -10,
      'happiness': -5,
      'intelligence': 0,
    });

    // 2. Robekan Kecil pada Jaringan Tipis (khusus pria)
    if (isMale) {
      possibleEffects.add({
        'title': 'Robekan Kecil Jaringan Tipis 🩹',
        'desc': 'Gerakan mendadak yang terlalu kasar menyebabkan robekan kecil pada jaringan tipis di area bawah, terasa perih saat terkena air.',
        'health': -10,
        'happiness': 0,
        'intelligence': 0,
      });
    }

    // 3. Kram Otot Pinggang dan Punggung Bawah
    possibleEffects.add({
      'title': 'Kram Otot Pinggang 🤕',
      'desc': 'Posisi duduk atau membungkuk terlalu lama membuat otot pinggang menegang dan terasa nyeri saat bergerak.',
      'health': -5,
      'happiness': 0,
      'intelligence': -5,
    });

    // 4. Kram pada Tangan dan Pergelangan
    possibleEffects.add({
      'title': 'Kram Tangan & Pergelangan ✊',
      'desc': 'Gerakan repetitif dan genggaman terlalu erat menyebabkan otot tangan kejang dan pergelangan terasa kaku.',
      'health': -3,
      'happiness': 0,
      'intelligence': 0,
    });

    // 5. Iritasi Akibat Overstimulasi (khusus wanita)
    if (!isMale) {
      possibleEffects.add({
        'title': 'Iritasi Overstimulasi 🔴',
        'desc': 'Area luar yang sangat sensitif menerima tekanan terlalu lama, menyebabkan bengkak ringan dan nyeri saat disentuh.',
        'health': -10,
        'happiness': -10,
        'intelligence': 0,
      });
    }

    // 6. Luka Mikro pada Jaringan Dalam (khusus wanita)
    if (!isMale) {
      possibleEffects.add({
        'title': 'Luka Mikro Jaringan Dalam 🩸',
        'desc': 'Tekanan atau gesekan internal yang berlebihan menyebabkan iritasi pada lapisan jaringan lunak di bagian dalam.',
        'health': -5,
        'happiness': 0,
        'intelligence': 0,
      });
    }

    // 7. Kram pada Otot Paha dan Perut Bawah (khusus wanita)
    if (!isMale) {
      possibleEffects.add({
        'title': 'Kram Paha & Perut Bawah ⚡',
        'desc': 'Menahan kontraksi otot terlalu lama membuat paha dan perut bawah terasa kejang dan tegang.',
        'health': -5,
        'happiness': 0,
        'intelligence': 0,
      });
    }

    // 8. Dehidrasi Ringan dan Pusing
    possibleEffects.add({
      'title': 'Dehidrasi Ringan & Pusing 🌀',
      'desc': 'Napas tersengal dan kurang minum setelah sesi panjang membuat kepala terasa ringan dan pandangan berkunang-kunang.',
      'health': -5,
      'happiness': 0,
      'intelligence': -3,
    });

    // 9. Reaksi Alergi / Iritasi Kulit
    possibleEffects.add({
      'title': 'Reaksi Alergi Sabun/Lotion 🧴',
      'desc': 'Penggunaan sabun, lotion, atau minyak yang tidak cocok menyebabkan ruam merah dan gatal di area bawah tubuh.',
      'health': -8,
      'happiness': -10,
      'intelligence': 0,
    });

    final effect = possibleEffects[random.nextInt(possibleEffects.length)];
    _applyAndShowEffect(context, character, effect, relationType, '', onComplete);
  }

  /// Memicu risiko efek samping untuk aktivitas masturbasi BERSAMA (Partner / Rayuan Berhasil).
  static void checkPartnerEffect(BuildContext context, Character character, String relationType, String partnerName, VoidCallback? onComplete, {int acceptanceHealthLoss = 0}) {
    final random = Random();
    final bool isMale = character.gender.toLowerCase() == 'laki-laki';
    
    final int chance = isMale 
        ? PersentaseEfekSampingPria.getChance(relationType)
        : PersentaseEfekSampingWanita.getChance(relationType);

    if (random.nextInt(100) >= chance) {
      onComplete?.call();
      return;
    }

    final List<Map<String, dynamic>> possibleEffects = [];

    // 1. Cedera Jaringan Keras Akibat Tekukan (khusus pria)
    if (isMale) {
      possibleEffects.add({
        'title': 'Cedera Jaringan Akibat Tekukan ⚠️',
        'desc': 'Gerakan yang tidak sinkron menyebabkan bagian bawah tubuh terbentur tulang pinggul pasangan, mengakibatkan bengkak besar dan memar berwarna kebiruan.',
        'health': -30,
        'happiness': -40,
        'intelligence': 0,
      });
    }

    // 2. Terkilir Otot Pinggang Akibat Gerakan Hentakan (khusus pria)
    if (isMale) {
      possibleEffects.add({
        'title': 'Terkilir Otot Pinggang ⚡',
        'desc': 'Gerakan menghentak terlalu agresif membuat otot pinggang bawah tertarik parah hingga sulit berdiri tegak.',
        'health': -15,
        'happiness': 0,
        'intelligence': 0,
      });
    }

    // 3. Infeksi Ringan Akibat Kontak (semua)
    possibleEffects.add({
      'title': 'Infeksi Ringan Kontak 🦠',
      'desc': 'Kebersihan pasangan kurang terjaga, beberapa hari kemudian muncul rasa gatal, panas, atau keluarnya cairan tidak normal dari area bawah tubuh.',
      'health': -20,
      'happiness': 0,
      'intelligence': 0,
      'karma': -10,
    });

    // 4. Laserasi / Robekan Jaringan Dalam (khusus wanita)
    if (!isMale) {
      possibleEffects.add({
        'title': 'Laserasi Jaringan Dalam 🩸',
        'desc': 'Tekanan atau penetrasi yang terlalu kasar menyebabkan robekan pada jaringan lunak bagian dalam, disertai pendarahan ringan.',
        'health': -25,
        'happiness': -20,
        'intelligence': 0,
      });
    }

    // 5. Kaku pada Otot Leher dan Rahang (semua)
    possibleEffects.add({
      'title': 'Kaku Otot Leher & Rahang 🤯',
      'desc': 'Posisi kepala menengadah atau tertunduk terlalu lama menyebabkan otot leher dan rahang kejang dan sulit digerakkan.',
      'health': -5,
      'happiness': 0,
      'intelligence': -5,
    });

    // 6. Iritasi atau Infeksi Jamur (khusus wanita)
    if (!isMale) {
      possibleEffects.add({
        'title': 'Iritasi Infeksi Jamur 🦠',
        'desc': 'Kebersihan tangan atau alat bantu yang kurang steril menyebabkan iritasi, gatal berlebihan, dan bau tidak sedap pada area bawah.',
        'health': -15,
        'happiness': -15,
        'intelligence': 0,
      });
    }
    
    // Pilih efek secara acak dari daftar yang tersisa
    final effect = possibleEffects[random.nextInt(possibleEffects.length)];
    _applyAndShowEffect(
      context,
      character,
      effect,
      relationType,
      partnerName,
      onComplete,
      acceptanceHealthLoss: acceptanceHealthLoss,
    );
  }

  static void _applyAndShowEffect(
    BuildContext context,
    Character character,
    Map<String, dynamic> effect,
    String relationType,
    String partnerName,
    VoidCallback? onComplete, {
    int acceptanceHealthLoss = 0,
  }) {
    // Terapkan efek statistik
    final int hDelta = effect['health'] ?? 0;
    final int hapDelta = effect['happiness'] ?? 0;
    final int iDelta = effect['intelligence'] ?? 0;
    final int kDelta = effect['karma'] ?? 0;

    character.health = (character.health + hDelta).clamp(0, 100);
    character.happiness = (character.happiness + hapDelta).clamp(0, 100);
    character.intelligence = (character.intelligence + iDelta).clamp(0, 100);
    character.karma = (character.karma + kDelta).clamp(0, 100);

    String detailStat = '';
    if (hDelta != 0) detailStat += 'Kesehatan $hDelta%  ';
    if (hapDelta != 0) detailStat += 'Kebahagiaan $hapDelta%  ';
    if (iDelta != 0) detailStat += 'Kecerdasan $iDelta%  ';
    if (kDelta != 0) detailStat += 'Karma $kDelta%  ';

    character.inbox.add('🚨 Efek Samping Masturbasi: ${effect['title']} ($detailStat)');

    final String diseaseName = effect['title'] ?? 'Efek Samping';
    if (!character.riwayatPenyakit.contains(diseaseName)) {
      character.riwayatPenyakit.add(diseaseName);
    }

    // Kumpulkan badge efek
    final List<Widget> effectBadges = [];
    if (hDelta != 0) {
      final color = hDelta > 0 ? Colors.green : Colors.red;
      effectBadges.add(_buildEffectBadge(
        Icons.favorite,
        '${hDelta > 0 ? '+' : ''}$hDelta% Kesehatan',
        color,
      ));
    }
    if (hapDelta != 0) {
      final color = hapDelta > 0 ? Colors.green : Colors.red;
      effectBadges.add(_buildEffectBadge(
        Icons.sentiment_satisfied,
        '${hapDelta > 0 ? '+' : ''}$hapDelta% Kebahagiaan',
        color,
      ));
    }
    if (iDelta != 0) {
      final color = iDelta > 0 ? Colors.blue : Colors.red;
      effectBadges.add(_buildEffectBadge(
        Icons.psychology,
        '${iDelta > 0 ? '+' : ''}$iDelta% Kecerdasan',
        color,
      ));
    }
    if (kDelta != 0) {
      final color = kDelta > 0 ? Colors.green : Colors.red;
      effectBadges.add(_buildEffectBadge(
        Icons.balance,
        '${kDelta > 0 ? '+' : ''}$kDelta% Karma',
        color,
      ));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                effect['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(effect['desc'], style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: effectBadges,
            ),
          ],
        ),
        actions: [
          if (partnerName.trim().isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _tellPartnerToHeal(
                  context,
                  character,
                  partnerName,
                  relationType,
                  hDelta,
                  acceptanceHealthLoss,
                  onComplete,
                );
              },
              child: Text(
                'Beri tahu $relationType ($partnerName)',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          if ((character.fatherName != null && !character.isFatherDeceased) ||
              (character.motherName != null && !character.isMotherDeceased))
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                BeriTahuOrangTua.show(context, character, relationType, partnerName, hDelta, onComplete);
              },
              child: const Text('Beri tahu orang tua', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _goToDoctor(context, character, hDelta, onComplete);
            },
            child: const Text('Pergi ke dokter (\$150)', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete?.call();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void _goToDoctor(
    BuildContext context,
    Character character,
    int originalHealthLoss,
    VoidCallback? onComplete,
  ) {
    const int doctorCost = 150;
    String msg = '';

    if (character.money >= doctorCost) {
      character.money -= doctorCost;
      final int healAmount = originalHealthLoss.abs();
      character.health = (character.health + healAmount).clamp(0, 100);
      msg = 'Dokter memberikan resep obat dan salep khusus. Kesehatanmu pulih sepenuhnya dari cedera ini (-\$$doctorCost uang, +$healAmount% Kesehatan).';
      character.inbox.add('🏥 Pergi ke dokter: $msg');
    } else {
      character.happiness = (character.happiness - 10).clamp(0, 100);
      msg = 'Uang saku kamu tidak cukup untuk membayar biaya dokter sebesar \$$doctorCost! Kamu terpaksa pulang dengan rasa perih (-10% Kebahagiaan).';
      character.inbox.add('🏥 Pergi ke dokter gagal: Uang tidak cukup.');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Pergi ke Dokter', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete?.call();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void _tellPartnerToHeal(
    BuildContext context,
    Character character,
    String partnerName,
    String relationType,
    int originalHealthLoss,
    int acceptanceHealthLoss,
    VoidCallback? onComplete,
  ) {
    // Sembuhkan cedera (tambahkan kembali health yang hilang dari event penerimaan + efek samping)
    final int healAmount = originalHealthLoss.abs() + acceptanceHealthLoss.abs();
    character.health = (character.health + healAmount).clamp(0, 100);
    
    // Hapus penyakit dari riwayat penyakit
    character.riwayatPenyakit.removeWhere((disease) => 
        disease.contains('Lecet') || 
        disease.contains('Robekan') || 
        disease.contains('Kram') || 
        disease.contains('Iritasi') || 
        disease.contains('Luka Mikro') || 
        disease.contains('Infeksi'));

    final String msg = '🤫 Rahasia Medis: Kamu memberitahu $relationType ($partnerName) tentang cederamu. '
        'Dengan rasa bersalah dan khawatir, dia membawamu ke klinik secara diam-diam tanpa sepengetahuan orang tua dan menanggung semua biaya pengobatan. Kesehatanmu pulih sepenuhnya (+$healAmount% Kesehatan).';
    character.inbox.add(msg);

    // Badge efek kesehatan pulih
    final badge = _buildEffectBadge(
      Icons.favorite,
      '+$healAmount% Kesehatan',
      Colors.green,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Bantuan dari $partnerName',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            badge,
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete?.call();
            },
            child: const Text('Terima Kasih', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}