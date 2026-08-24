// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/interactions/classmate_interaction_page.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import 'actions/rekan_kerja.dart';
import 'actions/bekerja_keras.dart';
import 'idol_logic/idol_manager.dart';
import 'idol_logic/idol_menu.dart';

// ============================================================
// EXTENSION untuk menambahkan isUnivGraduated ke Character
// ============================================================
extension CharacterExtension on Character {
  bool get isUnivGraduated {
    // Cek riwayat kelulusan pendidikan tinggi
    if (educationHistory['S1'] == 'Lulus' ||
        educationHistory['S2'] == 'Lulus' ||
        educationHistory['S3'] == 'Lulus') {
      return true;
    }
    // Fallback jika sedang kuliah dan sudah mencapai umur kelulusan (>= 22)
    if (univMajor != null && age >= 22) return true;
    return false;
  }
}

class KerjaMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KerjaMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<KerjaMenuScreen> createState() => _KerjaMenuScreenState();
}

class _KerjaMenuScreenState extends State<KerjaMenuScreen> {
  // ============================================================
  // DAFTAR PEKERJAAN (LENGKAP DENGAN KATEGORI & SYARAT)
  // ============================================================
  final List<Map<String, dynamic>> _availableJobs = [
    // ---- DASAR & ENTRY-LEVEL ----
    {
      'title': 'Kasir',
      'salary': 400,
      'minIntel': 10,
      'category': 'Dasar',
      'desc': 'Melayani transaksi pembayaran',
      'icon': Icons.point_of_sale,
      'color': Colors.blueGrey,
    },
    {
      'title': 'Supir Ojek Online',
      'salary': 400,
      'minIntel': 10,
      'category': 'Dasar',
      'desc': 'Mengantarkan penumpang dengan kendaraan',
      'icon': Icons.motorcycle,
      'color': Colors.green,
    },
    {
      'title': 'Karyawan Toko',
      'salary': 500,
      'minIntel': 20,
      'category': 'Dasar',
      'desc': 'Melayani pelanggan dan mengelola toko',
      'icon': Icons.store,
      'color': Colors.blue,
    },
    {
      'title': 'Buruh Pabrik',
      'salary': 600,
      'minIntel': 15,
      'category': 'Dasar',
      'desc': 'Bekerja di lini produksi pabrik',
      'icon': Icons.precision_manufacturing,
      'color': Colors.orange,
    },
    {
      'title': 'Cleaning Service',
      'salary': 350,
      'minIntel': 10,
      'category': 'Dasar',
      'desc': 'Membersihkan dan merawat gedung',
      'icon': Icons.cleaning_services,
      'color': Colors.grey,
    },
    {
      'title': 'Satpam',
      'salary': 400,
      'minIntel': 15,
      'category': 'Dasar',
      'desc': 'Menjaga keamanan dan ketertiban',
      'icon': Icons.security,
      'color': Colors.indigo,
    },
    {
      'title': 'Kurir',
      'salary': 450,
      'minIntel': 15,
      'category': 'Dasar',
      'desc': 'Mengantar paket dan barang',
      'icon': Icons.local_shipping,
      'color': Colors.amber,
    },

    // ---- TERAMPIL (TANPA GELAR) ----
    {
      'title': 'Montir',
      'salary': 800,
      'minIntel': 30,
      'category': 'Terampil',
      'desc': 'Memperbaiki kendaraan dan mesin',
      'icon': Icons.build,
      'color': Colors.brown,
    },
    {
      'title': 'Tukang Listrik',
      'salary': 900,
      'minIntel': 35,
      'category': 'Terampil',
      'desc': 'Memasang dan memperbaiki instalasi listrik',
      'icon': Icons.electrical_services,
      'color': Colors.orange,
    },
    {
      'title': 'Tukang Kayu',
      'salary': 850,
      'minIntel': 30,
      'category': 'Terampil',
      'desc': 'Membuat dan memperbaiki furnitur kayu',
      'icon': Icons.handyman,
      'color': Colors.brown,
    },
    {
      'title': 'Tukang Las',
      'salary': 900,
      'minIntel': 30,
      'category': 'Terampil',
      'desc': 'Mengelas logam dan struktur besi',
      'icon': Icons.fire_extinguisher,
      'color': Colors.grey,
    },
    {
      'title': 'Nelayan',
      'salary': 700,
      'minIntel': 20,
      'category': 'Terampil',
      'desc': 'Menangkap ikan di laut dan sungai',
      'icon': Icons.directions_boat,
      'color': Colors.blue,
    },
    {
      'title': 'Petani',
      'salary': 600,
      'minIntel': 20,
      'category': 'Terampil',
      'desc': 'Mengelola lahan pertanian dan ternak',
      'icon': Icons.agriculture,
      'color': Colors.green,
    },
    {
      'title': 'Koki',
      'salary': 800,
      'minIntel': 30,
      'category': 'Terampil',
      'desc': 'Memasak dan menyiapkan makanan',
      'icon': Icons.restaurant,
      'color': Colors.red,
    },
    {
      'title': 'Pelayan Restoran',
      'salary': 500,
      'minIntel': 20,
      'category': 'Terampil',
      'desc': 'Melayani pelanggan di restoran',
      'icon': Icons.restaurant_menu,
      'color': Colors.pink,
    },

    // ---- KREATIF & FREELANCE ----
    {
      'title': 'Fotografer',
      'salary': 1200,
      'minIntel': 40,
      'category': 'Kreatif',
      'desc': 'Mengambil foto untuk berbagai keperluan',
      'icon': Icons.photo_camera,
      'color': Colors.purple,
    },
    {
      'title': 'Videografer',
      'salary': 1500,
      'minIntel': 45,
      'category': 'Kreatif',
      'desc': 'Membuat konten video profesional',
      'icon': Icons.videocam,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Content Creator',
      'salary': 1800,
      'minIntel': 50,
      'category': 'Kreatif',
      'desc': 'Membuat konten digital (YouTube, TikTok, dll)',
      'icon': Icons.video_library,
      'color': Colors.red,
    },
    {
      'title': 'Musisi Jalanan',
      'salary': 600,
      'minIntel': 20,
      'category': 'Kreatif',
      'desc': 'Bermain musik di tempat umum',
      'icon': Icons.music_note,
      'color': Colors.orange,
    },
    {
      'title': 'Pelukis',
      'salary': 700,
      'minIntel': 25,
      'category': 'Kreatif',
      'desc': 'Melukis dan menjual karya seni',
      'icon': Icons.brush,
      'color': Colors.cyan,
    },

    // ---- LAYANAN & SOSIAL ----
    {
      'title': 'Driver Pribadi',
      'salary': 700,
      'minIntel': 25,
      'category': 'Layanan',
      'desc': 'Mengantar majikan ke berbagai tempat',
      'icon': Icons.car_rental,
      'color': Colors.teal,
    },
    {
      'title': 'Asisten Rumah Tangga',
      'salary': 500,
      'minIntel': 15,
      'category': 'Layanan',
      'desc': 'Membantu pekerjaan rumah tangga',
      'icon': Icons.home,
      'color': Colors.green,
    },
    {
      'title': 'Baby Sitter',
      'salary': 450,
      'minIntel': 20,
      'category': 'Layanan',
      'desc': 'Merawat dan mengawasi anak-anak',
      'icon': Icons.child_care,
      'color': Colors.pink,
    },
    {
      'title': 'Pengasuh Lansia',
      'salary': 500,
      'minIntel': 20,
      'category': 'Layanan',
      'desc': 'Merawat dan mendampingi lansia',
      'icon': Icons.elderly,
      'color': Colors.grey,
    },

    // ---- PROFESIONAL (BUTUH GELAR) ----
    // STEM & TEKNIK
    {
      'title': 'Junior Software Engineer',
      'salary': 3500,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Mengembangkan aplikasi dan sistem',
      'icon': Icons.computer,
      'color': Colors.indigo,
    },
    {
      'title': 'Data Analyst',
      'salary': 3000,
      'minIntel': 65,
      'category': 'Profesional',
      'desc': 'Menganalisis data untuk keputusan bisnis',
      'icon': Icons.analytics,
      'color': Colors.blue,
    },
    {
      'title': 'Network Engineer',
      'salary': 3200,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Mengelola infrastruktur jaringan',
      'icon': Icons.wifi,
      'color': Colors.cyan,
    },
    {
      'title': 'Civil Engineer',
      'salary': 3000,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Merancang dan mengawasi proyek konstruksi',
      'icon': Icons.architecture,
      'color': Colors.brown,
    },
    {
      'title': 'Mechanical Engineer',
      'salary': 3200,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Merancang sistem mekanik dan mesin',
      'icon': Icons.settings,
      'color': Colors.grey,
    },
    {
      'title': 'Electrical Engineer',
      'salary': 3300,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Merancang sistem kelistrikan dan elektronik',
      'icon': Icons.flash_on,
      'color': Colors.orange,
    },
    {
      'title': 'Chemical Engineer',
      'salary': 3500,
      'minIntel': 65,
      'category': 'Profesional',
      'desc': 'Mengembangkan proses produksi kimia',
      'icon': Icons.science,
      'color': Colors.deepOrange,
    },
    {
      'title': 'Architect',
      'salary': 3800,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Merancang bangunan dan struktur',
      'icon': Icons.home_work,
      'color': Colors.amber,
    },

    // KESEHATAN
    {
      'title': 'Dokter Umum',
      'salary': 5000,
      'minIntel': 80,
      'category': 'Profesional',
      'desc': 'Mendiagnosis dan mengobati pasien',
      'icon': Icons.medical_services,
      'color': Colors.red,
    },
    {
      'title': 'Dokter Spesialis',
      'salary': 8000,
      'minIntel': 85,
      'category': 'Profesional',
      'desc': 'Spesialisasi di bidang tertentu (bedah, anak, dll)',
      'icon': Icons.local_hospital,
      'color': Colors.red.shade900, // deepRed diganti
    },
    {
      'title': 'Dokter Gigi',
      'salary': 4500,
      'minIntel': 75,
      'category': 'Profesional',
      'desc': 'Merawat kesehatan gigi dan mulut',
      'icon': Icons.medical_information,
      'color': Colors.teal,
    },
    {
      'title': 'Apoteker',
      'salary': 3500,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Menyediakan dan mengelola obat-obatan',
      'icon': Icons.medication,
      'color': Colors.purple,
    },
    {
      'title': 'Perawat',
      'salary': 2800,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Memberikan perawatan medis langsung',
      'icon': Icons.health_and_safety,
      'color': Colors.blue,
    },
    {
      'title': 'Ahli Gizi',
      'salary': 2500,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Memberikan konsultasi gizi dan diet',
      'icon': Icons.restaurant,
      'color': Colors.green,
    },

    // BISNIS & EKONOMI
    {
      'title': 'Manajer Keuangan',
      'salary': 4000,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Mengelola keuangan dan investasi perusahaan',
      'icon': Icons.attach_money,
      'color': Colors.green,
    },
    {
      'title': 'Akuntan',
      'salary': 3200,
      'minIntel': 65,
      'category': 'Profesional',
      'desc': 'Mengelola laporan keuangan dan pajak',
      'icon': Icons.calculate,
      'color': Colors.blue,
    },
    {
      'title': 'Analis Ekonomi',
      'salary': 3500,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Menganalisis tren ekonomi dan pasar',
      'icon': Icons.timeline,
      'color': Colors.cyan,
    },
    {
      'title': 'Bankir',
      'salary': 3800,
      'minIntel': 65,
      'category': 'Profesional',
      'desc': 'Mengelola dana dan memberikan pinjaman',
      'icon': Icons.account_balance,
      'color': Colors.indigo,
    },
    {
      'title': 'Marketing Specialist',
      'salary': 3000,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Merancang strategi pemasaran produk',
      'icon': Icons.trending_up,
      'color': Colors.purple,
    },

    // HUKUM & SOSIAL
    {
      'title': 'Pengacara',
      'salary': 5000,
      'minIntel': 75,
      'category': 'Profesional',
      'desc': 'Memberikan bantuan hukum dan pembelaan',
      'icon': Icons.gavel,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Jaksa',
      'salary': 4500,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Menuntut perkara pidana di pengadilan',
      'icon': Icons.account_balance, // court_house diganti
      'color': Colors.blueGrey,
    },
    {
      'title': 'Diplomat',
      'salary': 4000,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Mewakili negara dalam hubungan internasional',
      'icon': Icons.public,
      'color': Colors.blue,
    },
    {
      'title': 'Jurnalis',
      'salary': 2500,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Mengumpulkan dan menyajikan berita',
      'icon': Icons.newspaper,
      'color': Colors.grey,
    },
    {
      'title': 'Psikolog',
      'salary': 3500,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Memberikan konseling dan terapi psikologis',
      'icon': Icons.psychology,
      'color': Colors.pink,
    },
    {
      'title': 'Pegawai Negeri Sipil (PNS)',
      'salary': 1500,
      'minIntel': 50,
      'category': 'Profesional',
      'desc': 'Bekerja di instansi pemerintah',
      'icon': Icons.account_balance,
      'color': Colors.teal,
    },

    // PENDIDIKAN & BAHASA
    {
      'title': 'Guru SD',
      'salary': 1200,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Mengajar siswa kelas 1-6 SD',
      'icon': Icons.school,
      'color': Colors.purple,
    },
    {
      'title': 'Guru SMP',
      'salary': 1400,
      'minIntel': 65,
      'category': 'Profesional',
      'desc': 'Mengajar siswa kelas 7-9 SMP',
      'icon': Icons.school,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Guru SMA',
      'salary': 1800,
      'minIntel': 70,
      'category': 'Profesional',
      'desc': 'Mengajar siswa kelas 10-12 SMA',
      'icon': Icons.school,
      'color': Colors.indigo,
    },
    {
      'title': 'Dosen',
      'salary': 3000,
      'minIntel': 75,
      'category': 'Profesional',
      'desc': 'Mengajar dan meneliti di perguruan tinggi',
      'icon': Icons.menu_book,
      'color': Colors.blue,
    },
    {
      'title': 'Penerjemah',
      'salary': 2500,
      'minIntel': 65,
      'category': 'Profesional',
      'desc': 'Menerjemahkan teks dalam berbagai bahasa',
      'icon': Icons.translate,
      'color': Colors.green,
    },
    {
      'title': 'Penulis',
      'salary': 2000,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Menulis buku, artikel, atau konten kreatif',
      'icon': Icons.edit,
      'color': Colors.amber,
    },

    // KREATIF & SENI
    {
      'title': 'Desainer Grafis',
      'salary': 2500,
      'minIntel': 55,
      'category': 'Profesional',
      'desc': 'Merancang visual untuk media dan produk',
      'icon': Icons.design_services,
      'color': Colors.pink,
    },
    {
      'title': 'Desainer Mode',
      'salary': 2800,
      'minIntel': 55,
      'category': 'Profesional',
      'desc': 'Merancang pakaian dan aksesoris',
      'icon': Icons.style,
      'color': Colors.purple,
    },
    {
      'title': 'Sutradara Film',
      'salary': 4000,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Mengarahkan produksi film dan televisi',
      'icon': Icons.movie,
      'color': Colors.red,
    },
    {
      'title': 'Produser Musik',
      'salary': 3500,
      'minIntel': 55,
      'category': 'Profesional',
      'desc': 'Memproduksi dan mengelola rekaman musik',
      'icon': Icons.music_video,
      'color': Colors.orange,
    },
    {
      'title': 'Seniman',
      'salary': 2000,
      'minIntel': 50,
      'category': 'Profesional',
      'desc': 'Menciptakan karya seni (lukis, patung, dll)',
      'icon': Icons.palette,
      'color': Colors.cyan,
    },

    // PERTANIAN & LAINNYA
    {
      'title': 'Agronom',
      'salary': 2800,
      'minIntel': 55,
      'category': 'Profesional',
      'desc': 'Mengelola produksi tanaman dan pertanian',
      'icon': Icons.agriculture,
      'color': Colors.green,
    },
    {
      'title': 'Manajer Hotel',
      'salary': 3000,
      'minIntel': 60,
      'category': 'Profesional',
      'desc': 'Mengelola operasional hotel dan akomodasi',
      'icon': Icons.hotel,
      'color': Colors.teal,
    },

    // PRESTISE TINGGI
    {
      'title': 'CEO Startup',
      'salary': 10000,
      'minIntel': 80,
      'category': 'Prestise',
      'desc': 'Memimpin perusahaan rintisan',
      'icon': Icons.rocket,
      'color': Colors.amber, // gold diganti
    },
    {
      'title': 'Pilot',
      'salary': 6000,
      'minIntel': 70,
      'category': 'Prestise',
      'desc': 'Mengemudikan pesawat terbang',
      'icon': Icons.flight,
      'color': Colors.blue,
    },
    {
      'title': 'Arsitek Senior',
      'salary': 6000,
      'minIntel': 75,
      'category': 'Prestise',
      'desc': 'Merancang bangunan bertingkat tinggi',
      'icon': Icons.architecture,
      'color': Colors.brown,
    },
    {
      'title': 'Pengacara Senior',
      'salary': 8000,
      'minIntel': 80,
      'category': 'Prestise',
      'desc': 'Menangani kasus-kasus besar',
      'icon': Icons.gavel,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Konsultan Manajemen',
      'salary': 7000,
      'minIntel': 75,
      'category': 'Prestise',
      'desc': 'Memberikan saran strategis untuk perusahaan',
      'icon': Icons.business_center,
      'color': Colors.indigo,
    },
  ];

