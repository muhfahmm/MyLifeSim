// lib/game/widgets/hubungan_menu/sibling_family_view.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';

/// Screen untuk menampilkan silsilah keluarga dari perspektif anggota keluarga terpilih (Saudara, Paman, Bibi, Sepupu, Kakek, Nenek, dll).
class SiblingFamilyViewScreen extends StatefulWidget {
  final Character character;
  final String? siblingName; // nama/ID anggota keluarga target
  final String side;          // 'Ayah' atau 'Ibu'
  final VoidCallback onRefresh;

  const SiblingFamilyViewScreen({
    super.key,
    required this.character,
    this.siblingName,
    required this.side,
    required this.onRefresh,
  });

  @override
  State<SiblingFamilyViewScreen> createState() => _SiblingFamilyViewScreenState();
}

class _SiblingFamilyViewScreenState extends State<SiblingFamilyViewScreen> {
  void _addWithoutDuplicate(List<Map<String, String>> list, Map<String, String> item) {
    final String itemName = item['name'] ?? '';
    final String itemId = item['id'] ?? '';
    final bool exists = list.any((existing) {
      if (itemId.isNotEmpty && existing['id'] == itemId) return true;
      return existing['name'] == itemName;
    });
    if (!exists) {
      list.add(item);
    }
  }
  
  Widget _buildPersonCard({
    required String name,
    required String roleLabel,
    required String gender,
    required int age,
    required bool isDeceased,
    required bool isDivorced,
    required Color borderColor,
    bool isUser = false,
    String? badge,
    Map<String, String>? rawMemberData,
  }) {
    final bool isMale = gender.toLowerCase() == 'laki-laki';
    String avatarUrl;
    if (isUser) {
      avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(widget.character);
    } else {
      avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
        name: name,
        gender: gender,
        age: age,
        happiness: 70,
      );
    }

    final Color statusColor = isDeceased
        ? Colors.grey
        : isDivorced
            ? Colors.orange
            : borderColor;

