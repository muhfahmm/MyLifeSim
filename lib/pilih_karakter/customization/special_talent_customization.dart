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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        title: Text(
          'Talenta Spesial',
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                'Pilih talenta spesial karaktermu',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                itemCount: _talents.length,
                itemBuilder: (context, index) {
                  final talent = _talents[index];
                  final isSelected = _selectedTalent == talent['name'];
                  
                  final Color borderColor = isSelected
                      ? Colors.orange
                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade200);
                  final Color cardColor = isSelected
                      ? Colors.orange.withValues(alpha: 0.08)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade50);
                  final Color titleColor = isSelected
                      ? Colors.orange.shade800
                      : (isDark ? Colors.white : Colors.black87);
                  final Color trailingColor = isSelected
                      ? Colors.orange
                      : (isDark ? Colors.white54 : Colors.grey.shade400);

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: borderColor,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    color: cardColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Text(
                            talent['emoji']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            talent['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.orange)
                              : Icon(Icons.circle_outlined, color: trailingColor),
                          onTap: () {
                            setState(() {
                              _selectedTalent = talent['name']!;
                            });
                          },
                        ),
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 12, color: Colors.orange),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                                    children: [
                                      const TextSpan(text: '✨ Pengaruh Utama: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: _getTalentEffect(talent['name']!)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                                    children: [
                                      const TextSpan(text: '🌟 Sinergi Atribut: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: _getTalentSynergy(talent['name']!)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                                    children: [
                                      const TextSpan(text: '💼 Rekomendasi Karier: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: _getTalentCareer(talent['name']!)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.red.shade300 : Colors.red.shade700),
                                    children: [
                                      const TextSpan(text: '⚠️ Risiko: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: _getTalentRisk(talent['name']!)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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

  String _getTalentSynergy(String name) {
    switch (name) {
      case 'Tidak Ada': return '-';
      case 'Akting': return 'Penampilan (tinggi), Kecerdasan (sedang), Kebahagiaan';
      case 'Kriminalitas': return 'Kecerdasan (tinggi), Disiplin (sedang)';
      case 'Pengedar': return 'Tekad (sangat tinggi), Disiplin (tinggi), Kesehatan (turun)';
      case 'Modeling': return 'Penampilan (sangat ekstrem), Kesehatan (tinggi)';
      case 'Musik': return 'Kecerdasan (kreativitas), Kebahagiaan, Disiplin';
      case 'Olahraga': return 'Kesehatan (sangat tinggi), Tekad (sangat tinggi), Disiplin (tinggi)';
      default: return '-';
    }
  }

  String _getTalentEffect(String name) {
    switch (name) {
      case 'Tidak Ada': return 'Tidak ada buff atau debuff. Semua event berjalan normal sesuai atribut dasar.';
      case 'Akting': return 'Kemampuan berbohong, berpura-pura, dan memanipulasi jauh lebih berhasil (peluang sukses +30%). Lebih mudah meyakinkan orang saat wawancara kerja.';
      case 'Kriminalitas': return 'Peluang sukses saat mencuri, merampok, menipu, atau meretas sangat tinggi. Saat tertangkap, kamu lebih pintar menghilangkan barang bukti atau lolos dari hukuman.';
      case 'Pengedar': return 'Sangat ahli dalam jaringan bisnis gelap. Kamu akan lebih sering mendapat tawaran menguntungkan dari orang asing dan lebih cepat membangun "kerajaan" ilegal.';
      case 'Modeling': return 'Kamu mendapatkan bonus Penampilan pasif (misalnya +10 di atas nilai slider). Setiap kali ada kontes kecantikan, casting iklan, atau event sosial, kamu hampir selalu menang.';
      case 'Musik': return 'Kamu sangat cepat belajar alat musik. Saat ada event "Ikut band sekolah", peluang suksesmu sangat tinggi. Lagu yang kamu ciptakan lebih sering menjadi hits.';
      case 'Olahraga': return 'Stamina dan kemampuan fisik kamu berada di atas rata-rata. Kamu sangat jarang cedera saat berolahraga, dan selalu menang dalam kompetisi fisik.';
      default: return '-';
    }
  }

  String _getTalentCareer(String name) {
    switch (name) {
      case 'Tidak Ada': return 'Semua lowongan pekerjaan dasar hingga profesional terbuka normal tanpa bonus.';
      case 'Akting': return 'Content Creator, Sutradara Film, Marketing Specialist, Pengacara, dan Penerjemah.';
      case 'Kriminalitas': return 'Junior Software Engineer (hacker), Network Engineer, Pengacara (celah hukum), Jaksa, dan Manajer Keuangan (penggelapan).';
      case 'Pengedar': return 'Manajer Hotel, CEO Startup, PNS (jalur suap), dan Pengacara.';
      case 'Modeling': return 'Fotografer, Content Creator, Desainer Mode, Marketing Specialist, Dokter Umum/Spesialis, dan Pilot.';
      case 'Musik': return 'Musisi Jalanan, Produser Musik, Content Creator, Guru (seni musik), Sutradara Film (soundtrack), dan CEO Startup.';
      case 'Olahraga': return 'Satpam, Kurir, Buruh Pabrik, Tukang Las, dan Pilot.';
      default: return '-';
    }
  }

  String _getTalentRisk(String name) {
    switch (name) {
      case 'Tidak Ada': return 'Cocok untuk hardcore mode tanpa bantuan.';
      case 'Akting': return 'Jika sering dipakai untuk menipu, hubungan pertemanan/keluarga bisa hancur.';
      case 'Kriminalitas': return 'Hukuman penjara cenderung lebih berat dan sering diincar polisi.';
      case 'Pengedar': return 'Risiko dipenjara sangat tinggi, sering diserang musuh, dan kesehatan bisa rusak permanen jika ikut mengonsumsi.';
      case 'Modeling': return 'Sangat sensitif terhadap penuaan, karier langsung hancur dan gaji turun drastis.';
      case 'Musik': return 'Butuh waktu lama untuk tenar, dan seringkali harus mengalami fase "miskin" sebelum kontrak rekaman besar.';
      case 'Olahraga': return 'Umur karier pendek. Setelah pensiun (usia 35-40 tahun), harus memiliki rencana cadangan agar tidak jatuh miskin.';
      default: return '-';
    }
  }
}