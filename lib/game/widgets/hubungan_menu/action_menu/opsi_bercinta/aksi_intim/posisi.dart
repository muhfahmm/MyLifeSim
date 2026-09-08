// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/posisi.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class PosisiSeksHelper {
  /// Mendapatkan daftar opsi posisi seks secara dinamis berdasarkan gender pasangan dan lokasi
  static List<Map<String, dynamic>> getPosisiOptions({
    required String myGender,
    required String partnerGender,
    String location = 'Kamar Tidur',
  }) {
    final String g1 = myGender.trim().toLowerCase();
    final String g2 = partnerGender.trim().toLowerCase();
    final String locLower = location.toLowerCase();

    // Tentukan kategori lokasi:
    // 'kamar_mandi', 'ruang_tamu', 'dapur', 'kamar_tidur' (default rumah), atau 'luar_rumah'
    String locCat = 'kamar_tidur';
    if (locLower.contains('mandi') || locLower.contains('bathtub') || locLower.contains('shower')) {
      locCat = 'kamar_mandi';
    } else if (locLower.contains('tamu') || locLower.contains('sofa')) {
      locCat = 'ruang_tamu';
    } else if (locLower.contains('dapur') || locLower.contains('meja makan')) {
      locCat = 'dapur';
    } else if (locLower.contains('mobil') || locLower.contains('hotel') || locLower.contains('restoran') || locLower.contains('kafe') || locLower.contains('taman') || locLower.contains('kantor')) {
      locCat = 'luar_rumah';
    }

    // -------------------------------------------------------------------------
    // 1. WANITA DENGAN WANITA (LESBIAN)
    // -------------------------------------------------------------------------
    if (g1 == 'perempuan' && g2 == 'perempuan') {
      if (locCat == 'kamar_mandi') {
        return [
          {
            'id': 'standing_wall',
            'label': 'Shower Wall Stand (Berdiri Menempel Dinding Shower) 🚿',
            'icon': '🚿',
            'description': 'Satu wanita merangkul dan mengangkat paha pasangannya di bawah kucuran air shower hangat.',
          },
          {
            'id': 'tribadism',
            'label': 'Bathtub Straddling (Saling Menindih di Bathtub) 🛁',
            'icon': '🛁',
            'description': 'Satu wanita menindih panggul pasangannya di dalam bathtub berbusa hangat.',
          },
          {
            'id': 'face_sitting',
            'label': 'Edge Sitting Cunnilingus (Duduk di Pinggir Bathtub/Wastafel) 🧼',
            'icon': '🧼',
            'description': 'Satu wanita duduk di pinggir bathtub/wastafel membiarkan pasangannya memberi rangsangan oral.',
          },
          {
            'id': 'riding',
            'label': 'Wet Lap Riding (Duduk Pangku di Atas Paha Basah) 💦',
            'icon': '💦',
            'description': 'Duduk memangku di atas paha pasangan di lantai kamar mandi / bangku shower.',
          },
          {
            'id': 'scissoring',
            'label': 'Wet Scissoring (Gunting Basah di Lantai/Bathtub) ✂️',
            'icon': '✂️',
            'description': 'Berbaring miring menyilang paha di atas matras/bathtub kamar mandi sambil saling menggesekkan klitoris.',
          },
        ];
      } else if (locCat == 'ruang_tamu') {
        return [
          {
            'id': 'riding',
            'label': 'Sofa Lap Riding (Duduk Memangku di Sofa) 🛋️',
            'icon': '🛋️',
            'description': 'Satu wanita duduk memangku di atas paha pasangannya di sofa ruang tamu.',
          },
          {
            'id': 'tribadism',
            'label': 'Sofa Straddling (Menindih di Sofa Ruang Tamu) 👩‍❤️‍💋‍👩',
            'icon': '👩‍❤️‍💋‍👩',
            'description': 'Satu wanita menindih di atas panggul pasangannya yang berbaring di sofa.',
          },
          {
            'id': 'face_sitting',
            'label': 'Sofa Headrest Cunnilingus (Duduk di Atas Sandaran Sofa) 👑',
            'icon': '👑',
            'description': 'Satu wanita duduk di sandaran sofa membiarkan pasangannya melakukan isapan oral dari bawah.',
          },
          {
            'id': 'spooning_lesbian',
            'label': 'Sofa Spooning (Menyamping di Sofa) 🌙',
            'icon': '🌙',
            'description': 'Berbaring miring bersandar di sofa ruang tamu sambil mendekap intim dari belakang.',
          },
          {
            'id': 'scissoring',
            'label': 'Rug Scissoring (Scissoring di Atas Karpet Ruang Tamu) ✂️',
            'icon': '✂️',
            'description': 'Rebahan menyilang di atas karpet empuk ruang tamu sambil mengunci kaki & menggesekkan area intim.',
          },
        ];
      } else if (locCat == 'dapur') {
        return [
          {
            'id': 'face_sitting',
            'label': 'Kitchen Counter Cunnilingus (Duduk di Meja Dapur) 🍽️',
            'icon': '🍽️',
            'description': 'Duduk di atas counter/meja dapur sementara pasangannya berdiri memberikan stimulasi oral.',
          },
          {
            'id': 'standing_wall',
            'label': 'Kitchen Counter Press (Menempel di Meja Dapur) 🧱',
            'icon': '🧱',
            'description': 'Bersandar di meja dapur, merangkul paha pasangan untuk gesekan panggul berdiri.',
          },
          {
            'id': 'riding',
            'label': 'Kitchen Chair Lap Riding (Pangku di Kursi Makan) 🪑',
            'icon': '🪑',
            'description': 'Duduk memangku di atas paha pasangan yang sedang duduk di kursi meja makan.',
          },
          {
            'id': 'tribadism',
            'label': 'Countertop Straddling (Menindih di Meja Dapur) 👩‍❤️‍💋‍👩',
            'icon': '👩‍❤️‍💋‍👩',
            'description': 'Satu wanita terlentang di meja dapur, pasangannya menindih mesra di atasnya.',
          },
          {
            'id': 'spooning_lesbian',
            'label': 'Standing Back Embrace (Dekapan Belakang Dapur) 🌙',
            'icon': '🌙',
            'description': 'Berdiri merapat di dekat kulkas/counter dapur sambil memeluk & menggesekkan panggul dari belakang.',
          },
        ];
      } else if (locCat == 'luar_rumah') {
        return [
          {
            'id': 'riding',
            'label': 'Car / Chair Lap Riding (Memangku di Kursi / Tempat Luar) 🚗',
            'icon': '🚗',
            'description': 'Duduk memangku di atas paha pasangan dalam lingkungan privat di luar rumah.',
          },
          {
            'id': 'standing_wall',
            'label': 'Wall Stand Press (Berdiri Menempel Dinding Luar/Hotel) 🧱',
            'icon': '🧱',
            'description': 'Menempelkan tubuh ke dinding privat sambil merangkul paha pasangan.',
          },
          {
            'id': 'face_sitting',
            'label': 'Chair / Seat Cunnilingus (Duduk di Kursi/Wajah) 🪑',
            'icon': '🪑',
            'description': 'Duduk di atas kursi/wajah pasangan memberikan kenikmatan oral yang menggairahkan.',
          },
          {
            'id': 'spooning_lesbian',
            'label': 'Reclined Spooning (Menyamping Dekapan Luar) 🌙',
            'icon': '🌙',
            'description': 'Berbaring miring mendekap mesra dari belakang di tempat peristirahatan privat.',
          },
          {
            'id': 'tribadism',
            'label': 'Intimate Straddling (Menindih Privat) 👩‍❤️‍💋‍👩',
            'icon': '👩‍❤️‍💋‍👩',
            'description': 'Saling menindih dan menggesekkan area kewanitaan di lokasi spesial pilihan.',
          },
        ];
      } else {
        // Default Kamar Tidur (5 opsi utama)
        return [
          {
            'id': 'scissoring',
            'label': 'Bed Scissoring (Gunting di Kasur) ✂️',
            'icon': '✂️',
            'description': 'Kedua wanita berbaring miring menyilang paha di atas kasur empuk dan saling menggesekkan klitoris.',
          },
          {
            'id': 'tribadism',
            'label': 'Bed Straddling (Saling Menindih Tatap Muka) 👩‍❤️‍💋‍👩',
            'icon': '👩‍❤️‍💋‍👩',
            'description': 'Satu wanita menindih di atas panggul pasangannya di ranjang, bertatap muka secara merata.',
          },
          {
            'id': 'face_sitting',
            'label': 'Face Sitting / Cunnilingus (Duduk di Wajah) 👑',
            'icon': '👑',
            'description': 'Duduk santai di atas wajah pasangannya yang memberikan rangsangan isapan oral dari bawah.',
          },
          {
            'id': 'riding',
            'label': 'Lap Riding (Duduk di Atas Paha / Pangkuan) 💃',
            'icon': '💃',
            'description': 'Duduk memangku di atas paha pasangannya, mengontrol tempo goyangan pinggul.',
          },
          {
            'id': 'spooning_lesbian',
            'label': 'Bed Spooning (Menyamping Dekapan Belakang) 🌙',
            'icon': '🌙',
            'description': 'Berbaring miring mendekap dari belakang di kasur, menggesekkan panggul dan paha.',
          },
        ];
      }
    }

    // -------------------------------------------------------------------------
    // 2. PRIA DENGAN PRIA (GAY)
    // -------------------------------------------------------------------------
    if (g1 == 'laki-laki' && g2 == 'laki-laki') {
      if (locCat == 'kamar_mandi') {
        return [
          {
            'id': 'standing_gay',
            'label': 'Shower Wall Anal (Penetrasi Anal Berdiri di Shower) 🚿',
            'icon': '🚿',
            'description': 'Satu pria menopang pasangannya yang menempel di dinding shower basah untuk penetrasi anal.',
          },
          {
            'id': 'doggy_gay',
            'label': 'Wet Doggy Style (Anal Dari Belakang di Kamar Mandi) 🐾',
            'icon': '🐾',
            'description': 'Merangkul pinggul dari belakang di bawah guyuran air hangat shower.',
          },
          {
            'id': 'cowgirl_gay',
            'label': 'Bathtub Riding (Duduk Memangku Anal di Bathtub) 🛁',
            'icon': '🛁',
            'description': 'Duduk memangku di atas penis pasangan di dalam bathtub berbusa hangat.',
          },
          {
            'id': 'frottage',
            'label': 'Wet Frottage (Gesekan Penis Basah) 💥',
            'icon': '💥',
            'description': 'Saling menggesekkan penis di bawah kucuran air shower tanpa penetrasi anal.',
          },
          {
            'id': 'spooning_gay',
            'label': 'Wet Spooning Anal (Anal Menyamping Basah) 🌙',
            'icon': '🌙',
            'description': 'Berbaring miring mendekap dari belakang di lantai/bathtub basah.',
          },
        ];
      } else if (locCat == 'ruang_tamu') {
        return [
          {
            'id': 'cowgirl_gay',
            'label': 'Sofa Riding (Duduk Memangku Anal di Sofa) 🛋️',
            'icon': '🛋️',
            'description': 'Satu pria duduk memangku di atas penis pasangannya di sofa ruang tamu.',
          },
          {
            'id': 'doggy_gay',
            'label': 'Sofa Doggy Style (Anal Belakang di Sofa) 🐾',
            'icon': '🐾',
            'description': 'Bersandar di lengan sofa, pasangan melakukan penetrasi anal dari belakang.',
          },
          {
            'id': 'missionary_gay',
            'label': 'Sofa Missionary Anal (Anal Tatap Muka di Sofa) 👨‍❤️‍👨',
            'icon': '👨‍❤️‍👨',
            'description': 'Menindih dari depan bertatap muka di atas sofa empuk ruang tamu.',
          },
          {
            'id': 'spooning_gay',
            'label': 'Sofa Spooning Anal (Anal Menyamping di Sofa) 🌙',
            'icon': '🌙',
            'description': 'Rebahan miring bersandar di sofa sambil penetrasi anal perlahan.',
          },
          {
            'id': 'frottage',
            'label': 'Rug Frottage (Gesekan Penis di Karpet Ruang Tamu) 💥',
            'icon': '💥',
            'description': 'Berpelukan erat di karpet ruang tamu sambil menggesekkan penis tanpa penetrasi.',
          },
        ];
      } else if (locCat == 'dapur') {
        return [
          {
            'id': 'standing_gay',
            'label': 'Kitchen Counter Anal (Anal Berdiri di Meja Dapur) 🍽️',
            'icon': '🍽️',
            'description': 'Pasangan membungkuk di meja dapur untuk penetrasi anal berdiri.',
          },
          {
            'id': 'cowgirl_gay',
            'label': 'Kitchen Chair Riding (Duduk Memangku Anal di Kursi Makan) 🪑',
            'icon': '🪑',
            'description': 'Duduk memangku di atas penis pasangan yang sedang duduk di kursi meja makan.',
          },
          {
            'id': 'doggy_gay',
            'label': 'Kitchen Doggy Style (Anal Dari Belakang di Dapur) 🐾',
            'icon': '🐾',
            'description': 'Merangkalk/menungging di dekat meja dapur dengan penetrasi anal mendalam.',
          },
          {
            'id': 'missionary_gay',
            'label': 'Countertop Missionary (Anal Tatap Muka di Meja Dapur) 👨‍❤️‍👨',
            'icon': '👨‍❤️‍👨',
            'description': 'Berbaring terlentang di meja dapur, pasangan menindih bertatap muka.',
          },
          {
            'id': 'frottage',
            'label': 'Kitchen Standing Frottage (Gesekan Penis Berdiri di Dapur) 💥',
            'icon': '💥',
            'description': 'Berdiri berpelukan di dekat meja dapur sambil menggesekkan penis intim.',
          },
        ];
      } else if (locCat == 'luar_rumah') {
        return [
          {
            'id': 'cowgirl_gay',
            'label': 'Seat / Car Riding (Memangku Anal di Luar) 🚗',
            'icon': '🚗',
            'description': 'Duduk memangku di atas penis pasangan di ruang privat luar rumah.',
          },
          {
            'id': 'standing_gay',
            'label': 'Wall Press Anal (Anal Berdiri Menempel Dinding Privat) 🧱',
            'icon': '🧱',
            'description': 'Menempel ke dinding privat untuk penetrasi anal berdiri yang bergairah.',
          },
          {
            'id': 'doggy_gay',
            'label': 'Reclined Doggy Style (Anal Dari Belakang Tempat Luar) 🐾',
            'icon': '🐾',
            'description': 'Menungging santai dengan penetrasi anal dari belakang.',
          },
          {
            'id': 'spooning_gay',
            'label': 'Private Spooning Anal (Anal Menyamping Luar) 🌙',
            'icon': '🌙',
            'description': 'Berbaring miring mendekap erat dari belakang di tempat peristirahatan.',
          },
          {
            'id': 'frottage',
            'label': 'Intimate Frottage (Gesekan Penis Tempat Luar) 💥',
            'icon': '💥',
            'description': 'Saling menggesekkan penis di area privat luar rumah.',
          },
        ];
      } else {
        // Default Kamar Tidur (5 opsi utama)
        return [
          {
            'id': 'missionary_gay',
            'label': 'Bed Missionary Anal (Anal Tatap Muka di Kasur) 👨‍❤️‍👨',
            'icon': '👨‍❤️‍👨',
            'description': 'Berbaring telentang di ranjang menaikkan paha, pasangan menindih bertatap muka.',
          },
          {
            'id': 'doggy_gay',
            'label': 'Bed Doggy Style (Anal Dari Belakang di Kasur) 🐾',
            'icon': '🐾',
            'description': 'Merangkak/menungging di kasur empuk, pasangan penetrasi dari belakang.',
          },
          {
            'id': 'cowgirl_gay',
            'label': 'Bed Riding (Duduk Memangku Anal di Atas Penis) 🤠',
            'icon': '🤠',
            'description': 'Duduk memangku di atas penis pasangan di ranjang, mengontrol tempo goyangan.',
          },
          {
            'id': 'spooning_gay',
            'label': 'Bed Spooning Anal (Anal Menyamping di Kasur) 🌙',
            'icon': '🌙',
            'description': 'Berbaring miring mendekap erat dari belakang di kasur dengan penetrasi anal perlahan.',
          },
          {
            'id': 'frottage',
            'label': 'Bed Frottage (Gesekan Penis di Kasur) 💥',
            'icon': '💥',
            'description': 'Saling menggesekkan penis di atas kasur empuk tanpa penetrasi anal.',
          },
        ];
      }
    }

    // -------------------------------------------------------------------------
    // 3. PRIA DENGAN WANITA (HETERO - HETEROSEXUAL)
    // -------------------------------------------------------------------------
    if (locCat == 'kamar_mandi') {
      return [
        {
          'id': 'standing_wall',
          'label': 'Shower Standing (Penetrasi Berdiri di Shower) 🚿',
          'icon': '🚿',
          'description': 'Mengangkat satu paha wanita yang bersandar di dinding shower basah di bawah kucuran air hangat.',
        },
        {
          'id': 'doggy',
          'label': 'Wet Doggy Style (Dari Belakang di Kamar Mandi) 🐾',
          'icon': '🐾',
          'description': 'Wanita membungkuk di pinggir bathtub / dinding shower, penetrasi dari belakang.',
        },
        {
          'id': 'cowgirl',
          'label': 'Bathtub Cowgirl (Wanita Di Atas di Bathtub) 🛁',
          'icon': '🛁',
          'description': 'Wanita duduk memangku di atas tubuh pria di dalam bathtub berbusa hangat.',
        },
        {
          'id': 'missionary',
          'label': 'Edge Bath Missionary (Tatap Muka di Matras/Bathtub) 🧼',
          'icon': '🧼',
          'description': 'Berbaring telentang di area kamar mandi basah, pria menindih dari depan.',
        },
        {
          'id': 'spooning',
          'label': 'Wet Spooning (Menyamping Basah) 🌙',
          'icon': '🌙',
          'description': 'Berbaring menyamping bersama di kamar mandi sambil penetrasi santai dari belakang.',
        },
      ];
    } else if (locCat == 'ruang_tamu') {
      return [
        {
          'id': 'cowgirl',
          'label': 'Sofa Cowgirl (Wanita Di Atas di Sofa) 💃',
          'icon': '💃',
          'description': 'Pasangan wanita duduk memangku dan mengontrol tempo goyangan di atas sofa ruang tamu.',
        },
        {
          'id': 'doggy',
          'label': 'Sofa Doggy Style (Dari Belakang di Sofa) 🐾',
          'icon': '🐾',
          'description': 'Wanita bertumpu pada sandaran sofa ruang tamu, pria penetrasi ritmis dari belakang.',
        },
        {
          'id': 'missionary',
          'label': 'Sofa Missionary (Tatap Muka di Sofa) 👩‍❤️‍👨',
          'icon': '👩‍❤️‍👨',
          'description': 'Menindih bertatap muka mesra di atas sofa empuk ruang tamu.',
        },
        {
          'id': 'spooning',
          'label': 'Sofa Spooning (Menyamping di Sofa) 🌙',
          'icon': '🌙',
          'description': 'Rebahan miring bersandar di sofa ruang tamu sambil penetrasi santai dari belakang.',
        },
        {
          'id': 'posisi_69',
          'label': 'Rug 69 (Posisi 69 di Karpet Ruang Tamu) 🔄',
          'icon': '🔄',
          'description': 'Rebahan berbalik arah di atas karpet empuk ruang tamu untuk oral bersamaan.',
        },
      ];
    } else if (locCat == 'dapur') {
      return [
        {
          'id': 'standing_wall',
          'label': 'Kitchen Counter Standing (Berdiri di Meja Dapur) 🍽️',
          'icon': '🍽️',
          'description': 'Wanita duduk di pinggir meja dapur, pria berdiri di depannya untuk penetrasi mendalam.',
        },
        {
          'id': 'cowgirl',
          'label': 'Kitchen Chair Cowgirl (Duduk Di Atas di Kursi Makan) 🪑',
          'icon': '🪑',
          'description': 'Pria duduk di kursi meja makan, wanita memangku di atasnya mengayunkan pinggul.',
        },
        {
          'id': 'doggy',
          'label': 'Kitchen Counter Doggy (Dari Belakang di Meja Dapur) 🐾',
          'icon': '🐾',
          'description': 'Wanita membungkuk bertumpu di meja dapur, pria penetrasi dari belakang.',
        },
        {
          'id': 'missionary',
          'label': 'Countertop Missionary (Tatap Muka di Meja Dapur) 👩‍❤️‍👨',
          'icon': '👩‍❤️‍👨',
          'description': 'Wanita berbaring terlentang di meja dapur, pria menindih mesra dari atas.',
        },
        {
          'id': 'spooning',
          'label': 'Kitchen Standing Spooning (Dekapan Belakang Dapur) 🌙',
          'icon': '🌙',
          'description': 'Berdiri merapat di dekat counter dapur, penetrasi menyamping/belakang.',
        },
      ];
    } else if (locCat == 'luar_rumah') {
      return [
        {
          'id': 'cowgirl',
          'label': 'Seat / Car Cowgirl (Wanita Di Atas di Luar Rumah) 🚗',
          'icon': '🚗',
          'description': 'Wanita memangku di atas paha pria di area privat luar rumah.',
        },
        {
          'id': 'standing_wall',
          'label': 'Wall Press Standing (Berdiri Menempel Dinding Privat) 🧱',
          'icon': '🧱',
          'description': 'Menempelkan tubuh wanita ke dinding privat dengan angkatan paha intim.',
        },
        {
          'id': 'doggy',
          'label': 'Reclined Doggy Style (Dari Belakang Tempat Luar) 🐾',
          'icon': '🐾',
          'description': 'Wanita membungkuk santai dengan penetrasi dari belakang.',
        },
        {
          'id': 'missionary',
          'label': 'Private Missionary (Tatap Muka Tempat Luar) 👩‍❤️‍👨',
          'icon': '👩‍❤️‍👨',
          'description': 'Berbaring bertatap muka di tempat peristirahatan privat.',
        },
        {
          'id': 'spooning',
          'label': 'Private Spooning (Menyamping Tempat Luar) 🌙',
          'icon': '🌙',
          'description': 'Berbaring miring mendekap erat dari belakang.',
        },
      ];
    } else {
      // Default Kamar Tidur (5 opsi utama)
      return [
        {
          'id': 'missionary',
          'label': 'Bed Missionary (Tatap Muka di Kasur) 👩‍❤️‍👨',
          'icon': '👩‍❤️‍👨',
          'description': 'Posisi klasik bertatap muka di atas kasur empuk dengan kontak dada yang hangat.',
        },
        {
          'id': 'doggy',
          'label': 'Bed Doggy Style (Dari Belakang di Kasur) 🐾',
          'icon': '🐾',
          'description': 'Penetrasi mendalam dari belakang di kasur dengan tempo ritmis yang bergairah.',
        },
        {
          'id': 'cowgirl',
          'label': 'Bed Cowgirl (Wanita Di Atas di Kasur) 💃',
          'icon': '💃',
          'description': 'Pasangan wanita memegang kendali tempo dengan goyangan pinggul di atas kasur.',
        },
        {
          'id': 'posisi_69',
          'label': 'Bed Posisi 69 (Oral Saling Berhadapan) 🔄',
          'icon': '🔄',
          'description': 'Saling memberikan kenikmatan oral secara bersamaan dari posisi berbalik arah di kasur.',
        },
        {
          'id': 'spooning',
          'label': 'Bed Spooning (Menyamping di Kasur) 🌙',
          'icon': '🌙',
          'description': 'Posisi menyamping santai sambil mendekap erat tubuh pasangan dari belakang di kasur.',
        },
      ];
    }
  }

  /// Menghasilkan VN Dialogue Nodes sesuai posisi seks yang dipilih.
  static List<VNDialogueNode> generatePosisiDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String posisiId,
    required String posisiLabel,
    String targetRole = 'Pasangan',
  }) {
    final String myGender = character.gender.trim().toLowerCase();
    final String partnerGender = targetGender.trim().toLowerCase();
    final bool isPlayerMale = myGender == 'laki-laki';

    // Panggilan intim
    final String callToNpc = PanggilanManager.getPanggilan(
      targetName: targetName,
      targetRole: targetRole,
      targetGender: targetGender,
      isSpeakerPlayer: true,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    final String callToPlayer = PanggilanManager.getPanggilan(
      targetName: targetName,
      targetRole: targetRole,
      targetGender: targetGender,
      isSpeakerPlayer: false,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    // =========================================================================
    // 1. POSISI KHUSUS LESBIAN (WANITA - WANITA)
    // =========================================================================
    // =========================================================================
    // 1. POSISI KHUSUS LESBIAN (WANITA - WANITA)
    // =========================================================================
    if (posisiId == 'scissoring') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} dan $targetName merebahkan diri miring menyilang, melingkarkan kaki satu sama lain dalam posisi Scissoring (Gunting) dan mulai saling menggesekkan area intim dengan lembut...) ✂️',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Ahh... $callToPlayer... gesekan hangat darimu rasanya pas sekali... kakimu mengunci paha dengan begitu nikmat... 💗',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Nnnggh... $callToNpc! Sentuhan klitoris dan kulit sensitif kita yang bergesekan membuat ritme ini semakin tak tertahankan... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Sensasi menggesek dalam posisi gunting menghantarkan letupan kenikmatan meluap-luap bagi kedua wanita...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'tribadism') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} menindih tubuh $targetName dari atas dalam posisi Tribadism / Missionary, saling menempelkan area intim dan menekan panggul secara ritmis...) 👩‍❤️‍💋‍👩',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Ouhh... bobot tubuhmu di atasku terasa hangat... tekan panggulmu lebih kuat lagi $callToPlayer... 💓',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Mmmh... $callToNpc... gesekan intim panggul kita bertatapan langsung membuat gairahku membara... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Gesekan menindih tatap muka menciptakan aliran listrik kenikmatan mesra yang memabukkan...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'face_sitting') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} duduk di atas wajah $targetName dalam posisi Face Sitting, membiarkan pasangannya memanjakan area intimnya dengan isapan mulut dan lidah...) 👑',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Ahhh... nnngghh... $callToNpc! Sentuhan lidahmu di bawah sana sungguh luar biasa nikmat... hmmmph! 💖',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Mmmph... mmmh! (Napas $targetName hangat berhembus pasrah di bawah lekukan intim tempatnya mengisap mesra...) 👄',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Kenikmatan manis dari posisi Face Sitting membuat tubuh bergetar hebat dalam puncak kebahagiaan...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'riding') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} duduk di atas tubuh $targetName dalam posisi Riding / Cowgirl, memegang kendali tempo dengan memutar pinggulnya di atas sentuhan pasangannya...) 💃',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Goyanganmu di atasku indah sekali $callToPlayer... gairahmu benar-benar meluap! 💥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Ughh... nnnggh! Rasanya begitu nikmat saat aku mengarahkan ritmenya sendiri di atasmu $callToNpc... 💓',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Tarian indah di atas tubuh memberikan kepuasan sensual yang tiada tara...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'spooning_lesbian') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} memeluk erat $targetName dari belakang dalam posisi Spooning (Sendok), menggesekkan panggulnya lembut ke bokong pasangannya...) 🌙',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Dekapan hangat dari belakang ini rasanya begitu dekat... gesekan perlahanmu sungguh nyaman $callToPlayer... ☺️',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Aku suka mendekapmu erat seperti ini $callToNpc... napas intim di lehermu terasa sangat syahdu... 💋',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Gesekan menyamping yang santai dan penuh kasih sayang menghadirkan kehangatan mendalam...) 💫',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'posisi_69_lesbian') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} dan $targetName berbaring miring saling berhadapan berbalik arah dalam Posisi 69, saling memanjakan area intim dengan isapan oral secara bersamaan...) 🔄',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Mmmph... ahh... $callToPlayer! Isapan mulutmu di bawah sana membuatku gila... kuberikan kenikmatan yang sama untukmu... 👄',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Nnnggh... hmmmph! Sentuhan mulut dan lidahmu membuat seluruh tubuhku gemetaran manis $callToNpc... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Pemberian kenikmatan oral secara bersamaan membawa puncak sensasi ganda yang intens...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'standing_wall') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} mengangkat dan menopang $targetName menempel ke dinding dalam posisi Standing / Against the Wall, saling menggesekkan panggul dengan intim...) 🧱',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Aww-ahh! Pelukan dan angkatanmu di dinding ini terasa begitu bergairah dan kuat $callToPlayer... 💥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Kupegang tubuhmu erat-erat $callToNpc... desakan intim kita di dinding membuat suasana semakin membakar... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Rangsangan berdiri di dinding memberikan sensasi gairah yang menantang dan memabukkan...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    }

    // =========================================================================
    // 2. POSISI KHUSUS GAY (PRIA - PRIA)
    // =========================================================================
    else if (posisiId == 'missionary_gay') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} merebahkan $targetName telentang di ranjang, menindih dari depan sambil menatap matanya lekat dalam penetrasi anal Missionary...) 👨‍❤️‍👨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Ughhh... ahh! Penetrasi tatap muka ini terasa begitu dalam dan hangat $callToPlayer... 💥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Aku ingin melihat ekspresi wajahmu saat aku mendorong lebih dalam $callToNpc... tatapanmu sangat tampan... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Pendorong penuh gairah dalam posisi Missionary bertatap muka menciptakan keintiman mendalam...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'doggy_gay') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} memposisikan $targetName merangkak menungging di ranjang, memegang pinggulnya erat dari belakang untuk penetrasi anal Doggy Style...) 🐾',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Ahh! Hah... hah! Entakan keras dari belakang ini membuat seluruh tubuhku merinding lemas $callToPlayer! 🔥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Goyangan pinggulmu dari belakang ini sangat mantap $callToNpc... tahan ritme ini! 💥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Entakan intensif dari belakang memicu gelombang desahan menggebu di seluruh ruangan...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'cowgirl_gay') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($targetName naik ke atas tubuh ${character.name}, duduk di atas penis sambil mengayunkan pinggulnya naik turun dalam posisi Reverse / Cowgirl...) 🤠',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Ughhh... pemandangan dirimu mengendalikan ritme di atasku terlihat sangat perkasa $callToNpc... 💦',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Nnnggh... rasanya begitu rapat dan hangat saat aku menurunkannya sendiri di atasmu $callToPlayer... 💗',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Goyangan di atas tubuh memberikan sensasi kepuasan anal yang melayang bergairah...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'spooning_gay') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} memeluk erat $targetName dari belakang dalam posisi Spooning (Sendok), melakukan penetrasi anal lembut secara menyamping...) 🌙',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Dekapan hangat dari belakang ini rasanya begitu dekat... dorongan perlahanmu sungguh nyaman $callToPlayer... ☺️',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Aku suka mendekapmu erat seperti ini $callToNpc... napas intim di lehermu terasa sangat syahdu... 💋',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Penetrasi menyamping yang santai dan penuh kasih sayang menghadirkan kehangatan mendalam...) 💫',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'frottage') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} dan $targetName berpelukan erat, saling menggesekkan alat vital (Frottage / Grinding) tanpa penetrasi sebagai stimulasi hangat...) 💥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Hah... hah... gesekan hangat ini nikmat sekali $callToPlayer! Gairahku langsung terpacu pesat... 🔥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Sensasi menggesek ini luar biasa $callToNpc... sentuhan kulit ke kulit kita sungguh membakar semangat... ⚡',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Gesekan Frottage yang intensif membakar gairah intim keduanya hingga ke puncak kejenuhan...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'standing_gay') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} merangkul paha $targetName yang berdiri bersandar di dinding, melakukan penetrasi anal dalam posisi Standing / Wall Press...) 🧱',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Aww-ahh! Pelukan dan penetrasimu di dinding ini terasa begitu bergairah dan kuat $callToPlayer... 💥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Kupegang tubuhmu erat-erat $callToNpc... desakan intim kita di dinding membuat suasana semakin membakar... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Rangsangan penetrasi anal berdiri di dinding memberikan sensasi gairah yang menantang dan memabukkan...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    }

    // =========================================================================
    // 3. POSISI UMUM (69, MISSIONARY, DOGGY, COWGIRL, SPOONING HETERO / FALLBACK)
    // =========================================================================
    else if (posisiId == 'posisi_69') {
      final String speaker1 = isPlayerMale ? character.name : targetName;
      final String speaker2 = isPlayerMale ? targetName : character.name;
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(${character.name} dan $targetName merebahkan diri berbalik arah dalam posisi 69, saling memberikan kenikmatan oral yang intens secara simultan...) 🔄',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: targetName,
          dialogueText: 'Mmmphh... nnnggh... $callToPlayer... sentuhan dan isapanmu di bawah sana membuat seluruh tubuhku gemetaran... 💗',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: character.name,
          dialogueText: 'Mmmh... $callToNpc... kulumanmu juga sungguh nikmat tiada tanding... hah... hah... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Kenikmatan balasan beruntun dari posisi 69 membawa letupan kepuasan ganda yang sensasional...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'doggy') {
      final String maleName = isPlayerMale ? character.name : targetName;
      final String femaleName = isPlayerMale ? targetName : character.name;
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($maleName memposisikan $femaleName merangkak di ranjang, memegang pinggulnya dari belakang dan melakukan pendorongan mendalam dalam gaya Doggy Style...) 🐾',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Ahhh... ahh! Dalam sekali... entakan dari belakang ini membuatku gemetaran tak tertahankan! 💥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Goyangan pinggulmu dari belakang ini sangat menggairahkan... tahan sebentar ya sayang! 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Entakan cepat dari belakang memicu gelombang desahan keras yang menggebu-gebu di dalam kamar tidur...) 🌟',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'cowgirl') {
      final String maleName = isPlayerMale ? character.name : targetName;
      final String femaleName = isPlayerMale ? targetName : character.name;
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($femaleName naik ke atas tubuh $maleName, memegang kendali ritme sambil memutar pinggulnya naik turun dalam posisi Cowgirl...) 💃',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Ughhh... pemandangan dirimu di atasku terlihat luar biasa seksi... gerakkan lebih cepat lagi sayang! 💦',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Nnnggh... rasanya begitu dalam saat aku mengendalikannya sendiri... nikmati sentuhanku di atasmu ya... 💋',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Goyangan indah di atas tubuh membawa sensasi kenikmatan melayang yang penuh daya pikat...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else if (posisiId == 'spooning') {
      final String maleName = isPlayerMale ? character.name : targetName;
      final String femaleName = isPlayerMale ? targetName : character.name;
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($maleName memeluk erat $femaleName dari belakang dalam posisi Spooning, melakukan pendorongan lembut secara menyamping...) 🌙',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Dekapanmu dari belakang hangat dan nyaman sekali... bisikan napasmu di leherku bikin geli tapi enak... 😳',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Aku suka memelukmu seperti ini... terasa santai tapi begitu intim dan dalam... 💋',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Penyatuan hangat dalam dekapan menyamping menghadirkan suasana romantis yang menenangkan...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else { // Fallback Missionary
      final String maleName = isPlayerMale ? character.name : targetName;
      final String femaleName = isPlayerMale ? targetName : character.name;
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($maleName merebahkan $femaleName dengan lembut di atas ranjang, memegang kedua tangannya sambil bertatap mata penuh cinta dalam posisi Missionary...) 👩‍❤️‍👨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Tatapan matamu hangat sekali... dorong lebih dalam sayang, aku ingin merasakan seluruh tubuhmu menempel padaku... 💗',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Aku menyukainya ketika mata kita saling mengunci seperti ini... senyuman dan desahanmu terasa sangat dekat... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Entakan ritmis dalam posisi bertatap muka menciptakan keintiman romantis yang begitu mendalam bagi keduanya...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    }

    return nodes;
  }
}

