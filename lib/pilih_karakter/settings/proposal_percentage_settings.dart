// lib/pilih_karakter/settings/proposal_percentage_settings.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';

/// Class untuk menyimpan dan mengelola preferensi persentase ajakan NPC per-hubungan detail
/// Memisahkan persentase & toggle switch per-anggota antara Karakter Laki-laki dan Perempuan
class ProposalPercentageSettings {
  // =========================================================
  // --- TOGGLE SWITCH PER-ANGGOTA (FEMALE) ---
  // =========================================================
  static final ValueNotifier<bool> femaleAyahKandungEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleAyahTiriEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleAyahMertuaEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleIbuKandungEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleIbuTiriEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleIbuMertuaEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleKakakLakiEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleKakakPerempuanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleAdikLakiEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleAdikPerempuanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femalePamanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femalePasanganPamanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleBibiEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleSepupuEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleKakekEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleNenekEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleAnakKeponakanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleGuruDosenEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> femaleNonKeluargaLainEnabled = ValueNotifier<bool>(true);

  // =========================================================
  // --- PERSENTASE SLIDER (FEMALE) ---
  // =========================================================
  static final ValueNotifier<double> femaleAyahKandungPacaran = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> femaleAyahKandungMasturbasi = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> femaleAyahKandungMakeLove = ValueNotifier<double>(40.0);

  static final ValueNotifier<double> femaleAyahTiriPacaran = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> femaleAyahTiriMasturbasi = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> femaleAyahTiriMakeLove = ValueNotifier<double>(60.0);

  static final ValueNotifier<double> femaleAyahMertuaPacaran = ValueNotifier<double>(35.0);
  static final ValueNotifier<double> femaleAyahMertuaMasturbasi = ValueNotifier<double>(35.0);
  static final ValueNotifier<double> femaleAyahMertuaMakeLove = ValueNotifier<double>(35.0);

  static final ValueNotifier<double> femaleIbuKandungPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femaleIbuKandungMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femaleIbuKandungMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> femaleIbuTiriPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femaleIbuTiriMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femaleIbuTiriMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> femaleIbuMertuaPacaran = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleIbuMertuaMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleIbuMertuaMakeLove = ValueNotifier<double>(30.0);

  static final ValueNotifier<double> femaleKakakLakiPacaran = ValueNotifier<double>(45.0);
  static final ValueNotifier<double> femaleKakakLakiMasturbasi = ValueNotifier<double>(45.0);
  static final ValueNotifier<double> femaleKakakLakiMakeLove = ValueNotifier<double>(45.0);

  static final ValueNotifier<double> femaleKakakPerempuanPacaran = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleKakakPerempuanMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleKakakPerempuanMakeLove = ValueNotifier<double>(30.0);

  static final ValueNotifier<double> femaleAdikLakiPacaran = ValueNotifier<double>(45.0);
  static final ValueNotifier<double> femaleAdikLakiMasturbasi = ValueNotifier<double>(45.0);
  static final ValueNotifier<double> femaleAdikLakiMakeLove = ValueNotifier<double>(45.0);

  static final ValueNotifier<double> femaleAdikPerempuanPacaran = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> femaleAdikPerempuanMasturbasi = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> femaleAdikPerempuanMakeLove = ValueNotifier<double>(40.0);

  static final ValueNotifier<double> femalePamanPacaran = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femalePamanMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femalePamanMakeLove = ValueNotifier<double>(30.0);

  static final ValueNotifier<double> femalePasanganPamanPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femalePasanganPamanMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femalePasanganPamanMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> femaleBibiPacaran = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> femaleBibiMasturbasi = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> femaleBibiMakeLove = ValueNotifier<double>(25.0);

  static final ValueNotifier<double> femaleSepupuPacaran = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> femaleSepupuMasturbasi = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> femaleSepupuMakeLove = ValueNotifier<double>(40.0);

  static final ValueNotifier<double> femaleKakekPacaran = ValueNotifier<double>(15.0);
  static final ValueNotifier<double> femaleKakekMasturbasi = ValueNotifier<double>(15.0);
  static final ValueNotifier<double> femaleKakekMakeLove = ValueNotifier<double>(15.0);

  static final ValueNotifier<double> femaleNenekPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femaleNenekMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> femaleNenekMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> femaleAnakKeponakanPacaran = ValueNotifier<double>(65.0);
  static final ValueNotifier<double> femaleAnakKeponakanMasturbasi = ValueNotifier<double>(65.0);
  static final ValueNotifier<double> femaleAnakKeponakanMakeLove = ValueNotifier<double>(65.0);

  static final ValueNotifier<double> femaleGuruDosenPacaran = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleGuruDosenMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleGuruDosenMakeLove = ValueNotifier<double>(30.0);

  static final ValueNotifier<double> femaleNonKeluargaLainPacaran = ValueNotifier<double>(35.0);
  static final ValueNotifier<double> femaleNonKeluargaLainMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> femaleNonKeluargaLainMakeLove = ValueNotifier<double>(30.0);

