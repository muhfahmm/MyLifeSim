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
      builder: (dialogContext) {
        final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: Row(
            children: [
              Icon(Icons.access_time, color: isDark ? Colors.indigoAccent : Colors.indigoAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pilih Waktu Bercinta',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi terpilih: $locationText',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                ...timeOptions.map((time) {
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
                        backgroundColor: isDark ? Colors.indigo.shade900 : Colors.indigo.shade50,
                        child: Icon(time.icon, color: isDark ? Colors.indigoAccent : Colors.indigoAccent),
                      ),
                      title: Text(
                        time.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        time.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      onTap: () => Navigator.pop(dialogContext, time),
                    ),
                  );
                }),
              ],
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

    return selectedTime?.name;
  }
}