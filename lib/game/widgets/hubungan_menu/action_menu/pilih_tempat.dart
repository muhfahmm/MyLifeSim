// lib/game/widgets/hubungan_menu/action_menu/pilih_tempat.dart
import 'package:flutter/material.dart';

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
  static Future<String?> showLocationChooser(BuildContext context, String partnerName) async {
    // Langkah 1: Pilih Lokasi Utama (Rumah, Mobil, Hotel)
    LocationOption? selectedMain = await showDialog<LocationOption>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.redAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pilih Tempat Bercinta dengan $partnerName',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mainLocations.length,
            itemBuilder: (context, index) {
              final loc = mainLocations[index];
              return Card(
                elevation: 0,
                color: Colors.grey.shade50,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade50,
                    child: Icon(loc.icon, color: Colors.redAccent),
                  ),
                  title: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(loc.description, style: const TextStyle(fontSize: 12)),
                  onTap: () => Navigator.pop(context, loc),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );

    if (selectedMain == null) return null;

    // Langkah 2: Jika memilih "Di Rumah", tawarkan pilihan ruangan detail
    if (selectedMain.name == 'Di Rumah') {
      LocationOption? selectedRoom = await showDialog<LocationOption>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.meeting_room, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text('Pilih Ruangan di Rumah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: roomLocations.length,
              itemBuilder: (context, index) {
                final room = roomLocations[index];
                return Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade50,
                      child: Icon(room.icon, color: Colors.redAccent),
                    ),
                    title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(room.description, style: const TextStyle(fontSize: 12)),
                    onTap: () => Navigator.pop(context, room),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );

      if (selectedRoom == null) {
        // Ulangi/kembali ke pemilihan utama jika ditekan kembali
        return showLocationChooser(context, partnerName);
      }
      return 'Rumah (${selectedRoom.name})';
    }

    return selectedMain.name;
  }
}
