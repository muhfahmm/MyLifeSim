// lib/game/widgets/aktivitas_menu/pilih_aktivitas/kesehatan/olahraga_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class OlahragaMenuHelper {
  static void showOlahragaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    final Random random = Random();

    if (character.age < 7) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Terlalu Muda'),
          content: const Text('Kamu belum cukup umur untuk berolahraga secara serius (minimal 7 tahun).'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final List<Map<String, dynamic>> olahraga = [
      {'name': 'Lari Pagi 🏃', 'health': 10, 'happiness': 5, 'intelligence': 0, 'desc': 'Berlari di pagi hari untuk kebugaran dasar.'},
      {'name': 'Gym / Angkat Beban 🏋️', 'health': 15, 'happiness': 5, 'intelligence': 0, 'desc': 'Latihan intensif di gym untuk membangun otot.'},
      {'name': 'Renang 🏊', 'health': 12, 'happiness': 8, 'intelligence': 0, 'desc': 'Olahraga seluruh tubuh yang menyenangkan.'},
      {'name': 'Yoga & Meditasi 🧘', 'health': 8, 'happiness': 12, 'intelligence': 3, 'desc': 'Menenangkan pikiran dan meregangkan tubuh.'},
      {'name': 'Sepeda 🚴', 'health': 10, 'happiness': 10, 'intelligence': 0, 'desc': 'Bersepeda santai atau menjelajah kota.'},
      {'name': 'Olahraga Tim ⚽', 'health': 10, 'happiness': 15, 'intelligence': 0, 'desc': 'Bergabung dengan tim sepak bola atau basket.'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.fitness_center, color: Colors.orange),
          SizedBox(width: 8),
          Text('Pilih Jenis Olahraga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: olahraga.length,
            itemBuilder: (_, i) {
              final o = olahraga[i];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(o['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(o['desc'], style: const TextStyle(fontSize: 11)),
                  trailing: Text('+${o['health']}❤️', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _executeOlahraga(context, character, o, random, onComplete);
                  },
                ),
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal'))],
      ),
    );
  }

  static void _executeOlahraga(
      BuildContext context, Character character, Map<String, dynamic> o, Random random, VoidCallback onComplete) {
    // Risiko cedera 5%
    final bool cedera = random.nextInt(100) < 5;
    String resultMsg;

    if (cedera) {
      character.health = (character.health - 10).clamp(0, 100);
      character.happiness = (character.happiness - 5).clamp(0, 100);
      resultMsg = '😣 Kamu mengalami cedera saat ${o['name']}! Kesehatanmu turun (-10% Kesehatan, -5% Kebahagiaan).';
    } else {
      character.health = (character.health + (o['health'] as int)).clamp(0, 100);
      character.happiness = (character.happiness + (o['happiness'] as int)).clamp(0, 100);
      if ((o['intelligence'] as int) > 0) {
        character.intelligence = (character.intelligence + (o['intelligence'] as int)).clamp(0, 100);
      }
      resultMsg = '💪 ${o['name']} selesai! Tubuhmu terasa lebih bugar (+${o['health']}% Kesehatan, +${o['happiness']}% Kebahagiaan).';
    }

    character.inbox.add(resultMsg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(cedera ? Icons.warning : Icons.check_circle, color: cedera ? Colors.orange : Colors.green),
          const SizedBox(width: 8),
          Text(cedera ? 'Cedera!' : 'Olahraga Selesai', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(resultMsg),
        actions: [
          TextButton(onPressed: () { Navigator.pop(ctx); onComplete(); }, child: const Text('OK')),
        ],
      ),
    );
  }
}
