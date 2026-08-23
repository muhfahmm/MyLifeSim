import 'package:flutter/material.dart';

class KemewahanItem extends StatelessWidget {
  final int age;

  const KemewahanItem({super.key, required this.age});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = age >= 15;
    final Color statusColor = isUnlocked ? Colors.green : Colors.grey;
    final IconData statusIcon = isUnlocked ? Icons.check_circle : Icons.lock;

    return InkWell(
      onTap: () {
        if (age < 15) {
          _showLockedDialog(context, 'Kemewahan', 15);
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const _KemewahanPage()));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.purple.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUnlocked ? Colors.purple.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.diamond, color: isUnlocked ? Colors.purple : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Kemewahan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isUnlocked ? Colors.black87 : Colors.grey),
              ),
            ),
            Text(
              '\$0',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isUnlocked ? Colors.purple : Colors.grey),
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

// --- HALAMAN KEMEWAHAN ---
class _KemewahanPage extends StatelessWidget {
  const _KemewahanPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kemewahan'), backgroundColor: Colors.purple),
      body: const Center(child: Text('Koleksi barang mewah Anda.\n(Fitur dalam pengembangan)', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
    );
  }
}
