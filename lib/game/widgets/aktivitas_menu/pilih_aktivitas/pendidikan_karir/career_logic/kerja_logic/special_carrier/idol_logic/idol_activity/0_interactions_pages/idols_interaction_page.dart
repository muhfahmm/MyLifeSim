import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/utils/country_helper.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/npc_family_view.dart';
import 'package:mylifesim/store_page/fitur_premium/adult_features/adult_features.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';

class IdolsInteractionPage extends StatefulWidget {
  final Map<String, String> person;
  final Character character;
  final String category; // 'Trainee', 'Main Team', or 'Staff'
  final VoidCallback onRefresh;

  const IdolsInteractionPage({
    super.key,
    required this.person,
    required this.character,
    required this.category,
    required this.onRefresh,
  });

  @override
  State<IdolsInteractionPage> createState() => _IdolsInteractionPageState();
}

class _IdolsInteractionPageState extends State<IdolsInteractionPage> {
  final Random _random = Random();
  late int relationship;
  late int age;
  late String name;
  late String gender;
  late String role;
  late String sexuality;
  late int intelligence;
  late int wealth;

  @override
  void initState() {
    super.initState();
    name = widget.person['name'] ?? 'Rekan';
    gender = widget.person['gender'] ?? 'Perempuan';
    age = int.tryParse(widget.person['age'] ?? '16') ?? 16;
    relationship = int.tryParse(widget.person['relationship'] ?? '50') ?? 50;
    role = widget.person['role'] ??
        (widget.category == 'Trainee' ? 'Anggota Trainee' : 'Anggota Utama');
    sexuality = widget.person['sexuality'] ??
        (_random.nextInt(100) < 15 ? 'Biseksual' : 'Heteroseksual');
    intelligence = int.tryParse(widget.person['intelligence'] ?? '') ??
        (50 + _random.nextInt(41));
    wealth = int.tryParse(widget.person['wealth'] ?? '') ??
        (1000 + _random.nextInt(8001));
  }

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
              if (mounted) setState(() {});
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  void _updateRelationship(int change) {
    setState(() {
      relationship = (relationship + change).clamp(0, 100);
      widget.person['relationship'] = relationship.toString();
    });
    widget.onRefresh();
  }

