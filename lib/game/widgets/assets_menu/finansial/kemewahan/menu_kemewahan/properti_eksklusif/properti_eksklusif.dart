// lib/game/widgets/assets_menu/finansial/kemewahan/menu_kemewahan/properti_eksklusif/properti_eksklusif.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';

// ============================================================
// HALAMAN PROPERTI EKSKLUSIF
// ============================================================
class PropertiEksklusifPage extends StatelessWidget {
  final _KemewahanPageState state;
  const PropertiEksklusifPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Villa di Bali', 'harga': 5000000000, 'happiness': 30},
      {'nama': 'Penthouse di Jakarta', 'harga': 8000000000, 'happiness': 35},
      {'nama': 'Kastil di Eropa', 'harga': 15000000000, 'happiness': 45},
      {'nama': 'Pulau Pribadi', 'harga': 50000000000, 'happiness': 60},
    ];

    return state._buildItemPage(
      title: 'Properti Eksklusif',
      items: items,
      ownedItems: state.propertiEksklusif,
      onBuy: state.beliProperti,
    );
  }
}