  // =========================================================
  // --- TOGGLE SWITCH PER-ANGGOTA (MALE) ---
  // =========================================================
  static final ValueNotifier<bool> maleAyahKandungEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleAyahTiriEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleAyahMertuaEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleIbuKandungEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleIbuTiriEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleIbuMertuaEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleKakakLakiEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleKakakPerempuanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleAdikLakiEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleAdikPerempuanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> malePamanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> malePasanganPamanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleBibiEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleSepupuEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleKakekEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleNenekEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleAnakKeponakanEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleGuruDosenEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> maleNonKeluargaLainEnabled = ValueNotifier<bool>(true);

  // =========================================================
  // --- PERSENTASE SLIDER (MALE) ---
  // =========================================================
  static final ValueNotifier<double> maleAyahKandungPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleAyahKandungMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleAyahKandungMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> maleAyahTiriPacaran = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> maleAyahTiriMasturbasi = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> maleAyahTiriMakeLove = ValueNotifier<double>(60.0);

  static final ValueNotifier<double> maleAyahMertuaPacaran = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleAyahMertuaMasturbasi = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleAyahMertuaMakeLove = ValueNotifier<double>(5.0);

  static final ValueNotifier<double> maleIbuKandungPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleIbuKandungMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleIbuKandungMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> maleIbuTiriPacaran = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> maleIbuTiriMasturbasi = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> maleIbuTiriMakeLove = ValueNotifier<double>(60.0);

  static final ValueNotifier<double> maleIbuMertuaPacaran = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> maleIbuMertuaMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> maleIbuMertuaMakeLove = ValueNotifier<double>(30.0);

  static final ValueNotifier<double> maleKakakLakiPacaran = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleKakakLakiMasturbasi = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleKakakLakiMakeLove = ValueNotifier<double>(5.0);

  static final ValueNotifier<double> maleKakakPerempuanPacaran = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> maleKakakPerempuanMasturbasi = ValueNotifier<double>(30.0);
  static final ValueNotifier<double> maleKakakPerempuanMakeLove = ValueNotifier<double>(30.0);

  static final ValueNotifier<double> maleAdikLakiPacaran = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleAdikLakiMasturbasi = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleAdikLakiMakeLove = ValueNotifier<double>(5.0);

  static final ValueNotifier<double> maleAdikPerempuanPacaran = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> maleAdikPerempuanMasturbasi = ValueNotifier<double>(40.0);
  static final ValueNotifier<double> maleAdikPerempuanMakeLove = ValueNotifier<double>(40.0);

  static final ValueNotifier<double> malePamanPacaran = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> malePamanMasturbasi = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> malePamanMakeLove = ValueNotifier<double>(5.0);

  static final ValueNotifier<double> malePasanganPamanPacaran = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> malePasanganPamanMasturbasi = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> malePasanganPamanMakeLove = ValueNotifier<double>(5.0);

  static final ValueNotifier<double> maleBibiPacaran = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> maleBibiMasturbasi = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> maleBibiMakeLove = ValueNotifier<double>(25.0);

  static final ValueNotifier<double> maleSepupuPacaran = ValueNotifier<double>(35.0);
  static final ValueNotifier<double> maleSepupuMasturbasi = ValueNotifier<double>(35.0);
  static final ValueNotifier<double> maleSepupuMakeLove = ValueNotifier<double>(35.0);

  static final ValueNotifier<double> maleKakekPacaran = ValueNotifier<double>(5.0);
  static final ValueNotifier<double> maleKakekMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleKakekMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> maleNenekPacaran = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleNenekMasturbasi = ValueNotifier<double>(10.0);
  static final ValueNotifier<double> maleNenekMakeLove = ValueNotifier<double>(10.0);

  static final ValueNotifier<double> maleAnakKeponakanPacaran = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> maleAnakKeponakanMasturbasi = ValueNotifier<double>(60.0);
  static final ValueNotifier<double> maleAnakKeponakanMakeLove = ValueNotifier<double>(60.0);

  static final ValueNotifier<double> maleGuruDosenPacaran = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> maleGuruDosenMasturbasi = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> maleGuruDosenMakeLove = ValueNotifier<double>(25.0);

  static final ValueNotifier<double> maleNonKeluargaLainPacaran = ValueNotifier<double>(35.0);
  static final ValueNotifier<double> maleNonKeluargaLainMasturbasi = ValueNotifier<double>(25.0);
  static final ValueNotifier<double> maleNonKeluargaLainMakeLove = ValueNotifier<double>(25.0);

