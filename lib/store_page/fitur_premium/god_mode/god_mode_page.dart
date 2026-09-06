// lib/store_page/fitur_premium/god_mode/god_mode_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/skin_color_inheritance.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/database_nama_pekerjaan.dart';

class GodModePage extends StatefulWidget {
  final Character character;

  const GodModePage({
    super.key,
    required this.character,
  });

  @override
  State<GodModePage> createState() => _GodModePageState();
}

class _GodModePageState extends State<GodModePage> {
  late double _discipline;
  late double _fertility;
  late double _happiness;
  late double _health;
  late double _karma;
  late double _looks;
  late double _sexualityVal; // 0 = Heteroseksual, 1 = Biseksual, 2 = Homoseksual
  late double _smarts;
  late double _willpower;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _discipline = c.discipline.toDouble();
    _fertility = c.fertility.toDouble();
    _happiness = c.happiness.toDouble();
    _health = c.health.toDouble();
    _karma = c.karma.toDouble();
    _looks = c.appearance.toDouble();

    if (c.sexuality == 'Biseksual') {
      _sexualityVal = 1;
    } else if (c.sexuality == 'Homoseksual' || c.sexuality == 'Gay' || c.sexuality == 'Lesbian') {
      _sexualityVal = 2;
    } else {
      _sexualityVal = 0;
    }

