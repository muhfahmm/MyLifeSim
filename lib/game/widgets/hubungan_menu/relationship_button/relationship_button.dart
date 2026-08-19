// lib/game/widgets/hubungan_menu/relationship_button/relationship_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';

class RelationshipButton extends StatelessWidget {
  final Character character;
  final bool isAlive;
  final VoidCallback onRefresh;

  const RelationshipButton({
    super.key,
    required this.character,
    required this.isAlive,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!isAlive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Karakter sudah meninggal!')),
          );
          return;
        }

        // --- BUAT DAFTAR SAUDARA & DIRI SENDIRI ---
        final List<Map<String, dynamic>> childrenList = [];

        // 1. Masukkan semua saudara kandung yang SUDAH LAHIR (age >= 0)
        for (var sib in character.siblings) {
          final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
          final bool isDeceased = sib['isDeceased'] == 'true';
          final String expectedLabel = '${sib['name']} (${sib['relation']})';

          // Hindari duplikasi jika saudara adalah pasangan
          if (character.partner != null && character.partner!['name'] == expectedLabel) {
            continue;
          }

          if (sibAge >= 0) {
            childrenList.add({
              'isPlayer': false,
              'name': sib['name'] ?? 'Saudara',
              'gender': sib['gender'] ?? 'Laki-laki',
              'relation': sib['relation'] ?? 'Saudara',
              'relationship': int.tryParse(sib['relationship'] ?? '50') ?? 50,
              'age': sibAge,
              'isDeceased': isDeceased,
            });
          }
        }

        // 2. Masukkan data diri sendiri (Player)
        childrenList.add({
          'isPlayer': true,
          'name': '${character.name} (Anda)',
          'gender': character.gender,
          'relation': 'Diri Sendiri',
          'relationship': 100,
          'age': character.age,
          'isDeceased': false,
        });

        // 3. Urutkan dari yang tertua ke termuda (descending)
        childrenList.sort((a, b) => b['age'].compareTo(a['age']));

