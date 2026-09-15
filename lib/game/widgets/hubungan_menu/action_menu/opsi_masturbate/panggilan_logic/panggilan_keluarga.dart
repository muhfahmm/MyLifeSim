// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_keluarga.dart

import 'dart:math';

/// Logika panggilan untuk Hubungan Keluarga (Sesuai Pengaturan Persentase Keluarga).
/// Mendukung panggilan 2 arah: User -> NPC (isSpeakerPlayer: true) & NPC -> User (isSpeakerPlayer: false).
/// Selalu menggunakan sebutan peran/relasi tanpa menyebut nama secara langsung.
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
    final bool isUserMale = (userGender ?? '').toLowerCase().contains('laki') || (userGender ?? '').toLowerCase().contains('male');
    final bool isTargetFemale = (targetGender == null || targetGender.isEmpty || targetGender.toLowerCase().contains('perempuan') || targetGender.toLowerCase().contains('female') || targetGender.toLowerCase().contains('cewek'));
    final List<String> pool = [];

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
          pool.addAll(['Mas', 'Abang', 'Kakak', 'Kak']);
          break;

        case 'Kakak Perempuan':
        case 'Kakak Cewek':
        case 'Mbak':
        case 'Teteh':
          pool.addAll(['Mbak', 'Teteh', 'Kakak', 'Kak']);
          break;

        case 'Adik Laki-laki':
        case 'Adik Perempuan':
        case 'Adik':
        case 'Dek':
          pool.addAll(['Dek', 'Adik', 'Adikku']);
          break;

        case 'Paman':
        case 'Om':
          pool.addAll(['Paman', 'Om']);
          break;

        case 'Pasangan Paman':
        case 'Bibi':
        case 'Tante':
          pool.addAll(['Bibi', 'Tante']);
          break;

        case 'Sepupu':
          pool.addAll(['Sepupu', 'Sepupuku', 'Kakak', 'Dek', 'Mas', 'Mbak', 'Kak']);
          break;

        case 'Kakek':
        case 'Opa':
          pool.addAll(['Kakek', 'Opa']);
          break;

        case 'Nenek':
        case 'Oma':
          pool.addAll(['Nenek', 'Oma']);
          break;

        case 'Anak / Keponakan':
        case 'Anak':
        case 'Anak Kandung':
        case 'Anak Angkat':
        case 'Anak Anda (Donor)':
        case 'Anak Hasil Donor':
        case 'Anak Donor':
        case 'Anak (Donor)':
        case 'Anak Perempuan':
        case 'Anak Laki-laki':
        case 'Putri':
        case 'Putra':
        case 'Keponakan':
          pool.addAll(usePetName 
              ? ['Anakku', 'Keponakanku', 'Nak', 'Sayang']
              : ['Anakku', 'Keponakanku', 'Nak']);
          break;

        case 'Cucu':
          pool.addAll(['Cucuku', 'Cu']);
          break;

        default:
          final String lower = key.toLowerCase();
          if (lower.contains('ayah') || lower.contains('bapak') || lower.contains('papa')) {
            pool.addAll(['Ayah', 'Papa', 'Papi']);
          } else if (lower.contains('ibu') || lower.contains('mama') || lower.contains('mami')) {
            pool.addAll(['Ibu', 'Mama', 'Mami']);
          } else if (lower.contains('kakak') || lower.contains('mas') || lower.contains('mbak') || lower.contains('abang')) {
            pool.addAll(['Mas', 'Mbak', 'Abang', 'Kakak', 'Kak']);
          } else if (lower.contains('adik') || lower.contains('dek')) {
            pool.addAll(['Dek', 'Adik', 'Adikku']);
          } else if (lower.contains('paman') || lower.contains('om')) {
            pool.addAll(['Paman', 'Om']);
          } else if (lower.contains('bibi') || lower.contains('tante')) {
            pool.addAll(['Bibi', 'Tante']);
          } else if (lower.contains('anak') || lower.contains('keponakan') || lower.contains('putri') || lower.contains('putra')) {
            pool.addAll(['Nak', 'Anakku']);
          } else {
            pool.addAll(usePetName ? ['Sayang', 'Manisku'] : ['Sayang']);
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
              ? ['Nak', 'Anakku', 'Sayang'] 
              : ['Nak', 'Anakku']);
          break;

        case 'Kakak Laki-laki':
        case 'Kakak Perempuan':
        case 'Kakak Cowok':
        case 'Kakak Cewek':
        case 'Mas':
        case 'Mbak':
        case 'Abang':
          // NPC adalah Kakak -> User adalah ADIK (Laki-laki/Perempuan)
          if (isUserMale && isTargetFemale) {
            pool.add('dik');
          } else {
            pool.addAll(usePetName 
                ? ['Dek', 'Adik', 'Adikku', 'Sayang']
                : ['Dek', 'Adik', 'Adikku']);
          }
          break;

        case 'Adik Laki-laki':
        case 'Adik Perempuan':
        case 'Adik Laki-laki Kandung':
        case 'Adik Perempuan Kandung':
        case 'Adik':
        case 'Dek':
          // NPC adalah Adik -> User adalah KAKAK (Laki-laki/Perempuan)
          if (isUserMale && isTargetFemale) {
            pool.add('kak');
          } else if (isUserMale) {
            pool.addAll(usePetName
                ? ['Mas', 'Abang', 'Kakak', 'Kak', 'Sayang']
                : ['Mas', 'Abang', 'Kakak', 'Kak']);
          } else {
            pool.addAll(usePetName
                ? ['Mbak', 'Teteh', 'Kakak', 'Kak', 'Sayang']
                : ['Mbak', 'Teteh', 'Kakak', 'Kak']);
          }
          break;

        case 'Paman':
        case 'Om':
        case 'Pasangan Paman':
        case 'Bibi':
        case 'Tante':
          // NPC adalah Paman/Bibi -> User adalah KEPONAKAN
          pool.addAll(usePetName 
              ? ['Keponakanku', 'Nak', 'Sayang']
              : ['Keponakanku', 'Nak']);
          break;

        case 'Sepupu':
          // NPC adalah Sepupu -> User adalah Sepupu
          pool.addAll(usePetName
              ? ['Sepupuku', 'Dek', 'Kak', 'Sayang']
              : ['Sepupuku', 'Dek', 'Kak', 'Mas', 'Mbak']);
          break;

        case 'Kakek':
        case 'Opa':
        case 'Nenek':
        case 'Oma':
          // NPC adalah Kakek/Nenek -> User adalah CUCU
          pool.addAll(usePetName 
              ? ['Cucuku', 'Cu', 'Sayang']
              : ['Cucuku', 'Cu']);
          break;

        case 'Anak / Keponakan':
        case 'Anak':
        case 'Anak Kandung':
        case 'Anak Angkat':
        case 'Anak Anda (Donor)':
        case 'Anak Hasil Donor':
        case 'Anak Donor':
        case 'Anak (Donor)':
        case 'Anak Perempuan':
        case 'Anak Laki-laki':
        case 'Putri':
        case 'Putra':
          // NPC adalah Anak (termasuk Anak Donor) -> User adalah ORANG TUA / PAPAH / AYAH
          if (isUserMale) {
            pool.addAll(['Ayah', 'Papa', 'Papi', 'Papah']);
          } else {
            pool.addAll(['Ibu', 'Mama', 'Mami', 'Mamah']);
          }
          break;

        case 'Keponakan':
          // NPC adalah Keponakan -> User adalah PAMAN / BIBI
          if (isUserMale) {
            pool.addAll(['Paman', 'Om']);
          } else {
            pool.addAll(['Bibi', 'Tante']);
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
            if (isUserMale && isTargetFemale) {
              pool.add('dik');
            } else {
              pool.addAll(usePetName ? ['Dek', 'Adikku', 'Sayang'] : ['Dek', 'Adikku', 'Adik']);
            }
          } else if (lower.contains('adik') || lower.contains('dek')) {
            if (isUserMale && isTargetFemale) {
              pool.add('kak');
            } else {
              pool.addAll(usePetName ? [isUserMale ? 'Mas' : 'Mbak', 'Kakak', 'Kak', 'Sayang'] : [isUserMale ? 'Mas' : 'Mbak', 'Kakak', 'Kak']);
            }
          } else if (lower.contains('anak') || lower.contains('donor') || lower.contains('putri') || lower.contains('putra')) {
            if (isUserMale) {
              pool.addAll(['Ayah', 'Papa', 'Papi', 'Papah']);
            } else {
              pool.addAll(['Ibu', 'Mama', 'Mami', 'Mamah']);
            }
          } else if (lower.contains('paman') || lower.contains('bibi') || lower.contains('om') || lower.contains('tante')) {
            pool.addAll(usePetName ? ['Keponakanku', 'Nak', 'Sayang'] : ['Keponakanku', 'Nak']);
          } else {
            pool.addAll(usePetName ? ['Sayang'] : ['Sayang']);
          }
          break;
      }
    }

    final bool isUserFemale = (userGender ?? '').toLowerCase().contains('perempuan') || (userGender ?? '').toLowerCase().contains('female');
    final bool isWLW = isUserFemale && isTargetFemale;

    if (isWLW) {
      pool.removeWhere((p) => p.toLowerCase().contains('teteh'));
    }

    if (pool.isEmpty) return 'Sayang';
    return pool[_random.nextInt(pool.length)];
  }
}
