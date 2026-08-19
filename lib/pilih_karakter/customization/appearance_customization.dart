// lib/pilih_karakter/customization/appearance_customization.dart

import 'package:flutter/material.dart';
import 'package:bitlife/avatar/avatar_generator.dart';

class AppearanceCustomizationScreen extends StatefulWidget {
  final String gender;
  final Map<String, String> initialAppearance;

  const AppearanceCustomizationScreen({
    super.key,
    required this.gender,
    required this.initialAppearance,
  });

  @override
  State<AppearanceCustomizationScreen> createState() => _AppearanceCustomizationScreenState();
}

class _AppearanceCustomizationScreenState extends State<AppearanceCustomizationScreen> {
  late String _selectedTopType;
  late String _selectedAccessoriesType;
  late String _selectedHairColor;
  late String _selectedClotheType;
  late String _selectedClotheColor;
  late String _selectedSkinColor;

  @override
  void initState() {
    super.initState();
    _selectedTopType = widget.initialAppearance['topType'] ?? '';
    _selectedAccessoriesType = widget.initialAppearance['accessoriesType'] ?? '';
    _selectedHairColor = widget.initialAppearance['hairColor'] ?? '';
    _selectedClotheType = widget.initialAppearance['clotheType'] ?? '';
    _selectedClotheColor = widget.initialAppearance['clotheColor'] ?? '';
    _selectedSkinColor = widget.initialAppearance['skinColor'] ?? '';

    // Validate values or fallback
    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';
    final tops = isMale ? AvatarGenerator.topsMale : AvatarGenerator.topsFemale;
    
    if (!tops.values.contains(_selectedTopType)) _selectedTopType = tops.values.first;
    if (!AvatarGenerator.accessories.values.contains(_selectedAccessoriesType)) _selectedAccessoriesType = AvatarGenerator.accessories.values.first;
    if (!AvatarGenerator.hairColors.values.contains(_selectedHairColor)) _selectedHairColor = AvatarGenerator.hairColors.values.first;
    if (!AvatarGenerator.clothes.values.contains(_selectedClotheType)) _selectedClotheType = AvatarGenerator.clothes.values.first;
    if (!AvatarGenerator.clotheColors.values.contains(_selectedClotheColor)) _selectedClotheColor = AvatarGenerator.clotheColors.values.first;
    if (!AvatarGenerator.skinColors.values.contains(_selectedSkinColor)) _selectedSkinColor = AvatarGenerator.skinColors.values.first;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMale = widget.gender == 'male' || widget.gender == 'laki-laki';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kustomisasi Penampilan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Live Avatar Preview
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.blue.shade100, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue.shade50,
                          child: Image.network(
                            AvatarGenerator.buildCustomAvatarUrl(
                              topType: _selectedTopType,
                              accessoriesType: _selectedAccessoriesType,
                              hairColor: _selectedHairColor,
                              clotheType: _selectedClotheType,
                              clotheColor: _selectedClotheColor,
                              skinColor: _selectedSkinColor,
                              eyeType: 'default',
                              eyebrowType: 'default',
                              mouthType: 'default',
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            },
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Customizers list
                    _buildCustomizerDropdown(
                      label: 'Gaya Rambut',
                      value: _selectedTopType,
                      items: isMale ? AvatarGenerator.topsMale : AvatarGenerator.topsFemale,
                      onChanged: (val) => setState(() => _selectedTopType = val!),
                    ),
                    _buildCustomizerDropdown(
                      label: 'Warna Rambut',
                      value: _selectedHairColor,
                      items: AvatarGenerator.hairColors,
                      onChanged: (val) => setState(() => _selectedHairColor = val!),
                      isColorDropdown: true,
                    ),
                    _buildCustomizerDropdown(
                      label: 'Warna Kulit',
                      value: _selectedSkinColor,
                      items: AvatarGenerator.skinColors,
                      onChanged: (val) => setState(() => _selectedSkinColor = val!),
                      isColorDropdown: true,
                    ),
                    _buildCustomizerDropdown(
                      label: 'Aksesoris / Kacamata',
                      value: _selectedAccessoriesType,
                      items: AvatarGenerator.accessories,
                      onChanged: (val) => setState(() => _selectedAccessoriesType = val!),
                    ),
                    _buildCustomizerDropdown(
                      label: 'Pakaian',
                      value: _selectedClotheType,
                      items: AvatarGenerator.clothes,
                      onChanged: (val) => setState(() => _selectedClotheType = val!),
                    ),
                    _buildCustomizerDropdown(
                      label: 'Warna Pakaian',
                      value: _selectedClotheColor,
                      items: AvatarGenerator.clotheColors,
                      onChanged: (val) => setState(() => _selectedClotheColor = val!),
                      isColorDropdown: true,
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'topType': _selectedTopType,
                      'accessoriesType': _selectedAccessoriesType,
                      'hairColor': _selectedHairColor,
                      'clotheType': _selectedClotheType,
                      'clotheColor': _selectedClotheColor,
                      'skinColor': _selectedSkinColor,
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

  Widget _buildCustomizerDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
    bool isColorDropdown = false,
  }) {
    final finalValue = items.values.contains(value) ? value : items.values.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: finalValue,
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: items.entries.map((entry) {
              Widget leading = const SizedBox.shrink();
              if (isColorDropdown) {
                Color swatchColor = Colors.transparent;
                try {
                  swatchColor = Color(int.parse('FF${entry.value}', radix: 16));
                } catch (_) {}
                
                leading = Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: swatchColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                );
              }

              return DropdownMenuItem<String>(
                value: entry.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leading,
                    Text(entry.key, style: const TextStyle(color: Colors.black87)),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