  /// Helper untuk mengambil ValueNotifier status aktif per-anggota
  static ValueNotifier<bool> getRelationEnabledNotifier(String relation, {String? gender}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final bool isFemale = currentGender == 'perempuan' || currentGender == 'female';
    final String rel = relation.trim().toLowerCase();

    // Prioritas 1: Kakek & Nenek (harus sebelum Ayah & Ibu karena stringnya "Kakek (Ayah dari Ayah)" dll)
    if (rel.contains('kakek')) return isFemale ? femaleKakekEnabled : maleKakekEnabled;
    if (rel.contains('nenek')) return isFemale ? femaleNenekEnabled : maleNenekEnabled;

    // Prioritas 2: Pasangan Paman, Paman, Bibi, Sepupu, Anak/Keponakan
    if (rel.contains('pasangan paman')) return isFemale ? femalePasanganPamanEnabled : malePasanganPamanEnabled;
    if (rel.contains('paman')) return isFemale ? femalePamanEnabled : malePamanEnabled;
    if (rel.contains('bibi')) return isFemale ? femaleBibiEnabled : maleBibiEnabled;
    if (rel.contains('sepupu')) return isFemale ? femaleSepupuEnabled : maleSepupuEnabled;
    if (rel.contains('anak') || rel.contains('keponakan')) return isFemale ? femaleAnakKeponakanEnabled : maleAnakKeponakanEnabled;
    if (rel.contains('guru') || rel.contains('dosen')) return isFemale ? femaleGuruDosenEnabled : maleGuruDosenEnabled;

    // Prioritas 3: Ayah & Ibu
    if (rel.contains('ayah tiri')) return isFemale ? femaleAyahTiriEnabled : maleAyahTiriEnabled;
    if (rel.contains('ayah mertua')) return isFemale ? femaleAyahMertuaEnabled : maleAyahMertuaEnabled;
    if (rel.contains('ayah')) return isFemale ? femaleAyahKandungEnabled : maleAyahKandungEnabled;

    if (rel.contains('ibu tiri')) return isFemale ? femaleIbuTiriEnabled : maleIbuTiriEnabled;
    if (rel.contains('ibu mertua')) return isFemale ? femaleIbuMertuaEnabled : maleIbuMertuaEnabled;
    if (rel.contains('ibu')) return isFemale ? femaleIbuKandungEnabled : maleIbuKandungEnabled;

    // Prioritas 4: Kakak & Adik
    if (rel.contains('kakak laki') || rel.contains('kakak pria')) return isFemale ? femaleKakakLakiEnabled : maleKakakLakiEnabled;
    if (rel.contains('kakak perem') || rel.contains('kakak wanita')) return isFemale ? femaleKakakPerempuanEnabled : maleKakakPerempuanEnabled;
    if (rel.contains('kakak')) return isFemale ? femaleKakakLakiEnabled : maleKakakLakiEnabled;

    if (rel.contains('adik laki') || rel.contains('adik pria')) return isFemale ? femaleAdikLakiEnabled : maleAdikLakiEnabled;
    if (rel.contains('adik perem') || rel.contains('adik wanita')) return isFemale ? femaleAdikPerempuanEnabled : maleAdikPerempuanEnabled;
    if (rel.contains('adik')) return isFemale ? femaleAdikLakiEnabled : maleAdikLakiEnabled;

    return isFemale ? femaleNonKeluargaLainEnabled : maleNonKeluargaLainEnabled;
  }

  /// Aktifkan semua toggle switch per-anggota sekaligus
  static void enableAllRelations({String? gender}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final bool isFemale = currentGender == 'perempuan' || currentGender == 'female';

    if (isFemale) {
      femaleAyahKandungEnabled.value = true;
      femaleAyahTiriEnabled.value = true;
      femaleAyahMertuaEnabled.value = true;
      femaleIbuKandungEnabled.value = true;
      femaleIbuTiriEnabled.value = true;
      femaleIbuMertuaEnabled.value = true;
      femaleKakakLakiEnabled.value = true;
      femaleKakakPerempuanEnabled.value = true;
      femaleAdikLakiEnabled.value = true;
      femaleAdikPerempuanEnabled.value = true;
      femalePamanEnabled.value = true;
      femalePasanganPamanEnabled.value = true;
      femaleBibiEnabled.value = true;
      femaleSepupuEnabled.value = true;
      femaleKakekEnabled.value = true;
      femaleNenekEnabled.value = true;
      femaleAnakKeponakanEnabled.value = true;
      femaleGuruDosenEnabled.value = true;
      femaleNonKeluargaLainEnabled.value = true;
    } else {
      maleAyahKandungEnabled.value = true;
      maleAyahTiriEnabled.value = true;
      maleAyahMertuaEnabled.value = true;
      maleIbuKandungEnabled.value = true;
      maleIbuTiriEnabled.value = true;
      maleIbuMertuaEnabled.value = true;
      maleKakakLakiEnabled.value = true;
      maleKakakPerempuanEnabled.value = true;
      maleAdikLakiEnabled.value = true;
      maleAdikPerempuanEnabled.value = true;
      malePamanEnabled.value = true;
      malePasanganPamanEnabled.value = true;
      maleBibiEnabled.value = true;
      maleSepupuEnabled.value = true;
      maleKakekEnabled.value = true;
      maleNenekEnabled.value = true;
      maleAnakKeponakanEnabled.value = true;
      maleGuruDosenEnabled.value = true;
      maleNonKeluargaLainEnabled.value = true;
    }
  }

