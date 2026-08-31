// lib/game/widgets/hubungan_menu/relationship_button/relationship_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class RelationshipButton extends StatefulWidget {
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
  State<RelationshipButton> createState() => _RelationshipButtonState();
}

class _RelationshipButtonState extends State<RelationshipButton> {
  StateSetter? _dialogSetState;

  @override
  Widget build(BuildContext context) {
    final Character character = widget.character;
    final bool isAlive = widget.isAlive;
    final VoidCallback onRefresh = widget.onRefresh;
    final bool isImprisoned = character.isImprisoned;
    return ElevatedButton(
      style: isImprisoned
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.grey.shade600,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            )
          : ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.withOpacity(0.2),
              foregroundColor: Colors.pink,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.pink, width: 1.5),
              ),
            ),
      onPressed: () {
        if (isImprisoned) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Akses ditolak! Kamu sedang berada di dalam penjara.')),
          );
          return;
        }
        if (!isAlive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Karakter sudah meninggal!')),
          );
          return;
        }

        DialogHelper.show(
          context: context,
          title: 'Hubungan & Keluarga',
          isNotification: false,
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              _dialogSetState = setDialogState;

              // Bersihkan partner yang secara tidak sengaja bentrok dengan nama anak
              if (character.partner != null && character.children.any((c) => c['name'] == character.partner!['name'])) {
                character.partner = null;
              }
              if (character.secondPartner != null && character.children.any((c) => c['name'] == character.secondPartner!['name'])) {
                character.secondPartner = null;
              }
              if (character.thirdPartner != null && character.children.any((c) => c['name'] == character.thirdPartner!['name'])) {
                character.thirdPartner = null;
              }
              if (character.fourthPartner != null && character.children.any((c) => c['name'] == character.fourthPartner!['name'])) {
                character.fourthPartner = null;
              }
              if (character.fifthPartner != null && character.children.any((c) => c['name'] == character.fifthPartner!['name'])) {
                character.fifthPartner = null;
              }

              // Sinkronkan status kematian pasangan/keluarga & rekan kerja/sekolah
              character.syncNPCsAndPartners();
              character.syncPartnerDeathStatus();
              character.syncSocialRelationships();

              // --- BUAT DAFTAR SAUDARA & DIRI SENDIRI ---
              final List<Map<String, dynamic>> childrenList = [];

              // 1. Masukkan semua saudara kandung yang SUDAH LAHIR (age >= 0)
              for (var sib in character.siblings) {
                final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
                final bool isDeceased = sib['isDeceased'] == 'true';

                // Tampilkan saudara meskipun mereka berpacaran dengan player
                if (sibAge >= 0) {
                  childrenList.add({
                    'isPlayer': false,
                    'name': sib['name'] ?? 'Saudara',
                    'gender': sib['gender'] ?? 'Laki-laki',
                    'relation': sib['relation'] ?? 'Saudara',
                    'relationship': int.tryParse(sib['relationship'] ?? '50') ?? 50,
                    'age': sibAge,
                    'isDeceased': isDeceased,
                    'skinColor': sib['skinColor'],
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

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ============================================
              // 1. BAGIAN ORANGTUA
              // ============================================
              if (character.isFatherDivorced || character.isMotherDivorced) ...[
                if (character.fatherName != null) ...[
                  const Text('👨 Ayah (Terpisah)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  _buildFamilyItem(
                    context,
                    icon: Icons.person,
                    label: character.isFatherDeceased
                        ? 'Ayah (${character.fatherName}) (Wafat)'
                        : character.isFatherImprisoned
                            ? 'Ayah (${character.fatherName}) (Dipenjara)'
                            : 'Ayah (${character.fatherName})',
                    status: character.isFatherImprisoned ? 'Dipenjara' : 'Cerai',
                    color: character.isFatherDeceased ? Colors.grey : Colors.blue,
                    relationshipValue: character.isFatherDeceased ? 0 : (character.fatherRelationship ?? 50),
                    ageText: character.fatherAge != null ? '${character.fatherAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isFatherDeceased,
                    isLivingTogether: character.custodyParent == 'Ayah' && !character.isFatherImprisoned,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.fatherName!,
                      gender: 'Laki-laki',
                      age: character.fatherAge ?? 40,
                      happiness: character.isFatherDeceased ? 0 : (character.fatherRelationship ?? 50),
                      forcedSkinColor: character.fatherSkinColor,
                    ),
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
                      isLivingTogether: character.custodyParent == 'Ayah',
                      avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                        name: character.stepMotherName!,
                        gender: 'Perempuan',
                        age: character.stepMotherAge ?? 40,
                        happiness: character.isStepMotherDeceased ? 0 : (character.stepMotherRelationship ?? 50),
                        forcedSkinColor: character.stepMotherSkinColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
                if (character.motherName != null) ...[
                  const Text('👩 Ibu (Terpisah)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  _buildFamilyItem(
                    context,
                    icon: Icons.person_outline,
                    label: character.isMotherDeceased
                        ? 'Ibu (${character.motherName}) (Wafat)'
                        : character.isMotherImprisoned
                            ? 'Ibu (${character.motherName}) (Dipenjara)'
                            : 'Ibu (${character.motherName})',
                    status: character.isMotherImprisoned ? 'Dipenjara' : 'Cerai',
                    color: character.isMotherDeceased ? Colors.grey : Colors.pink,
                    relationshipValue: character.isMotherDeceased ? 0 : (character.motherRelationship ?? 50),
                    ageText: character.motherAge != null ? '${character.motherAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isMotherDeceased,
                    isLivingTogether: character.custodyParent == 'Ibu' && !character.isMotherImprisoned,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.motherName!,
                      gender: 'Perempuan',
                      age: character.motherAge ?? 40,
                      happiness: character.isMotherDeceased ? 0 : (character.motherRelationship ?? 50),
                      forcedSkinColor: character.motherSkinColor,
                    ),
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
                      isLivingTogether: character.custodyParent == 'Ibu',
                      avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                        name: character.stepFatherName!,
                        gender: 'Laki-laki',
                        age: character.stepFatherAge ?? 40,
                        happiness: character.isStepFatherDeceased ? 0 : (character.stepFatherRelationship ?? 50),
                        forcedSkinColor: character.stepFatherSkinColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ] else ...[
                const Text('👨👩👧 Orangtua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                const SizedBox(height: 8),
                if (character.fatherName != null)
                  _buildFamilyItem(
                    context,
                    icon: Icons.person,
                    label: character.isFatherDeceased
                        ? 'Ayah (${character.fatherName}) (Wafat)'
                        : character.isFatherImprisoned
                            ? 'Ayah (${character.fatherName}) (Dipenjara)'
                            : 'Ayah (${character.fatherName})',
                    status: character.isFatherImprisoned ? 'Dipenjara' : 'Kandung',
                    color: character.isFatherDeceased ? Colors.grey : Colors.blue,
                    relationshipValue: character.isFatherDeceased ? 0 : (character.fatherRelationship ?? 50),
                    ageText: character.fatherAge != null ? '${character.fatherAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isFatherDeceased,
                    isLivingTogether: !character.isFatherImprisoned,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.fatherName!,
                      gender: 'Laki-laki',
                      age: character.fatherAge ?? 40,
                      happiness: character.isFatherDeceased ? 0 : (character.fatherRelationship ?? 50),
                      forcedSkinColor: character.fatherSkinColor,
                    ),
                  ),
                if (character.stepMotherName != null && !(character.isFatherDivorced || character.isMotherDivorced))
                  _buildFamilyItem(
                    context,
                    icon: Icons.person_add,
                    label: character.isStepMotherDeceased ? 'Ibu Tiri (${character.stepMotherName}) (Wafat)' : 'Ibu Tiri (${character.stepMotherName})',
                    status: 'Tiri',
                    color: character.isStepMotherDeceased ? Colors.grey : Colors.pinkAccent,
                    relationshipValue: character.isStepMotherDeceased ? 0 : (character.stepMotherRelationship ?? 50),
                    ageText: character.stepMotherAge != null ? '${character.stepMotherAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isStepMotherDeceased,
                    isLivingTogether: !character.isFatherImprisoned,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.stepMotherName!,
                      gender: 'Perempuan',
                      age: character.stepMotherAge ?? 40,
                      happiness: character.isStepMotherDeceased ? 0 : (character.stepMotherRelationship ?? 50),
                      forcedSkinColor: character.stepMotherSkinColor,
                    ),
                  ),
                if (character.motherName != null)
                  _buildFamilyItem(
                    context,
                    icon: Icons.person_outline,
                    label: character.isMotherDeceased
                        ? 'Ibu (${character.motherName}) (Wafat)'
                        : character.isMotherImprisoned
                            ? 'Ibu (${character.motherName}) (Dipenjara)'
                            : 'Ibu (${character.motherName})',
                    status: character.isMotherImprisoned ? 'Dipenjara' : 'Kandung',
                    color: character.isMotherDeceased ? Colors.grey : Colors.pink,
                    relationshipValue: character.isMotherDeceased ? 0 : (character.motherRelationship ?? 50),
                    ageText: character.motherAge != null ? '${character.motherAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isMotherDeceased,
                    isLivingTogether: !character.isMotherImprisoned,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.motherName!,
                      gender: 'Perempuan',
                      age: character.motherAge ?? 40,
                      happiness: character.isMotherDeceased ? 0 : (character.motherRelationship ?? 50),
                      forcedSkinColor: character.motherSkinColor,
                    ),
                  ),
                if (character.stepFatherName != null && !(character.isFatherDivorced || character.isMotherDivorced))
                  _buildFamilyItem(
                    context,
                    icon: Icons.person_add,
                    label: character.isStepFatherDeceased ? 'Ayah Tiri (${character.stepFatherName}) (Wafat)' : 'Ayah Tiri (${character.stepFatherName})',
                    status: 'Tiri',
                    color: character.isStepFatherDeceased ? Colors.grey : Colors.blueGrey,
                    relationshipValue: character.isStepFatherDeceased ? 0 : (character.stepFatherRelationship ?? 50),
                    ageText: character.stepFatherAge != null ? '${character.stepFatherAge} tahun' : 'Tidak diketahui',
                    isDeceased: character.isStepFatherDeceased,
                    isLivingTogether: !character.isMotherImprisoned,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.stepFatherName!,
                      gender: 'Laki-laki',
                      age: character.stepFatherAge ?? 40,
                      happiness: character.isStepFatherDeceased ? 0 : (character.stepFatherRelationship ?? 50),
                      forcedSkinColor: character.stepFatherSkinColor,
                    ),
                  ),
              ],


              // ============================================
              // 2. BAGIAN PACAR / TUNANGAN / SUAMI / ISTRI
              // ============================================
              if (character.partner != null) ...[
                const Divider(height: 32),
                Row(
                  children: [
                    Text(
                      (character.partner!['relation'] ?? 'Pacar') == 'Pacar'
                          ? '💖 Pacar'
                          : (character.partner!['relation'] ?? 'Pacar') == 'Tunangan'
                              ? '💍 Tunangan'
                              : '👩❤️👨 Pasangan Hidup',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
                    ),
                    if ((character.partner!['relation'] ?? 'Pacar') == 'Pacar') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Pacar Resmi',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                _buildFamilyItem(
                  context,
                  icon: (character.partner!['relation'] ?? 'Pacar') == 'Pacar'
                      ? Icons.favorite
                      : (character.partner!['relation'] ?? 'Pacar') == 'Tunangan'
                          ? Icons.diamond
                          : Icons.wc,
                  label: character.partner!['isDeceased'] == 'true'
                      ? '${character.partner!['name'] ?? 'Pasangan'} (Wafat)'
                      : (character.partner!['name'] ?? 'Pasangan'),
                  status: character.partner!['relation'] ?? 'Pacar',
                  color: character.partner!['isDeceased'] == 'true' ? Colors.grey : Colors.redAccent,
                  relationshipValue: int.tryParse(character.partner!['relationship'] ?? '80') ?? 80,
                  ageText: '${character.partner!['age'] ?? '20'} tahun',
                  avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                    name: character.partner!['name'] ?? 'Pasangan',
                    gender: character.partner!['gender'] ?? 'Perempuan',
                    age: int.tryParse(character.partner!['age'] ?? '20') ?? 20,
                    happiness: int.tryParse(character.partner!['relationship'] ?? '80') ?? 80,
                    forcedSkinColor: character.getFamilyMemberSkinColor(character.partner!['name'] ?? '') ?? character.partner!['skinColor'],
                  ),
                ),
                if (character.secondPartner != null && !character.isHavingAffair) ...[
                  const SizedBox(height: 12),
                  const Text('❤️ Pacar Kedua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  _buildFamilyItem(
                    context,
                    icon: Icons.favorite,
                    label: character.secondPartner!['isDeceased'] == 'true'
                        ? '${character.secondPartner!['name'] ?? 'Pacar'} (Wafat)'
                        : (character.secondPartner!['name'] ?? 'Pacar'),
                    status: 'Pacar Kedua',
                    color: character.secondPartner!['isDeceased'] == 'true' ? Colors.grey : Colors.redAccent,
                    relationshipValue: int.tryParse(character.secondPartner!['relationship'] ?? '70') ?? 70,
                    ageText: '${character.secondPartner!['age'] ?? '20'} tahun',
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.secondPartner!['name'] ?? 'Pacar',
                      gender: character.secondPartner!['gender'] ?? 'Perempuan',
                      age: int.tryParse(character.secondPartner!['age'] ?? '20') ?? 20,
                      happiness: int.tryParse(character.secondPartner!['relationship'] ?? '70') ?? 70,
                      forcedSkinColor: character.getFamilyMemberSkinColor(character.secondPartner!['name'] ?? '') ?? character.secondPartner!['skinColor'],
                    ),
                  ),
                ],
                if (character.thirdPartner != null) ...[
                  const SizedBox(height: 12),
                  const Text('❤️ Pacar Ketiga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  _buildFamilyItem(
                    context,
                    icon: Icons.favorite,
                    label: character.thirdPartner!['isDeceased'] == 'true'
                        ? '${character.thirdPartner!['name'] ?? 'Pacar'} (Wafat)'
                        : (character.thirdPartner!['name'] ?? 'Pacar'),
                    status: 'Pacar Ketiga',
                    color: character.thirdPartner!['isDeceased'] == 'true' ? Colors.grey : Colors.redAccent,
                    relationshipValue: int.tryParse(character.thirdPartner!['relationship'] ?? '70') ?? 70,
                    ageText: '${character.thirdPartner!['age'] ?? '20'} tahun',
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.thirdPartner!['name'] ?? 'Pacar',
                      gender: character.thirdPartner!['gender'] ?? 'Perempuan',
                      age: int.tryParse(character.thirdPartner!['age'] ?? '20') ?? 20,
                      happiness: int.tryParse(character.thirdPartner!['relationship'] ?? '70') ?? 70,
                      forcedSkinColor: character.getFamilyMemberSkinColor(character.thirdPartner!['name'] ?? '') ?? character.thirdPartner!['skinColor'],
                    ),
                  ),
                ],
                if (character.fourthPartner != null) ...[
                  const SizedBox(height: 12),
                  const Text('❤️ Pacar Keempat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  _buildFamilyItem(
                    context,
                    icon: Icons.favorite,
                    label: character.fourthPartner!['isDeceased'] == 'true'
                        ? '${character.fourthPartner!['name'] ?? 'Pacar'} (Wafat)'
                        : (character.fourthPartner!['name'] ?? 'Pacar'),
                    status: 'Pacar Keempat',
                    color: character.fourthPartner!['isDeceased'] == 'true' ? Colors.grey : Colors.redAccent,
                    relationshipValue: int.tryParse(character.fourthPartner!['relationship'] ?? '70') ?? 70,
                    ageText: '${character.fourthPartner!['age'] ?? '20'} tahun',
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.fourthPartner!['name'] ?? 'Pacar',
                      gender: character.fourthPartner!['gender'] ?? 'Perempuan',
                      age: int.tryParse(character.fourthPartner!['age'] ?? '20') ?? 20,
                      happiness: int.tryParse(character.fourthPartner!['relationship'] ?? '70') ?? 70,
                      forcedSkinColor: character.getFamilyMemberSkinColor(character.fourthPartner!['name'] ?? '') ?? character.fourthPartner!['skinColor'],
                    ),
                  ),
                ],
                if (character.fifthPartner != null) ...[
                  const SizedBox(height: 12),
                  const Text('❤️ Pacar Kelima', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  _buildFamilyItem(
                    context,
                    icon: Icons.favorite,
                    label: character.fifthPartner!['isDeceased'] == 'true'
                        ? '${character.fifthPartner!['name'] ?? 'Pacar'} (Wafat)'
                        : (character.fifthPartner!['name'] ?? 'Pacar'),
                    status: 'Pacar Kelima',
                    color: character.fifthPartner!['isDeceased'] == 'true' ? Colors.grey : Colors.redAccent,
                    relationshipValue: int.tryParse(character.fifthPartner!['relationship'] ?? '70') ?? 70,
                    ageText: '${character.fifthPartner!['age'] ?? '20'} tahun',
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.fifthPartner!['name'] ?? 'Pacar',
                      gender: character.fifthPartner!['gender'] ?? 'Perempuan',
                      age: int.tryParse(character.fifthPartner!['age'] ?? '20') ?? 20,
                      happiness: int.tryParse(character.fifthPartner!['relationship'] ?? '70') ?? 70,
                      forcedSkinColor: character.getFamilyMemberSkinColor(character.fifthPartner!['name'] ?? '') ?? character.fifthPartner!['skinColor'],
                    ),
                  ),
                ],
              ],

              // ============================================
              // 2a. BAGIAN HUBUNGAN RAHASIA (SELINGKUHAN)
              // ============================================
              if (character.isHavingAffair) ...[
                () {
                  final List<Map<String, String>> secretList = [];
                  if (character.secondPartner != null) {
                    secretList.add(character.secondPartner!);
                  }
                  secretList.addAll(character.secretPartners);

                  if (secretList.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      ...secretList.map((sec) {
                        final bool isDeceased = sec['isDeceased'] == 'true';
                        final String sName = sec['name'] ?? '';
                        final String relationRole = sec['relation'] ?? 'Pacar (Rahasia)';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildFamilyItem(
                            context,
                            icon: Icons.heart_broken,
                            label: isDeceased ? '$sName (Wafat)' : sName,
                            status: relationRole,
                            color: isDeceased ? Colors.grey : Colors.deepOrange,
                            relationshipValue: int.tryParse(sec['relationship'] ?? '70') ?? 70,
                            ageText: sec['age'] != null ? '${sec['age']} tahun' : 'Tidak diketahui',
                            isDeceased: isDeceased,
                            avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                              name: sName,
                              gender: sec['gender'] ?? 'Perempuan',
                              age: int.tryParse(sec['age'] ?? '20') ?? 20,
                              happiness: int.tryParse(sec['relationship'] ?? '70') ?? 70,
                              forcedSkinColor: character.getFamilyMemberSkinColor(sName) ?? sec['skinColor'],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }(),
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
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.fatherInLawName!,
                      gender: 'Laki-laki',
                      age: character.fatherInLawAge ?? 50,
                      happiness: character.isFatherInLawDeceased ? 0 : (character.fatherInLawRelationship ?? 50),
                    ),
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
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: character.motherInLawName!,
                      gender: 'Perempuan',
                      age: character.motherInLawAge ?? 50,
                      happiness: character.isMotherInLawDeceased ? 0 : (character.motherInLawRelationship ?? 50),
                    ),
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
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.teal.withOpacity(0.15),
                          child: Image(
                            image: AvatarImageCache.getImageProvider(
                              AvatarAgeRules.getAgeBasedAvatarUrl(
                                character,
                                happiness: character.happiness,
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 1.5),
                              );
                            },
                            width: 28,
                            height: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
                              const SizedBox(height: 2),
                              Text('Umur: $age tahun', style: TextStyle(fontSize: 11, color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54)),
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
                  final bool isParentsDivorced = character.isFatherDivorced || character.isMotherDivorced;
                  String? custodyBadgeText;
                  Color? custodyBadgeColor;
                  if (isParentsDivorced && !isDeceased) {
                    final int hash = name.codeUnits.fold(0, (prev, element) => prev + element);
                    final String custody = (hash % 2 == 0) ? 'Ayah' : 'Ibu';
                    if (custody == 'Ayah') {
                      custodyBadgeText = 'Ikut Ayah';
                      custodyBadgeColor = Colors.blue;
                    } else {
                      custodyBadgeText = 'Ikut Ibu';
                      custodyBadgeColor = Colors.pink;
                    }
                  }

                  return _buildFamilyItem(
                    context,
                    icon: isMale ? Icons.male : Icons.female,
                    label: isDeceased ? '$name ($relation) (Wafat)' : '$name ($relation)',
                    status: 'Kandung',
                    color: isDeceased ? Colors.grey : (isMale ? Colors.indigo : Colors.purple),
                    relationshipValue: child['relationship'] as int,
                    ageText: '$age tahun',
                    isDeceased: isDeceased,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: name,
                      gender: gender,
                      age: age,
                      happiness: child['relationship'] as int,
                      forcedSkinColor: child['skinColor'] as String?,
                    ),
                    extraBadgeText: custodyBadgeText,
                    extraBadgeColor: custodyBadgeColor,
                  );
                }
              }).toList(),

              // ============================================
              // 4. BAGIAN MANTAN PACAR (JIKA ADA)
              // ============================================
              if (character.exPartners.isNotEmpty) ...[
                const Divider(height: 32),
                const Text('💔 Mantan Pacar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                const SizedBox(height: 8),
                ...character.exPartners.map((ex) {
                  final String name = ex['name'] ?? 'Mantan Pacar';
                  final String gender = ex['gender'] ?? 'Perempuan';
                  final int relVal = int.tryParse(ex['relationship'] ?? '30') ?? 30;
                  final int exAge = int.tryParse(ex['age'] ?? '12') ?? 12;
                  final bool isDeceased = ex['isDeceased'] == 'true';
                  final bool isMale = gender == 'Laki-laki';

                  return _buildFamilyItem(
                    context,
                    icon: isMale ? Icons.male : Icons.female,
                    label: isDeceased ? '$name (Mantan Pacar) (Wafat)' : name,
                    status: 'Mantan Pacar',
                    color: isDeceased ? Colors.grey : Colors.pinkAccent,
                    relationshipValue: relVal,
                    ageText: '$exAge tahun',
                    isDeceased: isDeceased,
                    avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                      name: name,
                      gender: gender,
                      age: exAge,
                      happiness: relVal,
                    ),
                  );
                }).toList(),
              ],

              // ============================================
              // 5. BAGIAN ANAK (JIKA ADA)
              // ============================================
              if (character.children.isNotEmpty) ...[
                const Divider(height: 32),
                (() {
                  final normalChildren = character.children.where((child) => !character.donorRecipients.any((r) => r['childName'] == child['name'])).toList();
                  final donorChildren = character.children.where((child) => character.donorRecipients.any((r) => r['childName'] == child['name'])).toList();
                  
                  final List<Widget> widgets = [];
                  if (normalChildren.isNotEmpty) {
                    widgets.add(const Text('👶 Anak Anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)));
                    widgets.add(const SizedBox(height: 8));
                    widgets.addAll(normalChildren.map((child) {
                      final String name = child['name'] ?? 'Anak';
                      final String gender = child['gender'] ?? 'Laki-laki';
                      final int relVal = int.tryParse(child['relationship'] ?? '80') ?? 80;
                      final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
                      final bool isDeceased = child['isDeceased'] == 'true';
                      final bool isMale = gender == 'Laki-laki';
                      final String parentingStyle = character.parentingStyles[name] ?? 'Balanced';

                      return _buildChildItem(
                        context,
                        icon: isMale ? Icons.boy : Icons.girl,
                        label: isDeceased ? '$name (Wafat)' : name,
                        status: gender,
                        color: isDeceased ? Colors.grey : Colors.teal,
                        relationshipValue: relVal,
                        ageText: '$childAge tahun',
                        isDeceased: isDeceased,
                        parentingStyle: parentingStyle,
                        avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                          name: name,
                          gender: gender,
                          age: childAge,
                          happiness: relVal,
                          forcedSkinColor: child['skinColor'],
                        ),
                      );
                    }).toList());
                  }

                  if (donorChildren.isNotEmpty) {
                    if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 16));
                    widgets.add(const Text('🧬 Anak Hasil Donor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)));
                    widgets.add(const SizedBox(height: 8));
                    widgets.addAll(donorChildren.map((child) {
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
                        status: '$gender (Donor)',
                        color: isDeceased ? Colors.grey : Colors.teal,
                        relationshipValue: relVal,
                        ageText: '$childAge tahun',
                        isDeceased: isDeceased,
                        avatarUrl: AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                          name: name,
                          gender: gender,
                          age: childAge,
                          happiness: relVal,
                          forcedSkinColor: child['skinColor'],
                        ),
                      );
                    }).toList());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgets,
                  );
                })(),
              ],
              const Divider(height: 32),
            ],
            );
          },
        ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup Menu'),
            ),
          ],
        );
      },
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
    String? avatarUrl,
    bool isLivingTogether = false,
    String? extraBadgeText,
    Color? extraBadgeColor,
  }) {
    return InkWell(
      onTap: isDeceased ? null : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionMenuScreen(
              character: widget.character,
              targetName: label,
              targetRole: status,
            ),
          ),
        ).then((_) {
          widget.onRefresh();
          if (_dialogSetState != null) {
            _dialogSetState!(() {});
          }
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
                if (avatarUrl != null)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: color.withOpacity(0.15),
                    child: Image(
                      image: AvatarImageCache.getImageProvider(avatarUrl),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        );
                      },
                      width: 28,
                      height: 28,
                    ),
                  )
                else
                  Icon(icon, color: color, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
  label,
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: isDeceased ? Colors.grey.shade600 : null, // null → ikut tema
  ),
),
                      const SizedBox(height: 2),
