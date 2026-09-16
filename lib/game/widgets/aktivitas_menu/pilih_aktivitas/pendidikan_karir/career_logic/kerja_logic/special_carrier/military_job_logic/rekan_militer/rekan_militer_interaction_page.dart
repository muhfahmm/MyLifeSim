// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/military_job_logic/rekan_militer/rekan_militer_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/utils/country_helper.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/action_menu.dart';
import 'package:mylifesim/store_page/fitur_premium/adult_features/adult_features.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_ajakan.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/npc_family_view.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';
import 'dart:math';

class RekanMiliterInteractionPage extends StatefulWidget {
  final Map<String, String> coworker;
  final Character character;
  final VoidCallback onRefresh;

  const RekanMiliterInteractionPage({
    super.key,
    required this.coworker,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanMiliterInteractionPage> createState() =>
      _RekanMiliterInteractionPageState();
}

class _RekanMiliterInteractionPageState
    extends State<RekanMiliterInteractionPage> {
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
              setState(() {});
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  bool _shouldShowRomanceButtons(int userAge, int mateAge) {
    return userAge >= 12 && mateAge >= 12;
  }

  void _handleBercinta() {
    final String name = widget.coworker['name']!;

    const String role = 'Rekan Kerja';
    const String relation = 'Rekan Kerja';

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
        int.tryParse(widget.coworker['relationship'] ?? '50') ?? 50;

    final int successChance = relVal >= 50
        ? 100
        : PersentaseAjakan.getSuccessChance(
            character: widget.character,
            relationType: 'Rekan Kerja',
            viewerName: name,
          );
    final bool success =
        relVal >= 50 || Random().nextInt(100) < successChance;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BercintaScreen(
            character: widget.character,
            targetName: name,
            targetRole: role,
            onActionComplete: () {
              final int change = 5 + Random().nextInt(6);
              widget.coworker['relationship'] =
                  (relVal + change).clamp(0, 100).toString();
              if (mounted) setState(() {});
              widget.onRefresh();
            },
          ),
        ),
      );
    } else {
      final int change = 10 + Random().nextInt(11);
      widget.coworker['relationship'] =
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
    final mateGen = widget.coworker['gender'] ?? 'Laki-laki';
    final String name = widget.coworker['name']!;

    const String role = 'Rekan Kerja';
    const String relation = 'Rekan Kerja';

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
          int.tryParse(widget.coworker['relationship'] ?? '50') ?? 50;
      widget.coworker['relationship'] =
          (relVal + 20).clamp(0, 100).toString();

      if (widget.character.partner == null) {
        widget.character.partner = {
          'name': name,
          'gender': mateGen,
          'age': widget.coworker['age'] ?? '28',
          'relationship': widget.coworker['relationship']!,
          'relation': 'Pacar',
          'isDeceased': 'false',
        };
      } else {
        widget.character.secondPartner = {
          'name': name,
          'gender': mateGen,
          'age': widget.coworker['age'] ?? '28',
          'relationship': widget.coworker['relationship']!,
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
      widget.coworker['relationship'] =
          ((int.tryParse(widget.coworker['relationship'] ?? '50') ?? 50) -
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

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final name = widget.coworker['name'] ?? 'Rekan Militer';

    final bool isPartner = widget.character.isAnyPartnerNameMatching(name);
    if (isPartner) {
      String partnerRole = 'Pacar';
      if (widget.character.partner != null &&
          widget.character.partner!['name'] == name) {
        partnerRole = widget.character.partner!['relation'] ?? 'Pacar';
      } else if (widget.character.secondPartner != null &&
          widget.character.secondPartner!['name'] == name) {
        partnerRole = widget.character.secondPartner!['relation'] ?? 'Pacar';
      }

      return ActionMenuScreen(
        character: widget.character,
        targetName: name,
        targetRole: partnerRole,
      );
    }

    final gender = widget.coworker['gender'] ?? 'Laki-laki';
    final int age = int.tryParse(widget.coworker['age'] ?? '28') ?? 28;
    final int rel =
        int.tryParse(widget.coworker['relationship'] ?? '50') ?? 50;

    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: 'SMA',
      happiness: rel,
    );

    final String roleTag = widget.coworker['role'] ?? widget.coworker['title'] ?? 'Prajurit Militer';
    final bool isFemale = gender.toLowerCase() == 'perempuan';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
            // Profile Header Card (Family-style layout)
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
                        AvatarImageCache.buildAvatar(
                          url: avatarUrl,
                          width: 56,
                          height: 56,
                          gender: gender,
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
                                    'Hubungan: Rekan Kerja • ',
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
                                      : (rel > 40
                                          ? Colors.amber.shade600
                                          : Colors.red),
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
                                        widget.coworker['intelligence'] ?? '50') /
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
                            '${widget.coworker['intelligence'] ?? '50'}%',
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
                        final int wealthVal = widget.character
                            .getTargetWealth(name, 'Rekan Kerja');
                        final double progressVal =
                            (wealthVal / 10000.0).clamp(0.0, 1.0);
                        Color barColor = Colors.green;

                        final String statusText =
                            'Pekerjaan: $roleTag (Gaji: ${CurrencySettings.format(2400)}/bln)';

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

            // Section Title
            Text(
              'PILIH AKSI INTERAKSI REKAN KERJA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white54 : Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            // List Aksi
            Expanded(
              child: ListView(
                children: [
                  _buildActionTile(
                    icon: Icons.family_restroom,
                    color: Colors.indigo,
                    title: 'Lihat Keluarga',
                    onTap: () {
                      final String mateGender =
                          widget.coworker['gender'] ?? 'Laki-laki';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NpcFamilyViewScreen(
                            npcName: name,
                            npcGender: mateGender,
                            npcAge: age,
                            npcRole: 'Rekan Kerja',
                            character: widget.character,
                          ),
                        ),
                      );
                    },
                  ),

                  if (_shouldShowRomanceButtons(widget.character.age, age)) ...[
                    if (AdultFeatures.canMakeLove(
                      userAge: widget.character.age,
                      role: 'Rekan Kerja',
                      relation: 'Rekan Kerja',
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
                                  widget.coworker['relationship'] ?? '50') ??
                              50;
                          final int successChance = relVal >= 50
                              ? 100
                              : PersentaseAjakan.getSuccessChance(
                                  character: widget.character,
                                  relationType: 'Rekan Kerja',
                                  viewerName: name,
                                );
                          final bool success =
                              relVal >= 50 || Random().nextInt(100) < successChance;
                          if (success) {
                            AjakanMasturbasiDialog.show(
                              context: context,
                              character: widget.character,
                              relationType: 'Rekan Kerja',
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
                            widget.coworker['relationship'] =
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
                      'Rekan Kerja',
                      'Rekan Kerja',
                      userAge: widget.character.age,
                    ))
                      _buildActionTile(
                        icon: Icons.favorite_border,
                        color: Colors.redAccent,
                        title: 'Ajak Pacaran',
                        onTap: _handleAjakPacaran,
                      ),
                  ],

                  _buildActionTile(
                    icon: Icons.chat_bubble_outline,
                    color: Colors.blue,
                    title: 'Ngobrol',
                    onTap: () {
                      final int relVal = int.tryParse(
                              widget.coworker['relationship'] ?? '50') ??
                          50;
                      widget.coworker['relationship'] =
                          (relVal + 5).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness + 2).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome(
                          'Ngobrol Santai 💬', 'Obrolan hangat dengan $name berjalan seru.');
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.emoji_emotions,
                    color: Colors.amber.shade700,
                    title: 'Bercanda',
                    onTap: () {
                      final int relVal = int.tryParse(
                              widget.coworker['relationship'] ?? '50') ??
                          50;
                      widget.coworker['relationship'] =
                          (relVal + 8).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness + 4).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Bercanda Bersama 😄',
                          'Leluconmu membuat $name tertawa terbahak-bahak!');
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.volunteer_activism,
                    color: Colors.purple,
                    title: 'Puji',
                    onTap: () {
                      final int relVal = int.tryParse(
                              widget.coworker['relationship'] ?? '50') ??
                          50;
                      widget.coworker['relationship'] =
                          (relVal + 10).clamp(0, 100).toString();
                      widget.onRefresh();
                      _showOutcome('Memberikan Pujian 👏',
                          'Pujianmu membuat $name merasa sangat dihargai.');
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.card_giftcard,
                    color: Colors.teal,
                    title: 'Beri Hadiah',
                    onTap: () {
                      if (widget.character.money < 50) {
                        _showOutcome('Uang Tidak Cukup 💸',
                            'Kamu butuh minimal \$50 untuk memberi hadiah.');
                        return;
                      }
                      widget.character.money -= 50;
                      final int relVal = int.tryParse(
                              widget.coworker['relationship'] ?? '50') ??
                          50;
                      widget.coworker['relationship'] =
                          (relVal + 15).clamp(0, 100).toString();
                      widget.onRefresh();
                      _showOutcome('Memberikan Hadiah 🎁',
                          '$name sangat senang menerima hadiah darimu!');
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.sentiment_dissatisfied,
                    color: Colors.deepOrange,
                    title: 'Hina',
                    onTap: () {
                      final int relVal = int.tryParse(
                              widget.coworker['relationship'] ?? '50') ??
                          50;
                      widget.coworker['relationship'] =
                          (relVal - 15).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness - 5).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Menghina 😡',
                          'Perkataanmu yang pedas membuat $name sangat tersinggung.');
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.flash_on,
                    color: Colors.red,
                    title: 'Buat Keributan',
                    onTap: () {
                      final int relVal = int.tryParse(
                              widget.coworker['relationship'] ?? '50') ??
                          50;
                      widget.coworker['relationship'] =
                          (relVal - 25).clamp(0, 100).toString();
                      widget.character.happiness =
                          (widget.character.happiness - 10).clamp(0, 100);
                      widget.onRefresh();
                      _showOutcome('Keributan 💥',
                          'Kamu terlibat pertengkaran hebat dengan $name!');
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
