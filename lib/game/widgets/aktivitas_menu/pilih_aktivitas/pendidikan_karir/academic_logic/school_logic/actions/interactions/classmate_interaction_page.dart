// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/classmate_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/utils/country_helper.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/action_menu.dart';
import 'package:mylifesim/store_page/fitur_premium/adult_features/adult_features.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_ajakan.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/npc_family_view.dart';
import 'dart:math';

class ClassmateInteractionPage extends StatefulWidget {
  final Map<String, String> classmate;
  final Character character;
  final VoidCallback onRefresh;

  const ClassmateInteractionPage({
    super.key,
    required this.classmate,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<ClassmateInteractionPage> createState() =>
      _ClassmateInteractionPageState();
}

class _ClassmateInteractionPageState extends State<ClassmateInteractionPage> {
  bool _isStatsVisible = true;

  void _showOutcome(String title, String content) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(content),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {}); // Refresh current screen
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // LOGIKA INTERNAL PENGGANTI SCHOOL_SEXUALITY_LOGIC
  // ==========================================================
  bool _shouldShowRomanceButtons(int userAge, int classmateAge) {
    return userAge >= 12 && classmateAge >= 12;
  }

  /// Helper: tentukan role berdasarkan konteks karakter
  String _resolveRole(String name) {
    if (widget.character.univClassmates.any((e) => e['name'] == name)) {
      return 'Teman Kuliah';
    }
    return 'Teman Sekelas';
  }

  /// Helper: tentukan relation berdasarkan konteks karakter
  String _resolveRelation(String name) {
    if (widget.character.univClassmates.any((e) => e['name'] == name)) {
      return 'Teman Kuliah';
    }
    return 'Teman Sekolah';
  }

  void _handleBercinta() {
    final userGen = widget.character.gender;
    final mateGen = widget.classmate['gender'] ?? 'Laki-laki';
    final String name = widget.classmate['name']!;

    final String role = _resolveRole(name);
    final String relation = _resolveRelation(name);

    if (!AdultFeatures.canMakeLove(
      userAge: widget.character.age,
      role: role,
      relation: relation,
    )) {
      _showOutcome('Aksi Diblokir 🚫',
          'Kamu belum bisa melakukan aksi ini pada usia sekarang.');
      return;
    }

    final int relVal =
        int.tryParse(widget.classmate['relationship'] ?? '50') ?? 50;
    final bool isSameSex = userGen == mateGen;
    final int successChance = isSameSex ? 50 : 65;
    final bool success = Random().nextInt(100) < successChance;

    if (success) {
      final int change = 15 + Random().nextInt(11);
      widget.classmate['relationship'] =
          (relVal + change).clamp(0, 100).toString();
      widget.character.happiness =
          (widget.character.happiness + 10).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Berhasil 💖',
          'Kamu berhasil melakukan hubungan intim dengan $name! Hubungan kalian meningkat pesat.');
    } else {
      final int change = 10 + Random().nextInt(11);
      widget.classmate['relationship'] =
          (relVal - change).clamp(0, 100).toString();
      widget.character.happiness =
          (widget.character.happiness - 10).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Ditolak 💔',
          '$name menolak ajakanmu dan merasa sangat tidak nyaman. Hubungan menurun.');
    }
  }

  void _handleAjakPacaran() {
    final userGen = widget.character.gender;
    final mateGen = widget.classmate['gender'] ?? 'Laki-laki';
    final String name = widget.classmate['name']!;

    final String role = _resolveRole(name);
    final String relation = _resolveRelation(name);

    if (!AdultFeatures.canProposeDating(
      role,
      relation,
      userAge: widget.character.age,
    )) {
      _showOutcome('Aksi Diblokir 🚫',
          'Kamu belum bisa mengajak pacaran pada usia sekarang.');
      return;
    }

    final bool isSameSex = userGen == mateGen;
    final int successChance = isSameSex ? 35 : 60;
    final bool success = Random().nextInt(100) < successChance;

    if (success) {
      final int relVal =
          int.tryParse(widget.classmate['relationship'] ?? '50') ?? 50;
      widget.classmate['relationship'] =
          (relVal + 20).clamp(0, 100).toString();

      // PERBAIKAN: Tambahkan ! pada akses map agar sesuai Map<String, String>
      if (widget.character.partner == null) {
        widget.character.partner = {
          'name': name,
          'gender': mateGen,
          'age': widget.classmate['age']!,
          'relationship': widget.classmate['relationship']!,
          'relation': 'Pacar',
          'isDeceased': 'false',
        };
      } else {
        widget.character.secondPartner = {
          'name': name,
          'gender': mateGen,
          'age': widget.classmate['age']!,
          'relationship': widget.classmate['relationship']!,
          'relation': 'Pacar (Selingkuhan)',
          'isDeceased': 'false',
        };
        widget.character.isHavingAffair = true;
      }

      widget.character.happiness =
          (widget.character.happiness + 15).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Pacaran Baru! ❤️',
          'Kamu berhasil mengajak $name untuk berpacaran dan dia menerimanya!');
    } else {
      final int change = 10 + Random().nextInt(11);
      widget.classmate['relationship'] =
          ((int.tryParse(widget.classmate['relationship'] ?? '50') ?? 50) -
                  change)
              .clamp(0, 100)
              .toString();
      widget.character.happiness =
          (widget.character.happiness - 5).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Ajakan Ditolak 💔',
          '$name menolak ajakanmu untuk berpacaran. Hubungan kalian sedikit canggung.');
    }
  }
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final name = widget.classmate['name']!;

    final bool isPartner = widget.character.isAnyPartnerNameMatching(name);
    if (isPartner) {
      String partnerRole = 'Pacar';
      if (widget.character.partner != null &&
          widget.character.partner!['name'] == name) {
        partnerRole = widget.character.partner!['relation'] ?? 'Pacar';
      } else if (widget.character.secondPartner != null &&
          widget.character.secondPartner!['name'] == name) {
        partnerRole = widget.character.secondPartner!['relation'] ?? 'Pacar';
      } else if (widget.character.thirdPartner != null &&
          widget.character.thirdPartner!['name'] == name) {
        partnerRole = widget.character.thirdPartner!['relation'] ?? 'Pacar';
      } else if (widget.character.fourthPartner != null &&
          widget.character.fourthPartner!['name'] == name) {
        partnerRole = widget.character.fourthPartner!['relation'] ?? 'Pacar';
      } else if (widget.character.fifthPartner != null &&
          widget.character.fifthPartner!['name'] == name) {
        partnerRole = widget.character.fifthPartner!['relation'] ?? 'Pacar';
      }

      return ActionMenuScreen(
        character: widget.character,
        targetName: name,
        targetRole: partnerRole,
      );
    }

    final gender = widget.classmate['gender']!;
    final int age = int.tryParse(widget.classmate['age'] ?? '0') ??
        widget.character.age;
    final int rel =
        int.tryParse(widget.classmate['relationship'] ?? '50') ?? 50;
    final String schoolLevel = widget.character.age <= 12
        ? 'SD'
        : widget.character.age <= 15
            ? 'SMP'
            : 'SMA';
    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: schoolLevel,
      happiness: rel,
    );

    final String resolvedRole = _resolveRole(name);
    final String resolvedRelation = _resolveRelation(name);
    final bool isFemale = gender.toLowerCase() == 'perempuan';

    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card Header (Family-style layout)
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242424) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Builder(builder: (context) {
                                final currentYear = widget.character.currentDate?.year ??
                                    widget.character.birthDate?.year ??
                                    DateTime.now().year;
                                final birthYear = currentYear - age;
                                return Text(
                                  'Tanggal Lahir: 4 September $birthYear | $age tahun',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.blueGrey.shade300
                                        : Colors.blueGrey.shade600,
                                  ),
                                );
                              }),
                              const SizedBox(height: 2),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Builder(builder: (context) {
                                final String bCountry =
                                    widget.character.birthCountry ??
                                        widget.character.location;
                                final String bFlag =
                                    CountryHelper.getFlagEmoji(bCountry);
                                final String bFlagStr =
                                    bFlag.isNotEmpty ? ' $bFlag' : '';
                                final String lCountry = widget.character.location;
                                final String lFlag =
                                    CountryHelper.getFlagEmoji(lCountry);
                                final String lFlagStr =
                                    lFlag.isNotEmpty ? ' $lFlag' : '';
                                final String cityStr =
                                    widget.character.currentCity != null
                                        ? '${widget.character.currentCity}, '
                                        : '';
                                return Text(
                                  'Kebangsaan: $bCountry$bFlagStr • Tinggal di: $cityStr$lCountry$lFlagStr',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    'Hubungan: $resolvedRole • ',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                                  ),
                                  Icon(
                                    isFemale ? Icons.female : Icons.male,
                                    size: 16,
                                    color: isFemale ? Colors.pinkAccent : Colors.blueAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isStatsVisible = !_isStatsVisible;
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detail & Statistik',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isStatsVisible ? 'Sembunyikan' : 'Tampilkan',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  _isStatsVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isStatsVisible) ...[
                      const SizedBox(height: 10),
                      // Bar: Tingkat Hubungan
                      Row(
                        children: [
                          Text(
                            'Tingkat Hubungan: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: rel / 100.0,
                                backgroundColor: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  rel > 70
                                      ? Colors.amber.shade700
                                      : (rel > 40 ? Colors.amber.shade600 : Colors.red),
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$rel%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Bar: Tingkat Kecerdasan
                      Row(
                        children: [
                          Text(
                            'Tingkat Kecerdasan: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: int.parse(
                                        widget.classmate['intelligence'] ?? '50') /
                                    100.0,
                                backgroundColor: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${widget.classmate['intelligence'] ?? '50'}%',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Bar: Nilai Kekayaan
                      Builder(builder: (context) {
                        final int wealthVal =
                            widget.character.getTargetWealth(name, resolvedRole);
                        final double progressVal =
                            (wealthVal / 10000.0).clamp(0.0, 1.0);
                        Color barColor = Colors.green;

                        final jobInfo =
                            widget.character.getNPCJobInfo(name, resolvedRole);
                        final String statusText =
                            jobInfo['status'] == 'Sekolah/Kuliah'
                                ? 'Status: Sekolah/Kuliah'
                                : 'Pekerjaan: ${jobInfo['job']} (Gaji: ${CurrencySettings.format(jobInfo['salary'] as int)}/bln)';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Nilai Kekayaan: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: progressVal,
                                      backgroundColor: isDark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(barColor),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  CurrencySettings.format(wealthVal),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: barColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ============================
            // Section Title
            // ============================
            Text(
              'PILIH AKSI INTERAKSI TEMAN KELAS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white54 : Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            // ============================
            // List Aksi
            // ============================
            Expanded(
              child: ListView(
                children: [
                  // -------- Lihat Keluarga --------
                  _buildActionTile(
                    icon: Icons.family_restroom,
                    color: Colors.indigo,
                    title: 'Lihat Keluarga',
                    onTap: () {
                      final String mateGender =
                          widget.classmate['gender'] ?? 'Laki-laki';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NpcFamilyViewScreen(
                            npcName: name,
                            npcGender: mateGender,
                            npcAge: age,
                            npcRole: resolvedRole,
                            character: widget.character,
                          ),
                        ),
                      );
                    },
                  ),

                  // -------- Romance Actions --------
                  if (_shouldShowRomanceButtons(widget.character.age, age)) ...[
                    if (AdultFeatures.canMakeLove(
                      userAge: widget.character.age,
                      role: resolvedRole,
                      relation: resolvedRelation,
                    ))
                      _buildActionTile(
                        icon: Icons.favorite,
                        color: Colors.pink,
                        title: 'Bercinta / Make Love',
                        onTap: _handleBercinta,
                      ),

                    if (AdultFeatures.canMasturbateTogether() &&
                        widget.character.age >= 12)
                      _buildActionTile(
                        icon: Icons.flash_on,
                        color: Colors.purple,
                        title: 'Ajak Masturbasi Bersama',
                        onTap: () {
                          final int relVal = int.tryParse(
                                  widget.classmate['relationship'] ?? '50') ??
                              50;
                          int successChance =
                              PersentaseAjakan.getSuccessChance(
                            character: widget.character,
                            relationType: resolvedRole,
                            viewerName: name,
                          );
                          final bool success =
                              Random().nextInt(100) < successChance;
                          if (success) {
                            AjakanMasturbasiDialog.show(
                              context: context,
                              character: widget.character,
                              relationType: resolvedRole,
                              viewerName: name,
                              targetGender: gender,
                              isUserInitiated: true,
                              onComplete: () {
                                setState(() {});
                                widget.onRefresh();
                              },
                            );
                          } else {
                            final change = 10 + Random().nextInt(11);
                            widget.classmate['relationship'] =
                                (relVal - change).clamp(0, 100).toString();
                            widget.character.happiness =
                                (widget.character.happiness - 15)
                                    .clamp(0, 100);
                            widget.onRefresh();
                            _showOutcome('Ajakan Ditolak ❌',
                                '$name menolak ajakan masturbasi bersamamu secara mentah-mentah! (-$change% Hubungan, -15% Kebahagiaan).');
                          }
                        },
                      ),

                    if (AdultFeatures.canProposeDating(
                      resolvedRole,
                      resolvedRelation,
                      userAge: widget.character.age,
                    ))
                      _buildActionTile(
                        icon: widget.character.partner != null
                            ? Icons.heart_broken
                            : Icons.favorite_border,
                        color: widget.character.partner != null
                            ? Colors.deepOrange
                            : Colors.redAccent,
                        title: widget.character.partner != null
                            ? 'Ajak Pacaran (Selingkuh?)'
                            : 'Ajak Pacaran',
                        onTap: _handleAjakPacaran,
                      ),
                  ],

                  // -------- Berteman --------
                  _buildActionTile(
                    icon: Icons.group_add,
                    color: Colors.teal,
                    title: 'Berteman',
                    onTap: () {
                      final int currentRel =
                          int.tryParse(widget.classmate['relationship'] ?? '50') ??
                              50;
                      // 60% jika hubungannya >= 50, dan 40% jika di bawah 50
                      final int successChance =
                          currentRel >= 50 ? 60 : 40;
                      final bool isAccepted =
                          Random().nextInt(100) < successChance;

                      if (isAccepted) {
                        final int change = 10 + Random().nextInt(11);
                        widget.classmate['relationship'] =
                            (currentRel + change).clamp(0, 100).toString();
                        widget.classmate['isFriend'] = 'true';
                        widget.classmate['relation'] = 'Teman';

                        // Tambahkan ke daftar teman karakter (jika belum ada)
                        final bool alreadyInFriends = widget
                            .character.friends
                            .any((f) => f['name'] == name);
                        if (!alreadyInFriends) {
                          widget.character.friends.add(widget.classmate);
                        }

                        widget.character.happiness =
                            (widget.character.happiness + 10).clamp(0, 100);
                        widget.character.inbox.add(
                            '🤝 Pertemanan Baru: $name menerima ajakan berteman darimu!');
                        widget.onRefresh();
                        _showOutcome(
                          'Ajakan Berteman Diterima! 🤝',
                          'Kamu mengajak $name untuk berteman dan dia merespon dengan hangat! $name sekarang telah menjadi teman dekatmu.',
                        );
                      } else {
                        final int change = 5 + Random().nextInt(6);
                        widget.classmate['relationship'] =
                            (currentRel - change).clamp(0, 100).toString();
                        widget.character.happiness =
                            (widget.character.happiness - 5).clamp(0, 100);
                        widget.character.inbox.add(
                            '💔 Pertemanan Ditolak: $name menolak ajakan berteman darimu.');
                        widget.onRefresh();
                        _showOutcome(
                          'Ajakan Berteman Ditolak 💔',
                          'Kamu mengajak $name untuk berteman, namun dia menolak ajakanmu secara halus. Hubungan kalian sedikit merenggang.',
                        );
                      }
                    },
                  ),

                  // -------- Berikan Pujian --------
                  _buildActionTile(
                    icon: Icons.thumb_up,
                    color: Colors.blueAccent,
                    title: 'Berikan Pujian',
                    onTap: () {
                      final change = 5 + Random().nextInt(6);
                      widget.classmate['relationship'] =
                          (rel + change).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness + 5).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Pujian',
                          'Kamu memuji penampilan $name. Dia tersenyum dan terlihat sangat senang!');
                    },
                  ),

                  // -------- Percakapan --------
                  _buildActionTile(
                    icon: Icons.chat_bubble_outline,
                    color: Colors.blue,
                    title: 'Percakapan',
                    onTap: () {
                      final change = 5 + Random().nextInt(11);
                      widget.classmate['relationship'] =
                          (rel + change).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness + 5).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Percakapan',
                          'Kamu mengobrol seru dengan $name tentang game kesukaan kalian. Hubungan kalian meningkat!');
                    },
                  ),

                  // -------- Menggoda --------
                  _buildActionTile(
                    icon: Icons.favorite_border,
                    color: Colors.pink,
                    title: 'Menggoda',
                    onTap: () {
                      final int chance = Random().nextInt(100);
                      if (chance < 30) {
                        final change = 5 + Random().nextInt(11);
                        widget.classmate['relationship'] =
                            (rel - change).clamp(0, 100).toString();
                        widget.character.happiness =
                            (widget.character.happiness - 5).clamp(0, 100);
                        widget.onRefresh();
                        _showOutcome('Gagal Menggoda',
                            'Kamu mencoba menggoda $name tetapi dia merasa tidak nyaman dan menjauh. Hubungan menurun!');
                      } else {
                        final change = 5 + Random().nextInt(11);
                        widget.classmate['relationship'] =
                            (rel + change).clamp(0, 100).toString();
                        widget.character.happiness =
                            (widget.character.happiness + 10).clamp(0, 100);
                        widget.onRefresh();
                        _showOutcome('Menggoda Berhasil',
                            'Kamu menggoda $name dengan cara yang lucu dan dia tersipu! Hubungan meningkat!');
                      }
                    },
                  ),

                  // -------- Gift --------
                  _buildActionTile(
                    icon: Icons.card_giftcard,
                    color: Colors.purple,
                    title: 'Gift',
                    onTap: () {
                      if (widget.character.money < 20) {
                        _showOutcome('Uang Tidak Cukup',
                            'Kamu tidak punya uang untuk membeli hadiah. Kumpulkan uang terlebih dahulu!');
                        return;
                      }
                      final change = 10 + Random().nextInt(16);
                      widget.character.money -= 20;
                      widget.classmate['relationship'] =
                          (rel + change).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness + 15).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Gift Diberikan',
                          'Kamu memberikan hadiah kecil kepada $name. Dia sangat terharu dan berterima kasih! Hubungan meningkat pesat!');
                    },
                  ),

                  // -------- Bertingkah Laku --------
                  _buildActionTile(
                    icon: Icons.emoji_people,
                    color: Colors.blueAccent,
                    title: 'Bertingkah Laku',
                    onTap: () {
                      final change = 3 + Random().nextInt(8);
                      widget.classmate['relationship'] =
                          (rel + change).clamp(0, 100).toString();
                      widget.character.karma =
                          (widget.character.karma + 3).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Bertingkah Laku',
                          'Kamu menunjukkan sikap ramah dan membantu $name. Dia sangat menghargai perilakumu!');
                    },
                  ),

                  // -------- Cium --------
                  if (AdultFeatures.canMakeLove(
                    userAge: widget.character.age,
                    role: resolvedRole,
                    relation: resolvedRelation,
                  ))
                    _buildActionTile(
                      icon: Icons.favorite,
                      color: Colors.pinkAccent,
                      title: 'Cium',
                      onTap: () {
                        if (rel >= 60) {
                          final change = 10 + Random().nextInt(11);
                          widget.classmate['relationship'] =
                              (rel + change).clamp(0, 100).toString();
                          widget.character.happiness =
                              (widget.character.happiness + 5)
                                  .clamp(0, 100);
                          widget.onRefresh();
                          _showOutcome('Ciuman Diterima',
                              'Kamu mencium pipi $name. Dia tersipu dan merasa senang! Hubungan kalian semakin dekat.');
                        } else {
                          final change = 10 + Random().nextInt(11);
                          widget.classmate['relationship'] =
                              (rel - change).clamp(0, 100).toString();
                          widget.character.happiness =
                              (widget.character.happiness - 5)
                                  .clamp(0, 100);
                          widget.onRefresh();
                          _showOutcome('Ciuman Ditolak',
                              'Kamu mencoba mencium $name, tapi dia mundur dengan tatapan tidak nyaman. Kamu merasa malu!');
                        }
                      },
                    ),

                  // -------- Hina --------
                  _buildActionTile(
                    icon: Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                    title: 'Hina',
                    onTap: () {
                      final change = 10 + Random().nextInt(16);
                      widget.classmate['relationship'] =
                          (rel - change).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness - 10).clamp(0, 100);
                      widget.character.karma =
                          (widget.character.karma - 5).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Menghina',
                          'Kamu mengucapkan kata-kata kasar kepada $name. Dia terlihat sangat tersinggung dan hubungan memburuk!');
                    },
                  ),

                  // -------- Buat Keributan --------
                  _buildActionTile(
                    icon: Icons.gavel,
                    color: Colors.orange,
                    title: 'Buat Keributan',
                    onTap: () {
                      final win = Random().nextBool();
                      final relChange = 20 + Random().nextInt(21);
                      if (win) {
                        widget.classmate['relationship'] =
                            (rel - relChange).clamp(0, 100).toString();
                        widget.character.health =
                            (widget.character.health - 5).clamp(0, 100);
                        widget.character.happiness =
                            (widget.character.happiness + 5).clamp(0, 100);
                        widget.onRefresh();
                        _showOutcome('Keributan',
                            'Kamu terlibat perkelahian dengan $name karena adu mulut dan kamu berhasil memenangkannya! Namun tubuhmu sedikit memar.');
                      } else {
                        widget.classmate['relationship'] =
                            (rel - relChange).clamp(0, 100).toString();
                        widget.character.health =
                            (widget.character.health - 15).clamp(0, 100);
                        widget.character.happiness =
                            (widget.character.happiness - 10).clamp(0, 100);
                        widget.onRefresh();
                        _showOutcome('Kalah Keributan',
                            'Kamu berkelahi dengan $name dan kalah telak. Kamu menderita memar parah dan merasa sangat malu!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      color: isDark ? const Color(0xFF242424) : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}