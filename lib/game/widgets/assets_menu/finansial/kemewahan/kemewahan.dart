// lib/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

String formatRupiah(num value) {
  final parts = value.round().abs().toString().split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(parts[i]);
  }
  final formatted = buffer.toString();
  return value < 0 ? '-$formatted' : formatted;
}

class KemewahanItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const KemewahanItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 15;

    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          _showLockedDialog(context, 'Kemewahan', 15);
          return;
        }
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KemewahanPage(character: character),
          ),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.purple.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.purple.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.diamond, color: isUnlocked ? Colors.purple : Colors.grey, size: 28),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Kemewahan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'Rp ${formatRupiah(character.money)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.purple : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isUnlocked ? Icons.check_circle : Icons.lock,
              color: isUnlocked ? Colors.green : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey, size: 28),
            SizedBox(width: 8),
            Text('Fitur Terkunci', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur $feature akan terbuka saat karakter berusia $requiredAge tahun.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Usia saat ini: ${character.age} tahun',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

class KemewahanPage extends StatefulWidget {
  final Character character;
  const KemewahanPage({super.key, required this.character});

  @override
  State<KemewahanPage> createState() => _KemewahanPageState();
}

class _KemewahanPageState extends State<KemewahanPage> {
  late Character character;

  // Data (tanpa pengalamanLiburan dan layananPribadi)
  List<Map<String, dynamic>> perhiasan = [];
  List<Map<String, dynamic>> kendaraan = [];
  List<Map<String, dynamic>> propertiEksklusif = [];
  List<Map<String, dynamic>> koleksiSeni = [];
  List<Map<String, dynamic>> keanggotaan = [];
  List<Map<String, dynamic>> donasi = [];
  List<Map<String, dynamic>> koleksiDigital = [];
  List<String> penghargaan = [];

  double get totalNilaiKemewahan {
    double total = 0;
    for (var item in perhiasan) { total += (item['harga'] as num).toDouble(); }
    for (var item in kendaraan) { total += (item['harga'] as num).toDouble(); }
    for (var item in propertiEksklusif) { total += (item['harga'] as num).toDouble(); }
    for (var item in koleksiSeni) { total += (item['harga'] as num).toDouble(); }
    for (var item in koleksiDigital) { total += (item['harga'] as num).toDouble(); }
    return total;
  }

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _checkAchievements();
  }

  // ----- PENCAPAIAN (tanpa pengalamanLiburan dan layananPribadi) -----
  void _checkAchievements() {
    List<String> newAchievements = [];
    if (perhiasan.length >= 3 && !penghargaan.contains('Kolektor Perhiasan')) newAchievements.add('💎 Kolektor Perhiasan');
    if (kendaraan.length >= 2 && !penghargaan.contains('Pecinta Otomotif')) newAchievements.add('🚗 Pecinta Otomotif');
    if (propertiEksklusif.length >= 1 && !penghargaan.contains('Pemilik Properti Mewah')) newAchievements.add('🏰 Pemilik Properti Mewah');
    if (koleksiSeni.length >= 2 && !penghargaan.contains('Kolektor Seni')) newAchievements.add('🖼️ Kolektor Seni');
    if (donasi.fold<int>(0, (sum, d) => sum + (d['jumlah'] as int)) >= 5000000 && !penghargaan.contains('Dermawan')) newAchievements.add('🎗️ Dermawan');
    if (koleksiDigital.length >= 1 && !penghargaan.contains('NFT Enthusiast')) newAchievements.add('💻 NFT Enthusiast');
    if (newAchievements.isNotEmpty) {
      setState(() {
        penghargaan.addAll(newAchievements);
        character.happiness = (character.happiness + 5 * newAchievements.length).clamp(0, 100);
      });
      String msg = '🏆 Penghargaan baru: ${newAchievements.join(', ')}!';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  // ----- FUNGSI UNTUK MENAMPILKAN HALAMAN PLACEHOLDER -----
  void _showPlaceholderPage(String title, IconData icon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Colors.purple,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 80, color: Colors.purple),
                const SizedBox(height: 20),
                Text(
                  'Fitur "$title" sedang dalam pengembangan.',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----- UI UTAMA -----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kemewahan'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Aset Kemewahan', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('Rp ${formatRupiah(totalNilaiKemewahan)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple)),
                    const SizedBox(height: 8),
                    Text('Uang Tunai: Rp ${formatRupiah(character.money)}'),
                    Text('Penghargaan: ${penghargaan.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // MENU DAFTAR (8 menu setelah penghapusan)
            _buildMenuTile(
              icon: Icons.weekend,
              label: 'Perhiasan & Aksesori Mewah',
              subtitle: 'Koleksi perhiasan, jam tangan, tas desainer',
              color: Colors.pink,
              onTap: () => _showPlaceholderPage('Perhiasan & Aksesori Mewah', Icons.weekend),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.directions_car,
              label: 'Kendaraan Mewah',
              subtitle: 'Mobil sport, yacht, jet pribadi',
              color: Colors.blue,
              onTap: () => _showPlaceholderPage('Kendaraan Mewah', Icons.directions_car),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.holiday_village,
              label: 'Properti Eksklusif',
              subtitle: 'Villa, penthouse, pulau pribadi',
              color: Colors.orange,
              onTap: () => _showPlaceholderPage('Properti Eksklusif', Icons.holiday_village),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.art_track,
              label: 'Koleksi Seni & Antik',
              subtitle: 'Lukisan, patung, barang antik',
              color: Colors.red,
              onTap: () => _showPlaceholderPage('Koleksi Seni & Antik', Icons.art_track),
            ),
            const SizedBox(height: 8),

            // Menu Pengalaman Mewah dihapus
            // _buildMenuTile(... Icons.flight ...)  ----- DIHAPUS -----

            _buildMenuTile(
              icon: Icons.sports_golf,
              label: 'Gaya Hidup Premium',
              subtitle: 'Klub, spa, gym elit',
              color: Colors.green,
              onTap: () => _showPlaceholderPage('Gaya Hidup Premium', Icons.sports_golf),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.favorite,
              label: 'Filantropi',
              subtitle: 'Donasi untuk amal dan yayasan',
              color: Colors.redAccent,
              onTap: () => _showPlaceholderPage('Filantropi', Icons.favorite),
            ),
            const SizedBox(height: 8),

            _buildMenuTile(
              icon: Icons.emoji_events,
              label: 'Status & Penghargaan',
              subtitle: 'Lihat semua penghargaan yang diperoleh',
              color: Colors.amber,
              onTap: () => _showPlaceholderPage('Status & Penghargaan', Icons.emoji_events),
            ),
            const SizedBox(height: 8),

            // Menu Layanan Pribadi dihapus
            // _buildMenuTile(... Icons.person ...)  ----- DIHAPUS -----

            _buildMenuTile(
              icon: Icons.image,
              label: 'Koleksi Digital & NFT',
              subtitle: 'Karya seni digital, NFT, domain premium',
              color: Colors.cyan,
              onTap: () => _showPlaceholderPage('Koleksi Digital & NFT', Icons.image),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}