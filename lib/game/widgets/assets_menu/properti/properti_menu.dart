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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '${character.ownedHouses.length} rumah dimiliki',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey),
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

enum SortOption { priceAsc, priceDesc, nameAsc }

class _PropertiMenuPageState extends State<PropertiMenuPage> {
  String _searchQuery = '';
  SortOption _currentSort = SortOption.priceAsc;
  bool _showOwnedDetails = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final owned = character.ownedHouses;

    // Filter & Sort Katalog
    List<HouseItemModel> filteredCatalog = KatalogRumahDatabase.houses.where((h) {
      final matchesSearch = _searchQuery.isEmpty ||
          h.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    filteredCatalog.sort((a, b) {
      switch (_currentSort) {
        case SortOption.priceAsc:
          return a.price.compareTo(b.price);
        case SortOption.priceDesc:
          return b.price.compareTo(a.price);
        case SortOption.nameAsc:
          return a.name.compareTo(b.name);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Properti & Rumah',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // ==================== SECTION 1: RUMAH SAYA ====================
          _buildRumahSayaSection(context, character, owned, isDark),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1.2),
          ),
          const SizedBox(height: 8),

          // ==================== SECTION 2: KATALOG BELI PROPERTI ====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.store, color: Colors.indigo, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Katalog Beli Properti',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const Spacer(),
                Text(
                  '${filteredCatalog.length} Pilihan',
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Search & Sort Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari rumah, villa, apartemen...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo.withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade900 : Colors.indigo.withValues(alpha: 0.03),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<SortOption>(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.sort, color: Colors.indigo, size: 20),
                  ),
                  tooltip: 'Urutkan',
                  onSelected: (SortOption result) {
                    setState(() {
                      _currentSort = result;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                    const PopupMenuItem<SortOption>(
                      value: SortOption.priceAsc,
                      child: Text('Harga: Murah ke Mahal'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.priceDesc,
                      child: Text('Harga: Mahal ke Murah'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.nameAsc,
                      child: Text('Nama: A - Z'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Catalog List Items
          if (filteredCatalog.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.search_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Tidak ada properti yang cocok dengan pencarian',
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredCatalog.map((house) {
              final bool alreadyOwned = character.ownedHouses.any((h) => h['name'] == house.name);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: alreadyOwned ? Colors.green.withValues(alpha: 0.5) : Colors.indigo.withValues(alpha: 0.2),
                      width: alreadyOwned ? 1.5 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
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
                              child: Text(house.iconEmoji, style: const TextStyle(fontSize: 28)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          house.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.indigo.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          house.type,
                                          style: const TextStyle(fontSize: 10.5, color: Colors.indigo, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    house.description,
                                    style: const TextStyle(fontSize: 11.5, color: Colors.grey, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CurrencySettings.format(house.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'Perawatan: ${CurrencySettings.format(house.yearlyMaintenance)}/thn',
                                  style: const TextStyle(fontSize: 10.5, color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: alreadyOwned
                                  ? null
                                  : () => _handleBuyHouse(context, character, house),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: alreadyOwned ? Colors.grey : Colors.indigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              icon: Icon(alreadyOwned ? Icons.check_circle : Icons.shopping_bag, size: 16),
                              label: Text(alreadyOwned ? 'Dimiliki' : 'Beli Properti'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRumahSayaSection(
    BuildContext context,
    Character character,
    List<Map<String, String>> owned,
    bool isDark,
  ) {
    int totalValue = 0;
    int totalMaintenance = 0;
    for (var item in owned) {
      final int val = int.tryParse(item['value'] ?? item['price'] ?? '0') ?? 0;
      final int maint = int.tryParse(item['yearlyMaintenance'] ?? '0') ?? 0;
      totalValue += val;
      totalMaintenance += maint;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.home, color: Colors.indigo, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Rumah Saya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
              if (owned.isNotEmpty)
                InkWell(
                  onTap: () {
                    setState(() {
                      _showOwnedDetails = !_showOwnedDetails;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _showOwnedDetails ? 'Sembunyikan' : 'Tampilkan (${owned.length})',
                        style: const TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        _showOwnedDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.indigo,
                        size: 20,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          if (owned.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.indigo.withValues(alpha: 0.1) : Colors.indigo.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.indigo, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Belum Memiliki Properti',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pilih dan beli tempat tinggal dari katalog di bawah untuk memulai kehidupan mandiri.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else ...[
            // Card Portofolio Properti
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.indigo.shade900, Colors.indigo.shade700]
                      : [Colors.indigo.shade600, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Aset Properti',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${owned.length} Rumah',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencySettings.format(totalValue),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Perawatan / Tahun',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencySettings.format(totalMaintenance),
                              style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status Tempat Tinggal',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              character.livesWithParents ? 'Bersama Ortu' : (character.activeHouseName ?? 'Mandiri'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_showOwnedDetails) ...[
              const SizedBox(height: 12),
              ...owned.asMap().entries.map((entry) {
                final int index = entry.key;
                final item = entry.value;
                final String id = item['id'] ?? '';
                final String name = item['name'] ?? 'Rumah';
                final String type = item['type'] ?? '';
                final int value = int.tryParse(item['value'] ?? item['price'] ?? '0') ?? 0;
                final int maintenance = int.tryParse(item['yearlyMaintenance'] ?? '0') ?? 0;
                final String emoji = item['iconEmoji'] ?? KatalogRumahDatabase.getById(id)?.iconEmoji ?? '🏠';
                final bool isActive = !character.livesWithParents && character.activeHouseName == name;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isActive ? Colors.green : Colors.indigo.withValues(alpha: 0.2),
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.indigo.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(emoji, style: const TextStyle(fontSize: 26)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      type,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: const Text(
                                    '🏠 Ditinggali',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Nilai Estimasi', style: TextStyle(fontSize: 10.5, color: Colors.grey)),
                                    Text(
                                      CurrencySettings.format(value),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Biaya Perawatan', style: TextStyle(fontSize: 10.5, color: Colors.grey)),
                                    Text(
                                      '${CurrencySettings.format(maintenance)}/thn',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.amber),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!isActive) ...[
                                OutlinedButton.icon(
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
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                    side: const BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: const Icon(Icons.home, size: 16),
                                  label: const Text('Tinggali'),
                                ),
                                const SizedBox(width: 8),
                              ],
                              ElevatedButton.icon(
                                onPressed: () {
                                  _confirmSell(context, character, item, index);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade100,
                                  foregroundColor: Colors.red.shade900,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.sell, size: 16),
                                label: const Text('Jual (85%)'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ],
      ),
    );
  }

  void _handleBuyHouse(BuildContext context, Character character, HouseItemModel house) {
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
                      'Ingin langsung pindah ke tempat tinggal baru ini atau tetap di hunian saat ini?',
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
  }

  void _confirmSell(BuildContext context, Character character, Map<String, String> item, int index) {
    final String name = item['name'] ?? 'Rumah';
    final int value = int.tryParse(item['value'] ?? item['price'] ?? '0') ?? 0;
    final int sellPrice = (value * 0.85).round();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Jual $name?'),
        content: Text(
          'Apakah kamu yakin ingin menjual $name seharga ${CurrencySettings.format(sellPrice)} (85% dari nilai beli)?',
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
            child: const Text('Jual Properti'),
          ),
        ],
      ),
    );
  }
}
