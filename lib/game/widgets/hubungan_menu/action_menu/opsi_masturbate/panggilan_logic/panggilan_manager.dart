// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart

import 'panggilan_pacar.dart';
import 'panggilan_rekan_kerja.dart';
import 'panggilan_idol.dart';
import 'panggilan_keluarga.dart';

class PanggilanManager {
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

    if (roleLower.contains('pacar') ||
        roleLower.contains('tunangan') ||
        roleLower.contains('suami') ||
        roleLower.contains('istri') ||
        roleLower.contains('pasangan')) {
      return PanggilanPacar.getPanggilan(
        targetName: targetName,
        targetGender: targetGender,
        targetRole: targetRole,
        isSpeakerPlayer: isSpeakerPlayer,
        userName: userName,
        userGender: userGender,
      );
    }

    if (roleLower.contains('idol') ||
        roleLower.contains('produser') ||
        roleLower.contains('member') ||
        (roleLower.contains('manager') && roleLower.contains('idol')) ||
        (roleLower.contains('staff') && roleLower.contains('idol'))) {
      return PanggilanIdol.getPanggilan(
        targetName: targetName,
        targetRole: targetRole,
        targetGender: targetGender,
        isSpeakerPlayer: isSpeakerPlayer,
        userName: userName,
        userGender: userGender,
      );
    }

    if (roleLower.contains('rekan kerja') ||
        roleLower.contains('bos') ||
        roleLower.contains('atasan') ||
        roleLower.contains('supervisor') ||
        roleLower.contains('bawahan') ||
        roleLower.contains('manajer') ||
        roleLower.contains('manager') ||
        roleLower.contains('teman sekelas') ||
        roleLower.contains('teman kuliah') ||
        roleLower.contains('dosen') ||
        roleLower.contains('guru')) {
      return PanggilanRekanKerja.getPanggilan(
        targetName: targetName,
        targetRole: targetRole,
        targetGender: targetGender,
        isSpeakerPlayer: isSpeakerPlayer,
        userName: userName,
        userGender: userGender,
        isIntimate: isIntimate,
      );
    }

    return PanggilanKeluarga.getPanggilan(
      targetName: targetName,
      relationKey: targetRole,
      isSpeakerPlayer: isSpeakerPlayer,
      userName: userName,
      userGender: userGender,
      targetGender: targetGender,
    );
  }
}
