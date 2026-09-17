// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/salon_spa/salon_spa_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'pilih_potong_rambut_page.dart';
import 'pilih_warna_rambut_page.dart';

class SalonSpaContent extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const SalonSpaContent({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<SalonSpaContent> createState() => _SalonSpaContentState();
}

class _SalonSpaContentState extends State<SalonSpaContent> {
  // Model data layanan sesuai tabel spesifikasi
  final List<Map<String, dynamic>> layananList = [
    {
      'name': 'Potong Rambut ✂️',
      'cost': 15,
      'health': 0,
      'happiness': 2,
      'desc': 'Tampilan baru yang segar dan stylish',
    },
    {
      'name': 'Creambath & Masker 🧖',
      'cost': 25,
      'health': 5,
      'happiness': 5,
      'desc': 'Perawatan rambut intensif',
    },
    {
      'name': 'Nail Art 💅',
      'cost': 20,
      'health': 0,
      'happiness': 5,
      'desc': 'Hiasan kuku yang cantik dan kreatif',
    },
    {
      'name': 'Facial & Peeling 🌸',
      'cost': 40,
      'health': 5,
      'happiness': 10,
      'desc': 'Perawatan kulit wajah intensif',
    },
    {
      'name': 'Mewarnai Rambut 🎨',
      'cost': 50,
      'health': 0,
      'happiness': 10,
      'desc': 'Warna rambut baru sesuai selera',
    },
    {
      'name': 'Full Body Massage 💆',
      'cost': 60,
      'health': 15,
      'happiness': 15,
      'desc': 'Pijat seluruh tubuh untuk relaksasi',
    },
    {
      'name': 'Spa Package Lengkap 🌺',
      'cost': 150,
      'health': 20,
      'happiness': 20,
      'desc': 'Paket spa menyeluruh premium',
    },
  ];

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  // Tampilkan modal info efek perubahan atribut menggunakan DialogHelper.show agar ukurannya standar
  void _showInfoModal(BuildContext context, Map<String, dynamic> item) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int health = item['health'] as int;
    final int happiness = item['happiness'] as int;

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
          child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
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
  void _executeLayanan(BuildContext context, Map<String, dynamic> item) {
    final String name = item['name'] as String;

    if (name.contains('Potong Rambut')) {
      Navigator.pop(context); // Tutup dialog salon spa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PilihPotongRambutPage(
            character: widget.character,
            onSaved: () {
              widget.onComplete();
            },
          ),
        ),
      );
      return;
    }

    if (name.contains('Mewarnai Rambut')) {
      Navigator.pop(context); // Tutup dialog salon spa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PilihWarnaRambutPage(
            character: widget.character,
            onSaved: () {
              widget.onComplete();
            },
          ),
        ),
      );
      return;
    }

    final int cost = item['cost'] as int;
    final int healthGain = item['health'] as int;
    final int happinessGain = item['happiness'] as int;

    if (widget.character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup 💸',
        content: Text('Kamu membutuhkan ${_fmt(cost)} untuk melakukan ${item['name']}. Saldomu saat ini: ${_fmt(widget.character.money)}.'),
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
    });

    List<String> effectDetails = [];
    if (healthGain > 0) effectDetails.add('+$healthGain% Kesehatan');
    if (happinessGain > 0) effectDetails.add('+$happinessGain% Kebahagiaan');

    final String effectStr = effectDetails.isNotEmpty ? ' (${effectDetails.join(', ')})' : '';
    final String msg = '💅 ${item['name']} selesai! Kamu tampak lebih segar dan menawan.$effectStr';

    widget.character.inbox.add(msg);
    widget.onComplete();

    DialogHelper.show(
      context: context,
      title: 'Perawatan Selesai ✨',
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
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: effectDetails.map((eff) => Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.purpleAccent, size: 16),
                    const SizedBox(width: 6),
                    Text(eff, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purpleAccent)),
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
          child: const Text('Mantap', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
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

        // Daftar Layanan Salon & Spa
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: layananList.length,
          itemBuilder: (_, i) {
            final item = layananList[i];

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              child: InkWell(
                onTap: () => _executeLayanan(context, item),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tombol i (Info) di samping kiri nama
                      InkWell(
                        onTap: () => _showInfoModal(context, item),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Kolom Nama, Deskripsi & Harga
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
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: subtextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Harga: ${_fmt(item['cost'] as int)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.purple.shade200 : Colors.purple.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Panah > berada di tengah secara vertikal
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: isDark ? Colors.white54 : Colors.grey,
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

// Wrapper Scaffold/Page jika dipanggil melalui Navigator.push
class SalonSpaModal extends StatelessWidget {
  final Character character;
  final VoidCallback onComplete;

  const SalonSpaModal({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon & Spa 💅', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SalonSpaContent(
            character: character,
            onComplete: onComplete,
          ),
        ),
      ),
    );
  }
}
