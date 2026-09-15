// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/politikus_job_logic/rekan_politik/rekan_politik_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/classmate_interaction_page.dart';

class RekanPolitikPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanPolitikPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanPolitikPage> createState() => _RekanPolitikPageState();
}

class _RekanPolitikPageState extends State<RekanPolitikPage> {
  Character get character => widget.character;

  @override
  void initState() {
    super.initState();
    if (character.jobName != null && character.coworkers.isEmpty) {
      character.generateCoworkersIfEmpty();
    }
    _adjustPoliticalRoles();
  }

  void _adjustPoliticalRoles() {
    final String job = character.jobName ?? '';

    List<String> roles = [];
    if (job == 'Anggota Dewan Kota / DPRD') {
      roles = ['Anggota Fraksi', 'Staf Ahli Parlemen', 'Ketua Komisi', 'Sekretaris Dewan', 'Anggota Dewan'];
    } else if (job == 'Walikota / Bupati') {
      roles = ['Wakil Walikota', 'Sekretaris Daerah (Sekda)', 'Kepala Dinas Bappeda', 'Kepala Dinas Kesehatan', 'Kepala Dinas Pendidikan'];
    } else if (job == 'Gubernur / Senator') {
      roles = ['Wakil Gubernur', 'Ketua DPRD Provinsi', 'Sekda Provinsi', 'Kepala Dinas PU', 'Senator Wilayah'];
    } else if (job == 'Presiden / Perdana Menteri') {
      roles = ['Wakil Presiden', 'Menteri Luar Negeri', 'Menteri Keuangan', 'Menteri Pertahanan', 'Panglima TNI', 'Sekretaris Kabinet'];
    } else {
      roles = ['Kolega Politik', 'Staf Ahli', 'Mitra Kerja'];
    }

    for (int i = 0; i < character.coworkers.length; i++) {
      final item = character.coworkers[i];
      item['role'] = roles[i % roles.length];
    }
  }

  String _getSeniorHeader() {
    final String job = character.jobName ?? '';
    if (job == 'Anggota Dewan Kota / DPRD') {
      return 'Pimpinan Dewan & Ketua Fraksi 🏛️';
    } else if (job == 'Walikota / Bupati') {
      return 'Wakil Walikota & Sekda Kota 🏙️';
    } else if (job == 'Gubernur / Senator') {
      return 'Wakil Gubernur & Pimpinan Parlemen 🗺️';
    } else if (job == 'Presiden / Perdana Menteri') {
      return 'Wakil Presiden & Pimpinan Lembaga Tinggi 👑';
    }
    return 'Kolega Senior & Tokoh Politik 🏛️';
  }

  String _getSeniorSubtitle() {
    final String job = character.jobName ?? '';
    if (job == 'Anggota Dewan Kota / DPRD') {
      return 'Pimpinan fraksi parlemen dan dewan pimpinan daerah';
    } else if (job == 'Walikota / Bupati') {
      return 'Sekretaris Daerah & jajaran wakil kepala daerah';
    } else if (job == 'Gubernur / Senator') {
      return 'Wakil gubernur & pimpinan DPRD tingkat provinsi';
    } else if (job == 'Presiden / Perdana Menteri') {
      return 'Wakil presiden & ketua dewan perwakilan rakyat';
    }
    return 'Tokoh senior dan mitra penting dalam kebijakan publik';
  }

