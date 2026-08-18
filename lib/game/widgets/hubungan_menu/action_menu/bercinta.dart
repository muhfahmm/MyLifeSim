// lib/game/widgets/hubungan_menu/action_menu/bercinta.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

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
      // Siapkan informasi yang akan ditampilkan di dialog
      if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        whoGetsPregnant = 'Kamu hamil';
        ageMin = 9; ageMax = 50;
      } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        whoGetsPregnant = 'Pasanganmu hamil';
        ageMin = 9; ageMax = 50;
      }

      // Cek usia untuk menentukan persentase
      bool isAgeValid = widget.character.age >= ageMin && widget.character.age <= ageMax;
      if (isAgeValid) {
        riskInfo = 'Jika TIDAK memakai pengaman: Ada 70% risiko $whoGetsPregnant! (Usia valid)';
      } else {
        riskInfo = 'Jika TIDAK memakai pengaman: Risiko 0% karena usia saat ini (${widget.character.age} tahun) belum memenuhi syarat. (Syarat: Minimal $ageMin tahun)';
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

  void _executeMakeLove() {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    bool success = false;
    final String myGender = widget.character.gender.trim().toLowerCase();
    final String targetNameLower = widget.targetName.toLowerCase();

    if (myGender == 'laki-laki' && targetNameLower.contains('kakak perempuan')) {
      // Adik laki-laki ke kakak perempuan -> 30%
      success = _random.nextInt(100) < 30;
    } else if (myGender == 'laki-laki' && targetNameLower.contains('adik perempuan')) {
      // Kakak laki-laki ke adik perempuan -> 40%
      success = _random.nextInt(100) < 40;
    } else if (myGender == 'perempuan' && (targetNameLower.startsWith('ayah') || targetNameLower.contains('ayah'))) {
      // Anak perempuan dengan ayah -> 40%
      success = _random.nextInt(100) < 40;
    } else if (myGender == 'perempuan' && (targetNameLower.startsWith('ibu') || targetNameLower.contains('ibu'))) {
      // Anak perempuan dengan ibu -> 30%
      success = _random.nextInt(100) < 30;
    } else if (myGender == 'laki-laki' && (targetNameLower.startsWith('ayah') || targetNameLower.contains('ayah'))) {
      // Anak laki-laki dengan ayah -> 10%
      success = _random.nextInt(100) < 10;
    } else if (myGender == 'laki-laki' && (targetNameLower.startsWith('ibu') || targetNameLower.contains('ibu'))) {
      // Anak laki-laki dengan ibu -> 10%
      success = _random.nextInt(100) < 10;
    } else if (widget.targetRole == 'Kandung' || widget.targetRole == 'Tiri' || widget.targetRole.contains('Saudara') || targetNameLower.contains('kakak') || targetNameLower.contains('adik')) {
      // Hubungan bercinta dengan keluarga lainnya (misal Kakak laki-laki, Adik laki-laki, dll)
      // Default incest rate keluarga lainnya diatur ke 20%
      success = _random.nextInt(100) < 20;
    } else {
      // Hubungan normal (Bukan keluarga)
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
      message = '$relation menerima ajakanmu dengan hangat dan penuh gairah. Kalian menghabiskan malam yang sangat intim! (+${relationChange.abs()}% hubungan)';
      icon = Icons.favorite;
      color = Colors.pink;
      stateUpdate = () {
        widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
        widget.onActionComplete.call();
      };
    } else {
      title = 'Momen Canggung';
      message = '$relation menolak ajakanmu dengan halus. Kamu merasa sedikit dipermalukan dan canggung (${relationChange.abs()}% hubungan).';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.orange;
      stateUpdate = () {
        widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
        widget.onActionComplete.call();
      };
    }

    // --- LOGIKA KEHAMILAN ---
    bool isPregnant = false;
    bool isPartnerPregnant = false;
    String additionalMessage = '';

    final String partnerGender = _getPartnerGender().trim().toLowerCase();

    if (_useCondom == false && myGender != partnerGender) {
      
      if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        if (widget.character.isPregnant) {
          additionalMessage = 'Kamu sudah dalam kondisi hamil.';
        } else {
          if (widget.character.age >= 9 && widget.character.age <= 50) {
            if (_random.nextInt(100) < 70) {
              isPregnant = true;
              widget.character.isPregnant = true;
              widget.character.pregnantByPartnerName = widget.targetName;
              widget.character.pregnantByPartnerRole = widget.targetRole;
            }
          }
        }
      } 
      else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        if (widget.character.partnerIsPregnant) {
          additionalMessage = 'Pasanganmu sudah dalam kondisi hamil.';
        } else {
          if (widget.character.age >= 9 && widget.character.age <= 50) {
            if (_random.nextInt(100) < 70) {
              isPartnerPregnant = true;
              widget.character.partnerIsPregnant = true;
              widget.character.pregnantByPartnerName = widget.targetName;
              widget.character.pregnantByPartnerRole = widget.targetRole;
            }
          }
        }
      }
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

  void _checkCondomNeeded() {
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