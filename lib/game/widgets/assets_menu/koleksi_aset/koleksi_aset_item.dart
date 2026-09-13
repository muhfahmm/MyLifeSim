// lib/game/widgets/assets_menu/koleksi_aset/koleksi_aset_item.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'koleksi_aksesoris/koleksi_aksesoris.dart';
import 'koleksi_perbelanjaan/koleksi_perbelanjaan.dart';

class KoleksiAksorisItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const KoleksiAksorisItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KoleksiAksorisPage(character: character),
          ),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.watch, color: Colors.purple, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Koleksi Aksesoris',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${character.ownedAccessories.length} barang koleksi aksesoris',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class KoleksiPerbelanjaanItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const KoleksiPerbelanjaanItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KoleksiPerbelanjaanPage(character: character),
          ),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.shopping_bag, color: Colors.teal, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Koleksi Hasil Belanja',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${character.ownedShopping.length} barang koleksi belanjaan',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
