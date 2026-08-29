// lib/intro_animation.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class IntroAnimationScreen extends StatefulWidget {
  final Widget nextScreen;
  const IntroAnimationScreen({super.key, required this.nextScreen});

  @override
  State<IntroAnimationScreen> createState() => _IntroAnimationScreenState();
}

class _IntroAnimationScreenState extends State<IntroAnimationScreen>
    with TickerProviderStateMixin {
  
  // Controller untuk Background dan Partikel (Real-time)
  late AnimationController _bgController;
  
  // Controller untuk Detak Jantung (Real-time, terus berulang)
  late AnimationController _heartController;
  late Animation<double> _heartBeatScale;

  // Controller untuk Shimmer Teks (Real-time)
  late AnimationController _shimmerController;

  // Controller Utama untuk Urutan Scene (Muncul -> Tunggu -> Keluar)
  late AnimationController _introController;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _progressOpacity;
  late Animation<double> _exitOpacity;

  // Data untuk Partikel Buble (Random)
  final List<_BubbleData> _bubbles = [];

  @override
  void initState() {
    super.initState();

    // 1. Setup Background & Partikel (Bergerak terus menerus)
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _generateBubbles();

    // 2. Setup Detak Jantung Realistis (Lub-Dub)
    _heartController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    // Pola "Lub-Dub" (Membesar cepat, mengecil, membesar sedikit, mengecil)
    _heartBeatScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 20), // Lub
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.12), weight: 20), // Dub
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeInOut));

    // 3. Setup Shimmer Teks (Gradient bergerak)
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    // 4. Setup Urutan Scene (Total 5 detik - terasa cukup santai karena bg hidup)
    _introController = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000));
    
    _titleOpacity = CurvedAnimation(parent: _introController, curve: const Interval(0.2, 0.4, curve: Curves.easeOut));
    _titleSlide = CurvedAnimation(parent: _introController, curve: const Interval(0.2, 0.4, curve: Curves.easeOut))
        .drive(Tween(begin: const Offset(0, 0.2), end: Offset.zero));
    _taglineOpacity = CurvedAnimation(parent: _introController, curve: const Interval(0.4, 0.6, curve: Curves.easeIn));
    _progressOpacity = CurvedAnimation(parent: _introController, curve: const Interval(0.5, 0.7, curve: Curves.easeIn));
    _exitOpacity = CurvedAnimation(parent: _introController, curve: const Interval(0.85, 1.0, curve: Curves.easeOut));

    // Mulai urutan intro
    _introController.forward();

    // Pindah halaman setelah selesai
    _introController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget.nextScreen,
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              // Transisi modern: Fade + Zoom Out halus
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.1).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    });
  }

  // Generate partikel buble secara acak
  void _generateBubbles() {
    final random = math.Random();
    for (int i = 0; i < 15; i++) {
      _bubbles.add(_BubbleData(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 30 + 10,
        speed: random.nextDouble() * 0.5 + 0.5,
        opacity: random.nextDouble() * 0.2 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _heartController.dispose();
    _shimmerController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _exitOpacity,
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Background Gradien yang Bergerak Real-time
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.5 * math.sin(_bgController.value * 2 * math.pi), -1),
                      end: Alignment(0.5 * math.cos(_bgController.value * 2 * math.pi), 1),
                      colors: const [
                        Color(0xFFE3F2FD),
                        Colors.white,
                        Color(0xFFBBDEFB),
                        Color(0xFF90CAF9),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 2. Partikel Buble yang Melayang (CustomPainter)
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _BubblePainter(
                    progress: _bgController.value,
                    bubbles: _bubbles,
                  ),
                );
              },
            ),

            // 3. Konten Utama (Tengah Layar)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hati dengan Detak Jantung Realistis + Glow
                  ScaleTransition(
                    scale: _heartBeatScale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 40 * _heartBeatScale.value,
                            spreadRadius: 10 * _heartBeatScale.value,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.favorite_rounded, size: 80, color: Colors.blueAccent),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Teks BITLIFE dengan Efek Shimmer (Gradient Bergerak)
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment(-1.5 + 3.0 * _shimmerController.value, 0),
                                end: Alignment(-0.5 + 3.0 * _shimmerController.value, 0),
                                colors: const [
                                  Colors.black87,
                                  Colors.blueAccent,
                                  Colors.black87,
                                ],
                                stops: const [0.35, 0.5, 0.65],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcATop,
                            child: const Text(
                              'BITLIFE',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 6,
                                color: Colors.white, // Warna dasar akan diganti Shader
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: const Text(
                      'Simulasi Kehidupan Tanpa Batas',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Progress Bar Modern
                  FadeTransition(
                    opacity: _progressOpacity,
                    child: const SizedBox(
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          color: Colors.blueAccent,
                          backgroundColor: Colors.black12,
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DATA & PAINTER UNTUK PARTIKEL =================

class _BubbleData {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  _BubbleData({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _BubblePainter extends CustomPainter {
  final double progress;
  final List<_BubbleData> bubbles;

  _BubblePainter({required this.progress, required this.bubbles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var bubble in bubbles) {
      // Hitung posisi Y berdasarkan progress agar bergerak ke atas
      double yPos = (bubble.y - (progress * bubble.speed)) % 1.0;
      if (yPos < 0) yPos += 1.0;

      // Posisi X bergerak sedikit ke kiri dan kanan (efek melayang)
      double xPos = bubble.x + (math.sin(progress * 2 * math.pi + bubble.y) * 0.05);

      paint.color = Colors.blueAccent.withOpacity(bubble.opacity);
      
      // Gambar partikel berupa lingkaran blur (bokeh)
      canvas.drawCircle(
        Offset(xPos * size.width, yPos * size.height),
        bubble.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.bubbles != bubbles;
  }
}