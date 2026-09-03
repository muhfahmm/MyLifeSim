// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'efek_samping.dart';
import 'masturbate_enjoyment.dart';

// ============================================================
// MODEL DATA LOKASI & WAKTU
// ============================================================
class _LokasiOption {
  final String name;
  final String description;
  final IconData icon;
  const _LokasiOption({required this.name, required this.description, required this.icon});
}

class _WaktuOption {
  final String name;
  final String description;
  final IconData icon;
  const _WaktuOption({required this.name, required this.description, required this.icon});
}

const List<_LokasiOption> _lokasiOptions = [
  _LokasiOption(name: 'Di Kamar Tidur', description: 'Privat dan nyaman di atas kasur.', icon: Icons.bed),
  _LokasiOption(name: 'Di Kamar Mandi', description: 'Sensasi segar di balik pintu terkunci.', icon: Icons.bathtub),
  _LokasiOption(name: 'Di Ruang Tamu', description: 'Diam-diam saat suasana rumah sedang sepi.', icon: Icons.chair),
  _LokasiOption(name: 'Di Mobil', description: 'Tersembunyi di dalam mobil yang terparkir.', icon: Icons.directions_car),
  _LokasiOption(name: 'Di Hotel', description: 'Kamar hotel mewah tanpa gangguan.', icon: Icons.hotel),
];

const List<_WaktuOption> _waktuOptions = [
  _WaktuOption(name: 'Pagi', description: 'Di pagi hari yang cerah dan segar.', icon: Icons.light_mode),
  _WaktuOption(name: 'Siang', description: 'Mencuri waktu di siang hari yang terik.', icon: Icons.wb_sunny),
  _WaktuOption(name: 'Sore', description: 'Suasana syahdu menjelang senja.', icon: Icons.wb_twilight),
  _WaktuOption(name: 'Malam', description: 'Kegelapan malam menyimpan rahasia.', icon: Icons.nightlight_round),
];

