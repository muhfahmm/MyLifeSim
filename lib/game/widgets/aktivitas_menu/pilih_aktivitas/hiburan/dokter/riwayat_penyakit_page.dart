import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'menu_dokter/dokter_utils.dart';
import 'menu_dokter/pemeriksaan_umum/pemeriksaan_umum_page.dart';
import 'menu_dokter/tes_darah/tes_darah_page.dart';
import 'menu_dokter/medical_checkup/medical_checkup_page.dart';

class RiwayatPenyakitPage extends StatefulWidget {
  final Character character;
  final VoidCallback? onComplete;
  const RiwayatPenyakitPage({super.key, required this.character, this.onComplete});

  @override
  State<RiwayatPenyakitPage> createState() => _RiwayatPenyakitPageState();
}

class _RiwayatPenyakitPageState extends State<RiwayatPenyakitPage> {
  static const int costPerTreatment = 150;

  void _treatDisease(String diseaseName) {
    if (widget.character.money < costPerTreatment) {
      showDialog(
        context: context,
        builder: (ctx) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Text('Saldo Kurang 💸', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text('Kamu tidak memiliki cukup uang untuk membayar biaya pengobatan sebesar $costPerTreatment.', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Mengerti', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          );
        },
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
        widget.onComplete?.call();
      });

      showDialog(
        context: context,
        builder: (ctx) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Text('Pengobatan Berhasil 🎉', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text('Dokter berhasil mengobati penyakitmu ($diseaseName).\nKesehatanmu meningkat +25% (\$150 uang berkurang).', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Bagus', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        widget.character.inbox.add('🏥 Pengobatan Gagal: Upaya mengobati $diseaseName gagal (-$costPerTreatment uang)');
      });

      showDialog(
        context: context,
        builder: (ctx) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Text('Pengobatan Gagal 😔', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text('Dokter telah berusaha semaksimal mungkin, namun penyakitmu ($diseaseName) belum berhasil disembuhkan.\nBiaya pengobatan sebesar \$150 tetap ditagihkan.', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Mengerti', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          );
        },
      );
    }
  }

  void _treatAllDiseases() {
    final activeDiseases = List<String>.from(widget.character.riwayatPenyakit);
    if (activeDiseases.isEmpty) return;

    int totalCost = 0;
    for (var disease in activeDiseases) {
      final costData = DokterUtils.getDiseaseCostAndSuccessRate(disease);
      totalCost += (costData['cost'] as int? ?? 150);
    }

    if (widget.character.money < totalCost) {
      // Cari orang tua yang bisa dimintai uang
      final character = widget.character;
      bool isFatherAvailable = character.fatherName != null && !character.isFatherDeceased && !character.isFatherImprisoned;
      bool isMotherAvailable = character.motherName != null && !character.isMotherDeceased && !character.isMotherImprisoned;
      bool areParentsTogether = isFatherAvailable && isMotherAvailable && !character.isFatherDivorced && !character.isMotherDivorced;

      String parentRelation = 'Orang Tua';
      int parentRelationship = 50;
      bool hasParent = false;

      if (areParentsTogether) {
        hasParent = true;
        parentRelation = 'Orang Tua';
        parentRelationship = (((character.fatherRelationship ?? 50) + (character.motherRelationship ?? 50)) / 2).round();
      } else {
        String? chosenName;
        if (isFatherAvailable) {
          chosenName = character.fatherName;
          parentRelation = 'Ayah';
          parentRelationship = character.fatherRelationship ?? 50;
          hasParent = true;
        }
        if (isMotherAvailable) {
          final int motherRel = character.motherRelationship ?? 50;
          if (chosenName == null || motherRel > parentRelationship) {
            chosenName = character.motherName;
            parentRelation = 'Ibu';
            parentRelationship = motherRel;
            hasParent = true;
          }
        }
        if (character.stepFatherName != null && !character.isStepFatherDeceased) {
          final int stepFatherRel = character.stepFatherRelationship ?? 50;
          if (chosenName == null || stepFatherRel > parentRelationship) {
            chosenName = character.stepFatherName;
            parentRelation = 'Ayah Tiri';
            parentRelationship = stepFatherRel;
            hasParent = true;
          }
        }
        if (character.stepMotherName != null && !character.isStepMotherDeceased) {
          final int stepMotherRel = character.stepMotherRelationship ?? 50;
          if (chosenName == null || stepMotherRel > parentRelationship) {
            chosenName = character.stepMotherName;
            parentRelation = 'Ibu Tiri';
            parentRelationship = stepMotherRel;
            hasParent = true;
          }
        }
      }

      showDialog(
        context: context,
        builder: (ctx) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Text('Saldo Kurang 💸', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text('Kamu tidak memiliki cukup uang untuk mengobati semua penyakit sekaligus.\nTotal Biaya: \$${DokterUtils.fmt(totalCost)}\nSaldo Kamu: \$${DokterUtils.fmt(widget.character.money)}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            actions: [
              if (hasParent)
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _askParentsToPay(parentRelation, parentRelationship, totalCost);
                  },
                  child: Text('Minta ke $parentRelation 👨‍👩‍👧', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Mengerti', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          );
        },
      );
      return;
    }

    // Process all treatments
    int curedCount = 0;
    int failedCount = 0;
    final random = Random();

    setState(() {
      widget.character.money -= totalCost;
      
      final List<String> curedDiseases = [];
      for (var disease in activeDiseases) {
        final costData = DokterUtils.getDiseaseCostAndSuccessRate(disease);
        final int successRate = costData['successRate'] ?? 75;

        // Determine rate
        int rate = successRate;
        final String nameLower = disease.toLowerCase();
        final List<String> ringanList = [
          'flu', 'sakit kepala', 'batuk', 'alergi', 'sakit gigi', 'pusing', 'diare', 
          'lecet', 'robekan kecil', 'kram', 'iritasi overstimulasi', 'luka mikro', 'dehidrasi'
        ];
        final List<String> beratList = [
          'pneumonia berat', 'stroke', 'serangan jantung', 'ginjal', 'kanker', 
          'meningitis', 'tuberkulosis', 'tbc', 'pankreatitis', 'hiv', 'aids', 'cedera jaringan', 'laserasi'
        ];
        if (ringanList.any((key) => nameLower.contains(key))) {
          rate = 90;
        } else if (beratList.any((key) => nameLower.contains(key))) {
          rate = 45;
        }

        final bool isSuccess = random.nextInt(100) < rate;
        if (isSuccess) {
          widget.character.riwayatPenyakit.remove(disease);
          curedDiseases.add(disease);
          curedCount++;
          final int hapGain = DokterUtils.getHappinessGainOnCured(disease);
          widget.character.happiness = (widget.character.happiness + hapGain).clamp(0, 100);

          if (disease.contains('HIV')) {
            widget.character.hasHIV = false;
          } else if (disease.contains('Sifilis')) {
            widget.character.hasSifilis = false;
          } else if (disease.contains('HPV')) {
            widget.character.hasHPV = false;
          }
        } else {
          failedCount++;
        }
      }

      // Add stats health increment
      if (curedCount > 0) {
        widget.character.health = (widget.character.health + (25 * curedCount)).clamp(0, 100);
        final successMsg = '🏥 Obati Semua: Berhasil menyembuhkan $curedCount penyakit: ${curedDiseases.join(", ")} (-$totalCost uang, kesehatan & kebahagiaan meningkat!)';
        widget.character.inbox.add(successMsg);
      }
      if (failedCount > 0) {
        final failMsg = '🏥 Obati Semua: Gagal menyembuhkan $failedCount penyakit.';
        widget.character.inbox.add(failMsg);
      }
      
      widget.onComplete?.call();
    });

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Text('Hasil Pengobatan Massal 🏥', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          content: Text('Pengobatan selesai!\n\n🎉 Berhasil Sembuh: $curedCount penyakit\n😔 Gagal Sembuh: $failedCount penyakit\n💸 Total Biaya: \$${DokterUtils.fmt(totalCost)}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Selesai', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            ),
          ],
        );
      },
    );
  }

