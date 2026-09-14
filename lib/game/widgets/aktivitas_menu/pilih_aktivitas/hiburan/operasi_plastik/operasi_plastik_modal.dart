// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/operasi_plastik/operasi_plastik_modal.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class OperasiPlastikContent extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const OperasiPlastikContent({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<OperasiPlastikContent> createState() => _OperasiPlastikContentState();
}

class _OperasiPlastikContentState extends State<OperasiPlastikContent> {
  final List<Map<String, dynamic>> operasiList = [
    {
      'name': 'Lip Filler (Bibir) 💋',
      'cost': 500,
      'happiness': 10,
      'risk': 5,
      'desc': 'Filler untuk bibir lebih penuh dan seksi',
    },
    {
      'name': 'Blepharoplasty (Mata) 👁️',
      'cost': 1500,
      'happiness': 12,
      'risk': 8,
      'desc': 'Operasi kelopak mata untuk tampak lebih segar',
    },
    {
      'name': 'Rhinoplasty (Hidung) 👃',
      'cost': 3000,
      'happiness': 15,
      'risk': 10,
      'desc': 'Operasi bentuk hidung agar lebih proporsional',
    },
    {
      'name': 'Liposuction (Tubuh) 🏃',
      'cost': 4000,
      'happiness': 20,
      'risk': 20,
      'desc': 'Sedot lemak untuk tubuh lebih ideal',
    },
    {
      'name': 'Facelift (Wajah) ✨',
      'cost': 6000,
      'happiness': 25,
      'risk': 15,
      'desc': 'Operasi menyeluruh untuk tampak lebih muda',
    },
  ];

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  // Tampilkan modal info detail risiko & perubahan atribut menggunakan DialogHelper.show
  void _showInfoModal(BuildContext context, Map<String, dynamic> item) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int happiness = item['happiness'] as int;
    final int risk = item['risk'] as int;

    DialogHelper.show(
      context: context,
      title: item['name'] as String,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tingkat Risiko Komplikasi: $risk%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Detail Efek & Risiko Operasi:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          _buildStatRow('Jika Berhasil ✨', '+$happiness% Kebahagiaan', isDark, Colors.green),
          const SizedBox(height: 8),
          _buildStatRow('Jika Komplikasi 😨', '-20% Kesehatan, -15% Kebahagiaan', isDark, Colors.redAccent),
          const SizedBox(height: 12),
          Text(
            'Estimasi Perubahan Atribut:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          _buildStatRow('Kesehatan ❤️', '0% (Bisa -20% jika komplikasi)', isDark, null),
          const SizedBox(height: 8),
          _buildStatRow('Kebahagiaan 🥳', '+$happiness%', isDark, Colors.amber.shade700),
          const SizedBox(height: 8),
          _buildStatRow('Kecerdasan 🧠', '-', isDark, null),
          const SizedBox(height: 8),
          _buildStatRow('Disiplin ⚡', '-', isDark, null),
          const SizedBox(height: 8),
          _buildStatRow('Seksualitas 💜', '-', isDark, null),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
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
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: highlightColor ?? (isDark ? Colors.white54 : Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Langsung terapkan efek setelah user menekan menu
  void _executeOperasi(BuildContext context, Map<String, dynamic> item) {
    final int cost = item['cost'] as int;
    final int risk = item['risk'] as int;
    final int happinessGain = item['happiness'] as int;

    if (widget.character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup',
        content: Text('Kamu membutuhkan ${_fmt(cost)} untuk melakukan ${item['name']}.'),
      );
      return;
    }

    final Random r = Random();
    final bool komplikasi = r.nextInt(100) < risk;

    setState(() {
      widget.character.money -= cost;
      if (komplikasi) {
        widget.character.health = (widget.character.health - 20).clamp(0, 100);
        widget.character.happiness = (widget.character.happiness - 15).clamp(0, 100);
      } else {
        widget.character.happiness = (widget.character.happiness + happinessGain).clamp(0, 100);
      }
    });

    final String msg = komplikasi
        ? '😨 Komplikasi! Operasi ${item['name']} mengalami masalah. Kesehatanmu turun drastis (-20% Kesehatan, -15% Kebahagiaan).'
        : '✨ ${item['name']} berhasil! Kamu sangat puas dengan hasilnya. (+$happinessGain% Kebahagiaan)';

    widget.character.inbox.add(msg);
    widget.onComplete();

    DialogHelper.show(
      context: context,
      title: komplikasi ? 'Komplikasi! 😨' : 'Operasi Berhasil! ✨',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(msg, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (komplikasi ? Colors.red : Colors.pink).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: (komplikasi ? Colors.redAccent : Colors.pinkAccent).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  komplikasi ? Icons.error_outline : Icons.check_circle,
                  color: komplikasi ? Colors.redAccent : Colors.pinkAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    komplikasi
                        ? 'Status: Terjadi Komplikasi (-20% Kesehatan, -15% Kebahagiaan)'
                        : 'Status: Sukses (+$happinessGain% Kebahagiaan)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: komplikasi ? Colors.redAccent : Colors.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: komplikasi ? Colors.redAccent : Colors.pinkAccent)),
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
            color: isDark ? Colors.grey.shade800 : Colors.pink.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.pink.shade800 : Colors.pink.shade200),
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
                  color: isDark ? Colors.greenAccent : Colors.pink.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Warning Banner Risiko Komplikasi
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.orange.shade900.withValues(alpha: 0.3) : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.orange.shade700 : Colors.orange.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: isDark ? Colors.orangeAccent : Colors.orange.shade800),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Operasi plastik memiliki risiko komplikasi. Pertimbangkan baik-baik!',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.orangeAccent : Colors.orange.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Daftar Operasi Plastik
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: operasiList.length,
          itemBuilder: (_, i) {
            final item = operasiList[i];
            final int cost = item['cost'] as int;
            final bool canAfford = widget.character.money >= cost;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: canAfford ? cardBg : disabledCardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              child: InkWell(
                onTap: canAfford ? () => _executeOperasi(context, item) : null,
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
                            color: Colors.pink.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Kolom Nama, Deskripsi & Biaya/Risiko
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
                              'Biaya: ${_fmt(cost)} | Risiko: ${item['risk']}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: canAfford
                                    ? (isDark ? Colors.pink.shade200 : Colors.pink.shade700)
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
                        color: canAfford ? Colors.pinkAccent : (isDark ? Colors.white38 : Colors.grey),
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
class OperasiPlastikModal extends StatelessWidget {
  final Character character;
  final VoidCallback onComplete;

  const OperasiPlastikModal({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operasi Plastik 🏥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: OperasiPlastikContent(
            character: character,
            onComplete: onComplete,
          ),
        ),
      ),
    );
  }
}
