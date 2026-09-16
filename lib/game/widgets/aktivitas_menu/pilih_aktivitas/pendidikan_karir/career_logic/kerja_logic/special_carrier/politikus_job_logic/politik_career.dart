// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/politikus_job_logic/politik_career.dart
class PoliticalLevel {
  final String title;
  final int minAge;
  final bool requireDegree;
  final String requiredDegreeName;
  final int campaignCost;
  final int baseSalary;
  final String description;
  final int minKarma;

  const PoliticalLevel({
    required this.title,
    required this.minAge,
    required this.requireDegree,
    this.requiredDegreeName = '',
    required this.campaignCost,
    required this.baseSalary,
    required this.description,
    this.minKarma = 0,
  });
}

class PoliticalCareerData {
  static const List<PoliticalLevel> levels = [
    PoliticalLevel(
      title: 'Anggota Dewan Kota / DPRD',
      minAge: 25,
      requireDegree: true,
      requiredDegreeName: 'Hukum / Ilmu Politik / Ekonomi / Komunikasi',
      campaignCost: 250000,
      baseSalary: 95000,
      description: 'Mewakili suara rakyat di dewan lokal dan menyusun undang-undang daerah.',
    ),
    PoliticalLevel(
      title: 'Walikota / Bupati',
      minAge: 28,
      requireDegree: true,
      requiredDegreeName: 'Hukum / Ilmu Politik / Manajemen Publik',
      campaignCost: 1500000,
      baseSalary: 280000,
      description: 'Memimpin pemerintahan kota dan mengelola anggaran daerah.',
    ),
    PoliticalLevel(
      title: 'Gubernur / Senator',
      minAge: 32,
      requireDegree: true,
      requiredDegreeName: 'Hukum / Ilmu Politik / Hubungan Internasional',
      campaignCost: 8000000,
      baseSalary: 750000,
      description: 'Penguasa wilayah provinsi/bagian dan memegang pengaruh kebijakan nasional.',
    ),
    PoliticalLevel(
      title: 'Presiden / Perdana Menteri',
      minAge: 35,
      requireDegree: true,
      requiredDegreeName: 'Bebas Gelar Sarjana (Hukum/Politik/Bisnis)',
      campaignCost: 40000000,
      baseSalary: 2500000,
      description: 'Pemimpin tertinggi negara. Memegang tongkat kekuasaan nasional & diplomatik.',
    ),
  ];

  static bool isPoliticianJob(String? jobName) {
    if (jobName == null) return false;
    return levels.any((level) => level.title == jobName);
  }
}
