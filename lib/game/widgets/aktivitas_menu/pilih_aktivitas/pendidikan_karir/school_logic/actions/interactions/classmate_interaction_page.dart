// lib/game/widgets/aktivitas_menu/school_logic/actions/interactions/classmate_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswa_siswi/student_romance_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswa_siswa/siswa_siswa_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswi_siswi/siswi_siswi_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/npc_family_view.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';
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
  State<ClassmateInteractionPage> createState() => _ClassmateInteractionPageState();
}

class _ClassmateInteractionPageState extends State<ClassmateInteractionPage> {
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

  @override
  Widget build(BuildContext context) {
    final name = widget.classmate['name']!;
    
    // Jika teman sekelas ini sudah menjadi pasangan/pacar aktif, tampilkan menu ActionMenuScreen pacar agar menunya konsisten
    final bool isPartner = widget.character.isAnyPartnerNameMatching(name);
    if (isPartner) {
      String partnerRole = 'Pacar';
      if (widget.character.partner != null && widget.character.partner!['name'] == name) {
        partnerRole = widget.character.partner!['relation'] ?? 'Pacar';
      } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == name) {
        partnerRole = widget.character.secondPartner!['relation'] ?? 'Pacar';
      } else if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == name) {
        partnerRole = widget.character.thirdPartner!['relation'] ?? 'Pacar';
      } else if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == name) {
        partnerRole = widget.character.fourthPartner!['relation'] ?? 'Pacar';
      } else if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == name) {
        partnerRole = widget.character.fifthPartner!['relation'] ?? 'Pacar';
      }
      
      return ActionMenuScreen(
        character: widget.character,
        targetName: name,
        targetRole: partnerRole,
      );
    }

    final gender = widget.classmate['gender']!;
    final int age = int.tryParse(widget.classmate['age'] ?? '0') ?? widget.character.age;
    final int rel = int.tryParse(widget.classmate['relationship'] ?? '50') ?? 50;
    // Tentukan level sekolah berdasarkan usia user
    final String schoolLevel = widget.character.age <= 12 ? 'SD' : widget.character.age <= 15 ? 'SMP' : 'SMA';
    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: schoolLevel,
      happiness: rel,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Profile Card
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    () {
                      final String sexuality = widget.classmate['sexuality'] ?? 'Heteroseksual';
                      String typeLabel = 'Teman Sekelas';
                      if (widget.character.univClassmates.any((e) => e['name'] == name)) {
                        typeLabel = 'Teman Kuliah';
                      } else if (widget.character.coworkers.any((e) => e['name'] == name)) {
                        typeLabel = 'Rekan Kerja';
                      } else if (widget.character.supervisor != null && widget.character.supervisor!['name'] == name) {
                        typeLabel = 'Supervisor / Atasan';
                      }
                      return Text(
                        '$typeLabel • Umur: $age tahun • Seksualitas: $sexuality • Hubungan: $rel%',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      );
                    }(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tingkat Kepuasan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: rel / 100.0,
                              backgroundColor: Colors.grey.shade200,
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
                    Row(
                      children: [
                        const Text('Tingkat Kecerdasan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: int.parse(widget.classmate['intelligence'] ?? '50') / 100.0,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${widget.classmate['intelligence'] ?? '50'}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Builder(builder: (context) {
                      String targetRole = 'Teman Sekelas';
                      if (widget.character.univClassmates.any((e) => e['name'] == name)) {
                        targetRole = 'Teman Kuliah';
                      } else if (widget.character.coworkers.any((e) => e['name'] == name)) {
                        targetRole = 'Rekan Kerja';
                      } else if (widget.character.supervisor != null && widget.character.supervisor!['name'] == name) {
                        targetRole = 'Supervisor';
                      }

                      final int wealthVal = widget.character.getTargetWealth(name, targetRole);
                      final double progressVal = (wealthVal / 10000.0).clamp(0.0, 1.0);
                      Color barColor = Colors.red;
                      if (wealthVal > 5000) {
                        barColor = Colors.green;
                      } else if (wealthVal >= 1000) {
                        barColor = Colors.amber;
                      }

                      final jobInfo = widget.character.getNPCJobInfo(name, targetRole);
                      final String statusText = jobInfo['status'] == 'Sekolah/Kuliah'
                          ? 'Status: Sekolah/Kuliah'
                          : 'Pekerjaan: ${jobInfo['job']} (Gaji: \$${jobInfo['salary']}/bln)';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Nilai Kekayaan: ',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold)),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progressVal,
                                    backgroundColor: Colors.grey.shade200,
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
                              color: Colors.black87,
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

            const Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
            ),
            const SizedBox(height: 12),

            // ============ TOMBOL LIHAT KELUARGA ============
            _buildActionTile(
              icon: Icons.people,
              color: Colors.blueGrey,
              title: 'Lihat Keluarga',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NpcFamilyViewScreen(
                      npcName: name,
                      npcGender: gender,
                      npcAge: age,
                      npcRole: 'Teman Sekelas',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            if (StudentRomanceLogic.shouldShowRomanceButtons(
              userAge: widget.character.age,
              classmateAge: age,
            )) ...[
              // Aksi 1: Bercinta / Make Love
              _buildActionTile(
                icon: Icons.favorite,
                color: Colors.pink,
                title: 'Bercinta / Make Love',
                onTap: () {
                  final userGen = widget.character.gender;
                  final mateGen = gender;
                  if (userGen == 'Laki-laki' && mateGen == 'Laki-laki') {
                    SiswaSiswaLogic.bercinta(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else if (userGen == 'Perempuan' && mateGen == 'Perempuan') {
                    SiswiSiswiLogic.bercinta(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else {
                    StudentRomanceLogic.bercinta(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  }
                },
              ),
              // Aksi 2: Ajak Pacaran
              _buildActionTile(
                icon: widget.character.partner != null ? Icons.heart_broken : Icons.favorite_border,
                color: widget.character.partner != null ? Colors.deepOrange : Colors.redAccent,
                title: widget.character.partner != null ? 'Ajak Pacaran (Selingkuh?)' : 'Ajak Pacaran',
                onTap: () {
                  final userGen = widget.character.gender;
                  final mateGen = gender;
                  if (userGen == 'Laki-laki' && mateGen == 'Laki-laki') {
                    SiswaSiswaLogic.ajakPacaran(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else if (userGen == 'Perempuan' && mateGen == 'Perempuan') {
                    SiswiSiswiLogic.ajakPacaran(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else {
                    StudentRomanceLogic.ajakPacaran(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  }
                },
              ),
            ],

            // Aksi 3: Berteman
            _buildActionTile(
              icon: Icons.group_add,
              color: Colors.teal,
              title: 'Berteman',
              onTap: () {
                final change = 5 + Random().nextInt(11);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Berteman', 'Kamu mengajak $name untuk berteman dan dia merespon dengan hangat! Hubungan kalian meningkat!');
              },
            ),

            // Aksi 2: Berikan Pujian
            _buildActionTile(
              icon: Icons.thumb_up,
              color: Colors.blueAccent,
              title: 'Berikan Pujian',
              onTap: () {
                final change = 5 + Random().nextInt(6);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Pujian', 'Kamu memuji penampilan $name. Dia tersenyum dan terlihat sangat senang!');
              },
            ),

            // Aksi 3: Percakapan (Mengobrol)
            _buildActionTile(
              icon: Icons.chat_bubble_outline,
              color: Colors.blue,
              title: 'Percakapan',
              onTap: () {
                final change = 5 + Random().nextInt(11);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Percakapan', 'Kamu mengobrol seru dengan $name tentang game kesukaan kalian. Hubungan kalian meningkat!');
              },
            ),

            // Aksi 4: Menggoda
            _buildActionTile(
              icon: Icons.favorite_border,
              color: Colors.pink,
              title: 'Menggoda',
              onTap: () {
                final int chance = Random().nextInt(100);
                if (chance < 30) {
                  // Gagal menggoda
                  final change = 5 + Random().nextInt(11);
                  widget.classmate['relationship'] = (rel - change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Gagal Menggoda', 'Kamu mencoba menggoda $name tetapi dia merasa tidak nyaman dan menjauh. Hubungan menurun!');
                } else {
                  final change = 5 + Random().nextInt(11);
                  widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Menggoda Berhasil', 'Kamu menggoda $name dengan cara yang lucu dan dia tersipu! Hubungan meningkat!');
                }
              },
            ),

            // Aksi 5: Gift
            _buildActionTile(
              icon: Icons.card_giftcard,
              color: Colors.purple,
              title: 'Gift',
              onTap: () {
                if (widget.character.money < 20) {
                  _showOutcome('Uang Tidak Cukup', 'Kamu tidak punya uang untuk membeli hadiah. Kumpulkan uang terlebih dahulu!');
                  return;
                }
                final change = 10 + Random().nextInt(16);
                widget.character.money -= 20;
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Gift Diberikan', 'Kamu memberikan hadiah kecil kepada $name. Dia sangat terharu dan berterima kasih! Hubungan meningkat pesat!');
              },
            ),

            // Aksi Bertingkah Laku
            _buildActionTile(
              icon: Icons.emoji_people,
              color: Colors.blueAccent,
              title: 'Bertingkah Laku',
              onTap: () {
                final change = 3 + Random().nextInt(8); // 3-10
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.karma = (widget.character.karma + 3).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Bertingkah Laku', 'Kamu menunjukkan sikap ramah dan membantu $name. Dia sangat menghargai perilakumu!');
              },
            ),

            // Aksi Cium
            _buildActionTile(
              icon: Icons.favorite,
              color: Colors.pinkAccent,
              title: 'Cium',
              onTap: () {
                if (rel >= 60) {
                  final change = 10 + Random().nextInt(11); // 10-20
                  widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Ciuman Diterima', 'Kamu mencium pipi $name. Dia tersipu dan merasa senang! Hubungan kalian semakin dekat.');
                } else {
                  final change = 10 + Random().nextInt(11); // 10-20 penurunan
                  widget.classmate['relationship'] = (rel - change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Ciuman Ditolak', 'Kamu mencoba mencium $name, tapi dia mundur dengan tatapan tidak nyaman. Kamu merasa malu!');
                }
              },
            ),

            // Aksi 6: Hina
            _buildActionTile(
              icon: Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              title: 'Hina',
              onTap: () {
                final change = 10 + Random().nextInt(16);
                widget.classmate['relationship'] = (rel - change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                widget.character.karma = (widget.character.karma - 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Menghina', 'Kamu mengucapkan kata-kata kasar kepada $name. Dia terlihat sangat tersinggung dan hubungan memburuk!');
              },
            ),

            // Aksi 7: Buat Keributan (Ajak Berkelahi)
            _buildActionTile(
              icon: Icons.gavel,
              color: Colors.orange,
              title: 'Buat Keributan',
              onTap: () {
                final win = Random().nextBool();
                final relChange = 20 + Random().nextInt(21);
                if (win) {
                  widget.classmate['relationship'] = (rel - relChange).clamp(0, 100).toString();
                  widget.character.health = (widget.character.health - 5).clamp(0, 100);
                  widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Keributan', 'Kamu terlibat perkelahian dengan $name karena adu mulut dan kamu berhasil memenangkannya! Namun tubuhmu sedikit memar.');
                } else {
                  widget.classmate['relationship'] = (rel - relChange).clamp(0, 100).toString();
                  widget.character.health = (widget.character.health - 15).clamp(0, 100);
                  widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Kalah Keributan', 'Kamu berkelahi dengan $name dan kalah telak. Kamu menderita memar parah dan merasa sangat malu!');
                }
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}