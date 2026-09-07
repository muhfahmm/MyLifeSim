// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/univ_logic/country_education_rules.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CountryEducationRules {
  /// Mengembalikan `true` jika negara menerapkan kontrol ketat/ideologis negara terhadap pendidikan agama umum.
  static bool isStrictStateCountry(String countryName) {
    final c = countryName.toLowerCase().trim();
    const strictCountries = {
      'china',
      'tiongkok',
      'korea utara',
      'north korea',
      'vietnam',
      'kuba',
      'cuba',
      'laos',
      'arab saudi',
      'iran',
      'eritrea',
      'turkmenistan',
    };
    return strictCountries.any((sc) => c.contains(sc) || sc.contains(c));
  }

  /// Nama jurusan pengganti pendidikan agama di negara ketat/ideologis.
  static String getIdeologicalMajorName(String countryName) {
    final c = countryName.toLowerCase().trim();
    if (c.contains('korea utara') || c.contains('north korea')) {
      return 'Studi Revolusioner & Ideologi Juche';
    } else if (c.contains('arab saudi') || c.contains('iran')) {
      return 'Studi Syariah & Doktrin Negara';
    } else if (c.contains('china') || c.contains('tiongkok') || c.contains('vietnam') || c.contains('kuba') || c.contains('cuba') || c.contains('laos')) {
      return 'Pendidikan Ideologi & Politik';
    }
    return 'Pendidikan Kewarganegaraan & Ideologi';
  }

  /// Mengembalikan struktur map kategori jurusan yang disesuaikan dengan aturan negara.
  static Map<String, List<String>> getCategoryMajorsForCountry(String countryName) {
    final bool isStrict = isStrictStateCountry(countryName);
    final String agamaOrIdeologi = isStrict ? getIdeologicalMajorName(countryName) : 'Pendidikan Agama';

    return {
      'STEM & TEKNIK': [
        'Teknik Informatika',
        'Sistem Informasi',
        'Teknik Sipil',
        'Teknik Elektro',
        'Teknik Mesin',
        'Teknik Kimia',
        'Arsitektur',
      ],
      'KESEHATAN': [
        'Kedokteran',
        'Kedokteran Gigi',
        'Farmasi',
        'Keperawatan',
        'Gizi & Ilmu Pangan',
      ],
      'BISNIS & EKONOMI': [
        'Manajemen',
        'Akuntansi',
        'Ekonomi Pembangunan',
        'Perbankan & Keuangan',
        'Pemasaran Digital',
      ],
      'HUKUM & SOSIAL': [
        'Hukum',
        'Hubungan Internasional',
        'Ilmu Komunikasi',
        'Psikologi',
        'Administrasi Publik',
        'Kriminologi',
      ],
      'PENDIDIKAN & BAHASA': [
        'Sastra & Bahasa',
        'Pendidikan / PGSD',
        agamaOrIdeologi,
      ],
      'KREATIF & SENI': [
        'Desain Komunikasi Visual (DKV)',
        'Desain Mode',
        'Film & Televisi',
        'Seni Musik',
      ],
      'PERTANIAN & LAINNYA': [
        'Agroteknologi',
        'Manajemen Perhotelan',
      ],
    };
  }

  /// Menampilkan modal peringatan dan konsekuensi jika user mencoba belajar agama secara tertutup/ilegal di negara ketat.
  static void handleSecretReligiousStudyAttempt({
    required BuildContext context,
    required Character character,
    required Function(bool successToProceed) onResult,
  }) {
    final String country = character.location.isNotEmpty
        ? character.location
        : (character.birthCountry ?? 'Negara');
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pembatasan Negara ⚠️',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
              'Pemerintah $country menerapkan regulasi ketat terhadap pendidikan agama bebas di perguruan tinggi negeri.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gavel, color: Colors.red, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pemberitahuan Risiko:\nBelajar agama secara diam-diam / mendaftar lembaga tak terdaftar berisiko sanksi hukum, penalti karma, penurunan kebahagiaan, atau tindakan aparat.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              onResult(false);
            },
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.lock_clock),
            label: const Text('Lanjut Diam-diam (Risiko)', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(dialogCtx);
              _processConsequences(context, character, country, onResult);
            },
          ),
        ],
      ),
    );
  }

  static void _processConsequences(
    BuildContext context,
    Character character,
    String country,
    Function(bool successToProceed) onResult,
  ) {
    final bool caught = Random().nextInt(100) < 45; // 45% peluang tertangkap
    final bool severeJail = caught && (Random().nextInt(100) < 30); // 30% dari tertangkap = penjara

    if (caught) {
      character.karma = max(0, character.karma - 30);
      character.happiness = max(0, character.happiness - 35);

      if (severeJail) {
        character.isImprisoned = true;
        character.remainingJailYears = Random().nextInt(3) + 2; // 2-4 tahun

        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Ditangkap Aparat Keamanan! 🚔'),
            content: Text(
              'Aparat intelijen $country mendeteksi aktivitas pendidikan agama tak terizin yang kamu ikuti.\n\nKamu dijatuhi hukuman penjara selama ${character.remainingJailYears} tahun!\n\n• Karma: -30\n• Kebahagiaan: -35',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(c);
                  onResult(false);
                },
                child: const Text('Terima Nasib'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Peringatan & Pengawasan Ketat 🛑'),
            content: Text(
              'Kamu diinterogasi oleh otoritas $country dan diberikan peringatan keras atas kegiatan akademik غير terdaftar.\n\n• Karma: -30\n• Kebahagiaan: -35',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(c);
                  onResult(false);
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        );
      }
    } else {
      // Tidak tertangkap tapi hidup dalam tekanan
      character.happiness = max(0, character.happiness - 15);
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Belajar Diam-diam 🤫'),
          content: Text(
            'Kamu berhasil mengikuti pembelajaran keagamaan secara rahasia di $country tanpa terdeteksi aparat. Namun, tekanan psikologis membuatmu cemas.\n\n• Kebahagiaan: -15',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(c);
                onResult(true);
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      );
    }
  }
}
