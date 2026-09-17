// lib/store_page/fitur_premium/skip_usia/skip_usia_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'skip_usia_logic.dart';

class SkipUsiaPage extends StatefulWidget {
  final Character? character;
  final VoidCallback? onAgeChanged;

  const SkipUsiaPage({
    super.key,
    this.character,
    this.onAgeChanged,
  });

  @override
  State<SkipUsiaPage> createState() => _SkipUsiaPageState();
}

class _SkipUsiaPageState extends State<SkipUsiaPage> {
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    final int currentAge = widget.character?.age ?? 0;
    _selectedAge = (currentAge < 18) ? 18 : (currentAge + 1).clamp(currentAge + 1, 100);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;

    if (character == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fast Forward Usia'),
          backgroundColor: Colors.purple.shade800,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Karakter tidak ditemukan. Silakan buat karakter terlebih dahulu.'),
        ),
      );
    }

    final int currentAge = character.age;
    final int minAllowedAge = (currentAge + 1).clamp(1, 100);
    const int maxAllowedAge = 100;

    // Pastikan _selectedAge selalu dalam rentang valid [minAllowedAge, maxAllowedAge]
    if (_selectedAge < minAllowedAge) {
      _selectedAge = minAllowedAge;
    } else if (_selectedAge > maxAllowedAge) {
      _selectedAge = maxAllowedAge;
    }

    final bool canSkip = currentAge < maxAllowedAge && _selectedAge > currentAge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Forward Usia ⏩', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade800, Colors.deepPurple.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Info Status Usia Saat Ini
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.purple.shade900, Colors.indigo.shade900]
                      : [Colors.purple.shade50, Colors.deepPurple.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.purple.shade100,
                    child: ClipOval(
                      child: Image(
                        image: AvatarImageCache.getImageProvider(
                          AvatarAgeRules.getAgeBasedAvatarUrl(character, happiness: character.happiness),
                        ),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Usia Saat Ini: $currentAge Tahun',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.purpleAccent : Colors.purple.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Judul Pilih Usia Tujuan
            Text(
              'Pilih Usia Tujuan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Presets Usia Cepat
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (currentAge < 18) _buildPresetChip(18, '18 Thn (Dewasa)'),
                if (currentAge < 21) _buildPresetChip(21, '21 Thn (Matang)'),
                if (currentAge < 30) _buildPresetChip(30, '30 Thn (Karir Puncak)'),
                if (currentAge < 50) _buildPresetChip(50, '50 Thn (Pensiun)'),
              ],
            ),
            const SizedBox(height: 24),

            // Slider Usia Kustom
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Usia Target Kustom:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple.shade300),
                          ),
                          child: Text(
                            '$_selectedAge Tahun',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (currentAge < maxAllowedAge) ...[
                      Slider(
                        value: _selectedAge.toDouble().clamp(minAllowedAge.toDouble(), maxAllowedAge.toDouble()),
                        min: minAllowedAge.toDouble(),
                        max: maxAllowedAge.toDouble(),
                        divisions: (maxAllowedAge - minAllowedAge) > 0 ? (maxAllowedAge - minAllowedAge) : 1,
                        activeColor: Colors.purple,
                        inactiveColor: Colors.purple.shade100,
                        label: '$_selectedAge Tahun',
                        onChanged: (val) {
                          setState(() {
                            _selectedAge = val.round();
                          });
                        },
                      ),
                      Text(
                        'Akan melompati +${_selectedAge - currentAge} tahun secara instan.',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ] else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Karakter sudah mencapai batas usia maksimum (100 tahun).',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Eksekusi
            ElevatedButton.icon(
              onPressed: canSkip
                  ? () {
                      _confirmSkipUsia(context, character);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              icon: const Icon(Icons.fast_forward_rounded, size: 24),
              label: Text(
                canSkip ? 'LOMPAT KE USIA $_selectedAge TAHUN ⏩' : 'USIA MAKSIMAL TERCAPAI',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(int age, String label) {
    final bool isSelected = _selectedAge == age;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.purple,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.purple.shade800,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedAge = age;
          });
        }
      },
    );
  }

  void _confirmSkipUsia(BuildContext context, Character character) {
    final int currentAge = character.age;
    final int targetAge = _selectedAge;
    final int yearsSkipped = targetAge - currentAge;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    DialogHelper.show(
      context: context,
      title: 'Konfirmasi Lompat Usia ⏩',
      isNotification: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah kamu yakin ingin melompati usia karakter dari $currentAge tahun menjadi $targetAge tahun (+$yearsSkipped tahun)?',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.purple.shade900.withValues(alpha: 0.3) : Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.purple.shade700 : Colors.purple.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: isDark ? Colors.purple.shade300 : Colors.purple.shade700,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Seluruh keluarga, pasangan, dan teman akan ikut bertambah usia secara otomatis.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.purple.shade200 : Colors.purple.shade900,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.grey.shade800,
                  side: BorderSide(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Tutup konfirmasi dialog
                  
                  final res = SkipUsiaLogic.performSkipUsia(character, targetAge);
                  final bool success = res['success'] == true;
                  final String message = (res['message'] ?? '').toString();
                  final List<String> skippedEvents = List<String>.from(res['skippedEvents'] ?? []);
                  final bool isDeceased = !character.isAlive;

                  if (success) {
                    final int newAge = character.age;
                    setState(() {
                      _selectedAge = (newAge + 1).clamp(newAge + 1, 100);
                    });
                    widget.onAgeChanged?.call();
                  }

                  DialogHelper.show(
                    context: context,
                    title: isDeceased ? 'Karakter Meninggal 💀' : (success ? 'Lompat Usia Berhasil ⏩' : 'Gagal'),
                    content: Text(message),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog hasil
                          if (skippedEvents.isNotEmpty && context.mounted) {
                            _showSkippedEventsDialog(context, skippedEvents, onDismiss: () {
                              if (isDeceased && context.mounted) {
                                Navigator.pop(context); // Tutup SkipUsiaPage agar kembali ke layar utama
                              }
                            });
                          } else if (isDeceased && context.mounted) {
                            Navigator.pop(context); // Tutup SkipUsiaPage agar kembali ke layar utama
                          }
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
                icon: const Icon(Icons.fast_forward_rounded, size: 18),
                label: const Text(
                  'Lompat Usia',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSkippedEventsDialog(BuildContext context, List<String> events, {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            titlePadding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kejadian Penting Selama Lompat Usia ⏩',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: events.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(e, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDismiss?.call();
                },
                child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }
}
