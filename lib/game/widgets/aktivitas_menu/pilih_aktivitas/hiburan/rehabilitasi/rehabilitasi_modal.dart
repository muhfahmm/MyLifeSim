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

  String _getMasturbationNarrative(int level) {
    if (level == 0) return '0% • Rendah (Aman) - Pikiran jernih dan bebas kecanduan.';
    if (level < 34) return '$level% • Ringan (Terkendali) - Dorongan masih dalam batas wajar.';
    if (level < 67) return '$level% • Sedang (Waspada) - Dorongan sering mengganggu fokus aktivitas harian.';
    return '$level% • Tinggi (Bahaya Kecanduan!) - Sangat kecanduan, berisiko mengganggu fisik & mental.';
  }

  String _getDrugNarrative(int level) {
    if (level == 0) return '0% • Rendah (Aman) - Tubuh bersih dari zat penenang & obat terlarang.';
    if (level < 34) return '$level% • Ringan (Gejala Awal) - Mulai ketagihan namun masih dapat dikontrol.';
    if (level < 67) return '$level% • Sedang (Ketergantungan) - Butuh dosis rutin untuk merasa tenang & nyaman.';
    return '$level% • Tinggi (Bahaya Overdosis!) - Ketergantungan berat dan berisiko fatal bagi kesehatan.';
  }

  String _getGamblingNarrative(int level) {
    if (level == 0) return '0% • Rendah (Aman) - Bebas dari dorongan taruhan judi.';
    if (level < 34) return '$level% • Ringan (Iseng) - Hanya mencoba taruhan judi sesekali untuk hiburan.';
    if (level < 67) return '$level% • Sedang (Ketergantungan) - Sering bayang-bayang dorongan memasang taruhan lagi.';
    return '$level% • Tinggi (Kompulsif / Bahaya!) - Kecanduan berat taruhan, berisiko menguras aset keuangan.';
  }

  // Bangun daftar program rehabilitasi
  List<Map<String, dynamic>> _getProgramList() {
    final List<Map<String, dynamic>> list = [
      {
        'name': 'Terapi Perilaku 🧠',
        'cost': 250,
        'happiness': 18,
        'health': 5,
        'reduceAddiction': 0,
        'targetType': 'none',
        'desc': 'Terapi kognitif untuk mengubah pola pikir negatif',
      },
      {
        'name': 'Rehabilitasi Judi 🎲',
        'cost': 500,
        'happiness': 15,
        'health': 10,
        'reduceAddiction': 100, // Menurunkan kecanduan judi 100%
        'targetType': 'judi',
        'desc': 'Terapi pemulihan mengatasi kecanduan berjudi',
      },
    ];

    // HANYA MUNCUL jika pengguna telah membeli Premium Akses Penuh (18+) atau memiliki kecanduan > 0
    if (GlobalSettings.isPremium.value || widget.character.addictionLevel > 0) {
      list.add({
        'name': 'Terapi Kecanduan Masturbasi 💦',
        'cost': 350,
        'happiness': 20,
        'health': 15,
        'reduceAddiction': 50, // Menurunkan kecanduan masturbasi sebesar 50%
        'targetType': 'masturbasi',
        'desc': 'Terapi pemulihan untuk menurunkan kecanduan masturbasi',
      });
    }

    // HANYA MUNCUL jika pengguna telah membeli Akses Obat-obatan (18+) atau memiliki kecanduan > 0
    if (GlobalSettings.isObatObatanUnlocked.value || widget.character.drugAddictionLevel > 0) {
      list.add({
        'name': 'Rehabilitasi Narkoba & Obat-obatan 💊',
        'cost': 2500,
        'happiness': 25,
        'health': 30,
        'reduceAddiction': 100, // Menurunkan kecanduan obat/narkoba 100%
        'targetType': 'narkoba',
        'desc': 'Program pemulihan intensif dari ketergantungan obat-obatan & narkoba',
      });
    }

    return list;
  }

  // Tampilkan modal info estimasi perubahan atribut menggunakan DialogHelper.show
  void _showInfoModal(BuildContext context, Map<String, dynamic> item) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int health = item['health'] as int;
    final int happiness = item['happiness'] as int;
    final int reduceAddiction = item['reduceAddiction'] as int;
    final String targetType = (item['targetType'] as String?) ?? 'none';

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
          if (reduceAddiction > 0 && targetType == 'masturbasi') ...[
            const SizedBox(height: 8),
            _buildStatRow('Kecanduan Masturbasi 💦', '-$reduceAddiction%', isDark, Colors.green),
          ],
          if (reduceAddiction > 0 && targetType == 'narkoba') ...[
            const SizedBox(height: 8),
            _buildStatRow('Kecanduan Obat/Narkoba 💊', '-$reduceAddiction%', isDark, Colors.purpleAccent),
          ],
          if (reduceAddiction > 0 && targetType == 'judi') ...[
            const SizedBox(height: 8),
            _buildStatRow('Kecanduan Judi 🎲', '-$reduceAddiction%', isDark, Colors.amber.shade800),
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
    final String targetType = (item['targetType'] as String?) ?? 'none';

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
        if (targetType == 'masturbasi') {
          widget.character.addictionLevel = (widget.character.addictionLevel - reduceAddiction).clamp(0, 100);
        } else if (targetType == 'narkoba') {
          widget.character.drugAddictionLevel = (widget.character.drugAddictionLevel - reduceAddiction).clamp(0, 100);
        } else if (targetType == 'judi') {
          widget.character.gamblingAddictionLevel = (widget.character.gamblingAddictionLevel - reduceAddiction).clamp(0, 100);
        }
      }
    });

    List<String> effectDetails = [];
    if (healthGain > 0) effectDetails.add('+$healthGain% Kesehatan');
    if (happinessGain > 0) effectDetails.add('+$happinessGain% Kebahagiaan');
    if (reduceAddiction > 0) {
      if (targetType == 'masturbasi') {
        effectDetails.add('-$reduceAddiction% Kecanduan Masturbasi (Level saat ini: ${widget.character.addictionLevel}%)');
      } else if (targetType == 'narkoba') {
        effectDetails.add('-$reduceAddiction% Kecanduan Narkoba & Obat (Level saat ini: ${widget.character.drugAddictionLevel}%)');
      } else if (targetType == 'judi') {
        effectDetails.add('-$reduceAddiction% Kecanduan Judi (Level saat ini: ${widget.character.gamblingAddictionLevel}%)');
      }
    }

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

        // Indikator Tingkat Kecanduan Masturbasi (Tampil jika Premium aktif atau level kecanduan > 0)
        if (GlobalSettings.isPremium.value || widget.character.addictionLevel > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
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
                      const SizedBox(height: 2),
                      Text(
                        _getMasturbationNarrative(widget.character.addictionLevel),
                        style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Indikator Tingkat Kecanduan Narkoba & Obat-obatan (Tampil jika Akses Obat Dibuka atau level kecanduan > 0)
        if (GlobalSettings.isObatObatanUnlocked.value || widget.character.drugAddictionLevel > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.medication_rounded, color: Colors.purple, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Level Kecanduan Narkoba & Obat-obatan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.purple),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getDrugNarrative(widget.character.drugAddictionLevel),
                        style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Indikator Tingkat Kecanduan Judi
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(Icons.casino, color: Colors.amber.shade800, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level Kecanduan Judi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getGamblingNarrative(widget.character.gamblingAddictionLevel),
                      style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87),
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
                              'Biaya: ${_fmt(cost)}',
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
