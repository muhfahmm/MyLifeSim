// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/toko_online/dekorasi_rumah/database_brand.dart
class DekorasiRumahDatabase {
  static final List<String> brands = ['IKEA 🛋️', 'Informa 🛋️', 'Ace Hardware 🏠'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'IKEA 🛋️': [
      {'name': 'Sofa Minimalis Klippan 🛋️', 'cost': 220, 'happiness': 15, 'desc': 'Sofa empuk desain khas Swedia.'},
      {'name': 'Lantai Kayu Parquet 🪵', 'cost': 300, 'happiness': 20, 'desc': 'Ubin kayu aesthetic untuk ruang tamu.'},
      {'name': 'Lampu Meja Riggad 💡', 'cost': 45, 'happiness': 8, 'desc': 'Lampu meja belajar dengan wireless charger.'},
    ],
    'Informa 🛋️': [
      {'name': 'Karpet Velvet Luxury 🛋️', 'cost': 95, 'happiness': 12, 'desc': 'Karpet bulu halus dan hangat.'},
      {'name': 'Rak Buku Modular 📚', 'cost': 75, 'happiness': 10, 'desc': 'Rak rapi untuk susunan koleksi buku.'},
    ],
    'Ace Hardware 🏠': [
      {'name': 'Jam Dinding Modern Giant ⏰', 'cost': 30, 'happiness': 6, 'desc': 'Jam dinding besar pemanis ruangan.'},
      {'name': 'Tanaman Hias Monstera 🪴', 'cost': 20, 'happiness': 5, 'desc': 'Tanaman indoor aesthetic penghijau ruangan.'},
    ],
  };
}
