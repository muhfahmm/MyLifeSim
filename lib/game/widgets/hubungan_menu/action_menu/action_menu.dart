// lib/game/widgets/hubungan_menu/action_menu/action_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// Import logic per usia
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_base.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_3_6.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart';

class ActionMenuScreen extends StatefulWidget {
  final Character character;
  final String targetName;
  final String targetRole;

  const ActionMenuScreen({
    super.key,
    required this.character,
    required this.targetName,
    required this.targetRole,
  });

  @override
  State<ActionMenuScreen> createState() => _ActionMenuScreenState();
}

class _ActionMenuScreenState extends State<ActionMenuScreen> {
  final Random _random = Random();

  // Helper untuk mengambil nilai umur target saat ini
  String _getCurrentAgeValue() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Pacar' || role == 'Tunangan' || role == 'Suami' || role == 'Istri') {
      return widget.character.partner != null ? '${widget.character.partner!['age']} tahun' : 'Tidak diketahui';
    }

    if (role == 'Kandung' && name.startsWith('Ayah')) {
      return widget.character.fatherAge != null ? '${widget.character.fatherAge} tahun' : 'Tidak diketahui';
    } else if (role == 'Kandung' && name.startsWith('Ibu')) {
      return widget.character.motherAge != null ? '${widget.character.motherAge} tahun' : 'Tidak diketahui';
    } else if (role == 'Tiri' && name.startsWith('Ayah')) {
      return widget.character.stepFatherAge != null ? '${widget.character.stepFatherAge} tahun' : 'Tidak diketahui';
    } else {
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
          return sibAge < 0 ? 'Belum Lahir (Dalam Kandungan)' : '$sibAge tahun';
        }
      }
    }
    return 'Tidak diketahui';
  }

  // Helper untuk mengambil nilai hubungan target saat ini
  int _getCurrentRelationshipValue() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Pacar' || role == 'Tunangan' || role == 'Suami' || role == 'Istri') {
      return int.tryParse(widget.character.partner?['relationship'] ?? '50') ?? 50;
    }

    if (role == 'Kandung' && name.startsWith('Ayah')) {
      return widget.character.fatherRelationship ?? 50;
    } else if (role == 'Kandung' && name.startsWith('Ibu')) {
      return widget.character.motherRelationship ?? 50;
    } else if (role == 'Tiri' && name.startsWith('Ayah')) {
      return widget.character.stepFatherRelationship ?? 50;
    } else {
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          return int.tryParse(sib['relationship'] ?? '50') ?? 50;
        }
      }
    }
    return 50;
  }

  // Helper untuk mengupdate nilai hubungan target saat ini
  void _updateRelationship(int changeAmount) {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Pacar' || role == 'Tunangan' || role == 'Suami' || role == 'Istri') {
      if (widget.character.partner != null) {
        int currentRel = int.tryParse(widget.character.partner!['relationship'] ?? '50') ?? 50;
        widget.character.partner!['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
      }
      return;
    }

    if (role == 'Kandung' && name.startsWith('Ayah')) {
      widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else if (role == 'Kandung' && name.startsWith('Ibu')) {
      widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else if (role == 'Tiri' && name.startsWith('Ayah')) {
      widget.character.stepFatherRelationship = ((widget.character.stepFatherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else {
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          int currentRel = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          sib['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    }
  }

  void _showResultDialog(String title, String message, IconData icon, Color color, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Fungsi update state yang dikirim ke file usia
  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int age = widget.character.age;

    // --- LOGIKA PEMANGGILAN BERDASARKAN USIA ---
    List<ActionItem> actions = [];

    if (age < 3) {
      // Belum ada menu, akan menampilkan pesan "Terlalu muda"
    } else if (age >= 3 && age <= 6) {
      actions = getAge3to6Actions(
        widget.character,
        widget.targetName,
        widget.targetRole,
        _random,
        _showResultDialog,
        _updateRelationship,
        _updateState,
      );
    } else if (age >= 6 && age < 12) {
      actions = getAge6to11Actions(
        widget.character,
        widget.targetName,
        widget.targetRole,
        _random,
        _showResultDialog,
        _updateRelationship,
        _updateState,
      );
    } else {
      actions = getAge12PlusActions(
        context,
        widget.character,
        widget.targetName,
        widget.targetRole,
        age,
        _random,
        _showResultDialog,
        _updateRelationship,
        _updateState,
      );
    }

    final int relationshipVal = _getCurrentRelationshipValue();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Card Info
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          radius: 28,
                          child: const Icon(Icons.person, color: Colors.blue, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.targetName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                'Hubungan: ${widget.targetRole} | Umur: ${_getCurrentAgeValue()}',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tingkat Kepuasan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationshipVal / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationshipVal > 65 ? Colors.green : relationshipVal > 35 ? Colors.amber : Colors.red,
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$relationshipVal%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: relationshipVal > 65 ? Colors.green : relationshipVal > 35 ? Colors.amber : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
            ),
            const SizedBox(height: 12),

            // --- MENU ACTION LIST (HASIL DARI AGE FILE) ---
            Expanded(
              child: actions.isEmpty
                  ? Center(
                      child: Text(
                        'Kamu masih berusia $age tahun. Kamu terlalu muda untuk berinteraksi secara aktif.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: actions.length,
                      itemBuilder: (context, index) {
                        final action = actions[index];
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade100),
                          ),
                          child: ListTile(
                            leading: Icon(action.icon, color: action.color),
                            title: Text(action.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            onTap: action.onTap,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}