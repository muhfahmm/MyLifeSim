// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/freelance/freelance_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'freelance_database.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class FreelanceMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const FreelanceMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<FreelanceMenuPage> createState() => _FreelanceMenuPageState();
}

class _FreelanceMenuPageState extends State<FreelanceMenuPage> {
  void _takeFreelanceGig(Map<String, dynamic> gig) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int minIntel = gig['minIntel'] ?? 0;
    if (widget.character.intelligence < minIntel) {
      DialogHelper.show(
        context: context,
        title: 'Kecerdasan Tidak Mencukupi 🧠',
        isNotification: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 2),
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.amber, size: 36),
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Proyek '),
                  TextSpan(text: '"${gig['title']}"', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  const TextSpan(text: ' membutuhkan tingkat kecerdasan minimal '),
                  TextSpan(text: '$minIntel%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                  const TextSpan(text: '.\n\nKecerdasanmu saat ini: '),
                  TextSpan(text: '${widget.character.intelligence}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
      return;
    }

    final int payout = (gig['payout'] as num).toInt();
    setState(() {
      widget.character.money += payout;
      widget.character.happiness = (widget.character.happiness + 2).clamp(0, 100);
      widget.character.inbox.add('💻 Freelance: Kamu menyelesaikan proyek "${gig['title']}" dan mendapatkan bayaran sebesar ${CurrencySettings.format(payout)}!');
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Proyek Selesai! 🎉',
      isNotification: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (gig['color'] as Color).withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: (gig['color'] as Color).withValues(alpha: 0.4), width: 2),
            ),
            child: Icon(gig['icon'] as IconData, color: gig['color'] as Color, size: 36),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Selamat! Kamu telah menyelesaikan proyek '),
                TextSpan(text: '"${gig['title']}"', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                const TextSpan(text: ' dengan sukses dan mengantongi uang tunai sebesar '),
                TextSpan(text: CurrencySettings.format(payout), style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.greenAccent : Colors.green.shade700)),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Terima Uang', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final gigs = FreelanceDatabase.availableGigs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan Freelance 💻', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ListView.builder(
          padding: EdgeInsets.all(isMobile ? 10 : 16),
          itemCount: gigs.length,
          itemBuilder: (context, index) {
            final gig = gigs[index];
            final IconData icon = gig['icon'] as IconData;
            final Color color = gig['color'] as Color;
            final int payout = (gig['payout'] as num).toInt();
            final int minIntel = gig['minIntel'] ?? 0;
            final bool isEligible = widget.character.intelligence >= minIntel;

            return Card(
              margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 10 : 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 8 : 10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: isMobile ? 22 : 28),
                    ),
                    SizedBox(width: isMobile ? 10 : 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gig['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            gig['desc'],
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              Text(
                                'Bayaran: ${CurrencySettings.format(payout)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: isMobile ? 11.5 : 13,
                                ),
                              ),
                              Text(
                                'Kecerdasan: $minIntel%',
                                style: TextStyle(
                                  fontSize: isMobile ? 10.5 : 11,
                                  color: isEligible ? (isDark ? Colors.white54 : Colors.grey.shade600) : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEligible ? Colors.purple.shade700 : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 14,
                          vertical: isMobile ? 6 : 8,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => _takeFreelanceGig(gig),
                      child: Text(
                        'Ambil',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 11.5 : 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
