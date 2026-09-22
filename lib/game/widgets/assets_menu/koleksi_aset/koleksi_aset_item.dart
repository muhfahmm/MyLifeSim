// lib/game/widgets/assets_menu/koleksi_aset/koleksi_aset_item.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'koleksi_aksesoris/koleksi_aksesoris.dart';
import 'koleksi_perbelanjaan/koleksi_perbelanjaan.dart';

class KoleksiAksorisItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const KoleksiAksorisItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 12;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          DialogHelper.show(
            context: context,
            title: 'Fitur Terkunci',
            content: Text(
              'Fitur Koleksi Aksesoris terbuka saat usia 12 tahun. (Usia saat ini: ${character.age} tahun)',
            ),
          );
          return;
        }
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
          color: isUnlocked
              ? Colors.purple.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? Colors.purple.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.watch, color: isUnlocked ? Colors.purple : Colors.grey, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Koleksi Aksesoris',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '${character.ownedAccessories.length} barang koleksi aksesoris',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              isUnlocked ? Icons.chevron_right : Icons.lock,
              color: isUnlocked ? Colors.purple : Colors.grey,
            ),
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
    final bool isUnlocked = character.age >= 12;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          DialogHelper.show(
            context: context,
            title: 'Fitur Terkunci',
            content: Text(
              'Fitur Koleksi Hasil Belanja terbuka saat usia 12 tahun. (Usia saat ini: ${character.age} tahun)',
            ),
          );
          return;
        }
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
          color: isUnlocked
              ? Colors.teal.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? Colors.teal.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.shopping_bag, color: isUnlocked ? Colors.teal : Colors.grey, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Koleksi Hasil Belanja',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '${character.ownedShopping.length} barang koleksi belanjaan',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              isUnlocked ? Icons.chevron_right : Icons.lock,
              color: isUnlocked ? Colors.teal : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
