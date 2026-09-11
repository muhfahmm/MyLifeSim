// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/sepakbola_logic/database_formasi_pelatih.dart

import 'dart:math';

class FormasiPelatih {
  final String code; // e.g. '4-3-3'
  final String name; // e.g. '4-3-3'
  final int kiper;
  final int bek;
  final int gelandang;
  final int penyerang;
  final List<String> orderedPositions;

  const FormasiPelatih({
    required this.code,
    required this.name,
    this.kiper = 1,
    required this.bek,
    required this.gelandang,
    required this.penyerang,
    required this.orderedPositions,
  });
}

class FormasiPelatihDatabase {
  /// Helper method untuk mengonversi nama posisi ke singkatan resmi (GK, CB, RB, LB, CDM, CM, CAM, LW, RW, ST)
  static String toPositionCode(String position) {
    if (position.isEmpty) return position;
    String clean = position.trim();
    final String cleanLower = clean.toLowerCase();

    if (cleanLower.contains('kiper') || cleanLower.contains('goalkeeper')) {
      return clean.replaceAll(RegExp(r'Kiper(\s*Cadangan)?', caseSensitive: false), 'GK');
    }
    if (cleanLower.contains('bek tengah')) {
      return clean.replaceAll(RegExp(r'Bek Tengah(\s*Cadangan)?', caseSensitive: false), 'CB');
    }
    if (cleanLower.contains('bek kanan')) {
      return clean.replaceAll(RegExp(r'Bek Kanan(\s*Cadangan)?', caseSensitive: false), 'RB');
    }
    if (cleanLower.contains('bek kiri')) {
      return clean.replaceAll(RegExp(r'Bek Kiri(\s*Cadangan)?', caseSensitive: false), 'LB');
    }
    if (cleanLower.contains('bek sayap')) {
      return clean.replaceAll(RegExp(r'Bek Sayap(\s*Cadangan)?', caseSensitive: false), 'LB/RB');
    }
    if (cleanLower == 'bek' || cleanLower == 'bek cadangan') {
      return 'CB';
    }
    if (cleanLower.contains('gelandang bertahan')) {
      return clean.replaceAll(RegExp(r'Gelandang Bertahan(\s*Cadangan)?', caseSensitive: false), 'CDM');
    }
    if (cleanLower.contains('gelandang serang')) {
      return clean.replaceAll(RegExp(r'Gelandang Serang(\s*Cadangan)?', caseSensitive: false), 'CAM');
    }
    if (cleanLower.contains('gelandang tengah')) {
      return clean.replaceAll(RegExp(r'Gelandang Tengah(\s*Cadangan)?', caseSensitive: false), 'CM');
    }
    if (cleanLower.contains('gelandang')) {
      return clean.replaceAll(RegExp(r'Gelandang(\s*Cadangan)?', caseSensitive: false), 'CM');
    }
    if (cleanLower.contains('penyerang sayap kiri')) {
      return clean.replaceAll(RegExp(r'Penyerang Sayap Kiri(\s*Cadangan)?', caseSensitive: false), 'LW');
    }
    if (cleanLower.contains('sayap kiri')) {
      return clean.replaceAll(RegExp(r'Sayap Kiri(\s*Cadangan)?', caseSensitive: false), 'LW');
    }
    if (cleanLower.contains('penyerang sayap kanan')) {
      return clean.replaceAll(RegExp(r'Penyerang Sayap Kanan(\s*Cadangan)?', caseSensitive: false), 'RW');
    }
    if (cleanLower.contains('sayap kanan')) {
      return clean.replaceAll(RegExp(r'Sayap Kanan(\s*Cadangan)?', caseSensitive: false), 'RW');
    }
    if (cleanLower.contains('penyerang tengah')) {
      return clean.replaceAll(RegExp(r'Penyerang Tengah(\s*Cadangan)?', caseSensitive: false), 'ST');
    }
    if (cleanLower.contains('striker')) {
      return clean.replaceAll(RegExp(r'Striker(\s*Cadangan)?', caseSensitive: false), 'ST');
    }
    if (cleanLower.contains('penyerang')) {
      return clean.replaceAll(RegExp(r'Penyerang(\s*Cadangan)?', caseSensitive: false), 'ST');
    }

    return clean;
  }

