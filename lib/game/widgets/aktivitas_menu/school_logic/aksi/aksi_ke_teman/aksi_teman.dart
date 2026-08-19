// lib/game/widgets/aktivitas_menu/school_logic/aksi/aksi_ke_teman/aksi_teman.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';

class AksiTemanMenu {
  static void showMenu(
    BuildContext context,
    Character character,
    String temanName,
    String temanGender,
    int temanAge,
    VoidCallback onRefresh,
    Function(String, int) updateRelationship,
  ) {
    final Random random = Random();
    
    // Check if character is around age 10 (year 4 SD)
    final bool isYoungRomanceAge = character.age >= 9 && character.age <= 11;

    DialogHelper.show(
      context: context,
      title: 'Pilih Aksi Interaksi',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Apa yang ingin kamu lakukan dengan $temanName?',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // 1. Berteman
          ListTile(
            leading: const Text('😊', style: TextStyle(fontSize: 24)),
            title: const Text('Berteman', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ajak bermain dan berbincang bersama.'),
            onTap: () {
              Navigator.pop(context);
              int relationshipGain = random.nextInt(5) + 3;
              updateRelationship(temanName, relationshipGain);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Berteman',
                content: Text('Kamu mengajak $temanName bermain bersama. Hubungan meningkat +$relationshipGain!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 2. Berikan Hadiah
          ListTile(
            leading: const Text('🎁', style: TextStyle(fontSize: 24)),
            title: const Text('Berikan Hadiah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Memberikan hadiah kecil untuk menunjukkan perhatian.'),
            onTap: () {
              Navigator.pop(context);
              int relationshipGain = random.nextInt(6) + 5;
              updateRelationship(temanName, relationshipGain);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Berikan Hadiah',
                content: Text('Kamu memberikan hadiah berupa pensil lucu kepada $temanName. Dia sangat senang! Hubungan meningkat +$relationshipGain!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 3. Singgung Dia
          ListTile(
            leading: const Text('😏', style: TextStyle(fontSize: 24)),
            title: const Text('Singgung Dia', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Menggoda dan mengganggu secara bercanda.'),
            onTap: () {
              Navigator.pop(context);
              int relationshipLoss = random.nextInt(4) + 2;
              updateRelationship(temanName, -relationshipLoss);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Singgung Dia',
                content: Text('Kamu menggoda $temanName tentang penampilan fisiknya. Dia terlihat sedikit tersinggung. Hubungan menurun -$relationshipLoss!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 4. Cium
          ListTile(
            leading: const Text('💋', style: TextStyle(fontSize: 24)),
            title: const Text('Cium', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Memberikan kecupan (tergantung gender dan hubungan).'),
            onTap: () {
              Navigator.pop(context);
              
              // Logika berbeda berdasarkan gender dan relationship
              int currentRelationship = int.tryParse(
                character.classmates.firstWhere(
                  (cm) => cm['name'] == temanName,
                  orElse: () => {'relationship': '50'},
                )['relationship'] ?? '50',
              ) ?? 50;

              String resultMsg = '';
              int relationshipChange = 0;

              if (currentRelationship < 50) {
                resultMsg = '$temanName terlihat terkejut dan menjauh dari ciuman mu. Hubungan menurun -5!';
                relationshipChange = -5;
              } else if (currentRelationship >= 50 && currentRelationship < 75) {
                resultMsg = '$temanName terlihat agak malu tapi menerima ciuman mu di pipi. Hubungan meningkat +10!';
                relationshipChange = 10;
              } else {
                resultMsg = '$temanName dengan senang hati menerima ciuman mu. Hubungan meningkat +15!';
                relationshipChange = 15;
              }

              updateRelationship(temanName, relationshipChange);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cium',
                content: Text(resultMsg),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // ★ AGE 9-11 ROMANCE ACTIONS (SCHOOL-SPECIFIC LOGIC)
          if (isYoungRomanceAge) ...[
            const Divider(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'AKSI ROMANTIS SEKOLAH',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),

            // 5. Ajak Pacaran (Young Romance - Age 9-11)
            ListTile(
              leading: const Text('💕', style: TextStyle(fontSize: 24)),
              title: const Text('Ajak Pacaran', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Mengajak menjadi pacar (sekolah elementary).'),
              onTap: () {
                Navigator.pop(context);
                
                // Get current relationship
                int currentRel = int.tryParse(
                  character.classmates.firstWhere(
                    (cm) => cm['name'] == temanName,
                    orElse: () => {'relationship': '50'},
                  )['relationship'] ?? '50',
                ) ?? 50;

                // ★ SCHOOL-SPECIFIC LOGIC (Age 9-11)
                // Much simpler than age 12+: only relationship matters
                // No incest checks, no affair system, no age-based psychology
                bool accepted = false;

                // Opposite gender check
                final bool isOppositeGender = 
                  (character.gender.toLowerCase().contains('laki') && temanGender.toLowerCase().contains('perempuan')) ||
                  (character.gender.toLowerCase().contains('perempuan') && temanGender.toLowerCase().contains('laki'));

                if (!isOppositeGender) {
                  // Same gender rejection (simpler at this age)
                  accepted = false;
                } else {
                  // Opposite gender: pure relationship threshold
                  // More forgiving than age 12+ (school innocent logic)
                  if (currentRel >= 40) {
                    accepted = random.nextInt(100) < 70;  // 70% chance if relationship good
                  } else if (currentRel >= 25) {
                    accepted = random.nextInt(100) < 40;  // 40% chance if neutral
                  } else {
                    accepted = random.nextInt(100) < 15;  // 15% chance if low
                  }
                }

                if (accepted) {
                  int relationshipGain = random.nextInt(8) + 10;
                  updateRelationship(temanName, relationshipGain);
                  onRefresh();

                  DialogHelper.show(
                    context: context,
                    title: 'Ajak Pacaran Diterima! 💕',
                    content: Text(
                      '$temanName dengan malu-malu menerima ajakanmu untuk menjadi pacar! Sekarang kalian adalah pasangan di sekolah. Hubungan meningkat +$relationshipGain! ☺️',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Mengerti'),
                      ),
                    ],
                  );
                } else {
                  int relationshipLoss = random.nextInt(3) + 1;
                  updateRelationship(temanName, -relationshipLoss);
                  onRefresh();

                  DialogHelper.show(
                    context: context,
                    title: 'Ajak Pacaran Ditolak 💔',
                    content: Text(
                      '$temanName terlihat canggung dan menolak ajakanmu. Mungkin hubungan kalian belum cukup dekat. Hubungan menurun -$relationshipLoss.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Mengerti'),
                      ),
                    ],
                  );
                }
              },
            ),

            // 6. Bercinta / Make Love (Young Age - Age 9-11 School Logic)
            ListTile(
              leading: const Text('❤️', style: TextStyle(fontSize: 24)),
              title: const Text('Bercinta / Make Love', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Intimate moment (school innocent version).'),
              onTap: () {
                Navigator.pop(context);

                // Get current relationship
                int currentRel = int.tryParse(
                  character.classmates.firstWhere(
                    (cm) => cm['name'] == temanName,
                    orElse: () => {'relationship': '50'},
                  )['relationship'] ?? '50',
                ) ?? 50;

                // ★ SCHOOL-SPECIFIC INTIMATE LOGIC
                // At age 9-11, "Bercinta" is innocent: kissing, hand-holding, hugging
                // NOT full sex (that's age 12+)
                // Gated by relationship threshold (much stricter than romance proposal)

                if (currentRel < 60) {
                  // Insufficient relationship
                  int relationshipLoss = random.nextInt(3) + 1;
                  updateRelationship(temanName, -relationshipLoss);
                  onRefresh();

                  DialogHelper.show(
                    context: context,
                    title: 'Ajakan Ditolak 😞',
                    content: Text(
                      '$temanName belum siap untuk moment romantis. "Kita masih terlalu muda untuk itu!" kata $temanName sambil menjauh. Hubungan menurun -$relationshipLoss.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Mengerti'),
                      ),
                    ],
                  );
                } else if (currentRel >= 60 && currentRel < 80) {
                  // Moderate relationship: partial acceptance
                  int relationshipGain = random.nextInt(6) + 5;
                  updateRelationship(temanName, relationshipGain);
                  onRefresh();

                  final List<String> innocentMoments = [
                    'Kalian berciuman di sudut taman sekolah, tersembunyi dari guru. Moment yang manis dan penuh gugup! 💋',
                    '$temanName dengan malu menerima pegangan tangan mu. Kalian berjalan bersama sambil memegang tangan. 🤝❤️',
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
                  // High relationship: full acceptance (still innocent, not real sex)
                  int relationshipGain = random.nextInt(8) + 12;
                  updateRelationship(temanName, relationshipGain);
                  onRefresh();

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
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
      ],
    );
  }
}