        DialogHelper.show(
          context: context,
          title: 'Hubungan & Keluarga',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ============================================
              // 1. BAGIAN ORANGTUA
              // ============================================
              const Text('👨👩👧 Orangtua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 8),
              if (character.fatherName != null)
                _buildFamilyItem(
                  context,
                  icon: Icons.person,
                  label: character.isFatherDeceased ? 'Ayah (${character.fatherName}) (Wafat)' : 'Ayah (${character.fatherName})',
                  status: 'Kandung',
                  color: character.isFatherDeceased ? Colors.grey : Colors.blue,
                  relationshipValue: character.isFatherDeceased ? 0 : (character.fatherRelationship ?? 50),
                  ageText: character.fatherAge != null ? '${character.fatherAge} tahun' : 'Tidak diketahui',
                  isDeceased: character.isFatherDeceased,
                ),
              if (character.motherName != null)
                _buildFamilyItem(
                  context,
                  icon: Icons.person_outline,
                  label: character.isMotherDeceased ? 'Ibu (${character.motherName}) (Wafat)' : 'Ibu (${character.motherName})',
                  status: 'Kandung',
                  color: character.isMotherDeceased ? Colors.grey : Colors.pink,
                  relationshipValue: character.isMotherDeceased ? 0 : (character.motherRelationship ?? 50),
                  ageText: character.motherAge != null ? '${character.motherAge} tahun' : 'Tidak diketahui',
                  isDeceased: character.isMotherDeceased,
                ),
              if (character.stepFatherName != null)
                _buildFamilyItem(
                  context,
                  icon: Icons.person_add,
                  label: character.isStepFatherDeceased ? 'Ayah Tiri (${character.stepFatherName}) (Wafat)' : 'Ayah Tiri (${character.stepFatherName})',
                  status: 'Tiri',
                  color: character.isStepFatherDeceased ? Colors.grey : Colors.blueGrey,
                  relationshipValue: character.isStepFatherDeceased ? 0 : (character.stepFatherRelationship ?? 50),
                  ageText: character.stepFatherAge != null ? '${character.stepFatherAge} tahun' : 'Tidak diketahui',
                  isDeceased: character.isStepFatherDeceased,
                ),
              if (character.stepMotherName != null)
                _buildFamilyItem(
                  context,
                  icon: Icons.person_add,
                  label: character.isStepMotherDeceased ? 'Ibu Tiri (${character.stepMotherName}) (Wafat)' : 'Ibu Tiri (${character.stepMotherName})',
                  status: 'Tiri',
                  color: character.isStepMotherDeceased ? Colors.grey : Colors.pinkAccent,
                  relationshipValue: character.isStepMotherDeceased ? 0 : (character.stepMotherRelationship ?? 50),
                  ageText: character.stepMotherAge != null ? '${character.stepMotherAge} tahun' : 'Tidak diketahui',
                  isDeceased: character.isStepMotherDeceased,
                ),

              // ============================================
              // 2. BAGIAN PACAR / TUNANGAN / SUAMI / ISTRI
              // ============================================
              if (character.partner != null) ...[
                const Divider(height: 32),
                Text(
                  character.partner!['relation'] == 'Pacar'
                      ? '💖 Pacar'
                      : character.partner!['relation'] == 'Tunangan'
                          ? '💍 Tunangan'
                          : '👩❤️👨 Pasangan Hidup',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
                ),
                const SizedBox(height: 8),
                _buildFamilyItem(
                  context,
                  icon: character.partner!['relation'] == 'Pacar'
                      ? Icons.favorite
                      : character.partner!['relation'] == 'Tunangan'
                          ? Icons.diamond
                          : Icons.wc,
                  label: character.partner!['isDeceased'] == 'true' ? '${character.partner!['name']!} (Wafat)' : character.partner!['name']!,
                  status: character.partner!['relation']!,
                  color: character.partner!['isDeceased'] == 'true' ? Colors.grey : Colors.redAccent,
                  relationshipValue: int.tryParse(character.partner!['relationship'] ?? '80') ?? 80,
                  ageText: '${character.partner!['age']} tahun',
                  isDeceased: character.partner!['isDeceased'] == 'true',
                ),
              ],

              // ============================================
              // 2a. BAGIAN PACAR KEDUA (SELINGKUHAN)
              // ============================================
              if (character.secondPartner != null) ...[
                const Divider(height: 32),
                Row(
                  children: [
                    const Text('💔 Hubungan Rahasia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Selingkuhan', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildFamilyItem(
                  context,
                  icon: Icons.heart_broken,
                  label: character.secondPartner!['isDeceased'] == 'true'
                      ? '${character.secondPartner!['name']!} (Wafat)'
                      : character.secondPartner!['name']!,
                  status: 'Pacar (Rahasia)',
                  color: character.secondPartner!['isDeceased'] == 'true' ? Colors.grey : Colors.deepOrange,
                  relationshipValue: int.tryParse(character.secondPartner!['relationship'] ?? '70') ?? 70,
                  ageText: '${character.secondPartner!['age']} tahun',
                  isDeceased: character.secondPartner!['isDeceased'] == 'true',
                ),
              ],

              // ============================================
              // 2b. BAGIAN MERTUA (AYAH & IBU MERTUA)
              // ============================================

              if (character.fatherInLawName != null || character.motherInLawName != null) ...[
                const Divider(height: 32),
                const Text('👵👴 Mertua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                const SizedBox(height: 8),
                if (character.fatherInLawName != null)
                  _buildFamilyItem(
                    context,
                    icon: Icons.person,
                    label: character.isFatherInLawDeceased ? 'Ayah Mertua (${character.fatherInLawName}) (Wafat)' : 'Ayah Mertua (${character.fatherInLawName})',
                    status: 'Mertua',
                    color: character.isFatherInLawDeceased ? Colors.grey : Colors.blueGrey,
                    relationshipValue: character.isFatherInLawDeceased ? 0 : (character.fatherInLawRelationship ?? 50),
                    ageText: character.fatherInLawAge != null ? '${character.fatherInLawAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isFatherInLawDeceased,
                  ),
                if (character.motherInLawName != null)
                  _buildFamilyItem(
                    context,
                    icon: Icons.person_outline,
                    label: character.isMotherInLawDeceased ? 'Ibu Mertua (${character.motherInLawName}) (Wafat)' : 'Ibu Mertua (${character.motherInLawName})',
                    status: 'Mertua',
                    color: character.isMotherInLawDeceased ? Colors.grey : Colors.brown,
                    relationshipValue: character.isMotherInLawDeceased ? 0 : (character.motherInLawRelationship ?? 50),
                    ageText: character.motherInLawAge != null ? '${character.motherInLawAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isMotherInLawDeceased,
                  ),
              ],

              const Divider(height: 32),

              // ============================================
              // 3. BAGIAN SAUDARA & DIRI SENDIRI
              // ============================================
              const Text('👫 Saudara & Diri Anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 8),
              ...childrenList.map((child) {
                final bool isPlayer = child['isPlayer'] as bool;
                final String name = child['name'] as String;
                final String gender = child['gender'] as String;
                final String relation = child['relation'] as String;
                final int age = child['age'] as int;
                final bool isDeceased = child['isDeceased'] as bool;
                final bool isMale = gender == 'Laki-laki';

                if (isPlayer) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.withOpacity(0.4), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(isMale ? Icons.face : Icons.face_3, color: Colors.teal, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
                              const SizedBox(height: 2),
                              Text('Umur: $age tahun', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                            ],
                          ),
                        ),
                        if (character.gender.trim().toLowerCase() == 'perempuan' && character.isPregnant) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.pink.withOpacity(0.3)),
                            ),
                            child: const Text('Hamil 🍼', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.pink)),
                          ),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.withOpacity(0.3)),
                          ),
                          child: const Text('Anda', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return _buildFamilyItem(
                    context,
                    icon: isMale ? Icons.male : Icons.female,
                    label: isDeceased ? '$name ($relation) (Wafat)' : '$name ($relation)',
                    status: 'Kandung',
                    color: isDeceased ? Colors.grey : (isMale ? Colors.indigo : Colors.purple),
                    relationshipValue: child['relationship'] as int,
                    ageText: '$age tahun',
                    isDeceased: isDeceased,
                  );
                }
              }).toList(),

