import 'package:flutter/material.dart';

class PilihPendidikanAgamaModal extends StatelessWidget {
  final Function(String selectedReligion) onSelectReligion;

  const PilihPendidikanAgamaModal({
    super.key,
    required this.onSelectReligion,
  });

  static const List<Map<String, dynamic>> _religions = [
    {'title': 'Pendidikan Agama Islam', 'icon': Icons.mosque, 'code': 'Pendidikan Agama Islam'},
    {'title': 'Pendidikan Agama Kristen', 'icon': Icons.church, 'code': 'Pendidikan Agama Kristen'},
    {'title': 'Pendidikan Agama Katolik', 'icon': Icons.account_balance, 'code': 'Pendidikan Agama Katolik'},
    {'title': 'Pendidikan Agama Hindu', 'icon': Icons.auto_awesome, 'code': 'Pendidikan Agama Hindu'},
    {'title': 'Pendidikan Agama Buddha', 'icon': Icons.self_improvement, 'code': 'Pendidikan Agama Buddha'},
    {'title': 'Pendidikan Agama Khonghucu', 'icon': Icons.temple_buddhist, 'code': 'Pendidikan Agama Khonghucu'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mosque, color: Colors.teal, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Pendidikan Agama 🕌',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pilih program studi studi keagamaan:',
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
                itemCount: _religions.length,
                separatorBuilder: (c, i) => const SizedBox(height: 6),
                itemBuilder: (c, i) {
                  final item = _religions[i];
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
                        color: Colors.teal.shade700,
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
                        onSelectReligion(item['title'] as String);
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
