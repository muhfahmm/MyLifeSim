import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';

class ModalCariKandidatStaf extends StatefulWidget {
  final Character character;
  final String targetRole;
  final String targetDepartment;
  final Function(Map<String, String> newCandidate) onCandidateSelected;

  const ModalCariKandidatStaf({
    super.key,
    required this.character,
    required this.targetRole,
    required this.targetDepartment,
    required this.onCandidateSelected,
  });

  static void show({
    required BuildContext context,
    required Character character,
    required String targetRole,
    required String targetDepartment,
    required Function(Map<String, String> newCandidate) onCandidateSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => ModalCariKandidatStaf(
        character: character,
        targetRole: targetRole,
        targetDepartment: targetDepartment,
        onCandidateSelected: onCandidateSelected,
      ),
    );
  }

  @override
  State<ModalCariKandidatStaf> createState() => _ModalCariKandidatStafState();
}

class _ModalCariKandidatStafState extends State<ModalCariKandidatStaf> {
  final Random _random = Random();
  String _selectedGender = 'Acak'; // 'Laki-laki', 'Perempuan', 'Acak'
  int _minAge = 22;
  int _maxAge = 50;
  List<Map<String, String>> _kandidatList = [];

  static const List<String> _firstNamesMale = [
    'Budi', 'Rizky', 'Dika', 'Andi', 'Fajar', 'Hendra', 'Bayu', 'Gilang',
    'Reza', 'Agus', 'Denny', 'Eko', 'Fikri', 'Irwan', 'Joko'
  ];

  static const List<String> _firstNamesFemale = [
    'Siti', 'Dewi', 'Putri', 'Novi', 'Rina', 'Maya', 'Anisa', 'Lestari',
    'Tari', 'Dian', 'Fitri', 'Gita', 'Indah', 'Kartika', 'Laras'
  ];

  static const List<String> _lastNames = [
    'Santoso', 'Pratama', 'Wijaya', 'Kusuma', 'Saputra', 'Setiawan', 'Hidayat',
    'Nugroho', 'Utamo', 'Wibowo', 'Firmansyah', 'Syahputra', 'Ramadhan'
  ];

  static const List<String> _skinColors = [
    'ffdbb4', 'edb98a', 'f8d25c', 'fd9841', 'ae5d29', 'd08b5b'
  ];

  @override
  void initState() {
    super.initState();
    _generateKandidat();
  }

  void _generateKandidat() {
    _kandidatList.clear();
    for (int i = 0; i < 3; i++) {
      String gender;
      if (_selectedGender == 'Acak') {
        gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      } else {
        gender = _selectedGender;
      }

      final firstName = gender == 'Laki-laki'
          ? _firstNamesMale[_random.nextInt(_firstNamesMale.length)]
          : _firstNamesFemale[_random.nextInt(_firstNamesFemale.length)];
      final lastName = _lastNames[_random.nextInt(_lastNames.length)];
      final name = '$firstName $lastName';

      final age = _minAge + _random.nextInt(_maxAge - _minAge + 1);
      final rel = 45 + _random.nextInt(21); // 45-65
      final intelligence = 50 + _random.nextInt(41);
      final wealth = 2000 + _random.nextInt(8001);
      final skinColor = _skinColors[_random.nextInt(_skinColors.length)];

      _kandidatList.add({
        'name': name,
        'gender': gender,
        'age': age.toString(),
        'role': widget.targetRole,
        'department': widget.targetDepartment,
        'relationship': rel.toString(),
        'intelligence': intelligence.toString(),
        'wealth': wealth.toString(),
        'sexuality': _random.nextInt(100) < 15 ? 'Biseksual' : 'Heteroseksual',
        'skinColor': skinColor,
        'isDeceased': 'false',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.person_add, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cari Rekrut Staf Baru',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Posisi: ${widget.targetRole} (${widget.targetDepartment})',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Filter Gender (Pakai FittedBox / Flexible agar tidak overflow)
          Row(
            children: [
              Text(
                'Gender: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Acak', label: Text('Acak')),
                      ButtonSegment(value: 'Laki-laki', label: Text('Laki-laki')),
                      ButtonSegment(value: 'Perempuan', label: Text('Perempuan')),
                    ],
                    selected: {_selectedGender},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        _selectedGender = newSelection.first;
                        _generateKandidat();
                      });
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Filter Umur Range
          Row(
            children: [
              Text(
                'Rentang Umur: ${_minAge.toInt()} - ${_maxAge.toInt()} th',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _generateKandidat();
                  });
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Acak Ulang'),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minAge.toDouble(), _maxAge.toDouble()),
            min: 18,
            max: 65,
            divisions: 47,
            labels: RangeLabels('${_minAge.toInt()} th', '${_maxAge.toInt()} th'),
            onChanged: (RangeValues values) {
              setState(() {
                _minAge = values.start.toInt();
                _maxAge = values.end.toInt();
              });
            },
            onChangeEnd: (RangeValues values) {
              setState(() {
                _generateKandidat();
              });
            },
          ),

          const Divider(),
          Text(
            'Kandidat Tersedia:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // List Candidate
          ..._kandidatList.map((kandidat) {
            final name = kandidat['name']!;
            final gender = kandidat['gender']!;
            final age = int.tryParse(kandidat['age']!) ?? 25;
            final intel = kandidat['intelligence']!;
            final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
              name: name,
              gender: gender,
              age: age,
              happiness: 60,
              forcedSkinColor: kandidat['skinColor'],
            );

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: isDark ? Colors.grey.shade800 : Colors.purple.shade50.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.purple.shade100,
                ),
              ),
              child: ListTile(
                dense: true,
                leading: AvatarGenerator.avatarImage(
                  url: avatarUrl,
                  width: 40,
                  height: 40,
                  gender: gender,
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '$gender • $age th • Kecerdasan: $intel%',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    widget.onCandidateSelected(kandidat);
                    Navigator.pop(context);
                    DialogHelper.show(
                      context: context,
                      title: 'Kontrak Disetujui 📄✨',
                      content: Text(
                        'Selamat! $name telah resmi direkrut sebagai ${widget.targetRole} di divisi ${widget.targetDepartment}.',
                      ),
                      actions: [
                        Builder(
                          builder: (dialogContext) => TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('OK'),
                          ),
                        ),
                      ],
                    );
                  },
                  child: const Text('Rekrut'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
