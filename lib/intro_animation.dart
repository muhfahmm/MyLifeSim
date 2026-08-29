// lib/intro_animation.dart
import "package:flutter/material.dart";

class IntroAnimationScreen extends StatefulWidget {
  final Widget nextScreen;
  const IntroAnimationScreen({super.key, required this.nextScreen});

  @override
  State<IntroAnimationScreen> createState() => _IntroAnimationScreenState();
}

class _IntroAnimationScreenState extends State<IntroAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  late Animation<double> _heartOpacity;

  late AnimationController _titleController;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  late AnimationController _taglineController;
  late Animation<double> _taglineOpacity;

  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  late AnimationController _exitController;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _heartScale = CurvedAnimation(parent: _heartController, curve: Curves.elasticOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _heartOpacity = CurvedAnimation(parent: _heartController, curve: Curves.easeIn)
        .drive(Tween(begin: 0.0, end: 1.0));

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulseScale = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
        .drive(Tween(begin: 1.0, end: 1.18));

    _titleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _titleOpacity = CurvedAnimation(parent: _titleController, curve: Curves.easeIn)
        .drive(Tween(begin: 0.0, end: 1.0));
    _titleSlide = CurvedAnimation(parent: _titleController, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.4), end: Offset.zero));

    _taglineController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _taglineOpacity = CurvedAnimation(parent: _taglineController, curve: Curves.easeIn)
        .drive(Tween(begin: 0.0, end: 1.0));

    _exitController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _exitOpacity = CurvedAnimation(parent: _exitController, curve: Curves.easeOut)
        .drive(Tween(begin: 1.0, end: 0.0));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _heartController.forward();

    await Future.delayed(const Duration(milliseconds: 700));
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 200));
    _titleController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 900));
    _pulseController.stop();
    await _exitController.forward();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.nextScreen,
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    _pulseController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _exitOpacity,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_heartController, _pulseController]),
                builder: (_, __) {
                  return FadeTransition(
                    opacity: _heartOpacity,
                    child: Transform.scale(
                      scale: _heartScale.value * _pulseScale.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.35 * _pulseScale.value),
                              blurRadius: 32 * _pulseScale.value,
                              spreadRadius: 6 * _pulseScale.value,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.favorite_rounded, size: 80, color: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _titleOpacity,
                child: SlideTransition(
                  position: _titleSlide,
                  child: const Text(
                    'BITLIFE',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _taglineOpacity,
                child: const Text(
                  'Simulasi Kehidupan Tanpa Batas',
                  style: TextStyle(fontSize: 14, color: Colors.black45, fontStyle: FontStyle.italic, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
