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
  @override
  Widget build(BuildContext context) {
    final staffList = widget.character.idolStaff;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staf & Manajemen 👥'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: staffList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada staf atau manajemen tersedia.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final staff = staffList[index];
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
                        Text('$role • Umur: $age tahun • Hubungan: $rel%'),
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
              },
            ),
    );
  }
}
