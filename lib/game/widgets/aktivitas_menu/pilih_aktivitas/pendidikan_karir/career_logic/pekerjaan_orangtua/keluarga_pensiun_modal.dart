// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/pekerjaan_orangtua/keluarga_pensiun_modal.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class KeluargaPensiunModal {
  /// Menampilkan Modal Notifikasi & Aksi ketika anggota keluarga pensiun dari pekerjaan
  static Future<void> show({
    required BuildContext context,
    required Character character,
    required String familyName,
    required String familyRelation,
    required String previousJob,
    required int pensionSalary,
    VoidCallback? onComplete,
  }) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final random = Random();

    // Dapatkan data umur dan gender untuk avatar
    int targetAge = 60;
    String targetGender = 'Laki-laki';
    final String cleanRel = familyRelation.toLowerCase();

    if (cleanRel.contains('ibu')) {
      targetGender = 'Perempuan';
      targetAge = character.motherAge ?? 60;
    } else if (cleanRel.contains('ayah')) {
      targetGender = 'Laki-laki';
      targetAge = character.fatherAge ?? 62;
    } else {
      for (var sib in character.siblings) {
        if (sib['name'] == familyName || cleanRel.contains('kakak') || cleanRel.contains('adik')) {
          targetAge = int.tryParse(sib['age'] ?? '60') ?? 60;
          targetGender = sib['gender'] ?? (familyRelation.contains('Perempuan') ? 'Perempuan' : 'Laki-laki');
          break;
        }
      }
    }

    final bool isFemale = targetGender.toLowerCase().contains('perempuan') || targetGender.toLowerCase().contains('female');

    // Generate Avatar URL
    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: familyName,
      gender: targetGender,
      age: targetAge > 0 ? targetAge : 60,
      happiness: 80, // Bahagia menikmati masa pensiun
      forcedSkinColor: character.getFamilyMemberSkinColor(familyName),
    );

    // Cerita Pensiun
    final List<String> stories = [
      '$familyName resmi purna tugas dari kariernya sebagai $previousJob setelah mengabdi bertahun-tahun dengan penuh dedikasi.',
      'Memasuki usia purnabakti, $familyName memutuskan untuk pensiun dari posisinya sebagai $previousJob untuk lebih banyak menghabiskan waktu bersama keluarga.',
      'Pihak instansi/perusahaan menyelenggarakan acara perpisahan hangat untuk melepas $familyName yang resmi memasuki masa pensiun sebagai $previousJob.',
    ];
    final String storyText = stories[random.nextInt(stories.length)];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              titlePadding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_membership, color: Colors.amber, size: 22),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pensiun! Masa Purna Tugas',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '$familyRelation Memasuki Masa Pensiun 👴👵',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Info Anggota Keluarga & Uang Pensiun 25%
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: isFemale ? Colors.pink.shade100 : Colors.blue.shade100,
                            child: ClipOval(
                              child: Image(
                                image: AvatarImageCache.getImageProvider(avatarUrl),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Text(isFemale ? '👵' : '👴', style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$familyName ($familyRelation)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Pekerjaan Lama: $previousJob',
                                  style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black54),
                                ),
                                Text(
                                  'Uang Pensiun: ${CurrencySettings.format(pensionSalary)}/bln (25%)',
                                  style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Narasi Pensiun
                    Text(
                      storyText,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.3,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      'Bagaimana tanggapanmu atas masa pensiun ini?',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                    // Action 1: Selamat & Rayakan
                    _buildActionButton(
                      icon: Icons.celebration,
                      color: Colors.amber.shade800,
                      title: '🥳 Selamat & Rayakan Masa Pensiun',
                      subtitle: '+15% Hubungan, +5% Kebahagiaan',
                      onPressed: () {
                        Navigator.pop(ctx);
                        character.updateTargetRelationship(familyName, familyRelation, 15);
                        character.happiness = (character.happiness + 5).clamp(0, 100);
                        character.inbox.add('🎉 Pensiun: Kamu mengadakan syukuran sederhana untuk merayakan masa pensiun $familyName ($familyRelation)!');
                        if (onComplete != null) onComplete();
                      },
                    ),
                    const SizedBox(height: 6),

                    // Action 2: Beri Hadiah Pensiun ($300)
                    _buildActionButton(
                      icon: Icons.card_giftcard,
                      color: character.money >= 300 ? Colors.green : Colors.grey,
                      title: '🎁 Beri Hadiah Pensiun Spesial (${CurrencySettings.format(300)})',
                      subtitle: character.money >= 300 
                          ? '+25% Hubungan, hadiah apresiasi purna tugas'
                          : 'Uangmu tidak cukup (${CurrencySettings.format(300)})',
                      onPressed: character.money >= 300
                          ? () {
                              Navigator.pop(ctx);
                              character.money -= 300;
                              character.updateTargetRelationship(familyName, familyRelation, 25);
                              character.happiness = (character.happiness + 5).clamp(0, 100);
                              character.inbox.add('🎁 Hadiah: Kamu memberikan hadiah kenang-kenangan purna tugas seharga ${CurrencySettings.format(300)} kepada $familyName ($familyRelation). Ia merasa sangat dihargai!');
                              if (onComplete != null) onComplete();
                            }
                          : null,
                    ),
                    const SizedBox(height: 6),

                    // Action 3: Biarkan Saja
                    _buildActionButton(
                      icon: Icons.thumb_up_alt_outlined,
                      color: Colors.grey,
                      title: '🤐 Ucapkan Selamat Biasa',
                      subtitle: 'Memberikan ucapan selamat tanpa perayaan khusus',
                      onPressed: () {
                        Navigator.pop(ctx);
                        character.inbox.add('💬 Pensiun: Kamu memberikan ucapan selamat atas masa purna tugas $familyName ($familyRelation).');
                        if (onComplete != null) onComplete();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onPressed,
  }) {
    final bool isDisabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDisabled ? Colors.grey.shade400 : color.withValues(alpha: 0.5)),
            color: isDisabled ? Colors.grey.shade200.withValues(alpha: 0.3) : color.withValues(alpha: 0.08),
          ),
          child: Row(
            children: [
              Icon(icon, color: isDisabled ? Colors.grey : color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                        color: isDisabled ? Colors.grey : color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 9.5,
                        color: isDisabled ? Colors.grey : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
