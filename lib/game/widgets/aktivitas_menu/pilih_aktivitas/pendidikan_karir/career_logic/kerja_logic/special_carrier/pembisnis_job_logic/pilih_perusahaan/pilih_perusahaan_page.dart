// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/pembisnis_job_logic/pilih_perusahaan/pilih_perusahaan_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../menu_pembisnis/buat_usaha_menu.dart';
import '../pembisnis_menu.dart';

class PilihPerusahaanPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PilihPerusahaanPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PilihPerusahaanPage> createState() => _PilihPerusahaanPageState();
}

class _PilihPerusahaanPageState extends State<PilihPerusahaanPage> {
  Character get character => widget.character;

  @override
  void initState() {
    super.initState();
    character.syncBusinessData();
  }

  String _formatCurrency(int amount) => CurrencySettings.format(amount.toDouble());

  String _getBusinessScaleLabel(int modal) {
    if (modal >= 70000) {
      return 'Usaha Besar (Korporasi / Startup) 🚀';
    } else if (modal >= 4000) {
      return 'Usaha Menengah (Franchise) 🏢';
    }
    return 'Usaha Kecil (UMKM) 🏪';
  }

  Color _getBusinessScaleColor(int modal) {
    if (modal >= 70000) {
      return Colors.purple;
    } else if (modal >= 4000) {
      return Colors.orange.shade800;
    }
    return Colors.green.shade700;
  }

  void _selectAndEnterBusiness(Map<String, dynamic> businessData) {
    character.setActiveBusiness(businessData);
    setState(() {});
    widget.onRefresh();

    final Widget rolePage = PembisnisMenuHelper.getSpecificRolePage(character, widget.onRefresh);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => rolePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    character.syncBusinessData();
    final List<Map<String, dynamic>> list = character.ownedBusinesses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Perusahaan & Agensi 🏢', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: Column(
        children: [
          // Sub-header petunjuk
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.business_center, color: Colors.green, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portofolio Bisnis Kamu (${list.length} Perusahaan)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pilih agensi atau perusahaan yang ingin kamu kelola hari ini:',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Daftar Perusahaan Milik User
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.storefront_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Kamu belum memiliki bisnis aktif',
                          style: TextStyle(fontSize: 15, color: isDark ? Colors.white60 : Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final String name = item['name'] ?? 'Perusahaan Tanpa Nama';
                      final String location = item['location'] ?? 'Indonesia';
                      final int modal = (item['modal'] as num?)?.toInt() ?? 0;
                      final int profit = (item['annualProfit'] as num?)?.toInt() ?? 0;
                      final String scaleLabel = _getBusinessScaleLabel(modal);
                      final Color scaleColor = _getBusinessScaleColor(modal);

                      final bool isActive = character.businessName == name;

                      return Card(
                        elevation: isActive ? 3 : 1,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isActive ? Colors.green : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                            width: isActive ? 2 : 1,
                          ),
                        ),
                        color: isDark ? Colors.grey.shade800 : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: scaleColor.withValues(alpha: 0.15),
                                    child: Icon(Icons.domain, color: scaleColor),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: isDark ? Colors.white : Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isActive)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade100,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  'AKTIF 🟢',
                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Lokasi: $location',
                                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildStat('Skala Usaha', scaleLabel, scaleColor, isDark),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStat('Modal Usaha', _formatCurrency(modal), Colors.blue, isDark),
                                      _buildStat('Profit / Tahun', _formatCurrency(profit), Colors.green, isDark),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: scaleColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () => _selectAndEnterBusiness(item),
                                  icon: const Icon(Icons.login, size: 18),
                                  label: const Text('Masuki & Kelola Perusahaan', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Tombol Buka Perusahaan Baru
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.green.shade700, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuatUsahaMenuPage(character: character, onRefresh: widget.onRefresh),
                    ),
                  );
                },
                icon: const Icon(Icons.add_business, color: Colors.green),
                label: const Text(
                  '+ Buka Perusahaan / Agensi Baru',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String val, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
