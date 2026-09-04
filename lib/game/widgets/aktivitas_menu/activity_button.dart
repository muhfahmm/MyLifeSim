// lib/game/widgets/aktivitas_menu/activity_button.dart

import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/masturbasi_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/love/love_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/sosial_media_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/kesehatan/olahraga_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/aksesoris/aksesoris_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/adopsi_anak/adopsi_anak_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/kriminal/kriminal_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/dokter/dokter_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/imigrasi_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/kesuburan/kesuburan_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/lisensi/lisensi_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/pikiran_tubuh/pikiran_tubuh_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/peliharaan_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/operasi_plastik/operasi_plastik_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/rehabilitasi/rehabilitasi_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/salon_spa/salon_spa_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/berbelanja_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/school_menu_page.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/freelance/freelance_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/pekerjaan_part_time_logic/part_time_menu.dart';

class ActivityButton extends StatelessWidget {
  final Character character;
  final bool isAlive;
  final VoidCallback onWork;
  final VoidCallback onExercise;
  final VoidCallback onRefresh;

  const ActivityButton({
    super.key,
    required this.character,
    required this.isAlive,
    required this.onWork,
    required this.onExercise,
    required this.onRefresh,
  });

  void _executeAction(BuildContext context, VoidCallback action) {
    action();
  }

