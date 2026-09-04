import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BeritaIdolPage extends StatelessWidget {
  final Character character;

  const BeritaIdolPage({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final newsList = character.idolNews.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Grup Idol 📰'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      body: newsList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Belum ada berita mengenai generasi baru atau kelulusan saat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final String news = newsList[index];
                
                // Determine icon and color based on news content
                IconData iconData = Icons.article_outlined;
                Color iconColor = Colors.grey;
                Color bgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade50;
                Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
                Color textColor = isDark ? Colors.white : Colors.black87;

                if (news.contains('🎓') || news.contains('Lulus')) {
                  iconData = Icons.school;
                  iconColor = Colors.blue;
                  bgColor = isDark ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50.withAlpha(50);
                  borderColor = isDark ? Colors.blue.shade700 : Colors.blue.shade100;
                } else if (news.contains('🆕') || news.contains('Generasi Baru') || news.contains('Promosi')) {
                  iconData = Icons.star;
                  iconColor = Colors.pink;
                  bgColor = isDark ? Colors.pink.shade900.withValues(alpha: 0.3) : Colors.pink.shade50.withAlpha(50);
                  borderColor = isDark ? Colors.pink.shade700 : Colors.pink.shade100;
                } else if (news.contains('📢') || news.contains('Keluar')) {
                  iconData = Icons.campaign;
                  iconColor = Colors.orange;
                  bgColor = isDark ? Colors.orange.shade900.withValues(alpha: 0.3) : Colors.orange.shade50.withAlpha(50);
                  borderColor = isDark ? Colors.orange.shade700 : Colors.orange.shade100;
                }

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 1),
                  ),
                  color: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: iconColor.withAlpha(30),
                          child: Icon(iconData, color: iconColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            news,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}