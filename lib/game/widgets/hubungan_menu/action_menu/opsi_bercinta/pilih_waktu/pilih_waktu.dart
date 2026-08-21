// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart
import 'package:flutter/material.dart';

class TimeOption {
  final String name;
  final String description;
  final IconData icon;

  const TimeOption({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class PilihWaktuHelper {
  static const List<TimeOption> timeOptions = [
    TimeOption(
      name: 'Pagi',
      description: 'Melakukan di pagi hari yang cerah dan segar.',
      icon: Icons.light_mode,
    ),
    TimeOption(
      name: 'Siang',
      description: 'Mencuri waktu di siang hari yang terik.',
      icon: Icons.wb_sunny,
    ),
    TimeOption(
      name: 'Sore',
      description: 'Suasana syahdu di sore hari menjelang senja.',
      icon: Icons.wb_twilight,
    ),
    TimeOption(
      name: 'Malam',
      description: 'Kegelapan malam menyimpan rahasia yang dalam.',
      icon: Icons.nightlight_round,
    ),
  ];

  static Future<String?> showTimeChooser(BuildContext context, String locationText) async {
    TimeOption? selectedTime = await showDialog<TimeOption>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.indigoAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pilih Waktu Bercinta',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lokasi terpilih: $locationText',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              ...timeOptions.map((time) {
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
                      backgroundColor: Colors.indigo.shade50,
                      child: Icon(time.icon, color: Colors.indigoAccent),
                    ),
                    title: Text(time.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(time.description, style: const TextStyle(fontSize: 12)),
                    onTap: () => Navigator.pop(context, time),
                  ),
                );
              }),
            ],
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

    return selectedTime?.name;
  }
}
