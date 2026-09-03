// lib/pilih_karakter/settings/proposal_percentage_settings.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// Imports for biseksual handlers
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/biseksual/ajakan_ml_biseksual_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/biseksual/ajakan_ml_biseksual_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/biseksual/ajakan_ml_biseksual_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/biseksual/ajakan_ml_biseksual_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/biseksual/ajakan_ml_biseksual_teman_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_teman_sekolah.dart';

// Imports for hetero perempuan handlers
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_teman_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_teman_sekolah.dart';

// Imports for hetero laki handlers
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_teman_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_teman_sekolah.dart';

// Imports for gay handlers
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/gay/ajakan_pacaran_gay_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/gay/ajakan_ml_gay_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/gay/ajakan_pacaran_gay_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/gay/ajakan_ml_gay_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/gay/ajakan_pacaran_gay_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/gay/ajakan_ml_gay_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/gay/ajakan_pacaran_gay_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/gay/ajakan_ml_gay_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/gay/ajakan_pacaran_gay_teman_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/gay/ajakan_ml_gay_teman_sekolah.dart';

// Imports for lesbian handlers
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/lesbian/ajakan_ml_lesbian_keluarga.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/lesbian/ajakan_ml_lesbian_coworker.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/lesbian/ajakan_ml_lesbian_dosen.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/lesbian/ajakan_ml_lesbian_guru_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_teman_sekolah.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_makelove/lesbian/ajakan_ml_lesbian_teman_sekolah.dart';

/// Class untuk mengelola preferensi persentase ajakan NPC per-hubungan detail.
/// HANYA mengelola toggle switch per-anggota, sedangkan DATA PERSENTASE DIBACA
/// SECARA DINAMIS LANGSUNG DARI FOLDER `ajakan_pacaran_makelove` (Hetero Perempuan, Hetero Laki, Gay, Lesbian, Biseksual)
/// SEBAGAI SINGLE SOURCE OF TRUTH.
class ProposalPercentageSettings {
  // =========================================================
  // --- TOGGLE SWITCH PER-ANGGOTA (FEMALE) ---
  // =========================================================
  static final ValueNotifier<bool> femaleAyahKandungEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleAyahTiriEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleAyahMertuaEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleIbuKandungEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleIbuTiriEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleIbuMertuaEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleKakakLakiEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleKakakPerempuanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleAdikLakiEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleAdikPerempuanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femalePamanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femalePasanganPamanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleBibiEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleSepupuEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleKakekEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleNenekEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleAnakKeponakanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleGuruDosenEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> femaleNonKeluargaLainEnabled = ValueNotifier<bool>(false);

  // =========================================================
  // --- TOGGLE SWITCH PER-ANGGOTA (MALE) ---
  // =========================================================
  static final ValueNotifier<bool> maleAyahKandungEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleAyahTiriEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleAyahMertuaEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleIbuKandungEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleIbuTiriEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleIbuMertuaEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleKakakLakiEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleKakakPerempuanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleAdikLakiEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleAdikPerempuanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> malePamanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> malePasanganPamanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleBibiEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleSepupuEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleKakekEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleNenekEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleAnakKeponakanEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleGuruDosenEnabled = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> maleNonKeluargaLainEnabled = ValueNotifier<bool>(false);

  // Cache notifier lokal untuk Slider UI agar langsung mencerminkan data dari folder ajakan_pacaran_makelove
  static final Map<String, ValueNotifier<double>> _dynamicNotifiers = {};

