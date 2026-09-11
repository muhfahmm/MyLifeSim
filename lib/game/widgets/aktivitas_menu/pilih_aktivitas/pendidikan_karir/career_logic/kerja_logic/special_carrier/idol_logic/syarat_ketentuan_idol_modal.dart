// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/idol_logic/syarat_ketentuan_idol_modal.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'persentase_tawaran_idol.dart';
import 'idol_manager.dart';

class SyaratKetentuanIdolModal extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const SyaratKetentuanIdolModal({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  /// Static helper untuk menampilkan Modal Pendaftaran & Syarat Ketentuan Idol
  static void show({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SyaratKetentuanIdolModal(
        character: character,
        onRefresh: onRefresh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isPerempuan = character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'wanita';
    final int age = character.age;
    final int health = character.health;
    final int discipline = character.discipline;
    final bool hasGraduated = character.hasGraduatedIdol;

    // Menentukan jenis posisi yang tersedia berdasarkan usia dan riwayat
    final bool isStaffOnly = (age >= 18) || (hasGraduated && age >= 18);
    final String targetJobTitle = isStaffOnly ? 'Staf Operasional Idol' : 'Idol (Trainee)';

    // Syarat kelayakan dasar
    final bool isGenderValid = isPerempuan || isStaffOnly;
    final bool isAgeValid = (age >= 10 && age <= 17) || (isStaffOnly && age >= 18);
    final bool isHealthValid = health >= 80;
    final bool isDisciplineValid = discipline >= 75;
    final bool isEligible = isGenderValid && isAgeValid && isHealthValid && isDisciplineValid;

    // Kalkulasi Persentase Peluang Lolos
    final int chancePercent = PersentaseTawaranIdol.hitungProbabilitasLamaran(character);

    // Perkiraan Gaji (Trainee: 1000 - 2000 USD)
    final int baseSalary = isStaffOnly ? 300 : 1000;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER DIALOG
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.pink.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🎤', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pendaftaran Audisi Idol',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Syarat & Ketentuan Bergabung Agensi',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: isDark ? Colors.white54 : Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // BADGE KARTU PELUANG KELULUSAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.pink.shade900, Colors.purple.shade900]
                        : [const Color(0xFFFFF0F5), const Color(0xFFF3E5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.pink.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.stars, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peluang Lolos Audisi',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.pink.shade200 : Colors.pink.shade900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '$chancePercent%',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : Colors.pink.shade800,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: chancePercent / 100.0,
                                    minHeight: 8,
                                    backgroundColor: Colors.pink.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // JUDUL PERSYARATAN
              Text(
                'Ketentuan & Kualifikasi Minimal:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.blueGrey.shade800,
                ),
              ),
              const SizedBox(height: 10),

              // LIST PERSYARATAN
              _buildRequirementRow(
                isDark: isDark,
                icon: Icons.person_outline,
                title: 'Gender / Posisi Target',
                subtitle: isStaffOnly ? 'Posisi: Staf Operasional Idol' : 'Perempuan (Audisi Member Trainee)',
                isValid: isGenderValid,
              ),
              _buildRequirementRow(
                isDark: isDark,
                icon: Icons.cake_outlined,
                title: 'Usia Karakter',
                subtitle: isStaffOnly ? 'Usia $age Tahun (Minimal 18 Thn)' : 'Usia $age Tahun (Batas Usia: 10 - 17 Thn)',
                isValid: isAgeValid,
              ),
              _buildRequirementRow(
                isDark: isDark,
                icon: Icons.favorite_outline,
                title: 'Kesehatan Minimal (80%)',
                subtitle: 'Kesehatan Karakter: $health%',
                isValid: isHealthValid,
              ),
              _buildRequirementRow(
                isDark: isDark,
                icon: Icons.verified_user_outlined,
                title: 'Kedisiplinan Minimal (75%)',
                subtitle: 'Kedisiplinan Karakter: $discipline%',
                isValid: isDisciplineValid,
              ),

              const SizedBox(height: 14),

              // INFORMASI TAMBAHAN (GAJI & PERINGATAN)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800.withValues(alpha: 0.5) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined, size: 18, color: Colors.green),
                        const SizedBox(width: 6),
                        Text(
                          isStaffOnly
                              ? 'Perkiraan Gaji: ${CurrencySettings.format(baseSalary)} / bulan'
                              : 'Perkiraan Gaji: ${CurrencySettings.format(1000)} - ${CurrencySettings.format(2000)} / bulan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.greenAccent : Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚠️ ', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Text(
                            'Latihan idol sangat padat. Tingkat kebahagiaanmu akan naik, namun stamina/kesehatan akan cepat terkuras.',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.amberAccent : Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // TOMBOL AKSI
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEligible ? Colors.pinkAccent : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: isEligible ? 3 : 0,
                      ),
                      onPressed: () {
                        _prosesLamaran(context, targetJobTitle, baseSalary, chancePercent);
                      },
                      child: Text(
                        isStaffOnly ? 'Daftar Staf Idol 💼' : 'Kirim Lamaran Audisi 🌟',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Row Item untuk menampilkan setiap syarat & centang statusnya
  Widget _buildRequirementRow({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isValid,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isValid ? Colors.green : (isDark ? Colors.redAccent : Colors.red),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isValid
                        ? (isDark ? Colors.greenAccent : Colors.green.shade800)
                        : (isDark ? Colors.redAccent : Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : (isDark ? Colors.redAccent : Colors.red),
            size: 20,
          ),
        ],
      ),
    );
  }

  /// Eksekusi proses pendaftaran audisi
  void _prosesLamaran(
    BuildContext context,
    String targetJobTitle,
    int baseSalary,
    int chancePercent,
  ) {
    final int age = character.age;
    final bool isPerempuan = character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'wanita';

    // 1. Cek Kelayakan Kritis Usia & Gender
    if (targetJobTitle == 'Idol (Trainee)') {
      if (!isPerempuan) {
        DialogHelper.show(
          context: context,
          title: 'Audisi Ditolak 🚫',
          content: const Text('Audisi Member Idol Trainee saat ini khusus diperuntukkan bagi karakter perempuan.'),
        );
        return;
      }
      if (age < 10 || age > 17) {
        DialogHelper.show(
          context: context,
          title: 'Usia Tidak Sesuai 🚫',
          content: Text('Audisi Trainee Idol hanya menerima calon anggota berusia 10 hingga 17 tahun. (Usiamu saat ini: $age tahun).'),
        );
        return;
      }
    }

    // 2. Cek Kelayakan Kritis Kesehatan & Kedisiplinan
    if (character.health < 80 || character.discipline < 75) {
      DialogHelper.show(
        context: context,
        title: 'Syarat Belum Terpenuhi 🚫',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Persyaratan minimal untuk mengikuti audisi belum terpenuhi:'),
            const SizedBox(height: 8),
            Text('• Kesehatan minimal: 80% (Kesehatanmu: ${character.health}%)'),
            Text('• Kedisiplinan minimal: 75% (Kedisiplinanmu: ${character.discipline}%)'),
            const SizedBox(height: 10),
            const Text('Silakan tingkatkan kesehatan dan kedisiplinan karaktermu terlebih dahulu!'),
          ],
        ),
      );
      return;
    }

    // 3. Roll Acak Berdasarkan Persentase Peluang Lolos
    final int roll = Random().nextInt(100);
    final bool isSuccess = roll < chancePercent;

    if (isSuccess) {
      // LOLOS AUDISI!
      character.setJob(targetJobTitle, baseSalary);

      if (targetJobTitle == 'Idol (Trainee)' || character.isIdolStaff) {
        IdolManager.initializeTraineeTeam(character);
      }

      if (!character.ownedLicenses.contains('Idol')) {
        character.ownedLicenses.add('Idol');
      }

      onRefresh();

      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('🎉', style: TextStyle(fontSize: 26)),
              SizedBox(width: 8),
              Expanded(
                child: Text('Selamat! Lolos Audisi! 🎤', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          content: Text(
            'Dewan juri terpesona dengan penampilanmu! '
            'Kamu resmi diterima sebagai $targetJobTitle dengan gaji ${CurrencySettings.format(baseSalary)}/bulan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nav = Navigator.of(context);
                Navigator.pop(dialogCtx); // Pop alert dialog
                Navigator.pop(context);   // Pop SyaratKetentuanIdolModal
                nav.pop();                // Pop PekerjaanSpesialMenuScreen (returns to Pekerjaan & Karir)
              },
              child: const Text('Masuk ke Agensi Idol ⭐', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      // GAGAL AUDISI
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('📢', style: TextStyle(fontSize: 26)),
              SizedBox(width: 8),
              Expanded(
                child: Text('Hasil Audisi Idol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          content: const Text(
            'Dewan juri mengapresiasi usahamu, namun persaingan generasi kali ini sangat ketat. '
            'Tingkatkan atribut kecerdasan, kesehatan, dan kedisiplinanmu lalu coba lagi di kesempatan berikutnya!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }
}