  /// Matikan semua toggle switch per-anggota sekaligus
  static void disableAllRelations({String? gender}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final bool isFemale = currentGender == 'perempuan' || currentGender == 'female';

    if (isFemale) {
      femaleAyahKandungEnabled.value = false;
      femaleAyahTiriEnabled.value = false;
      femaleAyahMertuaEnabled.value = false;
      femaleIbuKandungEnabled.value = false;
      femaleIbuTiriEnabled.value = false;
      femaleIbuMertuaEnabled.value = false;
      femaleKakakLakiEnabled.value = false;
      femaleKakakPerempuanEnabled.value = false;
      femaleAdikLakiEnabled.value = false;
      femaleAdikPerempuanEnabled.value = false;
      femalePamanEnabled.value = false;
      femalePasanganPamanEnabled.value = false;
      femaleBibiEnabled.value = false;
      femaleSepupuEnabled.value = false;
      femaleKakekEnabled.value = false;
      femaleNenekEnabled.value = false;
      femaleAnakKeponakanEnabled.value = false;
      femaleGuruDosenEnabled.value = false;
      femaleNonKeluargaLainEnabled.value = false;
    } else {
      maleAyahKandungEnabled.value = false;
      maleAyahTiriEnabled.value = false;
      maleAyahMertuaEnabled.value = false;
      maleIbuKandungEnabled.value = false;
      maleIbuTiriEnabled.value = false;
      maleIbuMertuaEnabled.value = false;
      maleKakakLakiEnabled.value = false;
      maleKakakPerempuanEnabled.value = false;
      maleAdikLakiEnabled.value = false;
      maleAdikPerempuanEnabled.value = false;
      malePamanEnabled.value = false;
      malePasanganPamanEnabled.value = false;
      maleBibiEnabled.value = false;
      maleSepupuEnabled.value = false;
      maleKakekEnabled.value = false;
      maleNenekEnabled.value = false;
      maleAnakKeponakanEnabled.value = false;
      maleGuruDosenEnabled.value = false;
      maleNonKeluargaLainEnabled.value = false;
    }
  }

