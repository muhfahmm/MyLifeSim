// lib/pilih_karakter/customization/attributes_customization.dart

import 'package:flutter/material.dart';

class AttributesCustomizationScreen extends StatefulWidget {
  final Map<String, dynamic> initialAttributes;
  final String? gender;

  const AttributesCustomizationScreen({
    super.key,
    required this.initialAttributes,
    this.gender,
  });

  @override
  State<AttributesCustomizationScreen> createState() => _AttributesCustomizationScreenState();
}

class _AttributesCustomizationScreenState extends State<AttributesCustomizationScreen> {
  late double _discipline;
  late double _fertility;
  late double _happiness;
  late double _health;
  late double _karma;
  late double _looks;
  late double _sexualityVal; // 0 = Heteroseksual, 1 = Biseksual, 2 = Gay/Lesbian
  late double _smarts;
  late double _willpower;
  late bool _isFemale;

  @override
  void initState() {
    super.initState();
    _discipline = (widget.initialAttributes['discipline'] ?? 50).toDouble();
    _fertility = (widget.initialAttributes['fertility'] ?? 50).toDouble();
    _happiness = (widget.initialAttributes['happiness'] ?? 50).toDouble();
    _health = (widget.initialAttributes['health'] ?? 100).toDouble();
    _karma = (widget.initialAttributes['karma'] ?? 50).toDouble();
    _looks = (widget.initialAttributes['looks'] ?? 50).toDouble();
    
    final String genderStr = (widget.gender ?? widget.initialAttributes['gender'] ?? '').toString().toLowerCase();
    _isFemale = genderStr.contains('perempuan') || genderStr.contains('female') || genderStr.contains('wanita');

    final String initialSex = widget.initialAttributes['sexuality'] ?? 'Heteroseksual';
    if (initialSex == 'Biseksual') {
      _sexualityVal = 1;
    } else if (initialSex == 'Homoseksual' || initialSex == 'Gay' || initialSex == 'Lesbian') {
      _sexualityVal = 2;
    } else {
      _sexualityVal = 0;
    }

    _smarts = (widget.initialAttributes['smarts'] ?? 50).toDouble();
    _willpower = (widget.initialAttributes['willpower'] ?? 50).toDouble();
  }

  String _getSexualityLabel(double val) {
    if (val < 0.5) return 'Heteroseksual';
    if (val < 1.5) return 'Biseksual';
    return _isFemale ? 'Lesbian' : 'Gay';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        title: Text(
          'Atribut Kepribadian',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Pilih tingkat atribut karaktermu!',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kesehatan',
                      value: _health,
                      icon: Icons.favorite_rounded,
                      iconColor: Colors.redAccent,
                      onChanged: (val) => setState(() => _health = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kebahagiaan',
                      value: _happiness,
                      icon: Icons.sentiment_very_satisfied_rounded,
                      iconColor: Colors.amber.shade700,
                      onChanged: (val) => setState(() => _happiness = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Kecerdasan',
                      value: _smarts,
                      icon: Icons.psychology_rounded,
                      iconColor: Colors.blueAccent,
                      onChanged: (val) => setState(() => _smarts = val),
                    ),
                    _buildAttributeSlider(
                      context: context,
                      label: 'Disiplin',
                      value: _discipline,
                      icon: Icons.fitness_center_rounded,
                      iconColor: Colors.orangeAccent,
                      onChanged: (val) => setState(() => _discipline = val),
                    ),
                    _buildSexualitySlider(context),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'discipline': _discipline.toInt(),
                      'fertility': _fertility.toInt(),
                      'happiness': _happiness.toInt(),
                      'health': _health.toInt(),
                      'karma': _karma.toInt(),
                      'looks': _looks.toInt(),
                      'sexuality': _getSexualityLabel(_sexualityVal),
                      'smarts': _smarts.toInt(),
                      'willpower': _willpower.toInt(),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeSlider({
    required BuildContext context,
    required String label,
    required double value,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<double> onChanged,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: Colors.blue.shade100,
              inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              thumbColor: Colors.blue,
              overlayColor: Colors.blue.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: 0,
              max: 100,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSexualitySlider(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_outline_rounded, size: 18, color: Colors.purple.shade400),
                  const SizedBox(width: 8),
                  Text(
                    'Seksualitas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                _getSexualityLabel(_sexualityVal),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: Colors.blue.shade100,
              inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              thumbColor: Colors.blue,
              overlayColor: Colors.blue.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: 0,
              max: 2,
              divisions: 2,
              value: _sexualityVal,
              onChanged: (val) => setState(() => _sexualityVal = val),
            ),
          ),
        ],
      ),
    );
  }
}