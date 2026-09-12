import 'package:flutter/material.dart';

class SeasonStatsTinjuMMAModal {
  static void show(
    BuildContext context, {
    required String noticeText,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.sports, color: Colors.redAccent, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Statistik Musim Tinju / MMA 🥊',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Text(
                noticeText.replaceFirst(RegExp(r'🥊 Statistik Musim Usia \d+ \([^)]+\):\n'), ''),
                style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onDone();
              },
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
