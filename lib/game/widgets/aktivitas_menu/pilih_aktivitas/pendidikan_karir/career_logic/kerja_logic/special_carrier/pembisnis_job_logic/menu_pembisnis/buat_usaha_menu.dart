// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/menu_pembisnis/buat_usaha_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class BuatUsahaMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BuatUsahaMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<BuatUsahaMenuPage> createState() => _BuatUsahaMenuPageState();
}

class _BuatUsahaMenuPageState extends State<BuatUsahaMenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedScaleIndex = 0;

  // Data Skala Usaha
  final List<Map<String, dynamic>> _scales = [
    {
      'name': 'Usaha Kecil (UMKM)',
      'icon': Icons.storefront,
      'color': Colors.green,
    },
    {
      'name': 'Usaha Menengah (Franchise)',
      'icon': Icons.apartment,
      'color': Colors.orange,
    },
    {
      'name': 'Usaha Besar (Startup / Korporasi)',
      'icon': Icons.rocket_launch,
      'color': Colors.purple,
    },
  ];

  // Master Template Jenis Usaha (Semua ditampilkan langsung secara lengkap)
  final List<List<Map<String, dynamic>>> _businessMasterTemplates = [
    // --- USAHA KECIL (UMKM) ---
    [
      {'name': 'Stand Gorengan & Jajanan Pasar', 'modal': 120, 'minIntel': 15, 'minHealth': 25, 'risk': 'Rendah', 'annualProfitVal': 30, 'annualProfitStr': '\$20 - \$50'},
      {'name': 'Toko Pulsa & Kuota Internet', 'modal': 230, 'minIntel': 20, 'minHealth': 20, 'risk': 'Rendah', 'annualProfitVal': 50, 'annualProfitStr': '\$35 - \$80'},
      {'name': 'Stand Minuman Boba & Jus', 'modal': 340, 'minIntel': 20, 'minHealth': 25, 'risk': 'Sedang', 'annualProfitVal': 80, 'annualProfitStr': '\$50 - \$120'},
      {'name': 'Jasa Penjahit Pakaian', 'modal': 420, 'minIntel': 25, 'minHealth': 30, 'risk': 'Rendah', 'annualProfitVal': 100, 'annualProfitStr': '\$60 - \$150'},
      {'name': 'Usaha Kerajinan Tangan', 'modal': 480, 'minIntel': 30, 'minHealth': 25, 'risk': 'Sedang', 'annualProfitVal': 120, 'annualProfitStr': '\$70 - \$180'},
      {'name': 'Warung Kelontong', 'modal': 570, 'minIntel': 20, 'minHealth': 30, 'risk': 'Rendah', 'annualProfitVal': 140, 'annualProfitStr': '\$80 - \$210'},
      {'name': 'Toko Online / Reseller', 'modal': 690, 'minIntel': 35, 'minHealth': 25, 'risk': 'Tinggi', 'annualProfitVal': 180, 'annualProfitStr': '\$100 - \$280'},
      {'name': 'Stand Martabak & Terang Bulan', 'modal': 780, 'minIntel': 25, 'minHealth': 30, 'risk': 'Sedang', 'annualProfitVal': 200, 'annualProfitStr': '\$120 - \$310'},
      {'name': 'Cucian Kilat (Laundry)', 'modal': 890, 'minIntel': 25, 'minHealth': 35, 'risk': 'Rendah', 'annualProfitVal': 230, 'annualProfitStr': '\$140 - \$350'},
      {'name': 'Barber Shop & Potong Rambut', 'modal': 980, 'minIntel': 30, 'minHealth': 30, 'risk': 'Rendah', 'annualProfitVal': 260, 'annualProfitStr': '\$160 - \$390'},
      {'name': 'Usaha Roti & Kue Basah', 'modal': 1150, 'minIntel': 30, 'minHealth': 35, 'risk': 'Sedang', 'annualProfitVal': 310, 'annualProfitStr': '\$190 - \$460'},
      {'name': 'Kedai Kopi Kekinian', 'modal': 1350, 'minIntel': 35, 'minHealth': 35, 'risk': 'Sedang', 'annualProfitVal': 360, 'annualProfitStr': '\$220 - \$540'},
      {'name': 'Usaha Cuci Motor & Mobil', 'modal': 1480, 'minIntel': 25, 'minHealth': 40, 'risk': 'Rendah', 'annualProfitVal': 400, 'annualProfitStr': '\$250 - \$590'},
      {'name': 'Service HP & Elektronik', 'modal': 1650, 'minIntel': 45, 'minHealth': 30, 'risk': 'Sedang', 'annualProfitVal': 450, 'annualProfitStr': '\$280 - \$660'},
      {'name': 'Rental Game & PS', 'modal': 1890, 'minIntel': 30, 'minHealth': 30, 'risk': 'Tinggi', 'annualProfitVal': 520, 'annualProfitStr': '\$320 - \$750'},
      {'name': 'Toko Bunga (Florist)', 'modal': 2150, 'minIntel': 35, 'minHealth': 30, 'risk': 'Sedang', 'annualProfitVal': 580, 'annualProfitStr': '\$360 - \$850'},
      {'name': 'Usaha Katering Rumahan', 'modal': 2380, 'minIntel': 35, 'minHealth': 40, 'risk': 'Rendah', 'annualProfitVal': 650, 'annualProfitStr': '\$400 - \$950'},
      {'name': 'Usaha Peternakan Rumahan', 'modal': 2750, 'minIntel': 30, 'minHealth': 45, 'risk': 'Tinggi', 'annualProfitVal': 750, 'annualProfitStr': '\$460 - \$1.100'},
    ],

    // --- USAHA MENENGAH (FRANCHISE / MENENGAH) ---
    [
      {'name': 'Studio Musik & Foto', 'modal': 4800, 'minIntel': 40, 'minHealth': 35, 'risk': 'Sedang', 'annualProfitVal': 1300, 'annualProfitStr': '\$800 - \$1.900'},
      {'name': 'Butik Fashion & Distro', 'modal': 6900, 'minIntel': 40, 'minHealth': 40, 'risk': 'Sedang', 'annualProfitVal': 1800, 'annualProfitStr': '\$1.100 - \$2.700'},
      {'name': 'Bimbel & Akademi Kursus', 'modal': 8200, 'minIntel': 55, 'minHealth': 35, 'risk': 'Rendah', 'annualProfitVal': 2200, 'annualProfitStr': '\$1.300 - \$3.200'},
      {'name': 'Pet Shop & Klinik Hewan', 'modal': 9800, 'minIntel': 45, 'minHealth': 40, 'risk': 'Rendah', 'annualProfitVal': 2600, 'annualProfitStr': '\$1.600 - \$3.800'},
      {'name': 'Toko Buku & Alat Tulis', 'modal': 11500, 'minIntel': 45, 'minHealth': 35, 'risk': 'Rendah', 'annualProfitVal': 3100, 'annualProfitStr': '\$1.900 - \$4.500'},
      {'name': 'Agensi Pemasaran Digital', 'modal': 14200, 'minIntel': 60, 'minHealth': 35, 'risk': 'Tinggi', 'annualProfitVal': 3900, 'annualProfitStr': '\$2.400 - \$5.600'},
      {'name': 'Salon Kecantikan & Spa', 'modal': 17500, 'minIntel': 45, 'minHealth': 40, 'risk': 'Sedang', 'annualProfitVal': 4800, 'annualProfitStr': '\$2.900 - \$6.900'},
      {'name': 'Bengkel Otomotif & Modifikasi', 'modal': 21000, 'minIntel': 45, 'minHealth': 45, 'risk': 'Rendah', 'annualProfitVal': 5700, 'annualProfitStr': '\$3.500 - \$8.300'},
      {'name': 'Restoran & Kafe Modern', 'modal': 26500, 'minIntel': 50, 'minHealth': 45, 'risk': 'Sedang', 'annualProfitVal': 7200, 'annualProfitStr': '\$4.400 - \$10.500'},
      {'name': 'Usaha Percetakan & Digital Printing', 'modal': 29500, 'minIntel': 50, 'minHealth': 40, 'risk': 'Rendah', 'annualProfitVal': 8000, 'annualProfitStr': '\$4.900 - \$11.600'},
      {'name': 'Minimarket Waralaba', 'modal': 33000, 'minIntel': 45, 'minHealth': 40, 'risk': 'Rendah', 'annualProfitVal': 9000, 'annualProfitStr': '\$5.500 - \$13.000'},
      {'name': 'Gym & Fitness Center', 'modal': 36500, 'minIntel': 45, 'minHealth': 50, 'risk': 'Sedang', 'annualProfitVal': 9900, 'annualProfitStr': '\$6.000 - \$14.400'},
      {'name': 'Perusahaan Security Outsourcing', 'modal': 39000, 'minIntel': 50, 'minHealth': 45, 'risk': 'Rendah', 'annualProfitVal': 10600, 'annualProfitStr': '\$6.500 - \$15.400'},
      {'name': 'Toko Bahan Bangunan', 'modal': 42500, 'minIntel': 45, 'minHealth': 45, 'risk': 'Rendah', 'annualProfitVal': 11500, 'annualProfitStr': '\$7.000 - \$16.800'},
      {'name': 'Klinik Kesehatan & Apotek', 'modal': 46800, 'minIntel': 65, 'minHealth': 40, 'risk': 'Rendah', 'annualProfitVal': 12800, 'annualProfitStr': '\$7.800 - \$18.500'},
      {'name': 'Dealer Sepeda Motor', 'modal': 52000, 'minIntel': 50, 'minHealth': 40, 'risk': 'Sedang', 'annualProfitVal': 14200, 'annualProfitStr': '\$8.600 - \$20.500'},
    ],

    // --- USAHA BESAR (STARTUP / KORPORASI) ---
    [
      {'name': 'Perusahaan AI & Software House', 'modal': 75000, 'minIntel': 75, 'minHealth': 40, 'risk': 'Tinggi', 'annualProfitVal': 21000, 'annualProfitStr': '\$12.500 - \$31.000'},
      {'name': 'Perusahaan Logistik & Ekspedisi', 'modal': 115000, 'minIntel': 65, 'minHealth': 45, 'risk': 'Rendah', 'annualProfitVal': 32000, 'annualProfitStr': '\$19.000 - \$47.000'},
      {'name': 'Bank Swasta & Financial Technology', 'modal': 185000, 'minIntel': 80, 'minHealth': 40, 'risk': 'Tinggi', 'annualProfitVal': 52000, 'annualProfitStr': '\$31.000 - \$76.000'},
      {'name': 'Stasiun Televisi & Media Nasional', 'modal': 290000, 'minIntel': 70, 'minHealth': 45, 'risk': 'Sedang', 'annualProfitVal': 81000, 'annualProfitStr': '\$48.000 - \$118.000'},
      {'name': 'Pabrik Manufaktur & Tekstil', 'modal': 420000, 'minIntel': 65, 'minHealth': 50, 'risk': 'Sedang', 'annualProfitVal': 118000, 'annualProfitStr': '\$70.000 - \$170.000'},
      {'name': 'Jaringan Rumah Sakit Swasta', 'modal': 580000, 'minIntel': 75, 'minHealth': 50, 'risk': 'Rendah', 'annualProfitVal': 162000, 'annualProfitStr': '\$96.000 - \$235.000'},
      {'name': 'Jaringan Hypermarket & Mall', 'modal': 770000, 'minIntel': 70, 'minHealth': 50, 'risk': 'Sedang', 'annualProfitVal': 215000, 'annualProfitStr': '\$128.000 - \$310.000'},
      {'name': 'Industri Farmasi & Bioteknologi', 'modal': 950000, 'minIntel': 85, 'minHealth': 45, 'risk': 'Rendah', 'annualProfitVal': 265000, 'annualProfitStr': '\$158.000 - \$380.000'},
      {'name': 'Perusahaan Properti & Real Estate', 'modal': 1200000, 'minIntel': 75, 'minHealth': 50, 'risk': 'Tinggi', 'annualProfitVal': 335000, 'annualProfitStr': '\$200.000 - \$480.000'},
      {'name': 'Jaringan Hotel & Resort Bintang 5', 'modal': 1480000, 'minIntel': 70, 'minHealth': 50, 'risk': 'Sedang', 'annualProfitVal': 415000, 'annualProfitStr': '\$245.000 - \$590.000'},
      {'name': 'Pabrik Kendaraan Listrik', 'modal': 1950000, 'minIntel': 80, 'minHealth': 50, 'risk': 'Tinggi', 'annualProfitVal': 545000, 'annualProfitStr': '\$325.000 - \$780.000'},
      {'name': 'Maskapai Penerbangan Swasta', 'modal': 2450000, 'minIntel': 80, 'minHealth': 55, 'risk': 'Tinggi', 'annualProfitVal': 685000, 'annualProfitStr': '\$410.000 - \$980.000'},
      {'name': 'Perusahaan Tambang & Energi', 'modal': 3150000, 'minIntel': 75, 'minHealth': 55, 'risk': 'Tinggi', 'annualProfitVal': 880000, 'annualProfitStr': '\$525.000 - \$1.260.000'},
      {'name': 'Perusahaan Galangan Kapal', 'modal': 4250000, 'minIntel': 80, 'minHealth': 55, 'risk': 'Sedang', 'annualProfitVal': 1190000, 'annualProfitStr': '\$710.000 - \$1.700.000'},
      {'name': 'Perusahaan Antariksa & Satelit Swasta', 'modal': 5500000, 'minIntel': 90, 'minHealth': 55, 'risk': 'Tinggi', 'annualProfitVal': 1540000, 'annualProfitStr': '\$920.000 - \$2.200.000'},
    ],
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    return CurrencySettings.format(amount.toDouble());
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'Rendah':
        return Colors.green;
      case 'Sedang':
        return Colors.amber.shade800;
      case 'Tinggi':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showBusinessDetail(Map<String, dynamic> businessItem) {
    final String businessType = businessItem['name'] as String;
    final int modal = businessItem['modal'] as int;
    final int annualProfitVal = businessItem['annualProfitVal'] as int;
    final int minIntel = businessItem['minIntel'] as int;
    final int minHealth = businessItem['minHealth'] as int;
    final String risk = (businessItem['risk'] ?? 'Sedang') as String;
    final Color riskColor = _getRiskColor(risk);

    // Format tampilan profit sesuai CurrencySettings
    final int minProfitVal = (annualProfitVal * 0.7).round();
    final int maxProfitVal = (annualProfitVal * 1.3).round();
    final String profitFormattedStr = '${_formatCurrency(minProfitVal)} - ${_formatCurrency(maxProfitVal)}';

    if (widget.character.money < modal) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Modal Tidak Cukup 💸'),
          content: Text('Kamu membutuhkan ${_formatCurrency(modal)} untuk memulai $businessType. Uangmu saat ini hanya ${_formatCurrency(widget.character.money)}.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    if (widget.character.intelligence < minIntel) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kecerdasan Kurang 🧠'),
          content: Text('Kamu membutuhkan Kecerdasan minimal $minIntel untuk mengelola $businessType. Tingkatkan dulu Kecerdasanmu!'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    if (widget.character.health < minHealth) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kesehatan Kurang 💪'),
          content: Text('Kamu membutuhkan Kesehatan minimal $minHealth untuk menjalankan $businessType. Istirahat dan berolahragalah!'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController nameController = TextEditingController(text: businessType);
        String selectedLocation = widget.character.location.isNotEmpty 
            ? widget.character.location 
            : (widget.character.birthCountry ?? 'Indonesia');

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Mulai $businessType 💼'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Modal: ${_formatCurrency(modal)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: riskColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: riskColor),
                                ),
                                child: Text(
                                  'Risiko $risk',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: riskColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Estimasi Keuntungan: $profitFormattedStr / thn', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text('Syarat: Intel > $minIntel, Health > $minHealth', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama Usaha', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedLocation,
                      decoration: const InputDecoration(labelText: 'Lokasi Usaha', border: OutlineInputBorder()),
                      items: [selectedLocation, 'Jakarta', 'New York', 'Tokyo', 'Seoul', 'London']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedLocation = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () {
                    // Proses Pembelian & Pendaftaran Keuntungan Tahunan
                    widget.character.money -= modal;
                    widget.character.businessName = nameController.text;
                    widget.character.businessLocation = selectedLocation;
                    widget.character.hasBusiness = true;
                    widget.character.businessModal = modal;
                    widget.character.businessAnnualProfit = annualProfitVal;
                    widget.character.jobName = 'Pemilik Usaha ($businessType)';

                    if (mounted) setState(() {});
                    Navigator.pop(ctx); // Close dialog
                    widget.onRefresh();

                    // Dialog Sukses
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Usaha Berhasil Didirikan! 🎉'),
                        content: Text(
                          'Selamat! $businessType ("${nameController.text}") di $selectedLocation telah resmi menjadi bisnismu.\n\nKeuntungan sekitar ${_formatCurrency(annualProfitVal)}/tahun akan masuk ke saldo keuangannmu setiap bertambah usia!',
                        ),
                        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                      ),
                    );
                  },
                  child: const Text('Bayar & Mulai'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = _scales[_selectedScaleIndex];

    // Filter daftar usaha berdasarkan skala yang dipilih dan pencarian kata kunci
    final List<Map<String, dynamic>> rawList = _businessMasterTemplates[_selectedScaleIndex];
    final List<Map<String, dynamic>> filteredList = rawList.where((item) {
      if (_searchQuery.isEmpty) return true;
      final String name = item['name'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Usaha & Ide Bisnis 💡'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Kartu Saldo Modal
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.green, size: 26),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Modal Kamu', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey)),
                            Text(
                              _formatCurrency(widget.character.money),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown Skala Usaha
                DropdownButtonFormField<int>(
                  initialValue: _selectedScaleIndex,
                  dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Skala Usaha',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  items: _scales.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Row(
                        children: [
                          Icon(entry.value['icon'], color: entry.value['color'], size: 18),
                          const SizedBox(width: 8),
                          Text(entry.value['name'] as String),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedScaleIndex = val);
                  },
                ),
                const SizedBox(height: 10),

                // Search TextField (Samakan persis dengan Pekerjaan Umum)
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari Usaha & Ide Bisnis...',
                    hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 20, color: isDark ? Colors.white70 : Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Sub-header Hasil
          if (filteredList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Usaha (${filteredList.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                  if (_searchQuery.isNotEmpty)
                    Text(
                      'Filter: "$_searchQuery"',
                      style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                    ),
                ],
              ),
            ),

          // List Usaha dengan layout Card & ListTile persis Pekerjaan Umum
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white38 : Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ditemukan usaha dengan kata kunci "$_searchQuery"',
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final String name = item['name'] as String;
                      final int modal = item['modal'] as int;
                      final int annualProfitVal = item['annualProfitVal'] as int;
                      final int minIntel = item['minIntel'] as int;
                      final int minHealth = item['minHealth'] as int;
                      final String risk = (item['risk'] ?? 'Sedang') as String;
                      final Color riskColor = _getRiskColor(risk);

                      final bool canAfford = widget.character.money >= modal;
                      final bool meetsIntel = widget.character.intelligence >= minIntel;
                      final bool meetsHealth = widget.character.health >= minHealth;
                      final bool isQualified = canAfford && meetsIntel && meetsHealth;

                      final int minProfitVal = (annualProfitVal * 0.7).round();
                      final int maxProfitVal = (annualProfitVal * 1.3).round();
                      final String profitFormattedStr =
                          '${_formatCurrency(minProfitVal)} - ${_formatCurrency(maxProfitVal)}';

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                        ),
                        color: isDark ? Colors.grey.shade800 : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: (scale['color'] as Color).withValues(alpha: 0.1),
                            child: Icon(scale['icon'] as IconData, color: scale['color']),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Modal: ${_formatCurrency(modal)} • Profit: $profitFormattedStr / thn',
                                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: riskColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: riskColor, width: 0.8),
                                    ),
                                    child: Text(
                                      'Risiko $risk',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: riskColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Min Intel: $minIntel% • Health: $minHealth%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.white60 : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isQualified ? Colors.green.shade600 : Colors.grey.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _showBusinessDetail(item),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isQualified) ...[
                                  const Icon(Icons.lock, size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  isQualified ? 'Mulai' : 'Terkunci',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => _showBusinessDetail(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