              // ============================================
              // 5. BAGIAN ANAK (JIKA ADA)
              // ============================================
              if (character.children.isNotEmpty) ...[
                const Divider(height: 32),
                const Text('👶 Anak Anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                const SizedBox(height: 8),
                ...character.children.map((child) {
                  final String name = child['name'] ?? 'Anak';
                  final String gender = child['gender'] ?? 'Laki-laki';
                  final int relVal = int.tryParse(child['relationship'] ?? '80') ?? 80;
                  final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
                  final bool isDeceased = child['isDeceased'] == 'true';
                  final bool isMale = gender == 'Laki-laki';

                  return _buildChildItem(
                    context,
                    icon: isMale ? Icons.boy : Icons.girl,
                    label: isDeceased ? '$name (Wafat)' : name,
                    status: gender,
                    color: isDeceased ? Colors.grey : Colors.teal,
                    relationshipValue: relVal,
                    ageText: '$childAge tahun',
                    isDeceased: isDeceased,
                  );
                }).toList(),
              ],
              const Divider(height: 32),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup Menu'),
            ),
          ],
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink.withOpacity(0.2),
        foregroundColor: Colors.pink,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.pink, width: 1.5),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 28, color: Colors.pink),
          SizedBox(height: 4),
          Text(
            'Hubungan',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.pink),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: Kartu Anggota Keluarga / Relasi (Navigasi ke ActionMenu) ---
  Widget _buildFamilyItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String status,
    required Color color,
    required int relationshipValue,
    required String ageText,
    bool isDeceased = false,
  }) {
    return InkWell(
      onTap: isDeceased ? null : () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionMenuScreen(
              character: character,
              targetName: label,
              targetRole: status,
            ),
          ),
        ).then((_) {
          onRefresh();
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDeceased ? Colors.grey.shade600 : Colors.black87,
                          decoration: isDeceased ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Umur: $ageText', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(
                    isDeceased ? 'Wafat' : status,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                if (!isDeceased) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ],
            ),
            if (!isDeceased) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Hubungan: ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: relationshipValue / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          relationshipValue > 65
                              ? Colors.green
                              : relationshipValue > 35
                                  ? Colors.amber
                                  : Colors.red,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$relationshipValue%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: relationshipValue > 65
                          ? Colors.green
                          : relationshipValue > 35
                              ? Colors.amber
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Kartu Anak ---
  Widget _buildChildItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String status,
    required Color color,
    required int relationshipValue,
    required String ageText,
    bool isDeceased = false,
  }) {
    return InkWell(
      onTap: isDeceased ? null : () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionMenuScreen(
              character: character,
              targetName: label,
              targetRole: status,
            ),
          ),
        ).then((_) {
          onRefresh();
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDeceased ? Colors.grey.shade600 : Colors.black87,
                          decoration: isDeceased ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Umur: $ageText', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(
                    isDeceased ? 'Wafat' : status,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                if (!isDeceased) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ],
            ),
            if (!isDeceased) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Hubungan: ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: relationshipValue / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          relationshipValue > 65
                              ? Colors.green
                              : relationshipValue > 35
                                  ? Colors.amber
                                  : Colors.red,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$relationshipValue%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: relationshipValue > 65
                          ? Colors.green
                          : relationshipValue > 35
                              ? Colors.amber
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
