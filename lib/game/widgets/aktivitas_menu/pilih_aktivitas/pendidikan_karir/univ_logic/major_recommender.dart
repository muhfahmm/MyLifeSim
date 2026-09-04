// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/major_recommender.dart

class MajorRecommender {
  /// Mengembalikan map rekomendasi jurusan [Major: BadgeLabel] berdasarkan nama negara tempat tinggal.
  /// Membawa kecerdasan untuk 200+ negara dengan sistem pemetaan kawasan / spesialisasi ekonomi & teknologi.
  static Map<String, String> getRecommendationsForCountry(String countryName) {
    final String c = countryName.toLowerCase().trim();

    // 1. TEKNOLOGI & INOVASI TINGGI (USA, China, Jepang, Korea Selatan, Jerman, Singapura, Taiwan, Inggris, Israel, Finlandia, dll.)
    if (_matches(c, [
      'amerika serikat', 'china', 'jepang', 'korea selatan', 'jerman',
      'singapura', 'taiwan', 'inggris', 'israel', 'finlandia',
      'swedia', 'swiss', 'estonia', 'kanada', 'irlandia'
    ])) {
      return {
        'Teknik Informatika': '⭐️ Top Industri',
        'Sistem Informasi': '🔥 Populer',
        'Pemasaran Digital': '🚀 Prospek Tinggi',
        'Teknik Elektro': '💡 Unggulan',
      };
    }

    // 2. KEUANGAN & BISNIS GLOBAL (Inggris, Swiss, Hong Kong, Singapura, UEA, Qatar, Luksemburg, Bahrain, Monako, Liechtenstein)
    if (_matches(c, [
      'uni emirat arab', 'qatar', 'luksemburg', 'bahrain', 'monako',
      'liechtenstein', 'hong kong', 'kuwait', 'arab saudi'
    ])) {
      return {
        'Manajemen': '⭐️ Pilihan Utama',
        'Perbankan & Keuangan': '💎 Gaji Tinggi',
        'Akuntansi': '🔥 Banyak Dicari',
        'Hubungan Internasional': '🌐 Karir Global',
      };
    }

    // 3. KESEHATAN & MEDIS (Kuba, Australia, Belgia, Denmark, Prancis, Italia, Spanyol, Austria, Norwegia, Belanda, Selandia Baru)
    if (_matches(c, [
      'kuba', 'australia', 'belgia', 'denmark', 'prancis',
      'italia', 'spanyol', 'austria', 'norwegia', 'belanda',
      'selandia baru', 'portugal', 'yunani'
    ])) {
      return {
        'Kedokteran': '⭐️ Sangat Diminati',
        'Farmasi': '🔥 Industri Besar',
        'Keperawatan': '❤️ Banyak Dibutuhkan',
        'Gizi & Ilmu Pangan': '🥗 Prospek Cerah',
      };
    }

    // 4. PARIWISATA, HOSPITALITAS & KREATIF (Thailand, Maladewa, Maladewa, Karibia, Italia, Prancis, Bali/Indonesia, Filipina, Mesir, Kroasia, Turki, Maroko)
    if (_matches(c, [
      'thailand', 'maladewa', 'bahama', 'barbados', 'fiji',
      'filipina', 'mesir', 'kroasia', 'turki', 'maroko',
      'jamaika', 'dominika', 'mauritania', 'seychelles', 'vanuatu'
    ])) {
      return {
        'Manajemen Perhotelan': '⭐️ Karir Utama',
        'Desain Komunikasi Visual (DKV)': '🎨 Sektor Kreatif',
        'Ilmu Komunikasi': '🔥 Banyak Dicari',
        'Pemasaran Digital': '🚀 Bisnis Lokal',
      };
    }

    // 5. PERTANIAN, SUMBER DAYA ALAM & ENERGI (Brasil, Argentina, Indonesia, Vietnam, Nigeria, Angola, Ukraina, Kazakhstan, Rusia, Peru, Ekuador)
    if (_matches(c, [
      'brasil', 'argentina', 'indonesia', 'vietnam', 'nigeria',
      'angola', 'ukraina', 'kazakhstan', 'rusia', 'peru',
      'ekuador', 'kolombia', 'ghana', 'kosta rika', 'bolivia'
    ])) {
      return {
        'Agroteknologi': '🌾 Sektor Vital',
        'Teknik Sipil': '🏗️ Pembangunan',
        'Teknik Mesin': '⚙️ Industri Tambang',
        'Manajemen': '💼 Bisnis Daerah',
      };
    }

    // 6. REGIONAL DEFAULT / LAINNYA (Negara berkembang / umum)
    return {
      'Teknik Informatika': '⭐️ Favorit Mahasiswa',
      'Manajemen': '🔥 Prospek Karir',
      'Hukum': '⚖️ Profesi Prestisius',
      'Kedokteran': '💉 Sangat Dibutuhkan',
    };
  }

  /// Menghitung biaya kuliah per tahun (USD) secara dinamis berdasarkan faktor negara dan spesialisasi jurusan.
  static int calculateTuitionFee(String countryName, String major) {
    final String c = countryName.toLowerCase().trim();

    // 1. Multiplier Biaya Berdasarkan Ekonomi Negara
    double countryMultiplier = 1.0;
    if (_matches(c, ['amerika serikat', 'swiss', 'inggris', 'kanada', 'australia'])) {
      countryMultiplier = 8.0; // ~$20k - $40k/tahun
    } else if (_matches(c, ['singapura', 'jepang', 'korea selatan', 'jerman', 'belanda', 'swedia', 'denmark', 'uni emirat arab', 'qatar', 'hong kong', 'luksemburg'])) {
      countryMultiplier = 5.0; // ~$12.5k - $25k/tahun
    } else if (_matches(c, ['china', 'prancis', 'italia', 'spanyol', 'austria', 'selandia baru', 'arab saudi', 'belgia'])) {
      countryMultiplier = 3.5; // ~$8.75k - $17.5k/tahun
    } else if (_matches(c, ['indonesia', 'malaysia', 'thailand', 'filipina', 'vietnam', 'india', 'brazil', 'mexico', 'turki', 'mesir'])) {
      countryMultiplier = 1.2; // ~$3k - $6k/tahun
    } else {
      countryMultiplier = 1.0; // Base ~$2.5k - $5k/tahun
    }

    // 2. Base Cost Berdasarkan Rumpun/Kompleksitas Jurusan
    int baseCost = 2500;
    if (major.contains('Kedokteran') || major.contains('Gigi')) {
      baseCost = 5000;
    } else if (major.startsWith('Teknik') || major.contains('Informatika') || major.contains('Farmasi') || major.contains('Arsitektur')) {
      baseCost = 3500;
    } else if (major.contains('Manajemen') || major.contains('Akuntansi') || major.contains('Hukum') || major.contains('Komunikasi') || major.contains('Psikologi')) {
      baseCost = 2800;
    } else if (major.contains('Seni') || major.contains('Desain') || major.contains('Film') || major.contains('Musik')) {
      baseCost = 3000;
    } else {
      baseCost = 2500;
    }

    return (baseCost * countryMultiplier).round();
  }

  static bool _matches(String country, List<String> targets) {
    return targets.any((t) => country.contains(t) || t.contains(country));
  }
}
