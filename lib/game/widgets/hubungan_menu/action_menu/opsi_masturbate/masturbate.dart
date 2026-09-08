// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/masturbate.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/kepuasan_bercinta.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/masturbate_enjoyment.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_masturbate/ajak_masturbate_dialogue.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';

class MasturbateScreen extends StatefulWidget {
  final Character character;
  final String targetName;
  final String targetRole;
  final VoidCallback onActionComplete;

  const MasturbateScreen({
    super.key,
    required this.character,
    required this.targetName,
    required this.targetRole,
    required this.onActionComplete,
  });

  @override
  State<MasturbateScreen> createState() => _MasturbateScreenState();
}

class _MasturbateScreenState extends State<MasturbateScreen> {
  final Random _random = Random();
  bool _isProcessing = false;
  bool _partnerConsentGranted = false;

  String _chosenLocation = 'Kamar Tidur';
  String _chosenTime = 'Malam';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMasturbateFlow();
    });
  }

  String _getTargetRoleLabel() {
    final String cleanTargetName = widget.targetName;
    for (var child in widget.character.children) {
      if (child['name'] == cleanTargetName) {
        return 'Anak';
      }
    }
    final String role = widget.targetRole;
    if (role == 'Laki-laki' || role == 'Perempuan') {
      return 'Anak';
    }
    final String name = widget.targetName;
    if (name.startsWith('Ayah')) {
      return widget.targetRole == 'Tiri' ? 'Ayah Tiri' : 'Ayah';
    }
    if (name.startsWith('Ibu')) {
      return 'Ibu';
    }
    final int startIndex = name.indexOf('(');
    final int endIndex = name.indexOf(')');
    if (startIndex != -1 && endIndex != -1) {
      return name.substring(startIndex + 1, endIndex).trim();
    }
    return 'Saudara';
  }

  String _getPartnerGender() {
    final String cleanTargetName = widget.targetName;
    if (widget.character.partner != null && widget.character.partner!['name'] == cleanTargetName) {
      return widget.character.partner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == cleanTargetName) {
      return widget.character.secondPartner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == cleanTargetName) {
      return widget.character.thirdPartner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == cleanTargetName) {
      return widget.character.fourthPartner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == cleanTargetName) {
      return widget.character.fifthPartner!['gender'] ?? 'Perempuan';
    }
    for (var child in widget.character.children) {
      if (child['name'] == cleanTargetName) {
        return child['gender'] ?? 'Perempuan';
      }
    }
    return HubunganIntimLogic.getPartnerGender(widget.targetName);
  }

  int _getTargetRelationship() {
    final String cleanTargetName = widget.targetName;
    if (widget.character.partner != null && widget.character.partner!['name'] == cleanTargetName) {
      return int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
    }
    if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == cleanTargetName) {
      return int.tryParse(widget.character.secondPartner!['relationship'] ?? '50') ?? 50;
    }
    if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == cleanTargetName) {
      return int.tryParse(widget.character.thirdPartner!['relationship'] ?? '50') ?? 50;
    }
    if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == cleanTargetName) {
      return int.tryParse(widget.character.fourthPartner!['relationship'] ?? '50') ?? 50;
    }
    if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == cleanTargetName) {
      return int.tryParse(widget.character.fifthPartner!['relationship'] ?? '50') ?? 50;
    }
    for (var child in widget.character.children) {
      if (child['name'] == cleanTargetName) {
        return int.tryParse(child['relationship'] ?? '50') ?? 50;
      }
    }
    for (var sibling in widget.character.siblings) {
      if (sibling['name'] == cleanTargetName) {
        return int.tryParse(sibling['relationship'] ?? '50') ?? 50;
      }
    }
    for (var family in widget.character.extendedFamily) {
      if (family['name'] == cleanTargetName) {
        return int.tryParse(family['relationship'] ?? '50') ?? 50;
      }
    }
    return 50;
  }

  Future<void> _startMasturbateFlow() async {
    final int satisfaction = _getTargetRelationship();
    final String partnerGender = _getPartnerGender();

    // 1. Cek Kesediaan Pasangan (Willingness)
    bool isWilling = KepuasanBercintaHelper.checkWillingness(
      context: context,
      character: widget.character,
      targetName: widget.targetName,
      targetGender: partnerGender,
      satisfaction: satisfaction,
      onRejected: () {
        if (mounted) Navigator.pop(context);
      },
      onAccepted: () {
        _partnerConsentGranted = true;
      },
    );

    if (!isWilling) return;

    // Hitung Usia Target
    final String plainName = AvatarAgeRules.getCleanNPCName(widget.targetName);
    int realTargetAge = 18;
    for (var sib in widget.character.siblings) {
      if (sib['name'] == plainName || widget.targetName.contains(sib['name'] ?? '')) {
        realTargetAge = int.tryParse(sib['age'] ?? '18') ?? 18;
        break;
      }
    }
    if (realTargetAge == 18) {
      for (var child in widget.character.children) {
        if (child['name'] == plainName || widget.targetName.contains(child['name'] ?? '')) {
          realTargetAge = int.tryParse(child['age'] ?? '18') ?? 18;
          break;
        }
      }
    }

    // 2. Pilih Lokasi (Sesuai usia user: 12-16 Rumah, 17 Rumah+Mobil, 18+ Rumah+Mobil+Hotel)
    final String? chosenLoc = await TempatBercintaHelper.showLocationChooser(
      context: context,
      character: widget.character,
      partnerName: widget.targetName,
      userAge: widget.character.age,
      targetAge: realTargetAge,
    );

    if (chosenLoc == null) {
      if (mounted) Navigator.pop(context);
      return;
    }
    _chosenLocation = chosenLoc;

    // 3. Pilih Waktu
    if (!mounted) return;
    final String? chosenTime = await PilihWaktuHelper.showTimeChooser(context, _chosenLocation);
    if (chosenTime == null) {
      if (mounted) Navigator.pop(context);
      return;
    }
    _chosenTime = chosenTime;

    // 4. Eksekusi Masturbasi Bersama
    _executeMasturbateTogether();
  }

  Future<void> _executeMasturbateTogether() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    bool success = _partnerConsentGranted;

    // --- LOGIKA KETAHUAN MASTURBASI BERSAMA ---
    if (success) {
      int caughtChance = 0;
      final String trLower = widget.targetRole.toLowerCase();
      final bool isSpouse = trLower == 'istri' || trLower == 'suami' || trLower == 'pasangan';

      if (!isSpouse) {
        final String locLower = _chosenLocation.toLowerCase();
        final String tLower = _chosenTime.toLowerCase();

        if (locLower.contains('kamar tidur')) {
          if (tLower.contains('pagi')) {
            caughtChance = 50; // (60 - 10)
          } else if (tLower.contains('siang')) {
            caughtChance = 25; // (35 - 10)
          } else if (tLower.contains('sore')) {
            caughtChance = 30; // (40 - 10)
          } else if (tLower.contains('malam')) {
            caughtChance = 10; // (15 - 10, mentok 10)
          }
        } else if (locLower.contains('kamar mandi')) {
          if (tLower.contains('pagi')) {
            caughtChance = 50; // (60 - 10)
          } else if (tLower.contains('siang')) {
            caughtChance = 20; // (30 - 10)
          } else if (tLower.contains('sore')) {
            caughtChance = 30; // (40 - 10)
          } else if (tLower.contains('malam')) {
            caughtChance = 10; // (10 mentok)
          }
        } else if (locLower.contains('ruang tamu')) {
          if (tLower.contains('pagi')) {
            caughtChance = 70; // (80 - 10)
          } else if (tLower.contains('siang')) {
            caughtChance = 35; // (45 - 10)
          } else if (tLower.contains('sore')) {
            caughtChance = 20; // (30 - 10)
          } else if (tLower.contains('malam')) {
            caughtChance = 30; // (40 - 10)
          }
        } else if (locLower.contains('dapur')) {
          if (tLower.contains('pagi')) {
            caughtChance = 30; // (40 - 10)
          } else if (tLower.contains('siang')) {
            caughtChance = 20; // (30 - 10)
          } else if (tLower.contains('sore')) {
            caughtChance = 55; // (65 - 10)
          } else if (tLower.contains('malam')) {
            caughtChance = 20; // (30 - 10)
          }
        } else if (locLower.contains('rumah')) {
          if (tLower.contains('pagi')) {
            caughtChance = 40;
          } else if (tLower.contains('siang')) {
            caughtChance = 25;
          } else if (tLower.contains('sore')) {
            caughtChance = 30;
          } else if (tLower.contains('malam')) {
            caughtChance = 10;
          }
        } else if (locLower.contains('mobil')) {
          if (tLower.contains('pagi')) {
            caughtChance = 50; // (60 - 10)
          } else if (tLower.contains('siang')) {
            caughtChance = 50; // (60 - 10)
          } else if (tLower.contains('sore')) {
            caughtChance = 40; // (50 - 10)
          } else if (tLower.contains('malam')) {
            caughtChance = 20; // (30 - 10)
          }
        } else if (locLower.contains('hotel')) {
          if (tLower.contains('pagi')) {
            caughtChance = 10; // (15 - 10 mentok 10)
          } else if (tLower.contains('siang')) {
            caughtChance = 10; // (20 - 10)
          } else if (tLower.contains('sore')) {
            caughtChance = 10; // (10 mentok 10)
          } else if (tLower.contains('malam')) {
            caughtChance = 5;  // (5 mentok 5)
          }
        }
      }

      if (caughtChance > 0 && _random.nextInt(100) < caughtChance) {
        success = false;
        int relationChange = -(_random.nextInt(15) + 15); // -15% s/d -30%
        final String firstPartnerName = widget.character.partner?['name'] ?? 'pasanganmu';
        final String informantDesc = _chosenLocation.contains('Rumah') ? 'keluarga/tetangga' : 'petugas hotel';
        
        final bool isWithMainPartner = widget.character.partner != null &&
            (widget.targetName == widget.character.partner!['name'] ||
             widget.targetName.contains(widget.character.partner!['name'] ?? '___') ||
             (widget.character.partner!['name'] ?? '').contains(widget.targetName));

        if (widget.character.partner != null && !isWithMainPartner) {
          int rel = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
          widget.character.partner!['relationship'] = (rel + relationChange).clamp(0, 100).toString();
        }
        widget.character.happiness = (widget.character.happiness - 20).clamp(0, 100);

        if (isWithMainPartner) {
          widget.character.inbox.add('😡 Ketahuan Basah: Aksi masturbasi bersama dengan ${widget.targetName} ketahuan oleh $informantDesc!');
        } else {
          widget.character.inbox.add('😡 Ketahuan Basah: Aksi masturbasi bersama dengan ${widget.targetName} ketahuan oleh $informantDesc! Hubunganmu dengan $firstPartnerName memburuk drastis.');
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogCtx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('Ketahuan Basah! 😡', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              isWithMainPartner
                  ? 'Gawat! Saat hendak melakukan masturbasi bersama $_chosenLocation pada waktu $_chosenTime, aksi kalian dipergoki oleh $informantDesc!'
                  : 'Gawat! Saat hendak melakukan masturbasi bersama $_chosenLocation pada waktu $_chosenTime, aksi kalian dipergoki oleh $informantDesc! '
                    'Kabar buruk ini menyebar cepat dan pacar utamamu ($firstPartnerName) mengetahuinya!',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  Navigator.pop(context); // Tutup MasturbateScreen
                  widget.onActionComplete.call();
                },
                child: const Text('Lanjutkan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
        return;
      }
    }

    if (success) {
      widget.character.inbox.add(
        '📢 Aktivitas Real-time: Kamu baru saja melakukan masturbasi bersama dengan ${widget.targetName} $_chosenLocation pada waktu $_chosenTime.'
      );
      widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
    } else {
      return;
    }

    final int relationshipValue = _getTargetRelationship();
    final String partnerGender = _getPartnerGender();
    final String plainName = AvatarAgeRules.getCleanNPCName(widget.targetName);

    int realTargetAge = 18;
    for (var sib in widget.character.siblings) {
      if (sib['name'] == plainName || widget.targetName.contains(sib['name'] ?? '')) {
        realTargetAge = int.tryParse(sib['age'] ?? '18') ?? 18;
        break;
      }
    }
    if (realTargetAge == 18) {
      for (var child in widget.character.children) {
        if (child['name'] == plainName || widget.targetName.contains(child['name'] ?? '')) {
          realTargetAge = int.tryParse(child['age'] ?? '18') ?? 18;
          break;
        }
      }
    }

    final String? skinColor = widget.character.getFamilyMemberSkinColor(widget.targetName);
    final String npcAvatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: plainName,
      gender: partnerGender,
      age: realTargetAge,
      happiness: relationshipValue,
      forcedSkinColor: skinColor,
    );

    final Map<String, dynamic> npcMap = {
      'name': widget.targetName,
      'plainName': plainName,
      'role': widget.targetRole,
      'gender': partnerGender,
      'age': '$realTargetAge tahun',
      'relationship': relationshipValue.toString(),
      'avatarUrl': npcAvatarUrl,
      'skinColor': skinColor,
    };

    final vnNodes = AjakMasturbateDialogue.getDialogue(
      player: widget.character,
      npc: npcMap,
      chosenLocation: _chosenLocation,
      chosenTime: _chosenTime,
      isAccepted: success,
    );

    VNDialogueOverlay.show(
      context: context,
      player: widget.character,
      npc: npcMap,
      nodes: vnNodes,
      npcAvatarUrl: npcAvatarUrl,
      customLocation: _chosenLocation,
      onFinished: () async {
        if (!context.mounted) return;

        MasturbateEnjoymentModal.show(
          context: context,
          character: widget.character,
          fantasyPartner: widget.targetName,
          isMutual: true,
          partnerName: widget.targetName,
          partnerRelation: _getTargetRoleLabel(),
          onComplete: () {
            Navigator.pop(context); // Tutup MasturbateScreen
            widget.onActionComplete.call();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.5),
      body: const Center(
        child: CircularProgressIndicator(color: Colors.purpleAccent),
      ),
    );
  }
}
