import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/penyakit_logic/std_logic.dart';
import 'package:bitlife/game/widgets/penyakit_logic/incest_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/pilih_tempat.dart';

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
    final String name = widget.targetName;
    if (name.startsWith('Ayah')) return 'Laki-laki';
    if (name.startsWith('Ibu')) return 'Perempuan';

    final int startIndex = name.indexOf('(');
    final int endIndex = name.indexOf(')');
    if (startIndex != -1 && endIndex != -1) {
      final String relationText = name.substring(startIndex + 1, endIndex).toLowerCase();
      if (relationText.contains('perempuan')) return 'Perempuan';
      if (relationText.contains('laki-laki')) return 'Laki-laki';
    }
    return 'Laki-laki';
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

  // --- FUNGSI LOGIKA KESUBURAN DINAMIS ---
  double _getFertilityRate(int age, String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan') {
      if (age < 8 || age > 45) return 0.0;
      if (age >= 8 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.65;
      if (age >= 40 && age <= 45) return 0.30;
    } else { // laki-laki
      if (age < 9 || age > 65) return 0.0;
      if (age >= 9 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.75;
      if (age >= 40 && age <= 49) return 0.55;
      if (age >= 50 && age <= 65) return 0.35;
    }
    return 0.0;
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

    // 1. Logika Orang Tua (User) Mengajak Anak Kandung/Tiri (Target)
    if (isChild) {
      if (myGender == 'laki-laki') {
        // Sebagai Ayah
        if (partnerGender == 'laki-laki') {
          // Mengajak anak laki-laki: 20%
          success = _random.nextInt(100) < (20 + partnerBonus);
        } else {
          // Mengajak anak perempuan: 35%
          success = _random.nextInt(100) < (35 + partnerBonus);
        }
      } else {
        // Sebagai Ibu
        if (partnerGender == 'laki-laki') {
          // Mengajak anak laki-laki: 20%
          success = _random.nextInt(100) < (20 + partnerBonus);
        } else {
          // Mengajak anak perempuan: 20%
          success = _random.nextInt(100) < (20 + partnerBonus);
        }
      }
    } 
    // 2. Logika Anak (User) Mengajak Orang Tua (Target)
    else if (targetNameLower.startsWith('ayah') || targetNameLower.contains('ayah')) {
      if (myGender == 'laki-laki') {
        // Anak laki mengajak ayahnya: 10%
        success = _random.nextInt(100) < (10 + partnerBonus);
      } else {
        // Anak perempuan mengajak ayahnya: 30%
        success = _random.nextInt(100) < (30 + partnerBonus);
      }
    } else if (targetNameLower.startsWith('ibu') || targetNameLower.contains('ibu')) {
      if (myGender == 'laki-laki') {
        // Anak laki mengajak ibunya: 10%
        success = _random.nextInt(100) < (10 + partnerBonus);
      } else {
        // Anak perempuan mengajak ibunya: 30%
        success = _random.nextInt(100) < (30 + partnerBonus);
      }
    }
    // 3. Logika Saudara Kandung / Incest Sibling (User dengan Target Kakak/Adik)
    else if (targetRoleLower.contains('saudara') || targetNameLower.contains('kakak') || targetNameLower.contains('adik')) {
      final bool isTargetOlder = targetNameLower.contains('kakak');
      
      if (myGender == 'perempuan' && partnerGender == 'perempuan') {
        // Anak perempuan dengan anak perempuan: 20%
        success = _random.nextInt(100) < (20 + partnerBonus);
      } else if (myGender == 'laki-laki' && partnerGender == 'laki-laki') {
        // Anak laki dengan anak laki: 10%
        success = _random.nextInt(100) < (10 + partnerBonus);
      } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        // Kakak laki adik perempuan ATAU adik laki kakak perempuan
        if (isTargetOlder) {
          // Target adalah Kakak Perempuan -> User adalah Adik Laki -> Adik laki kakak perempuan: 30%
          success = _random.nextInt(100) < (30 + partnerBonus);
        } else {
          // Target adalah Adik Perempuan -> User adalah Kakak Laki -> Kakak laki adik perempuan: 30%
          success = _random.nextInt(100) < (30 + partnerBonus);
        }
      } else if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        // Kakak perempuan adik laki ATAU adik perempuan kakak laki
        if (isTargetOlder) {
          // Target adalah Kakak Laki -> User adalah Adik Perempuan -> Kakak laki adik perempuan: 30%
          success = _random.nextInt(100) < (30 + partnerBonus);
        } else {
          // Target adalah Adik Laki -> User adalah Kakak Perempuan -> Adik laki kakak perempuan: 30%
          success = _random.nextInt(100) < (30 + partnerBonus);
        }
      } else {
        success = _random.nextInt(100) < 30; // Persentase default saudara/i 30%
      }
    }
    // 4. Hubungan Normal / Bukan Incest
    else {
      success = _random.nextInt(100) < 65;
    }

    int relationChange = success
        ? _random.nextInt(11) + 10
        : -(_random.nextInt(6) + 2);

    String title, message;
    IconData icon;
    Color color;
    VoidCallback stateUpdate;

    final String relation = widget.targetName.split(' ')[0];

    if (success) {
      title = 'Momen Mesra';
      message = '$relation menerima ajakanmu dengan hangat dan penuh gairah. Kalian menghabiskan malam yang sangat intim $_chosenLocation! (+${relationChange.abs()}% hubungan)';
      icon = Icons.favorite;
      color = Colors.pink;
      
      // Jika berhasil berhubungan seksual dan target adalah anak (Incest dari sisi Orang Tua mengajak Anak)
      if (isChild) {
        widget.character.inbox.add(
          '📢 Aktivitas Real-time: Kamu baru saja melakukan hubungan intim (Make Love) dengan anakmu, ${widget.targetName} $_chosenLocation.'
        );
      }
      // Jika target adalah orang tua (Incest dari sisi Anak mengajak Orang Tua)
      else if (targetNameLower.startsWith('ayah') || targetNameLower.contains('ayah') || targetNameLower.startsWith('ibu') || targetNameLower.contains('ibu')) {
        widget.character.inbox.add(
          '📢 Aktivitas Real-time: Kamu baru saja melakukan hubungan intim (Make Love) dengan orang tuamu, $relation $_chosenLocation.'
        );
      } else {
        widget.character.inbox.add(
          '📢 Aktivitas Real-time: Kamu baru saja melakukan hubungan intim (Make Love) dengan $relation $_chosenLocation.'
        );
      }

      stateUpdate = () {
        widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
        widget.onActionComplete.call();
      };
    } else {
      title = 'Momen Canggung';
      message = '$relation menolak ajakanmu dengan halus ketika diajak bercinta $_chosenLocation. Kamu merasa sedikit dipermalukan dan canggung (${relationChange.abs()}% hubungan).';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.orange;
      stateUpdate = () {
        widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
        widget.onActionComplete.call();
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
              Navigator.of(context).pop();
              stateUpdate();
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _chosenLocation = 'Rumah';

  void _checkCondomNeeded() async {
    final String? loc = await TempatBercintaHelper.showLocationChooser(context, widget.targetName);
    if (loc == null) {
      // Batal memilih tempat -> kembali
      Navigator.of(context).pop();
      return;
    }
    _chosenLocation = loc;

    if (_isCondomNeeded()) {
      _showCondomDialog();
    } else {
      _useCondom = null;
      _executeMakeLove();
    }
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