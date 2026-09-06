import 'package:flutter/material.dart';

class PilihPendidikanModal extends StatelessWidget {
  final Function(String selectedMajor) onSelectSubject;

  const PilihPendidikanModal({
    super.key,
    required this.onSelectSubject,
  });

  static const List<Map<String, dynamic>> _subjects = [
    {'title': 'Pendidikan Guru Sekolah Dasar (PGSD)', 'icon': Icons.child_care, 'code': 'Pendidikan / PGSD'},
    {'title': 'Pendidikan Bahasa Indonesia', 'icon': Icons.language, 'code': 'Pendidikan Bahasa Indonesia'},
    {'title': 'Pendidikan Bahasa Inggris', 'icon': Icons.record_voice_over, 'code': 'Pendidikan Bahasa Inggris'},
    {'title': 'Pendidikan Matematika', 'icon': Icons.calculate, 'code': 'Pendidikan Matematika'},
    {'title': 'Pendidikan IPA (Sains)', 'icon': Icons.science, 'code': 'Pendidikan IPA'},
    {'title': 'Pendidikan IPS (Sosial)', 'icon': Icons.public, 'code': 'Pendidikan IPS'},
    {'title': 'Pendidikan Jasmani & Olahraga (PJOK)', 'icon': Icons.sports_soccer, 'code': 'Pendidikan Olahraga'},
    {'title': 'Pendidikan Seni & Musik', 'icon': Icons.brush, 'code': 'Pendidikan Seni'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          maxWidth: 450,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Program Pendidikan 🎓',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pilih spesialisasi pendidikan perguruan tinggi:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List Options
            Expanded(
              child: ListView.separated(
                itemCount: _subjects.length,
                separatorBuilder: (c, i) => const SizedBox(height: 6),
                itemBuilder: (c, i) {
                  final item = _subjects[i];
                  return Card(
                    elevation: 0,
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      leading: Icon(
                        item['icon'] as IconData,
                        color: Colors.blue.shade700,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        Navigator.pop(context);
                        onSelectSubject(item['title'] as String);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Button Batal
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
