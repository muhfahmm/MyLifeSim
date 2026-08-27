// lib/game/widgets/penyakit_logic/incest_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

// ==============================================================
// TABEL 1: Peluang Cacat Genetik per Hubungan
// ==============================================================
// Ayah - Anak Perempuan        → 35%
// Ibu - Anak Laki-laki         → 35%
// Saudara Kandung (Kakak-Adik) → 32%
// Kakek - Cucu Perempuan       → 18%
// Nenek - Cucu Laki-laki       → 18%
// Paman - Keponakan Perempuan  → 15%
// Bibi - Keponakan Laki-laki   → 15%
// Sepupu (Laki-Perempuan)      → 6%
// Kakek/Ayah - Cucu/Anak Laki  → 0% (homoseksual, tidak hamil)
// ==============================================================
// TABEL 2: Konsekuensi Psikologis & Karma
// ==============================================================
// Ayah/Ibu - Anak              → -25 happiness, -35 karma
// Saudara Kandung              → -20 happiness, -30 karma
// Kakek/Nenek - Cucu           → -18 happiness, -25 karma
// Paman/Bibi - Keponakan       → -15 happiness, -20 karma
// Sepupu (beda jenis)          → -10 happiness, -10 karma
// Sepupu sesama jenis          → -8 happiness, -8 karma
// ==============================================================

class _IncestRelation {
  final String level;
  final int geneticRisk;
  final int happinessPenalty;
  final int karmaPenalty;
  const _IncestRelation({
    required this.level,
    required this.geneticRisk,
    required this.happinessPenalty,
    required this.karmaPenalty,
  });
}

_IncestRelation? _detectRelation(Character character, String roleLower, String nameLower) {
  // Cek apakah target adalah anak angkat/adopsi player
  for (var child in character.children) {
    if (child['name']?.toLowerCase() == nameLower) {
      if (child['relation'] == 'Anak Adopsi') {
        return null; // Anak adopsi tidak sedarah, 0% risiko genetik!
      }
    }
  }

  if (roleLower.contains('tiri') || nameLower.contains('tiri') ||
      roleLower.contains('mertua') || nameLower.contains('mertua') ||
      roleLower.contains('mantan') || nameLower.contains('mantan')) {
    return null; // Non-genetic relationships do not trigger incest warnings or genetic risks
  }
  if (nameLower.startsWith('ayah') || roleLower.contains('ayah') ||
      nameLower.startsWith('ibu') || roleLower.contains('ibu') ||
      roleLower == 'laki-laki' || roleLower == 'perempuan' || roleLower.contains('anak')) {
    return const _IncestRelation(level: 'parent', geneticRisk: 35, happinessPenalty: 25, karmaPenalty: 35);
  }
  if (roleLower.contains('saudara') || roleLower.contains('kandung') ||
      nameLower.contains('kakak') || nameLower.contains('adik')) {
    return const _IncestRelation(level: 'sibling', geneticRisk: 32, happinessPenalty: 20, karmaPenalty: 30);
  }
  if (roleLower.contains('kakek') || roleLower.contains('nenek')) {
    return const _IncestRelation(level: 'grandparent', geneticRisk: 18, happinessPenalty: 18, karmaPenalty: 25);
  }
  if (roleLower.contains('paman') || roleLower.contains('bibi')) {
    return const _IncestRelation(level: 'uncle_aunt', geneticRisk: 15, happinessPenalty: 15, karmaPenalty: 20);
  }
  if (roleLower.contains('sepupu') || roleLower.contains('keponakan')) {
    return const _IncestRelation(level: 'cousin', geneticRisk: 6, happinessPenalty: 10, karmaPenalty: 10);
  }
  return null;
}

