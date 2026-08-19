// lib/avatar/avatar_generator.dart

class AvatarGenerator {
  // Tentukan mata berdasarkan tingkat kebahagiaan
  static String getEyeType(int happiness) {
    if (happiness > 75) return 'happy';
    if (happiness < 30) return 'cry';
    return 'default';
  }

  // Tentukan mulut berdasarkan tingkat kebahagiaan
  static String getMouthType(int happiness) {
    if (happiness > 75) return 'smile';
    if (happiness < 35) return 'sad';
    return 'default';
  }

  // Tentukan alis berdasarkan tingkat kebahagiaan
  static String getEyebrowType(int happiness) {
    if (happiness > 75) return 'raisedExcited';
    if (happiness < 30) return 'angry';
    return 'default';
  }

  /// Membuat URL avatar SVG dari seed dan parameter ekspresi wajah
  static String buildAvatarUrl({
    required String seed,
    required String eyeType,
    required String eyebrowType,
    required String mouthType,
  }) {
    final cleanSeed = Uri.encodeComponent(seed);
    return 'https://api.dicebear.com/9.x/avataaars/svg?seed=$cleanSeed&eyes=$eyeType&eyebrows=$eyebrowType&mouth=$mouthType';
  }

  /// Membangun URL avatar untuk karakter tertentu berdasarkan nama dan kebahagiaan
  static String getDeterministicAvatarUrl(String name, String gender, {int happiness = 50}) {
    // Kita gabungkan nama dan gender sebagai seed agar gaya rambut/pakaian menyesuaikan gender
    final seedString = '$name-$gender';
    final eye = getEyeType(happiness);
    final eyebrow = getEyebrowType(happiness);
    final mouth = getMouthType(happiness);

    return buildAvatarUrl(
      seed: seedString,
      eyeType: eye,
      eyebrowType: eyebrow,
      mouthType: mouth,
    );
  }
}
