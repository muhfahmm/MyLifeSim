// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/pikiran_tubuh/pikiran_tubuh_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PikiranTubuhContent extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PikiranTubuhContent({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<PikiranTubuhContent> createState() => _PikiranTubuhContentState();
}

class _PikiranTubuhContentState extends State<PikiranTubuhContent> {
  // Model data aktivitas Pikiran & Tubuh
  final List<Map<String, dynamic>> aktivitasList = [
    {
      'name': 'Meditasi 🧘',
      'cost': 0,
      'happiness': 15,
      'intelligence': 5,
      'health': 5,
      'desc': 'Latihan pernapasan dan ketenangan batin',
    },
    {
      'name': 'Yoga 🌿',
      'cost': 15,
      'happiness': 12,
      'intelligence': 3,
      'health': 8,
      'desc': 'Gerakan tubuh untuk fleksibilitas dan ketenangan',
    },
    {
      'name': 'Tai Chi ☯️',
      'cost': 12,
      'happiness': 10,
      'intelligence': 4,
      'health': 6,
      'desc': 'Seni bela diri lembut untuk keseimbangan',
    },
    {
      'name': 'Terapi Pikiran 🧠',
      'cost': 60,
      'happiness': 20,
      'intelligence': 8,
      'health': 5,
      'desc': 'Sesi terapi kognitif dengan psikolog',
    },
    {
      'name': 'Journaling ✍️',
      'cost': 0,
      'happiness': 8,
      'intelligence': 7,
      'health': 2,
      'desc': 'Menulis jurnal untuk ekspresi diri',
    },
  ];

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  // Tampilkan modal info estimasi perubahan atribut menggunakan DialogHelper.show
  void _showInfoModal(BuildContext context, Map<String, dynamic> item) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int health = item['health'] as int;
    final int happiness = item['happiness'] as int;
    final int intelligence = item['intelligence'] as int;

    DialogHelper.show(
      context: context,
      title: item['name'] as String,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimasi Perubahan Atribut:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatRow('Kesehatan ❤️', health > 0 ? '+$health' : '-', isDark, health > 0 ? Colors.redAccent : null),
          const SizedBox(height: 8),
          _buildStatRow('Kebahagiaan 🥳', happiness > 0 ? '+$happiness' : '-', isDark, happiness > 0 ? Colors.amber.shade700 : null),
          const SizedBox(height: 8),
          _buildStatRow('Kecerdasan 🧠', intelligence > 0 ? '+$intelligence' : '-', isDark, intelligence > 0 ? Colors.blue.shade600 : null),
          const SizedBox(height: 8),
          _buildStatRow('Disiplin ⚡', '-', isDark, null),
          const SizedBox(height: 8),
          _buildStatRow('Seksualitas 💜', '-', isDark, null),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, bool isDark, Color? highlightColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: highlightColor ?? (isDark ? Colors.white54 : Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // Langsung terapkan efek setelah user menekan menu
  void _executeAktivitas(BuildContext context, Map<String, dynamic> item) {
    final int cost = item['cost'] as int;
    final int healthGain = item['health'] as int;
    final int happinessGain = item['happiness'] as int;
    final int intelligenceGain = item['intelligence'] as int;

    if (cost > 0 && widget.character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup',
        content: Text('Kamu membutuhkan ${_fmt(cost)} untuk melakukan ${item['name']}.'),
      );
      return;
    }

    setState(() {
      if (cost > 0) widget.character.money -= cost;
      if (healthGain > 0) {
        widget.character.health = (widget.character.health + healthGain).clamp(0, 100);
      }
      if (happinessGain > 0) {
        widget.character.happiness = (widget.character.happiness + happinessGain).clamp(0, 100);
      }
      if (intelligenceGain > 0) {
        widget.character.intelligence = (widget.character.intelligence + intelligenceGain).clamp(0, 100);
      }
    });

    List<String> effectDetails = [];
    if (healthGain > 0) effectDetails.add('+$healthGain% Kesehatan');
    if (happinessGain > 0) effectDetails.add('+$happinessGain% Kebahagiaan');
    if (intelligenceGain > 0) effectDetails.add('+$intelligenceGain% Kecerdasan');

    final String effectStr = effectDetails.isNotEmpty ? ' (${effectDetails.join(', ')})' : '';
    final String msg = '🧘 ${item['name']} selesai! Kamu merasa lebih tenang, bijak, dan sehat.$effectStr';

    widget.character.inbox.add(msg);
    widget.onComplete();

    DialogHelper.show(
      context: context,
      title: '${item['name']} Selesai 🎉',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(msg, style: const TextStyle(fontSize: 13)),
          if (effectDetails.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: effectDetails.map((eff) => Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.teal, size: 16),
                    const SizedBox(width: 6),
                    Text(eff, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                  ],
                )).toList(),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mantap', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color disabledCardBg = isDark ? Colors.grey.shade800.withValues(alpha: 0.5) : Colors.grey.shade100;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color disabledTextColor = isDark ? Colors.white38 : Colors.grey;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Container Saldo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.teal.shade800 : Colors.teal.shade200),
          ),
          child: Row(
            children: [
              const Text('💰', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Text(
                'Saldo Anda: ${_fmt(widget.character.money)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.greenAccent : Colors.teal.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Daftar Aktivitas Pikiran & Tubuh
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: aktivitasList.length,
          itemBuilder: (_, i) {
            final item = aktivitasList[i];
            final int cost = item['cost'] as int;
            final bool canAfford = cost == 0 || widget.character.money >= cost;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: canAfford ? cardBg : disabledCardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              child: InkWell(
                onTap: canAfford ? () => _executeAktivitas(context, item) : null,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Panah & i sejajar vertikal di tengah
                    children: [
                      // Tombol i (Info) di samping kiri nama
                      InkWell(
                        onTap: () => _showInfoModal(context, item),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Kolom Nama, Deskripsi & Biaya
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item['name'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: canAfford ? textColor : disabledTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: canAfford ? subtextColor : disabledTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cost == 0 ? 'Gratis ✅' : 'Biaya: ${_fmt(cost)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: canAfford
                                    ? (cost == 0 ? Colors.green.shade700 : (isDark ? Colors.teal.shade200 : Colors.teal.shade700))
                                    : disabledTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Panah > berada di tengah secara vertikal
                      Icon(
                        canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                        size: canAfford ? 14 : 16,
                        color: canAfford ? Colors.teal : (isDark ? Colors.white38 : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Wrapper Scaffold/Page jika dipanggil via Navigator.push
class PikiranTubuhModal extends StatelessWidget {
  final Character character;
  final VoidCallback onComplete;

  const PikiranTubuhModal({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pikiran & Tubuh 🧘', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00695C), Color(0xFF004D40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: PikiranTubuhContent(
            character: character,
            onComplete: onComplete,
          ),
        ),
      ),
    );
  }
}