  void _showAlert(String title, String msg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.infinity,
          child: Text(
            msg,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _interactSenior(Map<String, String> senior, String action) {
    final r = Random();
    int currentRel = int.tryParse(senior['relationship'] ?? '50') ?? 50;

    if (action == 'diskusi') {
      currentRel = (currentRel + 3 + r.nextInt(4)).clamp(0, 100);
      senior['relationship'] = currentRel.toString();
      character.karma = (character.karma + 2).clamp(0, 100);
      setState(() {});
      widget.onRefresh();
      _showAlert(
        'Diskusi Kebijakan Politik 💬',
        'Kamu berdiskusi dengan ${senior['name']} mengenai strategi penganggaran & perundangan publik.\n\n'
        '• Tingkat Hubungan: $currentRel%\n'
        '• Dukungan Publik (Karma): +2%',
      );
    } else if (action == 'koalisi') {
      currentRel = (currentRel + 5 + r.nextInt(5)).clamp(0, 100);
      senior['relationship'] = currentRel.toString();
      character.intelligence = (character.intelligence + 1).clamp(0, 100);
      setState(() {});
      widget.onRefresh();
      _showAlert(
        'Kesepakatan Koalisi 🤝',
        'Kamu menyepakati kompromi politik dan dukungan suara bersama ${senior['name']}.\n\n'
        '• Tingkat Hubungan: $currentRel%\n'
        '• Kecerdasan Politik: +1%',
      );
    } else if (action == 'apresiasi') {
      currentRel = (currentRel + 6 + r.nextInt(5)).clamp(0, 100);
      senior['relationship'] = currentRel.toString();
      character.happiness = (character.happiness + 2).clamp(0, 100);
      setState(() {});
      widget.onRefresh();
      _showAlert(
        'Pemberian Apresiasi 🎁',
        'Kamu memberikan cenderamata kenegaraan dan mengapresiasi visi pimpinan ${senior['name']}.\n\n'
        '• Tingkat Hubungan: $currentRel%\n'
        '• Kebahagiaan: +2%',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String currentJob = character.jobName ?? 'Politikus';
    final coworkers = character.coworkers;
    final supervisor = character.supervisor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolega & Tokoh Politik 🏛️'),
        backgroundColor: Colors.amber.shade900,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.amber.shade900.withValues(alpha: 0.25) : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jajaran Kolega $currentJob',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bangun relasi politik dan perkuat pengaruh koalisi pemerintahan.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= SENIOR / TOKOH POLITIK SECTION =================
          if (supervisor != null) ...[
            Text(
              _getSeniorHeader(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getSeniorSubtitle(),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              color: isDark ? Colors.grey.shade800 : Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.amber.shade700),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(
                            AvatarAgeRules.getSchoolAvatarUrl(
                              name: supervisor['name']!,
                              gender: supervisor['gender']!,
                              age: int.tryParse(supervisor['age'] ?? '45') ?? 45,
                              schoolLevel: 'SMA',
                              happiness: int.tryParse(supervisor['relationship'] ?? '50') ?? 50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supervisor['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Senior Politik • Usia ${supervisor['age']} thn',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    'Hubungan: ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: (int.tryParse(supervisor['relationship'] ?? '50') ?? 50) / 100.0,
                                        minHeight: 8,
                                        backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${supervisor['relationship']}%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _interactSenior(supervisor, 'diskusi'),
                            icon: const Icon(Icons.chat, size: 12),
                            label: const Text(
                              'Diskusi 💬',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _interactSenior(supervisor, 'koalisi'),
                            icon: const Icon(Icons.handshake, size: 12),
                            label: const Text(
                              'Koalisi 🤝',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _interactSenior(supervisor, 'apresiasi'),
                            icon: const Icon(Icons.card_giftcard, size: 12),
                            label: const Text(
                              'Apresiasi 🎁',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ================= DAFTAR KOLEGA POLITIK =================
          Text(
            'Daftar Kolega & Staf Politik 👥',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 10),

          if (coworkers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Belum ada data kolega politik.',
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coworkers.length,
              itemBuilder: (ctx, idx) {
                final c = coworkers[idx];
                final String name = c['name'] ?? 'Kolega Politik';
                final String gender = c['gender'] ?? 'Laki-laki';
                final int age = int.tryParse(c['age'] ?? '35') ?? 35;
                final int rel = int.tryParse(c['relationship'] ?? '50') ?? 50;
                final String role = c['role'] ?? 'Kolega Politik';

                final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                  name: name,
                  gender: gender,
                  age: age,
                  schoolLevel: 'SMA',
                  happiness: rel,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$role • $gender, $age thn',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Hubungan: ',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: rel / 100.0,
                                  minHeight: 6,
                                  backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    rel >= 70 ? Colors.green : (rel >= 40 ? Colors.amber : Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$rel%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ClassmateInteractionPage(
                            character: character,
                            classmate: c,
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
        ],
      ),
    );
  }
}