  /// Helper untuk mengambil Notifier persentase slider spesifik berdasarkan gender pengguna saat ini
  static ValueNotifier<double> getNotifier(String relation, String proposalType, {String? gender}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final bool isFemale = currentGender == 'perempuan' || currentGender == 'female';
    final String rel = relation.trim().toLowerCase();
    final String type = proposalType.trim().toLowerCase();

    // Prioritas 1: KAKEK
    if (rel.contains('kakek')) {
      if (type.contains('pacar')) return isFemale ? femaleKakekPacaran : maleKakekPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleKakekMasturbasi : maleKakekMasturbasi;
      return isFemale ? femaleKakekMakeLove : maleKakekMakeLove;
    }
    // Prioritas 2: NENEK
    if (rel.contains('nenek')) {
      if (type.contains('pacar')) return isFemale ? femaleNenekPacaran : maleNenekPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleNenekMasturbasi : maleNenekMasturbasi;
      return isFemale ? femaleNenekMakeLove : maleNenekMakeLove;
    }

    // Prioritas 3: PASANGAN PAMAN, PAMAN, BIBI, SEPUPU, ANAK/KEPONAKAN, GURU/DOSEN
    if (rel.contains('pasangan paman')) {
      if (type.contains('pacar')) return isFemale ? femalePasanganPamanPacaran : malePasanganPamanPacaran;
      if (type.contains('masturbasi')) return isFemale ? femalePasanganPamanMasturbasi : malePasanganPamanMasturbasi;
      return isFemale ? femalePasanganPamanMakeLove : malePasanganPamanMakeLove;
    }
    if (rel.contains('paman')) {
      if (type.contains('pacar')) return isFemale ? femalePamanPacaran : malePamanPacaran;
      if (type.contains('masturbasi')) return isFemale ? femalePamanMasturbasi : malePamanMasturbasi;
      return isFemale ? femalePamanMakeLove : malePamanMakeLove;
    }
    if (rel.contains('bibi')) {
      if (type.contains('pacar')) return isFemale ? femaleBibiPacaran : maleBibiPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleBibiMasturbasi : maleBibiMasturbasi;
      return isFemale ? femaleBibiMakeLove : maleBibiMakeLove;
    }
    if (rel.contains('sepupu')) {
      if (type.contains('pacar')) return isFemale ? femaleSepupuPacaran : maleSepupuPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleSepupuMasturbasi : maleSepupuMasturbasi;
      return isFemale ? femaleSepupuMakeLove : maleSepupuMakeLove;
    }
    if (rel.contains('anak') || rel.contains('keponakan')) {
      if (type.contains('pacar')) return isFemale ? femaleAnakKeponakanPacaran : maleAnakKeponakanPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAnakKeponakanMasturbasi : maleAnakKeponakanMasturbasi;
      return isFemale ? femaleAnakKeponakanMakeLove : maleAnakKeponakanMakeLove;
    }
    if (rel.contains('guru') || rel.contains('dosen')) {
      if (type.contains('pacar')) return isFemale ? femaleGuruDosenPacaran : maleGuruDosenPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleGuruDosenMasturbasi : maleGuruDosenMasturbasi;
      return isFemale ? femaleGuruDosenMakeLove : maleGuruDosenMakeLove;
    }

    // Prioritas 4: AYAH TIRI, AYAH MERTUA, AYAH KANDUNG
    if (rel.contains('ayah tiri')) {
      if (type.contains('pacar')) return isFemale ? femaleAyahTiriPacaran : maleAyahTiriPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAyahTiriMasturbasi : maleAyahTiriMasturbasi;
      return isFemale ? femaleAyahTiriMakeLove : maleAyahTiriMakeLove;
    }
    if (rel.contains('ayah mertua')) {
      if (type.contains('pacar')) return isFemale ? femaleAyahMertuaPacaran : maleAyahMertuaPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAyahMertuaMasturbasi : maleAyahMertuaMasturbasi;
      return isFemale ? femaleAyahMertuaMakeLove : maleAyahMertuaMakeLove;
    }
    if (rel.contains('ayah')) {
      if (type.contains('pacar')) return isFemale ? femaleAyahKandungPacaran : maleAyahKandungPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAyahKandungMasturbasi : maleAyahKandungMasturbasi;
      return isFemale ? femaleAyahKandungMakeLove : maleAyahKandungMakeLove;
    }

    // Prioritas 5: IBU TIRI, IBU MERTUA, IBU KANDUNG
    if (rel.contains('ibu tiri')) {
      if (type.contains('pacar')) return isFemale ? femaleIbuTiriPacaran : maleIbuTiriPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleIbuTiriMasturbasi : maleIbuTiriMasturbasi;
      return isFemale ? femaleIbuTiriMakeLove : maleIbuTiriMakeLove;
    }
    if (rel.contains('ibu mertua')) {
      if (type.contains('pacar')) return isFemale ? femaleIbuMertuaPacaran : maleIbuMertuaPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleIbuMertuaMasturbasi : maleIbuMertuaMasturbasi;
      return isFemale ? femaleIbuMertuaMakeLove : maleIbuMertuaMakeLove;
    }
    if (rel.contains('ibu')) {
      if (type.contains('pacar')) return isFemale ? femaleIbuKandungPacaran : maleIbuKandungPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleIbuKandungMasturbasi : maleIbuKandungMasturbasi;
      return isFemale ? femaleIbuKandungMakeLove : maleIbuKandungMakeLove;
    }

    // Prioritas 6: KAKAK & ADIK
    if (rel.contains('kakak laki') || rel.contains('kakak pria')) {
      if (type.contains('pacar')) return isFemale ? femaleKakakLakiPacaran : maleKakakLakiPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleKakakLakiMasturbasi : maleKakakLakiMasturbasi;
      return isFemale ? femaleKakakLakiMakeLove : maleKakakLakiMakeLove;
    }
    if (rel.contains('kakak perem') || rel.contains('kakak wanita')) {
      if (type.contains('pacar')) return isFemale ? femaleKakakPerempuanPacaran : maleKakakPerempuanPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleKakakPerempuanMasturbasi : maleKakakPerempuanMasturbasi;
      return isFemale ? femaleKakakPerempuanMakeLove : maleKakakPerempuanMakeLove;
    }
    if (rel.contains('kakak')) {
      if (type.contains('pacar')) return isFemale ? femaleKakakLakiPacaran : maleKakakLakiPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleKakakLakiMasturbasi : maleKakakLakiMasturbasi;
      return isFemale ? femaleKakakLakiMakeLove : maleKakakLakiMakeLove;
    }

    if (rel.contains('adik laki') || rel.contains('adik pria')) {
      if (type.contains('pacar')) return isFemale ? femaleAdikLakiPacaran : maleAdikLakiPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAdikLakiMasturbasi : maleAdikLakiMasturbasi;
      return isFemale ? femaleAdikLakiMakeLove : maleAdikLakiMakeLove;
    }
    if (rel.contains('adik perem') || rel.contains('adik wanita')) {
      if (type.contains('pacar')) return isFemale ? femaleAdikPerempuanPacaran : maleAdikPerempuanPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAdikPerempuanMasturbasi : maleAdikPerempuanMasturbasi;
      return isFemale ? femaleAdikPerempuanMakeLove : maleAdikPerempuanMakeLove;
    }
    if (rel.contains('adik')) {
      if (type.contains('pacar')) return isFemale ? femaleAdikLakiPacaran : maleAdikLakiPacaran;
      if (type.contains('masturbasi')) return isFemale ? femaleAdikLakiMasturbasi : maleAdikLakiMasturbasi;
      return isFemale ? femaleAdikLakiMakeLove : maleAdikLakiMakeLove;
    }

    // Default Non-Keluarga
    if (type.contains('pacar')) return isFemale ? femaleNonKeluargaLainPacaran : maleNonKeluargaLainPacaran;
    if (type.contains('masturbasi')) return isFemale ? femaleNonKeluargaLainMasturbasi : maleNonKeluargaLainMasturbasi;
    return isFemale ? femaleNonKeluargaLainMakeLove : maleNonKeluargaLainMakeLove;
  }

