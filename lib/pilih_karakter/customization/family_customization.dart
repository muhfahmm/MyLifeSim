// lib/pilih_karakter/customization/family_customization.dart

import 'package:flutter/material.dart';
// Import database pekerjaan agar daftar orang tua dinamis mengikuti daftar pekerjaan game
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/database_nama_pekerjaan.dart';

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
  String _siblingOption = 'tidak_punya';
  int _kakakLakiCount = 0;
  int _kakakPerempuanCount = 0;
  int _adikLakiCount = 0;
  int _adikPerempuanCount = 0;

  // 4. Status Ekonomi & Pekerjaan Orang Tua
  String _economicStatus = 'menengah';
  String _fatherJobOption = 'acak';
  String _motherJobOption = 'acak';

  // 5. Hubungan Awal & Kesehatan Genetik
  double _initialRelationshipValue = 50;
  RangeValues _fatherHealthRange = const RangeValues(50, 100);
  RangeValues _motherHealthRange = const RangeValues(50, 100);

  // AMBIL JUDUL PEKERJAAN DARI DATABASE
  // Ditambah opsi "acak" dan "Tidak Bekerja / Ibu Rumah Tangga"
  late final List<String> _jobList = [
    'acak', 
    'Tidak Bekerja / Ibu Rumah Tangga',
    ...JobDatabase.availableJobs.map((job) => job['title'] as String).toList(),
  ];

  // Data Dropdown untuk Ekonomi
  final List<Map<String, String>> _economicOptions = [
    {'label': 'Miskin', 'value': 'miskin'},
    {'label': 'Menengah', 'value': 'menengah'},
    {'label': 'Kaya', 'value': 'kaya'},
    {'label': 'Super Kaya', 'value': 'sangat_kaya'},
  ];

  void _validateAndAdjustSiblingCounts() {
    if (_siblingOption == 'tidak_punya' || _siblingOption == 'adik') {
      _kakakLakiCount = 0;
      _kakakPerempuanCount = 0;
      _birthOrder = 1;
    } else {
      int totalKakak = _kakakLakiCount + _kakakPerempuanCount;
      if (totalKakak == 0) {
        _kakakLakiCount = 1;
        totalKakak = 1;
      }
      _birthOrder = totalKakak + 1;
    }

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
        if (_siblingOption == 'kakak_dan_adik') {
          _siblingOption = 'adik';
        } else if (_siblingOption == 'kakak') {
          _siblingOption = 'tidak_punya';
        }
        _kakakLakiCount = 0;
        _kakakPerempuanCount = 0;
      } else {
        if (_siblingOption == 'tidak_punya') {
          _siblingOption = 'kakak';
        } else if (_siblingOption == 'adik') {
          _siblingOption = 'kakak_dan_adik';
        }
        int targetKakak = _birthOrder - 1;
        _kakakLakiCount = targetKakak;
        _kakakPerempuanCount = 0;
      }
    });
  }

  // Fungsi helper untuk mencari data pekerjaan dari database berdasarkan judul
  Map<String, dynamic>? _getJobData(String jobTitle) {
    if (jobTitle == 'acak' || jobTitle == 'Tidak Bekerja / Ibu Rumah Tangga') return null;
    
    try {
      return JobDatabase.availableJobs.firstWhere((job) => job['title'] == jobTitle);
    } catch (_) {
      return null; // Jika tidak ditemukan
    }
  }

  void _submit() {
    if (_motherAgeRange.start < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usia Ibu minimal adalah 15 tahun.')),
      );
      return;
    }

    // Ambil data pekerjaan dan gaji dari database
    final fatherJobData = _getJobData(_fatherJobOption);
    final motherJobData = _getJobData(_motherJobOption);

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
      'economicStatus': _economicStatus,
      'fatherJob': _fatherJobOption,
      'fatherSalary': fatherJobData?['salary'] ?? 0, // Gaji ayah dari database
      'motherJob': _motherJobOption,
      'motherSalary': motherJobData?['salary'] ?? 0, // Gaji ibu dari database
      'initialRelationship': _initialRelationshipValue,
      'fatherHealthMin': _fatherHealthRange.start.round(),
      'fatherHealthMax': _fatherHealthRange.end.round(),
      'motherHealthMin': _motherHealthRange.start.round(),
      'motherHealthMax': _motherHealthRange.end.round(),
    };

    widget.onConfirm(data);
  }

  // --- HELPER UNTUK MENGAMBIL TEKS DARI WIDGET ---
  String _getDropdownLabel(Widget child) {
    if (child is Text) return child.data ?? '';
    return child.toString();
  }

  // --- HELPER DROPDOWN MOBILE NATIVE (BOTTOM SHEET) ---
  Widget _buildModernDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String currentLabel = _getDropdownLabel(
        items.firstWhere((item) => item.value == value).child
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final selected = await showModalBottomSheet<T>(
            context: context,
            backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ...items.map((item) {
                        final bool isSelected = item.value == value;
                        return ListTile(
                          title: item.child,
                          trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                          textColor: isDark ? Colors.white : Colors.black87,
                          onTap: () => Navigator.pop(context, item.value),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );

          if (selected != null) {
            onChanged(selected);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
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
                            Text('1. Rentang Usia Orang Tua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Usia Ayah:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Text('${_fatherAgeRange.start.round()} - ${_fatherAgeRange.end.round()} Tahun', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ],
                            ),
                            RangeSlider(
                              values: _fatherAgeRange, min: 20, max: 80, divisions: 60,
                              labels: RangeLabels('${_fatherAgeRange.start.round()}', '${_fatherAgeRange.end.round()}'),
                              onChanged: (values) => setState(() => _fatherAgeRange = values),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Usia Ibu:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Text('${_motherAgeRange.start.round()} - ${_motherAgeRange.end.round()} Tahun', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ],
                            ),
                            RangeSlider(
                              values: _motherAgeRange, min: 15, max: 65, divisions: 50,
                              labels: RangeLabels('${_motherAgeRange.start.round()}', '${_motherAgeRange.end.round()}'),
                              onChanged: (values) => setState(() => _motherAgeRange = values),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 2: Urutan Kelahiran & Pilihan Saudara
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
                            Text('2. Urutan Kelahiran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                            const SizedBox(height: 16),
                            _buildModernDropdown<int>(
                              label: 'Saya adalah anak ke-',
                              value: _birthOrder,
                              items: const [
                                DropdownMenuItem(value: 1, child: Text('1 (Anak Pertama / Tunggal)')),
                                DropdownMenuItem(value: 2, child: Text('2')),
                                DropdownMenuItem(value: 3, child: Text('3')),
                                DropdownMenuItem(value: 4, child: Text('4')),
                                DropdownMenuItem(value: 5, child: Text('5 (atau lebih)')),
                              ],
                              onChanged: _onBirthOrderChanged,
                            ),
                            _buildModernDropdown<String>(
                              label: 'Saudara Kandung',
                              value: _siblingOption,
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

                    // CARD 3: Detail Saudara Kandung
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
                              Text('3. Detail Saudara Kandung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                              const SizedBox(height: 16),
                              if (hasKakak) ...[
                                Text('Jumlah Kakak (Harus ${_birthOrder - 1} Orang):', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black54)),
                                const SizedBox(height: 8),
                                _buildCounterRow(context: context, label: 'Kakak Laki-laki', value: _kakakLakiCount, onChanged: (val) {
                                  setState(() {
                                    _kakakLakiCount = val;
                                    final int maxK = _birthOrder - 1;
                                    if (_kakakLakiCount + _kakakPerempuanCount > maxK) { _kakakPerempuanCount = maxK - _kakakLakiCount; }
                                  });
                                }),
                                _buildCounterRow(context: context, label: 'Kakak Perempuan', value: _kakakPerempuanCount, onChanged: (val) {
                                  setState(() {
                                    _kakakPerempuanCount = val;
                                    final int maxK = _birthOrder - 1;
                                    if (_kakakLakiCount + _kakakPerempuanCount > maxK) { _kakakLakiCount = maxK - _kakakPerempuanCount; }
                                  });
                                }),
                                const Divider(height: 24, color: Colors.grey),
                              ],
                              if (hasAdik) ...[
                                Text('Jumlah Adik:', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black54)),
                                const SizedBox(height: 8),
                                _buildCounterRow(context: context, label: 'Adik Laki-laki', value: _adikLakiCount, onChanged: (val) => setState(() => _adikLakiCount = val)),
                                _buildCounterRow(context: context, label: 'Adik Perempuan', value: _adikPerempuanCount, onChanged: (val) => setState(() => _adikPerempuanCount = val)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // CARD 4: Status Ekonomi & Pekerjaan Orang Tua
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
                            Text('4. Status Ekonomi & Pekerjaan Orang Tua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                            const SizedBox(height: 16),
                            _buildModernDropdown<String>(
                              label: 'Status Ekonomi',
                              value: _economicStatus,
                              items: _economicOptions.map((option) => DropdownMenuItem(value: option['value'], child: Text(option['label']!))).toList(),
                              onChanged: (val) => setState(() => _economicStatus = val!),
                            ),
                            _buildModernDropdown<String>(
                              label: 'Pekerjaan Ayah',
                              value: _fatherJobOption,
                              items: _jobList.map((job) => DropdownMenuItem(value: job, child: Text(job))).toList(),
                              onChanged: (val) => setState(() => _fatherJobOption = val!),
                            ),
                            _buildModernDropdown<String>(
                              label: 'Pekerjaan Ibu',
                              value: _motherJobOption,
                              items: _jobList.map((job) => DropdownMenuItem(value: job, child: Text(job))).toList(),
                              onChanged: (val) => setState(() => _motherJobOption = val!),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 5: Hubungan Awal & Kesehatan Genetik
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
                            Text('5. Hubungan Awal & Kesehatan Genetik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                            const SizedBox(height: 16),
                            Text('Hubungan Awal dengan Orang Tua:', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                            Slider(
                              value: _initialRelationshipValue, min: 0, max: 100, divisions: 20,
                              label: '${_initialRelationshipValue.round()}%', activeColor: Colors.green,
                              onChanged: (val) => setState(() => _initialRelationshipValue = val),
                            ),
                            Text('${_initialRelationshipValue.round()}% (Semakin tinggi, semakin akrab)', style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey)),
                            const Divider(height: 24, color: Colors.grey),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Genetik Kesehatan Ayah:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Text('${_fatherHealthRange.start.round()} - ${_fatherHealthRange.end.round()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                              ],
                            ),
                            RangeSlider(
                              values: _fatherHealthRange, min: 10, max: 100, divisions: 18,
                              onChanged: (values) => setState(() => _fatherHealthRange = values),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Genetik Kesehatan Ibu:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Text('${_motherHealthRange.start.round()} - ${_motherHealthRange.end.round()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                              ],
                            ),
                            RangeSlider(
                              values: _motherHealthRange, min: 10, max: 100, divisions: 18,
                              onChanged: (values) => setState(() => _motherHealthRange = values),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('SELESAI & LAHIRKAN! 👶', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                width: 32, alignment: Alignment.center,
                child: Text('$value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
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