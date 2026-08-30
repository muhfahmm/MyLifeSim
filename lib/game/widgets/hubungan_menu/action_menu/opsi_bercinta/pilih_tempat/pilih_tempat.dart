// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class LocationOption {
  final String name;
  final String description;
  final IconData icon;

  const LocationOption({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class TempatBercintaHelper {
  static const List<LocationOption> mainLocations = [
    LocationOption(
      name: 'Di Rumah',
      description: 'Melakukan hubungan intim di area rumah tinggal.',
      icon: Icons.home,
    ),
    LocationOption(
      name: 'Di Mobil',
      description: 'Menyelinap ke dalam mobil pribadi agar tidak ketahuan.',
      icon: Icons.directions_car,
    ),
    LocationOption(
      name: 'Di Hotel',
      description: 'Menyewa kamar hotel agar mendapatkan kenyamanan ekstra.',
      icon: Icons.hotel,
    ),
  ];

  static const List<LocationOption> roomLocations = [
    LocationOption(
      name: 'Kamar Tidur',
      description: 'Di atas kasur yang empuk dan nyaman.',
      icon: Icons.bed,
    ),
    LocationOption(
      name: 'Kamar Mandi',
      description: 'Sensasi segar berendam di bathtub / di bawah shower.',
      icon: Icons.bathtub,
    ),
    LocationOption(
      name: 'Ruang Tamu',
      description: 'Melakukan secara diam-diam di sofa ruang tamu.',
      icon: Icons.chair,
    ),
    LocationOption(
      name: 'Dapur',
      description: 'Di dekat meja makan saat suasana sedang sepi.',
      icon: Icons.kitchen,
    ),
  ];

  // Menampilkan dialog pemilihan lokasi bercinta secara bertingkat
  // Menyembunyikan opsi mobil jika usia user adalah 12 dan target (pasangan) kurang dari 18 tahun (belum bisa menyetir mobil)
  static Future<String?> showLocationChooser({
    required BuildContext context,
    required Character character,
    required String partnerName,
    required int userAge,
    required int targetAge,
  }) async {
    // Saring lokasi berdasarkan aturan: jika user berusia 12 tahun dan target kurang dari 18 tahun, sembunyikan Mobil.
    final bool hideCar = (userAge == 12 && targetAge < 18);
    final List<LocationOption> filteredLocations = mainLocations.where((loc) {
      if (loc.name == 'Di Mobil' && hideCar) {
        return false;
      }
      return true;
    }).toList();

    // Langkah 1: Pilih Lokasi Utama (Rumah, Mobil, Hotel)
    LocationOption? selectedMain = await showDialog<LocationOption>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pilih Tempat Bercinta dengan $partnerName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredLocations.map((loc) {
                return Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDark ? Colors.red.shade900 : Colors.red.shade50,
                      child: Icon(loc.icon, color: Colors.redAccent),
                    ),
                    title: Text(
                      loc.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      loc.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    onTap: () => Navigator.pop(dialogContext, loc),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, null),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );

    if (selectedMain == null) return null;

    // Langkah 2: Jika memilih "Di Rumah", tawarkan pilihan rumah siapa (Rumah Orang Tua, Rumah Pacar Utama, Rumah Pacar Rahasia)
    if (selectedMain.name == 'Di Rumah') {
      final String? selectedHouseOwner = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
          final String parentName = character.motherName != null ? 'Ibu (${character.motherName})' : 'Orang Tua';

          final List<Widget> partnerHouseCards = [];

          bool isSiblingLivingWithParents(String partnerName) {
            final String cleanPName = partnerName.toLowerCase();
            for (var sib in character.siblings) {
              final String sibName = (sib['name'] ?? '').toLowerCase();
              if (sibName.isNotEmpty && (cleanPName.contains(sibName) || sibName.contains(cleanPName))) {
                final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
                return sibAge < 18;
              }
            }
            return false;
          }

          if (character.partner != null) {
            final String name = character.partner!['name']!;
            if (!isSiblingLivingWithParents(name)) {
              partnerHouseCards.add(
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.pink),
                    title: Text('Rumah $name', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    subtitle: const Text('Rumah pacar utamamu.'),
                    onTap: () => Navigator.pop(dialogContext, 'Pacar Pertama'),
                  ),
                ),
              );
            }
          }

          if (character.secondPartner != null) {
            final String name = character.secondPartner!['name']!;
            if (!isSiblingLivingWithParents(name)) {
              final String subtitle = character.isHavingAffair ? 'Rumah pacar rahasiamu (selingkuhan).' : 'Rumah pacar keduamu.';
              partnerHouseCards.add(
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Icon(character.isHavingAffair ? Icons.heart_broken : Icons.favorite, color: character.isHavingAffair ? Colors.deepOrange : Colors.pink),
                    title: Text('Rumah $name', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    subtitle: Text(subtitle, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                    onTap: () => Navigator.pop(dialogContext, 'Pacar Kedua'),
                  ),
                ),
              );
            }
          }

          if (character.thirdPartner != null) {
            final String name = character.thirdPartner!['name']!;
            if (!isSiblingLivingWithParents(name)) {
              partnerHouseCards.add(
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.pink),
                    title: Text('Rumah $name', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    subtitle: const Text('Rumah pacar ketigamu.'),
                    onTap: () => Navigator.pop(dialogContext, 'Pacar Ketiga'),
                  ),
                ),
              );
            }
          }

          if (character.fourthPartner != null) {
            final String name = character.fourthPartner!['name']!;
            if (!isSiblingLivingWithParents(name)) {
              partnerHouseCards.add(
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.pink),
                    title: Text('Rumah $name', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    subtitle: const Text('Rumah pacar keempatmu.'),
                    onTap: () => Navigator.pop(dialogContext, 'Pacar Keempat'),
                  ),
                ),
              );
            }
          }

          if (character.fifthPartner != null) {
            final String name = character.fifthPartner!['name']!;
            if (!isSiblingLivingWithParents(name)) {
              partnerHouseCards.add(
                Card(
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.pink),
                    title: Text('Rumah $name', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    subtitle: const Text('Rumah pacar kelimamu.'),
                    onTap: () => Navigator.pop(dialogContext, 'Pacar Kelima'),
                  ),
                ),
              );
            }
          }

          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Row(
              children: [
                const Icon(Icons.home, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Pilih Rumah Siapa?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (character.motherName != null || character.fatherName != null)
                    Card(
                      elevation: 0,
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.people, color: Colors.blue),
                        title: Text('Rumah $parentName', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                        subtitle: const Text('Rumah orang tuamu sendiri.'),
                        onTap: () => Navigator.pop(dialogContext, 'Orang Tua'),
                      ),
                    ),
                  ...partnerHouseCards,
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, null),
                child: Text(
                  'Kembali',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        },
      );

      if (selectedHouseOwner == null) {
        return showLocationChooser(
          context: context,
          character: character,
          partnerName: partnerName,
          userAge: userAge,
          targetAge: targetAge,
        );
      }

      LocationOption? selectedRoom = await showDialog<LocationOption>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Row(
              children: [
                Icon(Icons.meeting_room, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Pilih Ruangan di Rumah',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: roomLocations.map((room) {
                  return Card(
                    elevation: 0,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isDark ? Colors.red.shade900 : Colors.red.shade50,
                        child: Icon(room.icon, color: Colors.redAccent),
                      ),
                      title: Text(
                        room.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        room.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      onTap: () => Navigator.pop(dialogContext, room),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, null),
                child: Text(
                  'Kembali',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        },
      );

      if (selectedRoom == null) {
        return showLocationChooser(
          context: context,
          character: character,
          partnerName: partnerName,
          userAge: userAge,
          targetAge: targetAge,
        );
      }
      return 'Rumah (Pemilik: $selectedHouseOwner | Ruangan: ${selectedRoom.name})';
    }

    return selectedMain.name;
  }
}