Text('Umur: $ageText',
    style: TextStyle(
      fontSize: 11,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white54
          : Colors.black54,
    )),
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
                if (extraBadgeText != null && !isDeceased) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (extraBadgeColor ?? Colors.green).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (extraBadgeColor ?? Colors.green).withOpacity(0.2)),
                    ),
                    child: Text(
                      extraBadgeText,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: extraBadgeColor ?? Colors.green),
                    ),
                  ),
                ],
                if (isLivingTogether && !isDeceased) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                    ),
                    child: const Text(
                      'Tinggal Bersama 🏡',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                ],
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
    String? avatarUrl,
    String parentingStyle = 'Balanced',
  }) {
    return InkWell(
      onTap: isDeceased ? null : () {
        final String cleanRole = status.replaceAll('(Donor)', '').trim();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionMenuScreen(
              character: widget.character,
              targetName: label,
              targetRole: cleanRole,
            ),
          ),
        ).then((_) {
          widget.onRefresh();
          if (_dialogSetState != null) {
            _dialogSetState!(() {});
          }
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
                if (avatarUrl != null)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: color.withOpacity(0.15),
                    child: Image(
                      image: AvatarImageCache.getImageProvider(avatarUrl),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        );
                      },
                      width: 28,
                      height: 28,
                    ),
                  )
                else
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
                          color: isDeceased
                              ? Colors.grey.shade600
                              : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
                          decoration: isDeceased ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Umur: $ageText',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.black54,
                          )),
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
                  const SizedBox(width: 4),
                  // Badge Gaya Asuh
                  Builder(builder: (context) {
                    final Map<String, dynamic> styleInfo = {
                      'Strict':     {'emoji': '🗡️', 'color': Colors.red.shade700},
                      'Balanced':   {'emoji': '⚖️', 'color': Colors.blue.shade600},
                      'Loose':      {'emoji': '🕊️', 'color': Colors.green.shade600},
                      'Neglectful': {'emoji': '👻', 'color': Colors.grey.shade600},
                    };
                    final info = styleInfo[parentingStyle] ?? styleInfo['Balanced']!;
                    final Color badgeColor = info['color'] as Color;
                    final String emoji = info['emoji'] as String;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: badgeColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        '$emoji $parentingStyle',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor),
                      ),
                    );
                  }),
                  const SizedBox(width: 4),
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
