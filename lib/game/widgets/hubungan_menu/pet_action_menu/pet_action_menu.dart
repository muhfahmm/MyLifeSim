// lib/game/widgets/hubungan_menu/pet_action_menu/pet_action_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class PetActionMenuScreen extends StatefulWidget {
  final Character character;
  final Map<String, dynamic> pet;
  final VoidCallback onRefresh;

  const PetActionMenuScreen({
    super.key,
    required this.character,
    required this.pet,
    required this.onRefresh,
  });

  @override
  State<PetActionMenuScreen> createState() => _PetActionMenuScreenState();
}

class _PetActionMenuScreenState extends State<PetActionMenuScreen> {
  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  void _showResultDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (onConfirm != null) onConfirm();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _playWithPet() {
    final String petName = widget.pet['name'] ?? 'Peliharaan';
    final String emoji = widget.pet['emoji'] ?? '🐾';
    int currentRel = widget.pet['relationship'] as int? ?? 80;

    setState(() {
      currentRel = (currentRel + 5).clamp(0, 100);
      widget.pet['relationship'] = currentRel;
      widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
    });

    final String logMsg = '$emoji Kamu bermain bersama $petName! (+5% Hubungan, +5 Kebahagiaan)';
    widget.character.inbox.add(logMsg);
    widget.onRefresh();

    _showResultDialog(
      title: 'Bermain Bersama 🧶',
      message: logMsg,
      icon: Icons.sports_esports,
      color: Colors.orange,
    );
  }

  void _feedPet() {
    final String petName = widget.pet['name'] ?? 'Peliharaan';
    final String emoji = widget.pet['emoji'] ?? '🐾';
    int currentRel = widget.pet['relationship'] as int? ?? 80;

    setState(() {
      currentRel = (currentRel + 8).clamp(0, 100);
      widget.pet['relationship'] = currentRel;
      widget.character.happiness = (widget.character.happiness + 3).clamp(0, 100);
    });

    final String logMsg = '$emoji Kamu memberi makanan favorit $petName! (+8% Hubungan, +3 Kebahagiaan)';
    widget.character.inbox.add(logMsg);
    widget.onRefresh();

    _showResultDialog(
      title: 'Beri Makan 🍖',
      message: logMsg,
      icon: Icons.restaurant,
      color: Colors.green,
    );
  }

  void _sellPet() {
    final String petName = widget.pet['name'] ?? 'Peliharaan';
    final String breed = widget.pet['breed'] ?? '';
    final int originalCost = widget.pet['cost'] as int? ?? 100000;
    final int resaleValue = (originalCost * 0.6).round();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.sell, color: Colors.redAccent, size: 28),
            SizedBox(width: 8),
            Text('Jual Peliharaan', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin menjual/melepaskan $petName ($breed)?\n\n'
          'Kamu akan menerima ${_fmt(resaleValue)} (60% dari harga asli) dan kebahagiaanmu berkurang -10.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx); // Tutup konfirmasi

              setState(() {
                widget.character.pets.remove(widget.pet);
                widget.character.money += resaleValue;
                widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
              });

              final String logMsg = '💰 Kamu menjual $petName ($breed) seharga ${_fmt(resaleValue)}. (-10 Kebahagiaan)';
              widget.character.inbox.add(logMsg);
              widget.onRefresh();

              _showResultDialog(
                title: 'Peliharaan Terjual',
                message: logMsg,
                icon: Icons.check_circle,
                color: Colors.redAccent,
                onConfirm: () {
                  Navigator.pop(context); // Kembali dari PetActionMenuScreen
                },
              );
            },
            child: const Text('Jual'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color cardBg = isDark ? Colors.grey.shade900 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;

    final String petName = widget.pet['name'] ?? 'Peliharaan';
    final String breed = widget.pet['breed'] ?? '';
    final String type = widget.pet['type'] ?? 'Peliharaan';
    final String emoji = widget.pet['emoji'] ?? '🐾';
    final String gender = widget.pet['gender'] ?? 'Jantan';
    final int relationship = widget.pet['relationship'] as int? ?? 80;

    final bool isMale = gender.toLowerCase() == 'jantan';
    final IconData genderIcon = isMale ? Icons.male : Icons.female;
    final Color genderColor = isMale ? Colors.blue : Colors.pink;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$petName 🐾',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: cardBg,
        foregroundColor: textColor,
        elevation: 0.5,
      ),
      body: Container(
        color: bgColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- HEADER INFO PET ---
            Card(
              elevation: 0,
              color: cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.orange.withOpacity(0.15),
                          child: Text(emoji, style: const TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$petName ($breed)',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(genderIcon, color: genderColor, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    gender,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: genderColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Umur: ${widget.pet['age'] ?? 1} tahun',
                                style: TextStyle(fontSize: 13, color: subtextColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress bar Hubungan
                    Row(
                      children: [
                        Text(
                          'Hubungan: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: subtextColor,
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: relationship / 100,
                              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationship > 65
                                    ? Colors.green
                                    : relationship > 35
                                        ? Colors.amber
                                        : Colors.red,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$relationship%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: relationship > 65
                                ? Colors.green
                                : relationship > 35
                                    ? Colors.amber
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'PILIH AKSI INTERAKSI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            ),

            // --- KARTU OPSI AKSI ---
            _buildActionCard(
              context: context,
              iconWidget: const Text('🧶', style: TextStyle(fontSize: 24)),
              title: 'Bermain Bersama',
              subtitle: '+5% Hubungan, +5 Kebahagiaan',
              onTap: _playWithPet,
              isDark: isDark,
              textColor: textColor,
              subtextColor: subtextColor,
            ),
            const SizedBox(height: 8),
            _buildActionCard(
              context: context,
              iconWidget: const Text('🍖', style: TextStyle(fontSize: 24)),
              title: 'Beri Makanan Favorit',
              subtitle: '+8% Hubungan, +3 Kebahagiaan',
              onTap: _feedPet,
              isDark: isDark,
              textColor: textColor,
              subtextColor: subtextColor,
            ),
            const SizedBox(height: 8),
            _buildActionCard(
              context: context,
              iconWidget: const Icon(Icons.sell, color: Colors.redAccent, size: 24),
              title: 'Jual / Melepaskan Peliharaan',
              subtitle: 'Menerima 60% harga beli, -10 Kebahagiaan',
              onTap: _sellPet,
              isDark: isDark,
              textColor: Colors.redAccent,
              subtextColor: isDark ? Colors.red.shade200 : Colors.red.shade700,
              borderColor: Colors.red.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required Widget iconWidget,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
    required Color subtextColor,
    Color? borderColor,
  }) {
    final Color cardBg = isDark ? Colors.grey.shade900 : Colors.white;

    return Card(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor ?? (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: iconWidget,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: subtextColor),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
