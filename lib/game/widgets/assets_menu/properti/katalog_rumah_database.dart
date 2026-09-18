// lib/game/widgets/assets_menu/properti/katalog_rumah_database.dart

class HouseItemModel {
  final String id;
  final String name;
  final String type; // 'Kost & Sewa', 'Rumah Sederhana', 'Apartemen', 'Rumah Mewah', 'Villa'
  final int price;
  final int yearlyMaintenance;
  final String iconEmoji;
  final String description;

  const HouseItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.yearlyMaintenance,
    required this.iconEmoji,
    required this.description,
  });
}

class KatalogRumahDatabase {
  static const List<String> categories = [
    'Semua',
    'Kost & Sewa',
    'Rumah Sederhana',
    'Apartemen',
    'Rumah Mewah',
    'Villa',
  ];

  static const List<HouseItemModel> houses = [
    // --- TIER 1: STARTER & BUDGET LIVING ---
    HouseItemModel(
      id: 'kos_sederhana',
      name: 'Kamar Kos Sederhana',
      type: 'Kost & Sewa',
      price: 1500,
      yearlyMaintenance: 50,
      iconEmoji: '🚪',
      description: 'Kamar kos minimalis ukuran 3x3 m² dengan kamar mandi luar, pilihan pas untuk awal kemandirian.',
    ),
    HouseItemModel(
      id: 'kontrakan_petakan',
      name: 'Kontrakan Petak 3 Sekat',
      type: 'Rumah Sederhana',
      price: 3500,
      yearlyMaintenance: 100,
      iconEmoji: '🏘️',
      description: 'Kontrakan petakan ringkas dengan teras kecil, ruang tamu minimalis, dan tempat cuci piring.',
    ),
    HouseItemModel(
      id: 'apt_studio_mini',
      name: 'Apartemen Studio Minis',
      type: 'Apartemen',
      price: 6500,
      yearlyMaintenance: 200,
      iconEmoji: '🏢',
      description: 'Apartemen studio ringkas dan praktis di dekat area perkantoran, cocok untuk gaya hidup efisien.',
    ),
    HouseItemModel(
      id: 'rumah_subsidi',
      name: 'Rumah Minimalis Tipe 36',
      type: 'Rumah Sederhana',
      price: 12500,
      yearlyMaintenance: 350,
      iconEmoji: '🏡',
      description: 'Rumah tinggal nyaman dengan 2 kamar tidur, 1 kamar mandi, dan halaman depan kecil.',
    ),

    // --- TIER 2: MID-RANGE & SUBURBAN ---
    HouseItemModel(
      id: 'apt_2bedroom',
      name: 'Apartemen Modern 2 Kamar',
      type: 'Apartemen',
      price: 22000,
      yearlyMaintenance: 600,
      iconEmoji: '🏢',
      description: 'Apartemen modern lantai menengah dilengkapi fasilitas gym bersama dan keamanan 24 jam.',
    ),
    HouseItemModel(
      id: 'townhouse_minimalis',
      name: 'Townhouse Minimalis Tipe 45',
      type: 'Rumah Sederhana',
      price: 35000,
      yearlyMaintenance: 900,
      iconEmoji: '🏠',
      description: 'Townhouse 2 lantai bergaya kontemporer dengan car-port dan taman belakang yang hijau.',
    ),
    HouseItemModel(
      id: 'rumah_cluster',
      name: 'Rumah Cluster Asri Tipe 70',
      type: 'Rumah Sederhana',
      price: 55000,
      yearlyMaintenance: 1500,
      iconEmoji: '🏘️',
      description: 'Rumah modern di kawasan aman berpagar (one gate system) dengan lingkungan ramah keluarga.',
    ),
    HouseItemModel(
      id: 'rumah_hook',
      name: 'Rumah Hook Cluster Tipe 90',
      type: 'Rumah Sederhana',
      price: 85000,
      yearlyMaintenance: 2200,
      iconEmoji: '🏡',
      description: 'Rumah posisi sudut tanah luas dengan garasi mobil tertutup dan 3 kamar tidur lapang.',
    ),

    // --- TIER 3: EXECUTIVE & PREMIUM ---
    HouseItemModel(
      id: 'apt_condo_executive',
      name: 'Kondominium Eksekutif CBD',
      type: 'Apartemen',
      price: 135000,
      yearlyMaintenance: 3500,
      iconEmoji: '🌆',
      description: 'Kondominium berkelas di pusat bisnis dengan balkon luas dan kolam renang infinity rooftop.',
    ),
    HouseItemModel(
      id: 'rumah_mewah_suburb',
      name: 'Rumah Mewah Perumahan Elite',
      type: 'Rumah Mewah',
      price: 220000,
      yearlyMaintenance: 5500,
      iconEmoji: '🏛️',
      description: 'Hunian megah 4 kamar tidur dengan garasi 2 mobil, sistem smart home, dan halaman rumput hijau.',
    ),
    HouseItemModel(
      id: 'villa_pegunungan',
      name: 'Villa Asri Pegunungan',
      type: 'Villa',
      price: 320000,
      yearlyMaintenance: 7500,
      iconEmoji: '🏡',
      description: 'Villa peristirahatan sejuk di kawasan perbukitan dengan pemandangan lembah dan perapian hangat.',
    ),
    HouseItemModel(
      id: 'penthouse_skyview',
      name: 'Penthouse Apartemen Skyview',
      type: 'Apartemen',
      price: 450000,
      yearlyMaintenance: 10000,
      iconEmoji: '🏙️',
      description: 'Apartemen pemandangan kota 360 derajat di lantai paling atas lengkap dengan jacuzzi pribadi dan helipad.',
    ),

    // --- TIER 4: ULTRA LUXURY & ESTATES ---
    HouseItemModel(
      id: 'villa_pantai',
      name: 'Villa Mewah Tepi Pantai',
      type: 'Villa',
      price: 750000,
      yearlyMaintenance: 16000,
      iconEmoji: '🏝️',
      description: 'Hunian eksklusif tepi pantai dengan kolam renang pribadi dan dermaga kapal boat privat.',
    ),
    HouseItemModel(
      id: 'mansion_classic',
      name: 'Mansion Megah Klasik Eropa',
      type: 'Rumah Mewah',
      price: 1250000,
      yearlyMaintenance: 28000,
      iconEmoji: '🏰',
      description: 'Mansion mewah arsitektur klasik Eropa, 8 kamar tidur, bioskop pribadi, dan lapangan tenis.',
    ),
    HouseItemModel(
      id: 'estate_danau',
      name: 'Private Lake Estate',
      type: 'Rumah Mewah',
      price: 2100000,
      yearlyMaintenance: 45000,
      iconEmoji: '🏰',
      description: 'Kawasan hunian pribadi tepi danau dengan sistem pengamanan 24 jam, taman labirin, dan fasilitas spa.',
    ),
    HouseItemModel(
      id: 'resort_pribadi',
      name: 'Private Beach Resort Villa',
      type: 'Villa',
      price: 3500000,
      yearlyMaintenance: 75000,
      iconEmoji: '👑',
      description: 'Resort vila tropis pribadi seluas 1 hektar dengan paviliun tamu, staf butler pribadi, dan pantai privat.',
    ),
  ];

  static HouseItemModel? getById(String id) {
    try {
      return houses.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }
}

