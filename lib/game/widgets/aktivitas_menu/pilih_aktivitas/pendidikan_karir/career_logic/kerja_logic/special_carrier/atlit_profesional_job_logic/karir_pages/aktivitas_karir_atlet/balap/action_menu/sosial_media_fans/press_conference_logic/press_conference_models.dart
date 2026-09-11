// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/press_conference_logic/press_conference_models.dart

class PressEvent {
  final String id;
  final String title;
  final String question;
  final String category; // Pra-Pertandingan, Pasca-Pertandingan, Transfer, Krisis
  final List<PressOption> options;

  PressEvent({
    required this.id,
    required this.title,
    required this.question,
    required this.category,
    required this.options,
  });
}

class PressOption {
  final String label; // 🙏 Rendah Hati, 🔥 Agresif, 🎭 Diplomatis, 🤡 Humor
  final String styleName;
  final String answerText;
  final int publicTrustDelta;
  final int pressureDelta;
  final int happinessDelta;
  final int relationshipDelta;
  final String mediaGrade; // A, B, C, D
  final String fanReaction;
  final String teamReaction;

  PressOption({
    required this.label,
    required this.styleName,
    required this.answerText,
    required this.publicTrustDelta,
    required this.pressureDelta,
    required this.happinessDelta,
    required this.relationshipDelta,
    required this.mediaGrade,
    required this.fanReaction,
    required this.teamReaction,
  });
}
