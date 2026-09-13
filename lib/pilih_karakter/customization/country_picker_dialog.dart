// lib/pilih_karakter/customization/country_picker_dialog.dart

import 'package:flutter/material.dart';

class CountryPickerDialog extends StatefulWidget {
  final List<Map<String, dynamic>> countriesList;
  final Function(Map<String, dynamic> selectedCountry) onCountrySelected;

  const CountryPickerDialog({
    super.key,
    required this.countriesList,
    required this.onCountrySelected,
  });

  static String countryCodeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '🌍';
    int firstChar = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    int secondChar = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  static String capitalizeTitle(String text) {
    if (text.isEmpty) return '';
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  String searchQuery = '';

  static const Map<String, List<String>> continentMap = {
    'Asia': ['afganistan', 'arab saudi', 'armenia', 'azerbaijan', 'bahrain', 'bangladesh', 'bhutan', 'brunei', 'china', 'filipina', 'georgia', 'hong kong', 'india', 'indonesia', 'irak', 'iran', 'israel', 'jepang', 'kamboja', 'kazakhstan', 'kirgizstan', 'korea selatan', 'korea utara', 'kuwait', 'laos', 'lebanon', 'makau', 'malaysia', 'maldives', 'mongolia', 'myanmar', 'nepal', 'oman', 'pakistan', 'palestina', 'qatar', 'singapura', 'siprus', 'sri lanka', 'suriah', 'tajikistan', 'thailand', 'timor leste', 'turkmenistan', 'uni emirat arab', 'uzbekistan', 'vietnam', 'yaman', 'yordania'],
    'Afrika': ['afrika selatan', 'aljazair', 'angola', 'benin', 'botswana', 'burkina faso', 'burundi', 'chad', 'djibouti', 'eritrea', 'eswatini', 'ethiopia', 'gabon', 'gambia', 'ghana', 'guinea', 'guinea bissau', 'kamerun', 'kenya', 'komoro', 'kongo', 'lesotho', 'liberia', 'libya', 'madagaskar', 'malawi', 'mali', 'maroko', 'mauritania', 'mauritius', 'mesir', 'mozambik', 'namibia', 'niger', 'nigeria', 'pantai gading', 'republik afrika tengah', 'republik demokratik kongo', 'rwanda', 'senegal', 'seychelles', 'sierra leone', 'somalia', 'sudan', 'sudan selatan', 'tanjung verde', 'tanzania', 'togo', 'tunisia', 'uganda', 'zambia', 'zimbabwe'],
    'Eropa': ['albania', 'andorra', 'austria', 'belanda', 'belarus', 'belgia', 'bosnia dan hercegovina', 'bulgaria', 'ceko', 'denmark', 'estonia', 'finlandia', 'gibraltar', 'greenland', 'hungaria', 'inggris', 'irlandia', 'islandia', 'italia', 'jerman', 'kosovo', 'kroasia', 'latvia', 'liechtenstein', 'lithuania', 'luksemburg', 'makedonia utara', 'malta', 'moldova', 'monako', 'montenegro', 'norwegia', 'polandia', 'portugal', 'prancis', 'republik rumania', 'republik serbia', 'rusia', 'san marino', 'slovenia', 'slowakia', 'spanyol', 'swedia', 'swiss', 'ukraina', 'vatikan', 'yunani'],
    'Amerika Utara': ['amerika serikat', 'antigua dan barbuda', 'bahama', 'barbados', 'belize', 'bermuda', 'costa rica', 'curacao', 'dominika', 'el salvador', 'grenada', 'guatemala', 'haiti', 'honduras', 'jamaika', 'kanada', 'kuba', 'meksiko', 'nikaragua', 'panama', 'puerto rico', 'republik dominika', 'saint kitts dan nevis', 'saint lucia', 'saint vincent dan grenadine', 'trinidad dan tobago'],
    'Amerika Selatan': ['argentina', 'bolivia', 'brazil', 'chile', 'ekuador', 'guyana', 'guiana prancis', 'kolombia', 'paraguay', 'peru', 'suriname', 'uruguay', 'venezuela'],
    'Oseania': ['australia', 'fiji', 'guam', 'kiribati', 'kepulauan marshall', 'mikronesia', 'nauru', 'palau', 'papua nugini', 'samoa', 'samoa amerika', 'selandia baru', 'tahiti', 'tonga', 'tuvalu', 'vanuatu']
  };

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final Map<String, List<Map<String, dynamic>>> groupedCountries = {
      'Asia': [], 'Afrika': [], 'Eropa': [], 'Amerika Utara': [], 'Amerika Selatan': [], 'Oseania': []
    };
    for (var country in widget.countriesList) {
      String name = (country['name'] ?? '').toString().toLowerCase();
      bool found = false;
      for (var entry in continentMap.entries) {
        if (entry.value.contains(name)) {
          groupedCountries[entry.key]!.add(country);
          found = true;
          break;
        }
      }
      if (!found) {
        groupedCountries['Asia']!.add(country);
      }
    }

    final List<String> tabLabels = ['Asia', 'Afrika', 'Eropa', 'Amerika Utara', 'Amerika Selatan', 'Oseania'];

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        padding: const EdgeInsets.all(20.0),
        child: DefaultTabController(
          length: tabLabels.length,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header title and Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.public_rounded, size: 20, color: Colors.blue),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Pilih Negara Asal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: subtextColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Field
              TextField(
                style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  hintText: 'Cari nama negara...',
                  hintStyle: TextStyle(color: subtextColor, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: subtextColor, size: 20),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 14),

              // TabBar with scrollable tabs & proper padding
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.blue,
                unselectedLabelColor: subtextColor,
                indicatorColor: Colors.blue,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                tabs: tabLabels.map((label) => Tab(text: label)).toList(),
              ),
              const SizedBox(height: 10),

              // TabBarView Content
              Expanded(
                child: TabBarView(
                  children: tabLabels.map((continent) {
                    List<Map<String, dynamic>> countriesInContinent = groupedCountries[continent] ?? [];
                    if (searchQuery.isNotEmpty) {
                      countriesInContinent = countriesInContinent.where((country) {
                        final name = (country['name'] ?? '').toString().toLowerCase();
                        return name.contains(searchQuery.toLowerCase());
                      }).toList();
                    }
                    return countriesInContinent.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada negara ditemukan',
                              style: TextStyle(color: subtextColor, fontSize: 13),
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: countriesInContinent.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
                            ),
                            itemBuilder: (context, index) {
                              final country = countriesInContinent[index];
                              final formattedName = CountryPickerDialog.capitalizeTitle(country['name'].toString());

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                leading: Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    CountryPickerDialog.countryCodeToEmoji(country['iso']),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                title: Text(
                                  formattedName,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: subtextColor.withValues(alpha: 0.6)),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Update country map with capitalized name
                                  final selectedMap = Map<String, dynamic>.from(country);
                                  selectedMap['name'] = formattedName;
                                  widget.onCountrySelected(selectedMap);
                                },
                              );
                            },
                          );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