  /// Helper untuk mengambil nilai persentase numerik langsung (Memperhatikan toggle switch & GlobalSettings)
  static double getChance(String relation, String proposalType, {String? gender}) {
    // 1. Cek apakah hubungan ini secara individual dinonaktifkan oleh switch per-anggota
    if (!getRelationEnabledNotifier(relation, gender: gender).value) {
      return 0.0;
    }

    // 2. Cek apakah tipe ajakan ini dinonaktifkan oleh switch global kategori
    final String r = relation.trim().toLowerCase();
    final String t = proposalType.trim().toLowerCase();
    final bool isFam = !(r.contains('guru') || r.contains('dosen') || r.contains('teman') || r.contains('rekan') || r.contains('idol'));

    if (t.contains('pacar')) {
      if (isFam && GlobalSettings.disablePacaranFamily.value) return 0.0;
      if (!isFam && GlobalSettings.disablePacaranNonFamily.value) return 0.0;
    } else if (t.contains('masturbasi')) {
      if (isFam && GlobalSettings.disableMasturbationFamily.value) return 0.0;
      if (!isFam && GlobalSettings.disableMasturbationNonFamily.value) return 0.0;
    } else if (t.contains('bercinta') || t.contains('love')) {
      if (isFam && GlobalSettings.disableMakeLoveFamily.value) return 0.0;
      if (!isFam && GlobalSettings.disableMakeLoveNonFamily.value) return 0.0;
    }

    return getNotifier(relation, proposalType, gender: gender).value;
  }

