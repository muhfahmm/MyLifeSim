// lib/pilih_gender/gender.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/karakter.dart';
import 'package:mylifesim/main.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Pilih Gender'),
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 0,
          actions: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                final dark = mode == ThemeMode.dark;
                return IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: Tween(begin: 0.75, end: 1.0).animate(anim),
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      dark ? Icons.light_mode : Icons.dark_mode,
                      key: ValueKey(dark),
                      color: dark ? Colors.yellow.shade700 : Colors.grey.shade700,
                    ),
                  ),
                  onPressed: () {
                    themeNotifier.value = dark ? ThemeMode.light : ThemeMode.dark;
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Apa jenis kelamin karaktermu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildGenderOption(
                    context,
                    gender: 'Laki-laki',
                    icon: Icons.male,
                    iconColor: Colors.blue,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderOption(
                    context,
                    gender: 'Perempuan',
                    icon: Icons.female,
                    iconColor: Colors.pink,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String gender,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          String genderKey = gender.toLowerCase();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KarakterScreen(gender: genderKey),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(width: 16),
              Text(
                gender,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}