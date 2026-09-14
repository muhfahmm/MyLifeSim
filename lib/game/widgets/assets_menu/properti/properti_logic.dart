// lib/game/widgets/assets_menu/properti/properti_logic.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/assets_menu/properti/katalog_rumah_database.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class PropertiLogic {
  /// Membeli rumah baru dari katalog
  static Map<String, dynamic> buyHouse(Character character, HouseItemModel house) {
    if (character.money < house.price) {
      return {
        'success': false,
        'message': 'Uang kamu tidak cukup untuk membeli ${house.name} (${CurrencySettings.format(house.price)}).',
      };
    }

    character.money -= house.price;
    character.ownedHouses.add({
      'id': house.id,
      'name': house.name,
      'type': house.type,
      'price': house.price.toString(),
      'yearlyMaintenance': house.yearlyMaintenance.toString(),
      'iconEmoji': house.iconEmoji,
      'boughtAge': character.age.toString(),
    });

    character.inbox.add('🏠 Pembelian Properti: Kamu berhasil membeli ${house.name} seharga ${CurrencySettings.format(house.price)}!');
    return {
      'success': true,
      'message': 'Selamat! Kamu berhasil membeli ${house.name}.',
    };
  }

  /// Menjual rumah yang dimiliki (mendapatkan 85% dari harga beli)
  static Map<String, dynamic> sellHouse(Character character, Map<String, String> houseMap) {
    final int price = int.tryParse(houseMap['price'] ?? '0') ?? 0;
    final int sellPrice = (price * 0.85).round();

    final String houseName = houseMap['name'] ?? 'Rumah';
    
    // Jika rumah yang dijual sedang ditinggali user
    if (character.activeHouseName == houseName) {
      character.activeHouseName = null;
      character.livesWithParents = true;
    }

    character.ownedHouses.remove(houseMap);
    character.money += sellPrice;

    character.inbox.add('💰 Penjualan Properti: Kamu menjual $houseName seharga ${CurrencySettings.format(sellPrice)}.');
    return {
      'success': true,
      'message': 'Kamu berhasil menjual $houseName seharga ${CurrencySettings.format(sellPrice)}.',
    };
  }
}
