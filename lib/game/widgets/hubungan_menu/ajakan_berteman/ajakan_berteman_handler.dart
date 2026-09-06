import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/school_generator.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';

class AjakanBertemanHandler {
  /// Memeriksa dan menampilkan ajakan berteman dari teman sekelas (peluang 60%).
  /// Mengembalikan [true] jika dialog ajakan berteman dipicu.
  static bool checkAndGenerateFriendProposal({
    required BuildContext context,
    required Character character,
    required Random random,
    VoidCallback? onComplete,
  }) {
    // Hanya berlaku untuk usia sekolah / kuliah (usia >= 6)
    if (!character.isAlive) return false;

    // Peluang 60% untuk memicu ajakan berteman
    if (random.nextInt(100) >= 60) return false;

    // Cek status sekolah aktif
    final bool isCurrentlyInSchool = (character.age >= 6 && character.age < 18) && 
        (character.educationHistory['SD'] == 'Belum Lulus' || 
         character.educationHistory['SMP'] == 'Belum Lulus' || 
         character.educationHistory['SMA'] == 'Belum Lulus');

    // Jika usia sekolah aktif, pastikan daftar teman sekelas tersedia
    if (isCurrentlyInSchool) {
      SchoolGenerator.generateClassmatesIfEmpty(character);
    }

    // Kumpulkan seluruh kandidat yang belum berteman dan masih hidup
    final List<Map<String, dynamic>> candidates = [];

    // 1. Teman Sekolah (Hanya jika pemain masih aktif sekolah)
    if (isCurrentlyInSchool) {
      for (var c in character.classmates) {
        if (c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
          candidates.add({'data': c, 'role': 'Teman Sekelas'});
        }
      }
    }

    // 2. Teman Kuliah
    for (var c in character.univClassmates) {
      if (c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
        candidates.add({'data': c, 'role': 'Teman Kuliah'});
      }
    }

    // 3. Rekan Kerja / Teman Kerja
    for (var c in character.coworkers) {
      if (c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
        candidates.add({'data': c, 'role': 'Rekan Kerja'});
      }
    }

    // 3b. Anggota Idol Trainee
    for (var c in character.idolTrainees) {
      if (c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
        candidates.add({'data': c, 'role': 'Rekan Trainee Idol'});
      }
    }

    // 3c. Anggota Idol Main Member
    for (var c in character.idolMainMembers) {
      if (c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
        candidates.add({'data': c, 'role': 'Rekan Member Utama Idol'});
      }
    }

    // 3d. Staf Idol Management
    for (var c in character.idolStaff) {
      if (c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
        candidates.add({'data': c, 'role': 'Staf Agensi Idol'});
      }
    }

    // 4. Sepupu / Keluarga Sejawat (Eksklusi Kakek, Nenek, Paman, Bibi, Ayah, Ibu)
    for (var c in character.extendedFamily) {
      final String relation = (c['relation'] ?? '').toLowerCase();
      final String name = (c['name'] ?? '').toLowerCase();
      final bool isSenior = relation.contains('kakek') || relation.contains('nenek') ||
          relation.contains('paman') || relation.contains('bibi') ||
          relation.contains('ayah') || relation.contains('ibu') ||
          name.contains('kakek') || name.contains('nenek') ||
          name.contains('paman') || name.contains('bibi');

      if (!isSenior && c['isDeceased'] != 'true' && c['isFriend'] != 'true') {
        candidates.add({'data': c, 'role': c['relation'] ?? 'Sepupu'});
      }
    }

    if (candidates.isEmpty) return false;

    // Pilih 1 kandidat secara acak
    final chosen = candidates[random.nextInt(candidates.length)];
    final Map<String, String> target = chosen['data'] as Map<String, String>;
    final String relationLabel = chosen['role'] as String;
    final String friendName = target['name'] ?? 'Teman';
    final String friendGender = target['gender'] ?? 'Perempuan';

    // Tampilkan Dialog Ajakan Berteman
    _showFriendRequestDialog(
      context: context,
      character: character,
      friendName: friendName,
      friendGender: friendGender,
      relationLabel: relationLabel,
      targetData: target,
      onComplete: onComplete,
    );

    return true;
  }

  static void _showFriendRequestDialog({
    required BuildContext context,
    required Character character,
    required String friendName,
    required String friendGender,
    required String relationLabel,
    required Map<String, String> targetData,
    VoidCallback? onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bool isFemale = friendGender.toLowerCase().contains('perempuan');

        final int friendAge = int.tryParse(targetData['age'] ?? '12') ?? character.age;
        final int friendRel = int.tryParse(targetData['relationship'] ?? '50') ?? 50;
        final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
          name: friendName,
          gender: friendGender,
          age: friendAge,
          happiness: friendRel,
          forcedSkinColor: targetData['skinColor'],
        );

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.people_alt_rounded, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ajakan Berteman! 🤝',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                '$relationLabel-mu, $friendName, menyapamu di lorong dan mengajakmu untuk berteman lebih dekat!',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isFemale ? Colors.pink.shade50 : Colors.blue.shade50,
                      child: Image(
                        image: AvatarImageCache.getImageProvider(avatarUrl),
                        width: 36,
                        height: 36,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      isFemale ? Icons.female : Icons.male,
                      color: isFemale ? Colors.pink : Colors.blue,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$friendName ($friendGender)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Tolak Ajakan Berteman
                final int relPenalty = 5 + Random().nextInt(6); // 5 - 10
                int rel = int.tryParse(targetData['relationship'] ?? '50') ?? 50;
                targetData['relationship'] = (rel - relPenalty).clamp(0, 100).toString();
                character.inbox.add('💔 Tolak Pertemanan: Kamu menolak ajakan berteman dari $friendName (-$relPenalty% hubungan).');
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('💔 Kamu menolak ajakan berteman dari $friendName.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                onComplete?.call();
              },
              child: const Text('Tolak', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                // Terima Ajakan Berteman
                int rel = int.tryParse(targetData['relationship'] ?? '50') ?? 50;
                targetData['relationship'] = (rel + 30).clamp(0, 100).toString();
                targetData['isFriend'] = 'true';
                targetData['relation'] = 'Teman';

                // Tambahkan ke daftar teman karakter (jika belum ada)
                final bool alreadyFriend = character.friends.any((f) => f['name'] == friendName);
                if (!alreadyFriend) {
                  character.friends.add(targetData);
                }

                character.happiness = (character.happiness + 10).clamp(0, 100);
                character.inbox.add('🤝 Pertemanan Baru: Kamu dan $friendName sekarang menjadi teman dekat!');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🤝 Selamat! Kamu kini berteman dekat dengan $friendName!'),
                    backgroundColor: Colors.green,
                  ),
                );
                onComplete?.call();
              },
              child: const Text('Terima Ajakan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
