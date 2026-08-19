// lib/pilih_karakter/karakter.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitlife/pilih_karakter/character.dart'; // Model utama
import 'package:bitlife/game/index.dart'; // Halaman game
import 'package:bitlife/pilih_karakter/logic/family_generator.dart';

class KarakterScreen extends StatefulWidget {
  final String gender;
  const KarakterScreen({super.key, required this.gender});

  @override
  State<KarakterScreen> createState() => _KarakterScreenState();
}

class _KarakterScreenState extends State<KarakterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  
  List<String> _maleFirstNames = const [];
  List<String> _femaleFirstNames = const [];
  List<String> _maleLastNames = const [];
  List<String> _femaleLastNames = const [];
  List<String> _allLastNames = const [];
  bool _isLoading = true;
  bool _hasJsonData = false;
  String _currentCountry = 'Indonesia';
  String? _currentCountryIso = 'ID';
  List<Map<String, dynamic>> _countriesList = [];

  String _countryCodeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '🌍';
    int firstChar = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    int secondChar = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  Future<void> _loadCountries() async {
    try {
      debugPrint('Attempting to load countries.json...');
      final String response = await rootBundle.loadString('json/bendera_negara/countries.json');
      final Map<String, dynamic> data = jsonDecode(response);
      final List<Map<String, dynamic>> loadedList = [];
      data.forEach((key, value) {
        loadedList.add({
          'key': key,
          'name': value['name'] ?? key,
          'iso': value['iso'] ?? '',
        });
      });
      loadedList.sort((a, b) => a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));
      setState(() {
        _countriesList = loadedList;
        final defaultCountry = loadedList.firstWhere(
          (c) => c['name'].toString().toLowerCase() == 'indonesia',
          orElse: () => {'iso': 'ID', 'name': 'Indonesia'},
        );
        _currentCountryIso = defaultCountry['iso'];
        _currentCountry = defaultCountry['name'].toString().split(' ').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        }).join(' ');
      });
      debugPrint('Successfully loaded ${_countriesList.length} countries.');
    } catch (e) {
      debugPrint('Error loading countries.json: $e');
    }
  }

  Future<void> _loadNamesData() async {
    setState(() {
      _isLoading = true;
      _hasJsonData = false;
    });

    final String countryLower = _currentCountry.toLowerCase();
    const List<String> continents = ['asia', 'afrika', 'eropa', 'na', 'sa', 'oceania'];
    
    String? foundContinent;

    for (String continent in continents) {
      final String checkPath = 'json/firstname_lastname/$continent/$countryLower/male/firstname.json';
      try {
        await rootBundle.loadString(checkPath);
        foundContinent = continent;
        break;
      } catch (e) {
        // Try next continent
      }
    }

    if (foundContinent != null) {
      try {
        final String maleFirstContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryLower/male/firstname.json');
        final String femaleFirstContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryLower/female/firstname.json');
        final String maleLastContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryLower/male/lastname.json');
        final String femaleLastContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryLower/female/lastname.json');

        final List<String> maleFirst = List<String>.from(jsonDecode(maleFirstContent));
        final List<String> femaleFirst = List<String>.from(jsonDecode(femaleFirstContent));
        final List<String> maleLast = List<String>.from(jsonDecode(maleLastContent));
        final List<String> femaleLast = List<String>.from(jsonDecode(femaleLastContent));

        setState(() {
          _maleFirstNames = maleFirst;
          _femaleFirstNames = femaleFirst;
          _maleLastNames = maleLast;
          _femaleLastNames = femaleLast;
          _allLastNames = {...maleLast, ...femaleLast}.toList();
          _hasJsonData = true;
          _isLoading = false;
          _generateRandomName();
        });
        debugPrint('Successfully loaded names from $foundContinent for $countryLower');
      } catch (e) {
        debugPrint('Error decoding JSON names for $countryLower: $e');
        setState(() {
          _isLoading = false;
          _hasJsonData = false;
          _clearNames();
        });
      }
    } else {
      debugPrint('No names JSON found for country: $countryLower');
      setState(() {
        _isLoading = false;
        _hasJsonData = false;
        _clearNames();
      });
    }
  }

  void _clearNames() {
    _maleFirstNames = [];
    _femaleFirstNames = [];
    _maleLastNames = [];
    _femaleLastNames = [];
    _allLastNames = [];
    _firstNameController.clear();
    _lastNameController.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadCountries().then((_) => _loadNamesData());
  }

  void _generateRandomName() {
    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';
    
    // Gunakan fallback jika list null
    final List<String> firstList = (isMale ? _maleFirstNames : _femaleFirstNames) ?? [];
    List<String> lastList = [];
    if (isMale) {
      lastList = _maleLastNames ?? [];
    } else {
      lastList = _femaleLastNames ?? [];
    }
    
    // Jika kosong, gunakan fallback ke _allLastNames
    if (lastList.isEmpty) {
      lastList = _allLastNames ?? [];
    }

    // Fallback names hardcoded jika semuanya kosong
    List<String> fallbackMaleFirst = ['Budi', 'Andi', 'Rudi', 'Hendra', 'Agus', 'Joko', 'Slamet', 'Tono'];
    List<String> fallbackFemaleFirst = ['Sari', 'Dewi', 'Rina', 'Maya', 'Lestari', 'Yuni', 'Nina', 'Tina'];
    List<String> fallbackLast = ['Santoso', 'Wijaya', 'Putra', 'Siregar', 'Hidayat', 'Kusuma', 'Mardani', 'Ginting'];

    final random = Random();
    String firstName = '';
    String lastName = '';

    if (firstList.isNotEmpty) {
      firstName = firstList[random.nextInt(firstList.length)];
    } else {
      firstName = isMale 
          ? fallbackMaleFirst[random.nextInt(fallbackMaleFirst.length)]
          : fallbackFemaleFirst[random.nextInt(fallbackFemaleFirst.length)];
    }

    if (lastList.isNotEmpty) {
      lastName = lastList[random.nextInt(lastList.length)];
    } else {
      lastName = fallbackLast[random.nextInt(fallbackLast.length)];
    }

    setState(() {
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
    });
  }

  void _createCharacterAndStartGame() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama depan dan belakang tidak boleh kosong!')));
      return;
    }

    // --- 1. BUAT KARAKTER DASAR ---
    Character newCharacter = Character(
      name: '$firstName $lastName',
      gender: (widget.gender == 'male' || widget.gender == 'laki-laki') ? 'Laki-laki' : 'Perempuan',
      location: _currentCountry,
      age: 0,
      health: 100,
      happiness: 50,
      intelligence: 50,
      money: 0,
      appearance: 50,
      maleFirstNames: _maleFirstNames,
      femaleFirstNames: _femaleFirstNames,
      lastNames: _allLastNames,
    );

    // --- 2. GENERATE KELUARGA (PENTING!) ---
    FamilyGenerator.generateFamily(
      character: newCharacter,
      maleFirstNames: _maleFirstNames,
      femaleFirstNames: _femaleFirstNames,
      lastNames: _allLastNames,
    );

    // --- 3. MASUK KE GAME ---
    Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen(character: newCharacter)));
  }


  void _showCountryPicker() {
    if (_countriesList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daftar negara belum selesai dimuat. Silakan tunggu.')),
      );
      return;
    }

    final Map<String, List<String>> continentMap = {
      'Asia': ['afganistan', 'arab saudi', 'armenia', 'azerbaijan', 'bahrain', 'bangladesh', 'bhutan', 'brunei', 'china', 'filipina', 'georgia', 'hong kong', 'india', 'indonesia', 'irak', 'iran', 'israel', 'jepang', 'kamboja', 'kazakhstan', 'kirgizstan', 'korea selatan', 'korea utara', 'kuwait', 'laos', 'lebanon', 'makau', 'malaysia', 'maldives', 'mongolia', 'myanmar', 'nepal', 'oman', 'pakistan', 'palestina', 'qatar', 'singapura', 'siprus', 'sri lanka', 'suriah', 'tajikistan', 'thailand', 'timor leste', 'turkmenistan', 'uni emirat arab', 'uzbekistan', 'vietnam', 'yaman', 'yordania'],
      'Afrika': ['afrika selatan', 'aljazair', 'angola', 'benin', 'botswana', 'burkina faso', 'burundi', 'chad', 'djibouti', 'eritrea', 'eswatini', 'ethiopia', 'gabon', 'gambia', 'ghana', 'guinea', 'guinea bissau', 'kamerun', 'kenya', 'komoro', 'kongo', 'lesotho', 'liberia', 'libya', 'madagaskar', 'malawi', 'mali', 'maroko', 'mauritania', 'mauritius', 'mesir', 'mozambik', 'namibia', 'niger', 'nigeria', 'pantai gading', 'republik afrika tengah', 'republik demokratik kongo', 'rwanda', 'senegal', 'seychelles', 'sierra leone', 'somalia', 'sudan', 'sudan selatan', 'tanjung verde', 'tanzania', 'togo', 'tunisia', 'uganda', 'zambia', 'zimbabwe'],
      'Eropa': ['albania', 'andorra', 'austria', 'belanda', 'belarus', 'belgia', 'bosnia dan hercegovina', 'bulgaria', 'ceko', 'denmark', 'estonia', 'finlandia', 'gibraltar', 'greenland', 'hungaria', 'inggris', 'irlandia', 'islandia', 'italia', 'jerman', 'kosovo', 'kroasia', 'latvia', 'liechtenstein', 'lithuania', 'luksemburg', 'makedonia utara', 'malta', 'moldova', 'monako', 'montenegro', 'norwegia', 'polandia', 'portugal', 'prancis', 'republik rumania', 'republik serbia', 'rusia', 'san marino', 'slovenia', 'slowakia', 'spanyol', 'swedia', 'swiss', 'ukraina', 'vatikan', 'yunani'],
      'Amerika Utara': ['amerika serikat', 'antigua dan barbuda', 'bahama', 'barbados', 'belize', 'bermuda', 'costa rica', 'curacao', 'dominika', 'el salvador', 'grenada', 'guatemala', 'haiti', 'honduras', 'jamaika', 'kanada', 'kuba', 'meksiko', 'nikaragua', 'panama', 'puerto rico', 'republik dominika', 'saint kitts dan nevis', 'saint lucia', 'saint vincent dan grenadine', 'trinidad dan tobago'],
      'Amerika Selatan': ['argentina', 'bolivia', 'brazil', 'chile', 'ekuador', 'guyana', 'guiana prancis', 'kolombia', 'paraguay', 'peru', 'suriname', 'uruguay', 'venezuela'],
      'Oseania': ['australia', 'fiji', 'guam', 'kiribati', 'kepulauan marshall', 'mikronesia', 'nauru', 'palau', 'papua nugini', 'samoa', 'samoa amerika', 'selandia baru', 'tahiti', 'tonga', 'tuvalu', 'vanuatu']
    };

    final Map<String, List<Map<String, dynamic>>> groupedCountries = {
      'Asia': [], 'Afrika': [], 'Eropa': [], 'Amerika Utara': [], 'Amerika Selatan': [], 'Oseania': []
    };
    for (var country in _countriesList) {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
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
                      const Text(
                        'Pilih Negara Asal',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari negara...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onChanged: (value) {
                          setStateDialog(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.black54,
                        indicatorColor: Colors.blue,
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
                                ? const Center(child: Text('Tidak ada negara ditemukan', style: TextStyle(color: Colors.grey)))
                                : ListView.builder(
                                    itemCount: countriesInContinent.length,
                                    itemBuilder: (context, index) {
                                      final country = countriesInContinent[index];
                                      return ListTile(
                                        leading: Text(
                                          _countryCodeToEmoji(country['iso']),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        title: Text(country['name']),
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _currentCountry = country['name'];
                                            _currentCountryIso = country['iso'];
                                          });
                                          _loadNamesData();
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- LOGIKA VISUALISASI GENDER ---
    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';
    final String genderLabel = isMale ? 'Laki-laki' : 'Perempuan';
    final IconData genderIcon = isMale ? Icons.male : Icons.female;
    final Color genderColor = isMale ? Colors.blue : Colors.pink;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Siapa Namamu?'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person, size: 60, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Masukkan nama karaktermu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),

                // --- PERBAIKAN: TAMPILKAN GENDER DENGAN Ikon + CHIP WARNA ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: genderColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: genderColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(genderIcon, color: genderColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        genderLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: genderColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // --------------------------------------------------------
                
                const SizedBox(height: 16),

                const Text(
                  'Negara Asal:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _showCountryPicker,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _countryCodeToEmoji(_currentCountryIso ?? ''),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _currentCountry,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (_isLoading)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Memuat data nama...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  )
                else ...[
                  if (_hasJsonData)
                    Text('✅ Data nama $_currentCountry siap!', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold))
                  else
                    const Text('❌ json negara belum ada', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Nama Depan',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Nama Belakang',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ElevatedButton(
                          onPressed: _hasJsonData ? _generateRandomName : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Acak'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton(
                      onPressed: _createCharacterAndStartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Text('LAHIRKAN!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}