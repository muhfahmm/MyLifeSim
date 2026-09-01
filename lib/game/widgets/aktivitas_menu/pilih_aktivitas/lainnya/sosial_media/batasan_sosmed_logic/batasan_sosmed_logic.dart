// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/batasan_sosmed_logic/batasan_sosmed_logic.dart

enum JenisPembatasanSosmed {
  tidakAda,      // Akses sosmed normal
  blokirTotal,   // Diblokir total oleh pemerintah (misal: China, Korea Utara, Iran, Turkmenistan, Afghanistan, Myanmar)
  batasanUsia,   // Di bawah 16/15 tahun dilarang (misal: Australia, Indonesia, Brasil, Malaysia, Turki, Denmark, Yunani, Spanyol, Inggris, Kanada, Prancis, Polandia, Slovenia, UAE, Rusia)
}

class HasillPemeriksaanSosmed {
  final bool diizinkan;
  final JenisPembatasanSosmed jenis;
  final String judul;
  final String pesan;

  const HasillPemeriksaanSosmed({
    required this.diizinkan,
    required this.jenis,
    required this.judul,
    required this.pesan,
  });
}

class BatasanSosmedLogic {
  /// Daftar negara dengan Pemblokiran Total Sosial Media (Global / Domestik Intranet)
  static const Set<String> negaraBlokirTotal = {
    'china',
    'korea utara',
    'iran',
    'turkmenistan',
    'afghanistan',
    'myanmar',
  };

  /// Daftar negara dengan Pembatasan Usia Ketat (Usia minimal 16 atau 15 tahun)
  static const Map<String, int> negaraBatasanUsia = {
    // Usia Minimal 16 Tahun
    'australia': 16,
    'indonesia': 16,
    'brasil': 16,
    'malaysia': 16,
    'spanyol': 16,
    'inggris': 16,
    'inggris raya': 16,
    'uk': 16,
    'kanada': 16,

    // Usia Minimal 15 Tahun
    'turki': 15,
    'denmark': 15,
    'yunani': 15,
    'prancis': 15,
    'polandia': 15,
    'slovenia': 15,
    'uae': 15,
    'uni emirat arab': 15,
    'rusia': 15,
  };

  /// Memeriksa apakah karakter diizinkan mengakses sosial media berdasarkan negara dan usia.
  static HasillPemeriksaanSosmed periksaAksesSosmed({
    required String country,
    required int age,
  }) {
    final countryLower = country.trim().toLowerCase();

    // 1. Cek Blokir Total
    if (negaraBlokirTotal.contains(countryLower)) {
      return HasillPemeriksaanSosmed(
        diizinkan: false,
        jenis: JenisPembatasanSosmed.blokirTotal,
        judul: 'Akses Diblokir Pemerintah',
        pesan: 'Akses Sosial Media diblokir oleh pemerintah di $country.',
      );
    }

    // 2. Cek Pembatasan Usia Khusus Negara
    if (negaraBatasanUsia.containsKey(countryLower)) {
      final minAge = negaraBatasanUsia[countryLower]!;
      if (age < minAge) {
        return HasillPemeriksaanSosmed(
          diizinkan: false,
          jenis: JenisPembatasanSosmed.batasanUsia,
          judul: 'Pembatasan Usia ($minAge+)',
          pesan: 'Sesuai regulasi di $country, kamu harus berusia minimal $minAge tahun untuk menggunakan sosial media.',
        );
      }
    }

    // 3. Batasan Usia Standar Global (Minimal 12 Tahun) jika negara tidak termasuk daftar khusus di atas
    const int minAgeStandard = 12;
    if (age < minAgeStandard) {
      return HasillPemeriksaanSosmed(
        diizinkan: false,
        jenis: JenisPembatasanSosmed.batasanUsia,
        judul: 'Akses Dibatasi',
        pesan: 'Kamu harus berusia minimal $minAgeStandard tahun untuk memiliki akun sosial media.',
      );
    }

    // 4. Diizinkan
    return const HasillPemeriksaanSosmed(
      diizinkan: true,
      jenis: JenisPembatasanSosmed.tidakAda,
      judul: 'Diizinkan',
      pesan: 'Akses sosial media aktif.',
    );
  }
}
