// lib/game/widgets/assets_menu/properti/katalog_rumah_database.dart

class HouseItemModel {
  final String id;
  final String name;
  final String type; // 'Apartemen', 'Rumah Sederhana', 'Rumah Mewah', 'Villa'
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
  static const List<HouseItemModel> houses = [
    HouseItemModel(
      id: 'apt_studio',
      name: 'Apartemen Studio Minis',
      type: 'Apartemen',
      price: 25000,
      yearlyMaintenance: 500,
      iconEmoji: '🏢',
      description: 'Apartemen studio ringkas dan praktis, cocok untuk tinggal mandiri pertama kali.',
    ),
    HouseItemModel(
      id: 'rumah_subsidi',
      name: 'Rumah Minimalis Tipe 36',
      type: 'Rumah Sederhana',
      price: 50000,
      yearlyMaintenance: 1000,
      iconEmoji: '🏡',
      description: 'Rumah tinggal nyaman dengan 2 kamar tidur dan halaman depan kecil.',
    ),
    HouseItemModel(
      id: 'rumah_cluster',
      name: 'Rumah Cluster Asri Tipe 70',
      type: 'Rumah Sederhana',
      price: 120000,
      yearlyMaintenance: 2500,
      iconEmoji: '🏠',
      description: 'Rumah modern di kawasan aman berpagar dengan lingkungan yang ramah keluarga.',
    ),
    HouseItemModel(
      id: 'apartemen_mewah',
      name: 'Penthouse Apartemen Skyview',
      type: 'Apartemen',
      price: 350000,
      yearlyMaintenance: 7500,
      iconEmoji: '🏙️',
      description: 'Apartemen mewah dengan pemandangan kota di lantai atas lengkap dengan pemandian balkon.',
    ),
    HouseItemModel(
      id: 'villa_pantai',
      name: 'Villa Mewah Tepi Pantai',
      type: 'Villa',
      price: 850000,
      yearlyMaintenance: 15000,
      iconEmoji: '🏰',
      description: 'Hunian megah impian dengan kolam renang pribadi dan pemandangan laut yang indah.',
    ),
  ];
}
