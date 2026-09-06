// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/gaya_hidup_premium/gaya_hidup_premium.dart
part of 'package:mylifesim/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN GAYA HIDUP PREMIUM
// ============================================================
class GayaHidupPremiumPage extends StatelessWidget {
  final _KemewahanPageState state;
  const GayaHidupPremiumPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Klub Golf Eksklusif', 'harga': 20000000, 'happiness': 12},
      {'nama': 'Spa Premium', 'harga': 15000000, 'happiness': 10},
      {'nama': 'Gym Elite', 'harga': 10000000, 'happiness': 8},
      {'nama': 'Klub Malam VIP', 'harga': 25000000, 'happiness': 15},
    ];

    return state._buildItemPage(
      title: 'Gaya Hidup Premium',
      items: items,
      ownedItems: state.keanggotaan,
      onBuy: state.beliKeanggotaan,
    );
  }
}