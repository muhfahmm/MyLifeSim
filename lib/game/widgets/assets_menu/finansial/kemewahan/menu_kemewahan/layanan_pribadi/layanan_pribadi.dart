// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/layanan_pribadi/layanan_pribadi.dart
part of 'package:mylifesim/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN LAYANAN PRIBADI
// ============================================================
class LayananPribadiPage extends StatelessWidget {
  final _KemewahanPageState state;
  const LayananPribadiPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Asisten Pribadi', 'harga': 15000000, 'happiness': 15},
      {'nama': 'Koki Pribadi', 'harga': 12000000, 'happiness': 12},
      {'nama': 'Sopir Pribadi', 'harga': 10000000, 'happiness': 10},
      {'nama': 'Penata Gaya', 'harga': 8000000, 'happiness': 10},
    ];

    return state._buildItemPage(
      title: 'Layanan Pribadi',
      items: items,
      ownedItems: state.layananPribadi,
      onBuy: state.beliLayanan,
    );
  }
}