import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:bitlife/game/widgets/hubungan_menu/npc_family_view.dart';
import 'package:bitlife/game/premium_features/adult_features.dart';

class PageDonorSperma extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PageDonorSperma({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<PageDonorSperma> createState() => _PageDonorSpermaState();
}

class _PageDonorSpermaState extends State<PageDonorSperma> {
  @override
  void initState() {
    super.initState();
  }

  void _doDonor() {
    final r = Random();
    int kesuburan = widget.character.health;
    if (widget.character.age > 35) kesuburan = (kesuburan * 0.7).round();
    if (widget.character.age > 45) kesuburan = (kesuburan * 0.4).round();
    kesuburan = kesuburan.clamp(0, 100);

    setState(() {
      widget.character.money += 5000;
    });

    final bool berhasil = r.nextInt(100) < (kesuburan + 20).clamp(0, 100);
    String title;
    String content;

    if (berhasil) {
      final List<String> girls = (Character.globalFemaleFirstNames.isNotEmpty) ? Character.globalFemaleFirstNames : ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra'];
      final List<String> boys = (Character.globalMaleFirstNames.isNotEmpty) ? Character.globalMaleFirstNames : ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi'];
      final List<String> lastNamesList = (Character.globalLastNames.isNotEmpty) ? Character.globalLastNames : ['Pratama', 'Saputra', 'Wijaya', 'Kusuma'];
      
      final String ibuNama = '${girls[r.nextInt(girls.length)]} ${lastNamesList[r.nextInt(lastNamesList.length)]}';
      final String anakGender = r.nextBool() ? 'Laki-laki' : 'Perempuan';
      final String anakNamaDepan = anakGender == 'Laki-laki' ? boys[r.nextInt(boys.length)] : girls[r.nextInt(girls.length)];
      final String anakNama = '$anakNamaDepan ${lastNamesList[r.nextInt(lastNamesList.length)]}';

      widget.character.children.add({
        'name': anakNama,
        'gender': anakGender,
        'relationship': '50',
        'age': '0',
        'father': widget.character.name,
        'mother': ibuNama,
        'isDeceased': 'false',
      });

      widget.character.donorRecipients.add({
        'name': ibuNama,
        'age': (20 + r.nextInt(16)).toString(),
        'relationship': '50',
        'childName': anakNama,
      });

      title = 'Donor Sperma Berhasil! 🧬';
      content = 'Penerima: Ibu $ibuNama\nBayi lahir: $anakGender bernama $anakNama.\n\nAnda mendapatkan \$5.000 atas kontribusi ini!';
      widget.character.inbox.add('🧬 Donor Sperma Berhasil! Ibu $ibuNama melahirkan bayi $anakGender bernama $anakNama dari sperma Anda.');
    } else {
      title = 'Donor Sperma Tersimpan 🧪';
      content = 'Sperma Anda berhasil disimpan di bank sperma, namun belum ada penerima yang cocok tahun ini. Anda tetap menerima \$5.000!';
      widget.character.inbox.add('🧬 Donor Sperma: Sperma Anda berhasil disimpan di bank sperma.');
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Donor Sperma 🧬', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: isDark ? Colors.blue.shade900 : Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.biotech, size: 48, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                const SizedBox(height: 8),
                Text(
                  'Bantu Pasangan Lain Mendapatkan Anak',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.lightBlueAccent : Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Setiap kali mendonorkan sperma yang layak, Anda akan menerima imbalan \$5.000.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _doDonor,
                  icon: const Icon(Icons.favorite, size: 18),
                  label: const Text('MULAI DONOR SPERMA', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    'Riwayat Penerima & Hasil Donor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: widget.character.donorRecipients.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada riwayat penerima yang melahirkan dari sperma Anda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: widget.character.donorRecipients.length,
                          itemBuilder: (ctx, i) {
                            final item = widget.character.donorRecipients[i];
                            final int rAge = int.tryParse(item['age'] ?? '25') ?? 25;
                            final int rRel = int.tryParse(item['relationship'] ?? '50') ?? 50;

                            Map<String, String>? childData;
                            for (var c in widget.character.children) {
                              if (c['name'] == item['childName']) {
                                childData = c;
                                break;
                              }
                            }
                            final String cGender = childData?['gender'] ?? 'Laki-laki';
                            final String cAge = childData?['age'] ?? '0';

                            final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                              name: item['name'] ?? 'Penerima',
                              gender: 'Perempuan',
                              age: rAge,
                              happiness: rRel,
                              forcedSkinColor: item['skinColor'],
                            );

                            return Card(
                              elevation: 0,
                              color: isDark ? Colors.grey.shade800 : Colors.white,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                    child: Image(
                                      image: AvatarImageCache.getImageProvider(avatarUrl),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Penerima: Ibu ${item['name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  'Anak: ${item['childName']} ($cGender, Usia: $cAge thn)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: isDark ? Colors.white54 : Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipientInteractionPage(
                                        recipient: item,
                                        character: widget.character,
                                        onRefresh: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipientInteractionPage extends StatefulWidget {
  final Map<String, String> recipient;
  final Character character;
  final VoidCallback onRefresh;

  const RecipientInteractionPage({
    super.key,
    required this.recipient,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RecipientInteractionPage> createState() => _RecipientInteractionPageState();
}

class _RecipientInteractionPageState extends State<RecipientInteractionPage> {
  final Random _random = Random();
  late int relationship;
  late int age;
  late String name;
  late String gender;
  late String childName;

  @override
  void initState() {
    super.initState();
    name = widget.recipient['name'] ?? 'Penerima Donor';
    gender = 'Perempuan';
    age = int.tryParse(widget.recipient['age'] ?? '25') ?? 25;
    relationship = int.tryParse(widget.recipient['relationship'] ?? '50') ?? 50;
    childName = widget.recipient['childName'] ?? 'Anak Donor';
  }

  void _showOutcome(String title, String content) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(content),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) setState(() {});
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  void _updateRelationship(int change) {
    setState(() {
      relationship = (relationship + change).clamp(0, 100);
      widget.recipient['relationship'] = relationship.toString();
    });
    for (var r in widget.character.donorRecipients) {
      if (r['name'] == name) {
        r['relationship'] = relationship.toString();
        break;
      }
    }
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: relationship,
      forcedSkinColor: widget.recipient['skinColor'],
    );

    final bool isPartner = widget.character.isAnyPartnerNameMatching(name);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: isDark ? Colors.grey.shade800 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image(
                          image: AvatarImageCache.getImageProvider(avatarUrl),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (isPartner) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.pink.shade900 : Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isDark ? Colors.pink.shade700 : Colors.pink.shade200, width: 0.5),
                            ),
                            child: Text(
                              'Pacar ❤️',
                              style: TextStyle(
                                color: isDark ? Colors.pinkAccent : Colors.pink,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Penerima Donor Sperma • Gender: Perempuan • Umur: $age tahun • Hubungan: $relationship%',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Melahirkan anak Anda: $childName 👶',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.lightBlueAccent : Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Tingkat Hubungan: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: relationship / 100.0,
                              backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                relationship > 70 ? Colors.green : (relationship > 40 ? Colors.amber : Colors.red),
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$relationship%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: relationship > 70 ? Colors.green : (relationship > 40 ? Colors.amber : Colors.red),
                          ),
                        ),
                      ],
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
                color: isDark ? Colors.white70 : Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),


            if (isPartner) ...[
              _buildActionTile(
                icon: Icons.favorite,
                color: Colors.pink,
                title: 'Bercinta / Make Love',
                onTap: () {
                  final success = relationship >= 60;
                  if (success) {
                    widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
                    _showOutcome('Bercinta 💖', 'Kamu menghabiskan waktu bersama Ibu $name. Hubungan kalian berdua terasa semakin hangat.');
                  } else {
                    _updateRelationship(-5);
                    _showOutcome('Bercinta Ditolak 🚫', '$name menolak ajakanmu karena hubungan kalian saat ini terasa kurang dekat.');
                  }
                },
              ),
              if (AdultFeatures.canMasturbateTogether())
                _buildActionTile(
                  icon: Icons.flash_on,
                  color: Colors.purple,
                  title: 'Ajak Masturbasi Bersama',
                  onTap: () {
                    if (widget.character.age < 12) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Terlalu Muda 👶'),
                          content: const Text('Kamu harus berusia minimal 12 tahun untuk mengajak melakukan hal ini.'),
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

                    int successChance = 50;
                    if (widget.character.happiness > 60) {
                      successChance = 100;
                    }

                    final bool success = _random.nextInt(100) < successChance;
                    if (success) {
                      AjakanMasturbasiDialog.show(
                        context: context,
                        character: widget.character,
                        relationType: 'Pacar',
                        viewerName: name,
                        targetGender: 'Perempuan',
                        isUserInitiated: true,
                        onComplete: () {
                          setState(() {});
                          widget.onRefresh();
                        },
                      );
                    } else {
                      _updateRelationship(-10);
                      _showOutcome('Ajakan Ditolak 🚫', '$name menolak ajakan masturbasi bersamamu.');
                    }
                  },
                ),
              if (widget.character.age >= 18)
                _buildActionTile(
                  icon: Icons.diamond,
                  color: Colors.amber,
                  title: 'Lamar',
                  onTap: () {
                    bool accepted = relationship >= 60 ? (_random.nextInt(100) < 80) : (_random.nextInt(100) < 30);
                    if (accepted) {
                      setState(() {
                        if (widget.character.partner != null && widget.character.partner!['name'] == name) {
                          widget.character.partner!['relation'] = 'Tunangan';
                        } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == name) {
                          widget.character.secondPartner!['relation'] = 'Tunangan';
                        }
                      });
                      _updateRelationship(15);
                      widget.character.happiness = (widget.character.happiness + 30).clamp(0, 100);
                      _showOutcome('Lamaran Diterima! 💍', '$name menerima lamaran pernikahanmu dengan air mata bahagia! Status hubungan kalian kini adalah Tunangan.');
                    } else {
                      _updateRelationship(-10);
                      _showOutcome('Lamaran Ditolak 💔', '$name menolak lamaranmu karena merasa hubungan kalian belum cukup matang.');
                    }
                  },
                ),
              _buildActionTile(
                icon: Icons.heart_broken,
                color: Colors.red,
                title: 'Putuskan Pacar',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (confirmContext) => AlertDialog(
                      title: const Text('Putuskan Hubungan', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: Text('Apakah kamu yakin ingin memutuskan hubungan dengan $name?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(confirmContext),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(confirmContext);
                            setState(() {
                              if (widget.character.partner != null && widget.character.partner!['name'] == name) {
                                widget.character.partner = null;
                              } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == name) {
                                widget.character.secondPartner = null;
                              }
                            });
                            _updateRelationship(-40);
                            
                            DialogHelper.show(
                              context: context,
                              title: 'Putus Hubungan 💔',
                              content: Text('Kamu telah memutuskan hubungan dengan $name.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Mengerti'),
                                ),
                              ],
                            );
                          },
                          child: const Text('Ya, Putuskan', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              _buildActionTile(
                icon: Icons.favorite_border,
                color: Colors.redAccent,
                title: 'Ajak Pacaran',
                onTap: () {
                  bool accepted = relationship >= 65 && _random.nextInt(100) < 50;
                  if (accepted) {
                    final partnerMap = {
                      'name': name,
                      'gender': gender,
                      'relationship': relationship.toString(),
                      'age': age.toString(),
                      'isDeceased': 'false',
                      'relation': 'Pacar',
                    };
                    widget.character.addPartnerToFreeSlot(partnerMap);
                    _updateRelationship(20);
                    _showOutcome('Pacaran Sukses! ❤️', 'Luar biasa! Ibu $name menerima ajakan pacaranmu. 😍');
                  } else {
                    _updateRelationship(-10);
                    _showOutcome('Ajakan Ditolak 💔', '$name menolak ajakan pacaranmu secara halus.');
                  }
                },
              ),
            ],

            _buildActionTile(
              icon: Icons.chat_bubble_outline,
              color: Colors.blue,
              title: 'Percakapan',
              onTap: () {
                final change = 5 + _random.nextInt(6);
                _updateRelationship(change);
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                _showOutcome('Percakapan 💬', 'Kamu mengobrol mengenai perkembangan $childName. Hubungan meningkat!');
              },
            ),

            _buildActionTile(
              icon: Icons.access_time,
              color: Colors.blueAccent,
              title: 'Habiskan Waktu Bersama',
              onTap: () {
                final change = 8 + _random.nextInt(8);
                _updateRelationship(change);
                widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                _showOutcome('Habiskan Waktu Bersama 🕒', 'Kamu mengajak Ibu $name jalan-jalan santai di taman. Kalian bersenang-senang membahas tumbuh kembang anak.');
              },
            ),

            _buildActionTile(
              icon: Icons.movie_outlined,
              color: Colors.indigo,
              title: 'Ajak Nonton Bioskop',
              onTap: () {
                if (widget.character.money < 30) {
                  _showOutcome('Uang Tidak Cukup', 'Kamu tidak memiliki uang (\$30) untuk membeli tiket bioskop.');
                  return;
                }
                widget.character.money -= 30;
                final change = 12 + _random.nextInt(9);
                _updateRelationship(change);
                widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
                _showOutcome('Nonton Bioskop 🎬', 'Kamu membelikan tiket bioskop (\$30) untuk Ibu $name. Kalian menikmati film komedi romantis bersama.');
              },
            ),

            _buildActionTile(
              icon: Icons.thumb_up_alt_outlined,
              color: Colors.teal,
              title: 'Berikan Pujian',
              onTap: () {
                final change = 6 + _random.nextInt(6);
                _updateRelationship(change);
                _showOutcome('Pujian ⭐️', 'Kamu memuji Ibu $name sebagai ibu yang hebat dalam mengasuh anak.');
              },
            ),

            _buildActionTile(
              icon: Icons.card_giftcard,
              color: Colors.purple,
              title: 'Beri Hadiah (\$20)',
              onTap: () {
                if (widget.character.money < 20) {
                  _showOutcome('Uang Tidak Cukup', 'Kamu tidak memiliki cukup uang.');
                  return;
                }
                final change = 10 + _random.nextInt(11);
                widget.character.money -= 20;
                _updateRelationship(change);
                widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
                _showOutcome('Memberi Hadiah 🎁', 'Kamu memberikan hadiah untuk $name. Dia sangat senang!');
              },
            ),

            _buildActionTile(
              icon: Icons.face_retouching_natural,
              color: Colors.pink,
              title: 'Cium',
              onTap: () {
                if (relationship >= 60) {
                  final change = 10 + _random.nextInt(11);
                  _updateRelationship(change);
                  widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                  _showOutcome('Ciuman Diterima 💋', 'Kamu mencium pipi Ibu $name. Dia tersenyum merona dan menyambutnya dengan hangat.');
                } else {
                  final change = 8 + _random.nextInt(8);
                  _updateRelationship(-change);
                  _showOutcome('Ciuman Ditolak 🚫', 'Kamu mencoba mencium $name, tetapi dia menghindar karena hubungan kalian belum cukup dekat.');
                }
              },
            ),

            _buildActionTile(
              icon: Icons.favorite_border,
              color: Colors.pinkAccent,
              title: 'Menggoda',
              onTap: () {
                if (_random.nextInt(100) < 40) {
                  final change = 6 + _random.nextInt(6);
                  _updateRelationship(-change);
                  _showOutcome('Gagal Menggoda 💔', 'Kamu mencoba menggoda Ibu $name, tapi suasananya terasa agak canggung.');
                } else {
                  final change = 5 + _random.nextInt(11);
                  _updateRelationship(change);
                  widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                  _showOutcome('Menggoda Berhasil 💖', 'Kamu melontarkan rayuan manis. Dia tersenyum tersipu malu!');
                }
              },
            ),

            _buildActionTile(
              icon: Icons.monetization_on_outlined,
              color: Colors.green,
              title: 'Minta Uang',
              onTap: () {
                if (relationship < 50) {
                  _updateRelationship(-5);
                  _showOutcome('Minta Uang Ditolak ❌', '$name menolak memberi uang karena dia merasa hubungan kalian belum cukup akrab.');
                } else {
                  final amount = 100 + _random.nextInt(401);
                  widget.character.money += amount;
                  _updateRelationship(-8);
                  _showOutcome('Minta Uang Berhasil 💰', '$name memberikanmu uang jajan sebesar \$$amount untuk kebutuhan pribadimu.');
                }
              },
            ),

            _buildActionTile(
              icon: Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              title: 'Hina',
              onTap: () {
                final change = 10 + _random.nextInt(11);
                _updateRelationship(-change);
                widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                _showOutcome('Menghina 😡', 'Kamu menghina $name. Hubungan kalian memburuk secara signifikan.');
              },
            ),

            _buildActionTile(
              icon: Icons.gavel,
              color: Colors.deepOrange,
              title: 'Buat Keributan',
              onTap: () {
                final win = _random.nextBool();
                final relChange = 15 + _random.nextInt(16);
                if (win) {
                  _updateRelationship(-relChange);
                  widget.character.health = (widget.character.health - 5).clamp(0, 100);
                  _showOutcome('Keributan 🥊', 'Kamu berdebat keras dengan $name mengenai hak asuh anak dan kamu memenangkan perdebatan tersebut, meski hubungan kalian memburuk.');
                } else {
                  _updateRelationship(-relChange);
                  widget.character.health = (widget.character.health - 12).clamp(0, 100);
                  _showOutcome('Kalah Berdebat 🤕', 'Kamu berdebat dengan $name dan dia mendiamkanmu begitu saja. Kamu merasa kesal dan lelah.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}