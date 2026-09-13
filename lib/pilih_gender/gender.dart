// lib/pilih_gender/gender.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/karakter.dart';
import 'package:mylifesim/main.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _hoveredGender;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Subtle background gradient decorations
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? Colors.blue.shade900 : Colors.blue.shade200).withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? Colors.pink.shade900 : Colors.pink.shade200).withValues(alpha: 0.2),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, size: 20, color: textColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      // Step Pill Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.style_rounded, size: 14, color: Colors.blue.shade400),
                            const SizedBox(width: 6),
                            Text(
                              'LANGKAH 1 DARI 2',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Actions: Theme toggle & Close
                      Row(
                        children: [
                          ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeNotifier,
                            builder: (context, mode, _) {
                              final dark = mode == ThemeMode.dark;
                              return IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                    size: 20,
                                    color: dark ? Colors.amber : Colors.indigo.shade700,
                                  ),
                                ),
                                onPressed: () {
                                  themeNotifier.value = dark ? ThemeMode.light : ThemeMode.dark;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header Icon Badge
                            Center(
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)]
                                        : [const Color(0xFF2563EB), const Color(0xFF7C3AED)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: 0.35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Main Title
                            Text(
                              'Pilih Gender Karakter',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tentukan jenis kelamin awal untuk memulai petualangan sim kehidupannmu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: subtextColor,
                              ),
                            ),
                            const SizedBox(height: 36),

                            // Option Cards
                            _buildGenderCard(
                              context,
                              genderKey: 'laki-laki',
                              title: 'Laki-laki',
                              subtitle: 'Memulai perjalanan sebagai karakter pria',
                              icon: Icons.male_rounded,
                              accentGradient: const [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                              isDark: isDark,
                            ),
                            const SizedBox(height: 18),
                            _buildGenderCard(
                              context,
                              genderKey: 'perempuan',
                              title: 'Perempuan',
                              subtitle: 'Memulai perjalanan sebagai karakter wanita',
                              icon: Icons.female_rounded,
                              accentGradient: const [Color(0xFFEC4899), Color(0xFFF43F5E)],
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(
    BuildContext context, {
    required String genderKey,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> accentGradient,
    required bool isDark,
  }) {
    final isHovered = _hoveredGender == genderKey;
    final primaryAccent = accentGradient.first;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredGender = genderKey),
      onExit: (_) => setState(() => _hoveredGender = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KarakterScreen(gender: genderKey),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: isHovered ? Matrix4.diagonal3Values(1.02, 1.02, 1.0) : Matrix4.identity(),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? (isHovered ? const Color(0xFF1E293B) : const Color(0xFF0F172A).withValues(alpha: 0.8))
                : (isHovered ? Colors.white : Colors.white.withValues(alpha: 0.9)),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovered
                  ? primaryAccent
                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
              width: isHovered ? 2.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? primaryAccent.withValues(alpha: 0.2)
                    : (isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04)),
                blurRadius: isHovered ? 24 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with Gradient Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: accentGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryAccent.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 18),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron Arrow Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isHovered
                      ? primaryAccent.withValues(alpha: 0.15)
                      : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isHovered
                      ? primaryAccent
                      : (isDark ? Colors.white38 : Colors.black38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

