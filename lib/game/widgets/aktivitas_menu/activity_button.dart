// lib/game/widgets/aktivitas_menu/activity_button.dart

import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/masturbate.dart';

import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/school_menu_page.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart';

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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ============================================
              // 1. PENDIDIKAN & KARIR
              // ============================================
              const Text(
                'Pendidikan & Karir',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
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
                  subtitle = 'Menempuh pendidikan tinggi untuk karir profesional';
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
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => age <= 17
                            ? SchoolMenuPage(
                                character: character,
                                onRefresh: onRefresh,
                              )
                            : UnivMenuPage(
                                character: character,
                                onRefresh: onRefresh,
                              ),
                      ),
                    );
                  },
                );
              }(),

              // Item Bekerja
              _buildActivityTile(
                context: context,
                label: 'Bekerja',
                subtitle: 'Mulai bekerja untuk menghasilkan uang tunai',
                icon: Icons.work,
                color: Colors.green,
                minAge: 18,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KerjaMenuScreen(
                        character: character,
                        onRefresh: onRefresh,
                      ),
                    ),
                  );
                },
              ),

              const Divider(height: 32),

              // ============================================
              // 2. KESEHATAN & KEBUGARAN
              // ============================================
              const Text(
                'Kesehatan & Kebugaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
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
                onTap: () {
                  Navigator.pop(context);
                  onExercise();
                },
              ),

              const Divider(height: 32),

              // ============================================
              // 3. HIBURAN & GAYA HIDUP
              // ============================================
              const Text(
                'Hiburan & Gaya Hidup',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),

              // Aksesoris -> usia minimal 12
              _buildActivityTile(
                context: context,
                label: 'Aksesoris',
                subtitle: 'Tambahkan aksesoris untuk gaya',
                icon: Icons.style,
                color: Colors.pink,
                minAge: 12,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur aksesoris belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur adopsi anak belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur kriminal belum tersedia')),
                  );
                },
              ),

              // Pergi ke Dokter
              _buildActivityTile(
                context: context,
                label: 'Pergi ke Dokter',
                subtitle: 'Periksa kesehatan',
                icon: Icons.local_hospital,
                color: Colors.blue,
                minAge: 0,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur dokter belum tersedia')),
                  );
                },
              ),

              // Imigrasi
              _buildActivityTile(
                context: context,
                label: 'Imigrasi',
                subtitle: 'Pindah ke negara lain',
                icon: Icons.flight_takeoff,
                color: Colors.teal,
                minAge: 18,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur imigrasi belum tersedia')),
                  );
                },
              ),

              // Kesuburan
              _buildActivityTile(
                context: context,
                label: 'Kesuburan',
                subtitle: 'Cek atau tingkatkan kesuburan',
                icon: Icons.egg,
                color: Colors.purple,
                minAge: 18,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur kesuburan belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur lisensi belum tersedia')),
                  );
                },
              ),

              // Main Lotre
              _buildActivityTile(
                context: context,
                label: 'Main Lotre',
                subtitle: 'Coba keberuntungan',
                icon: Icons.casino,
                color: Colors.amber,
                minAge: 18,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur lotre belum tersedia')),
                  );
                },
              ),

              // Bercinta
              _buildActivityTile(
                context: context,
                label: 'Bercinta',
                subtitle: 'Nikmati keintiman',
                icon: Icons.favorite,
                color: Colors.pinkAccent,
                minAge: 16,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur bercinta belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur pikiran dan tubuh belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur peliharaan belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur operasi plastik belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur rehabilitasi belum tersedia')),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur salon & spa belum tersedia')),
                  );
                },
              ),

              // Berbelanja -> usia minimal 12
              _buildActivityTile(
                context: context,
                label: 'Berbelanja',
                subtitle: 'Beli barang kebutuhan',
                icon: Icons.shopping_cart,
                color: Colors.orangeAccent,
                minAge: 12,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur berbelanja belum tersedia')),
                  );
                },
              ),

              const Divider(height: 32),

              // ============================================
              // 4. LAINNYA (di bagian paling bawah)
              // ============================================
              const Text(
                'Lainnya',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),

              // Masturbasi (hanya jika usia ≥ 9)
              if (age >= 9)
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.grey.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                    title: const Text('Masturbasi (Fantasi)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Mengeksplorasi fantasi pribadimu'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    onTap: () {
                      Navigator.pop(context);
                      MasturbasiHelper.showMasturbationMenu(context, character, onRefresh);
                    },
                  ),
                ),

              // Love (misalnya aktivitas romantis, usia minimal 16)
              _buildActivityTile(
                context: context,
                label: 'Love (Cinta)',
                subtitle: 'Ekspresikan perasaan cintamu',
                icon: Icons.favorite,
                color: Colors.redAccent,
                minAge: 16,
                currentAge: age,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur love belum tersedia')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.withOpacity(0.2),
        foregroundColor: Colors.purple,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.purple, width: 1.5),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_run, size: 28),
          SizedBox(height: 4),
          Text(
            'Aktivitas',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple),
          ),
        ],
      ),
    );
  }

  // --- Helper untuk membuat item aktivitas dengan batas usia ---
  Widget _buildActivityTile({
    required BuildContext context,
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int minAge,
    required int currentAge,
    required VoidCallback onTap,
  }) {
    final bool isUnlocked = currentAge >= minAge;
    final Color itemColor = isUnlocked ? color : Colors.grey.shade400;
    final Color textColor = isUnlocked ? Colors.black87 : Colors.grey.shade400;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isUnlocked ? Colors.grey.shade200 : Colors.grey.shade100),
      ),
      color: isUnlocked ? Colors.grey.shade50 : Colors.grey.shade50.withOpacity(0.5),
      child: ListTile(
        leading: Icon(icon, color: itemColor),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.black54 : Colors.grey.shade400)),
        trailing: isUnlocked
            ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
            : const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
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
                              'Kamu harus berusia minimal $minAge tahun untuk membuka aktivitas ini.',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
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
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
      ),
    );
  }
}