  @override
  Widget build(BuildContext context) {
    final bool isImprisoned = character.isImprisoned;
    return ElevatedButton(
      style: isImprisoned
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.grey.shade600,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            )
          : ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.withValues(alpha: 0.2),
              foregroundColor: Colors.purple,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.purple, width: 1.5),
              ),
            ),
      onPressed: () {
        if (isImprisoned) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Akses ditolak! Kamu sedang berada di dalam penjara.')),
          );
          return;
        }
        if (!isAlive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Karakter sudah meninggal!')),
          );
          return;
        }

        final int age = character.age;

        DialogHelper.show(
          context: context,
          title: 'Pilih Aktivitas',
          isNotification: false,
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              void localRefresh() {
                onRefresh();
                setStateDialog(() {});
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ============================================
                  // 1. PENDIDIKAN & KARIR
                  // ============================================
                  Builder(builder: (ctx) {
                    final textColor = DefaultTextStyle.of(ctx).style.color;
                    return Text(
                      'Pendidikan & Karir',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor?.withValues(alpha: 0.6),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),

                  // Item Sekolah
                  () {
                    final String label;
                    final String subtitle;
                    final Color color;
                    final int minAge;
                    if (age <= 11) {
                      label = 'Sekolah Dasar (SD)';
                      subtitle = 'Belajar dan bermain di Sekolah Dasar';
                      color = Colors.blue;
                      minAge = 6;
                    } else if (age <= 14) {
                      label = 'Sekolah Menengah Pertama (SMP)';
                      subtitle = 'Lanjutkan pendidikan tingkat pertama';
                      color = Colors.blueAccent;
                      minAge = 12;
                    } else if (age <= 17) {
                      label = 'Sekolah Menengah Atas (SMA)';
                      subtitle = 'Pendidikan tingkat atas persiapan karir';
                      color = Colors.purple;
                      minAge = 15;
                    } else {
                      label = 'Universitas (Kuliah)';
                      if (character.univMajor != null) {
                        final String majorName = character.univMajor!.split(' (').first;
                        final String uName = character.univName != null && character.univName!.isNotEmpty
                            ? character.univName!
                            : 'Universitas';
                        subtitle = '$uName • Jurusan $majorName';
                      } else {
                        subtitle = 'Menempuh pendidikan tinggi untuk karir profesional';
                      }
                      color = Colors.indigo;
                      minAge = 18;
                    }

                    return _buildActivityTile(
                      context: context,
                      label: label,
                      subtitle: subtitle,
                      icon: Icons.school,
                      color: color,
                      minAge: minAge,
                      currentAge: age,
                      onTap: () => _executeAction(context, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => age <= 17
                                ? SchoolMenuPage(
                                    character: character,
                                    onRefresh: localRefresh,
                                  )
                                : UnivMenuPage(
                                    character: character,
                                    onRefresh: localRefresh,
                                  ),
                          ),
                        );
                      }),
                    );
                  }(),

                  // Item Bekerja (Pekerjaan Tetap)
                  _buildActivityTile(
                    context: context,
                    label: character.jobName != null
                        ? 'Bekerja (${character.jobName})'
                        : 'Bekerja',
                    subtitle: (character.jobName != null && character.jobSalary != null)
                        ? '${character.jobName} - Gaji: \$${character.jobSalary.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/tahun'
                        : 'Mulai bekerja untuk menghasilkan uang tunai',
                    icon: Icons.work,
                    color: Colors.green,
                    minAge: (character.gender == 'Perempuan' && age >= 12) ? age : (age >= 13 ? age : 18),
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KerjaMenuScreen(
                            character: character,
                            onRefresh: localRefresh,
                          ),
                        ),
                      );
                    }),
                  ),

                  // Item Freelancer
                  _buildActivityTile(
                    context: context,
                    label: 'Freelancer',
                    subtitle: 'Ambil proyek pekerjaan lepas secara mandiri',
                    icon: Icons.laptop_chromebook,
                    color: Colors.purple,
                    minAge: 13,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreelanceMenuPage(
                            character: character,
                            onRefresh: localRefresh,
                          ),
                        ),
                      );
                    }),
                  ),

                  // Item Pekerjaan Part Time
                  _buildActivityTile(
                    context: context,
                    label: character.partTimeJobName != null
                        ? 'Pekerjaan Part Time (${character.partTimeJobName})'
                        : 'Pekerjaan Part Time',
                    subtitle: (character.partTimeJobName != null && character.partTimeJobSalary != null)
                        ? '${character.partTimeJobName} - Gaji: \$${character.partTimeJobSalary.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/tahun'
                        : 'Kerja paruh waktu sampingan untuk penghasilan tambahan',
                    icon: Icons.access_time_filled_rounded,
                    color: Colors.teal,
                    minAge: 14,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartTimeMenuPage(
                            character: character,
                            onRefresh: localRefresh,
                          ),
                        ),
                      );
                    }),
                  ),

                  const Divider(height: 32),

                  // ============================================
                  // 2. KESEHATAN & KEBUGARAN
                  // ============================================
                  Builder(builder: (ctx) {
                    final textColor = DefaultTextStyle.of(ctx).style.color;
                    return Text(
                      'Kesehatan & Kebugaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor?.withValues(alpha: 0.6),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),

                  // Item Olahraga
                  _buildActivityTile(
                    context: context,
                    label: 'Olahraga',
                    subtitle: 'Latih fisikmu agar tetap sehat dan bugar',
                    icon: Icons.fitness_center,
                    color: Colors.orange,
                    minAge: 7,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      OlahragaMenuHelper.showOlahragaMenu(context, character, localRefresh);
                    }),
                  ),

                  const Divider(height: 32),

                  // ============================================
                  // 3. HIBURAN & GAYA HIDUP
                  // ============================================
                  Builder(builder: (ctx) {
                    final textColor = DefaultTextStyle.of(ctx).style.color;
                    return Text(
                      'Hiburan & Gaya Hidup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor?.withValues(alpha: 0.6),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),

                  // Aksesoris
                  _buildActivityTile(
                    context: context,
                    label: 'Aksesoris',
                    subtitle: 'Tambahkan aksesoris untuk gaya',
                    icon: Icons.style,
                    color: Colors.pink,
                    minAge: 12,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      AksesorisMenuHelper.showAksesorisMenu(context, character, localRefresh);
                    }),
                  ),

                  // Adopsi Anak
                  _buildActivityTile(
                    context: context,
                    label: 'Adopsi Anak',
                    subtitle: 'Berikan kasih sayang pada anak',
                    icon: Icons.child_care,
                    color: Colors.orange,
                    minAge: 21,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      AdopsiAnakMenuHelper.showAdopsiAnakMenu(context, character, localRefresh);
                    }),
                  ),

                  // Buat Kriminal
                  _buildActivityTile(
                    context: context,
                    label: 'Buat Kriminal',
                    subtitle: 'Melakukan aksi kriminal',
                    icon: Icons.gavel,
                    color: Colors.red,
                    minAge: 18,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      KriminalMenuHelper.showKriminalMenu(context, character, localRefresh);
                    }),
                  ),

                  // Pergi ke Dokter
                  _buildActivityTile(
                    context: context,
                    label: 'Pergi ke Dokter',
                    subtitle: 'Periksa kesehatan',
                    icon: Icons.local_hospital,
                    color: Colors.blue,
                    minAge: 6,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      DokterMenuHelper.showDokterMenu(context, character, localRefresh);
                    }),
                  ),

                  // Imigrasi
                  Builder(builder: (context) {
                    final bool hasPassport = character.ownedLicenses.contains('Paspor 🛂');
                    return _buildActivityTile(
                      context: context,
                      label: 'Imigrasi',
                      subtitle: hasPassport ? 'Pindah ke negara lain' : 'Belum memiliki paspor yang bisa didapatkan dari urus lisensi',
                      icon: Icons.flight_takeoff,
                      color: Colors.teal,
                      minAge: 18,
                      currentAge: hasPassport ? age : 0,
                      customLockMessage: hasPassport ? null : 'Belum memiliki paspor yang bisa didapatkan dari urus lisensi.',
                      lockActionLabel: hasPassport ? null : 'Pergi ke Lisensi 📋',
                      onLockAction: hasPassport
                          ? null
                          : () {
                              LisensiMenuHelper.showLisensiMenu(context, character, localRefresh);
                            },
                      onTap: () => _executeAction(context, () {
                        ImigrasimMenuHelper.showImigrasimMenu(context, character, localRefresh);
                      }),
                    );
                  }),

                  // Kesuburan
                  _buildActivityTile(
                    context: context,
                    label: 'Kesuburan',
                    subtitle: 'Cek atau tingkatkan kesuburan',
                    icon: Icons.egg,
                    color: Colors.purple,
                    minAge: 18,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      KesuburanMenuHelper.showKesuburanMenu(context, character, localRefresh);
                    }),
                  ),

                  // Lisensi
                  _buildActivityTile(
                    context: context,
                    label: 'Lisensi',
                    subtitle: 'Dapatkan lisensi (SIM, dll)',
                    icon: Icons.assignment_ind,
                    color: Colors.brown,
                    minAge: 17,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      LisensiMenuHelper.showLisensiMenu(context, character, localRefresh);
                    }),
                  ),

                  // Pikiran dan Tubuh -> usia minimal 12
                  _buildActivityTile(
                    context: context,
                    label: 'Pikiran dan Tubuh',
                    subtitle: 'Meditasi, yoga, atau terapi',
                    icon: Icons.self_improvement,
                    color: Colors.indigo,
                    minAge: 12,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      PikiranTubuhMenuHelper.showPikiranTubuhMenu(context, character, localRefresh);
                    }),
                  ),

                  // Peliharaan
                  _buildActivityTile(
                    context: context,
                    label: 'Peliharaan',
                    subtitle: 'Adopsi hewan peliharaan',
                    icon: Icons.pets,
                    color: Colors.green,
                    minAge: 10,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      PeliharaanMenuHelper.showPeliharaanMenu(context, character, localRefresh);
                    }),
                  ),

                  // Operasi Plastik
                  _buildActivityTile(
                    context: context,
                    label: 'Operasi Plastik',
                    subtitle: 'Ubah penampilan',
                    icon: Icons.face,
                    color: Colors.cyan,
                    minAge: 18,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      OperasiPlastikMenuHelper.showOperasiPlastikMenu(context, character, localRefresh);
                    }),
                  ),

                  // Rehabilitasi
                  _buildActivityTile(
                    context: context,
                    label: 'Rehabilitasi',
                    subtitle: 'Pulihkan diri dari kecanduan',
                    icon: Icons.healing,
                    color: Colors.deepPurple,
                    minAge: 18,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      RehabilitasiMenuHelper.showRehabilitasiMenu(context, character, localRefresh);
                    }),
                  ),

                  // Salon & Spa -> usia minimal 15
                  _buildActivityTile(
                    context: context,
                    label: 'Salon & Spa',
                    subtitle: 'Rawat diri dan kecantikan',
                    icon: Icons.spa,
                    color: Colors.pink,
                    minAge: 15,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      SalonSpaMenuHelper.showSalonSpaMenu(context, character, localRefresh);
                    }),
                  ),

                  // Berbelanja
                  _buildActivityTile(
                    context: context,
                    label: 'Berbelanja',
                    subtitle: 'Beli barang kebutuhan',
                    icon: Icons.shopping_cart,
                    color: Colors.orangeAccent,
                    minAge: 12,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      BerbelanjaMenuHelper.showBerbelanjaMenu(context, character, localRefresh);
                    }),
                  ),

                  const Divider(height: 32),

                  // ============================================
                  // 4. LAINNYA (di bagian paling bawah)
                  // ============================================
                  Builder(builder: (ctx) {
                    final textColor = DefaultTextStyle.of(ctx).style.color;
                    return Text(
                      'Lainnya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor?.withValues(alpha: 0.6),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),

                  // Sosial Media (usia minimal 12)
                  _buildActivityTile(
                    context: context,
                    label: 'Sosial Media',
                    subtitle: 'Kelola akun sosial mediamu',
                    icon: Icons.phone_iphone,
                    color: Colors.blueAccent,
                    minAge: 12,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      SocialMediaMenuHelper.showSocialMediaMenu(context, character, localRefresh);
                    }),
                  ),

                  // Masturbasi (hanya jika usia >= 9)
                  if (age >= 9)
                    Builder(builder: (ctx) {
                      final inheritedColor = DefaultTextStyle.of(ctx).style.color;
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _executeAction(context, () {
                            MasturbasiHelper.showMasturbationMenu(context, character, localRefresh);
                          }),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite_border, color: Colors.pinkAccent, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Masturbasi (Fantasi)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: inheritedColor,
                                        ),
                                      ),
                                      Text(
                                        'Mengeksplorasi fantasi pribadimu',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: inheritedColor?.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: inheritedColor?.withValues(alpha: 0.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                  // Love (aktivitas romantis, usia minimal 16)
                  _buildActivityTile(
                    context: context,
                    label: 'Love (Cinta)',
                    subtitle: 'Ekspresikan perasaan cintamu',
                    icon: Icons.favorite,
                    color: Colors.redAccent,
                    minAge: 16,
                    currentAge: age,
                    onTap: () => _executeAction(context, () {
                      LoveMenuHelper.showLoveMenu(context, character, localRefresh);
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_run, size: 20),
            Text(
              'Aktivitas',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper untuk membuat item aktivitas bergaya Hubungan Keluarga ---
  Widget _buildActivityTile({
    required BuildContext context,
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int minAge,
    required int currentAge,
    required VoidCallback onTap,
    String? customLockMessage,
    VoidCallback? onLockAction,
    String? lockActionLabel,
  }) {
    final bool isUnlocked = currentAge >= minAge;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color itemColor = isUnlocked ? color : Colors.grey.shade500;
    final Color bgColor = isUnlocked
        ? color.withValues(alpha: 0.05)
        : (isDark ? Colors.grey.shade800.withValues(alpha: 0.3) : Colors.grey.shade100);
    final Color borderColor = isUnlocked
        ? color.withValues(alpha: 0.3)
        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.white60 : Colors.black54;
    final Color arrowColor = isDark ? Colors.white38 : Colors.grey;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isUnlocked
            ? onTap
            : () {
                DialogHelper.show(
                  context: context,
                  title: 'Akses Dibatasi',
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🔒', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              customLockMessage ?? 'Kamu harus berusia minimal $minAge tahun untuk membuka aktivitas ini.',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      if (customLockMessage == null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFFB74D)),
                          ),
                          child: Row(
                            children: [
                              const Text('⚠️', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 8),
                              Text(
                                'Usia saat ini: $currentAge tahun',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    if (onLockAction != null && lockActionLabel != null)
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onLockAction();
                        },
                        child: Text(lockActionLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: itemColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isUnlocked ? textColor : Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? subtitleColor : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isUnlocked ? Icons.arrow_forward_ios : Icons.lock_outline,
                size: isUnlocked ? 14 : 16,
                color: isUnlocked ? arrowColor : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}