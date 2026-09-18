import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'panggilan_pacar.dart';
import 'panggilan_rekan_kerja.dart';
import 'panggilan_idol.dart';
import 'panggilan_keluarga.dart';

/// Dispatcher/Manager utama untuk mendapatkan panggilan NPC yang sesuai secara dinamis.
class PanggilanManager {
  /// Mendapatkan panggilan yang paling tepat berdasarkan nama, peran/relasi, dan gender.
  /// [isSpeakerPlayer]: true jika User berbicara ke NPC; false jika NPC berbicara ke User.
  static String getPanggilan({
    required String targetName,
    required String targetRole,
    String? targetGender,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
    bool isIntimate = false,
    Character? character,
  }) {
    String effectiveRole = targetRole;
    final String cleanTargetName = AvatarAgeRules.getCleanNPCName(targetName);

    if (character != null) {
      // Jika isSpeakerPlayer == false, targetName yang di-pass bisa saja userName (player).
      // Dalam hal itu, kita perlu tahu NPC siapa yang sedang berbicara (bisa diidentifikasi dari targetRole atau pencarian relasi).
      // 1. Cek anak di character.children
      for (var child in character.children) {
        final String cName = AvatarAgeRules.getCleanNPCName((child['name'] ?? '').toString());
        if (cName.isNotEmpty && (cName == cleanTargetName || targetName.contains(cName) || targetRole.contains(cName))) {
          effectiveRole = 'Anak Kandung';
          break;
        }
      }

      // 2. Cek anak donor sperma / bayi tabung di character.donorRecipients
      if (effectiveRole == targetRole) {
        for (var recipient in character.donorRecipients) {
          final String cName = AvatarAgeRules.getCleanNPCName((recipient['childName'] ?? '').toString());
          final String rName = AvatarAgeRules.getCleanNPCName((recipient['name'] ?? '').toString());
          if ((cName.isNotEmpty && (cName == cleanTargetName || targetName.contains(cName) || targetRole.contains(cName))) ||
              (rName.isNotEmpty && (rName == cleanTargetName || targetName.contains(rName) || targetRole.contains(rName)))) {
            effectiveRole = 'Anak Anda (Donor)';
            break;
          }
        }
      }

      // 3. Cek saudara di character.siblings
      if (effectiveRole == targetRole) {
        for (var sib in character.siblings) {
          final String sName = AvatarAgeRules.getCleanNPCName((sib['name'] ?? '').toString());
          if (sName.isNotEmpty && (sName == cleanTargetName || targetName.contains(sName) || targetRole.contains(sName))) {
            effectiveRole = (sib['role'] ?? sib['relation'] ?? 'Saudara Kandung').toString();
            break;
          }
        }
      }

      // 4. Cek keluarga besar di character.extendedFamily
      if (effectiveRole == targetRole) {
        for (var fam in character.extendedFamily) {
          final String fName = AvatarAgeRules.getCleanNPCName((fam['name'] ?? '').toString());
          if (fName.isNotEmpty && (fName == cleanTargetName || targetName.contains(fName) || targetRole.contains(fName))) {
            effectiveRole = (fam['role'] ?? fam['relation'] ?? 'Keluarga').toString();
            break;
          }
        }
      }
    }

    final String roleLower = effectiveRole.toLowerCase();
    final String targetNameLower = targetName.toLowerCase();

    // 0. Hubungan Keluarga (Prioritas Utama jika relasi mengandung unsur keluarga)
    final bool isFamilyRole = roleLower.contains('ayah') ||
        roleLower.contains('bapak') ||
        roleLower.contains('papa') ||
        roleLower.contains('ibu') ||
        roleLower.contains('mama') ||
        roleLower.contains('mami') ||
        roleLower.contains('kakak') ||
        roleLower.contains('mas') ||
        roleLower.contains('mbak') ||
        roleLower.contains('abang') ||
        roleLower.contains('adik') ||
        roleLower.contains('dek') ||
        roleLower.contains('anak') ||
        roleLower.contains('putri') ||
        roleLower.contains('putra') ||
        roleLower.contains('paman') ||
        roleLower.contains('om') ||
        roleLower.contains('bibi') ||
        roleLower.contains('tante') ||
        roleLower.contains('sepupu') ||
        roleLower.contains('kakek') ||
        roleLower.contains('opa') ||
        roleLower.contains('nenek') ||
        roleLower.contains('oma') ||
        roleLower.contains('cucu') ||
        roleLower.contains('keponakan') ||
        roleLower.contains('donor') ||
        roleLower.contains('tabung') ||
        targetNameLower.contains('donor') ||
        targetNameLower.contains('anak anda');

    if (isFamilyRole) {
      return PanggilanKeluarga.getPanggilan(
        targetName: targetName,
        relationKey: effectiveRole,
        isSpeakerPlayer: isSpeakerPlayer,
        userName: userName,
        userGender: userGender,
        targetGender: targetGender,
      );
    }

    // 1. Pasangan (Pacar, Tunangan, Suami, Istri)
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
        character: character,
      );
    }

    // 2. Idol / Staff Idol / Manager Idol / Produser
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

    // 3. Pekerjaan (Rekan Kerja, Bos, Atasan, Supervisor, Bawahan, Dosen, Guru)
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

    // 4. Hubungan Keluarga (Ayah, Ibu, Kakak, Adik, Paman, Bibi, Sepupu, Kakek, Nenek, Cucu, Keponakan, dll)
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
