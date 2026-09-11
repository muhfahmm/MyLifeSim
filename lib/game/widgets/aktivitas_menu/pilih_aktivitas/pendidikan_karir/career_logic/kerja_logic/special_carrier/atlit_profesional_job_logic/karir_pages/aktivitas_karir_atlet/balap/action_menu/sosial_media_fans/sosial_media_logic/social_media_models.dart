// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/sosial_media_logic/social_media_models.dart

class SocialContentType {
  final String id;
  final String label; // e.g. 📸 Foto Latihan
  final String description;
  final List<SocialCaptionOption> captionOptions;

  SocialContentType({
    required this.id,
    required this.label,
    required this.description,
    required this.captionOptions,
  });
}

class SocialCaptionOption {
  final String label; // 🙏 Rendah Hati, 😎 Sombong, 🤡 Humor, 📚 Motivasi
  final String styleName;
  final String captionText;
  final int popularityDelta;
  final int followersMultiplier; // Pengali penambahan pengikut
  final int engagementDelta;
  final int karmaDelta;
  final int moneyReward; // Pemasukan tambahan (jika endorse)
  final int relationshipDelta;
  final String successNarration;
  final String failNarration;

  SocialCaptionOption({
    required this.label,
    required this.styleName,
    required this.captionText,
    required this.popularityDelta,
    required this.followersMultiplier,
    required this.engagementDelta,
    required this.karmaDelta,
    this.moneyReward = 0,
    required this.relationshipDelta,
    required this.successNarration,
    required this.failNarration,
  });
}
