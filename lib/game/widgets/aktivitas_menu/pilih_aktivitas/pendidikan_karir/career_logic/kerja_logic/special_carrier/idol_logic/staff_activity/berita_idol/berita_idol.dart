import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class BeritaIdolPage extends StatefulWidget {
  final Character character;

  const BeritaIdolPage({
    super.key,
    required this.character,
  });

  @override
  State<BeritaIdolPage> createState() => _BeritaIdolPageState();
}

class _BeritaIdolPageState extends State<BeritaIdolPage> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    '🎓 Kelulusan',
    '🌟 Promosi & Rekrutmen',
    '🎤 Pertunjukan',
    '💼 Manajemen',
    '📣 Media',
  ];

  Map<String, dynamic> _getNewsMetadata(String news, bool isDark) {
    if (news.contains('🎓') || news.contains('Lulus')) {
      return {
        'category': '🎓 Kelulusan',
        'icon': Icons.school,
        'iconColor': Colors.blue,
        'bgColor': isDark ? Colors.blue.shade900.withAlpha(76) : Colors.blue.shade50.withAlpha(128),
        'borderColor': isDark ? Colors.blue.shade700 : Colors.blue.shade200,
        'badgeColor': Colors.blue.shade700,
        'badgeBgColor': Colors.blue.shade50,
      };
    } else if (news.contains('🆕') || news.contains('Generasi Baru') || news.contains('Promosi') || news.contains('Trainee Baru')) {
      return {
        'category': '🌟 Promosi & Rekrutmen',
        'icon': Icons.stars,
        'iconColor': Colors.pink,
        'bgColor': isDark ? Colors.pink.shade900.withAlpha(76) : Colors.pink.shade50.withAlpha(128),
        'borderColor': isDark ? Colors.pink.shade700 : Colors.pink.shade200,
        'badgeColor': Colors.pink.shade700,
        'badgeBgColor': Colors.pink.shade50,
      };
    } else if (news.contains('🎤') || news.contains('🎪') || news.contains('Teater') || news.contains('Konser') || news.contains('Latihan')) {
      return {
        'category': '🎤 Pertunjukan',
        'icon': Icons.mic_external_on,
        'iconColor': Colors.purple,
        'bgColor': isDark ? Colors.purple.shade900.withAlpha(76) : Colors.purple.shade50.withAlpha(128),
        'borderColor': isDark ? Colors.purple.shade700 : Colors.purple.shade200,
        'badgeColor': Colors.purple.shade700,
        'badgeBgColor': Colors.purple.shade50,
      };
    } else if (news.contains('📊') || news.contains('💼') || news.contains('💰') || news.contains('Evaluasi') || news.contains('Keuangan')) {
      return {
        'category': '💼 Manajemen',
        'icon': Icons.business_center,
        'iconColor': Colors.teal,
        'bgColor': isDark ? Colors.teal.shade900.withAlpha(76) : Colors.teal.shade50.withAlpha(128),
        'borderColor': isDark ? Colors.teal.shade700 : Colors.teal.shade200,
        'badgeColor': Colors.teal.shade800,
        'badgeBgColor': Colors.teal.shade50,
      };
    } else if (news.contains('📱') || news.contains('📣') || news.contains('Media') || news.contains('Promosi')) {
      return {
        'category': '📣 Media',
        'icon': Icons.campaign,
        'iconColor': Colors.orange,
        'bgColor': isDark ? Colors.orange.shade900.withAlpha(76) : Colors.orange.shade50.withAlpha(128),
        'borderColor': isDark ? Colors.orange.shade700 : Colors.orange.shade200,
        'badgeColor': Colors.orange.shade800,
        'badgeBgColor': Colors.orange.shade50,
      };
    }

    return {
      'category': '📢 Pengumuman',
      'icon': Icons.article,
      'iconColor': Colors.grey.shade700,
      'bgColor': isDark ? Colors.grey.shade800 : Colors.grey.shade50,
      'borderColor': isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      'badgeColor': Colors.grey.shade800,
      'badgeBgColor': Colors.grey.shade100,
    };
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final allNews = widget.character.idolNews.reversed.toList();

    final filteredNews = allNews.where((news) {
      if (_selectedCategory == 'Semua') return true;
      final meta = _getNewsMetadata(news, isDark);
      return meta['category'] == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Grup Idol 📰'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.pink.shade700,
                    backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
          ),

          // News List
          Expanded(
            child: filteredNews.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.newspaper,
                            size: 48,
                            color: isDark ? Colors.white38 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _selectedCategory == 'Semua'
                                ? 'Belum ada berita grup idol saat ini.\nLakukan aktivitas agensi atau tunggu perkembangan generasi baru!'
                                : 'Belum ada berita untuk kategori "$_selectedCategory".',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNews.length,
                    itemBuilder: (context, index) {
                      final String news = filteredNews[index];
                      final meta = _getNewsMetadata(news, isDark);

                      final IconData iconData = meta['icon'] as IconData;
                      final Color iconColor = meta['iconColor'] as Color;
                      final Color bgColor = meta['bgColor'] as Color;
                      final Color borderColor = meta['borderColor'] as Color;
                      final Color badgeColor = meta['badgeColor'] as Color;
                      final Color badgeBgColor = meta['badgeBgColor'] as Color;
                      final String categoryName = meta['category'] as String;

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: borderColor, width: 1),
                        ),
                        color: bgColor,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: iconColor.withAlpha(35),
                                radius: 20,
                                child: Icon(iconData, color: iconColor, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: badgeBgColor,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: badgeColor.withAlpha(80), width: 0.5),
                                          ),
                                          child: Text(
                                            categoryName,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: badgeColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      news,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white : Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
