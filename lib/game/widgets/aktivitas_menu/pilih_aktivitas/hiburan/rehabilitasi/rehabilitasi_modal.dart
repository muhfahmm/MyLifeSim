// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/rehabilitasi/rehabilitasi_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class RehabilitasiContent extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const RehabilitasiContent({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<RehabilitasiContent> createState() => _RehabilitasiContentState();
}

class _RehabilitasiContentState extends State<RehabilitasiContent> {
  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  // Bangun daftar program rehabilitasi, termasuk menu khusus kecanduan masturbasi jika pengguna memiliki akses Premium
  List<Map<String, dynamic>> _getProgramList() {
    final List<Map<String, dynamic>> list = [
      {
        'name': 'Terapi Perilaku 🧠',
        'cost': 250,
        'duration': 7,
        'happiness': 18,
        'health': 5,
        'reduceAddiction': 0,
        'desc': 'Terapi kognitif untuk mengubah pola pikir negatif',
      },
      {
        'name': 'Rehabilitasi Judi 🎲',
        'cost': 500,
        'duration': 14,
        'happiness': 15,
        'health': 10,
        'reduceAddiction': 0,
        'desc': 'Terapi mengatasi kecanduan berjudi',
      },
    ];

    // FITUR PREMIUM: Menu untuk menurunkan kecanduan masturbasi HANYA MUNCUL jika pengguna membeli Premium Akses Penuh (18+)
    if (GlobalSettings.isPremium.value) {
      list.add({
        'name': 'Terapi Kecanduan Masturbasi 💦',
        'cost': 350,
        'duration': 14,
        'happiness': 20,
        'health': 15,
        'reduceAddiction': 50, // Menurunkan kecanduan sebesar 50%
        'desc': 'Terapi khusus premium untuk menurunkan kecanduan masturbasi',
        'isPremiumOnly': true,
      });
    }

    list.addAll([
      {
        'name': 'Rehabilitasi Alkohol 🍺',
        'cost': 1200,
        'duration': 30,
        'happiness': 20,
        'health': 25,
        'reduceAddiction': 0,
        'desc': 'Program detoks dari ketergantungan alkohol',
      },
      {
        'name': 'Rehabilitasi Narkoba & Obat-obatan 💊',
        'cost': 2500,
        'duration': 90,
        'happiness': 25,
        'health': 30,
        'reduceAddiction': 100,
        'desc': 'Program pemulihan intensif dari ketergantungan obat-obatan & narkoba',
      },
    ]);

    return list;
  }

  // Tampilkan modal info estimasi perubahan atribut menggunakan DialogHelper.show
  void _showInfoModal(BuildContext context, Map<String, dynamic> item) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int health = item['health'] as int;
    final int happiness = item['happiness'] as int;
    final int reduceAddiction = item['reduceAddiction'] as int;

    DialogHelper.show(
      context: context,
      title: item['name'] as String,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimasi Perubahan Atribut & Efek:',
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
          if (reduceAddiction > 0) ...[
            const SizedBox(height: 8),
            _buildStatRow('Kecanduan Masturbasi 💦', '-$reduceAddiction%', isDark, Colors.green),
          ],
          const SizedBox(height: 8),
          _buildStatRow('Kecerdasan 🧠', '-', isDark, null),
          const SizedBox(height: 8),
          _buildStatRow('Disiplin ⚡', '-', isDark, null),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
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
  void _executeRehab(BuildContext context, Map<String, dynamic> item) {
    final int cost = item['cost'] as int;
    final int healthGain = item['health'] as int;
    final int happinessGain = item['happiness'] as int;
    final int reduceAddiction = item['reduceAddiction'] as int;

    if (widget.character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup',
        content: Text('Kamu membutuhkan ${_fmt(cost)} untuk mendaftar ${item['name']}.'),
      );
      return;
    }

    setState(() {
      widget.character.money -= cost;
      if (healthGain > 0) {
        widget.character.health = (widget.character.health + healthGain).clamp(0, 100);
      }
      if (happinessGain > 0) {
        widget.character.happiness = (widget.character.happiness + happinessGain).clamp(0, 100);
      }
      if (reduceAddiction > 0) {
        widget.character.addictionLevel = (widget.character.addictionLevel - reduceAddiction).clamp(0, 100);
      }
    });

    List<String> effectDetails = [];
    if (healthGain > 0) effectDetails.add('+$healthGain% Kesehatan');
    if (happinessGain > 0) effectDetails.add('+$happinessGain% Kebahagiaan');
    if (reduceAddiction > 0) effectDetails.add('-$reduceAddiction% Kecanduan Masturbasi (Level saat ini: ${widget.character.addictionLevel}%)');

    final String effectStr = effectDetails.isNotEmpty ? ' (${effectDetails.join(', ')})' : '';
    final String msg = '💚 ${item['name']} selesai! Kamu pulih dan siap menjalani hidup lebih sehat.$effectStr';

    widget.character.inbox.add(msg);
    widget.onComplete();

    DialogHelper.show(
      context: context,
      title: 'Program Selesai! 🎉',
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
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: effectDetails.map((eff) => Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        eff,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green),
                      ),
                    ),
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
          child: const Text('Mantap', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
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

    final programList = _getProgramList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Container Saldo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.green.shade800 : Colors.green.shade200),
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
                  color: isDark ? Colors.greenAccent : Colors.green.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Indikator Tingkat Kecanduan Karakter (jika ada kecanduan atau premium)
        if (GlobalSettings.isPremium.value)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.pink.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Level Kecanduan Masturbasi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.pinkAccent),
                      ),
                      Text(
                        'Tingkat kecanduan saat ini: ${widget.character.addictionLevel}%',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Daftar Program Rehabilitasi
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: programList.length,
          itemBuilder: (_, i) {
            final item = programList[i];
            final int cost = item['cost'] as int;
            final bool canAfford = widget.character.money >= cost;
            final bool isPremiumOnly = item['isPremiumOnly'] == true;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: canAfford
                  ? (isPremiumOnly
                      ? (isDark ? Colors.purple.shade900.withValues(alpha: 0.3) : Colors.pink.shade50)
                      : cardBg)
                  : disabledCardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isPremiumOnly
                      ? Colors.pinkAccent.withValues(alpha: 0.5)
                      : borderColor,
                ),
              ),
              child: InkWell(
                onTap: canAfford ? () => _executeRehab(context, item) : null,
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
                            color: (isPremiumOnly ? Colors.pinkAccent : Colors.green).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                            color: isPremiumOnly ? Colors.pinkAccent : Colors.green,
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: canAfford ? textColor : disabledTextColor,
                                    ),
                                  ),
                                ),
                                if (isPremiumOnly) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'PREMIUM',
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ],
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
                              'Biaya: ${_fmt(cost)} | Durasi: ${item['duration']} hari',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: canAfford
                                    ? (isDark ? Colors.green.shade200 : Colors.green.shade800)
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
                        color: canAfford ? (isPremiumOnly ? Colors.pinkAccent : Colors.green) : (isDark ? Colors.white38 : Colors.grey),
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
class RehabilitasiModal extends StatelessWidget {
  final Character character;
  final VoidCallback onComplete;

  const RehabilitasiModal({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Rehabilitasi 💚', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RehabilitasiContent(
            character: character,
            onComplete: onComplete,
          ),
        ),
      ),
    );
  }
}
