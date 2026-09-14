// lib/game/widgets/kategori_usia/kurangi_umur_button.dart
import 'package:flutter/material.dart';

class KurangiUmurButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const KurangiUmurButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        minimumSize: const Size(0, 48),
        fixedSize: const Size.fromHeight(48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.purple.shade400, width: 1.5),
        ),
      ),
      child: const SizedBox(
        height: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 18, color: Colors.white),
            SizedBox(height: 1),
            Text(
              'Kurangi Umur',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
