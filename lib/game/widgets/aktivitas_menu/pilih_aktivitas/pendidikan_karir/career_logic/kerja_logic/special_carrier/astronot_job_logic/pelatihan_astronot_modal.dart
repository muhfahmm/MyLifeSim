// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/pelatihan_astronot_modal.dart


import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PelatihanAstronotModal {
  static void show(
    BuildContext context, {
    required Character character,
    required VoidCallback onRefresh,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> trainingPrograms = [
      {
        'title': 'Simulasi Gravitasi Nol (Zero-G) 🛰️',
        'desc': 'Latihan adaptasi melayang dalam atmosfer mikro-gravitasi',
        'statBonus': '+Kesehatan & Stabilitas',
        'icon': Icons.blur_circular,
        'color': Colors.indigo,
        'action': () {
          character.health = (character.health + 4).clamp(0, 100);
          character.happiness = (character.happiness + 2).clamp(0, 100);
          return 'Tubuhmu berhasil menyesuaikan diri dengan simulasi Zero-G tanpa mual! (Kesehatan +4%)';
        }
      },
      {
        'title': 'Uji Mesin Sentrifugal G-Force Tinggi 🌀',
        'desc': 'Melatih ketahanan fisik dari tekanan g-force tinggi roket luncur',
        'statBonus': '+Ketahanan Fisik Ekstrem',
        'icon': Icons.speed,
        'color': Colors.deepPurple,
        'action': () {
          character.health = (character.health + 5).clamp(0, 100);
          character.willpower = (character.willpower + 3).clamp(0, 100);
          return 'Kamu mampu menahan g-force hingga 9G saat berputar di mesin sentrifugal! (Kesehatan +5%)';
        }
      },
      {
        'title': 'Simulasi Baju Antariksa di Dalam Air 🌊',
        'desc': 'Latihan spacewalk (EVA) di kolam selam raksasa laboratorium antariksa',
        'statBonus': '+Kecerdasan & Keterampilan EVA',
        'icon': Icons.pool,
        'color': Colors.teal,
        'action': () {
          character.intelligence = (character.intelligence + 3).clamp(0, 100);
          character.discipline = (character.discipline + 2).clamp(0, 100);
          return 'Kamu berhasil menyelesaikan perbaikan modul stasiun antariksa simulasi di bawah air! (Kecerdasan +3%)';
        }
      },
      {
        'title': 'Simulasi Kedaruratan & Pendaratan Darurat 🚨',
        'desc': 'Latihan bertahan hidup jika kapsul mendarat di hutan atau lautan lepas',
        'statBonus': '+Disiplin & Tekad Bertahan Hidup',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.orange,
        'action': () {
          character.discipline = (character.discipline + 4).clamp(0, 100);
          character.willpower = (character.willpower + 4).clamp(0, 100);
          return 'Timmu sukses menyalakan suar darurat dan bertahan hidup di medan ekstrem! (Tekad +4%)';
        }
      },
    ];

    DialogHelper.show(
      context: context,
      title: 'Pusat Pelatihan Kosmonot & Astronot 🏋️‍♂️🚀',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tingkatkan keahlian fisik dan mental astronotmu untuk mempersiapkan diri sebelum peluncuran misi:',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 12),
          ...trainingPrograms.map((program) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: program['color'] as Color,
                  radius: 18,
                  child: Icon(program['icon'] as IconData, color: Colors.white, size: 18),
                ),
                title: Text(
                  program['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: Text(
                  '${program['desc']}\nEfek: ${program['statBonus']}',
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.grey.shade700),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: program['color'] as Color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    final String msg = (program['action'] as String Function())();
                    onRefresh();

                    DialogHelper.show(
                      context: context,
                      title: 'Latihan Selesai! 💪',
                      content: Text(msg),
                    );
                  },
                  child: const Text('Latihan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
