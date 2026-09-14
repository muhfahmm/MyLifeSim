// lib/game/widgets/assets_menu/properti/properti_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/tempat_tinggal/tempat_tinggal_logic.dart';
import 'katalog_rumah_database.dart';
import 'properti_logic.dart';

class PropertiItem extends StatelessWidget {
  final Character character;
  final VoidCallback? onPop;

  const PropertiItem({super.key, required this.character, this.onPop});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = character.age >= 18;
    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          DialogHelper.show(
            context: context,
            title: 'Fitur Terkunci',
            content: Text(
              'Fitur Properti & Rumah terbuka saat usia 18 tahun. (Usia saat ini: ${character.age} tahun)',
            ),
          );
          return;
        }
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertiMenuPage(character: character),
          ),
        ).then((_) => onPop?.call());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.indigo.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.indigo.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.home_work, color: isUnlocked ? Colors.indigo : Colors.grey, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Properti & Rumah',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${character.ownedHouses.length} rumah dimiliki',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              isUnlocked ? Icons.chevron_right : Icons.lock,
              color: isUnlocked ? Colors.indigo : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class PropertiMenuPage extends StatefulWidget {
  final Character character;

  const PropertiMenuPage({super.key, required this.character});

  @override
  State<PropertiMenuPage> createState() => _PropertiMenuPageState();
}

class _PropertiMenuPageState extends State<PropertiMenuPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properti & Rumah'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Rumah Saya'),
            Tab(icon: Icon(Icons.store), text: 'Katalog Beli'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRumahSayaTab(context, character, isDark),
          _buildKatalogBeliTab(context, character, isDark),
        ],
      ),
    );
  }

  Widget _buildRumahSayaTab(BuildContext context, Character character, bool isDark) {
    final owned = character.ownedHouses;
    if (owned.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Belum Memiliki Rumah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Beli rumah impianmu di tab Katalog Beli!',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Buka Katalog'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: owned.length,
      itemBuilder: (context, index) {
        final item = owned[index];
        final String name = item['name'] ?? 'Rumah';
        final String type = item['type'] ?? '';
        final int value = int.tryParse(item['value'] ?? '0') ?? 0;
        final bool isActive = !character.livesWithParents && character.activeHouseName == name;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isActive ? Colors.green : Colors.indigo.withValues(alpha: 0.3),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.house, color: Colors.indigo, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            type,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Text(
                          'Ditinggali',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Nilai Estimasi: ${CurrencySettings.format(value)}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isActive) ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              final res = TempatTinggalLogic.setLivingArrangement(
                                character,
                                livesWithParents: false,
                                houseName: name,
                              );
                              setState(() {});
                              DialogHelper.show(
                                context: context,
                                title: 'Pindah Rumah 🚚',
                                content: Text((res['message'] ?? '').toString()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade100,
                              foregroundColor: Colors.green.shade900,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            icon: const Icon(Icons.home, size: 16),
                            label: const Text('Tinggali'),
                          ),
                          const SizedBox(width: 6),
                        ],
                        ElevatedButton.icon(
                          onPressed: () {
                            _confirmSell(context, character, item, index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            foregroundColor: Colors.red.shade900,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          icon: const Icon(Icons.sell, size: 16),
                          label: const Text('Jual'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKatalogBeliTab(BuildContext context, Character character, bool isDark) {
    const catalog = KatalogRumahDatabase.houses;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: catalog.length,
      itemBuilder: (context, index) {
        final house = catalog[index];
        final bool alreadyOwned = character.ownedHouses.any((h) => h['name'] == house.name);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.indigo.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home, color: Colors.indigo, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            house.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            house.type,
                            style: const TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            house.description,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencySettings.format(house.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: alreadyOwned
                          ? null
                          : () {
                              final res = PropertiLogic.buyHouse(character, house);
                              final bool success = res['success'] == true;
                              final String message = (res['message'] ?? '').toString();
                              setState(() {});

                              if (success) {
                                final bool isCurrentlyLivingWithParents = character.livesWithParents;

                                DialogHelper.show(
                                  context: context,
                                  title: 'Pembelian Berhasil 🏠',
                                  isNotification: false,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(message, style: const TextStyle(fontSize: 13, height: 1.4)),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.info_outline, color: Colors.blue, size: 20),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Ingin langsung pindah ke rumah baru ini atau tetap di tempat tinggal saat ini?',
                                                style: TextStyle(fontSize: 11, color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (isCurrentlyLivingWithParents) {
                                          TempatTinggalLogic.setLivingArrangement(character, livesWithParents: true);
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        isCurrentlyLivingWithParents 
                                            ? 'Tetap Tinggal Bersama Orang Tua' 
                                            : 'Tetap di Rumah Saat Ini',
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        final moveRes = TempatTinggalLogic.setLivingArrangement(
                                          character,
                                          livesWithParents: false,
                                          houseName: house.name,
                                        );
                                        setState(() {});
                                        DialogHelper.show(
                                          context: context,
                                          title: 'Pindah Rumah 🚚',
                                          content: Text((moveRes['message'] ?? '').toString()),
                                        );
                                      },
                                      child: const Text('Pindah Rumah 🏠'),
                                    ),
                                  ],
                                );
                              } else {
                                DialogHelper.show(
                                  context: context,
                                  title: 'Pembelian Gagal',
                                  content: Text(message),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: alreadyOwned ? Colors.grey : Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(alreadyOwned ? 'Dimiliki' : 'Beli Rumah'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmSell(BuildContext context, Character character, Map<String, String> item, int index) {
    final String name = item['name'] ?? 'Rumah';
    final int value = int.tryParse(item['value'] ?? '0') ?? 0;
    final int sellPrice = (value * 0.8).round();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Jual $name?'),
        content: Text(
          'Apakah kamu yakin ingin menjual rumah ini seharga ${CurrencySettings.format(sellPrice)} (80% dari harga beli)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              final res = PropertiLogic.sellHouse(character, item);
              final bool success = res['success'] == true;
              final String message = (res['message'] ?? '').toString();
              setState(() {});
              DialogHelper.show(
                context: context,
                title: success ? 'Penjualan Berhasil' : 'Penjualan Gagal',
                content: Text(message),
              );
            },
            child: const Text('Jual'),
          ),
        ],
      ),
    );
  }
}
