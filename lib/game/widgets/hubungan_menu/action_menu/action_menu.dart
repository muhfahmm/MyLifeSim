// lib/game/widgets/hubungan_menu/action_menu/action_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/store_page/fitur_premium/adult_features/adult_features.dart';

// Import logic per usia
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_base.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_3_6.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';
import 'package:bitlife/game/widgets/hubungan_menu/extended_family_view.dart';
import 'package:bitlife/game/widgets/hubungan_menu/sibling_family_view.dart';
import 'package:bitlife/game/widgets/hubungan_menu/npc_family_view.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/threesome.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_ajakan.dart';

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

    // Cek daftar teman (character.friends) terlebih dahulu jika cocok dengan nama
    for (var f in widget.character.friends) {
      if (f['name'] != null && (cleanName == f['name']!.toLowerCase() || cleanName.contains(f['name']!.toLowerCase()))) {
        int fAge = int.tryParse(f['age'] ?? '0') ?? 0;
        return '$fAge tahun';
      }
    }

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
      for (var f in widget.character.friends) {
        if (f['name'] == name || (f['name'] != null && name.contains(f['name']!))) {
          int fAge = int.tryParse(f['age'] ?? '0') ?? 0;
          return '$fAge tahun';
        }
      }
      for (var cm in widget.character.classmates) {
        final String expectedLabel = '${cm['name']} (Teman Sekelas)';
        if (expectedLabel == name || cm['name'] == name || (cm['name'] != null && name.contains(cm['name']!))) {
          int cmAge = int.tryParse(cm['age'] ?? '0') ?? 0;
          return '$cmAge tahun';
        }
      }
      for (var ucm in widget.character.univClassmates) {
        if (ucm['name'] == name || (ucm['name'] != null && name.contains(ucm['name']!))) {
          int ucmAge = int.tryParse(ucm['age'] ?? '0') ?? 0;
          return '$ucmAge tahun';
        }
      }
      for (var cw in widget.character.coworkers) {
        if (cw['name'] == name || (cw['name'] != null && name.contains(cw['name']!))) {
          int cwAge = int.tryParse(cw['age'] ?? '0') ?? 0;
          return '$cwAge tahun';
        }
      }
      for (var lec in widget.character.univLecturers) {
        if (lec['name'] == name || (lec['name'] != null && name.contains(lec['name']!))) {
          int lecAge = int.tryParse(lec['age'] ?? '0') ?? 0;
          return '$lecAge tahun';
        }
      }
      for (var t in [...widget.character.sdTeachers, ...widget.character.smpTeachers, ...widget.character.smaTeachers]) {
        if (t['name'] == name || (t['name'] != null && name.contains(t['name']!))) {
          int tAge = int.tryParse(t['age'] ?? '0') ?? 0;
          return '$tAge tahun';
        }
      }
      for (var idl in [...widget.character.idolTrainees, ...widget.character.idolMainMembers, ...widget.character.idolStaff]) {
        if (idl['name'] == name || (idl['name'] != null && name.contains(idl['name']!))) {
          int idlAge = int.tryParse(idl['age'] ?? '0') ?? 0;
          return '$idlAge tahun';
        }
      }
    }
    return 'Tidak diketahui';
  }

  // Helper untuk mendapatkan nama asli target (tanpa prefiks peran seperti Ayah, Ibu, dll)
  String _getPlainTargetName() {
    final String role = widget.targetRole;
    final String name = widget.targetName;
    final String nameLower = name.toLowerCase().trim();

    if (widget.character.motherName != null &&
        (nameLower.contains(widget.character.motherName!.toLowerCase().trim()) ||
         widget.character.motherName!.toLowerCase().trim().contains(nameLower))) {
      return widget.character.motherName!;
    }
    if (widget.character.fatherName != null &&
        (nameLower.contains(widget.character.fatherName!.toLowerCase().trim()) ||
         widget.character.fatherName!.toLowerCase().trim().contains(nameLower))) {
      return widget.character.fatherName!;
    }
    if (widget.character.stepMotherName != null &&
        (nameLower.contains(widget.character.stepMotherName!.toLowerCase().trim()) ||
         widget.character.stepMotherName!.toLowerCase().trim().contains(nameLower))) {
      return widget.character.stepMotherName!;
    }
    if (widget.character.stepFatherName != null &&
        (nameLower.contains(widget.character.stepFatherName!.toLowerCase().trim()) ||
         widget.character.stepFatherName!.toLowerCase().trim().contains(nameLower))) {
      return widget.character.stepFatherName!;
    }

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

    if (name.contains('(') && name.endsWith(')')) {
      final int openIdx = name.indexOf('(');
      final String inside = name.substring(openIdx + 1, name.length - 1).trim();
      if (inside.isNotEmpty) {
        return inside;
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
      for (var cw in widget.character.coworkers) {
        if (cw['name'] == name || (cw['name'] != null && name.contains(cw['name']!.toLowerCase()))) {
          return int.tryParse(cw['relationship'] ?? '50') ?? 50;
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
      for (var cw in widget.character.coworkers) {
        if (cw['name'] == name || (cw['name'] != null && name.contains(cw['name']!.toLowerCase()))) {
          int currentRel = int.tryParse(cw['relationship'] ?? '50') ?? 50;
          cw['relationship'] =
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
    final String name = widget.targetName;
    final String role = widget.targetRole;
    final String nameLower = name.toLowerCase().trim();
    final String roleLower = role.toLowerCase().trim();

    // 1. Cek Orang Tua Kandung & Tiri dulu (dengan pencocokan fleksibel)
    if (widget.character.motherName != null &&
        (nameLower.contains(widget.character.motherName!.toLowerCase().trim()) ||
         widget.character.motherName!.toLowerCase().trim().contains(nameLower))) {
      return 'Perempuan';
    }
    if (widget.character.stepMotherName != null &&
        (nameLower.contains(widget.character.stepMotherName!.toLowerCase().trim()) ||
         widget.character.stepMotherName!.toLowerCase().trim().contains(nameLower))) {
      return 'Perempuan';
    }
    if (widget.character.fatherName != null &&
        (nameLower.contains(widget.character.fatherName!.toLowerCase().trim()) ||
         widget.character.fatherName!.toLowerCase().trim().contains(nameLower))) {
      return 'Laki-laki';
    }
    if (widget.character.stepFatherName != null &&
        (nameLower.contains(widget.character.stepFatherName!.toLowerCase().trim()) ||
         widget.character.stepFatherName!.toLowerCase().trim().contains(nameLower))) {
      return 'Laki-laki';
    }

    // 2. Cek keyword nama / role untuk Ibu atau Ayah
    if (nameLower.startsWith('ibu') || roleLower.contains('ibu') || roleLower.contains('bibi') || roleLower.contains('nenek') || roleLower.contains('istri') || roleLower.contains('perempuan')) {
      return 'Perempuan';
    }
    if (nameLower.startsWith('ayah') || roleLower.contains('ayah') || roleLower.contains('paman') || roleLower.contains('kakek') || roleLower.contains('suami') || roleLower.contains('laki')) {
      return 'Laki-laki';
    }

    // 3. Cek partner utama & selingkuhan
    if (widget.character.partner != null &&
        (widget.character.partner!['name']?.toLowerCase().trim() == nameLower ||
         nameLower.contains(widget.character.partner!['name']?.toLowerCase().trim() ?? '___') ||
         (widget.character.partner!['name']?.toLowerCase().trim() ?? '').contains(nameLower))) {
      return widget.character.partner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.secondPartner != null &&
        (widget.character.secondPartner!['name']?.toLowerCase().trim() == nameLower ||
         nameLower.contains(widget.character.secondPartner!['name']?.toLowerCase().trim() ?? '___') ||
         (widget.character.secondPartner!['name']?.toLowerCase().trim() ?? '').contains(nameLower))) {
      return widget.character.secondPartner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.thirdPartner != null &&
        (widget.character.thirdPartner!['name']?.toLowerCase().trim() == nameLower ||
         nameLower.contains(widget.character.thirdPartner!['name']?.toLowerCase().trim() ?? '___') ||
         (widget.character.thirdPartner!['name']?.toLowerCase().trim() ?? '').contains(nameLower))) {
      return widget.character.thirdPartner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.fourthPartner != null &&
        (widget.character.fourthPartner!['name']?.toLowerCase().trim() == nameLower ||
         nameLower.contains(widget.character.fourthPartner!['name']?.toLowerCase().trim() ?? '___') ||
         (widget.character.fourthPartner!['name']?.toLowerCase().trim() ?? '').contains(nameLower))) {
      return widget.character.fourthPartner!['gender'] ?? 'Perempuan';
    }
    if (widget.character.fifthPartner != null &&
        (widget.character.fifthPartner!['name']?.toLowerCase().trim() == nameLower ||
         nameLower.contains(widget.character.fifthPartner!['name']?.toLowerCase().trim() ?? '___') ||
         (widget.character.fifthPartner!['name']?.toLowerCase().trim() ?? '').contains(nameLower))) {
      return widget.character.fifthPartner!['gender'] ?? 'Perempuan';
    }

    // 4. Cari di semua list NPC
    for (var list in [
      widget.character.siblings,
      widget.character.extendedFamily,
      widget.character.classmates,
      widget.character.univClassmates,
      widget.character.coworkers,
      widget.character.sdTeachers,
      widget.character.smpTeachers,
      widget.character.smaTeachers,
      widget.character.univLecturers,
      widget.character.children,
    ]) {
      for (var npc in list) {
        final String? npcName = npc['name']?.toLowerCase().trim();
        if (npcName != null && npcName.isNotEmpty && (npcName == nameLower || nameLower.contains(npcName) || npcName.contains(nameLower))) {
          return npc['gender'] ?? 'Perempuan';
        }
      }
    }

    // 5. Fallback ke role gender jika ada
    if (roleLower.contains('perempuan') || roleLower.contains('binti') || roleLower.contains('bibi') || roleLower.contains('nenek')) {
      return 'Perempuan';
    }
    if (roleLower.contains('laki') || roleLower.contains('bin') || roleLower.contains('paman') || roleLower.contains('kakek')) {
      return 'Laki-laki';
    }

    return 'Perempuan';
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
        return 'Ayah Kandung';
      } else if (name.startsWith('ibu')) {
        return 'Ibu Kandung';
      }
    } else if (role == 'Laki-laki') {
      return 'Anak Laki-laki';
    } else if (role == 'Perempuan') {
      return 'Anak Perempuan';
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

      actions.add(_buildAjakMasturbasiAction());
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

    // Logika filter menu pacar dihilangkan agar menu dewasa/normal konsisten dengan getAge12PlusActions / getAge6to11Actions standar.
    if (isChild && targetAge < 12) {
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

    // --- PREMIUM: Tombol dewasa untuk ANAK usia >= 12 tahun ---
    if (isChild && targetAge >= 12 && AdultFeatures.isPremiumUnlocked) {
      // 1. Bercinta / Make Love
      final bool hasBercintaAlready = actions.any((a) =>
          a.label.toLowerCase().contains('bercinta') ||
          a.label.toLowerCase().contains('make love'));
      if (!hasBercintaAlready) {
        actions.insert(0, ActionItem(
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

      // 2. Ajak Masturbasi Bersama
      final bool hasMasturbasiAlready = actions.any((a) =>
          a.label.toLowerCase().contains('masturbasi'));
      if (!hasMasturbasiAlready) {
        actions.insert(1, _buildAjakMasturbasiAction());
      }

      // 3. Ajak Pacaran (atau Selingkuh jika sudah punya pasangan)
      final bool isAlreadyChildPartner = widget.character.isAnyPartnerNameMatching(widget.targetName);
      if (!isAlreadyChildPartner) {
        final bool hasPacaranAlready = actions.any((a) =>
            a.label.toLowerCase().contains('pacaran') ||
            a.label.toLowerCase().contains('balikan'));
        if (!hasPacaranAlready) {
          final bool hasPartner = widget.character.partner != null;
          actions.insert(2, ActionItem(
            label: hasPartner ? 'Ajak Pacaran (Selingkuh?)' : 'Ajak Pacaran',
            icon: hasPartner ? Icons.heart_broken : Icons.favorite_border,
            color: hasPartner ? Colors.deepOrange : Colors.redAccent,
            onTap: () {
              final bool accepted = _random.nextInt(100) < 50;
              if (accepted) {
                _showResultDialog(
                  'Pacaran Baru! ❤️',
                  'Ajakanmu diterima oleh ${widget.targetName}! Kalian kini menjadi sepasang kekasih.',
                  Icons.favorite,
                  Colors.pinkAccent,
                  () {
                    final String childGender = _getTargetGender();
                    final partnerMap = {
                      'name': widget.targetName,
                      'relation': 'Pacar',
                      'gender': childGender,
                      'age': targetAge.toString(),
                      'relationship': '80',
                      'isDeceased': 'false',
                    };
                    if (widget.character.partner == null) {
                      widget.character.partner = partnerMap;
                    } else {
                      widget.character.secondPartner = partnerMap;
                      widget.character.isHavingAffair = true;
                    }
                    _updateRelationship(20);
                    _updateState();
                  },
                );
              } else {
                _showResultDialog(
                  'Ajakan Ditolak 💔',
                  '${widget.targetName} menolak ajakanmu untuk berpacaran. Hubungan menjadi sedikit canggung (-10% hubungan).',
                  Icons.block,
                  Colors.red,
                  () {
                    _updateRelationship(-10);
                    _updateState();
                  },
                );
              }
            },
          ));
        }
      }

      // 4. Minta Putus / Ceraikan (jika anak punya pasangan)
      Map<String, String>? childDataPremium;
      for (var c in widget.character.children) {
        final String cn = c['name'] ?? '';
        final String cleanSearchN = widget.targetName.replaceAll(' (Wafat)', '').trim().toLowerCase();
        if (cn.toLowerCase() == cleanSearchN || cleanSearchN.contains(cn.toLowerCase())) {
          childDataPremium = c;
          break;
        }
      }
      final String? childCurrentPartner = childDataPremium?['partnerName'];
      if (childCurrentPartner != null && childCurrentPartner.isNotEmpty) {
        final bool hasMintaPutus = actions.any((a) =>
            a.label.toLowerCase().contains('minta cerai') ||
            a.label.toLowerCase().contains('minta putus') ||
            a.label.toLowerCase().contains('pisahkan'));
        if (!hasMintaPutus) {
          actions.insert(
            isAlreadyChildPartner ? 2 : 3,
            ActionItem(
              label: 'Minta Cerai dengan $childCurrentPartner',
              icon: Icons.heart_broken,
              color: Colors.redAccent,
              onTap: () {
                final screenCtx = context;
                showDialog(
                  context: screenCtx,
                  builder: (confirmCtx) => AlertDialog(
                    title: const Text('Minta Cerai 💔',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text(
                        'Apakah kamu yakin ingin meminta ${widget.targetName} untuk memutuskan hubungannya dengan $childCurrentPartner?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(confirmCtx),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(confirmCtx);
                          final bool success = _random.nextInt(100) < 40;
                          if (success) {
                            childDataPremium!['partnerName'] = '';
                            childDataPremium['partnerGender'] = '';
                            _updateRelationship(-10);
                            _updateState();
                            _showResultDialog(
                              'Berhasil 💔',
                              '${widget.targetName} memutuskan hubungannya dengan $childCurrentPartner atas permintaanmu.',
                              Icons.done,
                              Colors.green,
                              () {},
                            );
                          } else {
                            _updateRelationship(-20);
                            _updateState();
                            _showResultDialog(
                              'Ditolak 🚫',
                              '${widget.targetName} menolak permintaanmu dan tetap bersama $childCurrentPartner. Hubunganmu dengannya menurun.',
                              Icons.block,
                              Colors.red,
                              () {},
                            );
                          }
                        },
                        child: const Text('Ya, Minta',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }
    }
    // --- END PREMIUM CHILD BUTTONS ---


    final String mintaAdikTargetName = widget.targetName.toLowerCase();
    final bool mintaAdikIsMother = mintaAdikTargetName.contains('ibu') && !mintaAdikTargetName.contains('tiri');
    if (widget.character.age >= 6 &&
        widget.character.age <= 12 &&
        mintaAdikIsMother &&
        widget.character.motherName != null &&
        widget.character.isMotherDeceased == false) {
      final bool hasMintaAdik = actions.any((act) => act.label == 'Minta Adik Baru');
      if (!hasMintaAdik) {
        final ActionItem mintaAdikAction = ActionItem(
          label: 'Minta Adik Baru',
          icon: Icons.baby_changing_station,
          color: Colors.pinkAccent,
          onTap: () {
            final int motherAge = widget.character.motherAge ?? 0;
            if (motherAge < 18 || motherAge > 45) {
              _showResultDialog(
                'Minta Adik Baru',
                'Ibumu tersenyum sedih dan berkata, "Ibu sudah tidak bisa melahirkan adik baru lagi untukmu pada usia $motherAge tahun, sayang..."',
                Icons.baby_changing_station,
                Colors.grey,
                () {},
              );
            } else {
              final bool cannotHaveChild = widget.character.isMotherDivorced &&
                  (widget.character.stepFatherName == null ||
                      widget.character.isStepFatherDeceased);
              if (cannotHaveChild) {
                _showResultDialog(
                  'Minta Adik Baru',
                  'Ibumu mengelus rambutmu dan berkata, "Ibu tidak memiliki pasangan saat ini untuk memberimu adik baru, sayang."',
                  Icons.baby_changing_station,
                  Colors.grey,
                  () {},
                );
              } else {
                final int biologicalSiblings = widget.character.siblings.where((sib) {
                  final String rel = sib['relation'] ?? '';
                  return !rel.toLowerCase().contains('tiri');
                }).length;
                final int totalChildren = 1 + biologicalSiblings;
                String childrenWord = '$totalChildren anak';
                if (totalChildren == 1) {
                  childrenWord = 'satu anak';
                } else if (totalChildren == 2) {
                  childrenWord = 'dua anak';
                } else if (totalChildren == 3) {
                  childrenWord = 'tiga anak';
                } else if (totalChildren == 4) {
                  childrenWord = 'empat anak';
                } else if (totalChildren == 5) {
                  childrenWord = 'lima anak';
                }
                final String capitalizedChildren = '${childrenWord[0].toUpperCase()}${childrenWord.substring(1)}';

                if (_random.nextBool()) {
                  _showResultDialog(
                    'Permintaan Disetujui!',
                    'Ibumu tersenyum hangat dan berkata, "Wah, ide yang bagus! Ibu akan membicarakannya dengan Ayahmu. Semoga kita segera mendapat adik baru!" Hubunganmu membaik dan kamu merasa senang. (+10% Hubungan, +15% Kebahagiaan)',
                    Icons.favorite,
                    Colors.green,
                    () {
                      widget.character.motherWillTryForBaby = true;
                      widget.character.happiness =
                          (widget.character.happiness + 15).clamp(0, 100);
                      _updateRelationship(10);
                      _updateState();
                    },
                  );
                } else {
                  _showResultDialog(
                    'Permintaan Ditolak',
                    'Ibumu tertawa kecil dan berkata, "$capitalizedChildren saja sudah membuat Ibu cukup sibuk saat ini, sayang. Mungkin nanti ya!" Hubunganmu tetap baik. (+2% Hubungan)',
                    Icons.sentiment_neutral,
                    Colors.orange,
                    () {
                      _updateRelationship(2);
                      _updateState();
                    },
                  );
                }
              }
            }
          },
        );

        final int sepedaIndex = actions.indexWhere((act) => act.label == 'Minta Sepeda');
        if (sepedaIndex != -1) {
          actions.insert(sepedaIndex + 1, mintaAdikAction);
        } else {
          actions.add(mintaAdikAction);
        }
      }
    }

    // --- KHUSUS ORANG TUA: Minta Cerai / Minta Tidak Menikah Lagi (Non-Dating / Hubungan Normal) ---
    final String parentTargetName = widget.targetName.toLowerCase();
    final bool parentIsFather = parentTargetName.startsWith('ayah') && !parentTargetName.contains('tiri');
    final bool parentIsMother = parentTargetName.startsWith('ibu') && !parentTargetName.contains('tiri');

    if (!isActivePartner) {
      final String myGenderLower = widget.character.gender.trim().toLowerCase();

      // --- AYAH ---
      if (parentIsFather && widget.character.fatherName != null && widget.character.isFatherDeceased == false) {
        final bool hasStepMother = widget.character.stepMotherName != null && widget.character.isStepMotherDeceased == false;
        final bool isStillMarriedToMother = widget.character.motherName != null &&
            widget.character.isMotherDeceased == false &&
            widget.character.isFatherDivorced == false &&
            widget.character.isMotherDivorced == false;

        if (hasStepMother) {
          final String stepMotherName = widget.character.stepMotherName!;
          final bool hasMintaCerai = actions.any((act) => act.label.contains('Minta Cerai'));
          if (!hasMintaCerai) {
            actions.add(ActionItem(
              label: 'Minta Cerai dengan $stepMotherName',
              icon: Icons.heart_broken,
              color: Colors.redAccent,
              onTap: () {
                final screenContext = context;
                showDialog(
                  context: screenContext,
                  builder: (confirmContext) => AlertDialog(
                    title: const Text('Minta Cerai 💔', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text('Apakah kamu yakin ingin meminta Ayahmu untuk menceraikan $stepMotherName?'),
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
                            widget.character.stepMotherName = null;
                            widget.character.stepMotherAge = null;
                            widget.character.stepMotherRelationship = null;

                            final String msg = '💔 Ayahmu memutuskan untuk menceraikan $stepMotherName atas permintaanmu!';
                            widget.character.inbox.add(msg);
                            _updateRelationship(15);
                            _updateState();

                            _showResultDialog(
                              'Sukses 💔',
                              'Ayahmu menyetujui permintaanmu dan kini resmi menceraikan $stepMotherName.',
                              Icons.done,
                              Colors.green,
                              () {
                                Navigator.pop(screenContext);
                              }
                            );
                          } else {
                            _updateRelationship(-15);
                            _updateState();
                            _showResultDialog(
                              'Ditolak 🚫',
                              'Ayahmu menolak untuk menceraikan $stepMotherName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan pasangannya.',
                              Icons.block,
                              Colors.red,
                              () {}
                            );
                          }
                        },
                        child: const Text('Ya, Minta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ));
          }
        } else if (isStillMarriedToMother && myGenderLower == 'perempuan') {
          // Jika masih bersuami-istri dengan Ibu Kandung dan player adalah Perempuan
          final String motherName = widget.character.motherName!;
          final bool hasMintaCerai = actions.any((act) => act.label.contains('Minta Cerai'));
          if (!hasMintaCerai) {
            actions.add(ActionItem(
              label: 'Minta Cerai dengan $motherName',
              icon: Icons.heart_broken,
              color: Colors.redAccent,
              onTap: () {
                final screenContext = context;
                showDialog(
                  context: screenContext,
                  builder: (confirmContext) => AlertDialog(
                    title: const Text('Minta Cerai 💔', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text('Apakah kamu yakin ingin meminta Ayahmu untuk menceraikan $motherName?'),
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
                            // Hapus ibu kandung karena mereka bercerai
                            widget.character.motherName = null;
                            widget.character.motherAge = null;
                            widget.character.motherRelationship = null;
                            widget.character.isFatherDivorced = true;
                            widget.character.isMotherDivorced = true;

                            final String msg = '💔 Ayahmu memutuskan untuk menceraikan $motherName atas permintaanmu!';
                            widget.character.inbox.add(msg);
                            _updateRelationship(15);
                            _updateState();

                            _showResultDialog(
                              'Sukses 💔',
                              'Ayahmu menyetujui permintaanmu dan kini resmi menceraikan $motherName.',
                              Icons.done,
                              Colors.green,
                              () {
                                Navigator.pop(screenContext);
                              }
                            );
                          } else {
                            _updateRelationship(-15);
                            _updateState();
                            _showResultDialog(
                              'Ditolak 🚫',
                              'Ayahmu menolak untuk menceraikan $motherName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan pasangannya.',
                              Icons.block,
                              Colors.red,
                              () {}
                            );
                          }
                        },
                        child: const Text('Ya, Minta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ));
          }
        } else if (!hasStepMother && !isStillMarriedToMother) {
          // Hanya tampilkan Minta Tidak Menikah Lagi jika Ayah benar-benar duda (tidak beristri)
          if (!widget.character.isFatherPersuadedNotToRemarry && widget.character.age >= 10) {
            final bool hasMintaTidakNikah = actions.any((act) => act.label == 'Minta Tidak Menikah Lagi');
            if (!hasMintaTidakNikah) {
              actions.add(ActionItem(
                label: 'Minta Tidak Menikah Lagi',
                icon: Icons.block,
                color: Colors.orange,
                onTap: () {
                  final screenContext = context;
                  showDialog(
                    context: screenContext,
                    builder: (confirmContext) => AlertDialog(
                      title: const Text('Minta Tidak Menikah Lagi 💍', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: const Text('Apakah kamu yakin ingin membujuk ayahmu untuk tidak menikah lagi dengan orang lain?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(confirmContext),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(confirmContext);
                            final bool success = _random.nextInt(100) < 70;
                            if (success) {
                              widget.character.isFatherPersuadedNotToRemarry = true;
                              _updateRelationship(15);
                              _updateState();
                              _showResultDialog(
                                'Sukses 💍',
                                'Ayahmu menyetujui permintaanmu. Dia berjanji tidak akan menikah lagi dengan orang lain.',
                                Icons.done,
                                Colors.green,
                                () {}
                              );
                            } else {
                              _updateRelationship(-15);
                              _updateState();
                              _showResultDialog(
                                'Ditolak 🚫',
                                'Ayahmu menolak permintaanmu. Dia merasa masih membutuhkan pendamping hidup kelak.',
                                Icons.block,
                                Colors.red,
                                () {}
                              );
                            }
                          },
                          child: const Text('Bujuk Ayah', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ));
            }
          }
        }
      }

      // --- IBU ---
      else if (parentIsMother && widget.character.motherName != null && widget.character.isMotherDeceased == false) {
        final bool hasStepFather = widget.character.stepFatherName != null && widget.character.isStepFatherDeceased == false;
        final bool isStillMarriedToFather = widget.character.fatherName != null &&
            widget.character.isFatherDeceased == false &&
            widget.character.isFatherDivorced == false &&
            widget.character.isMotherDivorced == false;

        if (hasStepFather) {
          final String stepFatherName = widget.character.stepFatherName!;
          final bool hasMintaCerai = actions.any((act) => act.label.contains('Minta Cerai'));
          if (!hasMintaCerai) {
            actions.add(ActionItem(
              label: 'Minta Cerai dengan $stepFatherName',
              icon: Icons.heart_broken,
              color: Colors.redAccent,
              onTap: () {
                final screenContext = context;
                showDialog(
                  context: screenContext,
                  builder: (confirmContext) => AlertDialog(
                    title: const Text('Minta Cerai 💔', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text('Apakah kamu yakin ingin meminta Ibumu untuk menceraikan $stepFatherName?'),
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
                            widget.character.stepFatherName = null;
                            widget.character.stepFatherAge = null;
                            widget.character.stepFatherRelationship = null;

                            final String msg = '💔 Ibumu memutuskan untuk menceraikan $stepFatherName atas permintaanmu!';
                            widget.character.inbox.add(msg);
                            _updateRelationship(15);
                            _updateState();

                            _showResultDialog(
                              'Sukses 💔',
                              'Ibumu menyetujui permintaanmu dan kini resmi menceraikan $stepFatherName.',
                              Icons.done,
                              Colors.green,
                              () {
                                Navigator.pop(screenContext);
                              }
                            );
                          } else {
                            _updateRelationship(-15);
                            _updateState();
                            _showResultDialog(
                              'Ditolak 🚫',
                              'Ibumu menolak untuk menceraikan $stepFatherName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan pasangannya.',
                              Icons.block,
                              Colors.red,
                              () {}
                            );
                          }
                        },
                        child: const Text('Ya, Minta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ));
          }
        } else if (isStillMarriedToFather && myGenderLower == 'laki-laki') {
          // Jika masih bersuami-istri dengan Ayah Kandung dan player adalah Laki-laki
          final String fatherName = widget.character.fatherName!;
          final bool hasMintaCerai = actions.any((act) => act.label.contains('Minta Cerai'));
          if (!hasMintaCerai) {
            actions.add(ActionItem(
              label: 'Minta Cerai dengan $fatherName',
              icon: Icons.heart_broken,
              color: Colors.redAccent,
              onTap: () {
                final screenContext = context;
                showDialog(
                  context: screenContext,
                  builder: (confirmContext) => AlertDialog(
                    title: const Text('Minta Cerai 💔', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text('Apakah kamu yakin ingin meminta Ibumu untuk menceraikan $fatherName?'),
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
                            // Hapus ayah kandung karena mereka bercerai
                            widget.character.fatherName = null;
                            widget.character.fatherAge = null;
                            widget.character.fatherRelationship = null;
                            widget.character.isFatherDivorced = true;
                            widget.character.isMotherDivorced = true;

                            final String msg = '💔 Ibumu memutuskan untuk menceraikan $fatherName atas permintaanmu!';
                            widget.character.inbox.add(msg);
                            _updateRelationship(15);
                            _updateState();

                            _showResultDialog(
                              'Sukses 💔',
                              'Ibumu menyetujui permintaanmu dan kini resmi menceraikan $fatherName.',
                              Icons.done,
                              Colors.green,
                              () {
                                Navigator.pop(screenContext);
                              }
                            );
                          } else {
                            _updateRelationship(-15);
                            _updateState();
                            _showResultDialog(
                              'Ditolak 🚫',
                              'Ibumu menolak untuk menceraikan $fatherName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan pasangannya.',
                              Icons.block,
                              Colors.red,
                              () {}
                            );
                          }
                        },
                        child: const Text('Ya, Minta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ));
          }
        }
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
            actions.add(_buildAjakMasturbasiAction());
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

          bool hasPacaran = actions.any((act) => act.label.contains('Pacaran') || act.label.contains('Balikan'));
          if (!hasPacaran &&
              !isActivePartner &&
              !isAlreadyPartner &&
              !isAlreadySecondPartner &&
              !isPartnerRole &&
              AdultFeatures.canProposeDating(widget.targetRole, widget.targetName, userAge: widget.character.age)) {
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

    final bool isStepFatherPartnerAndMotherExists =
        widget.character.gender.toLowerCase() == 'perempuan' &&
            isDatingStepFather &&
            widget.character.motherName != null &&
            !widget.character.isMotherDeceased;

    final bool isDatingBiologicalMother =
        (cleanRole.contains('ibu') || cleanName.contains('ibu')) &&
            !cleanRole.contains('tiri') &&
            !cleanName.contains('tiri') &&
            widget.character.isAnyPartnerNameMatching(widget.targetName);

    final bool isMotherPartnerAndFatherTiriExists =
        widget.character.gender.toLowerCase() == 'laki-laki' &&
            isDatingBiologicalMother &&
            widget.character.stepFatherName != null &&
            !widget.character.isStepFatherDeceased;

    final bool isMotherPartnerAndFatherExists =
        widget.character.gender.toLowerCase() == 'laki-laki' &&
            isDatingBiologicalMother &&
            widget.character.fatherName != null &&
            !widget.character.isFatherDeceased;

    // True when dating a parent whose spouse doesn't exist anymore (already divorced)
    // so we show Bercinta directly without the Minta Cerai button
    final bool isFatherPartnerAndParentsDivorced =
        widget.character.gender.toLowerCase() == 'perempuan' &&
            isDatingBiologicalFather &&
            (widget.character.stepMotherName == null ||
                widget.character.isStepMotherDeceased) &&
            (widget.character.motherName == null ||
                widget.character.isMotherDeceased);

    final bool isStepFatherPartnerAndParentsDivorced =
        widget.character.gender.toLowerCase() == 'perempuan' &&
            isDatingStepFather &&
            (widget.character.motherName == null ||
                widget.character.isMotherDeceased);

    final bool isMotherPartnerAndParentsDivorced =
        widget.character.gender.toLowerCase() == 'laki-laki' &&
            isDatingBiologicalMother &&
            (widget.character.stepFatherName == null ||
                widget.character.isStepFatherDeceased) &&
            (widget.character.fatherName == null ||
                widget.character.isFatherDeceased);

    final String plainTarget = widget.targetName;
    final String cleanRoleLower = widget.targetRole.toLowerCase();
    
    final bool isSpouse = cleanRoleLower == 'istri' || cleanRoleLower == 'suami' || cleanRoleLower == 'pasangan';
    final String breakLabel = isSpouse 
        ? (cleanRoleLower == 'istri' ? 'Ceraikan Istri' : (cleanRoleLower == 'suami' ? 'Ceraikan Suami' : 'Ceraikan Pasangan'))
        : 'Putuskan Pacar';
    final String breakTitle = isSpouse ? 'Ceraikan Pasangan 💔' : 'Putuskan Hubungan';
    final String breakBody = isSpouse 
        ? 'Apakah kamu yakin ingin menceraikan ${widget.targetName}?'
        : 'Apakah kamu yakin ingin memutuskan hubungan dengan ${widget.targetName}?';
    final String breakButtonText = isSpouse ? 'Ya, Ceraikan' : 'Ya, Putuskan';

    final ActionItem putuskanPacarAction = ActionItem(
      label: breakLabel,
      icon: Icons.heart_broken,
      color: Colors.red,
      onTap: () {
        final screenContext = context;
        showDialog(
          context: screenContext,
          builder: (confirmDialogContext) => AlertDialog(
            title: Text(breakTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(breakBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(confirmDialogContext),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(confirmDialogContext); // Tutup dialog konfirmasi

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

                  // 2. Tambahkan ke exPartners (mantan pacar / mantan pasangan)
                  widget.character.exPartners.add({
                    'name': widget.targetName,
                    'gender': _getTargetGender(),
                    'age': targetAge.toString(),
                    'relationship': '20',
                    'relation': isSpouse 
                        ? (cleanRoleLower == 'istri' ? 'Mantan Istri' : 'Mantan Suami')
                        : 'Mantan Pacar',
                    'isDeceased': 'false',
                    'breakInitiator': widget.character.gender,
                    'breakReason': 'putus biasa',
                  });

                  // 3. Turunkan hubungan
                  _updateRelationship(-40);

                  // 4. Refresh state
                  _updateState();

                  // 5. Tampilkan dialog hasil putus menggunakan screenContext
                  final String resultTitle = isSpouse ? 'Perceraian Selesai 💔' : 'Putus Hubungan 💔';
                  final String resultContent = isSpouse 
                      ? 'Kamu telah resmi bercerai dengan ${widget.targetName}. Hubungan kalian sekarang berakhir.'
                      : 'Kamu telah memutuskan hubungan dengan ${widget.targetName}. Hubungan kalian sekarang berakhir.';

                  DialogHelper.show(
                    context: screenContext,
                    title: resultTitle,
                    content: Text(resultContent),
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
                child: Text(breakButtonText,
                    style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );

    if (isFatherPartnerAndMotherTiriExists ||
        isStepFatherPartnerAndMotherExists ||
        isMotherPartnerAndFatherTiriExists ||
        isMotherPartnerAndFatherExists) {
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

      topActions.add(_buildAjakMasturbasiAction());

      // Putuskan Pacar (hanya jika pacar, bukan ceraikan pasangan)
      if (!isSpouse) {
        topActions.add(putuskanPacarAction);
      }

      // Minta Tidak Menikah Lagi (hanya jika ayah berstatus duda / tidak memiliki ibu tiri)
      if (isDatingBiologicalFather &&
          !widget.character.isFatherPersuadedNotToRemarry &&
          widget.character.age >= 10 &&
          (widget.character.stepMotherName == null ||
              widget.character.isStepMotherDeceased == true)) {
        topActions.add(ActionItem(
          label: 'Minta Tidak Menikah Lagi',
          icon: Icons.block,
          color: Colors.orange,
          onTap: () {
            final screenContext = context;
            showDialog(
              context: screenContext,
              builder: (confirmContext) => AlertDialog(
                title: const Text('Minta Tidak Menikah Lagi 💍',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text(
                    'Apakah kamu yakin ingin membujuk ayahmu untuk tidak menikah lagi dengan orang lain?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(confirmContext),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(confirmContext);
                      final bool success = _random.nextInt(100) < 70;
                      if (success) {
                        widget.character.isFatherPersuadedNotToRemarry = true;
                        _updateRelationship(15);
                        _updateState();
                        _showResultDialog(
                            'Sukses 💍',
                            'Ayahmu menyetujui permintaanmu. Dia berjanji tidak akan menikah lagi dengan orang lain.',
                            Icons.done,
                            Colors.green,
                            () {});
                      } else {
                        _updateRelationship(-15);
                        _updateState();
                        _showResultDialog(
                            'Ditolak 🚫',
                            'Ayahmu menolak permintaanmu. Dia merasa masih membutuhkan pendamping hidup kelak.',
                            Icons.block,
                            Colors.red,
                            () {});
                      }
                    },
                    child: const Text('Bujuk Ayah',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ));
      }

      // 2. Minta Cerai
      final String spouseName = isFatherPartnerAndMotherTiriExists
          ? (widget.character.stepMotherName ?? 'Ibu Tiri')
          : isStepFatherPartnerAndMotherExists
              ? (widget.character.motherName ?? 'Ibu Kandung')
              : isMotherPartnerAndFatherTiriExists
                  ? (widget.character.stepFatherName ?? 'Ayah Tiri')
                  : (widget.character.fatherName ?? 'Ayah Kandung');

      final String actionLabel = isFatherPartnerAndMotherTiriExists
          ? 'Minta Cerai dengan Ibu Tiri'
          : isStepFatherPartnerAndMotherExists
              ? 'Minta Cerai dengan Ibu Kandung'
              : isMotherPartnerAndFatherTiriExists
                  ? 'Minta Cerai dengan Ayah Tiri'
                  : 'Minta Cerai dengan Ayah Kandung';

      final String askerTitle = (isFatherPartnerAndMotherTiriExists || isStepFatherPartnerAndMotherExists)
          ? 'Ayahmu'
          : 'Ibumu';

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
                  'Apakah kamu yakin ingin meminta ${askerTitle} untuk menceraikan $spouseName?'),
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
                      } else if (isStepFatherPartnerAndMotherExists) {
                        widget.character.stepFatherName = null;
                        widget.character.stepFatherAge = null;
                        widget.character.stepFatherRelationship = null;
                        widget.character.isMotherDivorced = true;
                      } else if (isMotherPartnerAndFatherTiriExists) {
                        widget.character.stepFatherName = null;
                        widget.character.stepFatherAge = null;
                        widget.character.stepFatherRelationship = null;
                      } else if (isMotherPartnerAndFatherExists) {
                        widget.character.stepMotherName = null;
                        widget.character.stepMotherAge = null;
                        widget.character.stepMotherRelationship = null;
                        widget.character.isFatherDivorced = true;
                      }

                      final String msg =
                          '💔 ${askerTitle} memutuskan untuk menceraikan $spouseName atas permintaanmu!';
                      widget.character.inbox.add(msg);
                      _updateRelationship(15);
                      _updateState();

                      _showResultDialog(
                          'Sukses 💔',
                          '${askerTitle} menyetujui permintaanmu dan kini resmi menceraikan $spouseName.',
                          Icons.done,
                          Colors.green,
                          () {
                            Navigator.pop(screenContext); // Langsung tutup halaman agar ter-refresh otomatis di Hubungan & Keluarga
                          });
                    } else {
                      _updateRelationship(-15);
                      _updateState();
                      _showResultDialog(
                          'Ditolak 🚫',
                          '${askerTitle} menolak untuk menceraikan $spouseName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan pasangannya.',
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
    } else if (isFatherPartnerAndParentsDivorced ||
        isStepFatherPartnerAndParentsDivorced ||
        isMotherPartnerAndParentsDivorced) {
      // Orang tua sudah cerai, langsung bercinta tanpa menu minta cerai
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

      topActions.add(_buildAjakMasturbasiAction());

      // Putuskan Pacar
      topActions.add(putuskanPacarAction);

      // Minta Tidak Menikah Lagi (hanya jika ayah berstatus duda / tidak memiliki ibu tiri)
      if (isDatingBiologicalFather &&
          !widget.character.isFatherPersuadedNotToRemarry &&
          widget.character.age >= 10 &&
          (widget.character.stepMotherName == null ||
              widget.character.isStepMotherDeceased == true)) {
        topActions.add(ActionItem(
          label: 'Minta Tidak Menikah Lagi',
          icon: Icons.block,
          color: Colors.orange,
          onTap: () {
            final screenContext = context;
            showDialog(
              context: screenContext,
              builder: (confirmContext) => AlertDialog(
                title: const Text('Minta Tidak Menikah Lagi 💍',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text(
                    'Apakah kamu yakin ingin membujuk ayahmu untuk tidak menikah lagi dengan orang lain?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(confirmContext),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(confirmContext);
                      final bool success = _random.nextInt(100) < 70;
                      if (success) {
                        widget.character.isFatherPersuadedNotToRemarry = true;
                        _updateRelationship(15);
                        _updateState();
                        _showResultDialog(
                            'Sukses 💍',
                            'Ayahmu menyetujui permintaanmu. Dia berjanji tidak akan menikah lagi dengan orang lain.',
                            Icons.done,
                            Colors.green,
                            () {});
                      } else {
                        _updateRelationship(-15);
                        _updateState();
                        _showResultDialog(
                            'Ditolak 🚫',
                            'Ayahmu menolak permintaanmu. Dia merasa masih membutuhkan pendamping hidup kelak.',
                            Icons.block,
                            Colors.red,
                            () {});
                      }
                    },
                    child: const Text('Bujuk Ayah',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ));
      }
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

      topActions.add(_buildAjakMasturbasiAction());

      // 2. Putuskan Pacar (hanya untuk pacar, bukan ceraikan pasangan)
      if (!isSpouse) {
        topActions.add(putuskanPacarAction);
      }

      // 3. Minta Cerai (jika target adalah ayah/ibu kandung/tiri yang sedang pacaran dengan anak dan pasangannya masih ada)
      final String myGenderLower = widget.character.gender.toLowerCase();
      final bool isDatingMother = (cleanRole.contains('ibu') || cleanName.contains('ibu')) &&
          !cleanRole.contains('tiri') && !cleanName.contains('tiri') &&
          widget.character.isAnyPartnerNameMatching(widget.targetName);
      final bool isDatingStepMother = (cleanRole.contains('tiri') || cleanName.contains('tiri')) &&
          (cleanRole.contains('ibu') || cleanName.contains('ibu')) &&
          widget.character.isAnyPartnerNameMatching(widget.targetName);

      final bool localIsFatherPartnerAndMotherTiriExists =
          myGenderLower == 'perempuan' &&
          isDatingBiologicalFather &&
          widget.character.stepMotherName != null &&
          !widget.character.isStepMotherDeceased;

      final bool localIsStepFatherPartnerAndMotherExists =
          myGenderLower == 'perempuan' &&
          isDatingStepFather &&
          widget.character.motherName != null &&
          !widget.character.isMotherDeceased;

      final bool isMotherPartnerAndFatherTiriExists = myGenderLower == 'laki-laki' &&
          isDatingMother && widget.character.stepFatherName != null && !widget.character.isStepFatherDeceased;
      final bool isStepMotherPartnerAndFatherExists = myGenderLower == 'laki-laki' &&
          isDatingStepMother && widget.character.fatherName != null && !widget.character.isFatherDeceased;

      final bool showMintaCerai = localIsFatherPartnerAndMotherTiriExists ||
          localIsStepFatherPartnerAndMotherExists ||
          isMotherPartnerAndFatherTiriExists ||
          isStepMotherPartnerAndFatherExists;

      if (showMintaCerai) {
        final String spouseName = (localIsFatherPartnerAndMotherTiriExists)
            ? (widget.character.stepMotherName ?? 'Ibu Tiri')
            : (localIsStepFatherPartnerAndMotherExists)
                ? (widget.character.motherName ?? 'Ibu Kandung')
                : (isMotherPartnerAndFatherTiriExists)
                    ? (widget.character.stepFatherName ?? 'Ayah Tiri')
                    : (widget.character.fatherName ?? 'Ayah Kandung');

        final String targetParentLabel = (localIsFatherPartnerAndMotherTiriExists || localIsStepFatherPartnerAndMotherExists) ? 'Ayah' : 'Ibu';

        topActions.add(ActionItem(
          label: 'Minta Cerai dengan $spouseName',
          icon: Icons.heart_broken,
          color: Colors.redAccent,
          onTap: () {
            final screenContext = context;
            showDialog(
              context: screenContext,
              builder: (confirmContext) => AlertDialog(
                title: const Text('Minta Cerai 💔', style: TextStyle(fontWeight: FontWeight.bold)),
                content: Text('Apakah kamu yakin ingin meminta ${targetParentLabel}mu untuk menceraikan $spouseName?'),
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
                        if (localIsFatherPartnerAndMotherTiriExists) {
                          widget.character.stepMotherName = null;
                          widget.character.stepMotherAge = null;
                          widget.character.stepMotherRelationship = null;
                        } else if (localIsStepFatherPartnerAndMotherExists) {
                          widget.character.motherName = null;
                          widget.character.motherAge = null;
                          widget.character.motherRelationship = null;
                        } else if (isMotherPartnerAndFatherTiriExists) {
                          widget.character.stepFatherName = null;
                          widget.character.stepFatherAge = null;
                          widget.character.stepFatherRelationship = null;
                        } else if (isStepMotherPartnerAndFatherExists) {
                          widget.character.fatherName = null;
                          widget.character.fatherAge = null;
                          widget.character.fatherRelationship = null;
                        }

                        final String msg = '💔 ${targetParentLabel}mu memutuskan untuk menceraikan $spouseName atas permintaanmu!';
                        widget.character.inbox.add(msg);
                        _updateRelationship(15);
                        _updateState();

                        _showResultDialog(
                          'Sukses 💔',
                          '${targetParentLabel}mu menyetujui permintaanmu dan kini resmi menceraikan $spouseName.',
                          Icons.done,
                          Colors.green,
                          () {
                            Navigator.pop(screenContext); // Langsung tutup halaman agar ter-refresh otomatis di Hubungan & Keluarga
                          }
                        );
                      } else {
                        _updateRelationship(-15);
                        _updateState();
                        _showResultDialog(
                          'Ditolak 🚫',
                          '${targetParentLabel}mu menolak untuk menceraikan $spouseName. Ia berkata bahwa ia mencintaimu, namun tidak bisa menceraikan pasangannya.',
                          Icons.block,
                          Colors.red,
                          () {}
                        );
                      }
                    },
                    child: const Text('Ya, Minta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ));
      }

      // 4. Threesome (jika pacar >= 2)
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

    // --- TAMBAHAN: LAPORKAN PERSELINGKUHAN KEPADA PASANGAN SAH ---
    String getCleanName(String name) {
      return name.replaceAll(RegExp(r'.*\(|\)'), '').trim();
    }

    Map<String, String>? targetSpouse;
    final String cleanTargetName = getCleanName(widget.targetName).toLowerCase();
    
    // 1. Check in extended family
    for (var ext in widget.character.extendedFamily) {
      final String extClean = getCleanName(ext['name'] ?? '').toLowerCase();
      if (extClean == cleanTargetName) {
        if (ext['spouseId'] != null) {
          for (var spouse in widget.character.extendedFamily) {
            if (spouse['id'] == ext['spouseId']) {
              targetSpouse = spouse;
              break;
            }
          }
        }
        break;
      }
    }
    // 2. Check in parents
    if (widget.targetRole == 'Cerai' || widget.targetRole.contains('kandung') || widget.targetRole.contains('tiri') ||
        cleanTargetName.contains('ayah') || cleanTargetName.contains('ibu')) {
      if (cleanTargetName.contains('mother') || cleanTargetName.contains('ibu')) {
        if (widget.character.stepFatherName != null && !widget.character.isStepFatherDeceased) {
          targetSpouse = {'name': widget.character.stepFatherName!, 'relation': 'Ayah Tiri'};
        } else if (widget.character.fatherName != null && !widget.character.isFatherDeceased && !widget.character.isFatherDivorced) {
          targetSpouse = {'name': widget.character.fatherName!, 'relation': 'Ayah Kandung'};
        }
      } else if (cleanTargetName.contains('father') || cleanTargetName.contains('ayah')) {
        if (widget.character.stepMotherName != null && !widget.character.isStepMotherDeceased) {
          targetSpouse = {'name': widget.character.stepMotherName!, 'relation': 'Ibu Tiri'};
        } else if (widget.character.motherName != null && !widget.character.isMotherDeceased && !widget.character.isMotherDivorced) {
          targetSpouse = {'name': widget.character.motherName!, 'relation': 'Ibu Kandung'};
        }
      }
    }

    bool isCheatingSpouseDatingPlayer(String spouseName) {
      final List<Map<String, String>> allPartners = [];
      if (widget.character.partner != null) allPartners.add(widget.character.partner!);
      if (widget.character.secondPartner != null) allPartners.add(widget.character.secondPartner!);
      if (widget.character.thirdPartner != null) allPartners.add(widget.character.thirdPartner!);
      if (widget.character.fourthPartner != null) allPartners.add(widget.character.fourthPartner!);
      if (widget.character.fifthPartner != null) allPartners.add(widget.character.fifthPartner!);
      for (var sp in widget.character.secretPartners) {
        allPartners.add(sp);
      }
      
      final String cleanSpouse = spouseName.replaceAll(RegExp(r'.*\(|\)'), '').trim().toLowerCase();
      for (var p in allPartners) {
        final String pName = (p['name'] ?? '').toLowerCase();
        final String cleanP = pName.replaceAll(RegExp(r'.*\(|\)'), '').trim().toLowerCase();
        if (cleanP == cleanSpouse || pName.contains(cleanSpouse) || cleanSpouse.contains(cleanP)) {
          return true;
        }
      }
      return false;
    }

    if (targetSpouse != null) {
      final String spouseName = targetSpouse['name'] ?? '';
      final String spouseRelation = targetSpouse['relation'] ?? 'Pasangan';
      
      // If we are currently interacting with the cheating partner (who is our partner)
      final bool isReportingSelf = isActivePartner;
      
      // We can report if either the target is the cheater, or target is the victim and spouse is the cheater
      final bool showReport = isReportingSelf || isCheatingSpouseDatingPlayer(spouseName);
      
      if (showReport) {
        actions.add(ActionItem(
          label: isReportingSelf
              ? 'Laporkan Hubungan Kalian ke $spouseRelation'
              : 'Laporkan Perselingkuhan $spouseName',
          icon: Icons.campaign,
          color: Colors.orange,
          onTap: () {
            final String cleanSpouse = getCleanName(spouseName);
            final String cleanTarget = getCleanName(widget.targetName);

            // 1. Break up relationship with the cheating partner
            final String cheaterName = isReportingSelf ? cleanTarget : cleanSpouse;
            final String lowerCheater = cheaterName.toLowerCase();
            if (widget.character.partner != null && getCleanName(widget.character.partner!['name'] ?? '').toLowerCase() == lowerCheater) {
              widget.character.partner = null;
            } else if (widget.character.secondPartner != null && getCleanName(widget.character.secondPartner!['name'] ?? '').toLowerCase() == lowerCheater) {
              widget.character.secondPartner = null;
            } else if (widget.character.thirdPartner != null && getCleanName(widget.character.thirdPartner!['name'] ?? '').toLowerCase() == lowerCheater) {
              widget.character.thirdPartner = null;
            } else if (widget.character.fourthPartner != null && getCleanName(widget.character.fourthPartner!['name'] ?? '').toLowerCase() == lowerCheater) {
              widget.character.fourthPartner = null;
            } else if (widget.character.fifthPartner != null && getCleanName(widget.character.fifthPartner!['name'] ?? '').toLowerCase() == lowerCheater) {
              widget.character.fifthPartner = null;
            }
            widget.character.secretPartners.removeWhere((p) => getCleanName(p['name'] ?? '').toLowerCase() == lowerCheater);
            if (widget.character.secretPartners.isEmpty && widget.character.secondPartner == null) {
              widget.character.isHavingAffair = false;
            }

            // 2. Divorce / break spouse connection
            if (widget.character.fatherName != null && widget.character.fatherName!.toLowerCase() == lowerCheater) {
              widget.character.isFatherDivorced = true;
              widget.character.stepMotherName = null;
            } else if (widget.character.motherName != null && widget.character.motherName!.toLowerCase() == lowerCheater) {
              widget.character.isMotherDivorced = true;
              widget.character.stepFatherName = null;
            } else if (widget.character.stepFatherName != null && widget.character.stepFatherName!.toLowerCase() == lowerCheater) {
              widget.character.stepFatherName = null;
            } else if (widget.character.stepMotherName != null && widget.character.stepMotherName!.toLowerCase() == lowerCheater) {
              widget.character.stepMotherName = null;
            }

            // If it's extendedFamily:
            String spouseId = '';
            for (var ext in widget.character.extendedFamily) {
              final String extClean = getCleanName(ext['name'] ?? '').toLowerCase();
              if (extClean == cleanTarget.toLowerCase()) {
                spouseId = ext['spouseId'] ?? '';
                ext['spouseId'] = '';
                ext['relation'] = ext['relation']?.replaceAll(RegExp(r'Pasangan\s*'), '').trim() ?? '';
              }
            }
            if (spouseId.isNotEmpty) {
              widget.character.extendedFamily.removeWhere((ext) => ext['id'] == spouseId);
            }

            // 3. Update relationship with Y (the victim)
            final String victimName = isReportingSelf ? spouseName : widget.targetName;
            final String cleanVictim = getCleanName(victimName);
            final String lowerVictim = cleanVictim.toLowerCase();
            
            if (widget.character.fatherName != null && widget.character.fatherName!.toLowerCase() == lowerVictim) {
              widget.character.fatherRelationship = ((widget.character.fatherRelationship ?? 50) + 20).clamp(0, 100);
            } else if (widget.character.motherName != null && widget.character.motherName!.toLowerCase() == lowerVictim) {
              widget.character.motherRelationship = ((widget.character.motherRelationship ?? 50) + 20).clamp(0, 100);
            } else if (widget.character.stepFatherName != null && widget.character.stepFatherName!.toLowerCase() == lowerVictim) {
              widget.character.stepFatherRelationship = ((widget.character.stepFatherRelationship ?? 50) + 20).clamp(0, 100);
            } else if (widget.character.stepMotherName != null && widget.character.stepMotherName!.toLowerCase() == lowerVictim) {
              widget.character.stepMotherRelationship = ((widget.character.stepMotherRelationship ?? 50) + 20).clamp(0, 100);
            } else {
              for (var ext in widget.character.extendedFamily) {
                final String extClean = getCleanName(ext['name'] ?? '').toLowerCase();
                if (extClean == lowerVictim) {
                  int currentRel = int.tryParse(ext['relationship'] ?? '50') ?? 50;
                  ext['relationship'] = (currentRel + 20).clamp(0, 100).toString();
                  break;
                }
              }
            }

            _updateState();

            final String victimTitle = isReportingSelf ? spouseRelation : _getDetailedRelationLabel();
            _showResultDialog(
              'Laporan Perselingkuhan 📢',
              'Kamu melaporkan bahwa $cheaterName berselingkuh/berpacaran denganmu kepada $victimTitle ($cleanVictim). '
              'Dia sangat terkejut, berterima kasih atas kejujuranmu, dan langsung memutuskan hubungan dengan $cheaterName! Hubunganmu dengan $cleanVictim membaik (+20%).',
              Icons.campaign,
              Colors.orange,
              () {
                if (isReportingSelf) {
                  Navigator.pop(context);
                }
              }
            );
          },
        ));
      }
    }

    if (topActions.isNotEmpty) {
      // Hapus duplikasi tombol bercinta dan ajak masturbasi dari list bawah
      actions.removeWhere((act) => act.label == 'Bercinta / Make Love' || act.label == 'Ajak Masturbasi Bersama');
      actions.insertAll(0, topActions);
    }

    // --- TAMBAHAN TOMBOL SEKOLAHKAN ANAK ---
    final bool isChildTarget = isChild || widget.targetRole == 'Anak' || cleanRoleLower == 'anak' || cleanRoleLower == 'laki-laki' || cleanRoleLower == 'perempuan';
    if (isChildTarget) {
      Map<String, String>? childData;
      final String cleanSearchTarget = getCleanName(widget.targetName).replaceAll(' (Wafat)', '').trim().toLowerCase();
      for (var c in widget.character.children) {
        final String cleanCName = getCleanName(c['name'] ?? '').replaceAll(' (Wafat)', '').trim().toLowerCase();
        if (cleanCName == cleanSearchTarget || cleanSearchTarget.contains(cleanCName) || cleanCName.contains(cleanSearchTarget)) {
          childData = c;
          break;
        }
      }
      if (childData != null) {
        final int childAge = int.tryParse(childData['age'] ?? '0') ?? 0;
        final String schoolStatusSD = childData['schoolSD'] ?? 'Belum Sekolah';
        final String schoolStatusSMP = childData['schoolSMP'] ?? 'Belum Sekolah';
        final String schoolStatusSMA = childData['schoolSMA'] ?? 'Belum Sekolah';

        bool canEnroll = false;
        String schoolLevel = '';
        if (childAge >= 6 && childAge < 12 && schoolStatusSD != 'Sekolah Negeri' && schoolStatusSD != 'Sekolah Swasta') {
          canEnroll = true;
          schoolLevel = 'SD';
        } else if (childAge >= 12 && childAge < 15 && schoolStatusSMP != 'Sekolah Negeri' && schoolStatusSMP != 'Sekolah Swasta') {
          canEnroll = true;
          schoolLevel = 'SMP';
        } else if (childAge >= 15 && childAge < 18 && schoolStatusSMA != 'Sekolah Negeri' && schoolStatusSMA != 'Sekolah Swasta') {
          canEnroll = true;
          schoolLevel = 'SMA';
        }

        if (canEnroll) {
          actions.add(ActionItem(
            label: 'Sekolahkan Anak 🏫',
            icon: Icons.school,
            color: Colors.indigo,
            onTap: () {
              final screenContext = context;
              final isDark = Theme.of(screenContext).brightness == Brightness.dark;
              showDialog(
                context: screenContext,
                barrierDismissible: false,
                builder: (dialogContext) => PopScope(
                  canPop: false,
                  child: AlertDialog(
                  backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
                  title: Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pendaftaran Sekolah $schoolLevel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'Anakmu, ${widget.targetName}, telah memasuki usia $childAge tahun dan siap untuk masuk ke Sekolah $schoolLevel. Pilih jenis sekolah:',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  actions: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            childData!['school$schoolLevel'] = 'Sekolah Negeri';
                            _updateRelationship(15);
                            _updateState();
                            _showResultDialog(
                              'Pendaftaran Sukses 🎓',
                              'Kamu berhasil menyekolahkan ${widget.targetName} ke Sekolah Negeri ($schoolLevel) secara gratis. Anakmu senang sekali!',
                              Icons.done,
                              Colors.green,
                              () {}
                            );
                          },
                          child: const Text('🏫 Sekolah Negeri (Gratis)', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            if (widget.character.money < 1500) {
                              _showResultDialog(
                                'Uang Tidak Cukup 💸',
                                'Kamu tidak memiliki cukup uang untuk menyekolahkan anakmu ke Sekolah Swasta (\$1,500).',
                                Icons.block,
                                Colors.red,
                                () {}
                              );
                            } else {
                              widget.character.money -= 1500;
                              childData!['school$schoolLevel'] = 'Sekolah Swasta';
                              _updateRelationship(25);
                              _updateState();
                              _showResultDialog(
                                'Pendaftaran Sukses 🎓',
                                'Kamu membayar \$1,500 untuk menyekolahkan ${widget.targetName} ke Sekolah Swasta Unggulan ($schoolLevel). Kecerdasan anakmu bertambah! (+25% hubungan)',
                                Icons.done,
                                Colors.purple,
                                () {}
                              );
                            }
                          },
                          child: const Text('🏛️ Sekolah Swasta (\$1,500)', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              );
            },
          ));
        }

        // --- TOMBOL GAYA PENGASUHAN ---
        final String currentStyle = widget.character.parentingStyles[widget.targetName] ?? 'Balanced';
        final Map<String, Map<String, dynamic>> stylesData = {
          'Strict': {
            'emoji': '🗡️',
            'color': Colors.red.shade700,
            'desc': 'Keras & Disiplin — Kecerdasan naik, Kebahagiaan turun. Risiko anak kabur tinggi.',
          },
          'Balanced': {
            'emoji': '⚖️',
            'color': Colors.blue.shade600,
            'desc': 'Seimbang & Otoritatif — Semua statistik berkembang merata.',
          },
          'Loose': {
            'emoji': '🕊️',
            'color': Colors.green.shade600,
            'desc': 'Bebas & Permisif — Kebahagiaan sangat tinggi, Disiplin rendah.',
          },
          'Neglectful': {
            'emoji': '👻',
            'color': Colors.grey.shade600,
            'desc': 'Abai — Anak lebih mandiri tapi rentan kenakalan.',
          },
        };

        actions.add(ActionItem(
          label: 'Gaya Pengasuhan: $currentStyle ${stylesData[currentStyle]?['emoji'] ?? ''}',
          icon: Icons.family_restroom,
          color: (stylesData[currentStyle]?['color'] as Color?) ?? Colors.blue,
          onTap: () {
            final screenContext = context;
            final isDark = Theme.of(screenContext).brightness == Brightness.dark;
            showDialog(
              context: screenContext,
              barrierDismissible: true,
              builder: (dialogContext) {
                String selectedStyle = currentStyle;
                return StatefulBuilder(
                  builder: (ctx, setModalState) => AlertDialog(
                    backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
                    title: Row(
                      children: [
                        const Icon(Icons.family_restroom, color: Colors.teal),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Terapkan Gaya Pengasuhan',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        // X BUTTON
                        IconButton(
                          icon: Icon(Icons.close, color: isDark ? Colors.white54 : Colors.black45, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ],
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: stylesData.entries.map((entry) {
                          final String styleKey = entry.key;
                          final String emoji = entry.value['emoji'] as String;
                          final Color styleColor = entry.value['color'] as Color;
                          final String desc = entry.value['desc'] as String;
                          final bool isSelected = selectedStyle == styleKey;
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedStyle = styleKey),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? styleColor.withOpacity(0.15)
                                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? styleColor : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(emoji, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          styleKey,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? styleColor : (isDark ? Colors.white : Colors.black87),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          desc,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? Colors.white54 : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(Icons.check_circle, color: styleColor, size: 20),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (stylesData[selectedStyle]?['color'] as Color?) ?? Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              widget.character.parentingStyles[widget.targetName] = selectedStyle;

                              // Efek gaya asuh pada statistik anak
                              if (childData != null) {
                                switch (selectedStyle) {
                                  case 'Strict':
                                    final int rel = int.tryParse(childData['relationship'] ?? '80') ?? 80;
                                    childData['relationship'] = (rel - 10).clamp(0, 100).toString();
                                    break;
                                  case 'Balanced':
                                    break;
                                  case 'Loose':
                                    final int relL = int.tryParse(childData['relationship'] ?? '80') ?? 80;
                                    childData['relationship'] = (relL + 10).clamp(0, 100).toString();
                                    break;
                                  case 'Neglectful':
                                    final int relN = int.tryParse(childData['relationship'] ?? '80') ?? 80;
                                    childData['relationship'] = (relN - 15).clamp(0, 100).toString();
                                    break;
                                }
                              }

                              _updateState();
                              final String newEmoji = stylesData[selectedStyle]?['emoji'] as String? ?? '';
                              _showResultDialog(
                                'Gaya Asuh Diterapkan $newEmoji',
                                'Kamu menerapkan gaya pengasuhan $selectedStyle untuk ${widget.targetName}. Efeknya akan terasa seiring berjalannya waktu.',
                                Icons.check_circle,
                                (stylesData[selectedStyle]?['color'] as Color?) ?? Colors.blue,
                                () {},
                              );
                            },
                            child: const Text('Terapkan', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));

        // --- AKSI PENGASUHAN KHUSUS ---
        if (childAge >= 3) {
          // Marahi Anak (Strict)
          actions.add(ActionItem(
            label: 'Marahi Anak 😠',
            icon: Icons.record_voice_over,
            color: Colors.red.shade700,
            onTap: () {
              final int relChange = -(_random.nextInt(10) + 5);
              final String result;
              if (currentStyle == 'Strict') {
                result = '${widget.targetName} menundukkan kepala, patuh walaupun tampak ketakutan. Disiplin meningkat tapi hubungan menurun ($relChange%).';  
              } else if (currentStyle == 'Loose') {
                result = '${widget.targetName} justru menangis dan marah balik! Hubungan menurun lebih drastis (${relChange * 2}%).';
              } else {
                result = '${widget.targetName} terdiam dan menuruti kemauanmu. Hubungan sedikit menurun ($relChange%).';
              }
              _showResultDialog(
                'Marahi Anak 😠',
                result,
                Icons.record_voice_over,
                Colors.red.shade700,
                () {
                  final int actualChange = currentStyle == 'Loose' ? relChange * 2 : relChange;
                  _updateRelationship(actualChange);
                  _updateState();
                },
              );
            },
          ));

          // Beri Hadiah (Loose)
          actions.add(ActionItem(
            label: 'Beri Hadiah 🎁',
            icon: Icons.card_giftcard,
            color: Colors.orange.shade700,
            onTap: () {
              if (widget.character.money < 50) {
                _showResultDialog(
                  'Uang Tidak Cukup',
                  'Kamu tidak memiliki cukup uang untuk membeli hadiah (\$50).',
                  Icons.money_off,
                  Colors.red,
                  () {},
                );
                return;
              }
              final int relGain = _random.nextInt(10) + 10;
              final String result;
              if (currentStyle == 'Loose') {
                result = '${widget.targetName} sangat gembira menerima hadiahmu! Hubungan naik drastis (+${relGain + 5}%).';
              } else if (currentStyle == 'Strict') {
                result = '${widget.targetName} menerima hadiah dengan sopan, tapi tidak terlalu ekspresif. Hubungan naik sedikit (+${relGain ~/ 2}%).';
              } else {
                result = '${widget.targetName} langsung memelukmu karena senang! Hubungan naik (+$relGain%).';
              }
              _showResultDialog(
                'Beri Hadiah 🎁',
                result,
                Icons.card_giftcard,
                Colors.orange.shade700,
                () {
                  widget.character.money -= 50;
                  final int actual = currentStyle == 'Loose' ? relGain + 5 : currentStyle == 'Strict' ? relGain ~/ 2 : relGain;
                  _updateRelationship(actual);
                  _updateState();
                },
              );
            },
          ));

          // Ajak Diskusi (Balanced)
          actions.add(ActionItem(
            label: 'Ajak Diskusi 💬',
            icon: Icons.forum,
            color: Colors.blue.shade600,
            onTap: () {
              final int relGain = _random.nextInt(5) + 5;
              final String result;
              if (currentStyle == 'Balanced') {
                result = '${widget.targetName} terbuka dan menikmati diskusi bersamamu. Hubungan dan kecerdasan meningkat (+$relGain%).';
              } else if (currentStyle == 'Strict') {
                result = '${widget.targetName} mendengarkan dengan serius, tapi tidak banyak berbicara. Hubungan sedikit naik (+${relGain ~/ 2}%).';
              } else {
                result = '${widget.targetName} malah mengajakmu bermain daripada berdiskusi serius, tapi tetap menyenangkan! Hubungan naik (+$relGain%).';
              }
              _showResultDialog(
                'Ajak Diskusi 💬',
                result,
                Icons.forum,
                Colors.blue.shade600,
                () {
                  final int actual = currentStyle == 'Strict' ? relGain ~/ 2 : relGain;
                  _updateRelationship(actual);
                  widget.character.intelligence = (widget.character.intelligence + 2).clamp(0, 100);
                  _updateState();
                },
              );
            },
          ));
        }

        // Tampilkan Opsi Arah Hidup jika anak berusia >= 18 tahun dan berstatus Pengangguran
        final String choice18 = childData['choice18'] ?? 'Belum';
        if (childAge >= 18 && (choice18 == 'Biarkan' || choice18 == 'Belum' || choice18 == 'Suruh Nikah')) {
          actions.add(ActionItem(
            label: 'Suruh Kuliah 🎓',
            icon: Icons.school,
            color: Colors.blue.shade700,
            onTap: () {
              final List<String> allMajors = [
                'Teknik Informatika', 'Sistem Informasi', 'Teknik Sipil', 'Teknik Elektro', 'Teknik Mesin', 'Arsitektur',
                'Kedokteran', 'Farmasi', 'Keperawatan',
                'Manajemen', 'Akuntansi', 'Perbankan & Keuangan',
                'Hukum', 'Hubungan Internasional', 'Ilmu Komunikasi', 'Psikologi'
              ];
              final String randomMajor = allMajors[Random().nextInt(allMajors.length)];

              childData!['choice18'] = 'Suruh Kuliah';
              childData['schoolSD'] = 'Kuliah';
              childData['schoolSMP'] = 'Kuliah';
              childData['schoolSMA'] = 'Kuliah';
              childData['univMajor'] = randomMajor;
              widget.character.inbox.add('🎓 Arah Hidup: Kamu menyuruh ${widget.targetName} untuk melanjutkan pendidikan ke jenjang Kuliah (Jurusan $randomMajor).');
              _updateRelationship(15);
              _updateState();
              _showResultDialog(
                'Keputusan Kuliah 🎓',
                '${widget.targetName} menuruti saranmu dan mendaftarkan diri ke Universitas mengambil jurusan $randomMajor! Hubungan meningkat (+15% hubungan).',
                Icons.done,
                Colors.blue.shade700,
                () {}
              );
            },
          ));

          actions.add(ActionItem(
            label: 'Suruh Kerja 💼',
            icon: Icons.work,
            color: Colors.green.shade700,
            onTap: () {
              childData!['choice18'] = 'Suruh Kerja';
              childData['schoolSD'] = 'Bekerja';
              childData['schoolSMP'] = 'Bekerja';
              childData['schoolSMA'] = 'Bekerja';
              widget.character.inbox.add('💼 Arah Hidup: Kamu menyuruh ${widget.targetName} untuk mulai bekerja mencari nafkah.');
              _updateRelationship(10);
              _updateState();
              _showResultDialog(
                'Keputusan Kerja 💼',
                '${widget.targetName} mulai menyusun curriculum vitae (CV) dan mencari pekerjaan lowongan terdekat. Hubungan meningkat (+10% hubungan).',
                Icons.done,
                Colors.green.shade700,
                () {}
              );
            },
          ));

          actions.add(ActionItem(
            label: 'Suruh Nikah 💍',
            icon: Icons.favorite,
            color: Colors.pink.shade600,
            onTap: () {
              childData!['choice18'] = 'Suruh Nikah';
              widget.character.inbox.add('💍 Arah Hidup: Kamu menyuruh ${widget.targetName} untuk segera mencari pasangan hidup dan menikah.');
              _updateRelationship(-5);
              _updateState();
              _showResultDialog(
                'Suruh Nikah 💍',
                '${widget.targetName} merasa tertekan atas permintaan menikah muda ini, namun setuju untuk mulai menjalin asmara. Hubungan sedikit menurun (-5% hubungan).',
                Icons.done,
                Colors.pink.shade600,
                () {}
              );
            },
          ));
        }
      }
    }

    actions.removeWhere((act) {
      if (act.label == 'Ajak Masturbasi Bersama' && !AdultFeatures.canMasturbateTogether()) {
        return true;
      }
      if (act.label == 'Bercinta / Make Love') {
        final String roleLower = widget.targetRole.toLowerCase();
        if (roleLower == 'istri' || roleLower == 'suami' || roleLower == 'pasangan') {
          return false; // Selalu boleh bercinta dengan pasangan sah (tidak dihapus)
        }
        if (!AdultFeatures.canMakeLove(
          userAge: widget.character.age,
          role: widget.targetRole,
          relation: widget.targetRole,
        )) {
          return true;
        }
      }
      return false;
    });
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

    // Cek apakah target berada di negara yang sama dengan pemain
    bool isDifferentCountry = false;
    Map<String, String>? currentPartnerMap;
    final List<Map<String, String>> allPartners = [];
    if (widget.character.partner != null) allPartners.add(widget.character.partner!);
    if (widget.character.secondPartner != null) allPartners.add(widget.character.secondPartner!);
    if (widget.character.thirdPartner != null) allPartners.add(widget.character.thirdPartner!);
    if (widget.character.fourthPartner != null) allPartners.add(widget.character.fourthPartner!);
    if (widget.character.fifthPartner != null) allPartners.add(widget.character.fifthPartner!);
    for (var p in allPartners) {
      if (p['name'] == widget.targetName || widget.targetName.contains(p['name'] ?? '___')) {
        currentPartnerMap = p;
        break;
      }
    }
    
    if (currentPartnerMap != null) {
      final String partnerLoc = currentPartnerMap['location'] ?? widget.character.birthCountry ?? 'Indonesia';
      if (widget.character.location.toLowerCase() != partnerLoc.toLowerCase()) {
        isDifferentCountry = true;
      }
    } else {
      final String _cleanNameLocal = widget.targetName.toLowerCase();
      final String _cleanRoleLocal = widget.targetRole.toLowerCase();
      final bool _isFatherOrMother = _cleanNameLocal.contains('ayah') ||
          _cleanNameLocal.contains('ibu') ||
          _cleanRoleLocal.contains('ayah') ||
          _cleanRoleLocal.contains('ibu');
      final bool _isSiblingEntry = widget.character.siblings.any((sib) =>
          '${sib['name']} (${sib['relation']})'.toLowerCase() == _cleanNameLocal ||
          sib['name']!.toLowerCase() == _cleanNameLocal);
      final Map<String, String> _extMember = widget.character.extendedFamily.firstWhere(
        (ext) => ext['name'] == widget.targetName || widget.targetName.contains(ext['name'] ?? ''),
        orElse: () => <String, String>{},
      );
      final bool _isExtendedEntry = _extMember.isNotEmpty;
      final bool isTargetFamily = _isFatherOrMother || _isSiblingEntry || _isExtendedEntry;
      if (isTargetFamily) {
        if (widget.character.location.toLowerCase() != (widget.character.birthCountry ?? 'Indonesia').toLowerCase()) {
          isDifferentCountry = true;
        }
      }
    }

    if (isDifferentCountry) {
      actions.removeWhere((act) {
        final String l = act.label.toLowerCase();
        final bool isAllowed = l.contains('minta uang') ||
            l.contains('pujian') ||
            l.contains('percakapan') ||
            l.contains('video call') ||
            l.contains('menyinggung');
        return !isAllowed;
      });

      final String targetLocName = widget.character.location;
      actions.insert(
        0,
        ActionItem(
          label: 'Ajak Pindah ke $targetLocName ✈️',
          icon: Icons.flight_takeoff,
          color: Colors.blueAccent,
          onTap: () {
            final String cleanRole = widget.targetRole.toLowerCase();
            final String cleanName = widget.targetName.toLowerCase();
            final bool isAdik = cleanRole.contains('adik') || cleanName.contains('adik');

            if (isAdik && targetAge < 12) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.block, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Belum Cukup Umur 👶', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  content: Text('Adikmu (${widget.targetName}) masih berusia $targetAge tahun. Adik harus berusia minimal 12 tahun untuk bisa diajak pindah ke luar negeri secara mandiri.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return;
            }

            int chance = 50; // default chance
            if (cleanRole.contains('ayah') || cleanRole.contains('ibu') || cleanName.contains('ayah') || cleanName.contains('ibu')) {
              chance = 40;
            } else if (isAdik) {
              chance = 45;
            } else if (cleanRole.contains('kakak') || cleanName.contains('kakak')) {
              chance = 60;
            } else if (isActivePartner || cleanRole.contains('pacar') || cleanRole.contains('suami') || cleanRole.contains('istri')) {
              chance = 60;
            }

            final bool accept = _random.nextInt(100) < chance;

            if (accept) {
              if (currentPartnerMap != null) {
                currentPartnerMap['location'] = widget.character.location;
                if (widget.character.currentCity != null) {
                  currentPartnerMap['currentCity'] = widget.character.currentCity!;
                  currentPartnerMap['city'] = widget.character.currentCity!;
                }
              } else {
                final Map<String, String> sibMap = widget.character.siblings.firstWhere(
                  (sib) => '${sib['name']} (${sib['relation']})'.toLowerCase() == cleanName || sib['name']!.toLowerCase() == cleanName,
                  orElse: () => <String, String>{},
                );
                if (sibMap.isNotEmpty) {
                  sibMap['location'] = widget.character.location;
                  if (widget.character.currentCity != null) {
                    sibMap['currentCity'] = widget.character.currentCity!;
                    sibMap['city'] = widget.character.currentCity!;
                  }
                } else {
                  final Map<String, String> extMap = widget.character.extendedFamily.firstWhere(
                    (ext) => ext['name'] == widget.targetName || widget.targetName.contains(ext['name'] ?? ''),
                    orElse: () => <String, String>{},
                  );
                  if (extMap.isNotEmpty) {
                    extMap['location'] = widget.character.location;
                    if (widget.character.currentCity != null) {
                      extMap['currentCity'] = widget.character.currentCity!;
                      extMap['city'] = widget.character.currentCity!;
                    }
                  }
                }
              }

              _updateRelationship(15);
              final String userCityStr = widget.character.currentCity != null ? '${widget.character.currentCity}, ' : '';
              widget.character.inbox.add('✈️ ${widget.targetName} menerima ajakanmu dan resmi pindah ke $userCityStr${widget.character.location}!');

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.flight_land, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Ajakan Diterima! ✈️', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  content: Text('${widget.targetName} setuju dan memutuskan untuk pindah tinggal bersamamu di $userCityStr${widget.character.location}! (+15% Hubungan)'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _updateState();
                      },
                      child: const Text('OK'),
                    )
                  ],
                ),
              );
            } else {
              _updateRelationship(-5);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.block, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Ajakan Ditolak ❌', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  content: Text('${widget.targetName} menolak ajakanmu untuk pindah ke ${widget.character.location}. ${widget.targetName} memilih untuk tetap tinggal di tempat asalnya saat ini.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _updateState();
                      },
                      child: const Text('OK'),
                    )
                  ],
                ),
              );
            }
          },
        ),
      );
    }


    // Pindahkan Minta Cerai / Minta Tidak Menikah Lagi ke posisi dinamis
    final List<ActionItem> matchingActs = [];
    for (var act in actions) {
      if (act.label.contains('Minta Cerai') || act.label.contains('Minta Tidak Menikah Lagi')) {
        matchingActs.add(act);
      }
    }
    for (var act in matchingActs) {
      actions.remove(act);
    }
    if (matchingActs.isNotEmpty) {
      int insertIndex = isActivePartner ? 2 : 1;
      for (var act in matchingActs.reversed) {
        actions.insert(insertIndex.clamp(0, actions.length), act);
      }
    }

    final int relationshipVal = _getCurrentRelationshipValue();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetName),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Card Info
            Card(
              elevation: 0,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
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
                                  final String plainName = _getPlainTargetName().toLowerCase().trim();
                                  final String rawName = widget.targetName.toLowerCase().trim();
                                  if (widget.character.motherName != null) {
                                    final String mName = widget.character.motherName!.toLowerCase().trim();
                                    if (plainName.contains(mName) || rawName.contains(mName) || mName.contains(plainName)) {
                                      return widget.character.motherSkinColor;
                                    }
                                  }
                                  if (widget.character.fatherName != null) {
                                    final String fName = widget.character.fatherName!.toLowerCase().trim();
                                    if (plainName.contains(fName) || rawName.contains(fName) || fName.contains(plainName)) {
                                      return widget.character.fatherSkinColor;
                                    }
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
                                  // Lookup NPC skinColor from lists
                                  final List<List<Map<String, dynamic>>> allLists = [
                                    widget.character.friends,
                                    widget.character.classmates,
                                    widget.character.univClassmates,
                                    widget.character.coworkers,
                                    widget.character.siblings,
                                    widget.character.extendedFamily,
                                    widget.character.children,
                                    widget.character.idolTrainees,
                                    widget.character.idolMainMembers,
                                    widget.character.idolStaff,
                                  ];
                                  for (var list in allLists) {
                                    for (var item in list) {
                                      final String n = (item['name'] ?? '').toString().toLowerCase().trim();
                                      if (n.isNotEmpty && (plainName.contains(n) || n.contains(plainName) || rawName.contains(n))) {
                                        if (item['skinColor'] != null && item['skinColor'].toString().isNotEmpty) {
                                          return item['skinColor'].toString();
                                        }
                                      }
                                    }
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
                              Builder(builder: (context) {
                                final currentYear = widget.character.currentDate?.year ?? widget.character.birthDate?.year ?? DateTime.now().year;
                                final birthYear = currentYear - targetAge;
                                return Text(
                                  'Tanggal Lahir: 4 September $birthYear',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey.shade600,
                                  ),
                                );
                              }),
                              const SizedBox(height: 2),
                              Text(widget.targetName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87)),
                              const SizedBox(height: 2),
                              Builder(builder: (context) {
                                String npcLocation = widget.character.birthCountry ?? 'Indonesia';
                                String? npcCity = widget.character.birthCity;
                                
                                if (currentPartnerMap != null && currentPartnerMap['location'] != null) {
                                  npcLocation = currentPartnerMap['location']!;
                                  npcCity = currentPartnerMap['currentCity'] ?? currentPartnerMap['city'];
                                } else {
                                  final String cName = widget.targetName.toLowerCase();
                                  final Map<String, String> sibMap = widget.character.siblings.firstWhere(
                                    (sib) => '${sib['name']} (${sib['relation']})'.toLowerCase() == cName || sib['name']!.toLowerCase() == cName,
                                    orElse: () => <String, String>{},
                                  );
                                  if (sibMap.isNotEmpty) {
                                    npcLocation = sibMap['location'] ?? widget.character.birthCountry ?? 'Indonesia';
                                    npcCity = sibMap['currentCity'] ?? sibMap['city'] ?? widget.character.birthCity;
                                  } else {
                                    final Map<String, String> extMap = widget.character.extendedFamily.firstWhere(
                                      (ext) => ext['name'] == widget.targetName || widget.targetName.contains(ext['name'] ?? ''),
                                      orElse: () => <String, String>{},
                                    );
                                    if (extMap.isNotEmpty) {
                                      npcLocation = extMap['location'] ?? widget.character.birthCountry ?? 'Indonesia';
                                      npcCity = extMap['currentCity'] ?? extMap['city'] ?? widget.character.birthCity;
                                    }
                                  }
                                }

                                final String cityText = (npcCity != null && npcCity.isNotEmpty) ? '$npcCity, ' : '';

                                return Text(
                                  'Kebangsaan: ${widget.character.birthCountry ?? widget.character.location} • Tinggal di: $cityText$npcLocation',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }),
                              const SizedBox(height: 2),
                              Text(
                                'Hubungan: ${_getDetailedRelationLabel()} | Gender: ${_getTargetGender()} | Umur: ${_getCurrentAgeValue()}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white60 : Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Tingkat Hubungan: ',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationshipVal / 100,
                              backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
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
                          Text('Tingkat Kesuburan: ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fertilityVal / 100,
                                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
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

                      final jobInfo = widget.character.getNPCJobInfo(widget.targetName, widget.targetRole);
                      
                      // Dapatkan detail level sekolah/kuliah anggota keluarga
                      String detailSchool = 'Sekolah/Kuliah';
                      final String cleanRoleLower = widget.targetRole.toLowerCase();
                      final bool isChildTarget = cleanRoleLower == 'laki-laki' || cleanRoleLower == 'perempuan' || widget.targetRole == 'Anak';
                      
                      if (isChildTarget) {
                        Map<String, String>? childData;
                        for (var c in widget.character.children) {
                          if (c['name'] == widget.targetName || widget.targetName.startsWith(c['name'] ?? '___')) {
                            childData = c;
                            break;
                          }
                        }
                        if (childData != null) {
                          final int childAge = int.tryParse(childData['age'] ?? '0') ?? 0;
                          final String schoolSD = childData['schoolSD'] ?? 'Belum Sekolah';
                          final String schoolSMP = childData['schoolSMP'] ?? 'Belum Sekolah';
                          final String schoolSMA = childData['schoolSMA'] ?? 'Belum Sekolah';
                          final String choice18 = childData['choice18'] ?? 'Belum';
                          
                          if (schoolSD != 'Belum Sekolah' && schoolSD != '') {
                            detailSchool = 'Sekolah Dasar ($schoolSD)';
                          }
                          if (schoolSMP != 'Belum Sekolah' && schoolSMP != '') {
                            detailSchool = 'SMP ($schoolSMP)';
                          }
                          if (schoolSMA != 'Belum Sekolah' && schoolSMA != '') {
                            detailSchool = 'SMA ($schoolSMA)';
                          }
                          if (childAge >= 18) {
                            if (choice18 == 'Biarkan' || choice18 == 'Belum' || choice18 == 'Suruh Nikah') {
                              detailSchool = 'Pengangguran';
                            } else if (choice18 == 'Suruh Kuliah') {
                              final String major = childData['univMajor'] ?? 'Umum';
                              detailSchool = 'Kuliah ($major)';
                            } else if (choice18 == 'Suruh Kerja') {
                              detailSchool = 'Bekerja';
                            } else {
                              final String major = childData['univMajor'] ?? 'Umum';
                              detailSchool = 'Kuliah ($major)';
                            }
                          } else if (schoolSD == 'Belum Sekolah' && schoolSMP == 'Belum Sekolah' && schoolSMA == 'Belum Sekolah') {
                            detailSchool = 'Belum Sekolah';
                          }
                        }
                      } else {
                        // Untuk Saudara/Keluarga (Ayah, Ibu, Adik, Kakak, Sepupu, dll)
                        final int tAge = targetAge;
                        final String schoolTypeStr = (widget.targetName.hashCode % 2 == 0) ? 'Negeri' : 'Swasta';
                        
                        if (tAge < 6) {
                          detailSchool = 'Belum Sekolah';
                        } else if (tAge >= 6 && tAge <= 11) {
                          detailSchool = 'Sekolah Dasar ($schoolTypeStr)';
                        } else if (tAge >= 12 && tAge <= 14) {
                          detailSchool = 'SMP ($schoolTypeStr)';
                        } else if (tAge >= 15 && tAge <= 17) {
                          detailSchool = 'SMA ($schoolTypeStr)';
                        } else if (tAge >= 18 && tAge <= 22) {
                          final List<String> sampleMajors = [
                            'Teknik Informatika', 'Manajemen', 'Ilmu Hukum', 'Akuntansi', 
                            'Kedokteran', 'Psikologi', 'Ilmu Komunikasi', 'Teknik Sipil'
                          ];
                          final String majorName = sampleMajors[widget.targetName.hashCode.abs() % sampleMajors.length];
                          detailSchool = 'Kuliah ($majorName)';
                        } else {
                          detailSchool = 'Pengangguran / Lulus';
                        }
                      }

                      final String statusText = jobInfo['status'] == 'Sekolah/Kuliah'
                          ? 'Status Pendidikan: $detailSchool'
                          : 'Pekerjaan: ${jobInfo['job']} (Gaji: \$${jobInfo['salary']}/bln)';

                      // --- Status Hubungan Anak ---
                      String? childPartnerName;
                      String? childPartnerGender;
                      if (isChildTarget) {
                        Map<String, String>? cData;
                        for (var c in widget.character.children) {
                          if (c['name'] == widget.targetName || widget.targetName.startsWith(c['name'] ?? '___')) {
                            cData = c;
                            break;
                          }
                        }
                        if (cData != null) {
                          childPartnerName = cData['partnerName'];
                          childPartnerGender = cData['partnerGender'];
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Nilai Kekayaan: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : Colors.black87)),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progressVal,
                                    backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
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
                          ),
                          const SizedBox(height: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          if (isChildTarget) ...[ 
                            const SizedBox(height: 4),
                            childPartnerName != null && childPartnerName.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      // Navigasi ke ActionMenuScreen pasangan anak
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => ActionMenuScreen(
                                            character: widget.character,
                                            targetName: childPartnerName!,
                                            targetRole: childPartnerGender ?? 'Pacar',
                                          ),
                                        ),
                                      ).then((_) => _updateState());
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.favorite, size: 13, color: Colors.pink.shade400),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Status Hubungan: Berpacaran dengan ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isDark ? Colors.white60 : Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          childPartnerName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink.shade400,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.open_in_new, size: 11, color: Colors.pink.shade400),
                                      ],
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Icon(Icons.person_outline, size: 13, color: isDark ? Colors.white54 : Colors.black45),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Status Hubungan: Single',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white60 : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ],
                      );
                    }),
                    // --- BADGE HAMIL (di bawah tingkat kesuburan) ---
                    Builder(
                      builder: (context) {
                        final bool targetIsPregnant = widget.character.partnerIsPregnant &&
                            widget.character.pregnantByPartnerName == widget.targetName;
                        final bool playerIsPregnant = widget.character.isPregnant &&
                            widget.character.pregnantByPartnerName == widget.targetName;

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

            Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.grey,
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
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(action.icon, color: action.color),
                            title: Text(action.label,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87)),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 14, color: isDark ? Colors.white54 : Colors.grey),
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

  ActionItem _buildAjakMasturbasiAction() {
    if (!AdultFeatures.canMasturbateTogether()) {
      // Mengembalikan placeholder ActionItem dengan label kosong yang akan di-filter keluar atau tidak tampil.
      // Kita bisa buat visibility guard, atau melempar ActionItem khusus.
      // Tetapi cara paling aman adalah memeriksa AdultFeatures.canMasturbateTogether() saat tombol ditambahkan ke list.
    }
    return ActionItem(
      label: 'Ajak Masturbasi Bersama',
      icon: Icons.flash_on,
      color: Colors.purple,
      onTap: () {
        final String myGender = widget.character.gender.trim().toLowerCase();
        final String targetGender = _getTargetGender().trim().toLowerCase();
        
        final bool isGay = (myGender == 'laki-laki' && targetGender == 'laki-laki');
        final bool isLesbian = (myGender == 'perempuan' && targetGender == 'perempuan');

        if (widget.character.disableSameSexProposals && (isGay || isLesbian)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Aksi Diblokir 🚫'),
              content: Text(isGay 
                ? 'Kamu telah menonaktifkan ajakan gay di pengaturan karakter.' 
                : 'Kamu telah menonaktifkan ajakan lesbian di pengaturan karakter.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        int successChance = PersentaseAjakan.getSuccessChance(
          character: widget.character,
          relationType: widget.targetRole,
          viewerName: widget.targetName,
        );

        // Aturan khusus untuk user perempuan: auto-accept berdasarkan happiness
        final String myGenderLower = widget.character.gender.trim().toLowerCase();
        final String relLower2 = widget.targetRole.toLowerCase();
        if (myGenderLower == 'perempuan') {
          if (relLower2.contains('ayah') && widget.character.happiness > 70) {
            successChance = 100; // Ayah selalu menerima jika happiness > 70
          } else if (!relLower2.contains('ayah') && widget.character.happiness > 60) {
            successChance = 100; // Selain ayah selalu menerima jika happiness > 60
          }
        }

        final bool success = _random.nextInt(100) < successChance;
        final String relLower = widget.targetRole.toLowerCase();
        final bool isParent = relLower == 'ayah' || relLower == 'ibu' || relLower == 'ayah tiri' || relLower == 'ibu tiri';

        if (success) {
          AjakanMasturbasiDialog.show(
            context: context,
            character: widget.character,
            relationType: widget.targetRole,
            viewerName: widget.targetName,
            targetGender: _getTargetGender(),
            isUserInitiated: true,
            onComplete: () {
              _updateState();
            },
          );
        } else {
          if (isParent) {
            widget.character.happiness = (widget.character.happiness - 50).clamp(0, 100);
            widget.character.money = (widget.character.money * 0.5).round();
            _updateRelationship(-100);
            widget.character.inbox.add('🚨 DIUSIR & DIPENJARA: Kamu diusir dari rumah dan polisi memenjarakanmu selama 3 tahun atas tindakan asusila!');
            
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Rayuan Ditolak (Tragedi) 🚨'),
                content: Text('${widget.targetRole} marah besar dan merasa sangat jijik! Kamu langsung diusir dari rumah, dan polisi dipanggil untuk menangkapmu. Kamu dipenjara selama 3 tahun (-50% Kebahagiaan, uangmu terpotong 50%, -100% Hubungan).'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateState();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            _updateRelationship(-20);
            widget.character.happiness = (widget.character.happiness - 15).clamp(0, 100);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Ajakan Ditolak ❌'),
                content: Text('${widget.targetName} menolak ajakanmu secara mentah-mentah karena merasa aneh dan canggung! (-20% Hubungan, -15% Kebahagiaan).'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateState();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}
