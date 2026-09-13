// lib/pilih_karakter/karakter.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylifesim/pilih_karakter/character.dart'; // Model utama
import '../game/index.dart'; // Halaman game
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/pilih_karakter/logic/family_generator.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/customization/appearance_customization.dart';
import 'package:mylifesim/pilih_karakter/customization/attributes_customization.dart';
import 'package:mylifesim/pilih_karakter/customization/special_talent_customization.dart';
import 'package:mylifesim/pilih_karakter/customization/family_customization.dart';
import 'package:mylifesim/pilih_karakter/customization/country_picker_dialog.dart';
import 'package:mylifesim/utils/country_helper.dart';
import 'package:mylifesim/pilih_karakter/settings/settings.dart'; // Tambahan Import
import 'package:mylifesim/main.dart';

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
  List<String> _citiesList = const [];
  String? _selectedCity;
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
        if (loadedList.isNotEmpty) {
          final random = Random();
          final selectedCountry = loadedList[random.nextInt(loadedList.length)];
          _currentCountryIso = selectedCountry['iso'];
          _currentCountry = selectedCountry['name'].toString().split(' ').map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1);
          }).join(' ');
        }
      });
      debugPrint('Successfully loaded ${_countriesList.length} countries.');
    } catch (e) {
      debugPrint('Error loading countries.json: $e');
    }
  }

  String _getContinentForIso(String? iso) {
    if (iso == null) return 'asia';
    const africaIsos = {'ZA', 'DZ', 'AO', 'BJ', 'BW', 'BF', 'BI', 'TD', 'DJ', 'ER', 'SZ', 'ET', 'GA', 'GM', 'GH', 'GN', 'GW', 'KE', 'LS', 'LR', 'LY', 'MG', 'MW', 'ML', 'MR', 'MU', 'EG', 'MZ', 'NA', 'NE', 'NG', 'CI', 'CF', 'CD', 'SD', 'TZ', 'UG', 'ZM', 'ZW', 'RW', 'ST', 'SN', 'SC', 'SL', 'SO', 'SS', 'TG', 'TN', 'CV', 'KM', 'CG', 'MA'};
    const asiaIsos = {'AF', 'SA', 'AM', 'AZ', 'BH', 'BD', 'BT', 'BN', 'CN', 'PH', 'GE', 'HK', 'IN', 'ID', 'IQ', 'IR', 'IL', 'JP', 'KH', 'KZ', 'KG', 'KR', 'KP', 'KW', 'LA', 'LB', 'MO', 'MY', 'MV', 'MN', 'MM', 'NP', 'OM', 'PK', 'PS', 'QA', 'TL', 'SG', 'CY', 'LK', 'SY', 'TW', 'TJ', 'TH', 'TR', 'TM', 'AE', 'UZ', 'VN', 'YE', 'JO'};
    const eropaIsos = {'AL', 'AD', 'AT', 'NL', 'BY', 'BE', 'BA', 'BG', 'CZ', 'DK', 'EE', 'FI', 'GI', 'HU', 'GB', 'IE', 'IS', 'IT', 'DE', 'FO', 'XK', 'HR', 'LV', 'LI', 'LT', 'LU', 'MK', 'MT', 'MD', 'MC', 'ME', 'NO', 'PL', 'PT', 'FR', 'RO', 'RS', 'RU', 'SM', 'SI', 'SK', 'ES', 'SE', 'CH', 'UA', 'VA', 'GR'};
    const naIsos = {'US', 'AG', 'BS', 'BB', 'BZ', 'BM', 'CR', 'CW', 'DM', 'SV', 'GL', 'GD', 'GT', 'HT', 'HN', 'JM', 'CA', 'CU', 'MX', 'NI', 'PA', 'PR', 'DO', 'KN', 'LC', 'VC', 'TT'};
    const saIsos = {'AR', 'BO', 'BR', 'CL', 'EC', 'GF', 'GY', 'CO', 'PY', 'PE', 'SR', 'UY', 'VE'};
    const oceaniaIsos = {'AU', 'FJ', 'GU', 'KI', 'MH', 'FM', 'NR', 'PW', 'PG', 'WS', 'AS', 'NZ', 'PF', 'TO', 'TV', 'VU'};

    if (africaIsos.contains(iso)) return 'afrika';
    if (asiaIsos.contains(iso)) return 'asia';
    if (eropaIsos.contains(iso)) return 'eropa';
    if (naIsos.contains(iso)) return 'na';
    if (saIsos.contains(iso)) return 'sa';
    if (oceaniaIsos.contains(iso)) return 'oceania';
    return 'asia';
  }

  Future<void> _loadNamesData({bool showLoading = false}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _hasJsonData = false;
      });
    }

    final String countryLower = _currentCountry.toLowerCase();
    final String countryFolder = CountryHelper.normalizeCountryFolder(_currentCountry);
    final String foundContinent = _getContinentForIso(_currentCountryIso);

    try {
      final String maleFirstContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryFolder/male/firstname.json');
      final String femaleFirstContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryFolder/female/firstname.json');
      final String maleLastContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryFolder/male/lastname.json');
      final String femaleLastContent = await rootBundle.loadString('json/firstname_lastname/$foundContinent/$countryFolder/female/lastname.json');

      final List<String> maleFirst = List<String>.from(jsonDecode(maleFirstContent));
      final List<String> femaleFirst = List<String>.from(jsonDecode(femaleFirstContent));
      final List<String> maleLast = List<String>.from(jsonDecode(maleLastContent));
      final List<String> femaleLast = List<String>.from(jsonDecode(femaleLastContent));

      List<String> loadedCities = [];
      try {
        final String cityContent = await rootBundle.loadString('json/nama_kota/$foundContinent/$countryFolder.json');
        loadedCities = List<String>.from(jsonDecode(cityContent));
      } catch (e) {
        debugPrint('Error loading city JSON for $countryLower: $e');
      }

      setState(() {
        _maleFirstNames = maleFirst;
        _femaleFirstNames = femaleFirst;
        _maleLastNames = maleLast;
        _femaleLastNames = femaleLast;
        _allLastNames = {...maleLast, ...femaleLast}.toList();
        _citiesList = loadedCities;
        if (loadedCities.isNotEmpty) {
          _selectedCity = loadedCities[Random().nextInt(loadedCities.length)];
        } else {
          _selectedCity = null;
        }
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
    _randomizeAttributes();
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

  void _randomizeAttributes() {
    final random = Random();
    final String gStr = widget.gender.toLowerCase();
    final bool isFemale = gStr.contains('perempuan') || gStr.contains('female') || gStr.contains('wanita');
    final sexualityOptions = ['Heteroseksual', 'Biseksual', isFemale ? 'Lesbian' : 'Gay'];
    final newHealth = 50 + random.nextInt(31);
    final newHappiness = 50 + random.nextInt(31);
    final newSmarts = 40 + random.nextInt(21); // 40 to 60
    final newDiscipline = 50 + random.nextInt(31);
    final newSexuality = sexualityOptions[random.nextInt(sexualityOptions.length)];

    if (mounted) {
      setState(() {
        _health = newHealth;
        _happiness = newHappiness;
        _smarts = newSmarts;
        _discipline = newDiscipline;
        _sexuality = newSexuality;
      });
    } else {
      _health = newHealth;
      _happiness = newHappiness;
      _smarts = newSmarts;
      _discipline = newDiscipline;
      _sexuality = newSexuality;
    }
  }

  void _randomizeAll() {
    _generateRandomName();
    _randomizeAttributes();
  }

  void _generateRandomName() {
    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';
    
    // Gunakan fallback jika list null
    final List<String> firstList = isMale ? _maleFirstNames : _femaleFirstNames;
    List<String> lastList = [];
    if (isMale) {
      lastList = _maleLastNames;
    } else {
      lastList = _femaleLastNames;
    }
    
    // Jika kosong, gunakan fallback ke _allLastNames
    if (lastList.isEmpty) {
      lastList = _allLastNames;
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

    setState(() {
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
    });
  }

  Map<String, dynamic>? _customFamilyData;

  void _createCharacterAndStartGame() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty) {
      DialogHelper.show(
        context: context,
        title: 'Peringatan',
        content: const Text('Nama depan dan belakang tidak boleh kosong!'),
      );
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
    newCharacter.birthCountry = _currentCountry;
    newCharacter.birthCity = _selectedCity;
    newCharacter.currentCity = _selectedCity;

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
      DialogHelper.show(
        context: context,
        title: 'Informasi',
        content: const Text('Daftar negara belum selesai dimuat. Silakan tunggu.'),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerDialog(
          countriesList: _countriesList,
          onCountrySelected: (country) {
            setState(() {
              _currentCountry = country['name'];
              _currentCountryIso = country['iso'];
            });
            _loadNamesData();
          },
        );
      },
    );
  }

  void _showCityPicker() {
    if (_citiesList.isEmpty) return;
    String searchQuery = '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            List<String> filteredCities = _citiesList;
            if (searchQuery.isNotEmpty) {
              filteredCities = filteredCities
                  .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();
            }
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: 400,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pilih Kota Asal ($_currentCountry)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari kota...',
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
                    Expanded(
                      child: filteredCities.isEmpty
                          ? const Center(child: Text('Tidak ada kota ditemukan', style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              itemCount: filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = filteredCities[index];
                                return ListTile(
                                  leading: const Icon(Icons.location_city, color: Colors.blue),
                                  title: Text(city),
                                  selected: city == _selectedCity,
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _selectedCity = city;
                                    });
                                  },
                                );
                              },
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
  }  @override
  Widget build(BuildContext context) {
    // --- LOGIKA VISUALISASI GENDER ---
    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';
    final String genderLabel = isMale ? 'Laki-laki' : 'Perempuan';
    final IconData genderIcon = isMale ? Icons.male_rounded : Icons.female_rounded;
    final List<Color> genderGradient = isMale
        ? const [Color(0xFF3B82F6), Color(0xFF06B6D4)]
        : const [Color(0xFFEC4899), Color(0xFFF43F5E)];
    final Color genderColor = genderGradient.first;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isMale ? Colors.blue.shade900 : Colors.pink.shade900).withValues(alpha: isDark ? 0.25 : 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.shade900.withValues(alpha: isDark ? 0.2 : 0.08),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, size: 20, color: textColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      // Step Pill Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.face_rounded, size: 14, color: genderColor),
                            const SizedBox(width: 6),
                            Text(
                              'LANGKAH 2 DARI 2',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: subtextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Actions: Theme toggle
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeNotifier,
                        builder: (context, mode, _) {
                          final dark = mode == ThemeMode.dark;
                          return IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                size: 20,
                                color: dark ? Colors.amber : Colors.indigo.shade700,
                              ),
                            ),
                            onPressed: () {
                              themeNotifier.value = dark ? ThemeMode.light : ThemeMode.dark;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Hero Avatar Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: borderColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: genderGradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: genderColor.withValues(alpha: 0.35),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 92,
                                        height: 92,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                        ),
                                        child: ClipOval(
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
                                              return const Center(
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              );
                                            },
                                            width: 92,
                                            height: 92,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Profil Karakter Baru',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Gender Chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          genderGradient.first.withValues(alpha: 0.15),
                                          genderGradient.last.withValues(alpha: 0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: genderColor.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(genderIcon, color: genderColor, size: 20),
                                        const SizedBox(width: 6),
                                        Text(
                                          genderLabel,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: genderColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Location Selectors (Country & City)
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLocationTile(
                                    label: 'Negara Asal',
                                    value: _currentCountry,
                                    prefixWidget: Text(
                                      _countryCodeToEmoji(_currentCountryIso ?? ''),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    onTap: _showCountryPicker,
                                    isDark: isDark,
                                    cardBgColor: cardBgColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    subtextColor: subtextColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildLocationTile(
                                    label: 'Kota Asal',
                                    value: _selectedCity ?? 'Pilih Kota',
                                    prefixWidget: const Icon(Icons.location_city_rounded, size: 18, color: Colors.blue),
                                    onTap: _citiesList.isNotEmpty ? _showCityPicker : null,
                                    isDark: isDark,
                                    cardBgColor: cardBgColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    subtextColor: subtextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Name Inputs & Randomize Row
                            if (_isLoading)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardBgColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                                    const SizedBox(width: 12),
                                    Text('Memuat database nama $_currentCountry...', style: TextStyle(fontSize: 13, color: subtextColor)),
                                  ],
                                ),
                              )
                            else ...[
                              // JSON Ready Badge Pill
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _hasJsonData ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _hasJsonData ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(_hasJsonData ? Icons.check_circle_rounded : Icons.warning_rounded,
                                          size: 14, color: _hasJsonData ? Colors.green : Colors.red),
                                      const SizedBox(width: 6),
                                      Text(
                                        _hasJsonData ? 'Database Nama $_currentCountry Siap' : 'Database Nama Belum Tersedia',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _hasJsonData ? Colors.green.shade600 : Colors.red.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: _firstNameController,
                                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13.5),
                                      decoration: InputDecoration(
                                        labelText: 'Nama Depan',
                                        hintText: 'Nama Depan',
                                        labelStyle: TextStyle(color: subtextColor, fontSize: 12),
                                        hintStyle: TextStyle(color: subtextColor.withValues(alpha: 0.6), fontSize: 12),
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        isDense: true,
                                        filled: true,
                                        fillColor: cardBgColor,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: genderColor, width: 1.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      controller: _lastNameController,
                                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13.5),
                                      decoration: InputDecoration(
                                        labelText: 'Nama Belakang',
                                        hintText: 'Nama Belakang',
                                        labelStyle: TextStyle(color: subtextColor, fontSize: 12),
                                        hintStyle: TextStyle(color: subtextColor.withValues(alpha: 0.6), fontSize: 12),
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        isDense: true,
                                        filled: true,
                                        fillColor: cardBgColor,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: genderColor, width: 1.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    onPressed: _hasJsonData ? _randomizeAll : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                      foregroundColor: textColor,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.shuffle_rounded, size: 16),
                                        SizedBox(width: 4),
                                        Text('Acak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Section Title
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 10),
                              child: Text(
                                'KUSTOMISASI KARAKTER',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: subtextColor,
                                ),
                              ),
                            ),

                            // Kustomisasi Penampilan Card
                            _buildCustomizationTile(
                              title: 'Kustomisasi Penampilan',
                              subtitle: 'Gaya rambut, pakaian, dan aksesori',
                              icon: Icons.palette_rounded,
                              iconGradient: const [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              isDark: isDark,
                              cardBgColor: cardBgColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              subtextColor: subtextColor,
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
                            const SizedBox(height: 10),

                            // Atribut Kepribadian Card
                            _buildCustomizationTile(
                              title: 'Atribut Kepribadian',
                              subtitle: 'Sehat: $_health% | Bahagia: $_happiness% | Pintar: $_smarts%',
                              icon: Icons.tune_rounded,
                              iconGradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                              isDark: isDark,
                              cardBgColor: cardBgColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              subtextColor: subtextColor,
                              onTap: () async {
                                final res = await Navigator.push<Map<String, dynamic>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AttributesCustomizationScreen(
                                      gender: widget.gender,
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
                            const SizedBox(height: 10),

                            // Talenta Spesial Card
                            _buildCustomizationTile(
                              title: 'Talenta Spesial',
                              subtitle: 'Bakat utama: $_specialTalent',
                              icon: Icons.star_rounded,
                              iconGradient: const [Color(0xFF10B981), Color(0xFF059669)],
                              isDark: isDark,
                              cardBgColor: cardBgColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              subtextColor: subtextColor,
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
                            const SizedBox(height: 10),

                            // Latar Belakang Keluarga Card
                            _buildCustomizationTile(
                              title: 'Latar Belakang Keluarga',
                              subtitle: _customFamilyData == null
                                  ? 'Silsilah: Acak / Default'
                                  : 'Anak ke-${_customFamilyData!['birthOrder']} (Silsilah Kustom)',
                              icon: Icons.family_restroom_rounded,
                              iconGradient: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
                              isDark: isDark,
                              cardBgColor: cardBgColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              subtextColor: subtextColor,
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
                            const SizedBox(height: 10),

                            // Same-Sex Proposals Switch Card
                            Container(
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor),
                              ),
                              child: SwitchListTile(
                                activeThumbColor: Colors.pinkAccent,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                secondary: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFA855F7), Color(0xFF7E22CE)],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.no_accounts_rounded, color: Colors.white, size: 22),
                                ),
                                title: Text(
                                  (widget.gender.toLowerCase() == 'male' || widget.gender.toLowerCase() == 'laki-laki')
                                      ? 'Nonaktifkan Ajakan Gay'
                                      : 'Nonaktifkan Ajakan Lesbian',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: _sexuality == 'Heteroseksual' ? textColor : Colors.grey,
                                  ),
                                ),
                                subtitle: Text(
                                  _sexuality == 'Heteroseksual'
                                      ? (_disableSameSexProposals ? 'Status: Dinonaktifkan' : 'Status: Aktif')
                                      : 'Terkunci (Hanya untuk Seksualitas Heteroseksual)',
                                  style: TextStyle(fontSize: 12, color: subtextColor),
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
                            const SizedBox(height: 10),

                            // Settingan Game Tile
                            _buildCustomizationTile(
                              title: 'Settingan Permainan',
                              subtitle: 'Persentase takdir, hubungan, dan peluang',
                              icon: Icons.settings_rounded,
                              iconGradient: const [Color(0xFF64748B), Color(0xFF475569)],
                              isDark: isDark,
                              cardBgColor: cardBgColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              subtextColor: subtextColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                                );
                              },
                            ),

                            const SizedBox(height: 28),

                            // LAHIRKAN Action Button
                            GestureDetector(
                              onTap: _createCharacterAndStartGame,
                              child: Container(
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.35),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                                    SizedBox(width: 10),
                                    Text(
                                      'LAHIRKAN!',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTile({
    required String label,
    required String value,
    required Widget prefixWidget,
    required VoidCallback? onTap,
    required bool isDark,
    required Color cardBgColor,
    required Color borderColor,
    required Color textColor,
    required Color subtextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: subtextColor,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                prefixWidget,
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(Icons.unfold_more_rounded, size: 18, color: subtextColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> iconGradient,
    required bool isDark,
    required Color cardBgColor,
    required Color borderColor,
    required Color textColor,
    required Color subtextColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: iconGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: iconGradient.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: subtextColor,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.chevron_right_rounded, size: 18, color: subtextColor),
        ),
      ),
    );
  }
}

