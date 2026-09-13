// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/toko_online/buku_pengetahuan/database_brand.dart
class BukuPengetahuanDatabase {
  static final List<String> brands = ['Gramedia 📚', 'Mizan 📚', 'Erlangga 📚'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Gramedia 📚': [
      {'name': 'Buku Ensklopedia Sains 📚', 'cost': 150000, 'happiness': 6, 'intelligence': 6, 'desc': 'Buku sains lengkap warna-warni.', 'isbn': '978-602-217-861-3'},
      {'name': 'Buku Biografi Tokoh Dunia 📚', 'cost': 120000, 'happiness': 5, 'intelligence': 5, 'desc': 'Kisah inspiratif tokoh-tokoh hebat.', 'isbn': '978-602-032-114-1'},
    ],
    'Mizan 📚': [
      {'name': 'Buku Sejarah Peradaban 📚', 'cost': 130000, 'happiness': 5, 'intelligence': 7, 'desc': 'Pengetahuan mendalam tentang peradaban.', 'isbn': '978-602-441-052-0'},
      {'name': 'Buku Filsafat Dasar 📚', 'cost': 100000, 'happiness': 4, 'intelligence': 8, 'desc': 'Membuka cara berpikir kritis.', 'isbn': '978-602-291-526-3'},
    ],
    'Erlangga 📚': [
      {'name': 'Buku Pemrograman Komputer 📚', 'cost': 200000, 'happiness': 8, 'intelligence': 10, 'desc': 'Panduan koding dari dasar sampai mahir.', 'isbn': '978-602-241-998-3'},
      {'name': 'Buku Ekonomi & Finansial 📚', 'cost': 180000, 'happiness': 7, 'intelligence': 9, 'desc': 'Belajar manajemen keuangan pribadi.', 'isbn': '978-602-434-112-1'},
    ],
  };
}
