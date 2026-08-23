// lib/game/widgets/hubungan_menu/action_menu/action_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// Import logic per usia
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_base.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_3_6.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';
import 'package:bitlife/game/widgets/hubungan_menu/extended_family_view.dart';
import 'package:bitlife/game/widgets/hubungan_menu/sibling_family_view.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/threesome.dart';
import 'package:bitlife/avatar/avatar_generator.dart';

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
    final String cleanRole = role.toLowerCase();
    final String cleanName = name.toLowerCase();

    // Cek Nama Biologis & Tiri Terlebih Dahulu (Agar tidak peduli role apa pun yang di-passing)
    if (widget.character.fatherName != null &&
        (cleanName == widget.character.fatherName!.toLowerCase() ||
            cleanName.contains(widget.character.fatherName!.toLowerCase()))) {
      return widget.character.fatherAge != null
          ? '${widget.character.fatherAge} tahun'
          : 'Tidak diketahui';
    }
    if (widget.character.motherName != null &&
        (cleanName == widget.character.motherName!.toLowerCase() ||
            cleanName.contains(widget.character.motherName!.toLowerCase()))) {
      return widget.character.motherAge != null
          ? '${widget.character.motherAge} tahun'
          : 'Tidak diketahui';
    }
    if (widget.character.stepFatherName != null &&
        (cleanName == widget.character.stepFatherName!.toLowerCase() ||
            cleanName
                .contains(widget.character.stepFatherName!.toLowerCase()))) {
      return widget.character.stepFatherAge != null
          ? '${widget.character.stepFatherAge} tahun'
          : 'Tidak diketahui';
    }
    if (widget.character.stepMotherName != null &&
        (cleanName == widget.character.stepMotherName!.toLowerCase() ||
            cleanName
                .contains(widget.character.stepMotherName!.toLowerCase()))) {
      return widget.character.stepMotherAge != null
          ? '${widget.character.stepMotherAge} tahun'
          : 'Tidak diketahui';
    }

    // Cek berdasarkan Role
    if (cleanRole.contains('mantan pacar')) {
      for (var ex in widget.character.exPartners) {
        if (ex['name'] == name) {
          return '${ex['age']} tahun';
        }
      }
    }

    if (cleanRole.contains('pacar') ||
        cleanRole.contains('tunangan') ||
        cleanRole.contains('suami') ||
        cleanRole.contains('istri')) {
      if (widget.character.partner != null &&
          name.contains(widget.character.partner!['name'] ?? '')) {
        return '${widget.character.partner!['age']} tahun';
      }
      if (widget.character.secondPartner != null &&
          name.contains(widget.character.secondPartner!['name'] ?? '')) {
        return '${widget.character.secondPartner!['age']} tahun';
      }
      if (widget.character.thirdPartner != null &&
          name.contains(widget.character.thirdPartner!['name'] ?? '')) {
        return '${widget.character.thirdPartner!['age']} tahun';
      }
      if (widget.character.fourthPartner != null &&
          name.contains(widget.character.fourthPartner!['name'] ?? '')) {
        return '${widget.character.fourthPartner!['age']} tahun';
      }
      if (widget.character.fifthPartner != null &&
          name.contains(widget.character.fifthPartner!['name'] ?? '')) {
        return '${widget.character.fifthPartner!['age']} tahun';
      }
      for (var ex in widget.character.exPartners) {
        if (name.contains(ex['name'] ?? '')) {
          return '${ex['age']} tahun';
        }
      }
      for (var cm in widget.character.classmates) {
        if (name.contains(cm['name'] ?? '')) {
          return '${cm['age']} tahun';
        }
      }
      return 'Tidak diketahui';
    }

    if (cleanRole.contains('mertua')) {
      if (name.startsWith('Ayah Mertua') || cleanRole.contains('ayah')) {
        return widget.character.fatherInLawAge != null
            ? '${widget.character.fatherInLawAge} tahun'
            : 'Tidak diketahui';
      } else {
        return widget.character.motherInLawAge != null
            ? '${widget.character.motherInLawAge} tahun'
            : 'Tidak diketahui';
      }
    }

    if (cleanRole.contains('ayah') && !cleanRole.contains('tiri')) {
      return widget.character.fatherAge != null
          ? '${widget.character.fatherAge} tahun'
          : 'Tidak diketahui';
    }
    if (cleanRole.contains('ibu') && !cleanRole.contains('tiri')) {
      return widget.character.motherAge != null
          ? '${widget.character.motherAge} tahun'
          : 'Tidak diketahui';
    }

    if (cleanRole == 'kandung' && name.startsWith('Ayah')) {
      return widget.character.fatherAge != null
          ? '${widget.character.fatherAge} tahun'
          : 'Tidak diketahui';
    } else if (cleanRole == 'kandung' && name.startsWith('Ibu')) {
      return widget.character.motherAge != null
          ? '${widget.character.motherAge} tahun'
          : 'Tidak diketahui';
    } else if (cleanRole == 'tiri' && name.startsWith('Ayah')) {
      return widget.character.stepFatherAge != null
          ? '${widget.character.stepFatherAge} tahun'
          : 'Tidak diketahui';
    } else if (cleanRole == 'tiri' && name.startsWith('Ibu')) {
      return widget.character.stepMotherAge != null
          ? '${widget.character.stepMotherAge} tahun'
          : 'Tidak diketahui';
    } else if (cleanRole == 'cerai' && name.startsWith('Ayah')) {
      return widget.character.fatherAge != null
          ? '${widget.character.fatherAge} tahun'
          : 'Tidak diketahui';
    } else if (cleanRole == 'cerai' && name.startsWith('Ibu')) {
      return widget.character.motherAge != null
          ? '${widget.character.motherAge} tahun'
          : 'Tidak diketahui';
    } else if (cleanRole == 'laki-laki' || cleanRole == 'perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        final String cleanChildName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanChildName) {
          int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
          return '$childAge tahun';
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == name ||
            (ext['name'] != null && name.contains(ext['name']!))) {
          int extAge = int.tryParse(ext['age'] ?? '0') ?? 0;
          return extAge < 0 ? 'Belum Lahir (Dalam Kandungan)' : '$extAge tahun';
        }
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name || sib['name'] == name) {
          int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
          return sibAge < 0 ? 'Belum Lahir (Dalam Kandungan)' : '$sibAge tahun';
        }
      }
      for (var cm in widget.character.classmates) {
        final String expectedLabel = '${cm['name']} (Teman Sekelas)';
        if (expectedLabel == name || cm['name'] == name) {
          int cmAge = int.tryParse(cm['age'] ?? '0') ?? 0;
          return '$cmAge tahun';
        }
      }
    }
    return 'Tidak diketahui';
  }

  // Helper untuk mendapatkan nama asli target (tanpa prefiks peran seperti Ayah, Ibu, dll)
  String _getPlainTargetName() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Mantan Pacar') {
      for (var ex in widget.character.exPartners) {
        if (name.contains(ex['name'] ?? '')) {
          return ex['name']!;
        }
      }
    }

    if (role == 'Pacar' ||
        role == 'Tunangan' ||
        role == 'Suami' ||
        role == 'Istri' ||
        role.startsWith('Pacar')) {
      if (widget.character.partner != null &&
          name.contains(widget.character.partner!['name'] ?? '')) {
        return widget.character.partner!['name']!;
      }
      if (widget.character.secondPartner != null &&
          name.contains(widget.character.secondPartner!['name'] ?? '')) {
        return widget.character.secondPartner!['name']!;
      }
      if (widget.character.thirdPartner != null &&
          name.contains(widget.character.thirdPartner!['name'] ?? '')) {
        return widget.character.thirdPartner!['name']!;
      }
      if (widget.character.fourthPartner != null &&
          name.contains(widget.character.fourthPartner!['name'] ?? '')) {
        return widget.character.fourthPartner!['name']!;
      }
      if (widget.character.fifthPartner != null &&
          name.contains(widget.character.fifthPartner!['name'] ?? '')) {
        return widget.character.fifthPartner!['name']!;
      }
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) {
        return widget.character.fatherInLawName ?? name;
      } else {
        return widget.character.motherInLawName ?? name;
      }
    }

    final String nameLower = name.toLowerCase();
    if (nameLower.contains('ayah') && !nameLower.contains('tiri') && !nameLower.contains('mertua')) {
      return widget.character.fatherName ?? name;
    } else if (nameLower.contains('ibu') && !nameLower.contains('tiri') && !nameLower.contains('mertua')) {
      return widget.character.motherName ?? name;
    } else if (nameLower.contains('ayah tiri')) {
      return widget.character.stepFatherName ?? name;
    } else if (nameLower.contains('ibu tiri')) {
      return widget.character.stepMotherName ?? name;
    } else if (role == 'Laki-laki' || role == 'Perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        final String cleanName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanName) {
          return childName;
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (name.contains(ext['name'] ?? '')) {
          return ext['name']!;
        }
      }
      // Cek di siblings
      for (var sib in widget.character.siblings) {
        final String sibName = sib['name'] ?? '';
        if (sibName.isNotEmpty && name.contains(sibName)) {
          return sibName;
        }
      }
    }
    return name.replaceAll(' (Wafat)', '').trim();
  }

  // Helper untuk mengambil nilai hubungan target saat ini
  int _getCurrentRelationshipValue() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Mantan Pacar') {
      for (var ex in widget.character.exPartners) {
        if (ex['name'] == name) {
          return int.tryParse(ex['relationship'] ?? '50') ?? 50;
        }
      }
      return 30;
    }

    if ((role == 'Pacar' ||
            role == 'Tunangan' ||
            role == 'Suami' ||
            role == 'Istri' ||
            role.contains('Pacar')) &&
        role != 'Mantan Pacar') {
      final String plainName = _getPlainTargetName().toLowerCase();
      // SUMBER TUNGGAL: Jika pacar adalah Ibu kandung, gunakan motherRelationship
      if (widget.character.motherName != null &&
          widget.character.motherName!.toLowerCase() == plainName) {
        final int val = widget.character.motherRelationship ?? 50;
        // Sinkronkan partner map agar konsisten
        if (widget.character.partner != null &&
            widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
          widget.character.partner!['relationship'] = val.toString();
        }
        if (widget.character.secondPartner != null &&
            widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
          widget.character.secondPartner!['relationship'] = val.toString();
        }
        return val;
      }
      // SUMBER TUNGGAL: Jika pacar adalah Ayah kandung, gunakan fatherRelationship
      if (widget.character.fatherName != null &&
          widget.character.fatherName!.toLowerCase() == plainName) {
        final int val = widget.character.fatherRelationship ?? 50;
        if (widget.character.partner != null &&
            widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
          widget.character.partner!['relationship'] = val.toString();
        }
        if (widget.character.secondPartner != null &&
            widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
          widget.character.secondPartner!['relationship'] = val.toString();
        }
        return val;
      }
      // 1. Cari di classmates
      for (var cm in widget.character.classmates) {
        if (cm['name']!.toLowerCase() == plainName) {
          final int val = int.tryParse(cm['relationship'] ?? '50') ?? 50;
          if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
            widget.character.partner!['relationship'] = val.toString();
          }
          if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
            widget.character.secondPartner!['relationship'] = val.toString();
          }
          return val;
        }
      }
      // 2. Cari di univClassmates
      for (var cm in widget.character.univClassmates) {
        if (cm['name']!.toLowerCase() == plainName) {
          final int val = int.tryParse(cm['relationship'] ?? '50') ?? 50;
          if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
            widget.character.partner!['relationship'] = val.toString();
          }
          if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
            widget.character.secondPartner!['relationship'] = val.toString();
          }
          return val;
        }
      }
      // 3. Cari di coworkers
      for (var cw in widget.character.coworkers) {
        if (cw['name']!.toLowerCase() == plainName) {
          final int val = int.tryParse(cw['relationship'] ?? '50') ?? 50;
          if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
            widget.character.partner!['relationship'] = val.toString();
          }
          if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
            widget.character.secondPartner!['relationship'] = val.toString();
          }
          return val;
        }
      }

      if (widget.character.partner != null &&
          widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
        return int.tryParse(
                widget.character.partner!['relationship'] ?? '50') ??
            50;
      }
      if (widget.character.secondPartner != null &&
          widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
        return int.tryParse(
                widget.character.secondPartner!['relationship'] ?? '50') ??
            50;
      }
      // Check exPartners fallback
      for (var ex in widget.character.exPartners) {
        if (ex['name'] == name) {
          return int.tryParse(ex['relationship'] ?? '50') ?? 50;
        }
      }
      // Check classmates fallback
      for (var cm in widget.character.classmates) {
        if (cm['name'] == name) {
          return int.tryParse(cm['relationship'] ?? '50') ?? 50;
        }
      }
      return int.tryParse(widget.character.partner?['relationship'] ?? '50') ??
          50;
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) {
        return widget.character.fatherInLawRelationship ?? 50;
      } else {
        return widget.character.motherInLawRelationship ?? 50;
      }
    }

    final String nameLower = name.toLowerCase();
    if (nameLower.contains('ayah') && !nameLower.contains('tiri') && !nameLower.contains('mertua')) {
      final int val = widget.character.fatherRelationship ?? 50;
      // Sinkronkan partner map jika Ayah juga pasangan
      final String cleanF = (widget.character.fatherName ?? '').toLowerCase();
      if (cleanF.isNotEmpty) {
        if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(cleanF)) {
          widget.character.partner!['relationship'] = val.toString();
        }
        if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(cleanF)) {
          widget.character.secondPartner!['relationship'] = val.toString();
        }
      }
      return val;
    } else if (nameLower.contains('ibu') && !nameLower.contains('tiri') && !nameLower.contains('mertua')) {
      final int val = widget.character.motherRelationship ?? 50;
      // Sinkronkan partner map jika Ibu juga pasangan
      final String cleanM = (widget.character.motherName ?? '').toLowerCase();
      if (cleanM.isNotEmpty) {
        if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(cleanM)) {
          widget.character.partner!['relationship'] = val.toString();
        }
        if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(cleanM)) {
          widget.character.secondPartner!['relationship'] = val.toString();
        }
      }
      return val;
    } else if (nameLower.contains('ayah tiri')) {
      return widget.character.stepFatherRelationship ?? 50;
    } else if (nameLower.contains('ibu tiri')) {
      return widget.character.stepMotherRelationship ?? 50;
    } else if (role == 'Laki-laki' || role == 'Perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        final String cleanName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanName) {
          return int.tryParse(child['relationship'] ?? '50') ?? 50;
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == name) {
          return int.tryParse(ext['relationship'] ?? '50') ?? 50;
        }
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          return int.tryParse(sib['relationship'] ?? '50') ?? 50;
        }
      }
      for (var cm in widget.character.classmates) {
        final String expectedLabel = '${cm['name']} (Teman Sekelas)';
        if (expectedLabel == name || cm['name'] == name) {
          return int.tryParse(cm['relationship'] ?? '50') ?? 50;
        }
      }
    }
    return 50;
  }

  // Helper untuk mengupdate nilai hubungan target saat ini
  void _updateRelationship(int changeAmount) {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Mantan Pacar') {
      for (var ex in widget.character.exPartners) {
        if (ex['name'] == name) {
          int currentRel = int.tryParse(ex['relationship'] ?? '50') ?? 50;
          ex['relationship'] =
              (currentRel + changeAmount).clamp(0, 100).toString();
          return;
        }
      }
    }

    if ((role == 'Pacar' ||
            role == 'Tunangan' ||
            role == 'Suami' ||
            role == 'Istri' ||
            role.contains('Pacar')) &&
        role != 'Mantan Pacar') {
      final String plainTargetName = _getPlainTargetName().toLowerCase();
      // SYNC: Jika pacar yang diupdate adalah Ibu kandung
      if (widget.character.motherName != null && widget.character.motherName!.toLowerCase() == plainTargetName) {
        widget.character.motherRelationship =
            ((widget.character.motherRelationship ?? 50) + changeAmount)
                .clamp(0, 100);
      }
      // SYNC: Jika pacar yang diupdate adalah Ayah kandung
      if (widget.character.fatherName != null && widget.character.fatherName!.toLowerCase() == plainTargetName) {
        widget.character.fatherRelationship =
            ((widget.character.fatherRelationship ?? 50) + changeAmount)
                .clamp(0, 100);
      }

      if (widget.character.partner != null &&
          widget.character.partner!['name']!.toLowerCase().contains(plainTargetName)) {
        int currentRel =
            int.tryParse(widget.character.partner!['relationship'] ?? '50') ??
                50;
        widget.character.partner!['relationship'] =
            (currentRel + changeAmount).clamp(0, 100).toString();
      } else if (widget.character.secondPartner != null &&
          widget.character.secondPartner!['name']!.toLowerCase().contains(plainTargetName)) {
        int currentRel = int.tryParse(
                widget.character.secondPartner!['relationship'] ?? '50') ??
            50;
        widget.character.secondPartner!['relationship'] =
            (currentRel + changeAmount).clamp(0, 100).toString();
      }
      return;
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) {
        widget.character.fatherInLawRelationship =
            ((widget.character.fatherInLawRelationship ?? 50) + changeAmount)
                .clamp(0, 100);
      } else {
        widget.character.motherInLawRelationship =
            ((widget.character.motherInLawRelationship ?? 50) + changeAmount)
                .clamp(0, 100);
      }
      return;
    }

    final String nameLower = name.toLowerCase();
    if (nameLower.contains('ayah') && !nameLower.contains('tiri') && !nameLower.contains('mertua')) {
      widget.character.fatherRelationship =
          ((widget.character.fatherRelationship ?? 50) + changeAmount)
              .clamp(0, 100);
      // SYNC: Update matching partner map
      final String cleanF = (widget.character.fatherName ?? '').toLowerCase();
      if (cleanF.isNotEmpty) {
        if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(cleanF)) {
          widget.character.partner!['relationship'] = widget.character.fatherRelationship.toString();
        }
        if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(cleanF)) {
          widget.character.secondPartner!['relationship'] = widget.character.fatherRelationship.toString();
        }
      }
    } else if (nameLower.contains('ibu') && !nameLower.contains('tiri') && !nameLower.contains('mertua')) {
      widget.character.motherRelationship =
          ((widget.character.motherRelationship ?? 50) + changeAmount)
              .clamp(0, 100);
      // SYNC: Update matching partner map
      final String cleanM = (widget.character.motherName ?? '').toLowerCase();
      if (cleanM.isNotEmpty) {
        if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(cleanM)) {
          widget.character.partner!['relationship'] = widget.character.motherRelationship.toString();
        }
        if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(cleanM)) {
          widget.character.secondPartner!['relationship'] = widget.character.motherRelationship.toString();
        }
      }
    } else if (nameLower.contains('ayah tiri')) {
      widget.character.stepFatherRelationship =
          ((widget.character.stepFatherRelationship ?? 50) + changeAmount)
              .clamp(0, 100);
    } else if (nameLower.contains('ibu tiri')) {
      widget.character.stepMotherRelationship =
          ((widget.character.stepMotherRelationship ?? 50) + changeAmount)
              .clamp(0, 100);
    } else if (role == 'Laki-laki' || role == 'Perempuan') {
      // Ini adalah anak
      for (var child in widget.character.children) {
        final String childName = child['name'] ?? '';
        final String cleanName = name.replaceAll(' (Wafat)', '').trim();
        if (childName == cleanName) {
          int currentRel = int.tryParse(child['relationship'] ?? '50') ?? 50;
          child['relationship'] =
              (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    } else {
      // Cek di extended family
      for (var ext in widget.character.extendedFamily) {
        if (ext['name'] == name) {
          int currentRel = int.tryParse(ext['relationship'] ?? '50') ?? 50;
          ext['relationship'] =
              (currentRel + changeAmount).clamp(0, 100).toString();
          return;
        }
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == name) {
          int currentRel = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          sib['relationship'] =
              (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
      for (var cm in widget.character.classmates) {
        final String expectedLabel = '${cm['name']} (Teman Sekelas)';
        if (expectedLabel == name || cm['name'] == name) {
          int currentRel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
          cm['relationship'] =
              (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    }
    
    // Sinkronkan nilai hubungan terbaru ke semua list sosial (classmate, partner, dll)
    final int updatedVal = _getCurrentRelationshipValue();
    widget.character.updateRelationshipValue(name, updatedVal);
  }

  void _showResultDialog(String title, String message, IconData icon,
      Color color, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child:
                const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _getTargetGender() {
    final String role = widget.targetRole;
    final String name = widget.targetName;

    if (role == 'Mantan Pacar') {
      for (var ex in widget.character.exPartners) {
        if (ex['name'] == name) {
          return ex['gender'] ?? 'Perempuan';
        }
      }
    }

    if (role == 'Pacar' ||
        role == 'Tunangan' ||
        role == 'Suami' ||
        role == 'Istri' ||
        role.startsWith('Pacar')) {
      if (widget.character.partner != null &&
          name.contains(widget.character.partner!['name'] ?? '')) {
        return widget.character.partner!['gender'] ?? 'Perempuan';
      }
      if (widget.character.secondPartner != null &&
          name.contains(widget.character.secondPartner!['name'] ?? '')) {
        return widget.character.secondPartner!['gender'] ?? 'Perempuan';
      }
      if (widget.character.thirdPartner != null &&
          name.contains(widget.character.thirdPartner!['name'] ?? '')) {
        return widget.character.thirdPartner!['gender'] ?? 'Perempuan';
      }
      if (widget.character.fourthPartner != null &&
          name.contains(widget.character.fourthPartner!['name'] ?? '')) {
        return widget.character.fourthPartner!['gender'] ?? 'Perempuan';
      }
      if (widget.character.fifthPartner != null &&
          name.contains(widget.character.fifthPartner!['name'] ?? '')) {
        return widget.character.fifthPartner!['gender'] ?? 'Perempuan';
      }
      return widget.character.partner != null
          ? widget.character.partner!['gender'] ?? 'Perempuan'
          : 'Perempuan';
    }

    if (role == 'Mertua') {
      if (name.startsWith('Ayah Mertua')) return 'Laki-laki';
      return 'Perempuan';
    }

    if (name.startsWith('Ayah')) return 'Laki-laki';
    if (name.startsWith('Ibu')) return 'Perempuan';

    if (role == 'Laki-laki' || role == 'Perempuan') {
      return role;
    }

    // Cek di siblings
    for (var sib in widget.character.siblings) {
      final String expectedLabel = '${sib['name']} (${sib['relation']})';
      if (expectedLabel == name) {
        return sib['gender'] ?? 'Laki-laki';
      }
    }

    // Cek di extended family
    for (var ext in widget.character.extendedFamily) {
      if (ext['name'] == name) {
        return ext['gender'] ?? 'Laki-laki';
      }
    }

    return 'Laki-laki'; // fallback
  }

  int _getFertilityRate(int age, String gender) {
    return (HubunganIntimLogic.getFertilityRate(age, gender) * 100).toInt();
  }

  // Fungsi update state yang dikirim ke file usia
  void _updateState() {
    setState(() {});
  }

  String _getDetailedRelationLabel() {
    final String role = widget.targetRole;
    final String name = widget.targetName.toLowerCase();

    if (role == 'Kandung') {
      if (name.startsWith('ayah')) {
        return 'Ayah Kandung';
      } else if (name.startsWith('ibu')) {
        return 'Ibu Kandung';
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel =
            '${sib['name']} (${sib['relation']})'.toLowerCase();
        if (expectedLabel == name) {
          return '${sib['relation']} Kandung';
        }
      }
      return 'Keluarga Kandung';
    } else if (role == 'Tiri') {
      if (name.startsWith('ayah')) {
        return 'Ayah Tiri';
      } else if (name.startsWith('ibu')) {
        return 'Ibu Tiri';
      }
      for (var sib in widget.character.siblings) {
        final String expectedLabel =
            '${sib['name']} (${sib['relation']})'.toLowerCase();
        if (expectedLabel == name) {
          return '${sib['relation']} Tiri';
        }
      }
      return 'Keluarga Tiri';
    } else if (role == 'Cerai') {
      if (name.startsWith('ayah')) {
        return 'Ayah Kandung (Cerai)';
      } else if (name.startsWith('ibu')) {
        return 'Ibu Kandung (Cerai)';
      }
    }

    return role;
  }

  @override
  Widget build(BuildContext context) {
    final int age = widget.character.age;
    // Tentukan umur target. Jika target memiliki umur spesifik (misal anak), gunakan itu.
    // Jika tidak diketahui atau belum lahir, fallback ke 0.
    final String ageString = _getCurrentAgeValue();
    int targetAge = 0;
    if (ageString.contains('tahun')) {
      targetAge = int.tryParse(ageString.replaceAll(' tahun', '').trim()) ?? 0;
    }

    // --- LOGIKA PEMANGGILAN BERDASARKAN USIA TARGET ---
    List<ActionItem> actions = [];

    // Gunakan usia terkecil antara usia player dengan usia target untuk menentukan kategori interaksi.
    // Hal ini agar anak kecil (misal 5 tahun) tidak bisa mengajak pacaran atau bercinta dengan orang dewasa (misal kakaknya yang berumur 19 tahun).
    final int minAge = age < targetAge ? age : targetAge;
    final bool isChild =
        widget.targetRole == 'Laki-laki' || widget.targetRole == 'Perempuan';

    // Cek apakah target SUDAH menjadi pacar aktif
    bool isActivePartner =
        widget.character.isAnyPartnerNameMatching(widget.targetName);
    if (!isActivePartner) {
      if (widget.character.partner != null &&
          (widget.character.partner!['name'] == widget.targetName ||
              widget.targetName
                  .contains(widget.character.partner!['name'] ?? '___'))) {
        isActivePartner = true;
      } else if (widget.character.secondPartner != null &&
          (widget.character.secondPartner!['name'] == widget.targetName ||
              widget.targetName.contains(
                  widget.character.secondPartner!['name'] ?? '___'))) {
        isActivePartner = true;
      } else if (widget.character.thirdPartner != null &&
          (widget.character.thirdPartner!['name'] == widget.targetName ||
              widget.targetName
                  .contains(widget.character.thirdPartner!['name'] ?? '___'))) {
        isActivePartner = true;
      } else if (widget.character.fourthPartner != null &&
          (widget.character.fourthPartner!['name'] == widget.targetName ||
              widget.targetName.contains(
                  widget.character.fourthPartner!['name'] ?? '___'))) {
        isActivePartner = true;
      } else if (widget.character.fifthPartner != null &&
          (widget.character.fifthPartner!['name'] == widget.targetName ||
              widget.targetName
                  .contains(widget.character.fifthPartner!['name'] ?? '___'))) {
        isActivePartner = true;
      }
    }

    // Jika sudah pacaran: langsung tampilkan Make Love tanpa batasan usia
    if (isActivePartner &&
        widget.targetRole != 'Laki-laki' &&
        widget.targetRole != 'Perempuan') {
      actions.add(ActionItem(
        label: 'Bercinta / Make Love',
        icon: Icons.favorite,
        color: Colors.pink,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BercintaScreen(
                character: widget.character,
                targetName: widget.targetName,
                targetRole: widget.targetRole,
                onActionComplete: () {
                  _updateState();
                },
              ),
            ),
          );
        },
      ));
    }

    // Define partner-specific actions
    final ActionItem menggodaAction = ActionItem(
      label: 'Menggoda',
      icon: Icons.favorite_border,
      color: Colors.pink,
      onTap: () {
        final int chance = _random.nextInt(100);
        if (chance < 30) {
          final change = 5 + _random.nextInt(11);
          _updateRelationship(-change);
          widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
          _updateState();
          _showResultDialog(
            'Gagal Menggoda 💔',
            'Kamu mencoba menggoda ${widget.targetName} tetapi dia merasa kurang nyaman saat ini. Hubungan menurun!',
            Icons.sentiment_very_dissatisfied,
            Colors.red,
            () {},
          );
        } else {
          final change = 5 + _random.nextInt(11);
          _updateRelationship(change);
          widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
          _updateState();
          _showResultDialog(
            'Menggoda Berhasil 💖',
            'Kamu menggoda ${widget.targetName} dengan mesra dan dia tersipu malu! Hubungan meningkat!',
            Icons.favorite,
            Colors.pink,
            () {},
          );
        }
      },
    );

    final ActionItem bertingkahLakuAction = ActionItem(
      label: 'Bertingkah Laku',
      icon: Icons.emoji_people,
      color: Colors.blueAccent,
      onTap: () {
        final change = 3 + _random.nextInt(8);
        _updateRelationship(change);
        widget.character.karma = (widget.character.karma + 3).clamp(0, 100);
        _updateState();
        _showResultDialog(
          'Bertingkah Laku Baik',
          'Kamu menunjukkan sikap manis dan peduli kepada ${widget.targetName}. Dia sangat menghargai perilakumu!',
          Icons.emoji_people,
          Colors.blueAccent,
          () {},
        );
      },
    );

    if ((widget.targetRole == 'Pacar' ||
            widget.targetRole == 'Pacar (Rahasia)') &&
        age < 12) {
      final List<ActionItem> standardActions = getAge6to11Actions(
        context,
        widget.character,
        widget.targetName,
        widget.targetRole,
        _random,
        _showResultDialog,
        _updateRelationship,
        _updateState,
      );
      actions = standardActions.where((action) {
        final label = action.label.toLowerCase();
        return label == 'pujian' ||
            label == 'hadiah' ||
            label == 'menyinggung' ||
            label == 'pergi ke bioskop bersama' ||
            label == 'habiskan waktu bersama' ||
            label == 'minta barang' ||
            label == 'percakapan';
      }).toList();
    } else if (isChild && targetAge < 12) {
      // Jika target anak kita di bawah 12 tahun, tampilkan menu khusus orang tua mengasuh anak:
      // - Beri Uang Jajan (Minta uang dari sisi anak, di sini orang tua yang memberi uang)
      // - Beri Hadiah
      // - Ajak Bicara / Mengobrol
      // - Beri Pelukan
      // - Ajak Jalan-jalan / Bermain
      // - Disiplinkan (jika nakal)
      actions = [
        ActionItem(
          label: 'Beri Pelukan',
          icon: Icons.face,
          color: Colors.pinkAccent,
          onTap: () {
            int relBonus = _random.nextInt(6) + 10;
            _showResultDialog(
              'Pelukan Hangat',
              'Kamu memeluk erat ${widget.targetName}. Anakmu merasa sangat disayangi! (+$relBonus% hubungan)',
              Icons.face,
              Colors.pinkAccent,
              () {
                widget.character.happiness =
                    (widget.character.happiness + 5).clamp(0, 100);
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
        ActionItem(
          label: 'Bercakap-cakap',
          icon: Icons.chat,
          color: Colors.teal,
          onTap: () {
            int relBonus = _random.nextInt(5) + 5;
            _showResultDialog(
              'Mengobrol dengan Anak',
              'Kamu menghabiskan waktu mengobrol dan mendengarkan cerita ${widget.targetName}. (+$relBonus% hubungan)',
              Icons.chat,
              Colors.teal,
              () {
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
        ActionItem(
          label: 'Beri Uang Jajan',
          icon: Icons.monetization_on,
          color: Colors.green,
          onTap: () {
            if (widget.character.money < 10) {
              _showResultDialog(
                'Uang Tidak Cukup',
                'Kamu tidak memiliki cukup uang untuk memberikan uang jajan (\$10).',
                Icons.money_off,
                Colors.red,
                () {},
              );
            } else {
              int relBonus = _random.nextInt(6) + 10;
              _showResultDialog(
                'Beri Uang Jajan',
                'Kamu memberikan uang jajan sebesar \$10 kepada ${widget.targetName}. Dia sangat gembira! (+$relBonus% hubungan)',
                Icons.monetization_on,
                Colors.green,
                () {
                  widget.character.money -= 10;
                  _updateRelationship(relBonus);
                  _updateState();
                },
              );
            }
          },
        ),
        ActionItem(
          label: 'Beri Hadiah Mainan',
          icon: Icons.toys,
          color: Colors.orange,
          onTap: () {
            if (widget.character.money < 30) {
              _showResultDialog(
                'Uang Tidak Cukup',
                'Kamu tidak memiliki cukup uang untuk membelikan mainan (\$30).',
                Icons.money_off,
                Colors.red,
                () {},
              );
            } else {
              int relBonus = _random.nextInt(11) + 15;
              _showResultDialog(
                'Hadiah Mainan',
                'Kamu membelikan mainan baru seharga \$30 untuk ${widget.targetName}. Anakmu langsung melompat kegirangan! (+$relBonus% hubungan)',
                Icons.toys,
                Colors.orange,
                () {
                  widget.character.money -= 30;
                  _updateRelationship(relBonus);
                  _updateState();
                },
              );
            }
          },
        ),
        ActionItem(
          label: 'Ajak Bermain ke Taman',
          icon: Icons.park,
          color: Colors.deepOrange,
          onTap: () {
            int relBonus = _random.nextInt(6) + 12;
            _showResultDialog(
              'Bermain di Taman',
              'Kamu mengajak ${widget.targetName} bermain ayunan dan berlarian di taman. Waktu yang sangat menyenangkan! (+$relBonus% hubungan)',
              Icons.park,
              Colors.green,
              () {
                widget.character.happiness =
                    (widget.character.happiness + 10).clamp(0, 100);
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
        ActionItem(
          label: 'Puji Anak',
          icon: Icons.thumb_up,
          color: Colors.blue,
          onTap: () {
            int relBonus = _random.nextInt(5) + 8;
            _showResultDialog(
              'Pujian Orang Tua',
              'Kamu memuji kepintaran dan tingkah laku baik ${widget.targetName}. (+$relBonus% hubungan)',
              Icons.thumb_up,
              Colors.blue,
              () {
                _updateRelationship(relBonus);
                _updateState();
              },
            );
          },
        ),
      ];
    } else {
      // Gunakan logika standar berdasarkan usia terkecil (minAge)
      if (minAge < 3) {
        // Belum ada menu, menampilkan pesan "Terlalu muda"
        final String cleanRole = widget.targetRole.toLowerCase();
        final String cleanName = widget.targetName.toLowerCase();
        final bool isSibling = widget.character.siblings.any((sib) =>
                '${sib['name']} (${sib['relation']})'.toLowerCase() ==
                    cleanName ||
                sib['name']!.toLowerCase() == cleanName) ||
            cleanRole.contains('saudara') ||
            cleanRole.contains('kandung') ||
            cleanRole.contains('tiri') ||
            cleanName.contains('kakak') ||
            cleanName.contains('adik');

        if (age >= 5 && targetAge >= 1 && targetAge <= 2 && isSibling) {
          actions = [
            ActionItem(
              label: 'Bermain Bersama',
              icon: Icons.people,
              color: Colors.blueAccent,
              onTap: () {
                int relBonus = _random.nextInt(5) + 8;
                _showResultDialog(
                  'Bermain Bersama',
                  'Kamu bermain bersama adikmu, ${widget.targetName}. Sangat menyenangkan! (+$relBonus% hubungan)',
                  Icons.people,
                  Colors.blueAccent,
                  () {
                    widget.character.happiness =
                        (widget.character.happiness + 12).clamp(0, 100);
                    _updateRelationship(relBonus);
                    _updateState();
                  },
                );
              },
            )
          ];
        }
      } else if (minAge >= 3 && minAge < 6) {
        actions = getAge3to6Actions(
          widget.character,
          widget.targetName,
          widget.targetRole,
          _random,
          _showResultDialog,
          _updateRelationship,
          _updateState,
        );
      } else if (minAge >= 6 && minAge < 12) {
        actions = getAge6to11Actions(
          context, // ← tambahkan context di sini
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
          minAge,
          _random,
          _showResultDialog,
          _updateRelationship,
          _updateState,
        );
      }
    }

    if (isActivePartner) {
      bool hasMenggoda = actions.any((act) => act.label == 'Menggoda');
      if (!hasMenggoda) {
        actions.add(menggodaAction);
      }
      bool hasBertingkah = actions.any((act) => act.label == 'Bertingkah Laku');
      if (!hasBertingkah) {
        actions.add(bertingkahLakuAction);
      }
    }

    // --- TAMBAHAN LOGIKA KHUSUS USIA >= 7 TAHUN UNTUK ADIK/KAKAK DENGAN LAWAN JENIS ---
    if (age >= 7) {
      final String myGender = widget.character.gender.trim().toLowerCase();
      final String cleanName = widget.targetName.toLowerCase();
      final String cleanRole = widget.targetRole.toLowerCase();

      bool isSibling = cleanRole.contains('saudara') ||
          cleanRole.contains('kandung') ||
          cleanName.contains('kakak') ||
          cleanName.contains('adik');

      bool existsInSiblings = widget.character.siblings.any((sib) =>
          '${sib['name']} (${sib['relation']})'.toLowerCase() == cleanName);

      if (isSibling && existsInSiblings) {
        String targetGender = 'laki-laki';
        for (var sib in widget.character.siblings) {
          final String expectedLabel =
              '${sib['name']} (${sib['relation']})'.toLowerCase();
          if (expectedLabel == cleanName) {
            targetGender = (sib['gender'] ?? 'Laki-laki').toLowerCase();
            break;
          }
        }

        bool genderMatch =
            (myGender == 'laki-laki' && targetGender == 'perempuan') ||
                (myGender == 'perempuan' && targetGender == 'laki-laki');

        if (genderMatch) {
          bool hasBercinta = actions.any((act) =>
              act.label.contains('Bercinta') ||
              act.label.contains('Make Love'));
          if (!hasBercinta) {
            actions.add(ActionItem(
              label: 'Bercinta / Make Love',
              icon: Icons.favorite,
              color: Colors.pink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BercintaScreen(
                      character: widget.character,
                      targetName: widget.targetName,
                      targetRole: widget.targetRole,
                      onActionComplete: () {
                        _updateState();
                      },
                    ),
                  ),
                );
              },
            ));
          }

          bool isAlreadyPartner = widget.character.partner != null &&
              widget.character.partner!['name'] == widget.targetName;
          bool isAlreadySecondPartner =
              widget.character.secondPartner != null &&
                  widget.character.secondPartner!['name'] == widget.targetName;
          bool isPartnerRole = widget.targetRole == 'Pacar' ||
              widget.targetRole == 'Tunangan' ||
              widget.targetRole == 'Suami' ||
              widget.targetRole == 'Istri';

          bool hasPacaran = actions.any((act) => act.label.contains('Pacaran'));
          if (!hasPacaran &&
              !isAlreadyPartner &&
              !isAlreadySecondPartner &&
              !isPartnerRole) {
            final bool hasExistingPartner = widget.character.partner != null;
            actions.add(ActionItem(
              label: hasExistingPartner
                  ? 'Ajak Pacaran (Selingkuh?)'
                  : 'Ajak Pacaran',
              icon: hasExistingPartner
                  ? Icons.heart_broken
                  : Icons.favorite_border,
              color: hasExistingPartner ? Colors.deepOrange : Colors.redAccent,
              onTap: () {
                // Logika berdasarkan gender player dan sibling
                final String myGen =
                    widget.character.gender.trim().toLowerCase();
                int successChance;
                if (myGen == 'perempuan' && targetGender == 'laki-laki') {
                  // Player perempuan, target kakak laki = 35%, adik laki = 40%
                  successChance = cleanName.contains('kakak') ? 35 : 40;
                } else {
                  // Player laki-laki (logika lama)
                  successChance = cleanName.contains('kakak') ? 10 : 40;
                }
                bool accepted = _random.nextInt(100) < successChance;

                if (accepted) {
                  int actualTargetAge = 7;
                  for (var sib in widget.character.siblings) {
                    final String expectedLabel =
                        '${sib['name']} (${sib['relation']})';
                    if (expectedLabel == widget.targetName) {
                      actualTargetAge = int.tryParse(sib['age'] ?? '7') ?? 7;
                      break;
                    }
                  }

                  _showResultDialog(
                      'Pacaran Baru! ❤️',
                      'Ajakan pacaranmu diterima oleh ${widget.targetName}! Sekarang kalian adalah sepasang kekasih.',
                      Icons.favorite,
                      Colors.pinkAccent, () {
                    final String? familySkinColor = widget.character.getFamilyMemberSkinColor(widget.targetName);
                    final partnerMap = {
                      'name': widget.targetName,
                      'relation': 'Pacar',
                      'gender': targetGender == 'perempuan'
                          ? 'Perempuan'
                          : 'Laki-laki',
                      'age': actualTargetAge.toString(),
                      'relationship': '80',
                      'isDeceased': 'false',
                      if (familySkinColor != null) 'skinColor': familySkinColor,
                    };

                    if (widget.character.partner == null) {
                      widget.character.partner = partnerMap;
                    } else {
                      widget.character.secondPartner = partnerMap;
                    }

                    _updateRelationship(20);
                    _updateState();
                  });
                } else {
                  _showResultDialog(
                      'Ajakan Ditolak',
                      '${widget.targetName} menolak ajakanmu untuk berpacaran. Hubungan kalian menjadi sedikit canggung (-10% hubungan).',
                      Icons.block,
                      Colors.red, () {
                    _updateRelationship(-10);
                    _updateState();
                  });
                }
              },
            ));
          }
        }
      }
    }

    final String cleanRole = widget.targetRole.toLowerCase();
    final String cleanName = widget.targetName.toLowerCase();
    final bool isFatherOrMother = cleanName.contains('ayah') ||
        cleanName.contains('ibu') ||
        cleanRole.contains('ayah') ||
        cleanRole.contains('ibu');
    // Saudara juga bisa Lihat Keluarga
    final bool isSiblingEntry = widget.character.siblings.any((sib) =>
        '${sib['name']} (${sib['relation']})'.toLowerCase() == cleanName ||
        sib['name']!.toLowerCase() == cleanName);

    // Cek apakah target ada di extendedFamily
    final Map<String, String> extMember =
        widget.character.extendedFamily.firstWhere(
      (ext) =>
          ext['name'] == widget.targetName ||
          widget.targetName.contains(ext['name'] ?? ''),
      orElse: () => <String, String>{},
    );
    final bool isExtendedEntry = extMember.isNotEmpty;

    if (isFatherOrMother || isSiblingEntry || isExtendedEntry) {
      String side = 'Ayah';
      if (isExtendedEntry) {
        final String rel = extMember['relation'] ?? '';
        if (rel.contains('Ibu')) {
          side = 'Ibu';
        }
      } else {
        side = (cleanName.contains('ayah') || cleanRole.contains('ayah'))
            ? 'Ayah'
            : 'Ibu';
      }

      actions.insert(
          0,
          ActionItem(
            label: 'Lihat Keluarga',
            icon: Icons.people,
            color: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SiblingFamilyViewScreen(
                    character: widget.character,
                    siblingName: widget.targetName,
                    side: side,
                    onRefresh: () {
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ));
    }

    // --- TAMBAHAN: TOMBOL BERCINTA, PUTUSKAN PACAR, DAN THREESOME UNTUK PASANGAN AKTIF (DI TOP MENU) ---
    final List<ActionItem> topActions = [];

    // isActivePartner sudah dideklarasikan di atas (awal build method)
    // Gunakan variabel yang sama untuk topActions

    final bool isPartnerRole = widget.targetRole == 'Pacar' ||
        widget.targetRole == 'Pacar (Rahasia)' ||
        widget.targetRole == 'Pacar Kedua' ||
        widget.targetRole == 'Pacar Ketiga' ||
        widget.targetRole == 'Pacar Keempat' ||
        widget.targetRole == 'Pacar Kelima' ||
        widget.targetRole == 'Tunangan' ||
        widget.targetRole == 'Suami' ||
        widget.targetRole == 'Istri' ||
        widget.targetRole.startsWith('Pacar') ||
        widget.character.isAnyPartnerNameMatching(widget.targetName);

    final bool isDatingBiologicalFather =
        (cleanRole.contains('ayah') || cleanName.contains('ayah')) &&
            !cleanRole.contains('tiri') &&
            !cleanName.contains('tiri') &&
            widget.character.isAnyPartnerNameMatching(widget.targetName);

    final bool isDatingStepFather =
        (cleanRole.contains('tiri') || cleanName.contains('tiri')) &&
            (cleanRole.contains('ayah') || cleanName.contains('ayah')) &&
            widget.character.isAnyPartnerNameMatching(widget.targetName);

    final bool isFatherPartnerAndMotherTiriExists =
        widget.character.gender.toLowerCase() == 'perempuan' &&
            isDatingBiologicalFather &&
            widget.character.stepMotherName != null &&
            !widget.character.isStepMotherDeceased;

    // Ayah kandung sudah cerai dengan ibu kandung → ayah single, bercinta boleh
    final bool isFatherPartnerAndParentsDivorced =
        widget.character.gender.toLowerCase() == 'perempuan' &&
            isDatingBiologicalFather &&
            widget.character.isFatherDivorced &&
            (widget.character.stepMotherName == null ||
                widget.character.isStepMotherDeceased);

    final bool isStepFatherPartnerAndMotherExists =
        widget.character.gender.toLowerCase() == 'perempuan' &&
            isDatingStepFather &&
            widget.character.motherName != null &&
            !widget.character.isMotherDeceased;

    if (isFatherPartnerAndMotherTiriExists ||
        isStepFatherPartnerAndMotherExists) {
      // 1. Bercinta / Make Love
      topActions.add(ActionItem(
        label: 'Bercinta / Make Love',
        icon: Icons.favorite,
        color: Colors.pink,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BercintaScreen(
                character: widget.character,
                targetName: widget.targetName,
                targetRole: widget.targetRole,
                onActionComplete: () {
                  _updateState();
                },
              ),
            ),
          );
        },
      ));

      // 2. Minta Cerai
      final String spouseName = isFatherPartnerAndMotherTiriExists
          ? (widget.character.stepMotherName ?? 'Ibu Tiri')
          : (widget.character.motherName ?? 'Ibu Kandung');
      final String actionLabel = isFatherPartnerAndMotherTiriExists
          ? 'Minta Cerai dengan Ibu Tiri'
          : 'Minta Cerai dengan Ibu Kandung';

      topActions.add(ActionItem(
        label: actionLabel,
        icon: Icons.heart_broken,
        color: Colors.redAccent,
        onTap: () {
          final screenContext = context;
          showDialog(
            context: screenContext,
            builder: (confirmContext) => AlertDialog(
              title: const Text('Minta Cerai 💔',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text(
                  'Apakah kamu yakin ingin meminta Ayahmu untuk menceraikan $spouseName?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(confirmContext),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(confirmContext);
                    final bool success = _random.nextInt(100) < 40;
                    if (success) {
                      if (isFatherPartnerAndMotherTiriExists) {
                        widget.character.stepMotherName = null;
                        widget.character.stepMotherAge = null;
                        widget.character.stepMotherRelationship = null;
                      } else {
                        widget.character.stepFatherName = null;
                        widget.character.stepFatherAge = null;
                        widget.character.stepFatherRelationship = null;
                        widget.character.isMotherDivorced = true;
                      }

                      final String msg =
                          '💔 Ayahmu memutuskan untuk menceraikan $spouseName atas permintaanmu!';
                      widget.character.inbox.add(msg);
                      _updateRelationship(15);
                      _updateState();

                      _showResultDialog(
                          'Sukses 💔',
                          'Ayahmu menyetujui permintaanmu dan kini resmi menceraikan $spouseName.',
                          Icons.done,
                          Colors.green,
                          () {});
                    } else {
                      _updateRelationship(-15);
                      _updateState();
                      _showResultDialog(
                          'Ditolak 🚫',
                          'Ayahmu menolak untuk menceraikan $spouseName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan istrinya.',
                          Icons.block,
                          Colors.red,
                          () {});
                    }
                  },
                  child: const Text('Ya, Minta',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ));
    } else if (isFatherPartnerAndParentsDivorced) {
      // Ayah kandung sudah cerai, langsung bercinta tanpa menu minta cerai
      topActions.add(ActionItem(
        label: 'Bercinta / Make Love',
        icon: Icons.favorite,
        color: Colors.pink,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BercintaScreen(
                character: widget.character,
                targetName: widget.targetName,
                targetRole: widget.targetRole,
                onActionComplete: () {
                  _updateState();
                },
              ),
            ),
          );
        },
      ));
    } else if (isActivePartner && isPartnerRole) {
      // 1. Bercinta / Make Love (langsung muncul, tidak harus menunggu usia 12)
      topActions.add(ActionItem(
        label: 'Bercinta / Make Love',
        icon: Icons.favorite,
        color: Colors.pink,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BercintaScreen(
                character: widget.character,
                targetName: widget.targetName,
                targetRole: widget.targetRole,
                onActionComplete: () {
                  _updateState();
                },
              ),
            ),
          );
        },
      ));

      // 2. Putuskan Pacar
      topActions.add(ActionItem(
        label: 'Putuskan Pacar',
        icon: Icons.heart_broken,
        color: Colors.red,
        onTap: () {
          final screenContext = context;
          showDialog(
            context: screenContext,
            builder: (confirmDialogContext) => AlertDialog(
              title: const Text('Putuskan Hubungan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text(
                  'Apakah kamu yakin ingin memutuskan hubungan dengan ${widget.targetName}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(confirmDialogContext),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                        confirmDialogContext); // Tutup dialog konfirmasi

                    // 1. Hapus dari partner mana saja yang cocok
                    if (widget.character.partner != null &&
                        widget.character.partner!['name'] ==
                            widget.targetName) {
                      widget.character.partner = null;
                    } else if (widget.character.secondPartner != null &&
                        widget.character.secondPartner!['name'] ==
                            widget.targetName) {
                      widget.character.secondPartner = null;
                    } else if (widget.character.thirdPartner != null &&
                        widget.character.thirdPartner!['name'] ==
                            widget.targetName) {
                      widget.character.thirdPartner = null;
                    } else if (widget.character.fourthPartner != null &&
                        widget.character.fourthPartner!['name'] ==
                            widget.targetName) {
                      widget.character.fourthPartner = null;
                    } else if (widget.character.fifthPartner != null &&
                        widget.character.fifthPartner!['name'] ==
                            widget.targetName) {
                      widget.character.fifthPartner = null;
                    }
                    widget.character.secretPartners
                        .removeWhere((p) => p['name'] == widget.targetName);
                    if (widget.character.secretPartners.isEmpty &&
                        widget.character.secondPartner == null) {
                      widget.character.isHavingAffair = false;
                    }

                    // 2. Tambahkan ke exPartners (mantan pacar)
                    widget.character.exPartners.add({
                      'name': widget.targetName,
                      'gender': _getTargetGender(),
                      'age': widget.character.age.toString(),
                      'relationship': '20',
                      'relation': 'Mantan Pacar',
                      'isDeceased': 'false',
                      'breakInitiator': widget.character.gender,
                      'breakReason': 'putus biasa',
                    });

                    // 3. Turunkan hubungan
                    _updateRelationship(-40);

                    // 4. Refresh state
                    _updateState();

                    // 5. Tampilkan dialog hasil putus menggunakan screenContext
                    DialogHelper.show(
                      context: screenContext,
                      title: 'Putus Hubungan 💔',
                      content: Text(
                          'Kamu telah memutuskan hubungan dengan ${widget.targetName}. Hubungan kalian sekarang berakhir.'),
                      actions: [
                        Builder(
                          builder: (resultDialogContext) => TextButton(
                            onPressed: () {
                              Navigator.pop(resultDialogContext);
                              Navigator.pop(screenContext);
                            },
                            child: const Text('Mengerti'),
                          ),
                        ),
                      ],
                    );
                  },
                  child: const Text('Ya, Putuskan',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ));

      // 3. Threesome (jika pacar >= 2)
      if (widget.character.activePartnersCount >= 2) {
        topActions.add(ActionItem(
          label: 'Threesome',
          icon: Icons.group,
          color: Colors.purple,
          onTap: () {
            ThreesomeHelper.processThreesome(
              context: context,
              character: widget.character,
              updateState: _updateState,
            );
          },
        ));
      }
    }

    if (topActions.isNotEmpty) {
      // Hapus duplikasi tombol bercinta dari list bawah
      actions.removeWhere((act) => act.label == 'Bercinta / Make Love');
      actions.insertAll(0, topActions);
    }
    // -------------------------------------------------------------

    // --- TAMBAHAN: TOMBOL AJAK BALIKAN UNTUK MANTAN PACAR (BISA LEWAT MENU HUBUNGAN) ---
    final bool isExPartner = widget.targetRole == 'Mantan Pacar' ||
        widget.character.exPartners
            .any((ex) => ex['name'] == widget.targetName);
    if (isExPartner && widget.character.age >= 9) {
      final bool hasExistingPartner = widget.character.partner != null;
      bool hasBalikanButton = actions.any(
          (act) => act.label == 'Ajak Balikan' || act.label == 'Ajak Pacaran');
      if (!hasBalikanButton) {
        actions.add(ActionItem(
          label: 'Ajak Balikan',
          icon: hasExistingPartner ? Icons.heart_broken : Icons.favorite,
          color: hasExistingPartner ? Colors.deepOrange : Colors.pinkAccent,
          onTap: () {
            bool accepted = false;
            Map<String, String>? exData;
            for (var ex in widget.character.exPartners) {
              if (ex['name'] == widget.targetName) {
                exData = ex;
                break;
              }
            }

            String? breakInitiator = exData?['breakInitiator'];
            String? breakReason = exData?['breakReason'];

            if (breakReason == 'selingkuh' || breakReason == 'threesome') {
              accepted = _random.nextInt(100) < 10;
            } else {
              if (breakInitiator == 'Laki-laki') {
                accepted = _random.nextInt(100) < 30;
              } else if (breakInitiator == 'Perempuan') {
                accepted = _random.nextInt(100) < 25;
              } else {
                accepted = _random.nextInt(100) < 50;
              }
            }

            if (accepted) {
              widget.character.exPartners
                  .removeWhere((ex) => ex['name'] == widget.targetName);

              int targetAgeVal = widget.character.age;
              if (exData != null && exData['age'] != null) {
                targetAgeVal =
                    int.tryParse(exData['age']!) ?? widget.character.age;
              }

              _showResultDialog(
                  'Balikan Sukses! ❤️',
                  'Kamu berhasil balikan dengan mantan pacarmu, ${widget.targetName}!',
                  Icons.favorite,
                  Colors.pink, () {
                final partnerMap = {
                  'name': widget.targetName,
                  'relation': 'Pacar',
                  'gender': _getTargetGender(),
                  'age': targetAgeVal.toString(),
                  'relationship': '80',
                  'isDeceased': 'false',
                };

                if (widget.character.partner == null) {
                  widget.character.partner = partnerMap;
                } else {
                  widget.character.secondPartner = partnerMap;
                }

                _updateRelationship(30);
                _updateState();
              });
            } else {
              _showResultDialog(
                  'Balikan Ditolak 💔',
                  '${widget.targetName} belum bisa memaafkanmu atau tidak ingin balikan sekarang.',
                  Icons.block,
                  Colors.red, () {
                _updateRelationship(-15);
                _updateState();
              });
            }
          },
        ));
      }
      final String cleanRoleFilter = widget.targetRole.toLowerCase();
      final String cleanNameFilter = widget.targetName.toLowerCase();
      final bool isSiblingFilter = widget.character.siblings.any((sib) =>
              '${sib['name']} (${sib['relation']})'.toLowerCase() ==
                  cleanNameFilter ||
              sib['name']!.toLowerCase() == cleanNameFilter) ||
          cleanRoleFilter.contains('saudara') ||
          cleanRoleFilter.contains('kandung') ||
          cleanRoleFilter.contains('tiri') ||
          cleanNameFilter.contains('kakak') ||
          cleanNameFilter.contains('adik');

      if (isSiblingFilter) {
        // 1. ketika adik berusia kurang dari 10 tahun maka tidak ada button bercinta dan ajak pacaran
        if (targetAge < 10) {
          actions.removeWhere((act) =>
              act.label.toLowerCase().contains('bercinta') ||
              act.label.toLowerCase().contains('make love') ||
              act.label.toLowerCase().contains('pacaran'));
        }
        // 2. hapus button minta mainan jika user sebagai kakak menekan menu dari adiknya
        if (age > targetAge) {
          actions.removeWhere(
              (act) => act.label.toLowerCase().contains('minta mainan'));
        }
      }
      // 3. jika keduanya kurang dari 12 tahun hapus juga pergi ke bioskop
      if (age < 12 && targetAge < 12) {
        actions
            .removeWhere((act) => act.label.toLowerCase().contains('bioskop'));
      }
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
                          child: Image(
                            image: AvatarImageCache.getImageProvider(
                              AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                                name: _getPlainTargetName(),
                                gender: _getTargetGender(),
                                age: targetAge,
                                happiness: relationshipVal,
                                forcedSkinColor: () {
                                  final String plainName = _getPlainTargetName().toLowerCase();
                                  if (widget.character.motherName != null && plainName == widget.character.motherName!.toLowerCase()) {
                                    return widget.character.motherSkinColor;
                                  }
                                  if (widget.character.fatherName != null && plainName == widget.character.fatherName!.toLowerCase()) {
                                    return widget.character.fatherSkinColor;
                                  }
                                  if (widget.character.partner != null && widget.character.partner!['name']!.toLowerCase().contains(plainName)) {
                                    return widget.character.partner!['skinColor'];
                                  }
                                  if (widget.character.secondPartner != null && widget.character.secondPartner!['name']!.toLowerCase().contains(plainName)) {
                                    return widget.character.secondPartner!['skinColor'];
                                  }
                                  if (widget.character.thirdPartner != null && widget.character.thirdPartner!['name']!.toLowerCase().contains(plainName)) {
                                    return widget.character.thirdPartner!['skinColor'];
                                  }
                                  if (widget.character.fourthPartner != null && widget.character.fourthPartner!['name']!.toLowerCase().contains(plainName)) {
                                    return widget.character.fourthPartner!['skinColor'];
                                  }
                                  if (widget.character.fifthPartner != null && widget.character.fifthPartner!['name']!.toLowerCase().contains(plainName)) {
                                    return widget.character.fifthPartner!['skinColor'];
                                  }
                                  return null;
                                }(),
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 28,
                                height: 28,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              );
                            },
                            width: 56,
                            height: 56,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.targetName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                'Hubungan: ${_getDetailedRelationLabel()} | Umur: ${_getCurrentAgeValue()}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tingkat Kepuasan: ',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationshipVal / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationshipVal > 65
                                    ? Colors.green
                                    : relationshipVal > 35
                                        ? Colors.amber
                                        : Colors.red,
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
                            color: relationshipVal > 65
                                ? Colors.green
                                : relationshipVal > 35
                                    ? Colors.amber
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Builder(builder: (context) {
                      final String targetGender = _getTargetGender();
                      final int fertilityVal =
                          _getFertilityRate(targetAge, targetGender);
                      return Row(
                        children: [
                          const Text('Tingkat Kesuburan: ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fertilityVal / 100,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  fertilityVal > 60
                                      ? Colors.pink
                                      : fertilityVal > 30
                                          ? Colors.purple
                                          : Colors.grey,
                                ),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$fertilityVal%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: fertilityVal > 60
                                  ? Colors.pink
                                  : fertilityVal > 30
                                      ? Colors.purple
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    Builder(builder: (context) {
                      final int wealthVal = widget.character.getTargetWealth(widget.targetName, widget.targetRole);
                      final double progressVal = (wealthVal / 1000.0).clamp(0.0, 1.0);
                      Color barColor = Colors.red;
                      if (wealthVal > 500) {
                        barColor = Colors.green;
                      } else if (wealthVal >= 100) {
                        barColor = Colors.amber;
                      }

                      return Row(
                        children: [
                          const Text('Nilai Kekayaan: ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progressVal,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$$wealthVal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: barColor,
                            ),
                          ),
                        ],
                      );
                    }),
                    // --- BADGE HAMIL (di bawah tingkat kesuburan) ---
                    Builder(
                      builder: (context) {
                        final bool targetIsPregnant = widget
                                .character.partnerIsPregnant &&
                            (widget.character.pregnantByPartnerName ==
                                    widget.targetName ||
                                (widget.character.partner != null &&
                                    widget.character.partner!['name'] ==
                                        widget.targetName) ||
                                (widget.character.secondPartner != null &&
                                    widget.character.secondPartner!['name'] ==
                                        widget.targetName));
                        final bool playerIsPregnant =
                            widget.character.isPregnant &&
                                (widget.character.pregnantByPartnerName ==
                                    widget.targetName);

                        if (!targetIsPregnant && !playerIsPregnant)
                          return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.pink.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.pregnant_woman,
                                    color: Colors.pink, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  playerIsPregnant
                                      ? '🍼 Kamu sedang hamil dari ${widget.targetName}!'
                                      : '👶 ${widget.targetName} sedang hamil!',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0),
            ),
            const SizedBox(height: 12),

            // --- MENU ACTION LIST (HASIL DARI AGE FILE) ---
            Expanded(
              child: actions.isEmpty
                  ? Center(
                      child: Text(
                        'Kamu masih berusia $age tahun. Kamu terlalu muda untuk berinteraksi secara aktif.',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
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
                            title: Text(action.label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey),
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
