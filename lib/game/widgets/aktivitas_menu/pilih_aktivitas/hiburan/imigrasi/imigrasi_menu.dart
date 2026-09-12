// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/imigrasi_menu.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/pindah_negara_menu.dart';
import 'package:mylifesim/utils/country_helper.dart';

class ImigrasimMenuHelper {
  static void showImigrasimMenu(BuildContext context, Character character, VoidCallback onComplete, {String? initialSearchQuery}) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk berimigrasi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PindahNegaraMenuPage(
          character: character,
          onComplete: onComplete,
          initialSearchQuery: initialSearchQuery,
        ),
      ),
    );
  }

  static String _getContinentForIso(String? iso) {
    if (iso == null) return 'asia';
    const africaIsos = {'ZA', 'DZ', 'AO', 'BJ', 'BW', 'BF', 'BI', 'TD', 'DJ', 'ER', 'SZ', 'ET', 'GA', 'GM', 'GH', 'GN', 'GW', 'KE', 'LS', 'LR', 'LY', 'MG', 'MW', 'ML', 'MR', 'MU', 'EG', 'MZ', 'NA', 'NE', 'NG', 'CI', 'CF', 'CD', 'SD', 'TZ', 'UG', 'ZM', 'ZW', 'RW', 'ST', 'SN', 'SC', 'SL', 'SO', 'SS', 'TG', 'TN', 'CV', 'KM', 'CG', 'MA'};
    const asiaIsos = {'AF', 'SA', 'AM', 'AZ', 'BH', 'BD', 'BT', 'BN', 'CN', 'PH', 'GE', 'HK', 'IN', 'ID', 'IQ', 'IR', 'IL', 'JP', 'KH', 'KZ', 'KG', 'KR', 'KP', 'KW', 'LA', 'LB', 'MO', 'MY', 'MV', 'MN', 'MM', 'NP', 'OM', 'PK', 'PS', 'QA', 'TL', 'SG', 'CY', 'LK', 'SY', 'TW', 'TJ', 'TH', 'TR', 'TM', 'AE', 'UZ', 'VN', 'YE', 'JO'};
    const eropaIsos = {'AL', 'AD', 'AT', 'NL', 'BY', 'BE', 'BA', 'BG', 'CZ', 'DK', 'EE', 'FI', 'GI', 'HU', 'GB', 'IE', 'IS', 'IT', 'DE', 'FO', 'XK', 'HR', 'LV', 'LI', 'LT', 'LU', 'MK', 'MT', 'MD', 'MC', 'ME', 'NO', 'PL', 'PT', 'FR', 'RO', 'RS', 'RU', 'SM', 'SI', 'SK', 'ES', 'SE', 'CH', 'UA', 'VA', 'GR'};
    const naIsos = {'US', 'AG', 'BS', 'BB', 'BZ', 'BM', 'CR', 'CW', 'DM', 'SV', 'GL', 'GD', 'GT', 'HT', 'HN', 'JM', 'CA', 'CU', 'MX', 'NI', 'PA', 'PR', 'DO', 'KN', 'LC', 'VC', 'TT'};
    const saIsos = {'AR', 'BO', 'BR', 'CL', 'EC', 'GF', 'GY', 'CO', 'PY', 'PE', 'SR', 'UY', 'VE'};
    const oceaniaIsos = {'AU', 'FJ', 'GU', 'KI', 'MH', 'FM', 'NR', 'PW', 'PG', 'WS', 'AS', 'NZ', 'PF', 'TO', 'TV', 'VU'};

    final isoUpper = iso.toUpperCase();
    if (africaIsos.contains(isoUpper)) return 'afrika';
    if (asiaIsos.contains(isoUpper)) return 'asia';
    if (eropaIsos.contains(isoUpper)) return 'eropa';
    if (naIsos.contains(isoUpper)) return 'na';
    if (saIsos.contains(isoUpper)) return 'sa';
    if (oceaniaIsos.contains(isoUpper)) return 'oceania';
    return 'asia';
  }

  static Future<List<String>> fetchCitiesForCountry(String countryName) async {
    final String countryLower = countryName.toLowerCase().trim();
    try {
      final String response = await rootBundle.loadString('json/bendera_negara/countries.json');
      final Map<String, dynamic> data = jsonDecode(response);
      
      String iso = '';
      if (data.containsKey(countryLower)) {
        iso = data[countryLower]['iso'] ?? '';
      } else {
        data.forEach((key, val) {
          if (key.toLowerCase() == countryLower || (val['name'] ?? '').toString().toLowerCase() == countryLower) {
            iso = val['iso'] ?? '';
          }
        });
      }

      final String continent = _getContinentForIso(iso);
      final String countryFolder = CountryHelper.normalizeCountryFolder(countryName);
      final String cityContent = await rootBundle.loadString('json/nama_kota/$continent/$countryFolder.json');
      final List<dynamic> jsonList = jsonDecode(cityContent);
      return List<String>.from(jsonList);
    } catch (e) {
      debugPrint('Error loading city list for $countryName: $e');
      return [];
    }
  }

  static Future<void> processImigrasiToCountry(
    BuildContext context,
    Character character,
    String targetCountry,
    VoidCallback onComplete, {
    VoidCallback? onCitySelected,
  }) async {
    character.location = targetCountry;
    await character.updateLocationNamesData(targetCountry);
    character.resignJob();
    character.coworkers.clear();
    character.supervisor = null;
    character.univClassmates.clear();
    character.univLecturers.clear();
    character.idolTrainees.clear();
    character.idolMainMembers.clear();
    character.idolStaff.clear();

    final msg = '✈️ Kamu resmi pindah ke $targetCountry!';
    character.inbox.add(msg);
    onComplete();

    final List<String> cities = await fetchCitiesForCountry(targetCountry);

    if (!context.mounted) return;

    if (cities.isNotEmpty) {
      showSelectCityModal(context, character, targetCountry, cities, () {
        onComplete();
        onCitySelected?.call();
      });
    } else {
      character.currentCity = null;
      onComplete();
      onCitySelected?.call();
    }
  }

  static void showSelectCityModal(
    BuildContext parentContext,
    Character character,
    String countryName,
    List<String> cities,
    VoidCallback onComplete,
  ) {
    if (cities.isEmpty) {
      character.currentCity = null;
      onComplete();
      return;
    }

    String citySearchQuery = '';

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final bool isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final List<String> filteredCities = cities.where((c) => c.toLowerCase().contains(citySearchQuery.toLowerCase())).toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.location_city, color: Colors.blue, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pilih Kota di $countryName 🏙️',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selamat atas kepindahanmu ke $countryName! Silakan pilih kota tempat tinggal barumu:',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (val) {
                        setModalState(() {
                          citySearchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari nama kota...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: filteredCities.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Kota tidak ditemukan.', style: TextStyle(color: Colors.grey)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredCities.length,
                                itemBuilder: (ctx, idx) {
                                  final cityName = filteredCities[idx];
                                  return Card(
                                    elevation: 0,
                                    margin: const EdgeInsets.only(bottom: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.apartment, color: Colors.blue),
                                      title: Text(
                                        cityName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                      onTap: () {
                                        character.currentCity = cityName;
                                        character.inbox.add('🏙️ Tempat Tinggal: Kamu resmi menetap dan tinggal di kota $cityName, $countryName.');
                                        Navigator.pop(dialogCtx);
                                        onComplete();
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
