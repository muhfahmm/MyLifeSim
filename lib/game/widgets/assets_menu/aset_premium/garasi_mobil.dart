import 'package:flutter/material.dart';

class GarasiMobilItem extends StatelessWidget {
  final int age;

  const GarasiMobilItem({super.key, required this.age});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = age >= 18;
    final Color statusColor = isUnlocked ? Colors.green : Colors.grey;
    final IconData statusIcon = isUnlocked ? Icons.check_circle : Icons.lock;

    return InkWell(
      onTap: () {
        if (age < 18) {
          _showLockedDialog(context, 'Garasi Mobil', 18);
          return;
        }
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const _GarasiMobilPage()));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.directions_car, color: isUnlocked ? Colors.red : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Garasi Mobil',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isUnlocked ? Colors.red : Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            Icon(statusIcon, color: statusColor, size: 18),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, String feature, int requiredAge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey, size: 28),
            SizedBox(width: 8),
            Text('Fitur Terkunci', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fitur $feature akan terbuka saat karakter berusia $requiredAge tahun.', style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            Text('Usia saat ini: $age tahun', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Mengerti'))],
      ),
    );
  }
}

// --- HALAMAN GARASI MOBIL ---
class _GarasiMobilPage extends StatelessWidget {
  const _GarasiMobilPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garasi Mobil'), backgroundColor: Colors.red),
      body: const Center(child: Text('Selamat datang di Garasi Mobil!\n(Fitur dalam pengembangan)', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
    );
  }
}