  /// Helper untuk mengambil ValueNotifier status aktif per-anggota
  static ValueNotifier<bool> getRelationEnabledNotifier(String relation, {String? gender}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final bool isFemale = currentGender == 'perempuan' || currentGender == 'female';
    final String rel = relation.trim().toLowerCase();

    // Prioritas 1: Kakek & Nenek
    if (rel.contains('kakek')) return isFemale ? femaleKakekEnabled : maleKakekEnabled;
    if (rel.contains('nenek')) return isFemale ? femaleNenekEnabled : maleNenekEnabled;

    // Prioritas 2: Pasangan Paman, Paman, Bibi, Sepupu, Anak/Keponakan, Guru/Dosen
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

  /// Membaca persentase DINAMIS LANGSUNG DARI FILE KODE FOLDER `ajakan_pacaran_makelove`
  /// (Mendukung Biseksual, Gay, Lesbian, Hetero Perempuan, dan Hetero Laki)
  static double _getChanceFromAjakanFolder(String relation, String proposalType, {String? gender, String? sexuality}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final bool isFemale = currentGender == 'perempuan' || currentGender == 'female';
    final String effectiveSexuality = (sexuality ?? GlobalSettings.userSexuality.value).trim();

    final String rLower = relation.trim().toLowerCase();
    final dummyChar = Character(
      name: 'User',
      gender: isFemale ? 'Perempuan' : 'Laki-laki',
      location: 'Indonesia',
      sexuality: effectiveSexuality,
    )..custodyParent = rLower.contains('ibu') ? 'Ibu' : 'Ayah'
     ..age = 18;
    final candidate = {
      'name': relation,
      'relation': relation,
      'gender': relation.toLowerCase().contains('ayah') || relation.toLowerCase().contains('paman') ? 'Laki-laki' : 'Perempuan',
      'age': 30,
      'role': relation,
    };

    final String t = proposalType.trim().toLowerCase();
    final String r = relation.trim().toLowerCase();
    final String s = effectiveSexuality.trim().toLowerCase();

    // 1. BISEKSUAL
    if (s == 'biseksual') {
      if (t.contains('bercinta') || t.contains('love')) {
        if (r.contains('guru') || r.contains('dosen')) {
          if (r.contains('dosen')) return AjakanMlBiseksualDosen.getChance(dummyChar, candidate).toDouble();
          return AjakanMlBiseksualGuruSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
          return AjakanMlBiseksualTemanSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
          return AjakanMlBiseksualCoworker.getChance(dummyChar, candidate).toDouble();
        } else {
          return AjakanMlBiseksualKeluarga.getChance(dummyChar, candidate).toDouble();
        }
      } else {
        if (r.contains('guru') || r.contains('dosen')) {
          if (r.contains('dosen')) return AjakanPacaranBiseksualDosen.getChance(dummyChar, candidate).toDouble();
          return AjakanPacaranBiseksualGuruSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
          return AjakanPacaranBiseksualTemanSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
          return AjakanPacaranBiseksualCoworker.getChance(dummyChar, candidate).toDouble();
        } else {
          return AjakanPacaranBiseksualKeluarga.getChance(dummyChar, candidate).toDouble();
        }
      }
    }
    // 2. GAY
    else if (s == 'gay') {
      if (t.contains('bercinta') || t.contains('love')) {
        if (r.contains('guru') || r.contains('dosen')) {
          if (r.contains('dosen')) return AjakanMlGayDosen.getChance(dummyChar, candidate).toDouble();
          return AjakanMlGayGuruSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
          return AjakanMlGayTemanSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
          return AjakanMlGayCoworker.getChance(dummyChar, candidate).toDouble();
        } else {
          return AjakanMlGayKeluarga.getChance(dummyChar, candidate).toDouble();
        }
      } else {
        if (r.contains('guru') || r.contains('dosen')) {
          if (r.contains('dosen')) return AjakanPacaranGayDosen.getChance(dummyChar, candidate).toDouble();
          return AjakanPacaranGayGuruSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
          return AjakanPacaranGayTemanSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
          return AjakanPacaranGayCoworker.getChance(dummyChar, candidate).toDouble();
        } else {
          return AjakanPacaranGayKeluarga.getChance(dummyChar, candidate).toDouble();
        }
      }
    }
    // 3. LESBIAN
    else if (s == 'lesbian') {
      if (t.contains('bercinta') || t.contains('love')) {
        if (r.contains('guru') || r.contains('dosen')) {
          if (r.contains('dosen')) return AjakanMlLesbianDosen.getChance(dummyChar, candidate).toDouble();
          return AjakanMlLesbianGuruSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
          return AjakanMlLesbianTemanSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
          return AjakanMlLesbianCoworker.getChance(dummyChar, candidate).toDouble();
        } else {
          return AjakanMlLesbianKeluarga.getChance(dummyChar, candidate).toDouble();
        }
      } else {
        if (r.contains('guru') || r.contains('dosen')) {
          if (r.contains('dosen')) return AjakanPacaranLesbianDosen.getChance(dummyChar, candidate).toDouble();
          return AjakanPacaranLesbianGuruSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
          return AjakanPacaranLesbianTemanSekolah.getChance(dummyChar, candidate).toDouble();
        } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
          return AjakanPacaranLesbianCoworker.getChance(dummyChar, candidate).toDouble();
        } else {
          return AjakanPacaranLesbianKeluarga.getChance(dummyChar, candidate).toDouble();
        }
      }
    }
    // 4. HETERO (Dipisah menjadi hetero_perempuan dan hetero_laki)
    else {
      if (isFemale) {
        if (t.contains('bercinta') || t.contains('love')) {
          if (r.contains('guru') || r.contains('dosen')) {
            if (r.contains('dosen')) return AjakanMlHeteroPerempuanDosen.getChance(dummyChar, candidate).toDouble();
            return AjakanMlHeteroPerempuanGuruSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
            return AjakanMlHeteroPerempuanTemanSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
            return AjakanMlHeteroPerempuanCoworker.getChance(dummyChar, candidate).toDouble();
          } else {
            return AjakanMlHeteroPerempuanKeluarga.getChance(dummyChar, candidate).toDouble();
          }
        } else {
          if (r.contains('guru') || r.contains('dosen')) {
            if (r.contains('dosen')) return AjakanPacaranHeteroPerempuanDosen.getChance(dummyChar, candidate).toDouble();
            return AjakanPacaranHeteroPerempuanGuruSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
            return AjakanPacaranHeteroPerempuanTemanSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
            return AjakanPacaranHeteroPerempuanCoworker.getChance(dummyChar, candidate).toDouble();
          } else {
            return AjakanPacaranHeteroPerempuanKeluarga.getChance(dummyChar, candidate).toDouble();
          }
        }
      } else {
        if (t.contains('bercinta') || t.contains('love')) {
          if (r.contains('guru') || r.contains('dosen')) {
            if (r.contains('dosen')) return AjakanMlHeteroLakiDosen.getChance(dummyChar, candidate).toDouble();
            return AjakanMlHeteroLakiGuruSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
            return AjakanMlHeteroLakiTemanSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
            return AjakanMlHeteroLakiCoworker.getChance(dummyChar, candidate).toDouble();
          } else {
            return AjakanMlHeteroLakiKeluarga.getChance(dummyChar, candidate).toDouble();
          }
        } else {
          if (r.contains('guru') || r.contains('dosen')) {
            if (r.contains('dosen')) return AjakanPacaranHeteroLakiDosen.getChance(dummyChar, candidate).toDouble();
            return AjakanPacaranHeteroLakiGuruSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('teman') || r.contains('sekolah') || r.contains('sekelas')) {
            return AjakanPacaranHeteroLakiTemanSekolah.getChance(dummyChar, candidate).toDouble();
          } else if (r.contains('bos') || r.contains('atasan') || r.contains('rekan kerja') || r.contains('supervisor')) {
            return AjakanPacaranHeteroLakiCoworker.getChance(dummyChar, candidate).toDouble();
          } else {
            return AjakanPacaranHeteroLakiKeluarga.getChance(dummyChar, candidate).toDouble();
          }
        }
      }
    }
  }

