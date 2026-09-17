// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/ffm/posisi_ffm.dart

class PosisiFfmHelper {
  /// Mendapatkan opsi posisi Threesome FFM (2 Wanita & 1 Pria) berdasarkan lokasi
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
          'id': 'ffm_shower_wall',
          'label': 'Shower Wall Double Hug (Sandaran Dinding Shower) 🚿',
          'icon': '🚿',
          'description': 'Pria bersandar di dinding shower sambil memeluk 2 wanita di bawah kucuran air hangat.',
        },
        {
          'id': 'ffm_bathtub_trio',
          'label': 'Bathtub Triplet Splash (Saling Menindih di Bathtub) 🛁',
          'icon': '🛁',
          'description': 'Ketiganya berendam di bathtub busa hangat, 2 wanita saling bermesraan sementara pria memberikan dorongan intim.',
        },
        {
          'id': 'ffm_shower_riding',
          'label': 'Shower Lap Double Riding (Duduk Pangku di Shower) 💦',
          'icon': '💦',
          'description': 'Satu wanita duduk memangku di paha pria sementara wanita kedua memberikan rangsangan oral.',
        },
        {
          'id': 'ffm_bathtub_edge',
          'label': 'Bathtub Edge Cunnilingus (Duduk di Pinggir Bathtub) 🧼',
          'icon': '🧼',
          'description': 'Dua wanita duduk berdampingan di tepi bathtub dengan pria memberikan sentuhan intim bergiliran.',
        },
      ];
    } else if (locCat == 'ruang_tamu') {
      return [
        {
          'id': 'ffm_sofa_sandwich',
          'label': 'Sofa Double Sandwich (Pria di Tengah Sofa) 🛋️',
          'icon': '🛋️',
          'description': 'Pria duduk santai di sofa ruang tamu diapit oleh 2 wanita di kiri dan kanan.',
        },
        {
          'id': 'ffm_sofa_riding',
          'label': 'Sofa Lap Riding & Oral (Memangku di Sofa Ruang Tamu) 🔥',
          'icon': '🔥',
          'description': 'Satu wanita memicu ritme duduk di paha pria, sementara wanita kedua berciuman mesra.',
        },
        {
          'id': 'ffm_rug_threesome',
          'label': 'Carpet Triplet Romance (Berbaring di Karpet Ruang Tamu) 🌙',
          'icon': '🌙',
          'description': 'Berbaring bertiga di atas karpet ruang tamu dengan lilin romantis dan belitan paha hangat.',
        },
        {
          'id': 'ffm_sofa_headrest',
          'label': 'Sofa Headrest Double Bliss (Duduk di Sandaran Sofa) 👑',
          'icon': '👑',
          'description': 'Dua wanita menikmati rangsangan bersandar di sofa ruang tamu.',
        },
      ];
    } else if (locCat == 'dapur') {
      return [
        {
          'id': 'ffm_kitchen_counter',
          'label': 'Kitchen Counter Double Riding (Duduk di Meja Dapur) 🍳',
          'icon': '🍳',
          'description': 'Satu wanita duduk di atas meja dapur sementara wanita kedua mendekap erat pria dari samping.',
        },
        {
          'id': 'ffm_kitchen_table',
          'label': 'Kitchen Table Sandwich (Meja Makan FFM) 🍷',
          'icon': '🍷',
          'description': 'Pria dan dua wanita memanfaatkan meja makan dapur untuk posisi interaktif hangat.',
        },
        {
          'id': 'ffm_kitchen_standing',
          'label': 'Kitchen Island Double Support (Berdiri di Kitchen Island) 🥂',
          'icon': '🥂',
          'description': 'Berdiri bersama memeluk kitchen island dapur dengan gairah spontan.',
        },
      ];
    } else if (locCat == 'hotel') {
      return [
        {
          'id': 'ffm_king_sandwich',
          'label': 'King Bed Double Crown (Pria di Tengah Kasur Hotel) 👑',
          'icon': '👑',
          'description': 'Di atas kasur King Size kamar hotel, pria dikelilingi belitan mesra dua wanita.',
        },
        {
          'id': 'ffm_jacuzzi_bliss',
          'label': 'Jacuzzi Suite FFM Splash (Jacuzzi Mewah Hotel) ♨️',
          'icon': '♨️',
          'description': 'Nikmati sensasi gelembung hangat air Jacuzzi hotel bersama dua wanita dengan minuman anggur.',
        },
        {
          'id': 'ffm_balcony_luxury',
          'label': 'Hotel Balcony Triple Sight (Balkon Kamar Hotel) 🏙️',
          'icon': '🏙️',
          'description': 'Posisi intim di balkon hotel dengan pemandangan kota malam yang memukau.',
        },
        {
          'id': 'ffm_suite_couch',
          'label': 'Suite Couch Triple Passion (Sofa Suite Hotel) 🛋️',
          'icon': '🛋️',
          'description': 'Bercinta bertiga di sofa ruang tengah suite hotel berbintang.',
        },
      ];
    } else if (locCat == 'luar_rumah') {
      return [
        {
          'id': 'ffm_car_backseat',
          'label': 'Car Backseat FFM Hug (Kursi Belakang Mobil) 🚗',
          'icon': '🚗',
          'description': 'Sensasi intim mendebarkan di kursi belakang mobil yang tertutup rapat.',
        },
        {
          'id': 'ffm_tent_outdoor',
          'label': 'Camping Tent FFM Camping (Kemah Alam Luar) ⛺',
          'icon': '⛺',
          'description': 'Bercinta hangat bertiga di dalam tenda camping di bawah sinar bintang.',
        },
        {
          'id': 'ffm_office_desk',
          'label': 'Executive Desk Double Passion (Meja Kerja VIP) 💼',
          'icon': '💼',
          'description': 'Sensasi terlarang di meja kerja eksekutif seusai jam kantor.',
        },
      ];
    }

    // Default: KAMAR TIDUR
    return [
      {
        'id': 'ffm_bed_sandwich',
        'label': 'Bed Double Sandwich (Pria di Tengah Kasur) 🖈️',
        'icon': '🖈️',
        'description': 'Pria berbaring telentang di tengah kasur dengan 2 wanita mendekap mesra di sisi kiri dan kanan.',
      },
      {
        'id': 'ffm_double_riding',
        'label': 'Bed Lap Riding & Oral (Memangku & Rangsangan Oral) 🔥',
        'icon': '🔥',
        'description': 'Satu wanita memacu ritme duduk memangku pria, sementara wanita kedua berciuman bibir mesra.',
      },
      {
        'id': 'ffm_spitroast_ffm',
        'label': 'Double Pleasure Exchange (Pertukaran Sensasi Berdua) 💋',
        'icon': '💋',
        'description': 'Dua wanita saling bergantian memberi isapan dan sentuhan intim kepada pria di kasur.',
      },
      {
        'id': 'ffm_bed_queen_riding',
        'label': 'Queen Straddling (Saling Menindih & Berpelukan) 👑',
        'icon': '👑',
        'description': 'Kedua wanita saling menindih mesra di atas pria sambil bertukar desahan hangat.',
      },
      {
        'id': 'ffm_bed_spooning',
        'label': 'Triple Spooning Romance (Spooning Bertiga) 🌙',
        'icon': '🌙',
        'description': 'Berbaring miring bertiga saling memeluk erat dari belakang dengan suasana romantis kamar tidur.',
      },
    ];
  }
}
