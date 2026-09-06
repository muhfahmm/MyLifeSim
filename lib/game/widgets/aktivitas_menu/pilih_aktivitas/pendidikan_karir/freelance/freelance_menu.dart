// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/freelance/freelance_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
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
      widget.character.inbox.add('💻 Freelance: Kamu menyelesaikan proyek "${gig['title']}" dan mendapatkan bayaran sebesar \$$payout!');
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
        content: Text('Selamat! Kamu telah menyelesaikan proyek "${gig['title']}" dengan sukses dan mengantongi uang tunai sebesar \$$payout.'),
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
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
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
          padding: const EdgeInsets.all(16),
          itemCount: gigs.length,
          itemBuilder: (context, index) {
            final gig = gigs[index];
            final IconData icon = gig['icon'] as IconData;
            final Color color = gig['color'] as Color;
            final int payout = (gig['payout'] as num).toInt();
            final int minIntel = gig['minIntel'] ?? 0;
            final bool isEligible = widget.character.intelligence >= minIntel;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                title: Text(
                  gig['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      gig['desc'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Bayaran: \$$payout',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Kecerdasan: $minIntel%',
                          style: TextStyle(
                            fontSize: 11,
                            color: isEligible ? (isDark ? Colors.white54 : Colors.grey.shade600) : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEligible ? Colors.purple.shade700 : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _takeFreelanceGig(gig),
                  child: const Text('Ambil', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