  void _askParentsToPay(String parentRelation, int relationship, int totalCost) {
    final Random random = Random();
    // Peluang disetujui: Hubungan + 20% bonus karena ini kesehatan/medis
    final int chance = (relationship + 20).clamp(0, 100);
    final bool success = random.nextInt(100) < chance;

    if (success) {
      // Hubungan membaik
      setState(() {
        if (parentRelation == 'Orang Tua') {
          widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) + 10).clamp(0, 100);
          widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) + 10).clamp(0, 100);
        } else if (parentRelation == 'Ayah') {
          widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) + 10).clamp(0, 100);
        } else if (parentRelation == 'Ibu') {
          widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) + 10).clamp(0, 100);
        } else if (parentRelation == 'Ayah Tiri') {
          widget.character.stepFatherRelationship = ((widget.character.stepFatherRelationship ?? 50) + 10).clamp(0, 100);
        } else if (parentRelation == 'Ibu Tiri') {
          widget.character.stepMotherRelationship = ((widget.character.stepMotherRelationship ?? 50) + 10).clamp(0, 100);
        }
        widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
      });

      // Proses semua pengobatan secara gratis (karena dibayari orang tua)
      final activeDiseases = List<String>.from(widget.character.riwayatPenyakit);
      int curedCount = 0;
      int failedCount = 0;
      final List<String> curedDiseases = [];

      for (var disease in activeDiseases) {
        final costData = DokterUtils.getDiseaseCostAndSuccessRate(disease);
        final int successRate = costData['successRate'] ?? 75;

        int rate = successRate;
        final String nameLower = disease.toLowerCase();
        final List<String> ringanList = [
          'flu', 'sakit kepala', 'batuk', 'alergi', 'sakit gigi', 'pusing', 'diare', 
          'lecet', 'robekan kecil', 'kram', 'iritasi overstimulasi', 'luka mikro', 'dehidrasi'
        ];
        final List<String> beratList = [
          'pneumonia berat', 'stroke', 'serangan jantung', 'ginjal', 'kanker', 
          'meningitis', 'tubaberculosis', 'tbc', 'pankreatitis', 'hiv', 'aids', 'cedera jaringan', 'laserasi'
        ];
        if (ringanList.any((key) => nameLower.contains(key))) {
          rate = 90;
        } else if (beratList.any((key) => nameLower.contains(key))) {
          rate = 45;
        }

        final bool isSuccess = random.nextInt(100) < rate;
        if (isSuccess) {
          widget.character.riwayatPenyakit.remove(disease);
          curedDiseases.add(disease);
          curedCount++;
          final int hapGain = DokterUtils.getHappinessGainOnCured(disease);
          widget.character.happiness = (widget.character.happiness + hapGain).clamp(0, 100);

          if (disease.contains('HIV')) {
            widget.character.hasHIV = false;
          } else if (disease.contains('Sifilis')) {
            widget.character.hasSifilis = false;
          } else if (disease.contains('HPV')) {
            widget.character.hasHPV = false;
          }
        } else {
          failedCount++;
        }
      }

      // Tambah kesehatan
      if (curedCount > 0) {
        widget.character.health = (widget.character.health + (25 * curedCount)).clamp(0, 100);
        final successMsg = '🏥 Minta Pengobatan: $parentRelation membayar \$${DokterUtils.fmt(totalCost)} untuk mengobati penyakitmu. Berhasil menyembuhkan $curedCount penyakit: ${curedDiseases.join(", ")} (kesehatan & kebahagiaan meningkat!)';
        widget.character.inbox.add(successMsg);
      }
      if (failedCount > 0) {
        final failMsg = '🏥 Minta Pengobatan: $parentRelation membiayai pengobatan namun gagal menyembuhkan $failedCount penyakit.';
        widget.character.inbox.add(failMsg);
      }

      setState(() {});
      widget.onComplete?.call();

      showDialog(
        context: context,
        builder: (ctx) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Text('Minta Pengobatan Sukses! 🏥', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text(
              '$parentRelation berbaik hati membayarkan seluruh biaya pengobatan sebesar \$${DokterUtils.fmt(totalCost)} untukmu.\n\n'
              '🎉 Berhasil Sembuh: $curedCount penyakit\n'
              '😔 Gagal Sembuh: $failedCount penyakit\n'
              '(Hubungan dengan $parentRelation meningkat!)',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Selesai', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          );
        },
      );
    } else {
      // Gagal, hubungan memburuk
      setState(() {
        if (parentRelation == 'Orang Tua') {
          widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) - 5).clamp(0, 100);
          widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) - 5).clamp(0, 100);
        } else if (parentRelation == 'Ayah') {
          widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) - 5).clamp(0, 100);
        } else if (parentRelation == 'Ibu') {
          widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) - 5).clamp(0, 100);
        } else if (parentRelation == 'Ayah Tiri') {
          widget.character.stepFatherRelationship = ((widget.character.stepFatherRelationship ?? 50) - 5).clamp(0, 100);
        } else if (parentRelation == 'Ibu Tiri') {
          widget.character.stepMotherRelationship = ((widget.character.stepMotherRelationship ?? 50) - 5).clamp(0, 100);
        }
        widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
      });

      showDialog(
        context: context,
        builder: (ctx) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Text('Minta Pengobatan Ditolak ❌', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text(
              '$parentRelation menolak membayarkan biaya pengobatan sebesar \$${DokterUtils.fmt(totalCost)} karena hubungan kalian yang kurang dekat atau keterbatasan dana.',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Mengerti', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final activeDiseases = widget.character.riwayatPenyakit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Penyakit Anda', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Saldo Anda: \$${DokterUtils.fmt(widget.character.money)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16, 
                          color: isDark ? Colors.greenAccent : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  if (activeDiseases.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: _treatAllDiseases,
                      child: const Text('Obati Semua 🏥', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: activeDiseases.isEmpty
                  ? Center(
                      child: Text(
                        'kamu sehat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
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
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              disease,
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 14, 
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Harus diobati via: ${DokterUtils.getRequiredMenu(disease)}',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () async {
                                final menu = DokterUtils.getRequiredMenu(disease);
                                await DokterUtils.handleDiseaseTreatment(
                                  context, 
                                  widget.character, 
                                  menu, 
                                  specificDisease: disease
                                );
                                setState(() {});
                                widget.onComplete?.call();
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