  // ============================================================
  // FUNGSI UTAMA
  String? _getBaseMajor(String? fullMajor) {
    if (fullMajor == null) return null;
    return fullMajor.split(' (').first;
  }

  List<String> _getAllowedMajors(String jobTitle) {
    switch (jobTitle) {
      // STEM & TEKNIK
      case 'Junior Software Engineer':
      case 'Network Engineer':
        return ['Teknik Informatika', 'Sistem Informasi', 'Teknik Elektro'];
      case 'Data Analyst':
        return ['Teknik Informatika', 'Sistem Informasi', 'Akuntansi', 'Ekonomi Pembangunan', 'Manajemen'];
      case 'Civil Engineer':
        return ['Teknik Sipil'];
      case 'Mechanical Engineer':
        return ['Teknik Mesin'];
      case 'Electrical Engineer':
        return ['Teknik Elektro'];
      case 'Chemical Engineer':
        return ['Teknik Kimia'];
      case 'Architect':
      case 'Arsitek Senior':
        return ['Arsitektur'];

      // KESEHATAN
      case 'Dokter Umum':
      case 'Dokter Spesialis':
        return ['Kedokteran'];
      case 'Dokter Gigi':
        return ['Kedokteran Gigi'];
      case 'Apoteker':
        return ['Farmasi'];
      case 'Perawat':
        return ['Keperawatan'];
      case 'Ahli Gizi':
        return ['Gizi & Ilmu Pangan'];

      // BISNIS & EKONOMI
      case 'Manajer Keuangan':
        return ['Manajemen', 'Akuntansi', 'Perbankan & Keuangan'];
      case 'Akuntan':
        return ['Akuntansi'];
      case 'Analis Ekonomi':
        return ['Ekonomi Pembangunan', 'Akuntansi', 'Perbankan & Keuangan'];
      case 'Bankir':
        return ['Perbankan & Keuangan', 'Akuntansi', 'Manajemen'];
      case 'Marketing Specialist':
        return ['Pemasaran Digital', 'Manajemen', 'Ilmu Komunikasi'];
      case 'CEO Startup':
        return ['Manajemen', 'Akuntansi', 'Teknik Informatika', 'Sistem Informasi', 'Ekonomi Pembangunan'];
      case 'Konsultan Manajemen':
        return ['Manajemen', 'Akuntansi', 'Ekonomi Pembangunan', 'Perbankan & Keuangan'];

      // HUKUM & SOSIAL
      case 'Pengacara':
      case 'Pengacara Senior':
      case 'Jaksa':
        return ['Hukum'];
      case 'Diplomat':
        return ['Hubungan Internasional', 'Hukum'];
      case 'Jurnalis':
        return ['Ilmu Komunikasi', 'Sastra & Bahasa'];
      case 'Psikolog':
        return ['Psikologi'];
      case 'Pegawai Negeri Sipil (PNS)':
        return ['Administrasi Publik', 'Hukum', 'Hubungan Internasional', 'Ekonomi Pembangunan'];

      // PENDIDIKAN & BAHASA
      case 'Guru SD':
        return ['Pendidikan / PGSD', 'Pendidikan Agama Islam'];
      case 'Guru SMP':
      case 'Guru SMA':
      case 'Dosen':
        return ['Pendidikan / PGSD', 'Pendidikan Agama Islam', 'Sastra & Bahasa', 'Hukum', 'Kedokteran', 'Teknik Informatika'];
      case 'Penerjemah':
        return ['Sastra & Bahasa', 'Hubungan Internasional'];
      case 'Penulis':
        return ['Sastra & Bahasa', 'Ilmu Komunikasi', 'Pendidikan / PGSD'];

      // KREATIF & SENI
      case 'Desainer Grafis':
        return ['Desain Komunikasi Visual (DKV)'];
      case 'Desainer Mode':
        return ['Desain Mode'];
      case 'Sutradara Film':
        return ['Film & Televisi'];
      case 'Produser Musik':
        return ['Seni Musik'];
      case 'Seniman':
        return ['Desain Komunikasi Visual (DKV)', 'Desain Mode', 'Film & Televisi', 'Seni Musik'];

      // PERTANIAN & LAINNYA
      case 'Agronom':
        return ['Agroteknologi'];
      case 'Manajer Hotel':
        return ['Manajemen Perhotelan', 'Manajemen'];

      // LAINNYA
      case 'Pilot':
        return ['Teknik Elektro', 'Teknik Mesin', 'Teknik Sipil', 'Teknik Kimia', 'Teknik Informatika', 'Sistem Informasi', 'Arsitektur', 'Kedokteran'];

      // STAF IDOL
      case 'General Manager Idol':
      case 'Deputy General Manager Idol':
        return ['Manajemen', 'Akuntansi', 'Ilmu Komunikasi'];

      default:
        return [];
    }
  }



