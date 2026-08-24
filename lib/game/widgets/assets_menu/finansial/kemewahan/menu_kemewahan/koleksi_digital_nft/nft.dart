// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/koleksi_digital_nft/nft.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN KOLEKSI DIGITAL & NFT
// ============================================================
class NFTPage extends StatelessWidget {
  final _KemewahanPageState state;
  const NFTPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'NFT Karya Seni', 'harga': 50000000, 'happiness': 15},
      {'nama': 'NFT Koleksi Game', 'harga': 30000000, 'happiness': 12},
      {'nama': 'NFT Domain Premium', 'harga': 100000000, 'happiness': 20},
      {'nama': 'Koleksi Crypto Art', 'harga': 75000000, 'happiness': 18},
    ];

    return state._buildItemPage(
      title: 'Koleksi Digital & NFT',
      items: items,
      ownedItems: state.koleksiDigital,
      onBuy: state.beliDigital,
    );
  }
}