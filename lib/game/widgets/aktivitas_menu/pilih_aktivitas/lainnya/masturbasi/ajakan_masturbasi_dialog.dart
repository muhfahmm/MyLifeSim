// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'efek_samping.dart';

class AjakanMasturbasiDialog {
  static void show({
    required BuildContext context,
    required Character character,
    required String relationType,
    required String viewerName,
    required VoidCallback? onComplete,
  }) {
    final String myGender = character.gender.trim().toLowerCase();
    final String relLower = relationType.toLowerCase();
    
    // Tentukan gender target berdasarkan tipe relasi
    String targetGender = 'Perempuan';
    if (relLower.contains('ayah') || relLower.contains('paman') || relLower.contains('kakek') || (relLower.contains('saudara') && relLower.contains('laki')) || (relLower.contains('adik') && relLower.contains('laki')) || (relLower.contains('kakak') && relLower.contains('laki'))) {
      targetGender = 'Laki-laki';
    }

    final bool isGay = (myGender == 'laki-laki' && targetGender == 'Laki-laki');
    final bool isLesbian = (myGender == 'perempuan' && targetGender == 'Perempuan');

    // Parse relation details
    final parsed = _parseRelation(relationType);
    final String relationWithMu = _getRelationWithMu(parsed['main']!);
    final String partnerDesc = parsed['detail']!.isNotEmpty
        ? '$relationWithMu (${parsed['detail']}), $viewerName'
        : '$relationWithMu, $viewerName';

    String dialogTitle = 'Ajakan Masturbasi Bersama!';
    String dialogBody = '';

    if (isGay) {
      dialogTitle = 'Ajakan Gay (Masturbasi Bersama)!';
      dialogBody = '$partnerDesc secara terang-terangan mengajakmu untuk melakukan masturbasi bersama sesama jenis (Gay) secara rahasia. Apakah kamu mau menerima ajakan masturbasi tersebut?';
    } else if (isLesbian) {
      dialogTitle = 'Ajakan Lesbian (Masturbasi Bersama)!';
      dialogBody = '$partnerDesc secara terang-terangan mengajakmu untuk melakukan masturbasi bersama sesama jenis (Lesbian) secara rahasia. Apakah kamu mau menerima ajakan masturbasi tersebut?';
    } else {
      dialogTitle = 'Ajakan Masturbasi Bersama!';
      dialogBody = '$partnerDesc secara terang-terangan mengajakmu untuk melakukan masturbasi bersama secara rahasia. Apakah kamu mau menerima ajakan tersebut?';
    }

    // Tentukan apakah bisa melapor ke orang tua lain
    bool showReportToMother = (relLower == 'ayah' || relLower == 'ayah tiri') &&
        (character.motherName != null && !character.isMotherDeceased);
    bool showReportToFather = (relLower == 'ibu' || relLower == 'ibu tiri') &&
        (character.fatherName != null && !character.isFatherDeceased);
    bool showReportToParents = !showReportToMother && !showReportToFather && 
        (relLower.contains('kakak') || relLower.contains('adik') || relLower.contains('saudara'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFEEF2F5),
          title: Row(
            children: [
              if (isGay || isLesbian)
                const Text('🏳️‍🌈', style: TextStyle(fontSize: 28))
              else
                const Icon(Icons.favorite, color: Colors.pink, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dialogTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            dialogBody,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            // Opsi Lapor 1
            if (showReportToMother)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeReport(context, character, relationType, viewerName, 'Ibu', onComplete);
                },
                child: const Text(
                  'Laporkan ke Ibu',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            // Opsi Lapor 2
            if (showReportToFather)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeReport(context, character, relationType, viewerName, 'Ayah', onComplete);
                },
                child: const Text(
                  'Laporkan ke Ayah',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            // Opsi Lapor 3 (Saudara)
            if (showReportToParents)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeReportSibling(context, character, relationType, viewerName, onComplete);
                },
                child: const Text(
                  'Laporkan ke Orang Tua',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            
            // Tombol Terima (Styled with background pill/light green)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD4EDDA),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeAccept(context, character, relationType, viewerName, onComplete);
                },
                child: const Text(
                  'Terima ajakan masturbasi',
                  style: TextStyle(color: Color(0xFF28A745), fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Tombol Tolak
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _executeReject(context, character, relationType, viewerName, onComplete);
              },
              child: const Text(
                'Tolak',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOGIKA AKSI: TERIMA
  // ============================================================
  static void _executeAccept(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    VoidCallback? onComplete,
  ) {
    final int healthLoss = 1 + Random().nextInt(10);
    character.karma = (character.karma - 50).clamp(0, 100);
    character.health = (character.health - healthLoss).clamp(0, 100);
    _modifyRelativeRelationship(character, relationType, viewerName, 20);

    String msg = '';
    if (relationType.toLowerCase().contains('ayah')) {
      character.inbox.add('🚨 Rahasia Gelap: Hubungan tabu yang aneh terjalin dengan Ayah ($viewerName) setelah insiden tersebut.');
      msg = 'Kamu menerima ajakan Ayahmu. Hubungan rahasia gelap yang tabu telah terjalin (-50% Karma, -$healthLoss% Kesehatan, +20% Hubungan).';
    } else if (relationType.toLowerCase().contains('ibu')) {
      character.inbox.add('🚨 Rahasia Gelap: Hubungan tabu yang aneh terjalin dengan Ibu ($viewerName) setelah insiden tersebut.');
      msg = 'Kamu menerima ajakan Ibumu. Hubungan rahasia gelap yang tabu telah terjalin (-50% Karma, -$healthLoss% Kesehatan, +20% Hubungan).';
    } else {
      character.happiness = (character.happiness + 10).clamp(0, 100);
      character.inbox.add('🚨 Hubungan Toxic: Hubungan terlarang dan toxic dimulai dengan saudaramu, $viewerName.');
      msg = 'Kamu menerima ajakan saudaramu. Hubungan yang toxic dan terlarang telah terjalin (+10% Kebahagiaan, -30% Karma, -$healthLoss% Kesehatan, +20% Hubungan).';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajakan Diterima 😈'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              EfekSampingMasturbasi.checkPartnerEffect(context, character, relationType, viewerName, onComplete);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // ============================================================
  // LOGIKA AKSI: TOLAK BIASA
  // ============================================================
  static void _executeReject(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    VoidCallback? onComplete,
  ) {
    _modifyRelativeRelationship(character, relationType, viewerName, -15);
    character.happiness = (character.happiness - 10).clamp(0, 100);

    final parsed = _parseRelation(relationType);
    final String relationWithMu = _getRelationWithMu(parsed['main']!);
    final String partnerDesc = parsed['detail']!.isNotEmpty
        ? '$relationWithMu (${parsed['detail']}), $viewerName'
        : '$relationWithMu, $viewerName';

    character.inbox.add('💔 Penolakan: Kamu menolak ajakan hubungan intim dari $partnerDesc.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajakan Ditolak 💔'),
        content: Text('Kamu dengan tegas menolak ajakan dari $partnerDesc. Hubungan kalian menjadi agak renggang (-10% Kebahagiaan, -15% Hubungan).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete?.call();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // ============================================================
  // LOGIKA AKSI: LAPORAN ORANG TUA (Ayah/Ibu)
  // ============================================================
  static void _executeReport(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    String reportTarget,
    VoidCallback? onComplete,
  ) {
    _modifyRelativeRelationship(character, relationType, viewerName, -100);
    
    final Random random = Random();
    final bool divorce = random.nextInt(100) < 40;

    if (divorce) {
      character.inbox.add('🚨 PERTENGKARAN DAHSYAT: Orang tuamu bertengkar hebat setelah laporanmu dan memutuskan untuk BERCERAI!');
      _modifyParentsRelationship(character, -80);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Orang Tua Bercerai! 🚨'),
          content: Text('Laporanmu memicu pertengkaran hebat dan keributan dahsyat di rumah. $reportTarget tidak tahan dan memutuskan untuk bercerai! (-100% Hubungan dengan pelaku, Orang tuamu sekarang BERCERAI).'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onComplete?.call();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      _modifyParentsRelationship(character, -30);
      character.inbox.add('🚨 PERTENGKARAN HEBAT: $reportTarget mengkonfrontasi pelaku. Terjadi keributan besar tetapi mereka tetap bertahan bersama.');
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pertengkaran Hebat! 🚨'),
          content: const Text('Laporanmu memicu keributan besar di antara orang tuamu. Mereka berteriak sepanjang malam tetapi akhirnya tidak bercerai (-30% Hubungan orang tua).'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onComplete?.call();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  static void _executeReportSibling(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    VoidCallback? onComplete,
  ) {
    _modifyRelativeRelationship(character, relationType, viewerName, -100);
    character.karma = (character.karma + 15).clamp(0, 100);

    final parsed = _parseRelation(relationType);
    final String relationWithMu = _getRelationWithMu(parsed['main']!);
    final String partnerDesc = parsed['detail']!.isNotEmpty
        ? '$relationWithMu (${parsed['detail']}), $viewerName'
        : '$relationWithMu, $viewerName';

    character.inbox.add('🚨 SAUDARA DIHUKUM: Kamu melaporkan $partnerDesc ke orang tua. Dia dihukum dengan sangat keras.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dilaporkan ke Orang Tua! 📢'),
        content: Text('Kamu memutuskan untuk melaporkan ajakan cabul $partnerDesc ke orang tuamu. Orang tuamu sangat marah kepada $viewerName dan langsung menghukumnya dengan sangat berat! (-100% Hubungan dengan saudara, +15% Karma karena jujur).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete?.call();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // Helper parser relation
  static Map<String, String> _parseRelation(String relationType) {
    String mainRelation = relationType;
    String detailRelation = '';
    if (relationType.contains('(') && relationType.endsWith(')')) {
      final int openParen = relationType.indexOf('(');
      mainRelation = relationType.substring(0, openParen).trim();
      detailRelation = relationType.substring(openParen + 1, relationType.length - 1).trim();
    }
    return {'main': mainRelation, 'detail': detailRelation};
  }

  static String _getRelationWithMu(String mainRelation) {
    final String mainRelLower = mainRelation.toLowerCase();
    if (mainRelLower == 'ayah' || mainRelLower == 'ayah kandung') return 'Ayahmu';
    if (mainRelLower == 'ibu' || mainRelLower == 'ibu kandung') return 'Ibumu';
    if (mainRelLower == 'ayah tiri') return 'Ayah Tirimu';
    if (mainRelLower == 'ibu tiri') return 'Ibu Tirimu';
    if (mainRelLower == 'kakak laki-laki') return 'Kakak Laki-lakimu';
    if (mainRelLower == 'kakak perempuan') return 'Kakak Perempuanmu';
    if (mainRelLower == 'adik laki-laki') return 'Adik Laki-lakimu';
    if (mainRelLower == 'adik perempuan') return 'Adik Perempuanmu';
    if (mainRelLower == 'paman') return 'Pamanmu';
    if (mainRelLower == 'bibi') return 'Bibimu';
    if (mainRelLower == 'sepupu') return 'Sepupumu';
    if (mainRelLower == 'kakek') return 'Kakekmu';
    if (mainRelLower == 'nenek') return 'Nenekmu';
    return '${mainRelation}mu';
  }

  // Helper Hubungan
  static void _modifyRelativeRelationship(Character character, String relationType, String name, int delta) {
    final String relLower = relationType.toLowerCase();
    if (relLower.contains('ayah')) {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) + delta).clamp(0, 100);
    } else if (relLower.contains('ibu')) {
      character.motherRelationship = ((character.motherRelationship ?? 50) + delta).clamp(0, 100);
    }
    
    for (var sib in character.siblings) {
      if (sib['name'] == name || sib['relation'] == relationType || (sib['relation'] != null && relationType.toLowerCase().contains(sib['relation']!.toLowerCase()))) {
        int cur = int.tryParse(sib['relationship'] ?? '50') ?? 50;
        sib['relationship'] = (cur + delta).clamp(0, 100).toString();
        break;
      }
    }
  }

  static void _modifyParentsRelationship(Character character, int delta) {
    if (character.fatherName != null) {
      character.fatherRelationship = ((character.fatherRelationship ?? 50) + delta).clamp(0, 100);
    }
    if (character.motherName != null) {
      character.motherRelationship = ((character.motherRelationship ?? 50) + delta).clamp(0, 100);
    }
  }
}
