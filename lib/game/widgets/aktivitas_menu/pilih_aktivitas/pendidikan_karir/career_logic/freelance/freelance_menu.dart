// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/freelance/freelance_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'freelance_database.dart';

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
    final int minIntel = gig['minIntel'] ?? 0;
    if (widget.character.intelligence < minIntel) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kecerdasan Tidak Mencukupi'),
          content: Text('Proyek "${gig['title']}" membutuhkan tingkat kecerdasan minimal $minIntel%. Kecerdasanmu saat ini: ${widget.character.intelligence}%.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
          ],
        ),
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

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(gig['icon'] as IconData, color: gig['color'] as Color),
            const SizedBox(width: 8),
            const Text('Proyek Selesai! 🎉'),
          ],
        ),
        content: Text('Selamat! Kamu telah menyelesaikan proyek "${gig['title']}" dengan sukses dan mengantongi uang tunai sebesar ${CurrencySettings.format(payout)}.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Terima Uang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final gigs = FreelanceDatabase.availableGigs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan Freelance 💻', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                              fontSize: isMobile ? 13 : 15,
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
