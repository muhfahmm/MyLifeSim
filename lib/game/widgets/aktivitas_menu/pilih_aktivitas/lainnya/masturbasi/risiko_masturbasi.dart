// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/risiko_masturbasi.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class RisikoMasturbasi {
  // Probabilitas ketahuan (dalam persen) berdasarkan lokasi
  static int getCatchChance(String location) {
    switch (location) {
      case 'Di Rumah':
        return 10;
      case 'Di Mobil':
        return 25;
      case 'Di Kantor':
        return 40;
      case 'Di Toilet Umum':
        return 15;
      default:
        return 10;
    }
  }

  // Daftar ruangan untuk lokasi yang memiliki sub-ruangan
  static List<String> getRoomsForLocation(String location) {
    if (location == 'Di Rumah') {
      return [
        'Kamar Tidur Utama',
        'Kamar Tidur Anak',
        'Ruang Tamu',
        'Kamar Mandi',
        'Dapur',
      ];
    } else if (location == 'Di Kantor') {
      return [
        'Ruang Kerja Pribadi',
        'Ruang Meeting',
        'Toilet Kantor',
        'Ruang Server',
        'Lift Kantor',
      ];
    } else {
      return [];
    }
  }

  // Efek tambahan jika ketahuan di lokasi tertentu
  static Map<String, dynamic> getRiskEffects(String location, Character character, String targetName, String relation) {
    final Random random = Random();
    Map<String, dynamic> effects = {
      'happinessDelta': -30,
      'healthDelta': 0,
      'intelligenceDelta': 0,
      'relationshipDelta': 0,
      'message': '',
    };

    // Pesan umum
    String viewer = random.nextBool() ? 'Ayah' : 'Ibu';
    if (character.siblings.isNotEmpty) {
      final livingSiblings = character.siblings.where((s) => s['isDeceased'] != 'true').toList();
      if (livingSiblings.isNotEmpty) {
        viewer = livingSiblings[random.nextInt(livingSiblings.length)]['relation'] ?? 'Saudara';
      }
    }

    // Pesan spesifik berdasarkan lokasi
    switch (location) {
      case 'Di Rumah':
        effects['message'] = '😱 KETAHUAN! Saat sedang asyik bermasturbasi di ruangan, $viewer tiba-tiba membuka pintu! Kamu sangat malu (-30% Kebahagiaan).';
        if (_isFamily(targetName, relation)) {
          effects['message'] = '😱 TRAGEDI MEMALUKAN! Saat membayangkan $targetName, $viewer memergokimu! Kecanggungan luar biasa (-30% Kebahagiaan).';
        }
        break;
      case 'Di Mobil':
        effects['message'] = '🚗 KETAHUAN! Seseorang mengetuk kaca mobil dan melihatmu! Kamu panik dan malu (-30% Kebahagiaan).';
        break;
      case 'Di Kantor':
        effects['message'] = '🏢 KETAHUAN! Rekan kerja atau atasan memergokimu di ruangan! Kamu bisa dipecat atau dipermalukan (-30% Kebahagiaan).';
        // Jika ketahuan di kantor, tambahkan penalti spesial
        effects['intelligenceDelta'] = -10; // kehilangan fokus
        effects['relationshipDelta'] = -10; // hubungan dengan rekan kerja menurun
        break;
      case 'Di Toilet Umum':
        effects['message'] = '🚽 KETAHUAN! Seseorang masuk ke toilet dan mendengar suaramu! Kamu sangat malu (-30% Kebahagiaan).';
        break;
      default:
        effects['message'] = '😱 KETAHUAN!';
    }

    // Jika fantasi keluarga, tambahkan efek kesehatan negatif
    if (_isFamily(targetName, relation)) {
      effects['healthDelta'] = -10;
      effects['message'] += ' Rasa bersalah dan trauma menurunkan kesehatanmu.';
    }

    return effects;
  }

  // Helper untuk mengecek apakah target keluarga
  static bool _isFamily(String name, String relation) {
    final String r = relation.toLowerCase();
    final String n = name.toLowerCase();
    return r == 'kandung' ||
        r == 'tiri' ||
        r.contains('saudara') ||
        n.contains('kakak') ||
        n.contains('adik') ||
        n.startsWith('ayah') ||
        n.startsWith('ibu');
  }
}