    _smarts = c.intelligence.toDouble();
    _willpower = c.willpower.toDouble();
  }

  String _getSexualityLabel(double val) {
    if (val < 0.5) return 'Heteroseksual';
    if (val < 1.5) return 'Biseksual';
    final String gStr = widget.character.gender.toLowerCase();
    final bool isFemale = gStr.contains('perempuan') || gStr.contains('female') || gStr.contains('wanita');
    return isFemale ? 'Lesbian' : 'Gay';
  }

  void _showToast(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade700,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveChanges() {
    final c = widget.character;
    c.discipline = _discipline.toInt();
    c.fertility = _fertility.toInt();
    c.happiness = _happiness.toInt();
    c.health = _health.toInt();
    c.karma = _karma.toInt();
    c.appearance = _looks.toInt();
    c.sexuality = _getSexualityLabel(_sexualityVal);
    c.intelligence = _smarts.toInt();
    c.willpower = _willpower.toInt();

    _showToast('Atribut berhasil diperbarui!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        title: Text(
          'Atribut Kepribadian (God Mode)',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Pilih tingkat atribut karaktermu!',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SLIDERS POLOS PERSIS SEPERTI ATTRIBUTES_CUSTOMIZATION
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kesehatan',
                      value: _health,
                      emoji: '❤️',
                      onChanged: (val) => setState(() => _health = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kebahagiaan',
                      value: _happiness,
                      emoji: '😀',
                      onChanged: (val) => setState(() => _happiness = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kecerdasan',
                      value: _smarts,
                      emoji: '🧠',
                      onChanged: (val) => setState(() => _smarts = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Penampilan',
                      value: _looks,
                      emoji: '✨',
                      onChanged: (val) => setState(() => _looks = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Disiplin',
                      value: _discipline,
                      emoji: '🥋',
                      onChanged: (val) => setState(() => _discipline = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kesuburan',
                      value: _fertility,
                      emoji: '🌱',
                      onChanged: (val) => setState(() => _fertility = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Karma',
                      value: _karma,
                      emoji: '☯️',
                      onChanged: (val) => setState(() => _karma = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kemauan',
                      value: _willpower,
                      emoji: '💪',
                      onChanged: (val) => setState(() => _willpower = val),
                    ),
                    _buildSexualitySlider(context),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // KONTROL KEUANGAN (INSTAN)
                    Text(
                      'Kontrol Keuangan (Instan)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildActionChip('+ \$1.000.000', () {
                          setState(() => character.money += 1000000);
                          _showToast('Uang + \$1.000.000');
                        }),
                        _buildActionChip('+ \$100.000.000', () {
                          setState(() => character.money += 100000000);
                          _showToast('Uang + \$100.000.000');
                        }),
                        _buildActionChip('Set Uang 0', () {
                          setState(() => character.money = 0);
                          _showToast('Uang di-set ke 0');
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // PEKERJAAN & PENDIDIKAN
                    Text(
                      'Pekerjaan & Pendidikan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        final bool isEligible = character.age >= 18;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isEligible ? Colors.blue : Colors.grey,
                                side: BorderSide(color: isEligible ? Colors.blue : Colors.grey.shade400),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.school),
                              label: Text(
                                isEligible ? 'Langsung Lulus Universitas' : 'Langsung Lulus Universitas (Belum Kuliah/Belum 18thn)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: isEligible
                                  ? () => _showUnivGraduationDialog(isDark)
                                  : () => _showToast('⚠️ Karakter belum memenuhi syarat / belum lulus sekolah (minimal usia 18 tahun)!'),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: widget.character.bypassDegreeRequirement ? Colors.green : Colors.blue,
                                side: BorderSide(color: widget.character.bypassDegreeRequirement ? Colors.green : Colors.blue),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: Icon(widget.character.bypassDegreeRequirement ? Icons.verified : Icons.lock_open_rounded),
                              label: Text(
                                widget.character.bypassDegreeRequirement
                                    ? 'Bebas Syarat Gelar Sarjana (Aktif)'
                                    : 'Buka Pekerjaan Sarjana (Tanpa Lulus Univ)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.character.bypassDegreeRequirement = true;
                                });
                                _showToast('🎓 Syarat Gelar Sarjana Dibebaskan! 🎉\nKaraktermu sekarang dapat melamar semua pekerjaan profesional & sarjana tanpa perlu lulus universitas.');
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // HUBUNGAN
                    Text(
                      'Hubungan (Kontrol Penuh)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.family_restroom),
                          label: const Text('Set Hubungan Orang Tua ke 100%', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            setState(() {
                              character.fatherRelationship = 100;
                              character.motherRelationship = 100;
                              character.stepFatherRelationship = 100;
                              character.stepMotherRelationship = 100;
                            });
                            _showToast('Hubungan orang tua set ke 100%');
                          },
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.favorite),
                          label: const Text('Set Semua Hubungan ke 100%', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            setState(() {
                              character.fatherRelationship = 100;
                              character.motherRelationship = 100;
                              character.stepFatherRelationship = 100;
                              character.stepMotherRelationship = 100;

                              if (character.partner != null) character.partner!['relationship'] = '100';
                              if (character.secondPartner != null) character.secondPartner!['relationship'] = '100';
                              if (character.thirdPartner != null) character.thirdPartner!['relationship'] = '100';
                              if (character.fourthPartner != null) character.fourthPartner!['relationship'] = '100';
                              if (character.fifthPartner != null) character.fifthPartner!['relationship'] = '100';

                              for (var c in character.children) {
                                c['relationship'] = '100';
                              }
                              for (var s in character.siblings) {
                                s['relationship'] = '100';
                              }
                              for (var e in character.extendedFamily) {
                                e['relationship'] = '100';
                              }
                              for (var cw in character.coworkers) {
                                cw['relationship'] = '100';
                              }
                              for (var cm in character.classmates) {
                                cm['relationship'] = '100';
                              }
                              for (var cm in character.univClassmates) {
                                cm['relationship'] = '100';
                              }
                            });
                            _showToast('Semua hubungan set ke 100%');
                          },
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Tambahkan Pasangan Baru', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => _showAddPartnerDialog(isDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // TOMBOL SIMPAN DI BOTTOM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeSlider({
    required BuildContext context,
    required String label,
    required double value,
    required String emoji,
    required ValueChanged<double> onChanged,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$emoji $label',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: Colors.blue.shade100,
              inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              thumbColor: Colors.blue,
              overlayColor: Colors.blue.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: 0,
              max: 100,
              value: value.clamp(0.0, 100.0),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSexualitySlider(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🌈 Seksualitas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                _getSexualityLabel(_sexualityVal),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: Colors.blue.shade100,
              inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              thumbColor: Colors.blue,
              overlayColor: Colors.blue.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: 0,
              max: 2,
              divisions: 2,
              value: _sexualityVal,
              onChanged: (val) => setState(() => _sexualityVal = val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
      backgroundColor: Colors.blue.shade50,
      side: BorderSide(color: Colors.blue.shade200),
      onPressed: onTap,
    );
  }

  Widget _buildAgeChip(int age, Character character) {
    final bool isSelected = character.age == age;
    return ChoiceChip(
      label: Text('$age Thn', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
      selected: isSelected,
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey.shade200,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            character.age = age;
            if (character.currentDate != null && character.birthDate != null) {
              character.currentDate = DateTime(character.birthDate!.year + age, character.birthDate!.month, character.birthDate!.day);
            }
          });
          _showToast('Umur di-set menjadi $age tahun');
        }
      },
    );
  }

  void _showUnivGraduationDialog(bool isDark) {
    if (widget.character.age < 18) {
      _showToast('⚠️ Karakter belum memenuhi syarat / belum lulus sekolah (minimal usia 18 tahun)!');
      return;
    }
    // Mengambil seluruh data jurusan dari database UnivMajorSelectionPage.categoryMajors
    final List<String> majors = UnivMajorSelectionPage.categoryMajors.values
        .expand((element) => element)
        .toSet()
        .toList();
    String selectedMajor = majors.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: const Text('Pilih Jurusan Kuliah (Database)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: DropdownButtonFormField<String>(
              value: selectedMajor,
              isExpanded: true,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: majors.map((m) => DropdownMenuItem(value: m, child: Text(m, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (val) {
                if (val != null) setDialogState(() => selectedMajor = val);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  widget.character.univMajor = selectedMajor;
                  widget.character.justGraduatedStage = 'S1';
                  widget.character.justGraduatedMajor = selectedMajor;
                  if (!widget.character.graduatedMajors.contains(selectedMajor)) {
                    widget.character.graduatedMajors.add(selectedMajor);
                  }
                  widget.character.educationHistory['S1'] = selectedMajor;
                });
                _showToast('Berhasil lulus Universitas (Jurusan $selectedMajor)!');
              },
              child: const Text('Luluskan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showJobSelectionDialog(bool isDark) {
    if (widget.character.age < 18) {
      _showToast('⚠️ Karakter belum berusia 18 tahun (belum memenuhi syarat bekerja)!');
      return;
    }
    // Mengambil seluruh data pekerjaan dari database JobDatabase.availableJobs
    final List<Map<String, dynamic>> jobs = JobDatabase.availableJobs;
    Map<String, dynamic> selectedJob = jobs.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: const Text('Pilih Pekerjaan (Database)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedJob,
              isExpanded: true,
              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: jobs.map((j) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: j,
                  child: Text('${j['title']} (Rp ${j['salary']}/thn)', overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setDialogState(() => selectedJob = val);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  widget.character.jobName = selectedJob['title'];
                  widget.character.jobSalary = (selectedJob['salary'] as num).toInt();
                });
                _showToast('Dapat pekerjaan baru: ${selectedJob['title']}!');
              },
              child: const Text('Terapkan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPartnerDialog(bool isDark) {
    final TextEditingController nameCtrl = TextEditingController();
    String gender = widget.character.gender.toLowerCase() == 'perempuan' ? 'Laki-laki' : 'Perempuan';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: const Text('Tambah Pasangan Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Pasangan',
                  hintText: 'Misal: Clarissa / Gabriel',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jenis Kelamin:'),
                  DropdownButton<String>(
                    value: gender,
                    dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                    items: ['Laki-laki', 'Perempuan'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => gender = val);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                final String inputName = nameCtrl.text.trim();
                final String partnerName = inputName.isNotEmpty ? inputName : (gender == 'Perempuan' ? 'Ayu Soraya' : 'Davin Wijaya');
                final int partnerAge = widget.character.age > 18 ? widget.character.age : 18;

                Navigator.pop(ctx);
                setState(() {
                  final partnerMap = {
                    'name': partnerName,
                    'gender': gender,
                    'age': partnerAge.toString(),
                    'relationship': '100',
                    'relation': 'Pacar',
                    'isDeceased': 'false',
                    'skinColor': SkinColorInheritance.randomSkin(),
                  };

                  if (widget.character.partner == null) {
                    widget.character.partner = partnerMap;
                  } else {
                    widget.character.secondPartner = partnerMap;
                    widget.character.isHavingAffair = true;
                  }
                });
                _showToast('Pasangan baru ditambahkan: $partnerName!');
              },
              child: const Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
