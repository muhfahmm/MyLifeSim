// lib/pilih_karakter/karakter.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitlife/pilih_karakter/character.dart'; // Model utama
import '../game/index.dart'; // Halaman game // Halaman game
import 'package:bitlife/pilih_karakter/logic/family_generator.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/pilih_karakter/customization/appearance_customization.dart';
import 'package:bitlife/pilih_karakter/customization/attributes_customization.dart';
import 'package:bitlife/pilih_karakter/customization/special_talent_customization.dart';
import 'package:bitlife/pilih_karakter/customization/family_customization.dart';
import 'package:bitlife/main.dart';

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

  // --- STATE PARAMETER KUSTOMISASI AVATAR ---
  late String _selectedTopType;
  late String _selectedAccessoriesType;
  late String _selectedHairColor;
  late String _selectedClotheType;
  late String _selectedClotheColor;
  late String _selectedSkinColor;

  // --- STATE PARAMETER KUSTOMISASI LAINNYA ---
  int _discipline = 50;
  int _fertility = 50;
  int _happiness = 50;
  int _health = 100;
  int _karma = 50;
  int _looks = 50;
  String _sexuality = 'Heteroseksual';
  int _smarts = 50;
  int _willpower = 50;
  String _specialTalent = 'Tidak Ada';
  bool _disableSameSexProposals = false;

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
        });
        Character.globalMaleFirstNames = maleFirst;
        Character.globalFemaleFirstNames = femaleFirst;
        Character.globalLastNames = _allLastNames;
        _generateRandomName();
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

    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';
    _selectedTopType = isMale
        ? AvatarGenerator.topsMale.values.first
        : AvatarGenerator.topsFemale.values.first;
    _selectedAccessoriesType = AvatarGenerator.accessories.values.first;
    _selectedHairColor = AvatarGenerator.hairColors.values.first;
    _selectedClotheType = AvatarGenerator.clothes.values.first;
    _selectedClotheColor = AvatarGenerator.clotheColors.values.first;
    _selectedSkinColor = AvatarGenerator.skinColors.values.first;
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

    final random = Random();
    String firstName = '';
    String lastName = '';

    if (firstList.isNotEmpty) {
      firstName = firstList[random.nextInt(firstList.length)];
    } else {
      firstName = isMale 
          ? (Character.globalMaleFirstNames.isNotEmpty ? Character.globalMaleFirstNames[random.nextInt(Character.globalMaleFirstNames.length)] : '')
          : (Character.globalFemaleFirstNames.isNotEmpty ? Character.globalFemaleFirstNames[random.nextInt(Character.globalFemaleFirstNames.length)] : '');
    }

    if (lastList.isNotEmpty) {
      lastName = lastList[random.nextInt(lastList.length)];
    } else {
      lastName = Character.globalLastNames.isNotEmpty ? Character.globalLastNames[random.nextInt(Character.globalLastNames.length)] : '';
    }

    final randomAvatar = AvatarGenerator.generateRandomAvatar(widget.gender);

    final int discipline = random.nextInt(101);
    final int fertility = random.nextInt(101);
    final int happiness = random.nextInt(101);
    final int health = 50 + random.nextInt(51); // 50-100
    final int karma = random.nextInt(101);
    final int looks = random.nextInt(101);
    
    final int sexRoll = random.nextInt(100);
    String sexuality = 'Heteroseksual';
    if (sexRoll < 85) {
      sexuality = 'Heteroseksual';
    } else if (sexRoll < 92) {
      sexuality = 'Biseksual';
    } else {
      sexuality = 'Homoseksual';
    }
    
    final int smarts = random.nextInt(101);
    final int willpower = random.nextInt(101);
    
    final List<String> talentList = ['Tidak Ada', 'Akting', 'Kriminalitas', 'Pengedar', 'Modeling', 'Musik', 'Olahraga'];
    String specialTalent = 'Tidak Ada';
    if (random.nextInt(100) < 40) {
      specialTalent = talentList[1 + random.nextInt(talentList.length - 1)];
    }

    setState(() {
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _selectedTopType = randomAvatar['topType']!;
      _selectedAccessoriesType = randomAvatar['accessoriesType']!;
      _selectedHairColor = randomAvatar['hairColor']!;
      _selectedClotheType = randomAvatar['clotheType']!;
      _selectedClotheColor = randomAvatar['clotheColor']!;
      _selectedSkinColor = randomAvatar['skinColor']!;
      
      _discipline = discipline;
      _fertility = fertility;
      _happiness = happiness;
      _health = health;
      _karma = karma;
      _looks = looks;
      _sexuality = sexuality;
      _smarts = smarts;
      _willpower = willpower;
      _specialTalent = specialTalent;
    });
  }

  Map<String, dynamic>? _customFamilyData;

  void _createCharacterAndStartGame() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama depan dan belakang tidak boleh kosong!')));
      return;
    }

    Character newCharacter = Character(
      name: '$firstName $lastName',
      gender: (widget.gender == 'male' || widget.gender == 'laki-laki') ? 'Laki-laki' : 'Perempuan',
      location: _currentCountry,
      age: 0,
      health: _health,
      happiness: _happiness,
      intelligence: _smarts,
      money: 0,
      appearance: _looks,
      discipline: _discipline,
      fertility: _fertility,
      karma: _karma,
      sexuality: _sexuality,
      willpower: _willpower,
      specialTalent: _specialTalent,
      maleFirstNames: _maleFirstNames,
      femaleFirstNames: _femaleFirstNames,
      lastNames: _allLastNames,
      avatarTopType: _selectedTopType,
      avatarAccessoriesType: _selectedAccessoriesType,
      avatarHairColor: _selectedHairColor,
      avatarClotheType: _selectedClotheType,
      avatarClotheColor: _selectedClotheColor,
      avatarSkinColor: _selectedSkinColor,
      avatarFacialHairType: 'blank',
      disableSameSexProposals: _disableSameSexProposals,
    );

    if (_customFamilyData != null) {
      // Generate silsilah keluarga menggunakan input kustomisasi
      FamilyGenerator.generateCustomFamily(
        character: newCharacter,
        maleFirstNames: _maleFirstNames,
        femaleFirstNames: _femaleFirstNames,
        lastNames: _allLastNames,
        fatherMinAge: _customFamilyData!['fatherMinAge'],
        fatherMaxAge: _customFamilyData!['fatherMaxAge'],
        motherMinAge: _customFamilyData!['motherMinAge'],
        motherMaxAge: _customFamilyData!['motherMaxAge'],
        birthOrder: _customFamilyData!['birthOrder'],
        kakakLakiCount: _customFamilyData!['kakakLakiCount'],
        kakakPerempuanCount: _customFamilyData!['kakakPerempuanCount'],
        adikLakiCount: _customFamilyData!['adikLakiCount'],
        adikPerempuanCount: _customFamilyData!['adikPerempuanCount'],
      );
    } else {
      // Generate silsilah keluarga default (acak)
      FamilyGenerator.generateFamily(
        character: newCharacter,
        maleFirstNames: _maleFirstNames,
        femaleFirstNames: _femaleFirstNames,
        lastNames: _allLastNames,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(character: newCharacter),
      ),
    );
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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Siapa Namamu?'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: isDark ? Colors.yellow.shade700 : Colors.grey.shade700),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
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
                CircleAvatar(
                  radius: 40,
                  backgroundColor: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                  child: Image.network(
                    AvatarGenerator.buildCustomAvatarUrl(
                      topType: _selectedTopType,
                      accessoriesType: _selectedAccessoriesType,
                      hairColor: _selectedHairColor,
                      clotheType: _selectedClotheType,
                      clotheColor: _selectedClotheColor,
                      skinColor: _selectedSkinColor,
                      eyeType: 'default',
                      eyebrowType: 'default',
                      mouthType: 'default',
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Masukkan nama karaktermu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
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

                Text(
                  'Negara Asal:',
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _showCountryPicker,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
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
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600, 
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: isDark ? Colors.white70 : Colors.black54),
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
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'Nama Depan',
                            labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.black54),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'Nama Belakang',
                            labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.black54),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ElevatedButton(
                          onPressed: _hasJsonData ? _generateRandomName : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                            foregroundColor: isDark ? Colors.white70 : Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Acak'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // --- TIGA TOMBOL KUSTOMISASI BARU (Penampilan, Atribut, Talenta) ---
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.palette, color: Colors.blue),
                      title: Text('🎨 Kustomisasi Penampilan', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: () async {
                        final res = await Navigator.push<Map<String, String>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppearanceCustomizationScreen(
                              gender: widget.gender,
                              initialAppearance: {
                                'topType': _selectedTopType,
                                'accessoriesType': _selectedAccessoriesType,
                                'hairColor': _selectedHairColor,
                                'clotheType': _selectedClotheType,
                                'clotheColor': _selectedClotheColor,
                                'skinColor': _selectedSkinColor,
                              },
                            ),
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            _selectedTopType = res['topType']!;
                            _selectedAccessoriesType = res['accessoriesType']!;
                            _selectedHairColor = res['hairColor']!;
                            _selectedClotheType = res['clotheType']!;
                            _selectedClotheColor = res['clotheColor']!;
                            _selectedSkinColor = res['skinColor']!;
                          });
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.flash_on, color: Colors.amber),
                      title: Text('⚡ Atribut Kepribadian', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text(
                        'Penampilan: $_looks% | Kecerdasan: $_smarts% | Kesehatan: $_health%',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: () async {
                        final res = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttributesCustomizationScreen(
                              initialAttributes: {
                                'discipline': _discipline,
                                'fertility': _fertility,
                                'happiness': _happiness,
                                'health': _health,
                                'karma': _karma,
                                'looks': _looks,
                                'sexuality': _sexuality,
                                'smarts': _smarts,
                                'willpower': _willpower,
                              },
                            ),
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            _discipline = res['discipline'] as int;
                            _fertility = res['fertility'] as int;
                            _happiness = res['happiness'] as int;
                            _health = res['health'] as int;
                            _karma = res['karma'] as int;
                            _looks = res['looks'] as int;
                            _sexuality = res['sexuality'] as String;
                            _smarts = res['smarts'] as int;
                            _willpower = res['willpower'] as int;
                            if (_sexuality != 'Heteroseksual') {
                              _disableSameSexProposals = false;
                            }
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.orange),
                      title: Text('⭐ Talenta Spesial', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text(
                        'Talenta: $_specialTalent',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: () async {
                        final res = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecialTalentCustomizationScreen(
                              initialTalent: _specialTalent,
                            ),
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            _specialTalent = res;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.family_restroom, color: Colors.blue),
                      title: Text('👨‍👩‍👧‍👦 Latar Belakang Keluarga', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text(
                        _customFamilyData == null 
                            ? 'Latar Belakang: Acak/Default'
                            : 'Anak ke-${_customFamilyData!['birthOrder']} (Kustom)',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FamilyCustomizationScreen(
                              maleFirstNames: _maleFirstNames,
                              femaleFirstNames: _femaleFirstNames,
                              lastNames: _allLastNames,
                              gender: widget.gender,
                              onConfirm: (data) {
                                setState(() {
                                  _customFamilyData = data;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: SwitchListTile(
                      activeThumbColor: Colors.redAccent,
                      secondary: const Icon(
                        Icons.no_accounts,
                        color: Colors.purple,
                      ),
                      title: Text(
                        (widget.gender.toLowerCase() == 'male' || widget.gender.toLowerCase() == 'laki-laki')
                            ? '🚫 Nonaktifkan Ajakan Gay'
                            : '🚫 Nonaktifkan Ajakan Lesbian',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _sexuality == 'Heteroseksual'
                              ? (isDark ? Colors.white : Colors.black87)
                              : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        _sexuality == 'Heteroseksual'
                            ? (_disableSameSexProposals ? 'Ajakan Dinonaktifkan' : 'Ajakan Aktif')
                            : 'Terkunci (Hanya untuk Seksualitas Heteroseksual)',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                      ),
                      value: _disableSameSexProposals,
                      onChanged: _sexuality == 'Heteroseksual'
                          ? (bool value) {
                              setState(() {
                                _disableSameSexProposals = value;
                              });
                            }
                          : null,
                    ),
                  ),

                  const SizedBox(height: 24),
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

  Widget _buildCustomizerDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
    bool isColorDropdown = false,
  }) {
    final finalValue = items.values.contains(value) ? value : items.values.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: finalValue,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: items.entries.map((entry) {
              Widget leading = const SizedBox.shrink();
              if (isColorDropdown) {
                Color swatchColor = Colors.transparent;
                try {
                  swatchColor = Color(int.parse('FF${entry.value}', radix: 16));
                } catch (_) {}
                
                leading = Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: swatchColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                );
              }

              return DropdownMenuItem<String>(
                value: entry.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leading,
                    Text(entry.key),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}