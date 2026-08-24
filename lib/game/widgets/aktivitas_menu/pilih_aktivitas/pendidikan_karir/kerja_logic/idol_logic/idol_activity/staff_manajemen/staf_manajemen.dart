import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import '../0_interactions_pages/idols_interaction_page.dart';

class StafManajemenPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const StafManajemenPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<StafManajemenPage> createState() => _StafManajemenPageState();
}

class _StafManajemenPageState extends State<StafManajemenPage> {
  Widget _buildRoleBadge(String role) {
    String text = 'Staf ⚙️';
    Color color = Colors.blueGrey;
    Color bgColor = Colors.blueGrey.shade50;
    Color borderColor = Colors.blueGrey.shade200;

    if (role.contains('General Manager') && !role.contains('Deputy')) {
      text = 'GM 👑';
      color = Colors.purple;
      bgColor = Colors.purple.shade50;
      borderColor = Colors.purple.shade200;
    } else if (role.contains('Deputy')) {
      text = 'Deputy GM 💼';
      color = Colors.indigo;
      bgColor = Colors.indigo.shade50;
      borderColor = Colors.indigo.shade200;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserStaffCard(BuildContext context) {
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(widget.character, happiness: widget.character.happiness);
    final String role = widget.character.jobName ?? 'Staf';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200, width: 1.5),
      ),
      color: Colors.orange.shade50.withAlpha(76),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: ClipOval(
            child: Image(
              image: AvatarImageCache.getImageProvider(avatarUrl),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(widget.character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Kamu (Anda) ⭐',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text('$role • Umur: ${widget.character.age} tahun'),
            const SizedBox(width: 8),
            _buildRoleBadge(role),
          ],
        ),
        trailing: const Icon(Icons.star, color: Colors.orangeAccent),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ini adalah dirimu! Kelola grup dengan bijaksana!')),
          );
        },
      ),
    );
  }

  Widget _buildNPCStaffCard(BuildContext context, Map<String, String> staff) {
    final String name = staff['name'] ?? 'Staf';
    final String role = staff['role'] ?? 'Operasional';
    final String gender = staff['gender'] ?? 'Perempuan';
    final int age = int.tryParse(staff['age'] ?? '30') ?? 30;
    final int rel = int.tryParse(staff['relationship'] ?? '50') ?? 50;
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: rel,
      forcedSkinColor: staff['skinColor'],
    );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade50,
          child: ClipOval(
            child: Image(
              image: AvatarImageCache.getImageProvider(avatarUrl),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (widget.character.isAnyPartnerNameMatching(name)) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.pink.shade200, width: 0.5),
                ),
                child: const Text(
                  'Pacar ❤️',
                  style: TextStyle(color: Colors.pink, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Umur: $age tahun • Hubungan: $rel%'),
                const SizedBox(width: 8),
                _buildRoleBadge(role),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rel / 100,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 4,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IdolsInteractionPage(
                character: widget.character,
                person: staff,
                category: 'Staff',
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffList = widget.character.idolStaff;
    final isUserStaff = widget.character.isIdolStaff;

    // Separate GM and Deputy GM from regular Operations staff
    final leaders = staffList.where((s) => s['role'] == 'General Manager' || s['role'] == 'Deputy General Manager').toList();
    final opsStaff = staffList.where((s) => s['role'] == 'Operations Staff').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staf & Manajemen 👥'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: staffList.isEmpty && !isUserStaff
          ? const Center(
              child: Text(
                'Tidak ada staf atau manajemen tersedia.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. LEADERS SECTION
                if (isUserStaff && (widget.character.jobName == 'General Manager Idol' || widget.character.jobName == 'Deputy General Manager Idol')) ...[
                  _buildUserStaffCard(context),
                ],
                for (var staff in leaders) ...[
                  _buildNPCStaffCard(context, staff),
                ],

                const SizedBox(height: 16),
                const Text(
                  'Daftar Staf Operasional',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 12),

                // 2. OPERATIONS STAFF SECTION
                if (isUserStaff && widget.character.jobName == 'Staf Operasional Idol') ...[
                  _buildUserStaffCard(context),
                ],
                for (var staff in opsStaff) ...[
                  _buildNPCStaffCard(context, staff),
                ],
              ],
            ),
    );
  }
}