    return Card(
      elevation: 2,
      color: isDeceased ? Colors.grey.shade100 : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor.withOpacity(0.4), width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isDeceased || isUser || rawMemberData == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActionMenuScreen(
                      character: widget.character,
                      targetName: name,
                      targetRole: roleLabel,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                  widget.onRefresh();
                });
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: borderColor.withOpacity(0.1),
                    child: ClipOval(
                      child: Image(
                        image: AvatarImageCache.getImageProvider(avatarUrl),
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          isMale ? Icons.person : Icons.person_outline,
                          color: borderColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  if (isDeceased)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                    ),
                  if (isUser)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.star, size: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isDeceased ? '$name (Almarhum)' : name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDeceased ? Colors.grey : Colors.black87,
                              decoration: isDeceased ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor.withOpacity(0.4)),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      roleLabel,
                      style: TextStyle(fontSize: 12.5, color: statusColor, fontWeight: FontWeight.w500),
                    ),
                    if (age > 0) ...[
                      const SizedBox(height: 2),
                      Text('$age tahun', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: color.withOpacity(0.3))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Character c = widget.character;
    final String searchName = widget.siblingName ?? '';
    final String cleanSearch = searchName.toLowerCase();
    
    // Ekstrak nama asli dari format "Ayah (Nama)" atau "Ayah (Nama) (Cerai)" dsb
    String parsedName = searchName;
    final RegExp parenReg = RegExp(r'\(([^)]+)\)');
    final matches = parenReg.allMatches(searchName);
    if (matches.isNotEmpty) {
      parsedName = matches.first.group(1) ?? searchName;
    }
    final String cleanParsedName = parsedName.trim().toLowerCase();

    bool isFather = (cleanSearch.contains('ayah') && !cleanSearch.contains('tiri') && !cleanSearch.contains('mertua')) ||
                     (c.fatherName != null && (cleanSearch.contains(c.fatherName!.toLowerCase()) || cleanParsedName.contains(c.fatherName!.toLowerCase())));
    bool isMother = (cleanSearch.contains('ibu') && !cleanSearch.contains('tiri') && !cleanSearch.contains('mertua')) ||
                     (c.motherName != null && (cleanSearch.contains(c.motherName!.toLowerCase()) || cleanParsedName.contains(c.motherName!.toLowerCase())));

    // 1. Cari target orang dari siblings atau extendedFamily atau parents
    Map<String, String>? targetMap;
    bool isSibling = false;
    bool isParent = false;
    bool isUser = false;

    if (searchName == c.name) {
      isUser = true;
    } else if (isFather) {
      isParent = true;
      targetMap = {
        'name': c.fatherName ?? 'Ayah',
        'relation': c.isFatherDivorced ? 'Ayah (Cerai)' : 'Ayah Kandung',
        'gender': 'Laki-laki',
        'age': (c.fatherAge ?? 40).toString(),
        'isDeceased': c.isFatherDeceased.toString(),
      };
    } else if (isMother) {
      isParent = true;
      targetMap = {
        'name': c.motherName ?? 'Ibu',
        'relation': c.isMotherDivorced ? 'Ibu (Cerai)' : 'Ibu Kandung',
        'gender': 'Perempuan',
        'age': (c.motherAge ?? 40).toString(),
        'isDeceased': c.isMotherDeceased.toString(),
      };
    } else {
      // Cari di siblings
      for (var sib in c.siblings) {
        final String sibLabel = '${sib['name']} (${sib['relation']})';
        if (sibLabel == searchName || sib['name'] == searchName) {
          targetMap = sib;
          isSibling = true;
          break;
        }
      }
      // Cari di extendedFamily jika belum ketemu
      if (targetMap == null) {
        for (var ext in c.extendedFamily) {
          if (ext['name'] == searchName || ext['name']?.replaceAll(RegExp(r'^\w+\s\('), '').replaceAll(')', '') == searchName) {
            targetMap = ext;
            break;
          }
        }
      }
    }

    // Jika target tidak ditemukan, fallback ke mode user silsilah keluarga intinya
    if (targetMap == null) {
      isUser = true;
    }

    final Map<String, String> tMap = targetMap ?? {};

    final String targetId = tMap['id'] ?? '';
    final String relation = tMap['relation'] ?? '';
    final String name = tMap['name'] ?? c.name;
    final String gender = tMap['gender'] ?? c.gender;
    final int age = int.tryParse(tMap['age'] ?? '0') ?? c.age;
    final bool isDeceased = tMap['isDeceased'] == 'true';

    // Rencana Relasi yang akan dicari berdasarkan tipe target
    List<Map<String, String>> parentsList = [];
    List<Map<String, String>> spouseList = [];
    List<Map<String, String>> siblingsList = [];
    List<Map<String, String>> childrenList = [];

    if (isUser) {
      // Jika user: Tampilkan ortu, pasangan, dan anak user
      if (c.fatherName != null) {
        _addWithoutDuplicate(parentsList, {
          'name': c.fatherName!,
          'relation': c.isFatherDivorced ? 'Ayah (Cerai)' : 'Ayah Kandung',
          'gender': 'Laki-laki',
          'age': (c.fatherAge ?? 0).toString(),
          'isDeceased': c.isFatherDeceased.toString(),
        });
      }
      if (c.motherName != null) {
        _addWithoutDuplicate(parentsList, {
          'name': c.motherName!,
          'relation': c.isMotherDivorced ? 'Ibu (Cerai)' : 'Ibu Kandung',
          'gender': 'Perempuan',
          'age': (c.motherAge ?? 0).toString(),
          'isDeceased': c.isMotherDeceased.toString(),
        });
      }
      if (c.stepFatherName != null) {
        _addWithoutDuplicate(parentsList, {
          'name': c.stepFatherName!,
          'relation': 'Ayah Tiri',
          'gender': 'Laki-laki',
          'age': (c.stepFatherAge ?? 0).toString(),
          'isDeceased': c.isStepFatherDeceased.toString(),
        });
      }
      if (c.stepMotherName != null) {
        _addWithoutDuplicate(parentsList, {
          'name': c.stepMotherName!,
          'relation': 'Ibu Tiri',
          'gender': 'Perempuan',
          'age': (c.stepMotherAge ?? 0).toString(),
          'isDeceased': c.isStepMotherDeceased.toString(),
        });
      }
      if (c.partner != null) {
        _addWithoutDuplicate(spouseList, c.partner!);
      }
      for (var sib in c.siblings) {
        _addWithoutDuplicate(siblingsList, sib);
      }
      for (var child in c.children) {
        _addWithoutDuplicate(childrenList, child);
      }
    } else if (isSibling) {
      // Jika saudara kandung: Tampilkan ortu kandung/tiri, pasangan dia, anak dia
      if (c.fatherName != null) {
        _addWithoutDuplicate(parentsList, {
          'name': c.fatherName!,
          'relation': c.isFatherDivorced ? 'Ayah (Cerai)' : 'Ayah Kandung',
          'gender': 'Laki-laki',
          'age': (c.fatherAge ?? 0).toString(),
          'isDeceased': c.isFatherDeceased.toString(),
        });
      }
      if (c.motherName != null) {
        _addWithoutDuplicate(parentsList, {
          'name': c.motherName!,
          'relation': c.isMotherDivorced ? 'Ibu (Cerai)' : 'Ibu Kandung',
          'gender': 'Perempuan',
          'age': (c.motherAge ?? 0).toString(),
          'isDeceased': c.isMotherDeceased.toString(),
        });
      }

      // Pasangan dari saudara
      if (tMap['spouseName'] != null) {
        _addWithoutDuplicate(spouseList, {
          'name': tMap['spouseName']!,
          'relation': 'Pasangan Saudara',
          'gender': tMap['spouseGender'] ?? 'Laki-laki',
          'age': tMap['spouseAge'] ?? '20',
          'isDeceased': 'false',
        });
      }

      // Saudara lainnya + User
      _addWithoutDuplicate(siblingsList, {
        'name': c.name,
        'relation': 'Kamu',
        'gender': c.gender,
        'age': c.age.toString(),
        'isDeceased': 'false',
      });
      for (var sib in c.siblings) {
        if (sib['name'] != name) {
          _addWithoutDuplicate(siblingsList, sib);
        }
      }

      // Anak dari saudara
      if (tMap['childNames'] != null) {
        final List<String> cNames = tMap['childNames']!.split(',');
        final List<String> cAges = tMap['childAges']!.split(',');
        final List<String> cGenders = tMap['childGenders']!.split(',');
        for (int i = 0; i < cNames.length; i++) {
          _addWithoutDuplicate(childrenList, {
            'name': cNames[i],
            'relation': 'Keponakan',
            'gender': cGenders[i],
            'age': cAges[i],
            'isDeceased': 'false',
          });
        }
      }
    } else if (isParent) {
      // Jika orang tua kandung (Ayah/Ibu)
      final bool isAyah = relation.toLowerCase().contains('ayah');
      final String side = isAyah ? 'Ayah' : 'Ibu';

      // 1. Orang tua dari Ayah/Ibu (yaitu Kakek & Nenek dari side tersebut)
      for (var ext in c.extendedFamily) {
        final String extRel = ext['relation'] ?? '';
        if ((extRel.contains('Kakek') || extRel.contains('Nenek')) && extRel.contains(side)) {
          _addWithoutDuplicate(parentsList, ext);
        }
      }

      // 2. Pasangan (Suami/Istri) dari Ayah/Ibu
      final bool isDivorced = c.isFatherDivorced || c.isMotherDivorced;
      if (isAyah && c.motherName != null) {
        _addWithoutDuplicate(spouseList, {
          'name': c.motherName!,
          'relation': isDivorced ? 'Mantan Istri' : 'Ibu Kandung',
          'gender': 'Perempuan',
          'age': (c.motherAge ?? 40).toString(),
          'isDeceased': c.isMotherDeceased.toString(),
        });
      } else if (!isAyah && c.fatherName != null) {
        _addWithoutDuplicate(spouseList, {
          'name': c.fatherName!,
          'relation': isDivorced ? 'Mantan Suami' : 'Ayah Kandung',
          'gender': 'Laki-laki',
          'age': (c.fatherAge ?? 40).toString(),
          'isDeceased': c.isFatherDeceased.toString(),
        });
      }

      // 3. Saudara dari Ayah/Ibu (yaitu Paman & Bibi dari side tersebut)
      for (var ext in c.extendedFamily) {
        final String extRel = ext['relation'] ?? '';
        if ((extRel.contains('Paman') || extRel.contains('Bibi')) && extRel.contains(side) && !extRel.contains('Pasangan')) {
          _addWithoutDuplicate(siblingsList, ext);
        }
      }

      // 4. Anak-anak dari Ayah/Ibu (yaitu User sendiri + Saudara Kandung User)
      _addWithoutDuplicate(childrenList, {
        'name': c.name,
        'relation': 'Kamu',
        'gender': c.gender,
        'age': c.age.toString(),
        'isDeceased': 'false',
      });
      for (var sib in c.siblings) {
        _addWithoutDuplicate(childrenList, sib);
      }
    } else {
      // Jika Extended Family (Kakek, Nenek, Paman, Bibi, Sepupu)
      final String parentIdsStr = tMap['parentIds'] ?? '';
      final String spouseIdStr = tMap['spouseId'] ?? '';
      final String childrenIdsStr = tMap['childrenIds'] ?? '';

      // 1. Cari Orang Tua (untuk Paman, Bibi, Sepupu)
      if (parentIdsStr.isNotEmpty) {
        final List<String> parentIds = parentIdsStr.split(',');
        for (var ext in c.extendedFamily) {
          if (parentIds.contains(ext['id'])) {
            _addWithoutDuplicate(parentsList, ext);
          }
        }
      }

      // 2. Cari Pasangan
      if (spouseIdStr.isNotEmpty) {
        for (var ext in c.extendedFamily) {
          if (ext['id'] == spouseIdStr) {
            _addWithoutDuplicate(spouseList, ext);
          }
        }
      }

      // 3. Cari Saudara
      if (parentIdsStr.isNotEmpty) {
        final List<String> parentIds = parentIdsStr.split(',');
        for (var ext in c.extendedFamily) {
          if (ext['id'] != targetId && ext['parentIds'] != null) {
            final List<String> sibParentIds = ext['parentIds']!.split(',');
            if (sibParentIds.any((pId) => parentIds.contains(pId))) {
              _addWithoutDuplicate(siblingsList, ext);
            }
          }
        }
        
        // Cari jika Ayah Kandung atau Ibu Kandung adalah saudara dari Paman/Bibi
        if (relation.contains('Paman') || relation.contains('Bibi')) {
          final bool isAyahSide = relation.contains('Ayah');
          if (isAyahSide && c.fatherName != null) {
            _addWithoutDuplicate(siblingsList, {
              'name': c.fatherName!,
              'relation': 'Ayah Kandung',
              'gender': 'Laki-laki',
              'age': (c.fatherAge ?? 0).toString(),
              'isDeceased': c.isFatherDeceased.toString(),
            });
          } else if (!isAyahSide && c.motherName != null) {
            _addWithoutDuplicate(siblingsList, {
              'name': c.motherName!,
              'relation': 'Ibu Kandung',
              'gender': 'Perempuan',
              'age': (c.motherAge ?? 0).toString(),
              'isDeceased': c.isMotherDeceased.toString(),
            });
          }
        }
      }

      // 4. Cari Anak
      if (childrenIdsStr.isNotEmpty) {
        final List<String> childrenIds = childrenIdsStr.split(',');
        for (var ext in c.extendedFamily) {
          if (childrenIds.contains(ext['id'])) {
            _addWithoutDuplicate(childrenList, ext);
          }
        }
      } else {
        for (var ext in c.extendedFamily) {
          final String sibParentIdsStr = ext['parentIds'] ?? '';
          if (sibParentIdsStr.isNotEmpty) {
            final List<String> sibParentIds = sibParentIdsStr.split(',');
            if (sibParentIds.contains(targetId)) {
              _addWithoutDuplicate(childrenList, ext);
            }
          }
        }
      }

      // Kakek & Nenek: Anaknya adalah orang tua kandung + Paman/Bibi
      if (relation.contains('Kakek') || relation.contains('Nenek')) {
        for (var ext in c.extendedFamily) {
          final String parentIdsStr = ext['parentIds'] ?? '';
          if (parentIdsStr.isNotEmpty) {
            final List<String> pIds = parentIdsStr.split(',');
            if (pIds.contains(targetId)) {
              _addWithoutDuplicate(childrenList, ext);
            }
          }
        }
        final bool isAyahSide = relation.contains('Ayah');
        if (isAyahSide && c.fatherName != null) {
          _addWithoutDuplicate(childrenList, {
            'name': c.fatherName!,
            'relation': 'Ayah Kandung',
            'gender': 'Laki-laki',
            'age': (c.fatherAge ?? 0).toString(),
            'isDeceased': c.isFatherDeceased.toString(),
          });
        } else if (!isAyahSide && c.motherName != null) {
          _addWithoutDuplicate(childrenList, {
            'name': c.motherName!,
            'relation': 'Ibu Kandung',
            'gender': 'Perempuan',
            'age': (c.motherAge ?? 0).toString(),
            'isDeceased': c.isMotherDeceased.toString(),
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.family_restroom, color: Color(0xFF6C63FF)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Keluarga $name',
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF6C63FF), size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDeceased ? '$name (Almarhum)' : name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDeceased ? Colors.grey : Colors.black87,
                            decoration: isDeceased ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$relation | $age tahun',
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // === ORANG TUA ===
            if (parentsList.isNotEmpty) ...[
              _buildSectionHeader('Orang Tua', Icons.supervisor_account, Colors.indigo),
              ...parentsList.map((p) => _buildPersonCard(
                name: p['name'] ?? 'Orang Tua',
                roleLabel: p['relation'] ?? 'Orang Tua',
                gender: p['gender'] ?? 'Laki-laki',
                age: int.tryParse(p['age']?.toString() ?? '0') ?? 0,
                isDeceased: p['isDeceased'] == 'true',
                isDivorced: p['isDivorced'] == 'true',
                borderColor: Colors.blue,
                rawMemberData: p,
              )),
            ],

            // === PASANGAN ===
            if (spouseList.isNotEmpty) ...[
              _buildSectionHeader(
                spouseList.first['relation'] == 'Mantan Istri'
                    ? 'Mantan Istri'
                    : (spouseList.first['relation'] == 'Mantan Suami'
                        ? 'Mantan Suami'
                        : 'Suami / Istri'),
                Icons.favorite,
                Colors.red,
              ),
              ...spouseList.map((sp) => _buildPersonCard(
                name: sp['name'] ?? 'Pasangan',
                roleLabel: sp['relation'] ?? 'Pasangan',
                gender: sp['gender'] ?? 'Perempuan',
                age: int.tryParse(sp['age']?.toString() ?? '0') ?? 0,
                isDeceased: sp['isDeceased'] == 'true',
                isDivorced: false,
                borderColor: Colors.red,
                rawMemberData: sp,
              )),
            ],

            // === SAUDARA ===
            if (siblingsList.isNotEmpty) ...[
              _buildSectionHeader('Saudara', Icons.people, Colors.teal),
              ...siblingsList.map((sib) => _buildPersonCard(
                name: sib['name'] ?? 'Saudara',
                roleLabel: sib['relation'] ?? 'Saudara',
                gender: sib['gender'] ?? 'Laki-laki',
                age: int.tryParse(sib['age']?.toString() ?? '0') ?? 0,
                isDeceased: sib['isDeceased'] == 'true',
                isDivorced: false,
                borderColor: Colors.teal,
                rawMemberData: sib,
              )),
            ],

            // === ANAK-ANAK ===
            if (childrenList.isNotEmpty) ...[
              _buildSectionHeader('Anak-anak', Icons.child_care, Colors.green),
              ...childrenList.map((child) => _buildPersonCard(
                name: child['name'] ?? 'Anak',
                roleLabel: child['relation'] ?? 'Anak',
                gender: child['gender'] ?? 'Laki-laki',
                age: int.tryParse(child['age']?.toString() ?? '0') ?? 0,
                isDeceased: child['isDeceased'] == 'true',
                isDivorced: false,
                borderColor: Colors.green,
                rawMemberData: child,
              )),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
