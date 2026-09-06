import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class LoveMenuHelper {
  static void showLoveMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 16) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 16 tahun untuk memulai hubungan percintaan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoveMenuPage(character: character, onComplete: onComplete),
      ),
    );
  }
}

class LoveMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const LoveMenuPage({super.key, required this.character, required this.onComplete});

  @override
  State<LoveMenuPage> createState() => _LoveMenuPageState();
}

class _LoveMenuPageState extends State<LoveMenuPage> {
  Character get character => widget.character;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Love & Asmara 💕'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? Colors.red.shade700 : Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Temukan belahan jiwamu melalui aplikasi kencan atau cari jodoh secara acak.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.redAccent : Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone_iphone, color: Colors.pinkAccent),
                title: Text(
                  'Aplikasi Kencan (Dating App) 📱',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Cari pasangan ideal berdasarkan kriteria umur (Biaya: \$50.000)',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DatingAppConfigPage(character: character, onComplete: widget.onComplete)),
                  );
                },
              ),
            ),

            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.redAccent),
                title: Text(
                  'Cari Pacar Acak 💘',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Coba keberuntunganmu dengan mengajak kencan orang asing secara acak (Gratis)',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
                onTap: () {
                  final r = Random();
                  final List<String> boys = ['Reza', 'Gani', 'Dimas', 'Kevin', 'Iqbal', 'Arie', 'Wisnu', 'Diki', 'Indra'];
                  final List<String> girls = ['Siska', 'Rina', 'Clara', 'Mila', 'Alya', 'Nabila', 'Vania', 'Riska', 'Laras'];
                  
                  final gender = character.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
                  final name = gender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
                  
                  final age = (character.age - 2) + r.nextInt(5);
                  final looks = 30 + r.nextInt(70);
                  final smart = 30 + r.nextInt(70);
                  final moneyValue = 100000 + r.nextInt(5000000);

                  _showCandidateDialog(
                    context,
                    character,
                    {
                      'name': name,
                      'gender': gender,
                      'age': age.toString(),
                      'looks': looks.toString(),
                      'smart': smart.toString(),
                      'money': moneyValue.toString(),
                    },
                    widget.onComplete,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatingAppConfigPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const DatingAppConfigPage({super.key, required this.character, required this.onComplete});

  @override
  State<DatingAppConfigPage> createState() => _DatingAppConfigPageState();
}

class _DatingAppConfigPageState extends State<DatingAppConfigPage> {
  String selectedGender = '';
  String selectedAgeRange = '18-25';
  String selectedSexuality = 'Heteroseksual';

  @override
  void initState() {
    super.initState();
    selectedGender = widget.character.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
    _updateSexualityDefault();
  }

  void _updateSexualityDefault() {
    final bool sameGender = selectedGender.toLowerCase() == widget.character.gender.toLowerCase();
    if (sameGender) {
      selectedSexuality = widget.character.gender.toLowerCase() == 'laki-laki' ? 'Gay' : 'Lesbian';
    } else {
      selectedSexuality = 'Heteroseksual';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kriteria Kencan'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih Gender Target:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: 'Laki-laki',
                  groupValue: selectedGender,
                  activeColor: Colors.pinkAccent,
                  onChanged: (val) => setState(() {
                    selectedGender = val!;
                    _updateSexualityDefault();
                  }),
                ),
                Text('Laki-laki', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: selectedGender,
                  activeColor: Colors.pinkAccent,
                  onChanged: (val) => setState(() {
                    selectedGender = val!;
                    _updateSexualityDefault();
                  }),
                ),
                Text('Perempuan', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Rentang Usia:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedAgeRange,
              isExpanded: true,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: <String>['18-25', '26-35', '36+'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedAgeRange = val!),
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Tipe Seksualitas:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedSexuality,
              isExpanded: true,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: widget.character.gender.toLowerCase() == 'laki-laki'
                  ? const [
                      DropdownMenuItem(value: 'Heteroseksual', child: Text('Heteroseksual')),
                      DropdownMenuItem(value: 'Gay', child: Text('Gay')),
                      DropdownMenuItem(value: 'Biseksual', child: Text('Biseksual')),
                    ]
                  : const [
                      DropdownMenuItem(value: 'Heteroseksual', child: Text('Heteroseksual')),
                      DropdownMenuItem(value: 'Lesbian', child: Text('Lesbian')),
                      DropdownMenuItem(value: 'Biseksual', child: Text('Biseksual')),
                    ],
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  selectedSexuality = val;
                  final String userGen = widget.character.gender.toLowerCase();
                  if (val == 'Lesbian') {
                    selectedGender = 'Perempuan';
                  } else if (val == 'Gay') {
                    selectedGender = 'Laki-laki';
                  } else if (val == 'Heteroseksual') {
                    selectedGender = userGen == 'laki-laki' ? 'Perempuan' : 'Laki-laki';
                  }
                  // Jika Biseksual, target gender tetap sesuai pilihan Radio/sebelumnya
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _searchCandidate,
              child: const Text('Cari Pasangan (\$50.000)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
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

  static Future<Map<String, String>> _generateCandidateName(String countryName, String gender) async {
    final r = Random();
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
      final String genderFolder = gender == 'Laki-laki' ? 'male' : 'female';

      final String firstContent = await rootBundle.loadString('json/firstname_lastname/$continent/$countryLower/$genderFolder/firstname.json');
      final String lastContent = await rootBundle.loadString('json/firstname_lastname/$continent/$countryLower/$genderFolder/lastname.json');

      final List<dynamic> firstList = jsonDecode(firstContent);
      final List<dynamic> lastList = jsonDecode(lastContent);

      if (firstList.isNotEmpty && lastList.isNotEmpty) {
        final first = firstList[r.nextInt(firstList.length)].toString();
        final last = lastList[r.nextInt(lastList.length)].toString();
        return {'first': first, 'last': last, 'full': '$first $last'};
      }
    } catch (e) {
      debugPrint('Error loading name JSON for $countryName: $e');
    }

    final List<String> defaultBoys = ['Alex', 'James', 'Michael', 'Daniel', 'David', 'Chris', 'Ryan'];
    final List<String> defaultGirls = ['Emma', 'Sophia', 'Olivia', 'Ava', 'Isabella', 'Mia', 'Emily'];
    final defaultFirst = gender == 'Laki-laki' ? defaultBoys[r.nextInt(defaultBoys.length)] : defaultGirls[r.nextInt(defaultGirls.length)];
    return {'first': defaultFirst, 'last': 'Smith', 'full': '$defaultFirst Smith'};
  }

  void _searchCandidate() async {
    if (widget.character.money < 50000) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Uang Tidak Cukup'),
          content: const Text('Kamu butuh minimal \$50.000 untuk menggunakan aplikasi kencan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }
    widget.character.money -= 50000;

    final r = Random();
    final String userCountry = widget.character.location.isNotEmpty ? widget.character.location : (widget.character.birthCountry ?? 'Indonesia');
    final nameData = await _generateCandidateName(userCountry, selectedGender);
    final String candidateName = nameData['full']!;

    int age = 18;
    if (selectedAgeRange == '18-25') age = 18 + r.nextInt(8);
    else if (selectedAgeRange == '26-35') age = 26 + r.nextInt(10);
    else age = 36 + r.nextInt(15);

    // Generate Atribut Kepribadian & Seksual
    final int health = 40 + r.nextInt(61); // 40 - 100
    final int happiness = 40 + r.nextInt(61); // 40 - 100
    final int smart = 40 + r.nextInt(61); // 40 - 100
    final int discipline = 40 + r.nextInt(61); // 40 - 100

    // Seksualitas kandidat disesuaikan dengan pilihan kriteria user di Dating App
    final String sexuality = selectedSexuality;

    // Generate Pekerjaan & Gaji NPC
    final jobResult = widget.character.generateRandomNPCJobInfo(age);
    final String candidateJob = jobResult['job'] as String;
    final int candidateSalary = jobResult['salary'] as int;

    // Perhitungan tabungan/kekayaan yang realistis berdasarkan gaji dan umur (bukan nilai acak puluhan juta)
    int moneyValue = 0;
    if (candidateSalary > 0) {
      // Perkiraan tabungan = (Gaji bulanan * 12) * (umur - 18) * faktor tabungan acak (10% - 40%)
      final int workingYears = max(1, age - 18);
      final double savingsRate = 0.10 + (r.nextDouble() * 0.30); // 10% - 40%
      moneyValue = ((candidateSalary * 12 * workingYears) * savingsRate).round();
      if (moneyValue < 1000) moneyValue = 1000 + r.nextInt(5000);
    } else {
      // Jika pelajar / belum punya gaji
      moneyValue = 500 + r.nextInt(3000);
    }

    final String userLocation = widget.character.location.isNotEmpty ? widget.character.location : (widget.character.birthCountry ?? 'Indonesia');
    final String userCity = widget.character.currentCity ?? 'Kota Utama';

    // Generate Avatar NPC
    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: candidateName,
      gender: selectedGender,
      age: age,
      happiness: happiness,
    );

    if (!mounted) return;

    _showCandidateDialog(
      context,
      widget.character,
      {
        'name': candidateName,
        'gender': selectedGender,
        'age': age.toString(),
        'health': health.toString(),
        'happiness': happiness.toString(),
        'smart': smart.toString(),
        'discipline': discipline.toString(),
        'sexuality': sexuality,
        'money': moneyValue.toString(),
        'job': candidateJob,
        'salary': candidateSalary.toString(),
        'avatarUrl': avatarUrl,
        'location': userLocation,
        'currentCity': userCity,
        'city': userCity,
      },
      widget.onComplete,
    );
  }
}

// Fungsi untuk menampilkan dialog kandidat (modal)
void _showCandidateDialog(
  BuildContext context,
  Character character,
  Map<String, dynamic> candidate,
  VoidCallback onComplete,
) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final r = Random();
  final c = candidate;
  final String name = c['name']!;
  final String gender = c['gender']!;
  final int age = int.tryParse(c['age'] ?? '18') ?? 18;
  final int health = int.tryParse(c['health'] ?? '60') ?? 60;
  final int happiness = int.tryParse(c['happiness'] ?? '60') ?? 60;
  final int smart = int.tryParse(c['smart'] ?? '60') ?? 60;
  final int discipline = int.tryParse(c['discipline'] ?? '60') ?? 60;
  final String sexuality = c['sexuality'] ?? 'Heteroseksual';
  final int moneyValue = int.tryParse(c['money'] ?? '0') ?? 0;
  final String job = c['job'] ?? 'Pengangguran';
  final int salary = int.tryParse(c['salary'] ?? '0') ?? 0;
  final String avatarUrl = c['avatarUrl'] ?? '';

  Widget buildStatRow(String label, int val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: val / 100,
                color: color,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$val%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.pinkAccent),
          const SizedBox(width: 8),
          Text('Kandidat Ditemukan!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.shade50,
                border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.5), width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Icon(
                    gender == 'Perempuan' ? Icons.female : Icons.male,
                    size: 36,
                    color: gender == 'Perempuan' ? Colors.pink : Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gender: $gender', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12)),
              const Text(' • ', style: TextStyle(color: Colors.grey)),
              Text('Usia: $age thn', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12)),
            ],
          ),
          Center(
            child: Text('Seksualitas: $sexuality', style: TextStyle(color: isDark ? Colors.pinkAccent : Colors.pink, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(height: 12),
          
          buildStatRow('Kesehatan:', health, Colors.green),
          buildStatRow('Kebahagiaan:', happiness, Colors.amber),
          buildStatRow('Kecerdasan:', smart, Colors.blue),
          buildStatRow('Disiplin:', discipline, Colors.purple),

          const SizedBox(height: 8),
          Text(
            salary > 0 ? 'Pekerjaan: $job (Gaji: \$${salary.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}/bln)' : 'Pekerjaan: $job',
            style: TextStyle(color: isDark ? Colors.tealAccent : Colors.teal.shade700, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Kekayaan Tabungan: \$${moneyValue.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx); // Tutup dialog kandidat
            onComplete();
            Navigator.pop(context); // Pop halaman config
          },
          child: Text('Abaikan', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: () {
            Navigator.pop(ctx); // Tutup dialog kandidat
            final chance = (smart + happiness + 20) ~/ 3;
            final success = r.nextInt(100) < chance;

            String msg;
            if (success) {
              final Map<String, String> partnerMap = {
                'name': name,
                'gender': gender,
                'relationship': '70',
                'relation': 'Pacar',
                'age': age.toString(),
                'health': health.toString(),
                'happiness': happiness.toString(),
                'smart': smart.toString(),
                'discipline': discipline.toString(),
                'sexuality': sexuality,
                'money': moneyValue.toString(),
                'job': job,
                'salary': salary.toString(),
                'avatarUrl': avatarUrl,
                'location': c['location'] ?? character.location,
                'currentCity': c['currentCity'] ?? character.currentCity ?? 'Kota Utama',
                'city': c['currentCity'] ?? character.currentCity ?? 'Kota Utama',
              };
              character.addPartnerToFreeSlot(partnerMap);
              msg = '🎉 Berhasil! $name menerima ajakan kencanmu. Sekarang kalian resmi berpacaran!';
            } else {
              msg = '😔 Sayang sekali. $name menolak ajakan kencanmu dengan halus.';
            }

            character.inbox.add(msg);
            onComplete();

            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: isDark ? Colors.grey.shade900 : null,
                title: Row(children: [
                  Icon(success ? Icons.check_circle : Icons.cancel, color: success ? Colors.green : Colors.red),
                  const SizedBox(width: 8),
                  Text(success ? 'Sukses!' : 'Ditolak', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                ]),
                content: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          },
          child: const Text('Ajak Pacaran 💖', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}