// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/kendaraan_mewah/kendaraan_mewah.dart
part of 'package:mylifesim/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN KENDARAAN MEWAH
// ============================================================
class KendaraanMewahPage extends StatelessWidget {
  final _KemewahanPageState state;
  const KendaraanMewahPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Ferrari F8', 'harga': 2000000000, 'happiness': 25},
      {'nama': 'Lamborghini Aventador', 'harga': 3500000000, 'happiness': 30},
      {'nama': 'Rolls Royce Phantom', 'harga': 4000000000, 'happiness': 35},
      {'nama': 'Yacht 50 Kaki', 'harga': 7500000000, 'happiness': 40},
      {'nama': 'Jet Pribadi', 'harga': 15000000000, 'happiness': 50},
    ];

    return state._buildItemPage(
      title: 'Kendaraan Mewah',
      items: items,
      ownedItems: state.kendaraan,
      onBuy: state.beliKendaraan,
    );
  }
}