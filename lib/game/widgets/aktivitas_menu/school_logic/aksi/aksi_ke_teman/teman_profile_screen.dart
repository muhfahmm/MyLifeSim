// lib/game/widgets/aktivitas_menu/school_logic/aksi/aksi_ke_teman/teman_profile_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class TemanProfileScreen extends StatefulWidget {
  final Character character;
  final String temanName;
  final String temanGender;
  final int temanAge;
  final int initialRelationship;
  final VoidCallback onRefresh;

  const TemanProfileScreen({
    super.key,
    required this.character,
    required this.temanName,
    required this.temanGender,
    required this.temanAge,
    required this.initialRelationship,
    required this.onRefresh,
  });

  @override
  State<TemanProfileScreen> createState() => _TemanProfileScreenState();
}

class _TemanProfileScreenState extends State<TemanProfileScreen> {
  late int currentRelationship;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    currentRelationship = widget.initialRelationship;
  }

  void _updateRelationship(int change) {
    setState(() {
      currentRelationship = (currentRelationship + change).clamp(0, 100);
      // Update di character juga
      for (var classmate in widget.character.classmates) {
        if (classmate['name'] == widget.temanName) {
          classmate['relationship'] = currentRelationship.toString();
          break;
        }
      }
    });
  }

  void _executeAction(String actionType) {
    int change = 0;
    String resultMsg = '';

    switch (actionType) {
      case 'berteman':
        change = random.nextInt(5) + 3;
        _updateRelationship(change);
        resultMsg = 'Kamu mengajak ${widget.temanName} bermain bersama. Hubungan meningkat +$change!';
        break;
      case 'hadiah':
        change = random.nextInt(6) + 5;
        _updateRelationship(change);
        resultMsg = 'Kamu memberikan hadiah berupa pensil lucu kepada ${widget.temanName}. Dia sangat senang! Hubungan meningkat +$change!';
        break;
      case 'singgung':
        change = random.nextInt(4) + 2;
        _updateRelationship(-change);
        resultMsg = 'Kamu menggoda ${widget.temanName} tentang penampilan fisiknya. Dia terlihat sedikit tersinggung. Hubungan menurun -$change!';
        break;
      case 'cium':
        if (currentRelationship < 50) {
          change = -5;
          resultMsg = '${widget.temanName} terlihat terkejut dan menjauh dari ciuman mu. Hubungan menurun -5!';
        } else if (currentRelationship >= 50 && currentRelationship < 75) {
          change = 10;
          resultMsg = '${widget.temanName} terlihat agak malu tapi menerima ciuman mu di pipi. Hubungan meningkat +10!';
        } else {
          change = 15;
          resultMsg = '${widget.temanName} dengan senang hati menerima ciuman mu. Hubungan meningkat +15!';
        }
        _updateRelationship(change);
        break;

      // ★ AGE 9-11 ROMANCE ACTIONS
      case 'ajak_pacaran':
        _handleAjakPacaran();
        return;

      case 'bercinta':
        _handleBercinta();
        return;

      case 'putuskan_pacaran':
        _handlePutuskanPacaran();
        return;
    }

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Aksi Selesai',
      content: Text(resultMsg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    );
  }

  // ★ AGE 9-11: Ajak Pacaran (School Romance Proposal)
  void _handleAjakPacaran() {
    // Check opposite gender
    final bool isOppositeGender = 
      (widget.character.gender.toLowerCase().contains('laki') && widget.temanGender.toLowerCase().contains('perempuan')) ||
      (widget.character.gender.toLowerCase().contains('perempuan') && widget.temanGender.toLowerCase().contains('laki'));

    if (!isOppositeGender) {
      DialogHelper.show(
        context: context,
        title: 'Ajakan Ditolak',
        content: Text('${widget.temanName} tidak tertarik karena kalian sesama jenis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
      return;
    }

    // Acceptance logic based on relationship
    bool accepted = false;
    if (currentRelationship >= 40) {
      accepted = random.nextInt(100) < 70;  // 70% chance
    } else if (currentRelationship >= 25) {
      accepted = random.nextInt(100) < 40;  // 40% chance
    } else {
      accepted = random.nextInt(100) < 15;  // 15% chance
    }

    if (accepted) {
      int relationshipGain = random.nextInt(8) + 10;
      _updateRelationship(relationshipGain);
      widget.onRefresh();

      // ★ ADD TO CHARACTER PARTNERS
      final String roleLabel = widget.temanGender.toLowerCase().contains('perempuan') ? 'Pacar' : 'Pacar';
      
      final newPartner = {
        'name': widget.temanName,
        'gender': widget.temanGender,
        'age': widget.temanAge.toString(),
        'relationship': currentRelationship.toString(),
        'relation': roleLabel,  // 'Pacar' for elementary school romance
      };

      // Add to character's partner if not already set
      if (widget.character.partner == null) {
        widget.character.partner = newPartner;
      } else if (widget.character.secondPartner == null) {
        // If already has a partner, set as second partner
        widget.character.secondPartner = newPartner;
        widget.character.isHavingAffair = true;
      }

      DialogHelper.show(
        context: context,
        title: 'Ajak Pacaran Diterima! 💕',
        content: Text(
          '${widget.temanName} dengan malu-malu menerima ajakanmu untuk menjadi pacar! Sekarang kalian adalah pasangan di sekolah. Hubungan meningkat +$relationshipGain! ☺️',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to see updated relationship screen
              widget.onRefresh();
            },
            child: const Text('Mengerti'),
          ),
        ],
      );
    } else {
      int relationshipLoss = random.nextInt(3) + 1;
      _updateRelationship(-relationshipLoss);
      widget.onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Ajak Pacaran Ditolak 💔',
        content: Text(
          '${widget.temanName} terlihat canggung dan menolak ajakanmu. Mungkin hubungan kalian belum cukup dekat. Hubungan menurun -$relationshipLoss.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
    }
  }

  void _handlePutuskanPacaran() {
    DialogHelper.show(
      context: context,
      title: 'Putuskan Hubungan',
      content: Text('Apakah kamu yakin ingin memutuskan hubungan pacaran dengan ${widget.temanName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close confirm dialog
            
            // Remove from partner or secondPartner
            Map<String, String>? brokePartner;
            if (widget.character.partner != null && widget.character.partner!['name'] == widget.temanName) {
              brokePartner = widget.character.partner;
              widget.character.partner = null;
            } else if (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == widget.temanName) {
              brokePartner = widget.character.secondPartner;
              widget.character.secondPartner = null;
              widget.character.isHavingAffair = false;
            }
            
            // Add to exPartners (mantan pacar) - PERBAIKAN DI SINI!
            if (brokePartner != null) {
              // Ambil data dengan aman menggunakan variabel lokal
              final String exName = brokePartner['name'] ?? widget.temanName;
              final String exGender = brokePartner['gender'] ?? widget.temanGender;
              final String exAge = brokePartner['age'] ?? widget.temanAge.toString();

              widget.character.exPartners.add({
                'name': exName,
                'gender': exGender,
                'age': exAge,
                'relationship': '20', // break up drops relationship
                'relation': 'Mantan Pacar',
                'isDeceased': 'false',
                // --- DATA PENYEBAB PUTUS (PENTING UNTUK LOGIKA AJAK BALIKAN) ---
                'breakInitiator': widget.character.gender,
                'breakReason': 'putus biasa',
              });
            }
            
            _updateRelationship(-40); // penalty relationship
            widget.onRefresh();
            
            DialogHelper.show(
              context: context,
              title: 'Putus Hubungan 💔',
              content: Text('Kamu telah memutuskan hubungan dengan ${widget.temanName}. Hubungan kalian sekarang berakhir.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); // go back to classmate list
                  },
                  child: const Text('Mengerti'),
                ),
              ],
            );
          },
          child: const Text('Ya, Putuskan', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  // --- FUNGSI KESUBURAN DINAMIS (SAMA SEPERTI DI bercinta.dart) ---
  double _getFertilityRate(int age, String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan') {
      if (age < 8 || age > 45) return 0.0;
      if (age >= 8 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.65;
      if (age >= 40 && age <= 45) return 0.30;
    } else { // laki-laki
      if (age < 9 || age > 65) return 0.0;
      if (age >= 9 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.75;
      if (age >= 40 && age <= 49) return 0.55;
      if (age >= 50 && age <= 65) return 0.35;
    }
    return 0.0;
  }

  // ★ AGE 9-11: Bercinta / Make Love (Innocent School Intimacy & Modal Place Selection)
  void _handleBercinta() {
    if (currentRelationship < 60) {
      // Rejection
      int relationshipLoss = random.nextInt(3) + 1;
      _updateRelationship(-relationshipLoss);
      widget.onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Ajakan Ditolak 😞',
        content: Text(
          '${widget.temanName} belum siap untuk moment romantis. "Kita masih terlalu muda untuk itu!" kata ${widget.temanName} sambil menjauh. Hubungan menurun -$relationshipLoss.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      );
    } else {
      _startBercintaFlow();
    }
  }

  void _startBercintaFlow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tempat Bercinta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('Di Rumah'),
              subtitle: const Text('Melakukan di lingkungan rumah.'),
              onTap: () {
                Navigator.pop(context);
                _showRumahOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.orange),
              title: const Text('Di Sekolah'),
              subtitle: const Text('Melakukan di lingkungan sekolah.'),
              onTap: () {
                Navigator.pop(context);
                _showSekolahOptions();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRumahOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tempat di Rumah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.meeting_room, color: Colors.blueGrey),
              title: const Text('Dirumahku'),
              onTap: () {
                Navigator.pop(context);
                _showPengamanConfirmation('Dirumahku');
              },
            ),
            ListTile(
              leading: const Icon(Icons.house, color: Colors.teal),
              title: const Text('Di Rumah Pasangan'),
              onTap: () {
                Navigator.pop(context);
                _showPengamanConfirmation('Di Rumah Pasangan');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSekolahOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tempat di Sekolah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.wc, color: Colors.brown),
              title: const Text('Kamar Mandi'),
              onTap: () {
                Navigator.pop(context);
                _showPengamanConfirmation('Kamar Mandi');
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.indigo),
              title: const Text('Perpustakaan'),
              onTap: () {
                Navigator.pop(context);
                _showPengamanConfirmation('Perpustakaan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.warehouse, color: Colors.deepOrange),
              title: const Text('Gudang'),
              onTap: () {
                Navigator.pop(context);
                _showPengamanConfirmation('Gudang');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPengamanConfirmation(String tempat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pengaman'),
        content: const Text('Apakah kamu ingin menggunakan pengaman (kondom)?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _finishBercinta(tempat, true);
            },
            child: const Text('Ya, Gunakan Pengaman'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _finishBercinta(tempat, false);
            },
            child: const Text('Tidak, Tanpa Pengaman', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _finishBercinta(String tempat, bool pakaiPengaman) {
    int relationshipGain = random.nextInt(8) + 12;
    _updateRelationship(relationshipGain);
    widget.onRefresh();

    String description = '';
    if (tempat == 'Dirumahku') {
      description = 'Kalian berdua menyelinap masuk ke kamarmu saat rumah sedang sepi dan menikmati momen intim yang penuh debar jantung.';
    } else if (tempat == 'Di Rumah Pasangan') {
      description = 'Kamu pergi ke rumah ${widget.temanName} ketika orang tuanya tidak ada di rumah. Momen berdua di kamarnya terasa sangat intim.';
    } else if (tempat == 'Kamar Mandi') {
      description = 'Saat jam istirahat sekolah, kalian diam-diam menyelinap ke kamar mandi sekolah yang sepi untuk menikmati momen intim yang mendebarkan.';
    } else if (tempat == 'Perpustakaan') {
      description = 'Di antara rak-rak buku perpustakaan yang sepi, kalian bersembunyi dari pandangan pustakawan dan menikmati momen romantis bersama.';
    } else if (tempat == 'Gudang') {
      description = 'Di dalam gudang sekolah yang berdebu namun tersembunyi, kalian mengunci pintu dari dalam dan menikmati momen romantis bersama.';
    }

    String pengamanText = pakaiPengaman 
      ? '\n\nKamu menggunakan kondom sebagai pengaman. Seks yang aman dan bertanggung jawab!' 
      : '\n\nKamu memutuskan untuk melakukannya tanpa pengaman. Momen terasa lebih intens tetapi ada risiko!';

    // --- LOGIKA KEHAMILAN DENGAN KESUBURAN DINAMIS ---
    String pregnancyAlert = '';
    final bool isOppositeGender = 
      (widget.character.gender.toLowerCase().contains('laki') && widget.temanGender.toLowerCase().contains('perempuan')) ||
      (widget.character.gender.toLowerCase().contains('perempuan') && widget.temanGender.toLowerCase().contains('laki'));

    if (isOppositeGender) {
      // Cek apakah pasangan/karakter sedang dalam kondisi hamil
      final bool currentlyPregnant = widget.character.gender.toLowerCase().contains('perempuan')
          ? widget.character.isPregnant
          : widget.character.partnerIsPregnant;

      if (currentlyPregnant) {
        // SKENARIO: SUDAH HAMIL
        pregnancyAlert = '\n\n🤰 ${widget.temanName} sudah dalam masa kehamilan. Kamu tetap menikmati momen intim, tetapi tidak ada kemungkinan hamil baru karena beliau sudah mengandung.';
      } else {
        // Tentukan usia yang akan dicek kesuburannya (pihak yang bisa hamil)
        int fertileAge;
        String fertileGender;
        if (widget.character.gender.toLowerCase().contains('perempuan')) {
          fertileAge = widget.character.age;
          fertileGender = widget.character.gender;
        } else {
          fertileAge = widget.temanAge;
          fertileGender = widget.temanGender;
        }

        // Ambil tingkat kesuburan dari fungsi dinamis
        double baseFertility = _getFertilityRate(fertileAge, fertileGender);

        // Jika di luar masa subur, tidak ada kemungkinan hamil
        if (baseFertility <= 0) {
          pregnancyAlert = '\n\n⛔ Usia ${fertileAge} tahun berada di luar masa subur (${fertileGender == 'perempuan' ? '8-45 tahun' : '9-65 tahun'}). Tidak ada kemungkinan hamil.';
        } else {
          // Kalkulasi akhir: jika pakai pengaman, risiko jadi 5% dari nilai dasar. Jika tidak, riskonya adalah nilai dasar.
          double finalChance = pakaiPengaman ? (baseFertility * 0.05) : baseFertility;
          
          if (random.nextDouble() < finalChance) {
            bool hamilTerjadi = true;
            if (widget.character.gender.toLowerCase().contains('perempuan')) {
              widget.character.isPregnant = true;
              widget.character.pregnantByPartnerName = widget.temanName;
              widget.character.pregnantByPartnerRole = 'Pacar';
            } else {
              widget.character.partnerIsPregnant = true;
              widget.character.pregnantByPartnerName = widget.temanName;
              widget.character.pregnantByPartnerRole = 'Pacar';
            }
            pregnancyAlert = widget.character.gender.toLowerCase().contains('perempuan')
              ? '\n\n⚠️ Beberapa minggu kemudian, kamu menyadari bahwa kamu TELAH HAMIL! 🍼'
              : '\n\n⚠️ Beberapa minggu kemudian, ${widget.temanName} menghubungimu dan mengatakan bahwa DIA HAMIL! 🍼';
          } else {
            pregnancyAlert = '\n\n🧪 Kali ini tidak terjadi kehamilan. (Tingkat kesuburan saat ini: ${(baseFertility * 100).toInt()}%)';
          }
        }
      }
    }
    // -----------------------------------------------------

    DialogHelper.show(
      context: context,
      title: 'Momen Intim! 💕',
      content: Text('$description$pengamanText$pregnancyAlert\n\nHubungan meningkat +$relationshipGain!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: widget.temanName,
      gender: widget.temanGender,
      age: widget.temanAge,
      happiness: currentRelationship,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.temanName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Avatar dan Info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue.shade100,
                    child: Image.network(
                      avatarUrl,
                      width: 96,
                      height: 96,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(widget.temanGender == 'Laki-laki' ? Icons.male : Icons.female,
                              size: 48, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.temanName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Teman Sekelas | Umur: ${widget.temanAge} tahun',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  
                  // --- BAGIAN STATUS KEHAMILAN ---
                  if ((widget.character.gender.toLowerCase().contains('perempuan') && widget.character.isPregnant) ||
                      (!widget.character.gender.toLowerCase().contains('perempuan') && widget.character.partnerIsPregnant)) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.pink.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.pregnant_woman, color: Colors.pink, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            widget.character.gender.toLowerCase().contains('perempuan')
                              ? 'Status: Hamil 🍼'
                              : 'Status: Pasangan Hamil 🍼',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // ---------------------------------------------

                  const SizedBox(height: 12),
                  // Relationship Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tingkat Kepuasan:', style: TextStyle(fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: currentRelationship / 100,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  currentRelationship > 65
                                      ? Colors.green
                                      : currentRelationship > 35
                                          ? Colors.amber
                                          : Colors.red,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$currentRelationship%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: currentRelationship > 65
                              ? Colors.green
                              : currentRelationship > 35
                                  ? Colors.amber
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Pilih Aksi Interaksi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PILIH AKSI INTERAKSI',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: '😊',
                    title: 'Berteman',
                    onTap: () => _executeAction('berteman'),
                  ),
                  _buildActionCard(
                    icon: '🎁',
                    title: 'Berikan Hadiah',
                    onTap: () => _executeAction('hadiah'),
                  ),
                  _buildActionCard(
                    icon: '😏',
                    title: 'Singgung Dia',
                    onTap: () => _executeAction('singgung'),
                  ),
                  _buildActionCard(
                    icon: '💋',
                    title: 'Cium',
                    onTap: () => _executeAction('cium'),
                  ),

                  // ★ AGE 9-11 ROMANCE ACTIONS
                  Builder(
                    builder: (context) {
                      final bool isPartner = (widget.character.partner != null && widget.character.partner!['name'] == widget.temanName) ||
                                             (widget.character.secondPartner != null && widget.character.secondPartner!['name'] == widget.temanName);
                      
                      if ((widget.character.age >= 9 && widget.character.age <= 11) || isPartner) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                            const Text(
                              'AKSI ROMANTIS SEKOLAH',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            if (isPartner) ...[
                              _buildActionCard(
                                icon: '💔',
                                title: 'Putuskan Pacar',
                                onTap: () => _executeAction('putuskan_pacaran'),
                              ),
                              _buildActionCard(
                                icon: '❤️',
                                title: 'Bercinta / Make Love',
                                onTap: () => _executeAction('bercinta'),
                              ),
                            ] else ...[
                              _buildActionCard(
                                icon: '💕',
                                title: 'Ajak Pacaran',
                                onTap: () => _executeAction('ajak_pacaran'),
                              ),
                              _buildActionCard(
                                icon: '❤️',
                                title: 'Bercinta / Make Love',
                                onTap: () => _executeAction('bercinta'),
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.grey.shade50,
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}