// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/fmm/posisi_fmm.dart

class PosisiFmmHelper {
  /// Mendapatkan opsi posisi Threesome FMM (1 Wanita & 2 Pria) berdasarkan lokasi
  static List<Map<String, dynamic>> getPosisiOptions({
    String location = 'Kamar Tidur',
  }) {
    final String locLower = location.toLowerCase();

    // Tentukan kategori lokasi
    String locCat = 'kamar_tidur';
    if (locLower.contains('mandi') || locLower.contains('bathtub') || locLower.contains('shower')) {
      locCat = 'kamar_mandi';
    } else if (locLower.contains('tamu') || locLower.contains('sofa')) {
      locCat = 'ruang_tamu';
    } else if (locLower.contains('dapur') || locLower.contains('meja makan')) {
      locCat = 'dapur';
    } else if (locLower.contains('hotel')) {
      locCat = 'hotel';
    } else if (locLower.contains('mobil') || locLower.contains('restoran') || locLower.contains('kafe') || locLower.contains('taman') || locLower.contains('kantor')) {
      locCat = 'luar_rumah';
    }

    if (locCat == 'kamar_mandi') {
      return [
        {
          'id': 'fmm_shower_eiffel',
          'label': 'Shower Eiffel Tower (Berdiri di Shower Eiffel) 🚿',
          'icon': '🚿',
          'description': 'Wanita berdiri di tengah shower dengan satu pria memberi rangsangan depan dan pria lain dari belakang.',
        },
        {
          'id': 'fmm_bathtub_surround',
          'label': 'Bathtub Double Surrounding (Apit Bathtub Busa) 🛁',
          'icon': '🛁',
          'description': 'Wanita duduk berendam di bathtub berbusa hangat diapit oleh dua pria di dalam bathtub.',
        },
        {
          'id': 'fmm_shower_dp',
          'label': 'Shower Wall Double Support (Menempel Dinding Shower) 💦',
          'icon': '💦',
          'description': 'Wanita bersandar di dinding shower basah mendapatkan penetrasi & kehangatan ganda dari dua pria.',
        },
        {
          'id': 'fmm_bathtub_edge',
          'label': 'Edge Bathtub Lap Riding (Duduk di Tepi Bathtub) 🧼',
          'icon': '🧼',
          'description': 'Wanita memacu ritme di paha pria pertama sambil pria kedua merangkul hangat dari belakang.',
        },
      ];
    } else if (locCat == 'ruang_tamu') {
      return [
        {
          'id': 'fmm_sofa_eiffel',
          'label': 'Sofa Eiffel Tower (Eiffel Tower di Sofa Ruang Tamu) 🛋️',
          'icon': '🛋️',
          'description': 'Wanita berlutut di sofa ruang tamu mendapat rangsangan oral & penetrasi simultan dari dua pria.',
        },
        {
          'id': 'fmm_sofa_sandwich',
          'label': 'Sofa FMM Sandwich (Wanita di Tengah Sofa) 🔥',
          'icon': '🔥',
          'description': 'Wanita duduk terlentang di sofa diapit dua pria di sisi kiri dan kanan dengan gairah panas.',
        },
        {
          'id': 'fmm_rug_dp',
          'label': 'Carpet Double Penetration (DP di Atas Karpet Ruang Tamu) ⚡',
          'icon': '⚡',
          'description': 'Berbaring miring di karpet ruang tamu dengan penetrasi ganda simultan dari dua pria.',
        },
        {
          'id': 'fmm_sofa_riding',
          'label': 'Sofa Lap Riding & Rear Support (Memangku di Sofa) 👑',
          'icon': '👑',
          'description': 'Wanita duduk memangku di paha pria pertama sambil pria kedua memeluk erat dari belakang.',
        },
      ];
    } else if (locCat == 'dapur') {
      return [
        {
          'id': 'fmm_kitchen_dp',
          'label': 'Kitchen Counter Double Penetration (DP Meja Dapur) 🍳',
          'icon': '🍳',
          'description': 'Wanita bersandar di meja dapur mendapatkan penetrasi ganda spontan dari dua pria.',
        },
        {
          'id': 'fmm_kitchen_eiffel',
          'label': 'Kitchen Table Eiffel Tower (Meja Makan Eiffel) 🍷',
          'icon': '🍷',
          'description': 'Wanita berlutut di meja makan dapur dengan rangsangan depan & belakang dari dua pria.',
        },
        {
          'id': 'fmm_kitchen_island',
          'label': 'Kitchen Island Double Hug (Kitchen Island FMM) 🥂',
          'icon': '🥂',
          'description': 'Berdiri memeluk kitchen island dapur dengan gairah spontan bersama dua pria.',
        },
      ];
    } else if (locCat == 'hotel') {
      return [
        {
          'id': 'fmm_king_dp',
          'label': 'King Bed Double Penetration (DP di Kasur Hotel) ⚡',
          'icon': '⚡',
          'description': 'Pengalaman puncak DP (Double Penetration) di atas kasur King Size kamar hotel berbintang.',
        },
        {
          'id': 'fmm_king_eiffel',
          'label': 'Hotel Suite Eiffel Tower (Eiffel Tower Suite Hotel) 🏰',
          'icon': '🏰',
          'description': 'Posisi Eiffel Tower mewah di tengah kamar suite hotel dengan penerangan lilin hangat.',
        },
        {
          'id': 'fmm_jacuzzi_dp',
          'label': 'Jacuzzi Suite Double Surrounding (Jacuzzi Mewah FMM) ♨️',
          'icon': '♨️',
          'description': 'Berendam intim di Jacuzzi hotel diiringi gairah sensasional dari dua pria.',
        },
        {
          'id': 'fmm_balcony_fmm',
          'label': 'Hotel Balcony FMM Sight (Balkon Kamar Hotel) 🏙️',
          'icon': '🏙️',
          'description': 'Bercinta FMM mendebarkan di balkon hotel dengan pemandangan kota malam.',
        },
      ];
    } else if (locCat == 'luar_rumah') {
      return [
        {
          'id': 'fmm_car_dp',
          'label': 'Car Backseat Double Penetration (Kursi Belakang Mobil) 🚗',
          'icon': '🚗',
          'description': 'Penetrasi ganda mendebarkan di dalam mobil yang diparkir di tempat privat.',
        },
        {
          'id': 'fmm_tent_fmm',
          'label': 'Camping Tent FMM Passion (Tenda Camping Luar) ⛺',
          'icon': '⛺',
          'description': 'Pengalaman FMM hangat di dalam tenda camping di bawah langit malam.',
        },
        {
          'id': 'fmm_office_desk',
          'label': 'Executive Desk FMM DP (Meja Kerja VIP) 💼',
          'icon': '💼',
          'description': 'Bercinta FMM terlarang di meja eksekutif seusai jam kerja kantor.',
        },
      ];
    }

    // Default: KAMAR TIDUR
    return [
      {
        'id': 'fmm_bed_dp',
        'label': 'Double Penetration / DP (Penetrasi Depan & Belakang) ⚡',
        'icon': '⚡',
        'description': 'Wanita berbaring miring / nungging mendapatkan penetrasi simultan depan & belakang dari 2 pria.',
      },
      {
        'id': 'fmm_bed_eiffel',
        'label': 'Eiffel Tower (Oral Depan & Penetrasi Belakang) 🗼',
        'icon': '🗼',
        'description': 'Wanita berlutut di tengah kasur memberi isapan oral pria 1 sambil pria 2 melakukan dorongan intim dari belakang.',
      },
      {
        'id': 'fmm_bed_sandwich',
        'label': 'Bed FMM Sandwich (Wanita di Tengah 2 Pria) 🔥',
        'icon': '🔥',
        'description': 'Wanita berbaring terlentang di kasur diapit 2 pria di kiri dan kanan dengan ciuman & belaian hangat.',
      },
      {
        'id': 'fmm_bed_lap_riding',
        'label': 'Lap Riding & Rear Hug (Memangku & Dekapan Belakang) 👑',
        'icon': '👑',
        'description': 'Wanita duduk memangku paha pria 1 sambil pria 2 memeluk mesra dan memberi kecupan hangat dari belakang.',
      },
      {
        'id': 'fmm_bed_spitroast',
        'label': 'Spitroast Exchange (Isapan & Sentuhan Bergantian) 💋',
        'icon': '💋',
        'description': 'Dua pria bertukar posisi memberikan rangsangan oral dan penetrasi bertahap kepada wanita.',
      },
    ];
  }
}
