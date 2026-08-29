import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'menu_dokter/dokter_utils.dart';
import 'menu_dokter/pemeriksaan_umum/pemeriksaan_umum_page.dart';
import 'menu_dokter/tes_darah/tes_darah_page.dart';
import 'menu_dokter/medical_checkup/medical_checkup_page.dart';

class RiwayatPenyakitPage extends StatefulWidget {
  final Character character;
  const RiwayatPenyakitPage({super.key, required this.character});

  @override
  State<RiwayatPenyakitPage> createState() => _RiwayatPenyakitPageState();
}

class _RiwayatPenyakitPageState extends State<RiwayatPenyakitPage> {
  static const int costPerTreatment = 150;

  void _treatDisease(String diseaseName) {
    if (widget.character.money < costPerTreatment) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Saldo Kurang 💸'),
          content: const Text('Kamu tidak memiliki cukup uang untuk membayar biaya pengobatan sebesar $costPerTreatment.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
      return;
    }

    // Tentukan kategori keparahan penyakit untuk menentukan tingkat keberhasilan pengobatan
    int successRate = 75; // Default Sedang: 75%
    String categoryName = 'Sedang';

    // Penyakit Ringan (Peluang Sembuh: 90%)
    final List<String> ringanList = [
      'flu', 'sakit kepala', 'batuk', 'alergi', 'sakit gigi', 'pusing', 'diare', 
      'lecet', 'robekan kecil', 'kram', 'iritasi overstimulasi', 'luka mikro', 'dehidrasi'
    ];
    // Penyakit Berat (Peluang Sembuh: 45%)
    final List<String> beratList = [
      'pneumonia berat', 'stroke', 'serangan jantung', 'ginjal', 'kanker', 
      'meningitis', 'tuberkulosis', 'tbc', 'pankreatitis', 'hiv', 'aids', 'cedera jaringan', 'laserasi'
    ];

    final String nameLower = diseaseName.toLowerCase();
    if (ringanList.any((key) => nameLower.contains(key))) {
      successRate = 90;
      categoryName = 'Ringan';
    } else if (beratList.any((key) => nameLower.contains(key))) {
      successRate = 45;
      categoryName = 'Berat';
    }

    final random = Random();
    final bool isSuccess = random.nextInt(100) < successRate;

    // Potong biaya pengobatan terlebih dahulu
    setState(() {
      widget.character.money -= costPerTreatment;
    });

    if (isSuccess) {
      setState(() {
        // Hapus dari daftar riwayat penyakit aktif
        widget.character.riwayatPenyakit.remove(diseaseName);
        
        // Sembuhkan flag spesifik jika ada
        if (diseaseName.contains('HIV')) {
          widget.character.hasHIV = false;
        } else if (diseaseName.contains('Sifilis')) {
          widget.character.hasSifilis = false;
        } else if (diseaseName.contains('HPV')) {
          widget.character.hasHPV = false;
        }

        // Tambah kesehatan
        widget.character.health = (widget.character.health + 25).clamp(0, 100);
        widget.character.inbox.add('🏥 Pengobatan: Kamu telah sembuh dari $diseaseName (-$costPerTreatment uang, +25% Kesehatan)');
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pengobatan Berhasil 🎉'),
          content: Text('Dokter berhasil mengobati penyakitmu ($diseaseName).\nKesehatanmu meningkat +25% (\$150 uang berkurang).'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Bagus'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        widget.character.inbox.add('🏥 Pengobatan Gagal: Upaya mengobati $diseaseName gagal (-$costPerTreatment uang)');
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pengobatan Gagal 😔'),
          content: Text('Dokter telah berusaha semaksimal mungkin, namun penyakitmu ($diseaseName) belum berhasil disembuhkan.\nBiaya pengobatan sebesar \$150 tetap ditagihkan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeDiseases = widget.character.riwayatPenyakit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Penyakit Anda', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: \$${DokterUtils.fmt(widget.character.money)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: activeDiseases.isEmpty
                  ? const Center(
                      child: Text(
                        'kamu sehat',
                        textAlign: CenterTextAlignment,
                        style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: activeDiseases.length,
                      itemBuilder: (context, index) {
                        final disease = activeDiseases[index];
                        final costData = DokterUtils.getDiseaseCostAndSuccessRate(disease);
                        final int cost = costData['cost'] ?? 150;
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              disease,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                            ),
                            subtitle: Text(
                              'Harus diobati via: ${DokterUtils.getRequiredMenu(disease)}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                final menu = DokterUtils.getRequiredMenu(disease);
                                if (menu == 'Pemeriksaan Umum') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (ctx) => PemeriksaanUmumPage(character: widget.character)),
                                  ).then((_) => setState(() {}));
                                } else if (menu == 'Tes Darah') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (ctx) => TesDarahPage(character: widget.character)),
                                  ).then((_) => setState(() {}));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (ctx) => MedicalCheckupPage(character: widget.character)),
                                  ).then((_) => setState(() {}));
                                }
                              },
                              child: Text('Obati (\$${DokterUtils.fmt(cost)})'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
const CenterTextAlignment = TextAlign.center;
