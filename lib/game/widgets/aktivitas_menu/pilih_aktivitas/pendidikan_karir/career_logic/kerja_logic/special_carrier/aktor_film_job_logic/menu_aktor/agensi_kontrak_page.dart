// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/aktor_film_job_logic/menu_aktor/agensi_kontrak_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

import 'package:mylifesim/game/widgets/dialog_helper.dart';

class AgensiKontrakPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AgensiKontrakPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AgensiKontrakPage> createState() => _AgensiKontrakPageState();
}

class _AgensiKontrakPageState extends State<AgensiKontrakPage> {
  void _showAlert(String title, String desc) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(desc, style: const TextStyle(fontSize: 13)),
    );
  }

  void _rekrutManajer(String agencyName, int bonusSalary) {
    widget.character.jobSalary = (widget.character.jobSalary ?? 10000000) + bonusSalary;
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Kontrak Agen Aktor Disepakati! 🤝',
      'Kamu resmi dinaungi oleh $agencyName!\n\n'
      '• Tambahan Nilai Fee Per Film: +${CurrencySettings.format(bonusSalary.toDouble())}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Agen & Kontrak 💼'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.business_center, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gaji Per Film Saat Ini', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(CurrencySettings.format((widget.character.jobSalary ?? 0).toDouble()), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.indigo.shade900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text('Pilihan Agensi Bakat Perfilman 🏢', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildAgencyCard('Hollywood Talent Agency (CAA / WME) 🌟', 'Agensi kelas dunia untuk proyek film internasional', 200000, isDark),
          _buildAgencyCard('Asia Star Management 🌏', 'Agensi perfilman terkemuka tingkat regional', 100000, isDark),
          _buildAgencyCard('Indie Actor Circle 🎬', 'Agensi independen penyuplai film festival', 50000, isDark),
        ],
      ),
    );
  }

  Widget _buildAgencyCard(String title, String desc, int bonusSalary, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.star, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700, foregroundColor: Colors.white),
          onPressed: () => _rekrutManajer(title, bonusSalary),
          child: const Text('Gabung', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
