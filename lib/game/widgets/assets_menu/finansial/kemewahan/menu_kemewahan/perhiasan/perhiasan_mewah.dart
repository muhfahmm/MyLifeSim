// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/perhiasan/perhiasan_mewah.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN PERHIASAN & AKSESORI MEWAH
// ============================================================
class PerhiasanMewahPage extends StatelessWidget {
  final _KemewahanPageState state;
  const PerhiasanMewahPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Jam Tangan Rolex', 'harga': 50000000, 'happiness': 15},
      {'nama': 'Kalung Berlian', 'harga': 75000000, 'happiness': 20},
      {'nama': 'Tas Hermès Birkin', 'harga': 120000000, 'happiness': 25},
      {'nama': 'Cincin Emas 24K', 'harga': 15000000, 'happiness': 10},
      {'nama': 'Koleksi Perhiasan Eksklusif', 'harga': 300000000, 'happiness': 30},
    ];

    return state._buildItemPage(
      title: 'Perhiasan & Aksesori Mewah',
      items: items,
      ownedItems: state.perhiasan,
      onBuy: state.beliPerhiasan,
    );
  }
}