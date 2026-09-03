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
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 600,
        ),
        padding: const EdgeInsets.all(16.0),
        child: DefaultTabController(
          length: tabLabels.length,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Negara Asal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                cursorColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                decoration: InputDecoration(
                  hintText: 'Cari negara...',
                  hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                  prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.grey),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.lightBlueAccent : Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                labelColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                unselectedLabelColor: isDark ? Colors.white54 : Colors.black54,
                indicatorColor: isDark ? Colors.lightBlueAccent : Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                tabs: tabLabels.map((label) => Tab(text: label)).toList(),
              ),
              const SizedBox(height: 8),
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
                        ? Center(child: Text('Tidak ada negara ditemukan', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)))
                        : ListView.builder(
                            itemCount: countriesInContinent.length,
                            itemBuilder: (context, index) {
                              final country = countriesInContinent[index];
                              return ListTile(
                                leading: Text(
                                  CountryPickerDialog.countryCodeToEmoji(country['iso']),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                title: Text(
                                  country['name'],
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onCountrySelected(country);
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