class AjakanMasturbasiDialog {
  static void show({
    required BuildContext context,
    required Character character,
    required String relationType,
    required String viewerName,
    required VoidCallback? onComplete,
    String? targetGender,
    bool isUserInitiated = false,  // true = user mengajak, false = partner mengajak
  }) {
    final String myGender = character.gender.trim().toLowerCase();
    final String relLower = relationType.toLowerCase();
    final String viewerLower = viewerName.toLowerCase();
    
    // Tentukan gender target: prioritaskan parameter dari pemanggil
    String resolvedTargetGender = targetGender ?? 'Perempuan';
    if (targetGender == null) {
      if (viewerLower.startsWith('ayah') || viewerLower.startsWith('paman') || viewerLower.startsWith('kakek') || viewerLower.startsWith('kakak laki') || viewerLower.startsWith('adik laki')) {
        resolvedTargetGender = 'Laki-laki';
      } else if (viewerLower.startsWith('ibu') || viewerLower.startsWith('bibi') || viewerLower.startsWith('nenek') || viewerLower.startsWith('kakak per') || viewerLower.startsWith('adik per')) {
        resolvedTargetGender = 'Perempuan';
      } else if (relLower.contains('ayah') || relLower.contains('paman') || relLower.contains('kakek') || (relLower.contains('saudara') && relLower.contains('laki')) || (relLower.contains('adik') && relLower.contains('laki')) || (relLower.contains('kakak') && relLower.contains('laki')) || relLower.contains('suami')) {
        resolvedTargetGender = 'Laki-laki';
      } else if (relLower.contains('ibu') || relLower.contains('bibi') || relLower.contains('nenek') || relLower.contains('istri') || (relLower.contains('kakak') && relLower.contains('per')) || (relLower.contains('adik') && relLower.contains('per'))) {
        resolvedTargetGender = 'Perempuan';
      }
    }

    final bool isGay = (myGender == 'laki-laki' && resolvedTargetGender.toLowerCase() == 'laki-laki');
    final bool isLesbian = (myGender == 'perempuan' && resolvedTargetGender.toLowerCase() == 'perempuan');

    // Parse relasi
    final parsed = _parseRelation(relationType);
    final String relationWithMu = _getRelationWithMu(parsed['main']!);
    final String partnerDesc = parsed['detail']!.isNotEmpty
        ? '$relationWithMu (${parsed['detail']}), $viewerName'
        : '$relationWithMu, $viewerName';
    // Nama pendek tanpa 'mu' untuk framing user-initiated
    final String partnerDescPlain = parsed['detail']!.isNotEmpty
        ? '${parsed['main']} (${parsed['detail']}), $viewerName'
        : '$viewerName';

    String dialogTitle;
    String dialogBody;
    if (isUserInitiated) {
      // USER yang mengajak
      if (isGay) {
        dialogTitle = 'Ajak Masturbasi Bersama (Gay)?';
        dialogBody = 'Kamu ingin mengajak $partnerDescPlain untuk melakukan masturbasi bersama sesama jenis (Gay) secara rahasia. Apakah kamu yakin ingin melanjutkan?';
      } else if (isLesbian) {
        dialogTitle = 'Ajak Masturbasi Bersama (Lesbian)?';
        dialogBody = 'Kamu ingin mengajak $partnerDescPlain untuk melakukan masturbasi bersama sesama jenis (Lesbian) secara rahasia. Apakah kamu yakin ingin melanjutkan?';
      } else {
        dialogTitle = 'Ajak Masturbasi Bersama?';
        dialogBody = 'Kamu ingin mengajak $partnerDescPlain untuk melakukan masturbasi bersama secara rahasia. Apakah kamu yakin ingin melanjutkan?';
      }
    } else {
      // PARTNER yang mengajak
      if (isGay) {
        dialogTitle = 'Ajakan Gay (Masturbasi Bersama)!';
        dialogBody = '$partnerDesc secara terang-terangan mengajakmu melakukan masturbasi bersama sesama jenis (Gay) secara rahasia. Apakah kamu mau menerima ajakan tersebut?';
      } else if (isLesbian) {
        dialogTitle = 'Ajakan Lesbian (Masturbasi Bersama)!';
        dialogBody = '$partnerDesc secara terang-terangan mengajakmu melakukan masturbasi bersama sesama jenis (Lesbian) secara rahasia. Apakah kamu mau menerima ajakan tersebut?';
      } else {
        dialogTitle = 'Ajakan Masturbasi Bersama!';
        dialogBody = '$partnerDesc secara terang-terangan mengajakmu melakukan masturbasi bersama secara rahasia. Apakah kamu mau menerima ajakan tersebut?';
      }
    }

    // Opsi lapor hanya muncul ketika PARTNER yang mengajak (incoming)
    final bool showReportToMother = !isUserInitiated && (relLower == 'ayah' || relLower == 'ayah tiri') &&
        (character.motherName != null && !character.isMotherDeceased);
    final bool showReportToFather = !isUserInitiated && (relLower == 'ibu' || relLower == 'ibu tiri') &&
        (character.fatherName != null && !character.isFatherDeceased);
    final bool showReportToParents = !isUserInitiated && !showReportToMother && !showReportToFather &&
        (relLower.contains('kakak') || relLower.contains('adik') || relLower.contains('saudara'));

    // Untuk INCOMING: pre-generate lokasi & waktu secara acak (partner sudah memilih)
    final _random = Random();
    final String? preGeneratedLokasi = isUserInitiated ? null : _lokasiOptions[_random.nextInt(_lokasiOptions.length)].name;
    final String? preGeneratedWaktu = isUserInitiated ? null : _waktuOptions[_random.nextInt(_waktuOptions.length)].name;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFEEF2F5),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dialogBody,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              // Badge lokasi & waktu hanya muncul untuk incoming (partner sudah memilih)
              if (!isUserInitiated && preGeneratedLokasi != null && preGeneratedWaktu != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildBadge(Icons.location_on, preGeneratedLokasi, isDark ? Colors.purpleAccent : Colors.deepPurple),
                    const SizedBox(width: 8),
                    _buildBadge(Icons.access_time, preGeneratedWaktu, isDark ? Colors.indigoAccent : Colors.indigo),
                  ],
                ),
              ],
            ],
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            if (showReportToMother)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeReport(context, character, relationType, viewerName, 'Ibu', onComplete);
                },
                child: Text(
                  'Laporkan ke Ibu',
                  style: TextStyle(
                    color: isDark ? Colors.orangeAccent : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (showReportToFather)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeReport(context, character, relationType, viewerName, 'Ayah', onComplete);
                },
                child: Text(
                  'Laporkan ke Ayah',
                  style: TextStyle(
                    color: isDark ? Colors.orangeAccent : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (showReportToParents)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _executeReportSibling(context, character, relationType, viewerName, onComplete);
                },
                child: Text(
                  'Laporkan ke Orang Tua',
                  style: TextStyle(
                    color: isDark ? Colors.orangeAccent : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Konfirmasi → untuk user-initiated lanjut ke picker, untuk incoming langsung ke result
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.green.shade900 : const Color(0xFFD4EDDA),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  if (isUserInitiated) {
                    // User mengajak → picker tempat → picker waktu → result
                    _showPilihTempat(context, character, relationType, viewerName, partnerDesc, onComplete);
                  } else {
                    // Partner mengajak → langsung ke result dengan lokasi & waktu pre-generated
                    _executeAccept(context, character, relationType, viewerName, partnerDesc,
                        preGeneratedLokasi!, preGeneratedWaktu!, onComplete);
                  }
                },
                child: Text(
                  isUserInitiated ? 'Lanjutkan \u27A1' : 'Terima ajakan masturbasi',
                  style: TextStyle(
                    color: isDark ? Colors.greenAccent : const Color(0xFF28A745),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _executeReject(context, character, relationType, viewerName, onComplete);
              },
              child: Text(
                isUserInitiated ? 'Batal' : 'Tolak',
                style: TextStyle(
                  color: isDark ? Colors.redAccent : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MODAL 2: PILIH TEMPAT
  // ============================================================
  static void _showPilihTempat(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    String partnerDesc,
    VoidCallback? onComplete,
  ) {
    showDialog<_LokasiOption>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Row(
            children: [
              Icon(Icons.location_on, color: isDark ? Colors.purpleAccent : Colors.deepPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pilih Tempat Bersama $viewerName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _lokasiOptions.map((loc) {
                return Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDark ? Colors.purple.shade900 : Colors.purple.shade50,
                      child: Icon(loc.icon, color: isDark ? Colors.purpleAccent : Colors.deepPurple),
                    ),
                    title: Text(
                      loc.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      loc.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    onTap: () => Navigator.pop(ctx, loc),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((selectedLoc) {
      if (selectedLoc == null) return;
      _showPilihWaktu(context, character, relationType, viewerName, partnerDesc, selectedLoc.name, onComplete);
    });
  }

  // ============================================================
  // MODAL 3: PILIH WAKTU
  // ============================================================
  static void _showPilihWaktu(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    String partnerDesc,
    String lokasiTerpilih,
    VoidCallback? onComplete,
  ) {
    showDialog<_WaktuOption>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Row(
            children: [
              Icon(Icons.access_time, color: isDark ? Colors.indigoAccent : Colors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pilih Waktu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi terpilih: $lokasiTerpilih',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                ..._waktuOptions.map((time) {
                  return Card(
                    elevation: 0,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isDark ? Colors.indigo.shade900 : Colors.indigo.shade50,
                        child: Icon(time.icon, color: isDark ? Colors.indigoAccent : Colors.indigoAccent),
                      ),
                      title: Text(
                        time.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        time.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      onTap: () => Navigator.pop(ctx, time),
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((selectedTime) {
      if (selectedTime == null) return;
      _executeAccept(context, character, relationType, viewerName, partnerDesc, lokasiTerpilih, selectedTime.name, onComplete);
    });
  }

  // ============================================================
  // MODAL 4 (AKHIR): HASIL SETELAH TEMPAT & WAKTU DIPILIH
  // ============================================================
  static void _executeAccept(
    BuildContext context,
    Character character,
    String relationType,
    String viewerName,
    String partnerDesc,
    String lokasi,
    String waktu,
    VoidCallback? onComplete,
  ) {
    final int healthLoss = 1 + Random().nextInt(10);
    character.karma = (character.karma - 50).clamp(0, 100);
    character.health = (character.health - healthLoss).clamp(0, 100);
    character.happiness = (character.happiness + 15).clamp(0, 100);
    _modifyRelativeRelationship(character, relationType, viewerName, 20);
    character.addTabooSecret(viewerName, relationType, 'Masturbasi');
    character.addProposalHistory(name: viewerName, relation: relationType, type: 'Masturbasi', status: 'Diterima');

    final String relLower = relationType.toLowerCase();
    String inboxMsg;
    String resultMsg;

    if (relLower.contains('ayah')) {
      inboxMsg = '🚨 Rahasia Gelap: Hubungan tabu terjalin dengan Ayah ($viewerName) — $waktu, $lokasi.';
      resultMsg = 'Kamu dan Ayahmu ($viewerName) melakukannya bersama $waktu hari ini $lokasi. Rahasia ini hanya milik kalian berdua.';
    } else if (relLower.contains('ibu')) {
      inboxMsg = '🚨 Rahasia Gelap: Hubungan tabu terjalin dengan Ibu ($viewerName) — $waktu, $lokasi.';
      resultMsg = 'Kamu dan Ibumu ($viewerName) melakukannya bersama $waktu hari ini $lokasi. Rahasia ini hanya milik kalian berdua.';
    } else {
      inboxMsg = '🚨 Rahasia Gelap: Hubungan terlarang terjalin dengan $viewerName — $waktu, $lokasi.';
      resultMsg = 'Kamu dan $partnerDesc melakukannya bersama $waktu hari ini $lokasi. Kalian sepakat menjaga rahasia ini rapat-rapat.';
    }

    character.inbox.add(inboxMsg);

    final String parsedRel = _parseRelation(relationType)['main']!;
    final String partnerRelation = _getRelationWithMu(parsedRel);

    MasturbateEnjoymentModal.show(
      context: context,
      character: character,
      fantasyPartner: viewerName,
      isMutual: true,
      partnerName: viewerName,
      partnerRelation: partnerRelation,
      additionalText: resultMsg + '\n\n📈 Efek: +15% Kebahagiaan, -$healthLoss% Kesehatan, +20% Hubungan',
      onComplete: () {
        EfekSampingMasturbasi.checkPartnerEffect(
          context, character, relationType, viewerName, onComplete,
          acceptanceHealthLoss: healthLoss,
        );
      },
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
    character.addProposalHistory(name: viewerName, relation: relationType, type: 'Masturbasi', status: 'Ditolak');
    _modifyRelativeRelationship(character, relationType, viewerName, -15);

    final parsed = _parseRelation(relationType);
    final String relationWithMu = _getRelationWithMu(parsed['main']!);
    final String partnerDesc = parsed['detail']!.isNotEmpty
        ? '$relationWithMu (${parsed['detail']}), $viewerName'
        : '$relationWithMu, $viewerName';

    character.inbox.add('💔 Penolakan: Kamu menolak ajakan hubungan intim dari $partnerDesc.');

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            'Ajakan Ditolak 💔',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Text(
            'Kamu dengan tegas menolak ajakan dari $partnerDesc. Hubungan kalian menjadi agak renggang (-15% Hubungan).',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onComplete?.call();
              },
              child: Text(
                'OK',
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            )
          ],
        );
      },
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
        builder: (context) {
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            title: Text(
              'Orang Tua Bercerai! 🚨',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            content: Text(
              'Laporanmu memicu pertengkaran hebat dan keributan dahsyat di rumah. $reportTarget tidak tahan dan memutuskan untuk bercerai! (-100% Hubungan dengan pelaku, Orang tuamu sekarang BERCERAI).',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onComplete?.call();
                },
                child: Text('OK', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              )
            ],
          );
        },
      );
    } else {
      _modifyParentsRelationship(character, -30);
      character.inbox.add('🚨 PERTENGKARAN HEBAT: $reportTarget mengkonfrontasi pelaku. Terjadi keributan besar tetapi mereka tetap bertahan bersama.');
      
      showDialog(
        context: context,
        builder: (context) {
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            title: Text(
              'Pertengkaran Hebat! 🚨',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            content: Text(
              'Laporanmu memicu keributan besar di antara orang tuamu. Mereka berteriak sepanjang malam tetapi akhirnya tidak bercerai (-30% Hubungan orang tua).',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onComplete?.call();
                },
                child: Text('OK', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              )
            ],
          );
        },
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
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            'Dilaporkan ke Orang Tua! 📢',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Text(
            'Kamu memutuskan untuk melaporkan ajakan cabul $partnerDesc ke orang tuamu. Orang tuamu sangat marah kepada $viewerName dan langsung menghukumnya dengan sangat berat! (-100% Hubungan dengan saudara, +15% Karma karena jujur).',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onComplete?.call();
              },
              child: Text('OK', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            )
          ],
        );
      },
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

  // ============================================================
  // HELPER: BADGE CHIP UNTUK LOKASI/WAKTU/EFEK
  // ============================================================
  
   static Widget _buildBadge(IconData icon, String label, Color color) { return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}