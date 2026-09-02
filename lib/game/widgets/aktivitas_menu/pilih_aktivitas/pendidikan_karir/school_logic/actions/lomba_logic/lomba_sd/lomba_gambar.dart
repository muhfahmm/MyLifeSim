// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_gambar.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaGambarSD(BuildContext context, Character character, VoidCallback onRefresh) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LombaGambarDialog(
      character: character,
      onRefresh: onRefresh,
    ),
  );
}

class _LombaGambarDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const _LombaGambarDialog({
    required this.character,
    required this.onRefresh,
  });

  @override
  State<_LombaGambarDialog> createState() => _LombaGambarDialogState();
}

class _LombaGambarDialogState extends State<_LombaGambarDialog> {
  final List<Offset?> _points = [];
  final Set<Color> _usedColors = {}; // Melacak warna yang digunakan
  Color _selectedColor = Colors.red;
  double _strokeWidth = 6.0;

  final List<Color> _palette = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.black,
  ];

  // --- LOGIKA PENILAIAN MULTI-ASPEK ---
  Map<String, dynamic> _calculateScore() {
    if (_points.isEmpty) {
      return {'total': 0, 'detail': 'Tidak ada gambar'};
    }

    // 1. Variasi Warna (Maks 70 poin) - 7 warna * 10 poin
    int colorScore = _usedColors.length * 10;

    // 2. Cakupan Area (Maks 80 poin) - Berdasarkan bounding box
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    
    for (var p in _points) {
      if (p != null) {
        minX = min(minX, p.dx);
        maxX = max(maxX, p.dx);
        minY = min(minY, p.dy);
        maxY = max(maxY, p.dy);
      }
    }

    // Asumsikan kanvas berukuran 300x220 (perkiraan)
    double canvasWidth = 300.0;
    double canvasHeight = 220.0;
    double coveredWidth = (maxX - minX).clamp(0, canvasWidth);
    double coveredHeight = (maxY - minY).clamp(0, canvasHeight);
    double coveragePercentage = (coveredWidth * coveredHeight) / (canvasWidth * canvasHeight);
    int coverageScore = (coveragePercentage * 80).round();

    // 3. Kelancaran Garis (Maks 30 poin) - Jarak rata-rata antar titik
    int smoothnessScore = 0;
    if (_points.length > 2) {
      double totalDistance = 0.0;
      int distanceCount = 0;
      for (int i = 0; i < _points.length - 1; i++) {
        if (_points[i] != null && _points[i + 1] != null) {
          double distance = (_points[i]! - _points[i + 1]!).distance;
          // Jika jarak antar titik terlalu dekat (< 2px), itu coretan di tempat
          // Jika jarak > 5px, itu garis mengalir bagus
          if (distance > 5.0) {
            totalDistance += distance;
            distanceCount++;
          }
        }
      }
      if (distanceCount > 0) {
        // Rasio panjang garis terhadap jumlah coretan
        smoothnessScore = (min(totalDistance / 10.0, 30.0)).round();
      }
    }

    // 4. Aktivitas (Maks 20 poin) - Jumlah titik
    int activityScore = min(_points.length, 20).round();

    int totalScore = colorScore + coverageScore + smoothnessScore + activityScore;

    return {
      'total': totalScore,
      'detail': 'Warna: $colorScore, Area: $coverageScore, Garis: $smoothnessScore, Aktivitas: $activityScore'
    };
  }

  void _submitArtwork() {
    final result = _calculateScore();
    int totalScore = result['total'];
    
    Navigator.pop(context);
    
    Future.microtask(() {
      if (totalScore >= 150) {
        // Juara 1
        int rewardMoney = 100 + Random().nextInt(51); // $100-$150
        widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
        widget.character.appearance = (widget.character.appearance + 10).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 1 Lomba Menggambar! 🏆🎨',
          'Lukisanmu luar biasa! Juri memuji variasi warna dan keluasan karyamu.\n\n'
          'Kebahagiaan +15%\nPenampilan +10%\nHadiah Uang: \$$rewardMoney\n\n'
          'Detail Penilaian: ${result['detail']}',
          onConfirm: widget.onRefresh,
        );
      } else if (totalScore >= 110) {
        // Juara 2
        int rewardMoney = 50 + Random().nextInt(26); // $50-$75
        widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
        widget.character.appearance = (widget.character.appearance + 5).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 2 Lomba Menggambar! 🥈🎨',
          'Karyamu sangat bagus, hanya sedikit kurang variasi warna.\n\n'
          'Kebahagiaan +10%\nPenampilan +5%\nHadiah Uang: \$$rewardMoney\n\n'
          'Detail Penilaian: ${result['detail']}',
          onConfirm: widget.onRefresh,
        );
      } else if (totalScore >= 80) {
        // Juara 3
        int rewardMoney = 20 + Random().nextInt(16); // $20-$35
        widget.character.happiness = (widget.character.happiness + 7).clamp(0, 100);
        widget.character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 3 Lomba Menggambar! 🥉🎨',
          'Lukisanmu cukup bagus, tapi coba gambar lebih luas lagi ya!\n\n'
          'Kebahagiaan +7%\nHadiah Uang: \$$rewardMoney\n\n'
          'Detail Penilaian: ${result['detail']}',
          onConfirm: widget.onRefresh,
        );
      } else {
        // Partisipasi
        widget.character.happiness = (widget.character.happiness + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Apresiasi Seni 🎨',
          'Kamu tetap berusaha, tapi juri berharap kamu lebih banyak menggunakan warna lain dan menggambar di seluruh kertas.\n\n'
          'Kebahagiaan +4%\n\n'
          'Detail Penilaian: ${result['detail']}',
          onConfirm: widget.onRefresh,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.palette, color: Colors.pink, size: 28),
          SizedBox(width: 8),
          Text('Lomba Menggambar & Mewarnai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Usap/seret jarimu di kanvas. Semakin banyak warna dan semakin luas gambar, semakin besar peluangmu menang!',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Canvas Area
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade300, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    setState(() {
                      _points.add(details.localPosition);
                      _usedColors.add(_selectedColor); // Tambahkan warna saat menggambar
                    });
                  },
                  onPanEnd: (details) {
                    _points.add(null);
                  },
                  child: CustomPaint(
                    painter: _DrawingPainter(points: _points, color: _selectedColor, strokeWidth: _strokeWidth),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Color Palette Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _palette.map((color) {
                final bool isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: isSelected ? 30 : 24,
                    height: isSelected ? 30 : 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6, spreadRadius: 2)]
                          : [],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  tooltip: 'Hapus Semua',
                  onPressed: () {
                    setState(() {
                      _points.clear();
                      _usedColors.clear();
                    });
                  },
                ),
                Text('Warna dipakai: ${_usedColors.length} warna | Titik: ${_points.where((p) => p != null).length}'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.flag_outlined, color: Colors.red, size: 18),
          label: const Text('Menyerah', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('Kumpulkan Lukisan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _submitArtwork,
        ),
      ],
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  _DrawingPainter({required this.points, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}