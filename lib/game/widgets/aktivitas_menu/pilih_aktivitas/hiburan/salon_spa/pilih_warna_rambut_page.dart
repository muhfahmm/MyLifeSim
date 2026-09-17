// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/salon_spa/pilih_warna_rambut_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PilihWarnaRambutPage extends StatefulWidget {
  final Character character;
  final VoidCallback onSaved;

  const PilihWarnaRambutPage({
    super.key,
    required this.character,
    required this.onSaved,
  });

  @override
  State<PilihWarnaRambutPage> createState() => _PilihWarnaRambutPageState();
}

class _PilihWarnaRambutPageState extends State<PilihWarnaRambutPage> {
  late String _selectedHairColor;
  final int _cost = 50;

  @override
  void initState() {
    super.initState();
    final currentColor = widget.character.avatarHairColor;
    _selectedHairColor = (currentColor == null || currentColor.isEmpty) ? '2c1b18' : currentColor;
  }

  void _saveSelection() {
    if (widget.character.money < _cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup 💸',
        content: Text('Kamu membutuhkan ${CurrencySettings.format(_cost)} untuk mewarnai rambut.'),
      );
      return;
    }

    widget.character.money -= _cost;
    widget.character.avatarHairColor = _selectedHairColor;
    widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
    widget.character.inbox.add('🎨 Cat Rambut: Rambut barumu terlihat sangat trendi! (-${CurrencySettings.format(_cost)}, +10% Kebahagiaan)');
    widget.onSaved();

    Navigator.pop(context); // Kembali ke menu salon & spa / main page

    DialogHelper.show(
      context: context,
      title: 'Cat Rambut Selesai 🎨',
      content: const Text('Warna rambut barumu telah diaplikasikan dengan sempurna dan tampak begitu mengagumkan!\n\n(+10% Kebahagiaan)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFemale = widget.character.gender.toLowerCase().contains('perempuan');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mewarnai Rambut 🎨',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.purple.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        child: Column(
          children: [
            // Preview Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isFemale
                            ? [Colors.pink.shade300, Colors.purple.shade400]
                            : [Colors.blue.shade300, Colors.indigo.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Container(
                          width: 102,
                          height: 102,
                          color: isDark ? const Color(0xFF0F172A) : Colors.white,
                          child: Image.network(
                            AvatarGenerator.buildCustomAvatarUrl(
                              topType: widget.character.avatarTopType ?? (isFemale ? 'straight01' : 'shortRound'),
                              accessoriesType: widget.character.avatarAccessoriesType ?? 'blank',
                              hairColor: _selectedHairColor,
                              clotheType: widget.character.avatarClotheType ?? 'shirtCrewNeck',
                              clotheColor: widget.character.avatarClotheColor ?? '262e33',
                              skinColor: widget.character.avatarSkinColor ?? 'edb98a',
                              eyeType: AvatarGenerator.getEyeType(widget.character.happiness),
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
                            width: 102,
                            height: 102,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.character.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Preview Warna Rambut Baru',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Header Informasi Biaya
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isDark ? const Color(0xFF262626) : Colors.purple.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Mewarnai Rambut:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.purple.shade900,
                    ),
                  ),
                  Text(
                    CurrencySettings.format(_cost),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.greenAccent : Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // Daftar Pilihan Warna Rambut
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: AvatarGenerator.hairColors.entries.map((entry) {
                  final String label = entry.key;
                  final String colorHex = entry.value;
                  final bool isSelected = _selectedHairColor == colorHex;

                  // Konversi hex color string ke Color object untuk swatch
                  Color circleColor;
                  try {
                    circleColor = Color(int.parse('0xFF$colorHex'));
                  } catch (_) {
                    circleColor = Colors.brown;
                  }

                  return Card(
                    elevation: isSelected ? 2 : 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    color: isSelected
                        ? (isDark ? Colors.purple.shade900.withValues(alpha: 0.4) : Colors.purple.shade50)
                        : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.purple
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.white38 : Colors.black26,
                            width: 1.5,
                          ),
                        ),
                      ),
                      title: Text(
                        label,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.purple.shade200 : Colors.purple.shade900)
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.purple)
                          : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _selectedHairColor = colorHex;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Tombol Cat Rambut
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _saveSelection,
                    child: Text(
                      'Cat Rambut (${CurrencySettings.format(_cost)}) 🎨',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
}
