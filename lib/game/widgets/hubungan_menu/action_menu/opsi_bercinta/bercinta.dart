// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/penyakit_logic/std_logic.dart';
import 'package:bitlife/game/widgets/penyakit_logic/incest_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_hamil.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/kepuasan_bercinta.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCondomNeeded();
    });
  }

  String _getTargetRoleLabel() {
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
    final bool isHetero = myGender != partnerGender; // Berbeda gender

    String riskInfo = '';
    String whoGetsPregnant = '';
    int ageMin = 0, ageMax = 0;

    if (isHetero) {
      if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        whoGetsPregnant = 'Kamu hamil';
        ageMin = 8; ageMax = 45;
      } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        whoGetsPregnant = 'Pasanganmu hamil';
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
    } else {
      riskInfo = 'Kombinasi gender: Kamu ($myGender) dan Pasangan ($partnerGender) -> Risiko hamil 0% (Tidak memungkinkan secara biologis).';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.health_and_safety, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text('Gunakan Pengaman?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apa kamu ingin menggunakan kondom untuk mencegah kehamilan?',
              style: TextStyle(fontSize: 14),
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                riskInfo,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.blue),
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

  void _executeMakeLove() {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    bool success = false;
    final String myGender = widget.character.gender.trim().toLowerCase();
    final String targetNameLower = widget.targetName.toLowerCase();
    final String targetRoleLower = widget.targetRole.toLowerCase();
    final bool isChild = widget.targetRole == 'Laki-laki' || widget.targetRole == 'Perempuan';
    final String partnerGender = _getPartnerGender().trim().toLowerCase();

    // Bonus 15% jika target tersebut sudah berstatus resmi sebagai pacar aktif
    int partnerBonus = 0;
    if (widget.character.partner != null && widget.character.partner!['name'] == widget.targetName) {
      partnerBonus = 15;
    }

    // Gunakan logika persentase sukses terpusat
    success = HubunganIntimLogic.calculateMakeLoveSuccess(
      myGender: myGender,
      partnerGender: partnerGender,
      targetName: widget.targetName,
      targetRole: widget.targetRole,
      partnerBonus: partnerBonus,
      random: _random,
      playerAge: widget.character.age,
    );

    int relationChange = 0;

    // --- LOGIKA KETAHUAN BERCINTA (SUPER KETAT) ---
    // Di Rumah: Pagi (50%), Siang (55%), Malam (20%)
    // Di Hotel: 20%
    if (success) {
      int caughtChance = 0;
      if (_chosenLocation.contains('Rumah')) {
        final String t = _chosenTime.toLowerCase();
        if (t.contains('pagi')) {
          caughtChance = 50;
        } else if (t.contains('siang') || t.contains('sore')) {
          caughtChance = 55;
        } else if (t.contains('malam')) {
          caughtChance = 20;
        }
      } else if (_chosenLocation.contains('Hotel')) {
        caughtChance = 20;
      }

      if (_random.nextInt(100) < caughtChance) {
        // Gagal karena ketahuan!
        success = false;
        // Pinalti hubungan dengan target
        relationChange = -(_random.nextInt(15) + 15); // -15% s/d -30%
        // Buat detail penolakan khusus
        final String firstPartnerName = widget.character.partner?['name'] ?? 'pasanganmu';
        final String informantDesc = _chosenLocation.contains('Rumah') ? 'keluarga/tetangga' : 'petugas hotel';
        
        // Pinalti hubungan dengan pacar utama jika ada
        if (widget.character.partner != null) {
          int rel = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
          widget.character.partner!['relationship'] = (rel - 25).clamp(0, 100).toString();
        }
        widget.character.happiness = (widget.character.happiness - 20).clamp(0, 100);
        widget.character.inbox.add('😡 Ketahuan Basah: Aksi bercintamu dengan ${widget.targetName} ketahuan oleh $informantDesc! Hubunganmu dengan $firstPartnerName memburuk drastis.');

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
              'Gawat! Saat hendak berhubungan intim $_chosenLocation pada waktu $_chosenTime, aksi kalian dipergoki oleh $informantDesc! '
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

    relationChange = success
        ? _random.nextInt(11) + 10
        : -(_random.nextInt(5) + 1);

    String title, message;
    IconData icon;
    Color color;
    // Hanya perubahan state (happiness), TIDAK termasuk onActionComplete
    // supaya screen tidak di-pop sebelum dialog kehamilan selesai
    VoidCallback applyStateChange;

    final String relation = widget.targetName.split(' ')[0];

    if (success) {
      title = 'Momen Mesra';
      message = '$relation menerima ajakanmu dengan hangat dan penuh gairah. Kalian menghabiskan waktu yang sangat intim $_chosenLocation pada waktu $_chosenTime! (+${relationChange.abs()}% hubungan)';
      icon = Icons.favorite;
      color = Colors.pink;

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
      title = 'Momen Canggung';
      message = '$relation menolak ajakanmu dengan halus ketika diajak bercinta $_chosenLocation pada waktu $_chosenTime. Kamu merasa sedikit dipermalukan dan canggung (${relationChange.abs()}% hubungan).';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.orange;
      applyStateChange = () {
        widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
      };
    }

    // --- LOGIKA KEHAMILAN DINAMIS ---
    bool isPregnant = false;
    bool isPartnerPregnant = false;
    String additionalMessage = '';

    if (success && _useCondom == false && myGender != partnerGender) {
      
      // Ambil kesuburan berdasarkan usia dan gender
      double myFertility = _getFertilityRate(widget.character.age, myGender);
      
      if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        if (widget.character.isPregnant) {
          additionalMessage = 'Kamu sudah dalam kondisi hamil.';
        } else {
          if (myFertility > 0) {
            if (_random.nextDouble() < myFertility) {
              isPregnant = true;
              widget.character.isPregnant = true;
              widget.character.pregnantByPartnerName = widget.targetName;
              widget.character.pregnantByPartnerRole = widget.targetRole;
              
              widget.character.inbox.add(
                '🍼 Kabar Kehamilan: Kamu hamil dari hasil hubungan intim dengan $relation!'
              );
            } else {
              additionalMessage = 'Kali ini belum berhasil hamil. (Kesuburan saat ini: ${(myFertility * 100).toInt()}%)';
            }
          } else {
            additionalMessage = 'Usia kamu ${widget.character.age} tahun. Kamu sudah melewati masa subur (8-45 tahun).';
          }
        }
      } 
      else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        if (widget.character.partnerIsPregnant) {
          additionalMessage = 'Pasanganmu sudah dalam kondisi hamil.';
        } else {
          if (myFertility > 0) {
            if (_random.nextDouble() < myFertility) {
              isPartnerPregnant = true;
              widget.character.partnerIsPregnant = true;
              widget.character.pregnantByPartnerName = widget.targetName;
              widget.character.pregnantByPartnerRole = widget.targetRole;
              
              widget.character.inbox.add(
                '👶 Kabar Kehamilan: Pasangan/keluargamu, $relation, hamil dari hasil hubungan intim denganmu!'
              );
            } else {
              additionalMessage = 'Kali ini belum berhasil menghamili. (Kesuburan saat ini: ${(myFertility * 100).toInt()}%)';
            }
          } else {
            additionalMessage = 'Usia kamu ${widget.character.age} tahun. Kamu sudah melewati masa subur (9-65 tahun).';
          }
        }
      }
    }

    // Pemicu pengecekan penyakit menular seksual (STD) jika tidak pakai pengaman
    if (success && _useCondom == false) {
      handleSTDCheck(widget.character, widget.targetRole, widget.targetName, _random);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontSize: 14)),
            
            if (additionalMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Text(additionalMessage, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue)),
              ),
            ],

            if (isPregnant) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.pink.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.pregnant_woman, color: Colors.pink, size: 20),
                    SizedBox(width: 8),
                    Text('Kamu hamil! 🍼', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                  ],
                ),
              ),
            ],

             if (isPartnerPregnant) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wc, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Text('$relation hamil! 👶', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 1. Tutup dialog hasil bercinta
              Navigator.of(context).pop();
              // 2. Terapkan perubahan state (happiness dll)
              applyStateChange();
              if (isPregnant || isPartnerPregnant) {
                // 3a. Tampilkan dialog kehamilan, baru setelah selesai
                //     tutup BercintaScreen dan panggil onActionComplete
                BeritahuKehamilanHelper.showTellOrNotDialog(
                  context: context,
                  character: widget.character,
                  partnerName: widget.targetName,
                  partnerRole: widget.targetRole,
                  onComplete: () {
                    // Pastikan context masih valid sebelum pop
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    widget.onActionComplete.call();
                  },
                );
              } else {
                // 3b. Tidak ada kehamilan – langsung tutup dan selesai
                Navigator.of(context).pop();
                widget.onActionComplete.call();
              }
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == widget.targetName) {
          targetAge = int.tryParse(sib['age'] ?? '18') ?? 18;
          break;
        }
      }
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == widget.targetName) {
          targetAge = int.tryParse(ext['age'] ?? '18') ?? 18;
          break;
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
