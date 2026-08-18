// lib/game/widgets/hubungan_menu/relationship_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart'; // IMPORT HALAMAN AKTION

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

        // --- CONSTRUCT UNIFIED LIST OF CHILDREN (SIBLINGS + PLAYER) ---
        final List<Map<String, dynamic>> childrenList = [];

        // 1. Masukkan semua saudara kandung yang SUDAH LAHIR (age >= 0)
        for (var sib in character.siblings) {
          final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
          final bool isDeceased = sib['isDeceased'] == 'true';
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

        // 3. Urutkan dari yang tertua ke termuda (descending) berdasarkan umur
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
              const Text('👨‍👩‍👧 Orangtua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
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
                          : '👩‍❤️‍👨 Pasangan Hidup',
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

              const Divider(height: 32),

              // ============================================
              // 3. BAGIAN SAUDARA & DIRI SENDIRI (URUTAN UMUR)
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
                  // Card Khusus Player (Diri Sendiri, tidak bisa diklik)
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
                              Text(
                                name,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Umur: $age tahun',
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'Anda',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Card Saudara Kandung (Bisa diklik menuju Aksi jika hidup)
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
              // 4. BAGIAN ANAK (JIKA ADA)
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
                    father: child['father'] ?? 'Tidak diketahui',
                    mother: child['mother'] ?? 'Tidak diketahui',
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

  // --- WIDGET HELPER: Menampilkan Kartu Anggota Keluarga / Relasi ---
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
        // 1. Tutup menu dialog Hubungan & Keluarga
        Navigator.pop(context); 
        // 2. Pindah ke Halaman Aksi
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
          // Panggil onRefresh setelah menutup Halaman Aksi agar Dashboard & status uang/kepuasan ter-refresh
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
                      Text(
                        'Umur: $ageText',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
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
              // Progress Bar Tingkat Kepuasan / Hubungan
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

  // --- WIDGET HELPER: Menampilkan Kartu Anak (Klik Memunculkan Orangtua Asal Usul) ---
  Widget _buildChildItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String status,
    required Color color,
    required int relationshipValue,
    required String ageText,
    required String father,
    required String mother,
    bool isDeceased = false,
  }) {
    return InkWell(
      onTap: () {
        // Tampilkan dialog silsilah anak
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Umur: $ageText', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Gender: $status', style: const TextStyle(fontSize: 14)),
                if (isDeceased) ...[
                  const SizedBox(height: 8),
                  const Text('Status: Meninggal Dunia 🥀', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDeceased ? Colors.grey.shade100 : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDeceased ? Colors.grey.shade300 : Colors.teal.shade200),
                  ),
                  child: Text(
                    'Anak hasil hubungan dari:\n👨 Ayah: $father\n👩 Ibu: $mother',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDeceased ? Colors.grey.shade700 : Colors.teal),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
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
                      Text(
                        'Umur: $ageText',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
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
                const SizedBox(width: 8),
                const Icon(Icons.info_outline, size: 14, color: Colors.grey),
              ],
            ),
            if (!isDeceased) ...[
              const SizedBox(height: 8),
              // Progress Bar Tingkat Kepuasan / Hubungan
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