  /// Helper untuk mengambil Notifier persentase slider spesifik (Membaca langsung dari folder ajakan_pacaran_makelove)
  static ValueNotifier<double> getNotifier(String relation, String proposalType, {String? gender, String? sexuality}) {
    final String currentGender = (gender ?? GlobalSettings.userGender.value).trim().toLowerCase();
    final String cacheKey = '${relation.trim()}_${proposalType.trim()}_$currentGender';

    final double chanceFromCode = _getChanceFromAjakanFolder(relation, proposalType, gender: gender, sexuality: sexuality);

    if (!_dynamicNotifiers.containsKey(cacheKey)) {
      _dynamicNotifiers[cacheKey] = ValueNotifier<double>(chanceFromCode);
    } else {
      _dynamicNotifiers[cacheKey]!.value = chanceFromCode;
    }

    return _dynamicNotifiers[cacheKey]!;
  }

  /// Helper untuk mengambil nilai persentase numerik langsung (Memperhatikan toggle switch & GlobalSettings)
  static double getChance(String relation, String proposalType, {String? gender, String? sexuality}) {
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

    return getNotifier(relation, proposalType, gender: gender, sexuality: sexuality).value;
  }

  /// Reset semua toggle switch
  static void resetAll() {
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

    _dynamicNotifiers.forEach((key, notifier) {
      notifier.value = 50.0;
    });
  }
}

/// Widget Slider custom untuk menampilkan persentase ajakan pada menu setting
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
                                title: 'Peluang Diajak Pacaran',
                                notifier: pacaranNotifier,
                                activeColor: Colors.red,
                                isDisabled: !relationEnabled || disablePacaran,
                              ),
                              PercentageSliderTile(
                                title: 'Peluang Diajak Masturbasi Bersama',
                                notifier: masturbationNotifier,
                                activeColor: Colors.orange,
                                isDisabled: !relationEnabled || disableMasturbation,
                              ),
                              PercentageSliderTile(
                                title: 'Peluang DiajakBercinta / Make Love',
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
