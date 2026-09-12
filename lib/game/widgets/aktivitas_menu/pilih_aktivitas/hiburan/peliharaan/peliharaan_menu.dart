// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/peliharaan_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'kucing/kucing_page.dart';
import 'anjing/anjing_page.dart';
import 'burung/burung_page.dart';
import 'ikan/ikan_page.dart';
import 'kelinci/kelinci_page.dart';
import 'reptil/reptil_page.dart';

class PeliharaanMenuHelper {
  static void showPeliharaanMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 8) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 8 tahun untuk mengadopsi peliharaan.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PeliharaanPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class PeliharaanPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PeliharaanPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<PeliharaanPage> createState() => _PeliharaanPageState();
}

class _PeliharaanPageState extends State<PeliharaanPage> {
  final List<Map<String, dynamic>> hewan = [
    {'id': 'kucing', 'name': 'Kucing 🐱', 'desc': 'Teman berbulu yang menggemaskan'},
    {'id': 'anjing', 'name': 'Anjing 🐶', 'desc': 'Teman setia yang aktif'},
    {'id': 'burung', 'name': 'Burung 🦜', 'desc': 'Hewan cantik yang bisa bernyanyi'},
    {'id': 'ikan', 'name': 'Ikan 🐠', 'desc': 'Hewan tenang dan menenangkan'},
    {'id': 'kelinci', 'name': 'Kelinci 🐇', 'desc': 'Hewan lucu dan jinak'},
    {'id': 'reptil', 'name': 'Reptil 🦎', 'desc': 'Hewan unik untuk kolektor'},
  ];

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  void _openCategoryPage(BuildContext context, String categoryId) {
    Widget targetPage;
    switch (categoryId) {
      case 'kucing':
        targetPage = KucingPage(character: widget.character, onComplete: widget.onComplete);
        break;
      case 'anjing':
        targetPage = AnjingPage(character: widget.character, onComplete: widget.onComplete);
        break;
      case 'burung':
        targetPage = BurungPage(character: widget.character, onComplete: widget.onComplete);
        break;
      case 'ikan':
        targetPage = IkanPage(character: widget.character, onComplete: widget.onComplete);
        break;
      case 'kelinci':
        targetPage = KelinciPage(character: widget.character, onComplete: widget.onComplete);
        break;
      case 'reptil':
        targetPage = ReptilPage(character: widget.character, onComplete: widget.onComplete);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color containerBg = isDark ? Colors.grey.shade900 : Colors.white;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopsi Peliharaan 🐾', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: containerBg,
        foregroundColor: textColor,
        elevation: 0.5,
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: containerBg,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: ${_fmt(widget.character.money)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: hewan.length,
                itemBuilder: (_, i) {
                  final h = hewan[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        h['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          h['desc'],
                          style: TextStyle(
                            color: subtextColor,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                      onTap: () => _openCategoryPage(context, h['id'] as String),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

