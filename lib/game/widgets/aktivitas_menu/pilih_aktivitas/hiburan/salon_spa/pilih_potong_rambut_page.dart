// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/salon_spa/pilih_potong_rambut_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PilihPotongRambutPage extends StatefulWidget {
  final Character character;
  final VoidCallback onSaved;

  const PilihPotongRambutPage({
    super.key,
    required this.character,
    required this.onSaved,
  });

  @override
  State<PilihPotongRambutPage> createState() => _PilihPotongRambutPageState();
}

class _PilihPotongRambutPageState extends State<PilihPotongRambutPage> {
  late String _selectedTopType;
  final int _cost = 15;

  @override
  void initState() {
    super.initState();
    final currentTop = widget.character.avatarTopType;
    final isFemale = widget.character.gender.toLowerCase().contains('perempuan');
    final defaultTop = isFemale ? 'straight01' : 'shortRound';
    _selectedTopType = (currentTop == null || currentTop.isEmpty) ? defaultTop : currentTop;
  }

  void _saveSelection() {
    if (widget.character.money < _cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup 💸',
        content: Text('Kamu membutuhkan ${CurrencySettings.format(_cost)} untuk potong rambut.'),
      );
      return;
    }

    widget.character.money -= _cost;
    widget.character.avatarTopType = _selectedTopType;
    widget.character.happiness = (widget.character.happiness + 2).clamp(0, 100);
    widget.character.inbox.add('✂️ Potong Rambut: Tampilan model rambut barumu makin stylish! (-${CurrencySettings.format(_cost)}, +2% Kebahagiaan)');
    widget.onSaved();

    Navigator.pop(context); // Kembali ke menu salon & spa / main page

    DialogHelper.show(
      context: context,
      title: 'Potong Rambut Selesai ✂️',
      content: const Text('Model rambut barumu sudah dipotong dan tampak sangat stylish!\n\n(+2% Kebahagiaan)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFemale = widget.character.gender.toLowerCase().contains('perempuan');
    final Map<String, String> hairOptions = isFemale ? AvatarGenerator.topsFemale : AvatarGenerator.topsMale;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Potong Rambut ✂️',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.pink.shade700,
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
                          color: Colors.pink.withValues(alpha: 0.3),
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
                              topType: _selectedTopType,
                              accessoriesType: widget.character.avatarAccessoriesType ?? 'blank',
                              hairColor: widget.character.avatarHairColor ?? '2c1b18',
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
                    'Preview Model Rambut Baru',
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
              color: isDark ? const Color(0xFF262626) : Colors.pink.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Potong Rambut:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.pink.shade900,
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

            // Daftar Pilihan Style Rambut
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: hairOptions.entries.map((entry) {
                  final String label = entry.key;
                  final String topCode = entry.value;
                  final bool isSelected = _selectedTopType == topCode;

                  return Card(
                    elevation: isSelected ? 2 : 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    color: isSelected
                        ? (isDark ? Colors.pink.shade900.withValues(alpha: 0.4) : Colors.pink.shade50)
                        : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.pink
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Icon(
                        Icons.content_cut,
                        color: isSelected ? Colors.pink : (isDark ? Colors.white54 : Colors.grey),
                      ),
                      title: Text(
                        label,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.pink.shade200 : Colors.pink.shade900)
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.pink)
                          : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _selectedTopType = topCode;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Tombol Potong Rambut
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _saveSelection,
                    child: Text(
                      'Potong Rambut (${CurrencySettings.format(_cost)}) ✂️',
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
