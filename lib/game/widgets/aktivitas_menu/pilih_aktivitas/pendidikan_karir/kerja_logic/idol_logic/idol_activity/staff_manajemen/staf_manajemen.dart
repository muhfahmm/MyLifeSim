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
  // --- BADGE CONFIGS: role → (text, color) ---
  static const Map<String, Map<String, dynamic>> _badgeConfigs = {
    'General Manager':             {'text': 'GM 👑',              'color': 0xFF7B1FA2},
    'Deputy General Manager':      {'text': 'Deputy GM 💼',       'color': 0xFF303F9F},
    'Manajer Divisi Promosi':      {'text': 'Manajer 📣',         'color': 0xFF1565C0},
    'Manajer Divisi Operasional':  {'text': 'Manajer ⚙️',        'color': 0xFF1565C0},
    'Manajer Divisi Keuangan':     {'text': 'Manajer 💰',        'color': 0xFF1565C0},
    'Staf Administrasi':           {'text': 'Admin 📑',           'color': 0xFF00796B},
    'Staf HRD':                    {'text': 'HRD 🧑‍💼',            'color': 0xFF00796B},
    'Staf Administrasi Kontrak':   {'text': 'Kontrak 📝',         'color': 0xFF00796B},
    'Pelatih Tari (Koreografer)':  {'text': 'Koreografer 💃',     'color': 0xFFE91E63},
    'Pelatih Vokal':               {'text': 'Pelatih Vokal 🎤',   'color': 0xFF009688},
    'Pelatih Akting/MC':           {'text': 'Pelatih MC 🎭',      'color': 0xFFFF5722},
    'Sound Engineer':              {'text': 'Sound Eng. 🎛️',      'color': 0xFF0097A7},
    'Lighting Engineer':           {'text': 'Lighting 💡',        'color': 0xFFF9A825},
    'Stage Manager':               {'text': 'Stage Mgr 🎬',       'color': 0xFF6A1B9A},
    'Staf Backstage':              {'text': 'Backstage 🚪',       'color': 0xFF546E7A},
    'Staf Properti Panggung':      {'text': 'Properti 📦',        'color': 0xFF6D4C41},
    'Fotografer Resmi':            {'text': 'Foto 📷',            'color': 0xFF2E7D32},
    'Videografer Resmi':           {'text': 'Video 🎥',           'color': 0xFF1B5E20},
    'Editor Video':                {'text': 'Editor 💻',          'color': 0xFF424242},
    'Desainer Grafis':             {'text': 'Desainer 🎨',        'color': 0xFF6A1B9A},
    'Pengelola Sosial Media':      {'text': 'Sosmed 📱',          'color': 0xFF1565C0},
    'Staf Merchandise':            {'text': 'Merch 🛍️',           'color': 0xFFE65100},
    'Staf Penjualan Toko':         {'text': 'Store 🏪',           'color': 0xFFE65100},
    'Koordinator Merchandise':     {'text': 'Koordinator 🎁',     'color': 0xFFBF360C},
    'Makeup Artist (MUA)':         {'text': 'MUA 💄',             'color': 0xFFC2185B},
    'Staf Kostum':                 {'text': 'Kostum 👗',          'color': 0xFFAD1457},
    'Petugas Keamanan':            {'text': 'Satpam 👮',          'color': 0xFFC62828},
    'Staf Tiket':                  {'text': 'Tiket 🎟️',           'color': 0xFF283593},
    'Penjaga Pintu Masuk':         {'text': 'Pintu Masuk 🚪',     'color': 0xFF283593},
  };

  static const Map<String, Map<String, dynamic>> _deptConfigs = {
    'Manajemen Puncak & Admin':       {'emoji': '🏢', 'color': 0xFF7B1FA2},
    'Tim Pelatihan (Trainer)':        {'emoji': '🎓', 'color': 0xFFE91E63},
    'Tim Produksi Teater & Acara':    {'emoji': '🎭', 'color': 0xFF1565C0},
    'Tim Kreatif & Konten Digital':   {'emoji': '🎨', 'color': 0xFF2E7D32},
    'Tim Merchandise & Official Store': {'emoji': '🛍️', 'color': 0xFFE65100},
    'Tim MUA & Kostum':               {'emoji': '💄', 'color': 0xFFC2185B},
    'Tim Keamanan & Operasional Teater': {'emoji': '🛡️', 'color': 0xFFC62828},
  };

  static const List<String> _deptOrder = [
    'Manajemen Puncak & Admin',
    'Tim Pelatihan (Trainer)',
    'Tim Produksi Teater & Acara',
    'Tim Kreatif & Konten Digital',
    'Tim Merchandise & Official Store',
    'Tim MUA & Kostum',
    'Tim Keamanan & Operasional Teater',
  ];

  Widget _buildRoleBadge(String role) {
    final cfg = _badgeConfigs[role];
    final String text = cfg != null ? cfg['text'] as String : 'Staf ⚙️';
    final Color color = cfg != null ? Color(cfg['color'] as int) : Colors.blueGrey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDeptHeader(String dept) {
    final cfg = _deptConfigs[dept];
    final emoji = cfg?['emoji'] as String? ?? '📋';
    final Color color = cfg != null ? Color(cfg['color'] as int) : Colors.blueGrey;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            dept,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
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
        leading: AvatarGenerator.avatarImage(
          url: avatarUrl,
          width: 40,
          height: 40,
          gender: widget.character.gender,
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
            Expanded(child: Text('$role • Umur: ${widget.character.age} tahun')),
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
        leading: AvatarGenerator.avatarImage(
          url: avatarUrl,
          width: 40,
          height: 40,
          gender: gender,
        ),
        title: Row(
          children: [
            Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
            if (widget.character.isAnyPartnerNameMatching(name)) ...[
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
                Expanded(child: Text('$role • $age tahun')),
                _buildRoleBadge(role),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rel / 100,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 4,
              ),
            ),
            Text('Hubungan: $rel%', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
    final userJob = widget.character.jobName ?? '';

    // Group staff by department
    final Map<String, List<Map<String, String>>> byDept = {};
    for (final dept in _deptOrder) {
      byDept[dept] = [];
    }
    for (final staff in staffList) {
      final dept = staff['department'] ?? 'Manajemen Puncak & Admin';
      byDept.putIfAbsent(dept, () => []);
      byDept[dept]!.add(staff);
    }

    // Figure out which dept the user belongs to (based on role string)
    String userDept = 'Manajemen Puncak & Admin';
    if (userJob.contains('Staf Operasional') || userJob == 'Staf Operasional Idol') {
      // legacy – could be any dept; default to Manajemen
      userDept = 'Manajemen Puncak & Admin';
    } else if (userJob.contains('General Manager')) {
      userDept = 'Manajemen Puncak & Admin';
    }

    final totalStaff = staffList.length + (isUserStaff ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staf & Manajemen 👥'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Container(
            width: double.infinity,
            color: Colors.pink.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Total staf: $totalStaff orang',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
      body: staffList.isEmpty && !isUserStaff
          ? const Center(
              child: Text(
                'Tidak ada staf atau manajemen tersedia.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: _buildAllSections(context, byDept, isUserStaff),
            ),
    );
  }

  List<Widget> _buildAllSections(
    BuildContext context,
    Map<String, List<Map<String, String>>> byDept,
    bool isUserStaff,
  ) {
    final result = <Widget>[];
    final userJob = widget.character.jobName ?? '';
    final isGMRole = userJob.contains('General Manager');

    for (final dept in _deptOrder) {
      final deptStaff = byDept[dept] ?? [];
      final showUserHere = isUserStaff && isGMRole && dept == 'Manajemen Puncak & Admin';

      if (deptStaff.isEmpty && !showUserHere) continue;

      result.add(_buildDeptHeader(dept));
      if (showUserHere) result.add(_buildUserStaffCard(context));
      for (final staff in deptStaff) {
        result.add(_buildNPCStaffCard(context, staff));
      }
    }

    // Fallback: if user is ops staff with no dept match, prepend at top
    if (isUserStaff && !isGMRole) {
      result.insert(0, _buildUserStaffCard(context));
    }

    return result;
  }
}

