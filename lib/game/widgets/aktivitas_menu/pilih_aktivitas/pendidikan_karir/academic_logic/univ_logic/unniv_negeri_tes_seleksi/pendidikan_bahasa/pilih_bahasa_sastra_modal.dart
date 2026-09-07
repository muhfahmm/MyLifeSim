import 'package:flutter/material.dart';

class PilihBahasaSastraModal extends StatefulWidget {
  final Function(String selectedMajor) onSelectLanguage;

  const PilihBahasaSastraModal({
    super.key,
    required this.onSelectLanguage,
  });

  @override
  State<PilihBahasaSastraModal> createState() => _PilihBahasaSastraModalState();
}

class _PilihBahasaSastraModalState extends State<PilihBahasaSastraModal> {
  String _selectedCategory = 'Sastra'; // 'Sastra' atau 'Bahasa'

  final List<Map<String, dynamic>> _sastraList = [
    {'title': 'Sastra Indonesia', 'icon': Icons.language, 'code': 'Sastra Indonesia'},
    {'title': 'Sastra Inggris', 'icon': Icons.menu_book, 'code': 'Sastra Inggris'},
    {'title': 'Sastra Jepang', 'icon': Icons.translate, 'code': 'Sastra Jepang'},
    {'title': 'Sastra Mandarin / China', 'icon': Icons.g_translate, 'code': 'Sastra Mandarin'},
    {'title': 'Sastra Arab', 'icon': Icons.auto_stories, 'code': 'Sastra Arab'},
    {'title': 'Sastra Korea', 'icon': Icons.subtitles, 'code': 'Sastra Korea'},
    {'title': 'Sastra Jerman', 'icon': Icons.book, 'code': 'Sastra Jerman'},
    {'title': 'Sastra Prancis', 'icon': Icons.menu_book, 'code': 'Sastra Prancis'},
    {'title': 'Sastra Rusia', 'icon': Icons.translate, 'code': 'Sastra Rusia'},
  ];

  final List<Map<String, dynamic>> _bahasaList = [
    {'title': 'Bahasa & Budaya Indonesia', 'icon': Icons.flag, 'code': 'Bahasa Indonesia'},
    {'title': 'Bahasa Inggris Terapan', 'icon': Icons.record_voice_over, 'code': 'Bahasa Inggris'},
    {'title': 'Bahasa & Kebudayaan Jepang', 'icon': Icons.school, 'code': 'Bahasa Jepang'},
    {'title': 'Bahasa Mandarin', 'icon': Icons.translate, 'code': 'Bahasa Mandarin'},
    {'title': 'Bahasa Arab & Studi Timur Tengah', 'icon': Icons.auto_stories, 'code': 'Bahasa Arab'},
    {'title': 'Bahasa & Kebudayaan Korea', 'icon': Icons.psychology, 'code': 'Bahasa Korea'},
    {'title': 'Bahasa Jerman', 'icon': Icons.menu_book, 'code': 'Bahasa Jerman'},
    {'title': 'Bahasa Prancis', 'icon': Icons.book, 'code': 'Bahasa Prancis'},
    {'title': 'Linguistik Terapan & Penerjemahan', 'icon': Icons.g_translate, 'code': 'Linguistik Terapan'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, dynamic>> currentList =
        _selectedCategory == 'Sastra' ? _sastraList : _bahasaList;

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
            // Header Dialog
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.book, color: Colors.indigo, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Spesialisasi 📚',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pilih jurusan sastra atau bahasa pilihanmu:',
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

            // Tab Selector Sastra vs Bahasa
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = 'Sastra'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedCategory == 'Sastra'
                              ? Colors.indigo
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Sastra',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedCategory == 'Sastra'
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = 'Bahasa'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedCategory == 'Bahasa'
                              ? Colors.indigo
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Bahasa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedCategory == 'Bahasa'
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // List Options
            Expanded(
              child: ListView.separated(
                itemCount: currentList.length,
                separatorBuilder: (c, i) => const SizedBox(height: 6),
                itemBuilder: (c, i) {
                  final item = currentList[i];
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
                        color: Colors.indigo,
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
                        widget.onSelectLanguage(item['title'] as String);
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
