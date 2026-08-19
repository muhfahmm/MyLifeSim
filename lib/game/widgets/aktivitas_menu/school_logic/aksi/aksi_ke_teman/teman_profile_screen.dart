// lib/game/widgets/aktivitas_menu/school_logic/aksi/aksi_ke_teman/teman_profile_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class TemanProfileScreen extends StatefulWidget {
  final Character character;
  final String temanName;
  final String temanGender;
  final int temanAge;
  final int initialRelationship;
  final VoidCallback onRefresh;

  const TemanProfileScreen({
    super.key,
    required this.character,
    required this.temanName,
    required this.temanGender,
    required this.temanAge,
    required this.initialRelationship,
    required this.onRefresh,
  });

  @override
  State<TemanProfileScreen> createState() => _TemanProfileScreenState();
}

class _TemanProfileScreenState extends State<TemanProfileScreen> {
  late int currentRelationship;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    currentRelationship = widget.initialRelationship;
  }

  void _updateRelationship(int change) {
    setState(() {
      currentRelationship = (currentRelationship + change).clamp(0, 100);
      // Update di character juga
      for (var classmate in widget.character.classmates) {
        if (classmate['name'] == widget.temanName) {
          classmate['relationship'] = currentRelationship.toString();
          break;
        }
      }
    });
  }

  void _executeAction(String actionType) {
    int change = 0;
    String resultMsg = '';

    switch (actionType) {
      case 'berteman':
        change = random.nextInt(5) + 3;
        _updateRelationship(change);
        resultMsg = 'Kamu mengajak ${widget.temanName} bermain bersama. Hubungan meningkat +$change!';
        break;
      case 'hadiah':
        change = random.nextInt(6) + 5;
        _updateRelationship(change);
        resultMsg = 'Kamu memberikan hadiah berupa pensil lucu kepada ${widget.temanName}. Dia sangat senang! Hubungan meningkat +$change!';
        break;
      case 'singgung':
        change = random.nextInt(4) + 2;
        _updateRelationship(-change);
        resultMsg = 'Kamu menggoda ${widget.temanName} tentang penampilan fisiknya. Dia terlihat sedikit tersinggung. Hubungan menurun -$change!';
        break;
      case 'cium':
        if (currentRelationship < 50) {
          change = -5;
          resultMsg = '${widget.temanName} terlihat terkejut dan menjauh dari ciuman mu. Hubungan menurun -5!';
        } else if (currentRelationship >= 50 && currentRelationship < 75) {
          change = 10;
          resultMsg = '${widget.temanName} terlihat agak malu tapi menerima ciuman mu di pipi. Hubungan meningkat +10!';
        } else {
          change = 15;
          resultMsg = '${widget.temanName} dengan senang hati menerima ciuman mu. Hubungan meningkat +15!';
        }
        _updateRelationship(change);
        break;

      // ★ AGE 9-11 ROMANCE ACTIONS
      case 'ajak_pacaran':
        _handleAjakPacaran();
        return;

      case 'bercinta':
        _handleBercinta();
        return;
    }

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Aksi Selesai',
      content: Text(resultMsg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    );
  }

  // ★ AGE 9-11: Ajak Pacaran (School Romance Proposal)
  void _handleAjakPacaran() {
    // Check opposite gender
    final bool isOppositeGender = 
      (widget.character.gender.toLowerCase().contains('laki') && widget.temanGender.toLowerCase().contains('perempuan')) ||
      (widget.character.gender.toLowerCase().contains('perempuan') && widget.temanGender.toLowerCase().contains('laki'));

    if (!isOppositeGender) {
      DialogHelper.show(
        context: context,
        title: 'Ajakan Ditolak',
        content: Text('${widget.temanName} tidak tertarik karena kalian sesama jenis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
      return;
    }

    // Acceptance logic based on relationship
    bool accepted = false;
    if (currentRelationship >= 40) {
      accepted = random.nextInt(100) < 70;  // 70% chance
    } else if (currentRelationship >= 25) {
      accepted = random.nextInt(100) < 40;  // 40% chance
    } else {
      accepted = random.nextInt(100) < 15;  // 15% chance
    }

    if (accepted) {
      int relationshipGain = random.nextInt(8) + 10;
      _updateRelationship(relationshipGain);
      widget.onRefresh();

      // ★ ADD TO CHARACTER PARTNERS
      final String roleLabel = widget.temanGender.toLowerCase().contains('perempuan') ? 'Pacar' : 'Pacar';
      
      final newPartner = {
        'name': widget.temanName,
        'gender': widget.temanGender,
        'age': widget.temanAge.toString(),
        'relationship': currentRelationship.toString(),
        'relation': roleLabel,  // 'Pacar' for elementary school romance
      };

      // Add to character's partner if not already set
      if (widget.character.partner == null) {
        widget.character.partner = newPartner;
      } else if (widget.character.secondPartner == null) {
        // If already has a partner, set as second partner
        widget.character.secondPartner = newPartner;
        widget.character.isHavingAffair = true;
      }

      DialogHelper.show(
        context: context,
        title: 'Ajak Pacaran Diterima! 💕',
        content: Text(
          '${widget.temanName} dengan malu-malu menerima ajakanmu untuk menjadi pacar! Sekarang kalian adalah pasangan di sekolah. Hubungan meningkat +$relationshipGain! ☺️',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to see updated relationship screen
              widget.onRefresh();
            },
            child: const Text('Mengerti'),
          ),
        ],
      );
    } else {
      int relationshipLoss = random.nextInt(3) + 1;
      _updateRelationship(-relationshipLoss);
      widget.onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Ajak Pacaran Ditolak 💔',
        content: Text(
          '${widget.temanName} terlihat canggung dan menolak ajakanmu. Mungkin hubungan kalian belum cukup dekat. Hubungan menurun -$relationshipLoss.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
    }
  }

  // ★ AGE 9-11: Bercinta / Make Love (Innocent School Intimacy)
  void _handleBercinta() {
    if (currentRelationship < 60) {
      // Rejection
      int relationshipLoss = random.nextInt(3) + 1;
      _updateRelationship(-relationshipLoss);
      widget.onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Ajakan Ditolak 😞',
        content: Text(
          '${widget.temanName} belum siap untuk moment romantis. "Kita masih terlalu muda untuk itu!" kata ${widget.temanName} sambil menjauh. Hubungan menurun -$relationshipLoss.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
    } else if (currentRelationship >= 60 && currentRelationship < 80) {
      // Moderate acceptance - innocent moments
      int relationshipGain = random.nextInt(6) + 5;
      _updateRelationship(relationshipGain);
      widget.onRefresh();

      final List<String> innocentMoments = [
        'Kalian berciuman di sudut taman sekolah, tersembunyi dari guru. Moment yang manis dan penuh gugup! 💋',
        '${widget.temanName} dengan malu menerima pegangan tangan mu. Kalian berjalan bersama sambil memegang tangan. 🤝❤️',
        'Kalian berdekatan dan berciuman di samping pohon sekolah. Pelajaran yang indah untuk first kiss! 😊💕',
      ];

      String randomMoment = innocentMoments[random.nextInt(innocentMoments.length)];

      DialogHelper.show(
        context: context,
        title: 'Moment Romantis! 💕',
        content: Text(
          '$randomMoment\n\nHubungan meningkat +$relationshipGain!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
    } else {
      // High relationship - deep innocent moments
      int relationshipGain = random.nextInt(8) + 12;
      _updateRelationship(relationshipGain);
      widget.onRefresh();

      final List<String> deepMoments = [
        'Kalian meninggalkan kelas saat jam istirahat dan berciuman dengan penuh perasaan di belakang perpustakaan. Moment yang tak terlupakan! 😍💋',
        'Di taman sekolah, kalian duduk berdekatan dan berbagi ciuman berkali-kali. Hati kalian berdebar-debar penuh kebahagiaan. 💕✨',
        'Kalian berbagi momen intim yang dalam dengan berciuman dan saling merangkul erat. Ini moment terbaik di sekolah! 🌹❤️',
      ];

      String randomMoment = deepMoments[random.nextInt(deepMoments.length)];

      DialogHelper.show(
        context: context,
        title: 'Moment Intim yang Dalam! 💕✨',
        content: Text(
          '$randomMoment\n\nHubungan meningkat +$relationshipGain!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: widget.temanName,
      gender: widget.temanGender,
      age: widget.temanAge,
      happiness: currentRelationship,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.temanName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Avatar dan Info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue.shade100,
                    child: Image.network(
                      avatarUrl,
                      width: 96,
                      height: 96,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(widget.temanGender == 'Laki-laki' ? Icons.male : Icons.female,
                              size: 48, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.temanName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Teman Sekelas | Umur: ${widget.temanAge} tahun',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  // Relationship Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tingkat Kepuasan:', style: TextStyle(fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: currentRelationship / 100,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  currentRelationship > 65
                                      ? Colors.green
                                      : currentRelationship > 35
                                          ? Colors.amber
                                          : Colors.red,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$currentRelationship%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: currentRelationship > 65
                              ? Colors.green
                              : currentRelationship > 35
                                  ? Colors.amber
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Pilih Aksi Interaksi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PILIH AKSI INTERAKSI',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: '😊',
                    title: 'Berteman',
                    onTap: () => _executeAction('berteman'),
                  ),
                  _buildActionCard(
                    icon: '🎁',
                    title: 'Berikan Hadiah',
                    onTap: () => _executeAction('hadiah'),
                  ),
                  _buildActionCard(
                    icon: '😏',
                    title: 'Singgung Dia',
                    onTap: () => _executeAction('singgung'),
                  ),
                  _buildActionCard(
                    icon: '💋',
                    title: 'Cium',
                    onTap: () => _executeAction('cium'),
                  ),

                  // ★ AGE 9-11 ROMANCE ACTIONS
                  if (widget.character.age >= 9 && widget.character.age <= 11) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    const Text(
                      'AKSI ROMANTIS SEKOLAH',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: '💕',
                      title: 'Ajak Pacaran',
                      onTap: () => _executeAction('ajak_pacaran'),
                    ),
                    _buildActionCard(
                      icon: '❤️',
                      title: 'Bercinta / Make Love',
                      onTap: () => _executeAction('bercinta'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.grey.shade50,
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}
