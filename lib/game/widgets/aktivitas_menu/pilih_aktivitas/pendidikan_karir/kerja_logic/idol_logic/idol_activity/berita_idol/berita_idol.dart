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
    final newsList = character.idolNews.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Grup Idol 📰'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Belum ada berita mengenai generasi baru atau kelulusan saat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
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
                Color bgColor = Colors.grey.shade50;
                Color borderColor = Colors.grey.shade200;

                if (news.contains('🎓') || news.contains('Lulus')) {
                  iconData = Icons.school;
                  iconColor = Colors.blue;
                  bgColor = Colors.blue.shade50.withAlpha(50);
                  borderColor = Colors.blue.shade100;
                } else if (news.contains('🆕') || news.contains('Generasi Baru') || news.contains('Promosi')) {
                  iconData = Icons.star;
                  iconColor = Colors.pink;
                  bgColor = Colors.pink.shade50.withAlpha(50);
                  borderColor = Colors.pink.shade100;
                } else if (news.contains('📢') || news.contains('Keluar')) {
                  iconData = Icons.campaign;
                  iconColor = Colors.orange;
                  bgColor = Colors.orange.shade50.withAlpha(50);
                  borderColor = Colors.orange.shade100;
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
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
