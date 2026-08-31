import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/game/widgets/hubungan_menu/npc_family_view.dart';

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
    role = widget.person['role'] ?? (widget.category == 'Trainee' ? 'Anggota Trainee' : 'Anggota Utama');
    sexuality = widget.person['sexuality'] ?? (_random.nextInt(100) < 15 ? 'Biseksual' : 'Heteroseksual');
    intelligence = int.tryParse(widget.person['intelligence'] ?? '') ?? (50 + _random.nextInt(41));
    wealth = int.tryParse(widget.person['wealth'] ?? '') ?? (1000 + _random.nextInt(8001));
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

  @override
  Widget build(BuildContext context) {
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: relationship,
      forcedSkinColor: widget.person['skinColor'],
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
                      child: ClipOval(
                        child: Image(
                          image: AvatarImageCache.getImageProvider(avatarUrl),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (widget.character.isAnyPartnerNameMatching(name)) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.pink.shade200, width: 0.5),
                            ),
                            child: const Text(
                              'Pacar ❤️',
                              style: TextStyle(color: Colors.pink, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$role • Gender: $gender • Umur: $age tahun • Seksualitas: $sexuality • Hubungan: $relationship%',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tingkat Kepuasan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationship / 100.0,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationship > 70 ? Colors.green : (relationship > 40 ? Colors.amber : Colors.red),
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
                            color: relationship > 70 ? Colors.green : (relationship > 40 ? Colors.amber : Colors.red),
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
                              value: intelligence / 100.0,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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
                        const Text('Nilai Kekayaan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (wealth / 10000.0).clamp(0.0, 1.0),
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                wealth > 5000 ? Colors.green : (wealth >= 1000 ? Colors.amber : Colors.red),
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
                            color: wealth > 5000 ? Colors.green : (wealth >= 1000 ? Colors.amber : Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.category == 'Staff' 
                          ? 'Pekerjaan: $role' 
                          : 'Status: Anggota Grup Idol',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
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

            // Aksi Lihat Keluarga dipaling atas
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
                      npcRole: role,
                    ),
                  ),
                );
              },
            ),

            // Aksi 1: Bercinta / Make Love (Hanya jika berpacaran dengan rekan kerja/staff)
            if (widget.character.isAnyPartnerNameMatching(name)) ...[
              _buildActionTile(
                icon: Icons.favorite,
                color: Colors.pink,
                title: 'Bercinta / Make Love',
                onTap: () {
                  final success = relationship >= 60;
                  if (success) {
                    widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
                    _showOutcome('Bercinta', 'Kamu menghabiskan malam yang sangat romantis bersama pacarmu, $name. Hubungan terasa semakin erat.');
                  } else {
                    _updateRelationship(-5);
                    _showOutcome('Bercinta Ditolak 🚫', '$name menolak ajakanmu karena hubungan kalian saat ini terasa kurang hangat.');
                  }
                },
              ),
              _buildActionTile(
                icon: Icons.heart_broken,
                color: Colors.red,
                title: 'Putuskan Pacar',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (confirmContext) => AlertDialog(
                      title: const Text('Putuskan Hubungan', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: Text('Apakah kamu yakin ingin memutuskan hubungan dengan $name?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(confirmContext),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(confirmContext);
                            setState(() {
                              if (widget.character.partner != null && widget.character.partner!['name'] == name) {
                                widget.character.partner = null;
                              } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == name) {
                                widget.character.secondPartner = null;
                              } else if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == name) {
                                widget.character.thirdPartner = null;
                              } else if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == name) {
                                widget.character.fourthPartner = null;
                              } else if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == name) {
                                widget.character.fifthPartner = null;
                              }
                              widget.character.secretPartners.removeWhere((p) => p['name'] == name);
                              if (widget.character.secretPartners.isEmpty && widget.character.secondPartner == null) {
                                widget.character.isHavingAffair = false;
                              }

                              widget.character.exPartners.add({
                                'name': name,
                                'gender': gender,
                                'age': widget.character.age.toString(),
                                'relationship': '20',
                                'relation': 'Mantan Pacar',
                                'isDeceased': 'false',
                                'breakInitiator': widget.character.gender,
                                'breakReason': 'putus biasa',
                              });
                            });
                            _updateRelationship(-40);
                            
                            DialogHelper.show(
                              context: context,
                              title: 'Putus Hubungan 💔',
                              content: Text('Kamu telah memutuskan hubungan dengan $name. Hubungan kalian sekarang berakhir.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Mengerti'),
                                ),
                              ],
                            );
                          },
                          child: const Text('Ya, Putuskan', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],

            // Aksi 2: Ajak Pacaran (Jika belum pacaran)
            if (!widget.character.isAnyPartnerNameMatching(name)) ...[
              _buildActionTile(
                icon: widget.character.partner != null ? Icons.heart_broken : Icons.favorite_border,
                color: widget.character.partner != null ? Colors.deepOrange : Colors.redAccent,
                title: widget.character.partner != null ? 'Ajak Pacaran (Selingkuh?)' : 'Ajak Pacaran',
                onTap: () {
                  final isFemale = widget.character.gender.trim().toLowerCase() == 'perempuan';
                  final isStaff = widget.category == 'Staff';

                  if (isFemale && isStaff && widget.character.idolStaffDatingFailures >= 3) {
                    setState(() {
                      widget.character.resignJob();
                      widget.character.idolTrainees.clear();
                      widget.character.idolMainMembers.clear();
                      widget.character.idolStaff.clear();
                    });

                    DialogHelper.show(
                      context: context,
                      title: 'Dipecat dari Grup Idol 😡',
                      content: const Text('Karena kamu terus-menerus mencoba merayu dan mengajak pacaran staff manajemen secara agresif (percobaan ke-4), manajemen menganggap tindakanmu mengganggu profesionalisme kerja secara serius. Kamu resmi dipecat dari grup!'),
                      actions: [
                        Builder(
                          builder: (dialogContext) => TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext); // close dialog
                              Navigator.pop(context); // close interaction page
                            },
                            child: const Text('OK'),
                          ),
                        ),
                      ],
                    );
                    return;
                  }

                  bool accepted = false;
                  if (widget.category == 'Trainee' || widget.category == 'Main Team') {
                    accepted = _random.nextInt(100) < 30; // 30% berhasil, 70% gagal
                  } else {
                    accepted = relationship >= 70 && (_random.nextInt(100) < 65);
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
                    };
                    widget.character.addPartnerToFreeSlot(partnerMap);
                    _updateRelationship(20);
                    _showOutcome('Pacaran Sukses! ❤️', 'Luar biasa! $name menerima ajakan pacaranmu. Sekarang kalian resmi berpasangan! 😍');
                  } else {
                    _updateRelationship(-10);
                    if (isFemale && isStaff) {
                      widget.character.idolStaffDatingFailures++;
                      final remaining = 3 - widget.character.idolStaffDatingFailures;
                      if (remaining > 0) {
                        _showOutcome('Ajakan Ditolak 💔', '$name menolak ajakan pacaranmu dengan sopan karena ingin menjaga profesionalitas kerja saat ini.\n(Peringatan: Kamu memiliki $remaining kesempatan lagi sebelum tindakan merayu staff ini membuatmu dipecat!)');
                      } else {
                        _showOutcome('Ajakan Ditolak 💔', '$name menolak ajakan pacaranmu dengan sopan.\n(Peringatan Keras: Ini adalah kegagalan ke-3 merayu staff! Jika kamu mencoba merayu staff lagi, kamu akan langsung dipecat!)');
                      }
                    } else {
                      _showOutcome('Ajakan Ditolak 💔', '$name menolak ajakan pacaranmu dengan sopan.');
                    }
                  }
                },
              ),
            ],

            // Aksi Minta Naik Gaji (Khusus General Manager)
            if (role == 'General Manager') ...[
              _buildActionTile(
                icon: Icons.monetization_on_outlined,
                color: Colors.green,
                title: 'Minta Naik Gaji',
                onTap: () {
                  if (widget.character.idolSalaryRaiseCount >= 2) {
                    _showOutcome('Minta Naik Gaji 🚫', 'General Manager menolak mentah-mentah permintaanmu. Kamu sudah mencapai batas maksimal kenaikan gaji (1-2 kali)!');
                    return;
                  }

                  final bool isTrainee = widget.character.jobName == 'Idol (Trainee)';
                  final bool isMainTeam = widget.character.jobName == 'Idol (Main Performer)';

                  int successChance = 0;
                  if (isTrainee) {
                    successChance = 20;
                  } else if (isMainTeam) {
                    successChance = 40;
                  }

                  final bool success = _random.nextInt(100) < successChance;
                  if (success) {
                    setState(() {
                      widget.character.idolSalaryRaiseCount++;
                      int currentSalary = widget.character.jobSalary ?? 1000;
                      int raiseAmount = (currentSalary * 0.20).toInt(); // Naik 20%
                      widget.character.jobSalary = currentSalary + raiseAmount;
                    });
                    _updateRelationship(10);
                    _showOutcome('Naik Gaji Berhasil! 💰', 'Selamat! General Manager menyetujui permintaanmu. Gajimu naik menjadi \$${widget.character.jobSalary} per bulan!');
                  } else {
                    _updateRelationship(-8);
                    _showOutcome('Naik Gaji Gagal ❌', 'General Manager menolak permintaan naik gajimu. Dia merasa kinerjamu saat ini belum cukup menonjol.');
                  }
                },
              ),
            ],

            // Aksi 3: Percakapan (Mengobrol)
            _buildActionTile(
              icon: Icons.chat_bubble_outline,
              color: Colors.blue,
              title: 'Percakapan',
              onTap: () {
                final change = 5 + _random.nextInt(6);
                _updateRelationship(change);
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                _showOutcome('Percakapan', 'Kamu mengobrol santai dengan $name mengenai persiapan event handshake mendatang. Hubungan meningkat!');
              },
            ),

            // Aksi 4: Latihan Bareng (Khusus Rekan Idol)
            if (widget.category != 'Staff') ...[
              _buildActionTile(
                icon: Icons.accessibility_new,
                color: Colors.pink,
                title: 'Latihan Bareng',
                onTap: () {
                  final change = 6 + _random.nextInt(7);
                  _updateRelationship(change);
                  _showOutcome('Latihan Bareng 💃', 'Kamu mengajak $name latihan blocking panggung tambahan. Kerja sama tim kalian semakin meningkat!');
                },
              ),
            ],

            // Aksi 5: Minta Masukan (Khusus Staff)
            if (widget.category == 'Staff') ...[
              _buildActionTile(
                icon: Icons.feedback_outlined,
                color: Colors.indigo,
                title: 'Minta Masukan',
                onTap: () {
                  final change = 4 + _random.nextInt(5);
                  _updateRelationship(change);
                  _showOutcome('Minta Masukan 📋', 'Kamu meminta evaluasi penampilan teatermu kepada $name. Dia memberimu kiat-kiat yang sangat membantu!');
                },
              ),
            ],

            // Aksi 6: Cari Muka / Sanjung
            _buildActionTile(
              icon: Icons.thumb_up_alt_outlined,
              color: Colors.teal,
              title: widget.category == 'Staff' ? 'Cari Muka (Puji)' : 'Berikan Pujian',
              onTap: () {
                final success = _random.nextBool();
                if (success) {
                  final change = 6 + _random.nextInt(6);
                  _updateRelationship(change);
                  _showOutcome('Pujian Berhasil', 'Kamu memberikan pujian yang tulus kepada $name. Dia tersenyum senang dan menghargai perkataanmu!');
                } else {
                  final change = 5 + _random.nextInt(6);
                  _updateRelationship(-change);
                  _showOutcome('Pujian Gagal', 'Kamu mencoba memuji $name, namun dia merasa kamu hanya mencari muka dan menanggapinya dengan dingin.');
                }
              },
            ),

            // Aksi 7: Gift
            _buildActionTile(
              icon: Icons.card_giftcard,
              color: Colors.purple,
              title: 'Gift',
              onTap: () {
                if (widget.character.money < 20) {
                  _showOutcome('Uang Tidak Cukup', 'Kamu tidak memiliki cukup uang untuk membelikan hadiah.');
                  return;
                }
                final change = 10 + _random.nextInt(11);
                widget.character.money -= 20;
                _updateRelationship(change);
                widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
                _showOutcome('Memberi Hadiah 🎁', 'Kamu memberikan cinderamata kecil untuk $name. Dia sangat gembira menerima pemberianmu!');
              },
            ),

            // Aksi 8: Menggoda
            _buildActionTile(
              icon: Icons.favorite_border,
              color: Colors.pinkAccent,
              title: 'Menggoda',
              onTap: () {
                if (_random.nextInt(100) < 40) {
                  final change = 6 + _random.nextInt(6);
                  _updateRelationship(-change);
                  _showOutcome('Gagal Menggoda 💔', 'Kamu mencoba menggoda $name, tapi suasananya terasa agak canggung dan dia mengalihkan pembicaraan.');
                } else {
                  final change = 5 + _random.nextInt(11);
                  _updateRelationship(change);
                  widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                  _showOutcome('Menggoda Berhasil 💖', 'Kamu menggoda $name dengan candaan manis. Dia tersenyum tersipu malu!');
                }
              },
            ),

            // Aksi 9: Bertingkah Laku
            _buildActionTile(
              icon: Icons.emoji_people,
              color: Colors.blueAccent,
              title: 'Bertingkah Laku',
              onTap: () {
                final change = 3 + _random.nextInt(8);
                _updateRelationship(change);
                widget.character.karma = (widget.character.karma + 3).clamp(0, 100);
                _showOutcome('Bertingkah Laku', 'Kamu menunjukkan sikap sopan santun dan kedewasaan di depan $name. Dia sangat menghargaimu!');
              },
            ),

            // Aksi 10: Hina
            _buildActionTile(
              icon: Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              title: 'Hina',
              onTap: () {
                final change = 10 + _random.nextInt(11);
                _updateRelationship(-change);
                widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                widget.character.karma = (widget.character.karma - 5).clamp(0, 100);
                _showOutcome('Menghina 😡', 'Kamu mengejek cara bernyanyi/kinerja $name. Dia sangat marah dan terluka atas perkataanmu.');
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
