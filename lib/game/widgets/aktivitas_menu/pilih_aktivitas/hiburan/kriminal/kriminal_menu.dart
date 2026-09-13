// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/kriminal/kriminal_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class KriminalMenuHelper {
  static void showKriminalMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      DialogHelper.show(
        context: context,
        title: 'Akses Dibatasi',
        content: const Text('Kamu harus berusia minimal 18 tahun untuk melakukan tindakan kriminal.'),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KriminalPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class KriminalPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const KriminalPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<KriminalPage> createState() => _KriminalPageState();
}

class _KriminalPageState extends State<KriminalPage> {
  final List<Map<String, dynamic>> crimes = [
    {'name': 'Copet Dompet 👜', 'risk': 30, 'gain': 10000, 'jail': 1, 'desc': 'Mencuri dompet orang di keramaian'},
    {'name': 'Perjudian Ilegal 🎲', 'risk': 20, 'gain': 25000, 'jail': 1, 'desc': 'Berjudi di tempat terlarang'},
    {'name': 'Penipuan Online 💻', 'risk': 25, 'gain': 50000, 'jail': 2, 'desc': 'Menipu orang melalui internet'},
    {'name': 'Perampokan Toko 🏪', 'risk': 60, 'gain': 100000, 'jail': 5, 'desc': 'Merampok toko kecil'},
  ];

  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  void _executeCrime(BuildContext context, Map<String, dynamic> crime) {
    final r = Random();
    final bool tertangkap = r.nextInt(100) < (crime['risk'] as int);

    String msg;
    if (tertangkap) {
      final jailYears = crime['jail'] as int;
      final confiscatedAmount = widget.character.lastCrimeLoot;
      setState(() {
        widget.character.isImprisoned = true;
        widget.character.remainingJailYears = jailYears;
        if (confiscatedAmount > 0) {
          widget.character.money = (widget.character.money - confiscatedAmount).clamp(0, 999999999999);
        }
        widget.character.happiness = (widget.character.happiness - 40).clamp(0, 100);
        widget.character.health = (widget.character.health - 10).clamp(0, 100);
        
        final List<String> breakups = [];
        widget.character.handlePartnerBreakupOnArrest(breakups);
        
        // Reset last crime loot
        widget.character.lastCrimeLoot = 0;
      });
      msg = '🚔 TERTANGKAP! Kamu ditangkap polisi saat ${crime['name']} dan dihukum $jailYears tahun penjara! (-40% Kebahagiaan, -10% Kesehatan)';
      if (confiscatedAmount > 0) {
        msg += '\n👮 Polisi menyita uang hasil kriminal terakhirmu sebesar ${_fmt(confiscatedAmount)}!';
      }
    } else {
      setState(() {
        final gain = crime['gain'] as int;
        widget.character.money += gain;
        widget.character.lastCrimeLoot = gain;
        widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
      });
      msg = '😈 BERHASIL! Kamu berhasil melakukan ${crime['name']} dan mendapatkan ${_fmt(crime['gain'] as int)}! (+10% Kebahagiaan)';
    }

    widget.character.inbox.add(msg);
    DialogHelper.show(
      context: context,
      title: tertangkap ? 'Tertangkap!' : 'Berhasil!',
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onComplete();
            if (tertangkap) {
              Navigator.of(context).pop();
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('OK'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aksi Kriminal ⚠️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.red.shade900 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? Colors.red.shade700 : Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tindakan kriminal berisiko dipenjara! Pilih dengan bijak.',
                      style: TextStyle(
                        fontSize: 12, 
                        color: isDark ? Colors.redAccent : Colors.red, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: crimes.length,
                itemBuilder: (_, i) {
                  final crime = crimes[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        crime['name'], 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${crime['desc']}\nRisiko: ${crime['risk']}% | Penjara: ${crime['jail']} thn',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Text(
                        '+${_fmt(crime['gain'] as int)}',
                        style: TextStyle(
                          color: isDark ? Colors.greenAccent : Colors.green, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                        ),
                      ),
                      onTap: () => _executeCrime(context, crime),
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