  /// Reset semua nilai persentase ke default asli dari file-file hetero, lesbian, & gay
  static void resetAll() {
    femaleAyahKandungEnabled.value = true;
    femaleAyahTiriEnabled.value = true;
    femaleAyahMertuaEnabled.value = true;
    femaleIbuKandungEnabled.value = true;
    femaleIbuTiriEnabled.value = true;
    femaleIbuMertuaEnabled.value = true;
    femaleKakakLakiEnabled.value = true;
    femaleKakakPerempuanEnabled.value = true;
    femaleAdikLakiEnabled.value = true;
    femaleAdikPerempuanEnabled.value = true;
    femalePamanEnabled.value = true;
    femalePasanganPamanEnabled.value = true;
    femaleBibiEnabled.value = true;
    femaleSepupuEnabled.value = true;
    femaleKakekEnabled.value = true;
    femaleNenekEnabled.value = true;
    femaleAnakKeponakanEnabled.value = true;
    femaleGuruDosenEnabled.value = true;
    femaleNonKeluargaLainEnabled.value = true;

    maleAyahKandungEnabled.value = true;
    maleAyahTiriEnabled.value = true;
    maleAyahMertuaEnabled.value = true;
    maleIbuKandungEnabled.value = true;
    maleIbuTiriEnabled.value = true;
    maleIbuMertuaEnabled.value = true;
    maleKakakLakiEnabled.value = true;
    maleKakakPerempuanEnabled.value = true;
    maleAdikLakiEnabled.value = true;
    maleAdikPerempuanEnabled.value = true;
    malePamanEnabled.value = true;
    malePasanganPamanEnabled.value = true;
    maleBibiEnabled.value = true;
    maleSepupuEnabled.value = true;
    maleKakekEnabled.value = true;
    maleNenekEnabled.value = true;
    maleAnakKeponakanEnabled.value = true;
    maleGuruDosenEnabled.value = true;
    maleNonKeluargaLainEnabled.value = true;

    femaleAyahKandungPacaran.value = 40.0;
    femaleAyahKandungMasturbasi.value = 75.0;
    femaleAyahKandungMakeLove.value = 40.0;

    femaleAyahTiriPacaran.value = 70.0;
    femaleAyahTiriMasturbasi.value = 75.0;
    femaleAyahTiriMakeLove.value = 60.0;

    femaleAyahMertuaPacaran.value = 35.0;
    femaleAyahMertuaMasturbasi.value = 35.0;
    femaleAyahMertuaMakeLove.value = 35.0;

    femaleIbuKandungPacaran.value = 10.0;
    femaleIbuKandungMasturbasi.value = 75.0;
    femaleIbuKandungMakeLove.value = 10.0;

    femaleIbuTiriPacaran.value = 10.0;
    femaleIbuTiriMasturbasi.value = 75.0;
    femaleIbuTiriMakeLove.value = 10.0;

    femaleIbuMertuaPacaran.value = 30.0;
    femaleIbuMertuaMasturbasi.value = 35.0;
    femaleIbuMertuaMakeLove.value = 30.0;

    femaleKakakLakiPacaran.value = 45.0;
    femaleKakakLakiMasturbasi.value = 75.0;
    femaleKakakLakiMakeLove.value = 45.0;

    femaleKakakPerempuanPacaran.value = 30.0;
    femaleKakakPerempuanMasturbasi.value = 75.0;
    femaleKakakPerempuanMakeLove.value = 30.0;

    femaleAdikLakiPacaran.value = 45.0;
    femaleAdikLakiMasturbasi.value = 75.0;
    femaleAdikLakiMakeLove.value = 45.0;

    femaleAdikPerempuanPacaran.value = 40.0;
    femaleAdikPerempuanMasturbasi.value = 75.0;
    femaleAdikPerempuanMakeLove.value = 40.0;

    femalePamanPacaran.value = 30.0;
    femalePamanMasturbasi.value = 25.0;
    femalePamanMakeLove.value = 30.0;

    femalePasanganPamanPacaran.value = 10.0;
    femalePasanganPamanMasturbasi.value = 25.0;
    femalePasanganPamanMakeLove.value = 10.0;

    femaleBibiPacaran.value = 25.0;
    femaleBibiMasturbasi.value = 25.0;
    femaleBibiMakeLove.value = 25.0;

    femaleSepupuPacaran.value = 40.0;
    femaleSepupuMasturbasi.value = 30.0;
    femaleSepupuMakeLove.value = 40.0;

    femaleKakekPacaran.value = 15.0;
    femaleKakekMasturbasi.value = 25.0;
    femaleKakekMakeLove.value = 15.0;

    femaleNenekPacaran.value = 10.0;
    femaleNenekMasturbasi.value = 25.0;
    femaleNenekMakeLove.value = 10.0;

    femaleAnakKeponakanPacaran.value = 65.0;
    femaleAnakKeponakanMasturbasi.value = 30.0;
    femaleAnakKeponakanMakeLove.value = 65.0;

    femaleGuruDosenPacaran.value = 30.0;
    femaleGuruDosenMasturbasi.value = 45.0;
    femaleGuruDosenMakeLove.value = 30.0;

    femaleNonKeluargaLainPacaran.value = 40.0;
    femaleNonKeluargaLainMasturbasi.value = 15.0;
    femaleNonKeluargaLainMakeLove.value = 30.0;

    // --- RESET MALE ---
    maleAyahKandungPacaran.value = 10.0;
    maleAyahKandungMasturbasi.value = 75.0;
    maleAyahKandungMakeLove.value = 10.0;

    maleAyahTiriPacaran.value = 70.0;
    maleAyahTiriMasturbasi.value = 75.0;
    maleAyahTiriMakeLove.value = 60.0;

    maleAyahMertuaPacaran.value = 5.0;
    maleAyahMertuaMasturbasi.value = 35.0;
    maleAyahMertuaMakeLove.value = 5.0;

    maleIbuKandungPacaran.value = 10.0;
    maleIbuKandungMasturbasi.value = 75.0;
    maleIbuKandungMakeLove.value = 10.0;

    maleIbuTiriPacaran.value = 70.0;
    maleIbuTiriMasturbasi.value = 75.0;
    maleIbuTiriMakeLove.value = 60.0;

    maleIbuMertuaPacaran.value = 30.0;
    maleIbuMertuaMasturbasi.value = 35.0;
    maleIbuMertuaMakeLove.value = 30.0;

    maleKakakLakiPacaran.value = 5.0;
    maleKakakLakiMasturbasi.value = 75.0;
    maleKakakLakiMakeLove.value = 5.0;

    maleKakakPerempuanPacaran.value = 30.0;
    maleKakakPerempuanMasturbasi.value = 75.0;
    maleKakakPerempuanMakeLove.value = 30.0;

    maleAdikLakiPacaran.value = 5.0;
    maleAdikLakiMasturbasi.value = 75.0;
    maleAdikLakiMakeLove.value = 5.0;

    maleAdikPerempuanPacaran.value = 40.0;
    maleAdikPerempuanMasturbasi.value = 75.0;
    maleAdikPerempuanMakeLove.value = 40.0;

    malePamanPacaran.value = 5.0;
    malePamanMasturbasi.value = 25.0;
    malePamanMakeLove.value = 5.0;

    malePasanganPamanPacaran.value = 5.0;
    malePasanganPamanMasturbasi.value = 25.0;
    malePasanganPamanMakeLove.value = 5.0;

    maleBibiPacaran.value = 25.0;
    maleBibiMasturbasi.value = 25.0;
    maleBibiMakeLove.value = 25.0;

    maleSepupuPacaran.value = 35.0;
    maleSepupuMasturbasi.value = 30.0;
    maleSepupuMakeLove.value = 35.0;

    maleKakekPacaran.value = 5.0;
    maleKakekMasturbasi.value = 25.0;
    maleKakekMakeLove.value = 10.0;

    maleNenekPacaran.value = 10.0;
    maleNenekMasturbasi.value = 25.0;
    maleNenekMakeLove.value = 10.0;

    maleAnakKeponakanPacaran.value = 60.0;
    maleAnakKeponakanMasturbasi.value = 30.0;
    maleAnakKeponakanMakeLove.value = 60.0;

    maleGuruDosenPacaran.value = 25.0;
    maleGuruDosenMasturbasi.value = 45.0;
    maleGuruDosenMakeLove.value = 25.0;

    maleNonKeluargaLainPacaran.value = 35.0;
    maleNonKeluargaLainMasturbasi.value = 15.0;
    maleNonKeluargaLainMakeLove.value = 25.0;
  }
}

/// Widget Slider custom untuk mengubah persentase ajakan pada menu setting
class PercentageSliderTile extends StatelessWidget {
  final String title;
  final ValueNotifier<double> notifier;
  final Color activeColor;
  final bool isDisabled;

