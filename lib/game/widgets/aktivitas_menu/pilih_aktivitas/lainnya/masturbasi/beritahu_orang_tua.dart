// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/beritahu_orang_tua.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BeriTahuOrangTua {
  /// Memulai dialog interaktif beri tahu orang tua tentang cedera efek samping masturbasi.
  static void show(
    BuildContext context,
    Character character,
    String relationType,
    String partnerName,
    int originalHealthLoss,
    VoidCallback? onComplete,
  ) {
    final String r = relationType.toLowerCase();
    final bool isSolo = r == 'biasa' || r.isEmpty;

    int relSum = 0;
    int count = 0;
    if (character.fatherName != null && !character.isFatherDeceased) {
      relSum += character.fatherRelationship ?? 50;
      count++;
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      relSum += character.motherRelationship ?? 50;
      count++;
    }
    final int avgRel = count > 0 ? (relSum ~/ count) : 50;

    String scenarioTitle = '';
    String scenarioDesc = '';
    List<Map<String, dynamic>> options = [];

    if (!isSolo) {
      // C. SKENARIO 3: ORANG TUA MEMINTA IDENTITAS PASANGAN
      scenarioTitle = 'Orang Tua Menuntut Jawaban 🧐';
      scenarioDesc = 'Orang tuamu sangat penasaran dan menuntut untuk tahu siapa yang telah mengajakmu melakukan hal berisiko ini.';
      
      options = [
        {
          'text': 'Jujur menyebutkan nama pasangan',
          'action': () {
            character.health = 100;
            character.karma = (character.karma + 20).clamp(0, 100);
            _modifyRelativeRelationship(character, relationType, partnerName, -30);
            _modifyParentRelationships(character, -10);
            _addLongTermDebuff(character, 'Stigma Keluarga');

            _showOutcomeDialog(
              context, 
              'Berkata Jujur 🗣️', 
              'Kamu jujur menyebutkan bahwa $relationType ($partnerName) adalah orang yang terlibat. Orang tuamu membawamu ke dokter untuk diobati hingga sembuh total, namun merasa sangat kecewa dan langsung menghubungi pihak keluarganya (Kesehatan Sembuh Total, +20% Karma, -30% Hubungan Pasangan, -10% Hubungan Orang Tua, Status: Stigma Keluarga).', 
              onComplete
            );
          }
        },
        {
          'text': 'Berbohong menyebut nama orang lain',
          'action': () {
            character.health = 100;
            character.karma = (character.karma - 30).clamp(0, 100);
            _modifyParentRelationships(character, -50);
            _addLongTermDebuff(character, 'Stigma Keluarga');
            _addLongTermDebuff(character, 'Pengawasan Ketat');

            _showOutcomeDialog(
              context, 
              'Menuduh Orang Lain 🤥', 
              'Kamu menuduh orang lain yang tidak bersalah untuk melindungi $relationType ($partnerName). Orang tuamu tetap membawamu berobat hingga sembuh total, namun mencium kebohongan tersebut! (Kesehatan Sembuh Total, -30% Karma, -50% Hubungan Orang Tua, Status: Stigma Keluarga & Pengawasan Ketat).', 
              onComplete
            );
          }
        },
        {
          'text': 'Menolak menyebutkan nama',
          'action': () {
            character.health = 100;
            character.karma = (character.karma + 5).clamp(0, 100);
            _modifyParentRelationships(character, -15);
            _modifyRelativeRelationship(character, relationType, partnerName, 15);
            
            _showOutcomeDialog(
              context, 
              'Merahasiakan Nama 🤐', 
              'Kamu bersikeras merahasiakan identitas $relationType ($partnerName). Orang tuamu membawamu berobat hingga sembuh total meskipun kesal karena kamu menutup-nutupi hal ini, dan $relationType ($partnerName) sangat menghargaimu (Kesehatan Sembuh Total, +5% Karma, -15% Hubungan Orang Tua, +15% Hubungan Pasangan).', 
              onComplete
            );
          }
        }
      ];
    } else {
      // Solo play scenarios
      if (avgRel > 60) {
        // A. SKENARIO 1: ORANG TUA PANIK & MEMAKSA PERGI KE DOKTER
        scenarioTitle = 'Orang Tua Panik! 🚨';
        scenarioDesc = 'Mendengar keluhanmu, orang tuamu langsung panik setengah mati dan bersikeras membawamu ke klinik terdekat sekarang juga.';
        
        options = [
          {
            'text': 'Setuju pergi bersama orang tua',
            'action': () {
              character.health = 100;
              character.happiness = (character.happiness - 15).clamp(0, 100);
              _modifyParentRelationships(character, 5);
              _addLongTermDebuff(character, 'Stigma Keluarga');

              _showOutcomeDialog(
                context,
                'Pergi ke Klinik 🏥',
                'Orang tuamu membawamu ke dokter dan menanggung seluruh biayanya. Namun, mereka terus menanyai siapa pasanganmu sepanjang perjalanan (Kesehatan Sembuh Total, -15% Kebahagiaan, +5% Hubungan Orang Tua, Status: Stigma Keluarga).',
                onComplete
              );
            }
          },
          {
            'text': 'Menolak dan mengunci diri di kamar',
            'action': () {
              character.happiness = (character.happiness - 30).clamp(0, 100);
              _modifyParentRelationships(character, -10);
              _addLongTermDebuff(character, 'Trauma / Minder');

              _showOutcomeDialog(
                context,
                'Mengunci Diri 🚪',
                'Kamu malu sekali dan menolak bantuan mereka. Kamu berlari ke kamar dan menguncinya rapat-rapat. Kesehatanmu tidak sembuh (-30% Kebahagiaan, -10% Hubungan Orang Tua, Status: Trauma / Minder).',
                onComplete
              );
            }
          },
          {
            'text': 'Berbohong dan bilang itu hanya alergi makanan',
            'action': () {
              final int healAmount = originalHealthLoss.abs() ~/ 2;
              character.health = (character.health + healAmount).clamp(0, 100);
              character.karma = (character.karma - 15).clamp(0, 100);
              _modifyParentRelationships(character, -5);

              _showOutcomeDialog(
                context,
                'Berdalih Alergi 🌶️',
                'Kamu berbohong kepada orang tua bahwa itu hanya alergi makanan pedas. Orang tuamu membelikan obat alergi biasa (+${healAmount}% Kesehatan, -15% Karma, -5% Hubungan Orang Tua).',
                onComplete
              );
            }
          }
        ];
      } else if (avgRel < 40) {
        // B. SKENARIO 2: ORANG TUA MARAH BESAR & MENGHUKUM
        scenarioTitle = 'Orang Tua Marah Besar! 😡';
        scenarioDesc = 'Orang tuamu menganggap perbuatanmu sangat memalukan keluarga. Bukannya membawa ke dokter, mereka malah fokus memarahimu.';
        
        options = [
          {
            'text': 'Menerima hukuman dengan diam',
            'action': () {
              character.happiness = (character.happiness - 30).clamp(0, 100);
              character.karma = (character.karma + 10).clamp(0, 100);
              _modifyParentRelationships(character, -10);
              character.money = (character.money * 0.8).toInt();
              _addLongTermDebuff(character, 'Stigma Keluarga');

              _showOutcomeDialog(
                context,
                'Menerima Hukuman 🤐',
                'Kamu pasrah menerima omelan dan hukuman kurungan kamar selama 1 minggu serta pemotongan uang jajan sebesar 20% (-30% Kebahagiaan, +10% Karma, -10% Hubungan Orang Tua, Uang Jajan -20%).',
                onComplete
              );
            }
          },
          {
            'text': 'Membantah dan berargumen',
            'action': () {
              character.happiness = (character.happiness - 40).clamp(0, 100);
              _modifyParentRelationships(character, -25);
              character.intelligence = (character.intelligence + 5).clamp(0, 100);
              _addLongTermDebuff(character, 'Trauma / Minder');

              if (avgRel < 15) {
                character.location = 'Gelandangan';
                _showOutcomeDialog(
                  context,
                  'Diusir dari Rumah! 🎒',
                  'Kamu berdebat sengit dengan mereka. Karena hubungan kalian sangat buruk, orang tuamu langsung mengusirmu dari rumah! (-40% Kebahagiaan, -25% Hubungan Orang Tua, +5% Kecerdasan, Status: Gelandangan).',
                  onComplete
                );
              } else {
                _showOutcomeDialog(
                  context,
                  'Pertengkaran Sengit ⚡',
                  'Kamu membantah ceramah mereka dan bersikeras bahwa ini adalah hak privasimu. Terjadi pertengkaran hebat di rumah (-40% Kebahagiaan, -25% Hubungan Orang Tua, +5% Kecerdasan).',
                  onComplete
                );
              }
            }
          },
          {
            'text': 'Menangis dan meminta maaf',
            'action': () {
              character.health = 100;
              character.happiness = (character.happiness - 20).clamp(0, 100);
              _modifyParentRelationships(character, 5);

              _showOutcomeDialog(
                context,
                'Meminta Maaf 😭',
                'Kamu menangis tersedu-sedu dan berjanji tidak akan mengulanginya. Orang tuamu luluh dan iba, lalu setuju mengantarmu ke dokter hingga sembuh total secara gratis (Kesehatan Sembuh Total, -20% Kebahagiaan, +5% Hubungan Orang Tua).',
                onComplete
              );
            }
          }
        ];
      } else {
        // D. SKENARIO 4: ORANG TUA MEMBERI NASEHAT PANJANG (CERAMAH)
        scenarioTitle = 'Ceramah Panjang Orang Tua 🗣️';
        scenarioDesc = 'Orang tuamu tidak marah besar, namun mereka memaksamu duduk di ruang tamu dan mendengarkan ceramah panjang 30 menit mengenai bahaya pergaulan bebas.';
        
        options = [
          {
            'text': 'Mendengarkan dengan sopan',
            'action': () {
              character.happiness = (character.happiness - 10).clamp(0, 100);
              character.intelligence = (character.intelligence + 5).clamp(0, 100);
              _modifyParentRelationships(character, 5);

              _showOutcomeDialog(
                context,
                'Mendengar Ceramah 💤',
                'Kamu diam dan mengangguk mendengarkan ceramah mereka meskipun dalam hati bosan setengah mati (-10% Kebahagiaan, +5% Kecerdasan, +5% Hubungan Orang Tua).',
                onComplete
              );
            }
          },
          {
            'text': 'Memotong dan berkata "Saya sudah tahu, Bu/Pak"',
            'action': () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              character.intelligence = (character.intelligence + 10).clamp(0, 100);
              _modifyParentRelationships(character, 10);

              _showOutcomeDialog(
                context,
                'Menjawab dengan Cerdas 💡',
                'Kamu menyela ceramah mereka dan mengatakan kamu sudah paham dari pendidikan reproduksi di sekolah. Mereka cukup terkesan (-5% Kebahagiaan, +10% Kecerdasan, +10% Hubungan Orang Tua).',
                onComplete
              );
            }
          }
        ];
      }
    }

    // Tampilkan dialog pilihan scenario
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(scenarioTitle, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scenarioDesc, style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87)),
            const SizedBox(height: 16),
            Text(
              'Tindakanmu:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 8),
            ...options.map((opt) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                    foregroundColor: isDark ? Colors.lightBlueAccent : Colors.blueAccent,
                    side: BorderSide(color: isDark ? Colors.lightBlueAccent : Colors.blueAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    opt['action']();
                  },
                  child: Text(opt['text'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  static void _modifyParentRelationships(Character character, int amount) {
    if (character.fatherName != null && !character.isFatherDeceased) {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) + amount).clamp(0, 100);
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      character.motherRelationship = ((character.motherRelationship ?? 50) + amount).clamp(0, 100);
    }
  }

  static void _modifyRelativeRelationship(Character character, String relationType, String name, int amount) {
    final String nameLower = name.toLowerCase();
    for (var sib in character.siblings) {
      if (sib['name'] == name || sib['relation'] == name || (sib['relation'] != null && nameLower.contains(sib['relation']!.toLowerCase()))) {
        final int current = int.tryParse(sib['relationship'] ?? '50') ?? 50;
        sib['relationship'] = (current + amount).clamp(0, 100).toString();
      }
    }
    if (character.partner != null && (character.partner!['name'] == name || character.partner!['relation'] == name)) {
      final int current = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
      character.partner!['relationship'] = (current + amount).clamp(0, 100).toString();
    }
    if (nameLower.contains('ayah') && character.fatherName != null) {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) + amount).clamp(0, 100);
    }
    if (nameLower.contains('ibu') && character.motherName != null) {
      character.motherRelationship = ((character.motherRelationship ?? 50) + amount).clamp(0, 100);
    }
  }

  static void _addLongTermDebuff(Character character, String debuffName) {
    if (debuffName == 'Stigma Keluarga') {
      character.inbox.add('👪 Stigma Keluarga: Selama 3 turn ke depan, interaksi dengan keluarga akan terasa canggung.');
    } else if (debuffName == 'Pengawasan Ketat') {
      character.inbox.add('📱 Pengawasan Ketat: Orang tua mulai memeriksa HP dan kamarmu secara acak (risiko ketahuan meningkat).');
    } else if (debuffName == 'Trauma / Minder') {
      character.inbox.add('😔 Malu Berkepanjangan: Kamu merasa minder akibat kejadian memalukan ini.');
    }
  }

  static void _showOutcomeDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback? onComplete,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        content: Text(content, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete?.call();
            },
            child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ),
        ],
      ),
    );
  }
}