// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_keluarga.dart

import 'dart:math';

/// Logika panggilan untuk Hubungan Keluarga (Sesuai Pengaturan Persentase Keluarga).
/// Mendukung panggilan 2 arah: User -> NPC (isSpeakerPlayer: true) & NPC -> User (isSpeakerPlayer: false).
class PanggilanKeluarga {
  static final Random _random = Random();

  /// Mendapatkan panggilan berdasarkan relasi keluarga detail dan arah pembicara.
  /// [targetName]: Nama target NPC
  /// [relationKey]: Peran NPC relatif terhadap User (e.g. 'Kakak Perempuan', 'Ayah Kandung', 'Adik Laki-laki', dll)
  /// [isSpeakerPlayer]: true jika User yang berbicara ke NPC; false jika NPC yang berbicara ke User.
  /// [userName]: Nama karakter User
  /// [userGender]: Gender User ('laki-laki' / 'perempuan')
  /// [targetGender]: Gender NPC ('laki-laki' / 'perempuan')
  static String getPanggilan({
    required String targetName,
    required String relationKey,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
    String? targetGender,
  }) {
    final String key = relationKey.trim();
    final String uName = (userName != null && userName.isNotEmpty) ? userName : 'Sayang';
    final bool isUserMale = (userGender ?? '').toLowerCase().contains('laki') || (userGender ?? '').toLowerCase().contains('male');
    final List<String> pool = [];

    // Jika panggilan terdeteksi sebagai 'Sayang' atau sejenisnya, batasi peluangnya ke 30% saja untuk hubungan non-pacar.
    // 70% sisanya menggunakan panggilan kekeluargaan standar/biasa.
    final bool usePetName = _random.nextDouble() < 0.30;

    if (isSpeakerPlayer) {
      // USER BERBICARA KEPADA NPC (User panggil NPC berdasarkan peran NPC)
      switch (key) {
        case 'Ayah Kandung':
        case 'Ayah Tiri':
        case 'Ayah Mertua':
        case 'Ayah':
          pool.addAll(['Ayah', 'Papa', 'Papi', 'Yah...']);
          break;

        case 'Ibu Kandung':
        case 'Ibu Tiri':
        case 'Ibu Mertua':
        case 'Ibu':
          pool.addAll(['Ibu', 'Mama', 'Mami', 'Bu...']);
          break;

        case 'Kakak Laki-laki':
        case 'Kakak Cowok':
        case 'Abang':
        case 'Mas':
          pool.addAll(['Mas $targetName', 'Kak $targetName', 'Abang $targetName', 'Mas', 'Abang', 'Kakak']);
          break;

        case 'Kakak Perempuan':
        case 'Kakak Cewek':
        case 'Mbak':
        case 'Teteh':
          pool.addAll(['Mbak $targetName', 'Kak $targetName', 'Teteh $targetName', 'Mbak', 'Teteh', 'Kakak']);
          break;

        case 'Adik Laki-laki':
        case 'Adik Perempuan':
        case 'Adik':
        case 'Dek':
          pool.addAll(['Dek $targetName', 'Adik', targetName, 'Dek', 'Adikku']);
          break;

        case 'Paman':
        case 'Om':
          pool.addAll(['Paman $targetName', 'Om $targetName', 'Paman', 'Om']);
          break;

        case 'Pasangan Paman':
        case 'Bibi':
        case 'Tante':
          pool.addAll(['Bibi $targetName', 'Tante $targetName', 'Bibi', 'Tante']);
          break;

        case 'Sepupu':
          pool.addAll(['Sepupu $targetName', targetName, 'Kak $targetName', 'Dek $targetName', 'Mas $targetName', 'Mbak $targetName']);
          break;

        case 'Kakek':
        case 'Opa':
          pool.addAll(['Kakek', 'Opa', 'Kakek $targetName']);
          break;

        case 'Nenek':
        case 'Oma':
          pool.addAll(['Nenek', 'Oma', 'Nenek $targetName']);
          break;

        case 'Anak / Keponakan':
        case 'Anak':
        case 'Anak Kandung':
        case 'Anak Angkat':
        case 'Keponakan':
          pool.addAll(usePetName 
              ? ['Anakku', 'Keponakanku', targetName, 'Nak', 'Sayang']
              : ['Anakku', 'Keponakanku', targetName, 'Nak']);
          break;

        case 'Cucu':
          pool.addAll(['Cucuku', targetName, 'Cu']);
          break;

        default:
          final String lower = key.toLowerCase();
          if (lower.contains('ayah') || lower.contains('bapak') || lower.contains('papa')) {
            pool.addAll(['Ayah', 'Papa', 'Papi', 'Pak $targetName']);
          } else if (lower.contains('ibu') || lower.contains('mama') || lower.contains('mami')) {
            pool.addAll(['Ibu', 'Mama', 'Mami', 'Bu $targetName']);
          } else if (lower.contains('kakak') || lower.contains('mas') || lower.contains('mbak') || lower.contains('abang')) {
            pool.addAll(['Kak $targetName', 'Mas $targetName', 'Mbak $targetName', 'Abang $targetName', 'Kakak']);
          } else if (lower.contains('adik') || lower.contains('dek')) {
            pool.addAll(['Dek $targetName', targetName, 'Dek']);
          } else if (lower.contains('paman') || lower.contains('om')) {
            pool.addAll(['Paman $targetName', 'Om $targetName', 'Om']);
          } else if (lower.contains('bibi') || lower.contains('tante')) {
            pool.addAll(['Bibi $targetName', 'Tante $targetName', 'Tante']);
          } else if (lower.contains('anak') || lower.contains('keponakan')) {
            pool.addAll(['Nak', targetName, 'Anakku']);
          } else {
            pool.addAll(usePetName ? [targetName, 'Sayang'] : [targetName]);
          }
          break;
      }
    } else {
      // NPC BERBICARA KEPADA USER (NPC panggil User berdasarkan posisi User relatif terhadap NPC)
      switch (key) {
        case 'Ayah Kandung':
        case 'Ayah Tiri':
        case 'Ayah Mertua':
        case 'Ayah':
        case 'Ibu Kandung':
        case 'Ibu Tiri':
        case 'Ibu Mertua':
        case 'Ibu':
          // NPC adalah Orang Tua -> User adalah ANAK
          pool.addAll(usePetName 
              ? ['Nak', 'Anakku', uName, 'Sayang'] 
              : ['Nak', 'Anakku', uName]);
          break;

        case 'Kakak Laki-laki':
        case 'Kakak Perempuan':
        case 'Kakak Cowok':
        case 'Kakak Cewek':
        case 'Mas':
        case 'Mbak':
        case 'Abang':
          // NPC adalah Kakak -> User adalah ADIK (Laki-laki/Perempuan)
          pool.addAll(usePetName 
              ? ['Dek', 'Dek $uName', 'Adik', 'Adikku', 'Sayang']
              : ['Dek', 'Dek $uName', 'Adik', 'Adikku']);
          break;

        case 'Adik Laki-laki':
        case 'Adik Perempuan':
        case 'Adik Laki-laki Kandung':
        case 'Adik Perempuan Kandung':
        case 'Adik':
        case 'Dek':
          // NPC adalah Adik -> User adalah KAKAK (Laki-laki/Perempuan)
          if (isUserMale) {
            pool.addAll(usePetName
                ? ['Kak $uName', 'Kakak', 'Kak', 'Sayang']
                : ['Kak $uName', 'Kakak', 'Kak']);
          } else {
            pool.addAll(usePetName
                ? ['Kak $uName', 'Kakak', 'Mbak $uName', 'Kak', 'Mbak', 'Sayang']
                : ['Kak $uName', 'Kakak', 'Mbak $uName', 'Kak', 'Mbak']);
          }
          break;

        case 'Paman':
        case 'Om':
        case 'Pasangan Paman':
        case 'Bibi':
        case 'Tante':
          // NPC adalah Paman/Bibi -> User adalah KEPONAKAN
          pool.addAll(usePetName 
              ? ['Keponakanku', 'Nak', uName, 'Sayang']
              : ['Keponakanku', 'Nak', uName]);
          break;

        case 'Sepupu':
          // NPC adalah Sepupu -> User adalah Sepupu
          pool.addAll(usePetName
              ? ['Sepupuku', uName, 'Dek $uName', 'Kak $uName', 'Sayang']
              : ['Sepupuku', uName, 'Dek $uName', 'Kak $uName', 'Mas $uName', 'Mbak $uName']);
          break;

        case 'Kakek':
        case 'Opa':
        case 'Nenek':
        case 'Oma':
          // NPC adalah Kakek/Nenek -> User adalah CUCU
          pool.addAll(usePetName 
              ? ['Cucuku', 'Cu', uName, 'Sayang']
              : ['Cucuku', 'Cu', uName]);
          break;

        case 'Anak / Keponakan':
        case 'Anak':
        case 'Anak Kandung':
        case 'Anak Angkat':
        case 'Keponakan':
          // NPC adalah Anak/Keponakan -> User adalah ORANG TUA / PAMAN / BIBI
          if (isUserMale) {
            pool.addAll(['Ayah', 'Papa', 'Papi', 'Paman', 'Om']);
          } else {
            pool.addAll(['Ibu', 'Mama', 'Mami', 'Bibi', 'Tante']);
          }
          break;

        case 'Cucu':
          // NPC adalah Cucu -> User adalah KAKEK / NENEK
          if (isUserMale) {
            pool.addAll(['Kakek', 'Opa']);
          } else {
            pool.addAll(['Nenek', 'Oma']);
          }
          break;

        default:
          final String lower = key.toLowerCase();
          if (lower.contains('kakak') || lower.contains('mas') || lower.contains('mbak') || lower.contains('abang')) {
            pool.addAll(usePetName ? ['Dek', 'Dek $uName', 'Adikku', 'Sayang'] : ['Dek', 'Dek $uName', 'Adikku', 'Adik']);
          } else if (lower.contains('adik') || lower.contains('dek')) {
            pool.addAll(usePetName ? [isUserMale ? 'Kak $uName' : 'Mbak $uName', 'Kakak', 'Kak', 'Sayang'] : [isUserMale ? 'Kak $uName' : 'Mbak $uName', 'Kakak', 'Kak']);
          } else if (lower.contains('ayah') || lower.contains('ibu') || lower.contains('bapak') || lower.contains('mama')) {
            pool.addAll(usePetName ? ['Nak', 'Anakku', uName, 'Sayang'] : ['Nak', 'Anakku', uName]);
          } else if (lower.contains('paman') || lower.contains('bibi') || lower.contains('om') || lower.contains('tante')) {
            pool.addAll(usePetName ? ['Keponakanku', 'Nak', uName, 'Sayang'] : ['Keponakanku', 'Nak', uName]);
          } else if (lower.contains('anak') || lower.contains('keponakan')) {
            pool.addAll([isUserMale ? 'Ayah' : 'Ibu', isUserMale ? 'Papa' : 'Mama', isUserMale ? 'Om' : 'Tante']);
          } else {
            pool.addAll(usePetName ? [uName, 'Sayang'] : [uName]);
          }
          break;
      }
    }

    final bool isUserFemale = (userGender ?? '').toLowerCase().contains('perempuan') || (userGender ?? '').toLowerCase().contains('female');
    final bool isTargetFemale = (targetGender ?? '').toLowerCase().contains('perempuan') || (targetGender ?? '').toLowerCase().contains('female');
    final bool isWLW = isUserFemale && isTargetFemale;

    if (isWLW) {
      pool.removeWhere((p) => p.toLowerCase().contains('teteh'));
    }

    if (pool.isEmpty) return isSpeakerPlayer ? targetName : uName;
    return pool[_random.nextInt(pool.length)];
  }
}
