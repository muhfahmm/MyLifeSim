// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/koleksi_seni_antik/koleksi_antik.dart
part of 'package:mylifesim/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN KOLEKSI SENI & ANTIK
// ============================================================
class KoleksiAntikPage extends StatelessWidget {
  final _KemewahanPageState state;
  const KoleksiAntikPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Lukisan Monalisa (replika)', 'harga': 1000000000, 'happiness': 20},
      {'nama': 'Patung David (replika)', 'harga': 800000000, 'happiness': 18},
      {'nama': 'Koleksi Lukisan Modern', 'harga': 2000000000, 'happiness': 25},
      {'nama': 'Barang Antik Eropa', 'harga': 1500000000, 'happiness': 22},
    ];

    return state._buildItemPage(
      title: 'Koleksi Seni & Antik',
      items: items,
      ownedItems: state.koleksiSeni,
      onBuy: state.beliSeni,
    );
  }
}