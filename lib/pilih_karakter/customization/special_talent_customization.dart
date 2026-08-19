// lib/pilih_karakter/customization/special_talent_customization.dart

import 'package:flutter/material.dart';

class SpecialTalentCustomizationScreen extends StatefulWidget {
  final String initialTalent;

  const SpecialTalentCustomizationScreen({
    super.key,
    required this.initialTalent,
  });

  @override
  State<SpecialTalentCustomizationScreen> createState() => _SpecialTalentCustomizationScreenState();
}

class _SpecialTalentCustomizationScreenState extends State<SpecialTalentCustomizationScreen> {
  late String _selectedTalent;

  final List<Map<String, String>> _talents = [
    {'name': 'Tidak Ada', 'emoji': '😀'},
    {'name': 'Akting', 'emoji': '🎭'},
    {'name': 'Kriminalitas', 'emoji': '🔫'},
    {'name': 'Pengedar', 'emoji': '🌿'},
    {'name': 'Modeling', 'emoji': '📸'},
    {'name': 'Musik', 'emoji': '🎵'},
    {'name': 'Olahraga', 'emoji': '🏀'},
  ];

  @override
  void initState() {
    super.initState();
    // Normalisasi jika input adalah bahasa Inggris ke bahasa Indonesia
    final String initial = widget.initialTalent;
    if (initial == 'None') {
      _selectedTalent = 'Tidak Ada';
    } else if (initial == 'Acting') {
      _selectedTalent = 'Akting';
    } else if (initial == 'Crime') {
      _selectedTalent = 'Kriminalitas';
    } else if (initial == 'Dealing') {
      _selectedTalent = 'Pengedar';
    } else if (initial == 'Modeling') {
      _selectedTalent = 'Modeling';
    } else if (initial == 'Music') {
      _selectedTalent = 'Musik';
    } else if (initial == 'Sports') {
      _selectedTalent = 'Olahraga';
    } else {
      _selectedTalent = initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Talenta Spesial', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                'Pilih talenta spesial karaktermu',
                style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                itemCount: _talents.length,
                itemBuilder: (context, index) {
                  final talent = _talents[index];
                  final isSelected = _selectedTalent == talent['name'];
                  
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? Colors.orange : Colors.grey.shade200,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    color: isSelected ? Colors.orange.withOpacity(0.08) : Colors.grey.shade50,
                    child: ListTile(
                      leading: Text(
                        talent['emoji']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        talent['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.orange.shade800 : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.orange)
                          : Icon(Icons.circle_outlined, color: Colors.grey.shade400),
                      onTap: () {
                        setState(() {
                          _selectedTalent = talent['name']!;
                        });
                      },
                    ),
                  );
                },
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
                    Navigator.pop(context, _selectedTalent);
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
}
