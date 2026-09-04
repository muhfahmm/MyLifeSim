// lib/game/widgets/aktivitas_menu/school_logic/actions/interactions/teacher_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/store_page/fitur_premium/adult_features/adult_features.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_ajakan.dart';
import 'dart:math';

class TeacherInteractionPage extends StatefulWidget {
  final Map<String, String> teacher;
  final String role;
  final Character character;
  final VoidCallback onRefresh;

  const TeacherInteractionPage({
    super.key,
    required this.teacher,
    required this.role,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<TeacherInteractionPage> createState() => _TeacherInteractionPageState();
}

class _TeacherInteractionPageState extends State<TeacherInteractionPage> {
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
  String _getTeacherSexuality() {
    return widget.teacher['sexuality'] ?? 'Heteroseksual';
  }

  bool _isSexualityCompatible(String userGender, String teacherGender) {
    final String tSex = _getTeacherSexuality();
    if (tSex == 'Biseksual') return true;
    if (tSex == 'Homoseksual' || tSex == 'Lesbian' || tSex == 'Gay') {
      return userGender == teacherGender;
    }
    // Default: Heteroseksual
    return userGender != teacherGender;
  }

  void _handleBercinta() {
    final String name = widget.teacher['name']!;
    final String userGen = widget.character.gender;
    final String teacherGen = widget.teacher['gender'] ?? 'Laki-laki';
    final int rel = int.tryParse(widget.teacher['relationship'] ?? '50') ?? 50;

    if (!_isSexualityCompatible(userGen, teacherGen)) {
      _showOutcome('Tidak Sesuai 🚫', '$name (${_getTeacherSexuality()}) tidak tertarik dengan jenis kelaminmu.');
      return;
    }

    final int successChance = rel >= 70 ? 70 : (rel >= 40 ? 50 : 30);
    final bool success = Random().nextInt(100) < successChance;

    if (success) {
      final int change = 15 + Random().nextInt(11);
      widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
      widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Berhasil 💖', 'Kamu berhasil melakukan hubungan intim dengan $name! Hubungan kalian meningkat pesat.');
    } else {
      final int change = 10 + Random().nextInt(16);
      widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
      widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Ditolak 💔', '$name menolak ajakanmu dan merasa sangat terkejut. Hubungan menurun.');
    }
  }

  void _handleAjakPacaran() {
    final String name = widget.teacher['name']!;
    final String userGen = widget.character.gender;
    final String teacherGen = widget.teacher['gender'] ?? 'Laki-laki';
    final int rel = int.tryParse(widget.teacher['relationship'] ?? '50') ?? 50;

    if (widget.character.isAnyPartnerNameMatching(name)) {
      _showOutcome('Sudah Berpacaran 💑', 'Kamu sudah memiliki hubungan dengan $name.');
      return;
    }

    if (!_isSexualityCompatible(userGen, teacherGen)) {
      _showOutcome('Tidak Sesuai 🚫', '$name (${_getTeacherSexuality()}) tidak tertarik dengan jenis kelaminmu untuk berpacaran.');
      return;
    }

    final int successChance = rel >= 70 ? 70 : (rel >= 40 ? 50 : 30);
    final bool success = Random().nextInt(100) < successChance;

    if (success) {
      final int change = 10 + Random().nextInt(11);
      widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
      
      final Map<String, String> newPartnerMap = {
        'name': name,
        'gender': teacherGen,
        'age': widget.teacher['age'] ?? '40',
        'relationship': widget.teacher['relationship'] ?? '50',
        'relation': 'Pacar',
        'isDeceased': 'false',
      };

      if (widget.character.partner == null) {
        widget.character.partner = newPartnerMap;
      } else if (widget.character.secondPartner == null) {
        widget.character.secondPartner = newPartnerMap;
        widget.character.isHavingAffair = true;
      } else {
        widget.character.secretPartners.add(newPartnerMap);
        widget.character.isHavingAffair = true;
      }

      widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Pacaran Baru! ❤️', 'Kamu berhasil mengajak $name untuk berpacaran dan dia menerimanya!');
    } else {
      final int change = 10 + Random().nextInt(11);
      widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
      widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
      widget.onRefresh();
      _showOutcome('Ajakan Ditolak 💔', '$name menolak ajakanmu dan mengingatkanmu untuk menjaga sikap sebagai murid.');
    }
  }
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final name = widget.teacher['name']!;
    final gender = widget.teacher['gender']!;
    final int age = int.tryParse(widget.teacher['age'] ?? '40') ?? 40;
    final int rel = int.tryParse(widget.teacher['relationship'] ?? '50') ?? 50;
    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: 'Guru',
      happiness: rel,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    () {
                      final String sexuality = widget.teacher['sexuality'] ?? 'Heteroseksual';
                      final String gender = widget.teacher['gender'] ?? 'Laki-laki';
                      final currentYear = DateTime.now().year;
                      final birthYear = currentYear - age;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal Lahir: 4 September $birthYear',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kebangsaan: ${widget.character.birthCountry ?? widget.character.location} • Tinggal di: ${widget.character.currentCity != null ? '${widget.character.currentCity}, ' : ''}${widget.character.location}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.role} • Gender: $gender • Umur: $age tahun • Seksualitas: $sexuality • Hubungan: $rel%',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      );
                    }(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Tingkat Hubungan: ',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: rel / 100.0,
                              backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                rel > 70 ? Colors.green : (rel > 40 ? Colors.amber : Colors.red),
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$rel%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rel > 70 ? Colors.green : (rel > 40 ? Colors.amber : Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Builder(builder: (context) {
                      final int wealthVal = widget.character.getTargetWealth(name, 'Guru');
                      final double progressVal = (wealthVal / 1000.0).clamp(0.0, 1.0);
                      Color barColor = Colors.red;
                      if (wealthVal > 500) {
                        barColor = Colors.green;
                      } else if (wealthVal >= 100) {
                        barColor = Colors.amber;
                      }

                      final jobInfo = widget.character.getNPCJobInfo(name, 'Guru');
                      final String statusText = jobInfo['status'] == 'Sekolah/Kuliah'
                          ? 'Status: Sekolah/Kuliah'
                          : 'Pekerjaan: ${jobInfo['job']} (Gaji: \$${jobInfo['salary']}/bln)';

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
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progressVal,
                                    backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                                    minHeight: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '\$$wealthVal',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: barColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 8),

            if (widget.character.age >= 10) ...[
              if (AdultFeatures.canMakeLove(
                userAge: widget.character.age,
                role: widget.role,
                relation: widget.role,
              ))
                _buildActionTile(
                  icon: Icons.favorite,
                  color: Colors.pink,
                  title: 'Bercinta / Make Love',
                  onTap: _handleBercinta,
                ),
              if (AdultFeatures.canMasturbateTogether() && widget.character.age >= 12)
                _buildActionTile(
                  icon: Icons.flash_on,
                  color: Colors.purple,
                  title: 'Ajak Masturbasi Bersama',
                  onTap: () {
                    int successChance = PersentaseAjakan.getSuccessChance(
                      character: widget.character,
                      relationType: widget.role,
                      viewerName: name,
                    );
                    final bool success = Random().nextInt(100) < successChance;
                    if (success) {
                      AjakanMasturbasiDialog.show(
                        context: context,
                        character: widget.character,
                        relationType: widget.role,
                        viewerName: name,
                        targetGender: gender,
                        isUserInitiated: true,
                        onComplete: () {
                          setState(() {});
                          widget.onRefresh();
                        },
                      );
                    } else {
                      if (widget.role == 'Guru' || widget.role == 'Guru BK' || widget.role == 'Kepala Sekolah') {
                        widget.character.happiness = (widget.character.happiness - 50).clamp(0, 100);
                        widget.character.money = (widget.character.money * 0.5).round();
                        widget.character.inbox.add('🚨 DIKELUARKAN: Kamu dilaporkan melakukan pelecehan/tindakan asusila kepada ${widget.role} ($name) dan dikeluarkan dari sekolah!');
                        widget.teacher['relationship'] = '0';
                        
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Rayuan Ditolak (Tragedi) 🚨'),
                            content: Text('$name marah besar dan merasa sangat terganggu! Kamu langsung dilaporkan ke pihak sekolah dan dikeluarkan secara tidak terhormat! (-50% Kebahagiaan, uangmu terpotong 50%, -100% Hubungan).'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pop(context);
                                  widget.onRefresh();
                                },
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                      } else {
                        final change = 15 + Random().nextInt(11);
                        widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
                        widget.character.happiness = (widget.character.happiness - 15).clamp(0, 100);
                        widget.onRefresh();
                        _showOutcome('Ajakan Ditolak ❌', '$name menolak ajakan masturbasi bersamamu secara mentah-mentah! (-$change% Hubungan, -15% Kebahagiaan).');
                      }
                    }
                  },
                ),
              if (AdultFeatures.canProposeDating(widget.role, widget.role, userAge: widget.character.age))
                _buildActionTile(
                  icon: widget.character.partner != null ? Icons.heart_broken : Icons.favorite_border,
                  color: widget.character.partner != null ? Colors.deepOrange : Colors.redAccent,
                  title: widget.character.partner != null ? 'Ajak Pacaran (Selingkuh?)' : 'Ajak Pacaran',
                  onTap: _handleAjakPacaran,
                ),
            ],

            _buildActionTile(
              icon: Icons.thumb_up_alt_outlined,
              color: Colors.teal,
              title: 'Cari Muka (Puji)',
              onTap: () {
                final success = Random().nextBool();
                if (success) {
                  final change = 8 + Random().nextInt(11);
                  widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
                  widget.onRefresh();
                  _showOutcome('Cari Muka', 'Kamu memuji gaya mengajar $name. Dia tersenyum bangga dan menyukaimu!');
                } else {
                  final change = 5 + Random().nextInt(11);
                  widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
                  widget.onRefresh();
                  _showOutcome('Cari Muka Gagal', 'Kamu mencoba memuji $name, tapi dia tahu kamu hanya berpura-pura dan menegurmu!');
                }
              },
            ),

            _buildActionTile(
              icon: Icons.emoji_people,
              color: Colors.blueAccent,
              title: 'Bertingkah Laku',
              onTap: () {
                final change = 3 + Random().nextInt(8);
                widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.karma = (widget.character.karma + 3).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Bertingkah Laku', 'Kamu menunjukkan sikap sopan dan membantu $name. Dia sangat menghargai perilakumu!');
              },
            ),

            _buildActionTile(
              icon: Icons.card_giftcard,
              color: Colors.orange,
              title: 'Gift',
              onTap: () {
                const int giftCost = 100;
                if (widget.character.money >= giftCost) {
                  final change = 10 + Random().nextInt(11);
                  widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
                  widget.character.money -= giftCost;
                  widget.onRefresh();
                  _showOutcome('Memberi Hadiah', 'Kamu memberikan hadiah istimewa kepada $name. Dia sangat senang dan hubunganmu membaik!');
                } else {
                  _showOutcome('Gagal Memberi Hadiah', 'Kamu tidak memiliki cukup uang untuk membeli hadiah. (Butuh $giftCost)');
                }
              },
            ),

            if (AdultFeatures.canMakeLove(
              userAge: widget.character.age,
              role: widget.role,
              relation: widget.role,
            ))
              _buildActionTile(
                icon: Icons.favorite,
                color: Colors.pinkAccent,
                title: 'Cium',
                onTap: () {
                  if (rel >= 60) {
                    final change = 10 + Random().nextInt(11);
                    widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
                    widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                    widget.onRefresh();
                    _showOutcome('Ciuman Diterima', 'Kamu mencium pipi $name. Dia tersipu dan merasa disayangi! Hubungan kalian semakin dekat.');
                  } else {
                    final change = 10 + Random().nextInt(11);
                    widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
                    widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                    widget.onRefresh();
                    _showOutcome('Ciuman Ditolak', 'Kamu mencoba mencium $name, tapi dia mundur dengan tatapan tidak nyaman. Kamu merasa malu!');
                  }
                },
              ),

            _buildActionTile(
              icon: Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              title: 'Menghina',
              onTap: () {
                final change = 15 + Random().nextInt(16);
                widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
                widget.character.karma = (widget.character.karma - 5).clamp(0, 100);
                widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Menghina Guru', 'Kamu mengejek cara berpakaian $name. Dia sangat marah dan kamu dihukum berdiri di depan kelas!');
              },
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
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade100),
      ),
      color: isDark ? Colors.grey.shade800 : null,
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