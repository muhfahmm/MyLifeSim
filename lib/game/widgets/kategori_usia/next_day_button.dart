// lib/game/widgets/kategori_usia/next_day_button.dart
import 'package:flutter/material.dart';

class NextDayButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NextDayButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.today, size: 16),
      label: const Text(
        'Tambah Hari',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