Future<void> showIncestPsychologicalModal(
  BuildContext context, String partnerName, String relationLabel, int happinessPenalty) async {
  if (!context.mounted) return;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Row(children: [
        Icon(Icons.psychology, color: Colors.deepPurple, size: 28),
        SizedBox(width: 10),
        Expanded(child: Text('⚠️ Guncangan Psikologis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple))),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Kamu baru saja berhubungan intim dengan $relationLabel, $partnerName.',
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEF9A9A)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 18),
              const SizedBox(width: 6),
              Text('Kebahagiaan: -$happinessPenalty%',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            const Row(children: [
              Icon(Icons.balance, color: Colors.orange, size: 18),
              SizedBox(width: 6),
              Expanded(child: Text('Karma & hati nurani terguncang keras.',
                  style: TextStyle(color: Colors.orange, fontSize: 12))),
            ]),
          ]),
        ),
        const SizedBox(height: 10),
        const Text(
            'Perbuatan ini melanggar norma sosial dan nilai keluarga. Rasa bersalah yang mendalam membekas.',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
      ],
    ),
  );
}

Future<void> showIncestGeneticModal(
  BuildContext context, String partnerName, String relationLabel, int geneticRisk) async {
  if (!context.mounted) return;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Row(children: [
        Icon(Icons.biotech, color: Colors.red, size: 28),
        SizedBox(width: 10),
        Expanded(child: Text('🧬 Peringatan Risiko Genetik',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red))),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hubungan sedarah dengan $relationLabel ($partnerName) membawa risiko genetik serius pada kehamilan.',
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('⚠️ Peluang cacat bawaan: $geneticRisk%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 4),
            const Text('Risiko: Down syndrome, cacat fisik/mental, keguguran, atau bayi lahir mati.',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        ),
      ],
    ),
  );
}

class IncestRelationData {
  final String level;
  final int geneticRisk;
  IncestRelationData(this.level, this.geneticRisk);
}

IncestRelationData? detectIncestRelation(Character character, String role, String name) {
  final rel = _detectRelation(character, role.toLowerCase(), name.toLowerCase());
  if (rel == null) return null;
  return IncestRelationData(rel.level, rel.geneticRisk);
}

/// Dipanggil dari bercinta.dart setelah bercinta berhasil.
Future<void> handleIncestAfterSex(
  BuildContext context,
  Character character,
  String partnerRole,
  String partnerName,
  String myGender,
  String partnerGender,
  Random random,
) async {
  // Guncangan psikologis dihapus secara permanen.
  // Peringatan risiko genetik dipindahkan ke alur setelah pasangan hamil di bercinta.dart.
}

/// Dipanggil dari character.dart saat melahirkan (ageUp).
Map<String, dynamic> handleIncestPregnancyEffect(Character character, Random random) {
  final String? role = character.pregnantByPartnerRole;
  final String? partnerName = character.pregnantByPartnerName;
  if (role == null || partnerName == null) return {'keguguran': false, 'kelainanGenetik': false};

  final _IncestRelation? rel = _detectRelation(character, role.toLowerCase(), partnerName.toLowerCase());
  if (rel == null || rel.geneticRisk == 0) return {'keguguran': false, 'kelainanGenetik': false};

  final int roll = random.nextInt(100);

  if (roll < 15) {
    character.happiness = (character.happiness - 40).clamp(0, 100);
    final String logMsg =
        '🥀 Tragedi Inses: Kehamilan hasil hubungan sedarah dengan $partnerName berakhir dengan '
        'keguguran / bayi lahir dalam keadaan meninggal. Kamu merasa sangat sedih (-40% Kebahagiaan).';
    character.inbox.add(logMsg);
    return {'keguguran': true, 'kelainanGenetik': false, 'pesan': logMsg};
  }

  final int geneticRoll = random.nextInt(100);
  if (geneticRoll < rel.geneticRisk) {
    character.happiness = (character.happiness - 35).clamp(0, 100);
    final String logMsg =
        '⚠️ Kelainan Genetik Inses: Anak hasil hubungan sedarah dengan $partnerName lahir dengan '
        'kelainan genetik bawaan serius (peluang cacat ${rel.geneticRisk}%). Kebahagiaanmu turun drastis!';
    character.inbox.add(logMsg);
    return {'keguguran': false, 'kelainanGenetik': true, 'pesan': logMsg};
  }

  return {'keguguran': false, 'kelainanGenetik': false};
}