  const PercentageSliderTile({
    super.key,
    required this.title,
    required this.notifier,
    this.activeColor = Colors.orange,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<double>(
      valueListenable: notifier,
      builder: (context, val, _) {
        final Color effectiveColor = isDisabled ? Colors.grey : activeColor;

        return AbsorbPointer(
          absorbing: isDisabled,
          child: Opacity(
            opacity: isDisabled ? 0.35 : 1.0,
            child: Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDisabled
                    ? (isDark ? Colors.grey.shade900 : Colors.grey.shade300)
                    : (isDark ? Colors.grey.shade800.withValues(alpha: 0.4) : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDisabled
                      ? Colors.grey.shade700
                      : activeColor.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (isDisabled) ...[
                              const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDisabled ? Colors.grey : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                                  decoration: isDisabled ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: effectiveColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isDisabled ? 'Terkunci (0%)' : '${val.toInt()}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: effectiveColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: isDisabled ? 0 : 5),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: isDisabled ? 0 : 12),
                      activeTrackColor: effectiveColor,
                      inactiveTrackColor: effectiveColor.withValues(alpha: 0.2),
                      thumbColor: effectiveColor,
                      disabledActiveTrackColor: Colors.grey,
                      disabledInactiveTrackColor: Colors.grey.shade800,
                      disabledThumbColor: Colors.grey,
                    ),
                    child: Slider(
                      value: isDisabled ? 0.0 : val.clamp(0.0, 100.0),
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      onChanged: isDisabled ? null : (newVal) {
                        notifier.value = newVal;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget Card khusus untuk menampilkan pilihan pengaturan persentase per-anggota keluarga
class RelationPercentageGroupCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String relationKey;

  const RelationPercentageGroupCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.relationKey,
  });

  bool _isKeluarga(String key) {
    final r = key.toLowerCase();
    if (r.contains('guru') || r.contains('dosen') || r.contains('teman') || r.contains('rekan') || r.contains('idol')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFam = _isKeluarga(relationKey);

    return ValueListenableBuilder<String>(
      valueListenable: GlobalSettings.userGender,
      builder: (context, genderVal, _) {
        final ValueNotifier<bool> relationEnabledNotifier = ProposalPercentageSettings.getRelationEnabledNotifier(relationKey, gender: genderVal);

        return ValueListenableBuilder<bool>(
          valueListenable: relationEnabledNotifier,
          builder: (context, relationEnabled, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: isFam ? GlobalSettings.disablePacaranFamily : GlobalSettings.disablePacaranNonFamily,
              builder: (context, disablePacaran, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: isFam ? GlobalSettings.disableMasturbationFamily : GlobalSettings.disableMasturbationNonFamily,
                  builder: (context, disableMasturbation, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: isFam ? GlobalSettings.disableMakeLoveFamily : GlobalSettings.disableMakeLoveNonFamily,
                      builder: (context, disableMakeLove, _) {
                        final bool allDisabled = !relationEnabled || (disablePacaran && disableMasturbation && disableMakeLove);

                        final ValueNotifier<double> pacaranNotifier = ProposalPercentageSettings.getNotifier(relationKey, 'Ajak Pacaran', gender: genderVal);
                        final ValueNotifier<double> masturbationNotifier = ProposalPercentageSettings.getNotifier(relationKey, 'Masturbasi', gender: genderVal);
                        final ValueNotifier<double> makeLoveNotifier = ProposalPercentageSettings.getNotifier(relationKey, 'Bercinta', gender: genderVal);

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: allDisabled
                                ? (isDark ? Colors.grey.shade900.withValues(alpha: 0.3) : Colors.grey.shade200)
                                : (isDark ? Colors.grey.shade900.withValues(alpha: 0.5) : Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: allDisabled
                                  ? (isDark ? Colors.grey.shade800 : Colors.grey.shade400)
                                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                            ),
                          ),
                          child: ExpansionTile(
                            leading: Icon(icon, color: allDisabled ? Colors.grey : iconColor, size: 22),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: allDisabled ? Colors.grey : (isDark ? Colors.white : Colors.black87),
                                    ),
                                  ),
                                ),
                                if (!relationEnabled) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Nonaktif',
                                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: relationEnabled,
                                    activeThumbColor: iconColor,
                                    onChanged: (val) {
                                      relationEnabledNotifier.value = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              PercentageSliderTile(
                                title: 'Peluang Ajak Pacaran',
                                notifier: pacaranNotifier,
                                activeColor: Colors.red,
                                isDisabled: !relationEnabled || disablePacaran,
                              ),
                              PercentageSliderTile(
                                title: 'Peluang Masturbasi Bersama',
                                notifier: masturbationNotifier,
                                activeColor: Colors.orange,
                                isDisabled: !relationEnabled || disableMasturbation,
                              ),
                              PercentageSliderTile(
                                title: 'Peluang Bercinta / Make Love',
                                notifier: makeLoveNotifier,
                                activeColor: Colors.pinkAccent,
                                isDisabled: !relationEnabled || disableMakeLove,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
