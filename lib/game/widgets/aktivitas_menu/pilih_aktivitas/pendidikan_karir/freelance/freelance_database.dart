// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/freelance/freelance_database.dart
import 'package:flutter/material.dart';

class FreelanceDatabase {
  static final List<Map<String, dynamic>> availableGigs = [
    {
      'title': 'Fotografer Freelance',
      'payout': 1200,
      'minIntel': 40,
      'desc': 'Mengambil dan mengedit foto profesional untuk klien',
      'icon': Icons.photo_camera,
      'color': Colors.purple,
    },
    {
      'title': 'Videografer Freelance',
      'payout': 1500,
      'minIntel': 45,
      'desc': 'Membuat dan menyunting konten video promosi',
      'icon': Icons.videocam,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Content Creator',
      'payout': 1800,
      'minIntel': 50,
      'desc': 'Membuat dan mempublikasikan konten digital di media sosial',
      'icon': Icons.video_library,
      'color': Colors.red,
    },
    {
      'title': 'Musisi Jalanan',
      'payout': 600,
      'minIntel': 20,
      'desc': 'Bermain alat musik dan bernyanyi di tempat umum',
      'icon': Icons.music_note,
      'color': Colors.orange,
    },
    {
      'title': 'Pelukis Mandiri',
      'payout': 700,
      'minIntel': 25,
      'desc': 'Melukis karya seni berdasarkan komisi pesanan',
      'icon': Icons.brush,
      'color': Colors.cyan,
    },
    {
      'title': 'Penerjemah Lepas',
      'payout': 2500,
      'minIntel': 90,
      'desc': 'Menerjemahkan dokumen, artikel, dan materi asing',
      'icon': Icons.translate,
      'color': Colors.green,
    },
    {
      'title': 'Penulis Lepas (Ghostwriter)',
      'payout': 2000,
      'minIntel': 60,
      'desc': 'Menulis naskah, artikel web, atau cerita pesanan klien',
      'icon': Icons.edit,
      'color': Colors.amber,
    },
    {
      'title': 'Desainer Grafis Freelance',
      'payout': 2500,
      'minIntel': 55,
      'desc': 'Membuat desain logo, spanduk, dan aset visual digital',
      'icon': Icons.design_services,
      'color': Colors.pink,
    },
    {
      'title': 'Desainer Mode Freelance',
      'payout': 2800,
      'minIntel': 55,
      'desc': 'Merancang sketsa busana dan gaun custom',
      'icon': Icons.style,
      'color': Colors.purple,
    },
    {
      'title': 'Seniman Komisi Visual',
      'payout': 2000,
      'minIntel': 50,
      'desc': 'Menerima pesanan karya seni kustom dan patung',
      'icon': Icons.palette,
      'color': Colors.cyan,
    },
  ];
}
