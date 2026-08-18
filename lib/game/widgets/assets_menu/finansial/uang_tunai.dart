import 'package:flutter/material.dart';

class UangTunaiItem extends StatelessWidget {
  final int money;
  final int age;

  const UangTunaiItem({super.key, required this.money, required this.age});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (age < 12) {
          _showLockedDialog(context, 'Uang Tunai', 12);
          return;
        }
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const _UangTunaiPage()));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.green, size: 28),
            const SizedBox(width: 16),
            const Expanded(
              child: Text('Uang Tunai', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            Text('\$$money', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(width: 8),
            const Icon(Icons.check_circle, color: Colors.green, size: 18),
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

// --- HALAMAN UANG TUNAI ---
class _UangTunaiPage extends StatelessWidget {
  const _UangTunaiPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uang Tunai'), backgroundColor: Colors.green),
      body: const Center(child: Text('Detail saldo uang tunai Anda.\n(Fitur dalam pengembangan)', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
    );
  }
}