  static const List<FormasiPelatih> daftarFormasi = [
    FormasiPelatih(
      code: '4-3-3',
      name: '4-3-3',
      bek: 4,
      gelandang: 3,
      penyerang: 3,
      orderedPositions: [
        'GK',
        'LB',
        'CB',
        'CB',
        'RB',
        'CDM',
        'CM',
        'CAM',
        'LW',
        'ST',
        'RW',
      ],
    ),
    FormasiPelatih(
      code: '4-4-2',
      name: '4-4-2',
      bek: 4,
      gelandang: 4,
      penyerang: 2,
      orderedPositions: [
        'GK',
        'LB',
        'CB',
        'CB',
        'RB',
        'LW',
        'CM',
        'CM',
        'RW',
        'ST',
        'ST',
      ],
    ),
    FormasiPelatih(
      code: '3-5-2',
      name: '3-5-2',
      bek: 3,
      gelandang: 5,
      penyerang: 2,
      orderedPositions: [
        'GK',
        'CB',
        'CB',
        'CB',
        'LW',
        'CDM',
        'CM',
        'CAM',
        'RW',
        'ST',
        'ST',
      ],
    ),
    FormasiPelatih(
      code: '4-2-3-1',
      name: '4-2-3-1',
      bek: 4,
      gelandang: 5,
      penyerang: 1,
      orderedPositions: [
        'GK',
        'LB',
        'CB',
        'CB',
        'RB',
        'CDM',
        'CDM',
        'LW',
        'CAM',
        'RW',
        'ST',
      ],
    ),
    FormasiPelatih(
      code: '5-3-2',
      name: '5-3-2',
      bek: 5,
      gelandang: 3,
      penyerang: 2,
      orderedPositions: [
        'GK',
        'LB',
        'CB',
        'CB',
        'CB',
        'RB',
        'CDM',
        'CM',
        'CAM',
        'ST',
        'ST',
      ],
    ),
    FormasiPelatih(
      code: '3-4-3',
      name: '3-4-3',
      bek: 3,
      gelandang: 4,
      penyerang: 3,
      orderedPositions: [
        'GK',
        'CB',
        'CB',
        'CB',
        'LW',
        'CM',
        'CM',
        'RW',
        'LW',
        'ST',
        'RW',
      ],
    ),
    FormasiPelatih(
      code: '4-5-1',
      name: '4-5-1',
      bek: 4,
      gelandang: 5,
      penyerang: 1,
      orderedPositions: [
        'GK',
        'LB',
        'CB',
        'CB',
        'RB',
        'LW',
        'CDM',
        'CM',
        'CAM',
        'RW',
        'ST',
      ],
    ),
  ];

  /// Mendapatkan formasi pelatih secara acak
  static FormasiPelatih getRandomFormasi({Random? rand}) {
    final random = rand ?? Random();
    return daftarFormasi[random.nextInt(daftarFormasi.length)];
  }

  /// Mendapatkan daftar 10 posisi spesifik berurutan untuk rekan tim utama (di luar user)
  static List<String> generateKomposisiPemainUtama({
    required FormasiPelatih formasi,
    required String userPosition,
  }) {
    final List<String> positions = List<String>.from(formasi.orderedPositions);

    // Bersihkan posisi user dari teks tambahan / kurung
    String cleanPos = userPosition;
    if (cleanPos.contains('(')) {
      cleanPos = cleanPos.split('(').first.trim();
    }
    if (cleanPos.contains(' - ')) {
      cleanPos = cleanPos.split(' - ').first.trim();
    }
    final String posLower = cleanPos.toLowerCase();

    // Hapus 1 slot posisi dari daftar 11 yang paling sesuai dengan posisi user
    int removeIndex = -1;
    if (posLower.contains('gk') || posLower.contains('kiper') || posLower.contains('goalkeeper')) {
      removeIndex = positions.indexWhere((p) => p.toLowerCase().contains('gk') || p.toLowerCase().contains('kiper'));
    } else if (posLower.contains('st') || posLower.contains('striker') || posLower.contains('penyerang') || posLower.contains('lw') || posLower.contains('rw')) {
      removeIndex = positions.lastIndexWhere((p) => p.toLowerCase().contains('st') || p.toLowerCase().contains('striker') || p.toLowerCase().contains('penyerang') || p.toLowerCase().contains('lw') || p.toLowerCase().contains('rw'));
    } else if (posLower.contains('cb') || posLower.contains('lb') || posLower.contains('rb') || posLower.contains('bek')) {
      removeIndex = positions.indexWhere((p) => p.toLowerCase().contains('cb') || p.toLowerCase().contains('lb') || p.toLowerCase().contains('rb') || p.toLowerCase().contains('bek'));
    } else if (posLower.contains('cdm') || posLower.contains('cm') || posLower.contains('cam') || posLower.contains('gelandang') || posLower.contains('sayap')) {
      removeIndex = positions.indexWhere((p) => p.toLowerCase().contains('cdm') || p.toLowerCase().contains('cm') || p.toLowerCase().contains('cam') || p.toLowerCase().contains('gelandang') || p.toLowerCase().contains('sayap'));
    }

    if (removeIndex != -1) {
      positions.removeAt(removeIndex);
    } else {
      // Fallback: hapus posisi terakhir jika tidak cocok
      if (positions.isNotEmpty) positions.removeLast();
    }

    return positions;
  }
}
