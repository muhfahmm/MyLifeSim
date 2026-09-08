// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_rekan_kerja.dart

import 'dart:math';

/// Logika panggilan untuk hubungan Pekerjaan (Rekan Kerja, Bos/Atasan, Bawahan, Supervisor).
class PanggilanRekanKerja {
  static final Random _random = Random();

  static String getPanggilan({
    required String targetName,
    required String targetRole,
    String? targetGender,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
    bool isIntimate = false,
  }) {
    final String roleLower = targetRole.toLowerCase();
    final String listenerGender = isSpeakerPlayer ? (targetGender ?? '').toLowerCase() : (userGender ?? '').toLowerCase();
    final String listenerName = isSpeakerPlayer ? targetName : (userName ?? 'Rekan');
    final bool isListenerMale = listenerGender.contains('laki') || listenerGender.contains('male');

    final bool isBoss = roleLower.contains('bos') ||
        roleLower.contains('atasan') ||
        roleLower.contains('supervisor') ||
        roleLower.contains('manajer') ||
        roleLower.contains('manager');

    final bool isSubordinate = roleLower.contains('bawahan') || roleLower.contains('staf');

    final List<String> pool = [];

    if (isSpeakerPlayer) {
      // User berbicara kepada NPC
      if (isBoss) {
        if (isIntimate) {
          if (isListenerMale) {
            pool.addAll(['Pak $listenerName', 'Bos $listenerName', 'Pak...', 'Bos...', 'Mas $listenerName']);
          } else {
            pool.addAll(['Bu $listenerName', 'Bu Bos', 'Bu...', 'Mbak $listenerName', 'Ibu...']);
          }
        } else {
          if (isListenerMale) {
            pool.addAll(['Pak $listenerName', 'Pak', 'Bos', 'Pak Bos']);
          } else {
            pool.addAll(['Bu $listenerName', 'Ibu $listenerName', 'Bu Bos', 'Ibu']);
          }
        }
      } else if (isSubordinate) {
        pool.addAll([listenerName, isListenerMale ? 'Mas $listenerName' : 'Mbak $listenerName', 'Kamu', 'Rekan $listenerName']);
      } else {
        pool.addAll([listenerName, 'Rekan $listenerName', isListenerMale ? 'Mas $listenerName' : 'Mbak $listenerName']);
      }
    } else {
      // NPC berbicara kepada User
      if (isBoss) {
        // NPC adalah Bos, memanggil User (bawahan)
        pool.addAll([listenerName, isListenerMale ? 'Mas $listenerName' : 'Mbak $listenerName', 'Kamu', 'Rekan $listenerName']);
      } else if (isSubordinate) {
        // NPC adalah Bawahan, memanggil User (bos)
        if (isListenerMale) {
          pool.addAll(['Pak $listenerName', 'Pak Bos', 'Pak...', 'Bos']);
        } else {
          pool.addAll(['Bu $listenerName', 'Bu Bos', 'Bu...', 'Ibu']);
        }
      } else {
        pool.addAll([listenerName, 'Rekan $listenerName', isListenerMale ? 'Mas $listenerName' : 'Mbak $listenerName']);
      }
    }

    if (pool.isEmpty) return listenerName;
    return pool[_random.nextInt(pool.length)];
  }
}
