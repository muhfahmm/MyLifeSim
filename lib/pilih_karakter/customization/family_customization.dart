// lib/pilih_karakter/customization/family_customization.dart

import 'package:flutter/material.dart';

class FamilyCustomizationScreen extends StatefulWidget {
  final List<String> maleFirstNames;
  final List<String> femaleFirstNames;
  final List<String> lastNames;
  final String gender;
  final Function(Map<String, dynamic> customFamilyData) onConfirm;

  const FamilyCustomizationScreen({
    super.key,
    required this.maleFirstNames,
    required this.femaleFirstNames,
    required this.lastNames,
    required this.gender,
    required this.onConfirm,
  });

  @override
  State<FamilyCustomizationScreen> createState() => _FamilyCustomizationScreenState();
}

class _FamilyCustomizationScreenState extends State<FamilyCustomizationScreen> {
  // 1. Rentang Usia Orang Tua
  RangeValues _fatherAgeRange = const RangeValues(35, 55);
  RangeValues _motherAgeRange = const RangeValues(30, 48);

  // 2. Anak Keberapa
  int _birthOrder = 1;

  // 3. Saudara Kandung
  String _siblingOption = 'tidak_punya'; // 'tidak_punya', 'kakak', 'adik', 'kakak_dan_adik'
  int _kakakLakiCount = 0;
  int _kakakPerempuanCount = 0;
  int _adikLakiCount = 0;
  int _adikPerempuanCount = 0;

  void _validateAndAdjustSiblingCounts() {
    // Jika tidak punya kakak, reset jumlah kakak
    if (_siblingOption == 'tidak_punya' || _siblingOption == 'adik') {
      _kakakLakiCount = 0;
      _kakakPerempuanCount = 0;
      _birthOrder = 1; // Jika tidak punya kakak, otomatis anak ke-1
    } else {
      // Jika punya kakak, minimal total kakak adalah 1, dan birthOrder minimal adalah total kakak + 1
      int totalKakak = _kakakLakiCount + _kakakPerempuanCount;
      if (totalKakak == 0) {
        _kakakLakiCount = 1;
        totalKakak = 1;
      }
      _birthOrder = totalKakak + 1;
    }

    // Jika tidak punya adik, reset jumlah adik
    if (_siblingOption == 'tidak_punya' || _siblingOption == 'kakak') {
      _adikLakiCount = 0;
      _adikPerempuanCount = 0;
    } else {
      int totalAdik = _adikLakiCount + _adikPerempuanCount;
      if (totalAdik == 0) {
        _adikLakiCount = 1;
      }
    }
  }

  void _onSiblingOptionChanged(String? val) {
    if (val == null) return;
    setState(() {
      _siblingOption = val;
      _validateAndAdjustSiblingCounts();
    });
  }

  void _onBirthOrderChanged(int? order) {
    if (order == null) return;
    setState(() {
      _birthOrder = order;
      if (_birthOrder == 1) {
        // Anak ke-1 tidak boleh punya kakak
        if (_siblingOption == 'kakak_dan_adik') {
          _siblingOption = 'adik';
        } else if (_siblingOption == 'kakak') {
          _siblingOption = 'tidak_punya';
        }
        _kakakLakiCount = 0;
        _kakakPerempuanCount = 0;
      } else {
        // Anak ke-2 atau lebih harus punya kakak
        if (_siblingOption == 'tidak_punya') {
          _siblingOption = 'kakak';
        } else if (_siblingOption == 'adik') {
          _siblingOption = 'kakak_dan_adik';
        }
        // Sesuaikan jumlah kakak agar total = birthOrder - 1
        int targetKakak = _birthOrder - 1;
        _kakakLakiCount = targetKakak;
        _kakakPerempuanCount = 0;
      }
    });
  }

  void _submit() {
    // Validasi range usia orang tua
    if (_motherAgeRange.start < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usia Ibu minimal adalah 15 tahun.')),
      );
      return;
    }

    final data = {
      'fatherMinAge': _fatherAgeRange.start.round(),
      'fatherMaxAge': _fatherAgeRange.end.round(),
      'motherMinAge': _motherAgeRange.start.round(),
      'motherMaxAge': _motherAgeRange.end.round(),
      'birthOrder': _birthOrder,
      'kakakLakiCount': _kakakLakiCount,
      'kakakPerempuanCount': _kakakPerempuanCount,
      'adikLakiCount': _adikLakiCount,
      'adikPerempuanCount': _adikPerempuanCount,
    };