  bool _hasMatchingMajor(Character character, List<String> allowed) {
    if (!character.isUnivGraduated) return false;

    // Fallback: jika educationHistory sudah Lulus tapi graduatedMajors kosong (save game lama)
    final hasLulus = character.educationHistory['S1'] == 'Lulus' ||
                     character.educationHistory['S2'] == 'Lulus' ||
                     character.educationHistory['S3'] == 'Lulus';
    if (hasLulus && character.graduatedMajors.isEmpty) {
      return true;
    }

    for (final major in character.graduatedMajors) {
      if (allowed.contains(major)) return true;
    }
    final baseMajor = _getBaseMajor(character.univMajor);
    if (baseMajor != null && allowed.contains(baseMajor)) {
      return true;
    }
    return false;
  }

  // ============================================================
  void _applyJob(Map<String, dynamic> job) {
    if (job['title'] == 'Idol (Trainee)') {
      if (widget.character.hasGraduatedIdol) {
        if (widget.character.age < 18) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Lamaran Ditolak 🚫'),
              content: Text(
                'Kamu sudah pernah melangsungkan kelulusan (graduation) sebagai JKT48 Idol.\n\n'
                'Untuk bekerja kembali di manajemen sebagai Staf, kamu harus berusia minimal 18 tahun!\n'
                '(Usiamu saat ini: ${widget.character.age} tahun)',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }
      if (widget.character.health < 80 || widget.character.discipline < 75) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: Text(
              'Persyaratan menjadi Idol tidak terpenuhi.\n\n'
              '• Kesehatan minimal: 80% (Kesehantanmu: ${widget.character.health}%)\n'
              '• Kedisiplinan minimal: 75% (Kedisiplinanmu: ${widget.character.discipline}%)',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    } else if (widget.character.intelligence < (job['minIntel'] ?? 0)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lamaran Ditolak 🚫'),
          content: Text(
            'Kecerdasanmu (${widget.character.intelligence}%) kurang mencukupi untuk posisi ${job['title']}. Minimal ${job['minIntel']}%.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Cek jika pekerjaan membutuhkan gelar
    if (job['category'] == 'Profesional' || job['category'] == 'Prestise') {
      final allowed = _getAllowedMajors(job['title']);
      if (!_hasMatchingMajor(widget.character, allowed)) {
        final baseMajor = _getBaseMajor(widget.character.univMajor);
        final currentMajors = widget.character.graduatedMajors.isNotEmpty 
            ? widget.character.graduatedMajors.join(", ") 
            : (baseMajor ?? "Belum lulus / Tidak ada");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gelar Tidak Sesuai 🎓'),
            content: Text(
              'Posisi ${job['title']} membutuhkan gelar sarjana yang sesuai.\n\n'
              'Gelar/Jurusan yang diterima:\n'
              '• ${allowed.join("\n• ")}\n\n'
              'Jurusanmu: $currentMajors.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    }

    final isGraduatedRedirect = (job['title'] == 'Idol (Trainee)' && widget.character.hasGraduatedIdol);
    final String finalTitle = isGraduatedRedirect ? 'Staf Operasional Idol' : job['title'];
    final int finalSalary = isGraduatedRedirect ? 500 : job['salary'];

    // Lamaran diterima
    setState(() {
      widget.character.jobName = finalTitle;
      widget.character.jobSalary = finalSalary;
      if (finalTitle == 'Idol (Trainee)' || widget.character.isIdolStaff) {
        IdolManager.initializeTraineeTeam(widget.character);
      }
    });
    widget.onRefresh();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lamaran Diterima! 🎉💼'),
        content: Text(
          isGraduatedRedirect
              ? 'Karena kamu sudah pernah melangsungkan kelulusan (graduation) sebagai Idol, manajemen memutuskan untuk merekrutmu sebagai Staf Operasional Idol dengan gaji \$500/tahun!'
              : 'Selamat! Kamu resmi bekerja sebagai $finalTitle dengan gaji \$$finalSalary/tahun.\n\nGaji akan dibayarkan setiap kali kamu bertambah umur.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Luar Biasa!'),
          ),
        ],
      ),
    );
  }

  void _generateCoworkersIfEmpty() {
    final random = Random();
    if (widget.character.supervisor == null) {
      final gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final firstList = gender == 'Laki-laki'
          ? (widget.character.maleFirstNames ?? ['Andi', 'Budi', 'Joko'])
          : (widget.character.femaleFirstNames ?? ['Siti', 'Ani', 'Dewi']);
      final lastList = widget.character.lastNames ?? ['Santoso', 'Pratama', 'Hidayat'];
      final name = '${firstList[random.nextInt(firstList.length)]} ${lastList[random.nextInt(lastList.length)]}';
      final ageVal = 30 + random.nextInt(31);
      widget.character.supervisor = {
        'name': name,
        'gender': gender,
        'relationship': (40 + random.nextInt(21)).toString(),
        'age': ageVal.toString(),
        'isDeceased': 'false',
        'sexuality': 'Heteroseksual',
        'intelligence': (50 + random.nextInt(41)).toString(),
      };
    }

    if (widget.character.coworkers.isNotEmpty) return;
    final count = 5 + random.nextInt(6);
    for (int i = 0; i < count; i++) {
      final gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final firstList = gender == 'Laki-laki'
          ? (widget.character.maleFirstNames ?? ['Andi', 'Budi', 'Joko'])
          : (widget.character.femaleFirstNames ?? ['Siti', 'Ani', 'Dewi']);
      final lastList = widget.character.lastNames ?? ['Santoso', 'Pratama', 'Hidayat'];
      final name = '${firstList[random.nextInt(firstList.length)]} ${lastList[random.nextInt(lastList.length)]}';
      final ageVal = 20 + random.nextInt(41);
      widget.character.coworkers.add({
        'name': name,
        'gender': gender,
        'relationship': (40 + random.nextInt(21)).toString(),
        'age': ageVal.toString(),
        'isDeceased': 'false',
        'sexuality': 'Heteroseksual',
        'intelligence': (30 + random.nextInt(61)).toString(),
      });
    }
  }

  void _resign() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resign Pekerjaan'),
        content: Text('Apakah kamu yakin ingin keluar dari pekerjaanmu sebagai ${widget.character.jobName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.character.jobName = null;
                widget.character.jobSalary = null;
                widget.character.coworkers.clear();
                widget.character.supervisor = null;
              });
              widget.onRefresh();
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredJobsList(Character character) {
    final age = character.age;
    final gender = character.gender;

    // Female age 12-17: ONLY show "Idol (Trainee)"
    if (gender == 'Perempuan' && age >= 12 && age < 18) {
      return [
        {
          'title': 'Idol (Trainee)',
          // 10M - 20M IDR -> $667 to $1,333 USD
          'salary': 667 + Random().nextInt(667),
          'minIntel': 0,
          'category': 'Khusus',
          'desc': 'Bergabunglah dengan grup trainee Idol baru',
          'icon': Icons.music_note,
          'color': Colors.pink,
        }
      ];
    }

    // Other cases: start with standard jobs
    List<Map<String, dynamic>> jobs = List.from(_availableJobs);

    // If female >= 18, also add "Idol (Trainee)"
    if (gender == 'Perempuan' && age >= 18) {
      jobs.insert(0, {
        'title': 'Idol (Trainee)',
        'salary': 667 + Random().nextInt(667),
        'minIntel': 0,
        'category': 'Khusus',
        'desc': 'Bergabunglah dengan grup trainee Idol baru',
        'icon': Icons.music_note,
        'color': Colors.pink,
      });
    }

    // If male (or anyone >= 18), they see staff positions
    if (age >= 18) {
      jobs.addAll([
        {
          'title': 'General Manager Idol',
          'salary': 5000, // $5,000 USD (50M-100M IDR)
          'minIntel': 75,
          'category': 'Profesional',
          'desc': 'Memimpin operasional dan strategi grup Idol',
          'icon': Icons.manage_accounts,
          'color': Colors.purple,
        },
        {
          'title': 'Deputy General Manager Idol',
          'salary': 3500, // $3,500 USD (40M-75M IDR)
          'minIntel': 65,
          'category': 'Profesional',
          'desc': 'Membantu General Manager mengelola grup',
          'icon': Icons.supervisor_account,
          'color': Colors.indigo,
        },
        {
          'title': 'Staf Operasional Idol',
          'salary': 500, // $500 USD (5M-10M IDR)
          'minIntel': 30,
          'category': 'Dasar',
          'desc': 'Mengurus kebutuhan panggung dan member Idol',
          'icon': Icons.run_circle,
          'color': Colors.blueGrey,
        }
      ]);
    }

    return jobs;
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    if (character.isIdolRelated) {
      return IdolMenuScreen(
        character: character,
        onRefresh: () {
          if (mounted) setState(() {});
          widget.onRefresh();
        },
      );
    }
    final hasJob = character.jobName != null;

    if (hasJob) {
      _generateCoworkersIfEmpty();
    }

    // Cari kategori pekerjaan saat ini (untuk badge)
    String currentCategory = '';
    if (hasJob) {
      final job = _availableJobs.firstWhere(
        (j) => j['title'] == character.jobName,
        orElse: () => {},
      );
      currentCategory = job['category'] ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan & Karir 💼'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Status Pekerjaan
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: hasJob ? Colors.green.shade50 : Colors.grey.shade100,
                      child: Icon(
                        hasJob ? Icons.badge : Icons.work_off,
                        size: 32,
                        color: hasJob ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hasJob ? 'Pekerjaan Saat Ini:' : 'Belum Memiliki Pekerjaan',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    if (hasJob) ...[
                      const SizedBox(height: 4),
                      Text(
                        character.jobName!,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gaji: \$${character.jobSalary}/tahun',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      if (currentCategory == 'Profesional' || currentCategory == 'Prestise') ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Karir Profesional ⭐',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _resign,
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Resign / Keluar Kerja'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Daftar Lowongan Pekerjaan vs Daftar Rekan Kerja
            if (hasJob) ...[
              const Text(
                'Aktivitas Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 12),
              _buildMenuTile(
                context: context,
                icon: Icons.trending_up,
                color: Colors.green,
                title: 'Bekerja Lebih Giat',
                subtitle: 'Meningkatkan performa kerja dan hubungan dengan atasan',
                page: BekerjaKerasActionPage(
                  character: character,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
              _buildMenuTile(
                context: context,
                icon: Icons.group,
                color: Colors.orange,
                title: 'Rekan Kerja',
                subtitle: 'Berinteraksi dengan rekan sekerja',
                page: RekanKerjaPage(
                  character: character,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
            ] else ...[
              const Text(
                'Lowongan Pekerjaan Tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 12),
              (() {
                final filteredJobsList = _getFilteredJobsList(character);
                final nonDegreeJobs = filteredJobsList.where((j) => j['category'] != 'Profesional' && j['category'] != 'Prestise').toList();
                final degreeJobs = filteredJobsList.where((j) => j['category'] == 'Profesional' || j['category'] == 'Prestise').toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.work_outline, size: 16, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Pekerjaan Umum (Tidak Butuh Gelar)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                          ),
                        ],
                      ),
                    ),
                    ...nonDegreeJobs.map((job) => _buildJobCard(job, character)),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined, size: 16, color: Colors.indigo.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Pekerjaan Profesional (Butuh Gelar Sarjana)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                          ),
                        ],
                      ),
                    ),
                    ...degreeJobs.map((job) => _buildJobCard(job, character)),
                  ],
                );
              }()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, Character character) {
    final meetsIntel = character.intelligence >= job['minIntel'];
    final requiresGelar = job['category'] == 'Profesional' || job['category'] == 'Prestise';
    final allowed = _getAllowedMajors(job['title']);
    final meetsGelar = requiresGelar
        ? _hasMatchingMajor(character, allowed)
        : true;
    final canApply = meetsIntel && meetsGelar;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: job['color'].withOpacity(0.1),
          child: Icon(job['icon'], color: job['color']),
        ),
        title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gaji: \$${job['salary']}/tahun • ${job['category']}'),
            Text(
              job['desc'],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (requiresGelar) ...[
              if (!character.isUnivGraduated)
                const Text('⚠️ Membutuhkan gelar sarjana', style: TextStyle(fontSize: 11, color: Colors.orange))
              else if (!meetsGelar)
                Text('⚠️ Butuh Gelar: ${allowed.join(", ")}', style: const TextStyle(fontSize: 11, color: Colors.orange))
            ],
          ],
        ),
        trailing: Icon(
          canApply ? Icons.arrow_forward_ios : Icons.lock,
          size: 14,
          color: canApply ? Colors.grey : Colors.red,
        ),
        onTap: () {
          if (!canApply) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  !meetsIntel
                      ? 'Kecerdasan ${character.intelligence}% < ${job['minIntel']}%'
                      : (!character.isUnivGraduated
                          ? 'Butuh gelar sarjana untuk posisi ini'
                          : 'Jurusan Anda tidak sesuai. Butuh: ${allowed.join(", ")}'),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          _applyJob(job);
        },
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          } else if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}