  bool _isStatsVisible = false;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: relationship,
      forcedSkinColor: widget.person['skinColor'],
    );
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ============================
            // Target Card Info
            // ============================
            Card(
              elevation: 0,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          radius: 22,
                          child: ClipOval(
                            child: Image(
                              image: AvatarImageCache.getImageProvider(
                                  avatarUrl),
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Builder(builder: (context) {
                                final currentYear =
                                    widget.character.currentDate?.year ??
                                        widget.character.birthDate?.year ??
                                        DateTime.now().year;
                                final birthYear = currentYear - age;
                                return Text(
                                  'Tanggal Lahir: 4 September $birthYear | $age tahun',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.blueGrey.shade300
                                        : Colors.blueGrey.shade600,
                                  ),
                                );
                              }),
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (widget.character
                                      .isAnyPartnerNameMatching(name)) ...[
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.pink.shade50,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.pink.shade200,
                                            width: 0.5),
                                      ),
                                      child: const Text(
                                        'Pacar ❤️',
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
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
                                final String lCountry =
                                    widget.character.location;
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
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }),
                              const SizedBox(height: 2),
                              Builder(builder: (context) {
                                final bool isFemale = gender
                                        .trim()
                                        .toLowerCase() ==
                                    'perempuan';
                                final String displayRole =
                                    widget.category == 'Staff'
                                        ? role
                                        : 'Anggota Grup Idol';
                                return Row(
                                  children: [
                                    Text(
                                      'Hubungan: $displayRole • ',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.black54,
                                      ),
                                    ),
                                    Icon(
                                      isFemale
                                          ? Icons.female
                                          : Icons.male,
                                      size: 16,
                                      color: isFemale
                                          ? Colors.pinkAccent
                                          : Colors.blueAccent,
                                    ),
                                  ],
                                );
                              }),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detail & Statistik',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isStatsVisible
                                      ? 'Sembunyikan'
                                      : 'Tampilkan',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  _isStatsVisible
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
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
                      Row(
                        children: [
                          Text(
                            'Tingkat Hubungan: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: relationship / 100.0,
                                backgroundColor: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  relationship > 70
                                      ? Colors.green
                                      : (relationship > 40
                                          ? Colors.amber
                                          : Colors.red),
                                ),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$relationship%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: relationship > 70
                                  ? Colors.green
                                  : (relationship > 40
                                      ? Colors.amber
                                      : Colors.red),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Tingkat Kecerdasan: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: intelligence / 100.0,
                                backgroundColor: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$intelligence%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Nilai Kekayaan: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value:
                                    (wealth / 10000.0).clamp(0.0, 1.0),
                                backgroundColor: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  wealth > 5000
                                      ? Colors.green
                                      : (wealth >= 1000
                                          ? Colors.amber
                                          : Colors.red),
                                ),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$$wealth',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: wealth > 5000
                                  ? Colors.green
                                  : (wealth >= 1000
                                      ? Colors.amber
                                      : Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'PILIH AKSI INTERAKSI IDOL',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NpcFamilyViewScreen(
                            npcName: name,
                            npcGender: gender,
                            npcAge: age,
                            npcRole: role,
                            character: widget.character,
                          ),
                        ),
                      );
                    },
                  ),

                  // -------- Promosikan ke Tim Inti (Khusus GM untuk Trainee) --------
                  if (widget.character.jobName == 'General Manager' &&
                      (widget.category == 'Trainee' || role.contains('Trainee')))
                    _buildActionTile(
                      icon: Icons.star_border,
                      color: Colors.amber.shade800,
                      title: 'Promosikan ke Tim Inti',
                      onTap: () {
                        // Penentuan angka Generasi yang SAMA PERSIS dengan badge di list anggota
                        int genNum;
                        if (age >= 16) {
                          genNum = 5;
                        } else if (age >= 14) {
                          genNum = 6;
                        } else {
                          genNum = 7;
                        }

                        // Masa pelatihan yang realistis
                        int yearsInTrainee = int.tryParse(widget.person['yearsInTrainee'] ?? '') ?? (age - 12).clamp(0, 5);
                        if (yearsInTrainee < 0) yearsInTrainee = 0;

                        DialogHelper.show(
                          context: context,
                          title: '⭐ Promosi Anggota Trainee',
                          showCloseButton: false,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail Trainee:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('• Nama: $name'),
                              Text('• Usia: $age tahun'),
                              Text('• Generasi: Gen $genNum'),
                              Text('• Masa Pelatihan Trainee: $yearsInTrainee tahun'),
                              const SizedBox(height: 14),
                              Text(
                                'Sebagai General Manager, apakah Anda yakin ingin mempromosikan $name secara resmi menjadi Anggota Tim Utama?',
                                style: const TextStyle(fontSize: 13, height: 1.3),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade800,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  // Pindahkan dari idolTrainees ke idolMainMembers
                                  widget.character.idolTrainees.removeWhere(
                                    (t) => t['name'] == name,
                                  );
                                  final promotedMap = Map<String, String>.from(widget.person);
                                  promotedMap['role'] = 'Anggota Utama';
                                  widget.character.idolMainMembers.add(promotedMap);

                                  final promoNotice =
                                      '⭐ Promosi Resmi GM: $name (Gen $genNum) resmi dipromosikan ke Tim Utama oleh General Manager!';
                                  widget.character.idolNews.add(promoNotice);
                                });
                                widget.onRefresh();
                                _showOutcome(
                                  'Promosi Berhasil! ⭐',
                                  'Luar biasa! $name resmi kamu promosikan menjadi Anggota Tim Utama.',
                                );
                              },
                              child: const Text('Ya, Promosikan'),
                            ),
                          ],
                        );
                      },
                    ),

                  // -------- Bercinta / Make Love --------
                  if (widget.character.isAnyPartnerNameMatching(name) ||
                      AdultFeatures.canMakeLove(
                        userAge: widget.character.age,
                        role: role,
                        relation: role,
                      ))
                    _buildActionTile(
                      icon: Icons.favorite,
                      color: Colors.pink,
                      title: 'Bercinta / Make Love',
                      onTap: () {
                        final success = relationship >= 50;
                        if (success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BercintaScreen(
                                character: widget.character,
                                targetName: name,
                                targetRole: role,
                                onActionComplete: () {
                                  if (mounted) setState(() {});
                                  widget.onRefresh();
                                },
                              ),
                            ),
                          );
                        } else {
                          _updateRelationship(-5);
                          _showOutcome('Bercinta Ditolak 🚫',
                              '$name menolak ajakanmu karena hubungan kalian saat ini terasa kurang hangat (minimal 50%).');
                        }
                      },
                    ),

                  // -------- Ajak Masturbasi Bersama --------
                  if ((AdultFeatures.canMasturbateTogether() &&
                          widget.character.age >= 12) ||
                      widget.character.isAnyPartnerNameMatching(name))
                    _buildActionTile(
                      icon: Icons.flash_on,
                      color: Colors.purple,
                      title: 'Ajak Masturbasi Bersama',
                      onTap: () {
                        final bool success = relationship >= 50;
                        if (success) {
                          AjakanMasturbasiDialog.show(
                            context: context,
                            character: widget.character,
                            relationType: role,
                            viewerName: name,
                            targetGender: gender,
                            isUserInitiated: true,
                            onComplete: () {
                              setState(() {});
                              widget.onRefresh();
                            },
                          );
                        } else {
                          final change = 10 + _random.nextInt(11);
                          _updateRelationship(-change);
                          widget.character.happiness =
                              (widget.character.happiness - 15)
                                  .clamp(0, 100);
                          _showOutcome('Ajakan Ditolak ❌',
                              '$name menolak ajakan masturbasi bersamamu karena hubungan kalian saat ini belum cukup hangat (minimal 50%).');
                        }
                      },
                    ),

                  // -------- Putuskan Pacar --------
                  if (widget.character.isAnyPartnerNameMatching(name))
                    _buildActionTile(
                      icon: Icons.heart_broken,
                      color: Colors.red,
                      title: 'Putuskan Pacar',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (confirmContext) => AlertDialog(
                            title: const Text(
                              'Putuskan Hubungan',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                                'Apakah kamu yakin ingin memutuskan hubungan dengan $name?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(confirmContext),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(confirmContext);
                                  setState(() {
                                    if (widget.character.partner != null &&
                                        widget.character.partner!['name'] ==
                                            name) {
                                      widget.character.partner = null;
                                    } else if (widget.character
                                                .secondPartner !=
                                            null &&
                                        widget.character
                                                .secondPartner!['name'] ==
                                            name) {
                                      widget.character.secondPartner =
                                          null;
                                    } else if (widget.character
                                                .thirdPartner !=
                                            null &&
                                        widget.character
                                                .thirdPartner!['name'] ==
                                            name) {
                                      widget.character.thirdPartner =
                                          null;
                                    } else if (widget.character
                                                .fourthPartner !=
                                            null &&
                                        widget.character
                                                .fourthPartner!['name'] ==
                                            name) {
                                      widget.character.fourthPartner =
                                          null;
                                    } else if (widget.character
                                                .fifthPartner !=
                                            null &&
                                        widget.character
                                                .fifthPartner!['name'] ==
                                            name) {
                                      widget.character.fifthPartner =
                                          null;
                                    }
                                    widget.character.secretPartners
                                        .removeWhere(
                                            (p) => p['name'] == name);
                                    if (widget.character.secretPartners
                                            .isEmpty &&
                                        widget.character.secondPartner ==
                                            null) {
                                      widget.character.isHavingAffair =
                                          false;
                                    }

                                    widget.character.exPartners.add({
                                      'name': name,
                                      'gender': gender,
                                      'age': widget.character.age
                                          .toString(),
                                      'relationship': '20',
                                      'relation': 'Mantan Pacar',
                                      'isDeceased': 'false',
                                      'breakInitiator':
                                          widget.character.gender,
                                      'breakReason': 'putus biasa',
                                      if (widget.person['skinColor'] !=
                                          null)
                                        'skinColor': widget
                                            .person['skinColor']!,
                                    });
                                  });
                                  _updateRelationship(-40);

                                  DialogHelper.show(
                                    context: context,
                                    title: 'Putus Hubungan 💔',
                                    content: Text(
                                        'Kamu telah memutuskan hubungan dengan $name. Hubungan kalian sekarang berakhir.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child:
                                            const Text('Mengerti'),
                                      ),
                                    ],
                                  );
                                },
                                child: const Text(
                                  'Ya, Putuskan',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  // -------- Ajak Pacaran --------
                  if (!widget.character.isAnyPartnerNameMatching(name)) ...[
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
                      onTap: () {
                        final isFemale = widget.character.gender
                                .trim()
                                .toLowerCase() ==
                            'perempuan';
                        final isStaff = widget.category == 'Staff';

                        if (isFemale &&
                            isStaff &&
                            widget.character.idolStaffDatingFailures >=
                                3) {
                          setState(() {
                            widget.character.resignJob();
                            widget.character.idolTrainees.clear();
                            widget.character.idolMainMembers.clear();
                            widget.character.idolStaff.clear();
                          });

                          DialogHelper.show(
                            context: context,
                            title: 'Dipecat dari Grup Idol 😡',
                            content: const Text(
                                'Karena kamu terus-menerus mencoba merayu dan mengajak pacaran staff manajemen secara agresif (percobaan ke-4), manajemen menganggap tindakanmu mengganggu profesionalisme kerja secara serius. Kamu resmi dipecat dari grup!'),
                            actions: [
                              Builder(
                                builder: (dialogContext) => TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ),
                            ],
                          );
                          return;
                        }

                        bool accepted = false;
                        if (relationship < 50) {
                          accepted = false;
                        } else if (widget.character.isIdolStaff &&
                            (widget.category == 'Trainee' ||
                                widget.category == 'Main Team')) {
                          accepted = true;
                        } else if (widget.category == 'Trainee' ||
                            widget.category == 'Main Team') {
                          accepted = _random.nextInt(100) < 50;
                        } else {
                          accepted = _random.nextInt(100) < 65;
                        }

                        if (accepted) {
                          final partnerMap = {
                            'name': name,
                            'gender': gender,
                            'relationship': relationship.toString(),
                            'age': age.toString(),
                            'isDeceased': 'false',
                            'sexuality': sexuality,
                            'relation': 'Pacar',
                            if (widget.person['skinColor'] != null)
                              'skinColor': widget.person['skinColor']!,
                          };
                          widget.character
                              .addPartnerToFreeSlot(partnerMap);
                          _updateRelationship(20);
                          _showOutcome('Pacaran Sukses! ❤️',
                              'Luar biasa! $name menerima ajakan pacaranmu. Sekarang kalian resmi berpasangan! 😍');
                        } else {
                          _updateRelationship(-10);
                          if (isFemale && isStaff) {
                            widget.character.idolStaffDatingFailures++;
                            final remaining = 3 -
                                widget.character
                                    .idolStaffDatingFailures;
                            if (remaining > 0) {
                              _showOutcome('Ajakan Ditolak 💔',
                                  '$name menolak ajakan pacaranmu dengan sopan karena ingin menjaga profesionalitas kerja saat ini.\n(Peringatan: Kamu memiliki $remaining kesempatan lagi sebelum tindakan merayu staff ini membuatmu dipecat!)');
                            } else {
                              _showOutcome('Ajakan Ditolak 💔',
                                  '$name menolak ajakan pacaranmu dengan sopan.\n(Peringatan Keras: Ini adalah kegagalan ke-3 merayu staff! Jika kamu mencoba merayu staff lagi, kamu akan langsung dipecat!)');
                            }
                          } else {
                            _showOutcome('Ajakan Ditolak 💔',
                                '$name menolak ajakan pacaranmu dengan sopan.');
                          }
                        }
                      },
                    ),
                  ],

                  // -------- Minta Naik Gaji (Khusus General Manager) --------
                  if (role == 'General Manager') ...[
                    _buildActionTile(
                      icon: Icons.monetization_on_outlined,
                      color: Colors.green,
                      title: 'Minta Naik Gaji',
                      onTap: () {
                        if (widget.character.idolSalaryRaiseCount >= 2) {
                          _showOutcome('Minta Naik Gaji 🚫',
                              'General Manager menolak mentah-mentah permintaanmu. Kamu sudah mencapai batas maksimal kenaikan gaji (1-2 kali)!');
                          return;
                        }

                        final bool isTrainee =
                            widget.character.jobName == 'Idol (Trainee)';
                        final bool isMainTeam = widget.character.jobName ==
                            'Idol (Main Performer)';

                        int successChance = 0;
                        if (isTrainee) {
                          successChance = 20;
                        } else if (isMainTeam) {
                          successChance = 40;
                        }

                        final bool success =
                            _random.nextInt(100) < successChance;
                        if (success) {
                          setState(() {
                            widget.character.idolSalaryRaiseCount++;
                            int currentSalary =
                                widget.character.jobSalary ?? 1000;
                            int raiseAmount =
                                (currentSalary * 0.20).toInt();
                            widget.character.jobSalary =
                                currentSalary + raiseAmount;
                          });
                          _updateRelationship(10);
                          _showOutcome('Naik Gaji Berhasil! 💰',
                              'Selamat! General Manager menyetujui permintaanmu. Gajimu naik menjadi \$${widget.character.jobSalary} per bulan!');
                        } else {
                          _updateRelationship(-8);
                          _showOutcome('Naik Gaji Gagal ❌',
                              'General Manager menolak permintaan naik gajimu. Dia merasa kinerjamu saat ini belum cukup menonjol.');
                        }
                      },
                    ),
                  ],

                  // -------- Aksi Spesifik Berdasarkan Peran GM vs Biasa --------
                  if (widget.character.jobName == 'General Manager') ...[
                    // ===== AKSI KHUSUS GENERAL MANAGER =====

                    // -------- Pengarahan & Evaluasi Performance --------
                    _buildActionTile(
                      icon: Icons.assignment_turned_in_outlined,
                      color: Colors.blue,
                      title: 'Pengarahan & Evaluasi Performance',
                      onTap: () {
                        final change = 5 + _random.nextInt(6);
                        _updateRelationship(change);
                        _showOutcome('Pengarahan Performance 📋',
                            'Kamu memberikan pengarahan strategis serta evaluasi rutin perkembangan panggung kepada $name. Dia mencatat semua saranmu dengan antusias.');
                      },
                    ),

                    // -------- Apresiasi Kinerja --------
                    _buildActionTile(
                      icon: Icons.star_border_purple500,
                      color: Colors.amber,
                      title: 'Apresiasi Kinerja',
                      onTap: () {
                        final change = 6 + _random.nextInt(6);
                        _updateRelationship(change);
                        _showOutcome('Apresiasi Kinerja 🌟',
                            'Kamu memberikan apresiasi atas kedisiplinan dan kerja keras $name dalam grup. Dia merasa dihargai oleh manajemen!');
                      },
                    ),

                    // -------- Tegur & Evaluasi Kritis --------
                    _buildActionTile(
                      icon: Icons.gavel,
                      color: Colors.deepOrange,
                      title: 'Tegur & Evaluasi Kritis',
                      onTap: () {
                        final change = 6 + _random.nextInt(6);
                        _updateRelationship(-change);
                        _showOutcome('Teguran Profesional ⚠️',
                            'Kamu memberikan teguran tegas atas kekurangan disiplin atau performa $name di atas panggung. Dia menerima teguranmu dengan serius.');
                      },
                    ),

                    // -------- Berikan Konseling Kinerja --------
                    _buildActionTile(
                      icon: Icons.psychology_outlined,
                      color: Colors.teal,
                      title: 'Berikan Konseling Kinerja',
                      onTap: () {
                        final change = 5 + _random.nextInt(6);
                        _updateRelationship(change);
                        _showOutcome('Konseling Kinerja 🧠',
                            'Kamu mendengarkan keluh kesah $name dan memberikan bimbingan mental sebagai General Manager. Hubungan kalian menjadi semakin solid.');
                      },
                    ),
                  ] else ...[
                    // ===== AKSI UNTUK PEMAIN NON-GM =====

                    // -------- Percakapan --------
                    _buildActionTile(
                      icon: Icons.chat_bubble_outline,
                      color: Colors.blue,
                      title: 'Percakapan',
                      onTap: () {
                        final change = 5 + _random.nextInt(6);
                        _updateRelationship(change);
                        widget.character.happiness =
                            (widget.character.happiness + 5).clamp(0, 100);
                        _showOutcome('Percakapan',
                            'Kamu mengobrol santai dengan $name mengenai persiapan event handshake mendatang. Hubungan meningkat!');
                      },
                    ),

                    // -------- Latihan Bareng (Khusus Rekan Idol) --------
                    if (widget.category != 'Staff') ...[
                      _buildActionTile(
                        icon: Icons.accessibility_new,
                        color: Colors.pink,
                        title: 'Latihan Bareng',
                        onTap: () {
                          final change = 6 + _random.nextInt(7);
                          _updateRelationship(change);
                          _showOutcome('Latihan Bareng 💃',
                              'Kamu mengajak $name latihan blocking panggung tambahan. Kerja sama tim kalian semakin meningkat!');
                        },
                      ),
                    ],

                    // -------- Minta Masukan (Khusus Staff) --------
                    if (widget.category == 'Staff') ...[
                      _buildActionTile(
                        icon: Icons.feedback_outlined,
                        color: Colors.indigo,
                        title: 'Minta Masukan',
                        onTap: () {
                          final change = 4 + _random.nextInt(5);
                          _updateRelationship(change);
                          _showOutcome('Minta Masukan 📋',
                              'Kamu meminta evaluasi penampilan teatermu kepada $name. Dia memberimu kiat-kiat yang sangat membantu!');
                        },
                      ),
                    ],

                    // -------- Bertingkah Laku --------
                    _buildActionTile(
                      icon: Icons.emoji_people,
                      color: Colors.blueAccent,
                      title: 'Bertingkah Laku',
                      onTap: () {
                        final change = 3 + _random.nextInt(8);
                        _updateRelationship(change);
                        widget.character.karma =
                            (widget.character.karma + 3).clamp(0, 100);
                        _showOutcome('Bertingkah Laku',
                            'Kamu menunjukkan sikap sopan santun dan kedewasaan di depan $name. Dia sangat menghargaimu!');
                      },
                    ),

                    // -------- Hina --------
                    _buildActionTile(
                      icon: Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                      title: 'Hina',
                      onTap: () {
                        final change = 10 + _random.nextInt(11);
                        _updateRelationship(-change);
                        widget.character.happiness =
                            (widget.character.happiness - 10).clamp(0, 100);
                        widget.character.karma =
                            (widget.character.karma - 5).clamp(0, 100);
                        _showOutcome('Menghina 😡',
                            'Kamu mengejek cara bernyanyi/kinerja $name. Dia sangat marah dan terluka atas perkataanmu.');
                      },
                    ),
                  ],

                  // -------- Cari Muka / Puji --------
                  _buildActionTile(
                    icon: Icons.thumb_up_alt_outlined,
                    color: Colors.teal,
                    title: widget.category == 'Staff'
                        ? 'Cari Muka (Puji)'
                        : 'Berikan Pujian',
                    onTap: () {
                      final success = _random.nextBool();
                      if (success) {
                        final change = 6 + _random.nextInt(6);
                        _updateRelationship(change);
                        _showOutcome('Pujian Berhasil',
                            'Kamu memberikan pujian yang tulus kepada $name. Dia tersenyum senang dan menghargai perkataanmu!');
                      } else {
                        final change = 5 + _random.nextInt(6);
                        _updateRelationship(-change);
                        _showOutcome('Pujian Gagal',
                            'Kamu mencoba memuji $name, namun dia merasa kamu hanya mencari muka dan menanggapinya dengan dingin.');
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
                            'Kamu tidak memiliki cukup uang untuk membelikan hadiah.');
                        return;
                      }
                      final change = 10 + _random.nextInt(11);
                      widget.character.money -= 20;
                      _updateRelationship(change);
                      widget.character.happiness =
                          (widget.character.happiness + 15).clamp(0, 100);
                      _showOutcome('Memberi Hadiah 🎁',
                          'Kamu memberikan cinderamata kecil untuk $name. Dia sangat gembira menerima pemberianmu!');
                    },
                  ),

                  // -------- Menggoda --------
                  _buildActionTile(
                    icon: Icons.favorite_border,
                    color: Colors.pinkAccent,
                    title: 'Menggoda',
                    onTap: () {
                      if (_random.nextInt(100) < 40) {
                        final change = 6 + _random.nextInt(6);
                        _updateRelationship(-change);
                        _showOutcome('Gagal Menggoda 💔',
                            'Kamu mencoba menggoda $name, tapi suasananya terasa agak canggung dan dia mengalihkan pembicaraan.');
                      } else {
                        final change = 5 + _random.nextInt(11);
                        _updateRelationship(change);
                        widget.character.happiness =
                            (widget.character.happiness + 10).clamp(0, 100);
                        _showOutcome('Menggoda Berhasil 💖',
                            'Kamu menggoda $name dengan candaan manis. Dia tersenyum tersipu malu!');
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
      color: isDark ? Colors.grey.shade800 : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
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