    widget.onConfirm(data);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasKakak = _siblingOption == 'kakak' || _siblingOption == 'kakak_dan_adik';
    final bool hasAdik = _siblingOption == 'adik' || _siblingOption == 'kakak_dan_adik';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Latar Belakang Keluarga 👨‍👩‍👧‍👦',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deskripsi Singkat
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                      color: isDark ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: isDark ? Colors.blue.shade300 : Colors.blue.shade700, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Kustomisasi asal usul silsilah keluargamu. Aturan logika kelahiran akan divalidasi otomatis secara presisi.',
                                style: TextStyle(
                                  color: isDark ? Colors.blue.shade200 : Colors.blue.shade900,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 1: Rentang Usia Orang Tua
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. Rentang Usia Orang Tua',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Usia Ayah
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Usia Ayah:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Text(
                                  '${_fatherAgeRange.start.round()} - ${_fatherAgeRange.end.round()} Tahun',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: _fatherAgeRange,
                              min: 20,
                              max: 80,
                              divisions: 60,
                              labels: RangeLabels(
                                '${_fatherAgeRange.start.round()}',
                                '${_fatherAgeRange.end.round()}',
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _fatherAgeRange = values;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            // Usia Ibu
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Usia Ibu:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Text(
                                  '${_motherAgeRange.start.round()} - ${_motherAgeRange.end.round()} Tahun',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: _motherAgeRange,
                              min: 15,
                              max: 65,
                              divisions: 50,
                              labels: RangeLabels(
                                '${_motherAgeRange.start.round()}',
                                '${_motherAgeRange.end.round()}',
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _motherAgeRange = values;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 2: Anak Keberapa & Pilihan Saudara
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2. Urutan Kelahiran',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Dropdown Anak Keberapa
                            DropdownButtonFormField<int>(
                              value: _birthOrder,
                              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'Saya adalah anak ke-',
                                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 1, child: Text('1 (Anak Pertama / Tunggal)')),
                                DropdownMenuItem(value: 2, child: Text('2')),
                                DropdownMenuItem(value: 3, child: Text('3')),
                                DropdownMenuItem(value: 4, child: Text('4')),
                                DropdownMenuItem(value: 5, child: Text('5 (atau lebih)')),
                              ],
                              onChanged: _onBirthOrderChanged,
                            ),
                            const SizedBox(height: 16),
                            // Pilihan Saudara Kandung
                            DropdownButtonFormField<String>(
                              value: _siblingOption,
                              dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'Saudara Kandung',
                                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'tidak_punya', child: Text('Tidak Punya')),
                                DropdownMenuItem(value: 'kakak', child: Text('Hanya Punya Kakak')),
                                DropdownMenuItem(value: 'adik', child: Text('Hanya Punya Adik')),
                                DropdownMenuItem(value: 'kakak_dan_adik', child: Text('Punya Kakak dan Adik')),
                              ],
                              onChanged: _onSiblingOptionChanged,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 3: Custom Jumlah Kakak & Adik
                    if (_siblingOption != 'tidak_punya')
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                        ),
                        color: isDark ? Colors.grey.shade800 : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3. Detail Saudara Kandung',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Section Kakak
                              if (hasKakak) ...[
                                Text(
                                  'Jumlah Kakak (Harus ${_birthOrder - 1} Orang):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildCounterRow(
                                  context: context,
                                  label: 'Kakak Laki-laki',
                                  value: _kakakLakiCount,
                                  onChanged: (val) {
                                    setState(() {
                                      _kakakLakiCount = val;
                                      // Batasi agar total kakak = birthOrder - 1
                                      final int maxK = _birthOrder - 1;
                                      if (_kakakLakiCount + _kakakPerempuanCount > maxK) {
                                        _kakakPerempuanCount = maxK - _kakakLakiCount;
                                      }
                                    });
                                  },
                                ),
                                _buildCounterRow(
                                  context: context,
                                  label: 'Kakak Perempuan',
                                  value: _kakakPerempuanCount,
                                  onChanged: (val) {
                                    setState(() {
                                      _kakakPerempuanCount = val;
                                      // Batasi agar total kakak = birthOrder - 1
                                      final int maxK = _birthOrder - 1;
                                      if (_kakakLakiCount + _kakakPerempuanCount > maxK) {
                                        _kakakLakiCount = maxK - _kakakPerempuanCount;
                                      }
                                    });
                                  },
                                ),
                                const Divider(height: 24, color: Colors.grey),
                              ],

                              // Section Adik
                              if (hasAdik) ...[
                                Text(
                                  'Jumlah Adik:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildCounterRow(
                                  context: context,
                                  label: 'Adik Laki-laki',
                                  value: _adikLakiCount,
                                  onChanged: (val) {
                                    setState(() {
                                      _adikLakiCount = val;
                                    });
                                  },
                                ),
                                _buildCounterRow(
                                  context: context,
                                  label: 'Adik Perempuan',
                                  value: _adikPerempuanCount,
                                  onChanged: (val) {
                                    setState(() {
                                      _adikPerempuanCount = val;
                                    });
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Tombol fixed di bawah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SELESAI & LAHIRKAN! 👶',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({
    required BuildContext context,
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}