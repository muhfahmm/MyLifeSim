// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/penyakit_logic/std_logic.dart';
import 'package:mylifesim/game/widgets/penyakit_logic/incest_logic.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_hamil.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/kepuasan_bercinta.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_makelove/ajak_makelove_dialogue.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';

class BercintaScreen extends StatefulWidget {
  final Character character;
  final String targetName;
  final String targetRole;
  final VoidCallback onActionComplete;

  const BercintaScreen({
    super.key,
    required this.character,
    required this.targetName,
    required this.targetRole,
    required this.onActionComplete,
  });

  @override
  State<BercintaScreen> createState() => _BercintaScreenState();
}

class _BercintaScreenState extends State<BercintaScreen> {
  final Random _random = Random();
  bool _isProcessing = false;
  bool? _useCondom;
  bool _partnerConsentGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCondomNeeded();
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

  bool _isCondomNeeded() {
    final String myGender = widget.character.gender.trim().toLowerCase();
    final String partnerGender = _getPartnerGender().trim().toLowerCase();
    return myGender != partnerGender;
  }

  void _showCondomDialog() {
    final String myGender = widget.character.gender.trim().toLowerCase();
    final String partnerGender = _getPartnerGender().trim().toLowerCase();
    final bool isHetero = myGender != partnerGender;
    final bool isGay = myGender == 'laki-laki' && partnerGender == 'laki-laki';

    String riskInfo = '';

    if (isHetero) {
      final String whoGetsPregnant = myGender == 'perempuan' ? 'kamu hamil' : 'pasanganmu hamil';
      int ageMin = 13, ageMax = 50;
      if (myGender == 'perempuan') {
        ageMin = 10; ageMax = 55;
      } else {
        ageMin = 9; ageMax = 65;
      }

      // Cek usia untuk menentukan persentase (hanya info, logika detail ada di eksekusi)
      bool isAgeValid = widget.character.age >= ageMin && widget.character.age <= ageMax;
      if (isAgeValid) {
        double fertility = _getFertilityRate(widget.character.age, myGender);
        riskInfo = 'Jika TIDAK memakai pengaman: Ada ${(fertility * 100).toInt()}% risiko $whoGetsPregnant! (Usia saat ini ${widget.character.age} tahun, kesuburan ${(fertility * 100).toInt()}%)';
      } else {
        riskInfo = 'Jika TIDAK memakai pengaman: Risiko 0% karena usia saat ini (${widget.character.age} tahun) berada di luar masa subur. (Syarat: Minimal $ageMin - Maksimal $ageMax tahun)';
      }
    } else if (isGay) {
      riskInfo = '⚠️ Peringatan Kesehatan (Gay): Jika TIDAK memakai pengaman (kondom), terdapat 40% risiko terkena Penyakit Infeksi Menular Seksual (IMS) seperti HIV/AIDS, Sifilis, Gonore, atau HPV!';
    } else {
      riskInfo = 'Kombinasi gender: Kamu ($myGender) dan Pasangan ($partnerGender) -> Risiko hamil 0% (Tidak memungkinkan secara biologis).';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.health_and_safety, color: isGay ? Colors.redAccent : Colors.blue, size: 28),
            const SizedBox(width: 8),
            Text(isGay ? 'Gunakan Pengaman (IMS)?' : 'Gunakan Pengaman?', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGay
                  ? 'Apakah kamu ingin menggunakan pengaman (kondom) untuk melindungi diri dari Infeksi Menular Seksual (IMS)?'
                  : 'Apa kamu ingin menggunakan kondom untuk mencegah kehamilan?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              'Gender: Kamu (${widget.character.gender}) & ${_getTargetRoleLabel()} (${_getPartnerGender()})',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGay ? Colors.red.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isGay ? Colors.red.shade300 : Colors.blue.shade200),
              ),
              child: Text(
                riskInfo,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isGay ? Colors.red.shade900 : Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _useCondom = true;
              _executeMakeLove();
            },
            child: const Text('Ya, pakai', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _useCondom = false;
              _executeMakeLove();
            },
            child: const Text('Tidak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  double _getFertilityRate(int age, String gender) {
    return HubunganIntimLogic.getFertilityRate(age, gender);
  }

  bool _isTargetActivePartner() {
    return (widget.character.partner != null && widget.character.partner!['name'] == widget.targetName) ||
        (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == widget.targetName) ||
        (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == widget.targetName) ||
        (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == widget.targetName) ||
        (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == widget.targetName);
  }

  int _getPartnerBonus() {
    return widget.character.partner != null && widget.character.partner!['name'] == widget.targetName ? 15 : 0;
  }

  void _showEarlyRejectionDialog(int satisfaction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.heart_broken, color: Colors.red),
            SizedBox(width: 8),
            Text('Ajakan Ditolak 💔', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          '${widget.targetName} sedang tidak dalam mood yang baik meskipun hubungan kalian cukup dekat ($satisfaction%). Rawatlah hubunganmu terlebih dahulu!',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showExcusedRejectionDialog() {
    final excuses = [
      'sedang merasa sangat lelah setelah beraktivitas seharian.',
      'sedang tidak enak badan (kurang sehat) hari ini.',
      'sedang sibuk memikirkan pekerjaan/sekolah dan ingin beristirahat saja.',
      'sedang ingin fokus mengobrol biasa daripada bermesraan.',
      'sedang tidak mood untuk melakukan itu sekarang.'
    ];
    final String chosenExcuse = excuses[_random.nextInt(excuses.length)];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.heart_broken, color: Colors.red),
            SizedBox(width: 8),
            Text('Ajakan Ditolak 💔', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          '${widget.targetName} $chosenExcuse',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _executeMakeLove() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    bool success = _partnerConsentGranted;
    final String myGender = widget.character.gender.trim().toLowerCase();
    final String targetNameLower = widget.targetName.toLowerCase();
    final bool isChild = widget.targetRole == 'Laki-laki' || widget.targetRole == 'Perempuan';
    final String partnerGender = _getPartnerGender().trim().toLowerCase();

    // --- LOGIKA KETAHUAN BERCINTA (SUPER KETAT) ---






    // Di Rumah: Pagi (50%), Siang (55%), Malam (20%)
    // Di Hotel: 20%
    if (success) {
      int caughtChance = 0;
      final String trLower = widget.targetRole.toLowerCase();
      final bool isSpouse = trLower == 'istri' || trLower == 'suami' || trLower == 'pasangan';

      if (!isSpouse) {
        final String locLower = _chosenLocation.toLowerCase();
        final String tLower = _chosenTime.toLowerCase();

        if (locLower.contains('kamar tidur')) {
          if (tLower.contains('pagi')) {
            caughtChance = 60;
          } else if (tLower.contains('siang')) {
            caughtChance = 35;
          } else if (tLower.contains('sore')) {
            caughtChance = 40;
          } else if (tLower.contains('malam')) {
            caughtChance = 15;
          }
        } else if (locLower.contains('kamar mandi')) {
          if (tLower.contains('pagi')) {
            caughtChance = 60;
          } else if (tLower.contains('siang')) {
            caughtChance = 30;
          } else if (tLower.contains('sore')) {
            caughtChance = 40;
          } else if (tLower.contains('malam')) {
            caughtChance = 10;
          }
        } else if (locLower.contains('ruang tamu')) {
          if (tLower.contains('pagi')) {
            caughtChance = 80;
          } else if (tLower.contains('siang')) {
            caughtChance = 45;
          } else if (tLower.contains('sore')) {
            caughtChance = 30;
          } else if (tLower.contains('malam')) {
            caughtChance = 40;
          }
        } else if (locLower.contains('dapur')) {
          if (tLower.contains('pagi')) {
            caughtChance = 40;
          } else if (tLower.contains('siang')) {
            caughtChance = 30;
          } else if (tLower.contains('sore')) {
            caughtChance = 65;
          } else if (tLower.contains('malam')) {
            caughtChance = 30;
          }
        } else if (locLower.contains('rumah')) {
          // Fallback umum jika ruangan tidak terdeteksi spesifik
          if (tLower.contains('pagi')) {
            caughtChance = 50;
          } else if (tLower.contains('siang')) {
            caughtChance = 35;
          } else if (tLower.contains('sore')) {
            caughtChance = 40;
          } else if (tLower.contains('malam')) {
            caughtChance = 15;
          }
        } else if (locLower.contains('mobil')) {
          if (tLower.contains('pagi')) {
            caughtChance = 60;
          } else if (tLower.contains('siang')) {
            caughtChance = 60;
          } else if (tLower.contains('sore')) {
            caughtChance = 50;
          } else if (tLower.contains('malam')) {
            caughtChance = 30;
          }
        } else if (locLower.contains('hotel')) {
          if (tLower.contains('pagi')) {
            caughtChance = 15;
          } else if (tLower.contains('siang')) {
            caughtChance = 20;
          } else if (tLower.contains('sore')) {
            caughtChance = 10;
          } else if (tLower.contains('malam')) {
            caughtChance = 5;
          }
        }
      }

      if (caughtChance > 0 && _random.nextInt(100) < caughtChance) {
        // Gagal karena ketahuan!
        success = false;
        int relationChange = -(_random.nextInt(15) + 15); // -15% s/d -30%
        // Buat detail penolakan khusus
        final String firstPartnerName = widget.character.partner?['name'] ?? 'pasanganmu';
        final String informantDesc = _chosenLocation.contains('Rumah') ? 'keluarga/tetangga' : 'petugas hotel';
        
        final bool isWithMainPartner = widget.character.partner != null &&
            (widget.targetName == widget.character.partner!['name'] ||
             widget.targetName.contains(widget.character.partner!['name'] ?? '___') ||
             (widget.character.partner!['name'] ?? '').contains(widget.targetName));

        // Pinalti hubungan dengan pacar utama jika ada dan tidak sedang berhubungan dengan pacar utama
        if (widget.character.partner != null && !isWithMainPartner) {
          int rel = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
          widget.character.partner!['relationship'] = (rel + relationChange).clamp(0, 100).toString();
        }
        widget.character.happiness = (widget.character.happiness - 20).clamp(0, 100);
        if (isWithMainPartner) {
          widget.character.inbox.add('😡 Ketahuan Basah: Aksi bercintamu dengan ${widget.targetName} ketahuan oleh $informantDesc!');
        } else {
          widget.character.inbox.add('😡 Ketahuan Basah: Aksi bercintamu dengan ${widget.targetName} ketahuan oleh $informantDesc! Hubunganmu dengan $firstPartnerName memburuk drastis.');
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('Ketahuan Basah! 😡', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              isWithMainPartner
                  ? 'Gawat! Saat hendak berhubungan intim $_chosenLocation pada waktu $_chosenTime, aksi kalian dipergoki oleh $informantDesc!'
                  : 'Gawat! Saat hendak berhubungan intim $_chosenLocation pada waktu $_chosenTime, aksi kalian dipergoki oleh $informantDesc! '
                    'Kabar buruk ini menyebar cepat dan pacar utamamu ($firstPartnerName) mengetahuinya!',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Tutup layar bercinta
                  widget.onActionComplete.call();
                },
                child: const Text('Lanjutkan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
        return; // Hentikan eksekusi make love lebih lanjut
      }
    }
    final String relation = widget.targetName.split(' ')[0];



    VoidCallback applyStateChange = () {};


    if (success) {
      // Inbox log

      if (isChild) {
        widget.character.inbox.add(
          '📢 Aktivitas Real-time: Kamu baru saja melakukan hubungan intim (Make Love) dengan anakmu, ${widget.targetName} $_chosenLocation pada waktu $_chosenTime.'
        );
      } else if (targetNameLower.startsWith('ayah') || targetNameLower.contains('ayah') || targetNameLower.startsWith('ibu') || targetNameLower.contains('ibu')) {
        widget.character.inbox.add(
          '📢 Aktivitas Real-time: Kamu baru saja melakukan hubungan intim (Make Love) dengan orang tuamu, $relation $_chosenLocation pada waktu $_chosenTime.'
        );
      } else {
        widget.character.inbox.add(
          '📢 Aktivitas Real-time: Kamu baru saja melakukan hubungan intim (Make Love) dengan $relation $_chosenLocation pada waktu $_chosenTime.'
        );
      }

      applyStateChange = () {
        widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
      };
    } else {
      return;
    }

    // --- LOGIKA KEHAMILAN DINAMIS ---
    // Kehamilan HANYA terjadi jika:
    // 1. Sesi berhasil (success)
    // 2. Tidak pakai kondom (_useCondom == false)
    // 3. User memilih Ejakulasi "Di Dalam Vagina" (didCreampieThisSession == true)
    bool isPregnant = false;
    bool isPartnerPregnant = false;
    String additionalMessage = '';

    // Ambil dan langsung reset flag agar tidak bocor ke sesi berikutnya
    final bool didCreampie = widget.character.didCreampieThisSession;
    widget.character.didCreampieThisSession = false;
    widget.character.currentPosisiSeks = null;

    if (success && myGender != partnerGender && didCreampie) {
      if (_useCondom == true) {
        // Penggunaan pengaman (kondom) melindung dari kehamilan 100%
        additionalMessage = '🛡️ Penggunaan pengaman (kondom) melindungimu dari kehamilan (0% risiko hamil).';
      } else {
        // Tanpa pengaman: Risiko kehamilan bergantung pada tingkat kesuburan perempuan
        double femaleFertility = 0.0;
        int femaleAge = 0;

        if (myGender == 'perempuan') {
          femaleAge = widget.character.age;
          femaleFertility = _getFertilityRate(femaleAge, 'perempuan');

          if (widget.character.isPregnant) {
            additionalMessage = 'Kamu sudah dalam kondisi hamil.';
          } else {
            if (femaleFertility > 0) {
              double finalChance = widget.character.birthControlActive ? 0.05 : femaleFertility;
              if (_random.nextDouble() < finalChance) {
                isPregnant = true;
                widget.character.isPregnant = true;
                widget.character.pregnantByPartnerName = widget.targetName;
                widget.character.pregnantByPartnerRole = widget.targetRole;
                
                widget.character.inbox.add(
                  '🍼 Kabar Kehamilan: Kamu hamil dari hasil hubungan intim dengan $relation!'
                );
              } else {
                additionalMessage = widget.character.birthControlActive
                    ? 'Kontrol kehamilan (KB) aktif melindungimu dari kehamilan.'
                    : 'Kali ini belum berhasil hamil. (Kesuburan saat ini: ${(femaleFertility * 100).toInt()}%)';
              }
            } else {
              additionalMessage = 'Usia kamu $femaleAge tahun. Berada di luar masa subur (8-45 tahun).';
            }
          }
        } else if (partnerGender == 'perempuan') {
          // Cari usia partner jika tersedia
          femaleAge = 22; // default usia subur partner
          femaleFertility = _getFertilityRate(femaleAge, 'perempuan');

          if (widget.character.partnerIsPregnant) {
            additionalMessage = 'Pasanganmu sudah dalam kondisi hamil.';
          } else {
            if (femaleFertility > 0) {
              if (_random.nextDouble() < femaleFertility) {
                isPartnerPregnant = true;
                widget.character.partnerIsPregnant = true;
                widget.character.pregnantByPartnerName = widget.targetName;
                widget.character.pregnantByPartnerRole = widget.targetRole;
                
                widget.character.inbox.add(
                  '👶 Kabar Kehamilan: Pasangan/keluargamu, $relation, hamil dari hasil hubungan intim denganmu!'
                );
              } else {
                additionalMessage = 'Kali ini belum berhasil menghamili. (Kesuburan pasangan: ${(femaleFertility * 100).toInt()}%)';
              }
            } else {
              additionalMessage = 'Pasanganmu berada di luar masa subur.';
            }
          }
        }
      }
    } else if (success && myGender != partnerGender && !didCreampie && _useCondom != true) {
      // Tidak ejakulasi di dalam → aman dari kehamilan
      additionalMessage = '✅ Tidak ada risiko kehamilan (tidak ada ejakulasi di dalam vagina).';
    }

    // Pemicu pengecekan penyakit menular seksual (STD) dipindahkan ke akhir aliran dialog (pada tombol OK hasil bercinta)

    // Konsekuensi psikologis & genetik incest
    if (success) {
      if (context.mounted) {
        await handleIncestAfterSex(
          context,
          widget.character,
          widget.targetRole,
          widget.targetName,
          myGender,
          partnerGender,
          _random,
        );
      }
    }

    if (!mounted) return;
    String addText = '';
    if (additionalMessage.isNotEmpty) {
      addText += additionalMessage;
    }
    if (isPregnant) {
      if (addText.isNotEmpty) addText += '\n';
      addText += 'Kamu hamil! 🍼';
    }
    if (isPartnerPregnant) {
      if (addText.isNotEmpty) addText += '\n';
      addText += '$relation hamil! 👶';
    }

    final int relationshipValue = _getTargetRelationship();
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

    final vnNodes = AjakMakeLoveDialogue.getDialogue(
      player: widget.character,
      npc: npcMap,
      chosenLocation: _chosenLocation,
      chosenTime: _chosenTime,
      useCondom: _useCondom ?? false,
      isAccepted: success,
    );

    // Tampilkan Visual Novel Dialogue terlebih dahulu
    VNDialogueOverlay.show(
      context: context,
      player: widget.character,
      npc: npcMap,
      nodes: vnNodes,
      npcAvatarUrl: npcAvatarUrl,
      customLocation: _chosenLocation,
      onFinished: () async {
        if (!context.mounted) return;

        // Tampilkan Hasil Hubungan Intim SETELAH user menekan Selesai
        MLEnjoymentModal.show(
          context: context,
          character: widget.character,
          partnerName: widget.targetName,
          partnerRelation: widget.targetRole,
          relationshipValue: relationshipValue,
          additionalText: addText.isNotEmpty ? addText : null,
          onComplete: () async {
            applyStateChange();

            if (isPregnant || isPartnerPregnant) {
              if (!context.mounted) return;
              BeritahuKehamilanHelper.showTellOrNotDialog(
                context: context,
                character: widget.character,
                partnerName: widget.targetName,
                partnerRole: widget.targetRole,
                onComplete: () async {
                  if (_useCondom == false) {
                    final rel = detectIncestRelation(widget.character, widget.targetRole, widget.targetName);
                    if (rel != null && rel.geneticRisk > 0 && context.mounted) {
                      await showIncestGeneticModal(context, widget.targetName, widget.targetRole, rel.geneticRisk);
                    }
                  }

                  if (success && _useCondom == false && context.mounted) {
                    await handleSTDCheck(context, widget.character, widget.targetRole, widget.targetName, _random);
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  widget.onActionComplete.call();
                },
              );
            } else {
              if (success && _useCondom == false && context.mounted) {
                await handleSTDCheck(context, widget.character, widget.targetRole, widget.targetName, _random);
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
              widget.onActionComplete.call();
            }
          },
        );
      },
    );
  }


  int _getTargetRelationship() {
    int currentSatisfaction = 50; // default fallback
    final String cleanTargetName = widget.targetName;
    if (widget.character.partner != null && widget.character.partner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.secondPartner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.thirdPartner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.fourthPartner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.fifthPartner!['relationship'] ?? '50') ?? 50;
    } else {
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == cleanTargetName) {
          currentSatisfaction = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          break;
        }
      }
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == cleanTargetName) {
          currentSatisfaction = int.tryParse(ext['relationship'] ?? '50') ?? 50;
          break;
        }
      }
    }
    return currentSatisfaction;
  }

  String _chosenLocation = 'Rumah';
  String _chosenTime = 'Siang';

  void _checkCondomNeeded() async {
    // Cari usia target
    int targetAge = 18;
    if (widget.targetName.startsWith('Ayah')) {
      targetAge = widget.character.fatherAge ?? 40;
    } else if (widget.targetName.startsWith('Ibu')) {
      targetAge = widget.character.motherAge ?? 38;
    } else {
      bool found = false;
      // Cek partner utama / pacar aktif
      if (widget.character.partner != null && widget.character.partner!['name'] == widget.targetName) {
        targetAge = int.tryParse(widget.character.partner!['age'] ?? '18') ?? 18;
        found = true;
      } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == widget.targetName) {
        targetAge = int.tryParse(widget.character.secondPartner!['age'] ?? '18') ?? 18;
        found = true;
      } else if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == widget.targetName) {
        targetAge = int.tryParse(widget.character.thirdPartner!['age'] ?? '18') ?? 18;
        found = true;
      } else if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == widget.targetName) {
        targetAge = int.tryParse(widget.character.fourthPartner!['age'] ?? '18') ?? 18;
        found = true;
      } else if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == widget.targetName) {
        targetAge = int.tryParse(widget.character.fifthPartner!['age'] ?? '18') ?? 18;
        found = true;
      }

      if (!found) {
        for (var child in widget.character.children) {
          if (child['name'] == widget.targetName) {
            targetAge = int.tryParse(child['age'] ?? '18') ?? 18;
            found = true;
            break;
          }
        }
      }
      if (!found) {
        for (var sib in widget.character.siblings) {
          final String expectedLabel = '${sib['name']} (${sib['relation']})';
          if (expectedLabel == widget.targetName) {
            targetAge = int.tryParse(sib['age'] ?? '18') ?? 18;
            found = true;
            break;
          }
        }
      }
      if (!found) {
        for (var ext in widget.character.extendedFamily) {
          if (ext['name'] == widget.targetName) {
            targetAge = int.tryParse(ext['age'] ?? '18') ?? 18;
            found = true;
            break;
          }
        }
      }
    }

    // --- INTEGRASI KEPUASAN BERCINTA ---
    // Cari tingkat kepuasan hubungan dengan target ini
    int currentSatisfaction = 50; // default fallback
    final String cleanTargetName = widget.targetName;
    if (widget.character.partner != null && widget.character.partner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.secondPartner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.thirdPartner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.fourthPartner!['relationship'] ?? '50') ?? 50;
    } else if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name'] == cleanTargetName) {
      currentSatisfaction = int.tryParse(widget.character.fifthPartner!['relationship'] ?? '50') ?? 50;
    } else {
      // Cari di siblings
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == cleanTargetName) {
          currentSatisfaction = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          break;
        }
      }
      // Cari di extendedFamily
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == cleanTargetName) {
          currentSatisfaction = int.tryParse(ext['relationship'] ?? '50') ?? 50;
          break;
        }
      }
    }

    KepuasanBercintaHelper.checkWillingness(
      context: context,
      character: widget.character,
      targetName: widget.targetName,
      targetGender: _getPartnerGender(),
      satisfaction: currentSatisfaction,
      onRejected: () {
        Navigator.of(context).pop();
      },
      onAccepted: () async {
        final bool acceptedMakeLove = HubunganIntimLogic.calculateMakeLoveSuccess(
          character: widget.character,
          myGender: widget.character.gender.trim().toLowerCase(),
          partnerGender: _getPartnerGender().trim().toLowerCase(),
          targetName: widget.targetName,
          targetRole: widget.targetRole,
          partnerBonus: _getPartnerBonus(),
          random: _random,
          playerAge: widget.character.age,
          custodyParent: widget.character.custodyParent,
          isAlreadyPartner: _isTargetActivePartner(),
        );

        if (!acceptedMakeLove) {
          if (currentSatisfaction >= 60) {
            _showExcusedRejectionDialog();
          } else {
            _showEarlyRejectionDialog(currentSatisfaction);
          }
          return;
        }

        _partnerConsentGranted = true;

        final String? loc = await TempatBercintaHelper.showLocationChooser(
          context: context,
          character: widget.character,
          partnerName: widget.targetName,
          userAge: widget.character.age,
          targetAge: targetAge,
        );

        if (loc == null) {
          Navigator.of(context).pop();
          return;
        }

        final String? time = await PilihWaktuHelper.showTimeChooser(context, loc);
        if (time == null) {
          Navigator.of(context).pop();
          return;
        }

        _chosenLocation = loc;
        _chosenTime = time;

        if (_isCondomNeeded()) {
          _showCondomDialog();
        } else {
          _useCondom = null;
          _executeMakeLove();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bercinta dengan ${widget.targetName}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memproses aksi...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
