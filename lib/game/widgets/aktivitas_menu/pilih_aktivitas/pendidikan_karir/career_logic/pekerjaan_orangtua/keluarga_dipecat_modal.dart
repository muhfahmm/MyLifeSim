// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/pekerjaan_orangtua/keluarga_dipecat_modal.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class KeluargaDipecatModal {
  /// Menampilkan Modal Notifikasi & Aksi ketika anggota keluarga dipecat
  static Future<void> show({
    required BuildContext context,
    required Character character,
    required String familyName,
    required String familyRelation,
    required String previousJob,
    VoidCallback? onComplete,
  }) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final random = Random();

    // Dapatkan data umur dan gender untuk avatar
    int targetAge = 35;
    String targetGender = 'Laki-laki';
    final String cleanRel = familyRelation.toLowerCase();

    if (cleanRel.contains('ibu')) {
      targetGender = 'Perempuan';
      targetAge = character.motherAge ?? 38;
    } else if (cleanRel.contains('ayah')) {
      targetGender = 'Laki-laki';
      targetAge = character.fatherAge ?? 40;
    } else {
      // Cari di siblings
      for (var sib in character.siblings) {
        if (sib['name'] == familyName || cleanRel.contains('kakak') || cleanRel.contains('adik')) {
          targetAge = int.tryParse(sib['age'] ?? '25') ?? 25;
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
      age: targetAge > 0 ? targetAge : 20,
      happiness: 30, // Sedang sedih karena dipecat
      forcedSkinColor: character.getFamilyMemberSkinColor(familyName),
    );

    // Cerita alasan PHK / Pemecatan (10% risiko atau kesalahan besar)
    final List<String> reasons = [
      'Perusahaan tempat $familyName bekerja mengalami krisis keuangan internal dan terpaksa melakukan pemutusan hubungan kerja (PHK) massal.',
      '$familyName membuat kesalahan besar di tempat kerja saat menjalankan tugas operasional, sehingga pihak manajemen langsung memberhentikannya secara sepihak!',
      '$familyName mendadak diberhentikan dari jabatannya sebagai $previousJob karena pelanggaran prosedur kerja berat di kantor.',
      'Perusahaan tempat $familyName bekerja mendadak gulung tikar. $familyName terpaksa kehilangan pekerjaannya sebagai $previousJob.',
    ];
    final String storyReason = reasons[random.nextInt(reasons.length)];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.work_off, color: Colors.red, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PHK! Anggota Keluarga Dipecat',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '$familyRelation DiPHK dari Pekerjaan',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                    // Card Info Anggota Keluarga
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: isFemale ? Colors.pink.shade100 : Colors.blue.shade100,
                            child: ClipOval(
                              child: Image(
                                image: AvatarImageCache.getImageProvider(avatarUrl),
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Text(isFemale ? '👩' : '👨', style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$familyName ($familyRelation)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pekerjaan Sebelumnya: $previousJob',
                                  style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Status Saat Ini: Menganggur 😔',
                                  style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Narasi Kejadian
                    Text(
                      storyReason,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Bagaimana reaksimu terhadap masalah ini?',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Action 1: Beri Semangat
                    _buildActionButton(
                      icon: Icons.favorite,
                      color: Colors.pink,
                      title: '💬 Beri Semangat & Dukungan Moral',
                      subtitle: '+15% Hubungan dengan $familyName',
                      onPressed: () {
                        Navigator.pop(ctx);
                        character.updateTargetRelationship(familyName, familyRelation, 15);
                        character.happiness = (character.happiness + 3).clamp(0, 100);
                        character.inbox.add('❤️ Dukungan: Kamu memberikan semangat kepada $familyName ($familyRelation). Hubungan kalian menjadi lebih erat!');
                        if (onComplete != null) onComplete();
                      },
                    ),
                    const SizedBox(height: 8),

                    // Action 2: Bantu Modal ($500)
                    _buildActionButton(
                      icon: Icons.attach_money,
                      color: character.money >= 500 ? Colors.green : Colors.grey,
                      title: '💵 Bantu Modal Keuangan (${CurrencySettings.format(500)})',
                      subtitle: character.money >= 500 
                          ? '+25% Hubungan, membantu memenuhi kebutuhan hidup'
                          : 'Uangmu tidak cukup (${CurrencySettings.format(500)})',
                      onPressed: character.money >= 500
                          ? () {
                              Navigator.pop(ctx);
                              character.money -= 500;
                              character.updateTargetRelationship(familyName, familyRelation, 25);
                              character.inbox.add('💵 Bantuan: Kamu memberikan modal/uang sebesar ${CurrencySettings.format(500)} untuk $familyName ($familyRelation). Ia sangat terharu atas bantuanmu!');
                              if (onComplete != null) onComplete();
                            }
                          : null,
                    ),
                    const SizedBox(height: 8),

                    // Action 3: Marahi / Salahkan
                    _buildActionButton(
                      icon: Icons.mood_bad,
                      color: Colors.orange,
                      title: '😤 Marahi / Menyalahkan',
                      subtitle: '-20% Hubungan, merusak suasana keluarga',
                      onPressed: () {
                        Navigator.pop(ctx);
                        character.updateTargetRelationship(familyName, familyRelation, -20);
                        character.happiness = (character.happiness - 5).clamp(0, 100);
                        character.inbox.add('💔 Pertengkaran: Kamu menyalahkan $familyName ($familyRelation) atas pemecatannya. Hubungan kalian memburuk!');
                        if (onComplete != null) onComplete();
                      },
                    ),
                    const SizedBox(height: 8),

                    // Action 4: Biarkan Saja
                    _buildActionButton(
                      icon: Icons.do_not_disturb_on_outlined,
                      color: Colors.grey,
                      title: '🤐 Diam & Biarkan Saja',
                      subtitle: 'Tidak memberikan respon khusus',
                      onPressed: () {
                        Navigator.pop(ctx);
                        character.inbox.add('🤐 Cuek: Kamu memilih diam dan tidak memberikan tanggapan atas pemecatan $familyName ($familyRelation).');
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDisabled ? Colors.grey.shade400 : color.withValues(alpha: 0.5)),
            color: isDisabled ? Colors.grey.shade200.withValues(alpha: 0.3) : color.withValues(alpha: 0.08),
          ),
          child: Row(
            children: [
              Icon(icon, color: isDisabled ? Colors.grey : color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDisabled ? Colors.grey : color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
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
