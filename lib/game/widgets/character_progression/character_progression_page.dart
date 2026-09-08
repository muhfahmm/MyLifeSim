// lib/game/widgets/character_progression/character_progression_page.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_preset.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class CharacterProgressionPage extends StatefulWidget {
  final Character character;

  const CharacterProgressionPage({
    super.key,
    required this.character,
  });

  @override
  State<CharacterProgressionPage> createState() => _CharacterProgressionPageState();
}

class _CharacterProgressionPageState extends State<CharacterProgressionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final char = widget.character;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.indigo.shade800,
        foregroundColor: Colors.white,
        title: const Text(
          'Detail & Perkembangan Karakter 👤✨',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Profil & Visual'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Atribut & Stat'),
            Tab(icon: Icon(Icons.history_edu), text: 'Riwayat & Hidup'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(char, isDark),
          _buildAttributesTab(char, isDark),
          _buildHistoryTab(char, isDark),
        ],
      ),
    );
  }

  // --- TAB 1: PROFIL & VISUAL NOVEL STANDEE ---
  Widget _buildProfileTab(Character char, bool isDark) {
    final hasPartner = char.friends.any((f) =>
        f['isDating'] == 'true' ||
        f['relation'] == 'Pacar' ||
        f['relation'] == 'Suami' ||
        f['relation'] == 'Istri');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Banner Frame Visual Novel Avatar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.indigo.shade900, Colors.purple.shade900]
                    : [Colors.indigo.shade600, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'SISTEM VISUAL NOVEL KARAKTER',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                // Render Standee VN Character View
                VNCharacterView(
                  character: char,
                  isActiveSpeaker: true,
                  width: 220,
                  height: 320,
                  customName: char.name,
                ),
                const SizedBox(height: 16),
                Text(
                  char.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${char.gender} • ${char.age} Tahun',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '📍 ${char.currentCity ?? char.location} (${char.birthCountry ?? "Indonesia"})',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final dummyNPC = {
                      'name': 'Mentari',
                      'gender': char.gender.toLowerCase() == 'laki-laki' ? 'Perempuan' : 'Laki-laki',
                      'age': char.age.toString(),
                      'relation': 'Teman Kencan',
                    };
                    final nodes = VNDialoguePreset.getDatingDialogue(
                      player: char,
                      npc: dummyNPC,
                    );
                    VNDialogueOverlay.show(
                      context: context,
                      player: char,
                      npc: dummyNPC,
                      nodes: nodes,
                      onFinished: () {
                        setState(() {});
                      },
                    );
                  },
                  icon: const Icon(Icons.forum, color: Colors.amber),
                  label: const Text(
                    'Simulasi Percakapan Visual Novel 💬',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Card Informasi Ringkas
          _buildCardInfoGroup(
            isDark: isDark,
            title: 'Keluarga & Identitas',
            icon: Icons.badge,
            items: [
              _buildInfoRow('Negara Kelahiran', char.birthCountry ?? '-'),
              _buildInfoRow('Kota Kelahiran', char.birthCity ?? '-'),
              _buildInfoRow('Seksualitas', char.sexuality),
              _buildInfoRow('Talenta Spesial', char.specialTalent.isNotEmpty ? char.specialTalent : 'Tidak Ada'),
              _buildInfoRow('Status Pernikahan/Pasangan', hasPartner ? 'Berpasangan' : 'Lajang'),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: ATRIBUT & STATISTIK ---
  Widget _buildAttributesTab(Character char, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Atribut Utama Karakter', Icons.star, isDark),
          const SizedBox(height: 10),
          _buildStatProgressBar('Kesehatan', char.health, Colors.red, isDark),
          _buildStatProgressBar('Kebahagiaan', char.happiness, Colors.orange, isDark),
          _buildStatProgressBar('Kecerdasan', char.intelligence, Colors.blue, isDark),
          _buildStatProgressBar('Penampilan', char.appearance, Colors.pink, isDark),

          const SizedBox(height: 20),
          _buildSectionTitle('Atribut Sekunder & Kepribadian', Icons.psychology, isDark),
          const SizedBox(height: 10),
          _buildStatProgressBar('Disiplin', char.discipline, Colors.purple, isDark),
          _buildStatProgressBar('Karma', char.karma, Colors.teal, isDark),
          _buildStatProgressBar('Tekad / Willpower', char.willpower, Colors.amber.shade800, isDark),
          _buildStatProgressBar('Kesuburan', char.fertility, Colors.green, isDark),

          const SizedBox(height: 20),
          _buildCardInfoGroup(
            isDark: isDark,
            title: 'Karakteristik Sifat (Traits)',
            icon: Icons.bubble_chart,
            items: char.traits.isNotEmpty
                ? char.traits.map((t) => _buildInfoRow('Sifat', t)).toList()
                : [_buildInfoRow('Sifat', 'Belum ada sifat khusus')],
          ),
        ],
      ),
    );
  }

  // --- TAB 3: RIWAYAT & RIWAYAT PERKEMBANGAN ---
  Widget _buildHistoryTab(Character char, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCardInfoGroup(
            isDark: isDark,
            title: 'Keuangan & Sosial',
            icon: Icons.account_balance_wallet,
            items: [
              _buildInfoRow('Saldo Kas Dompet', CurrencySettings.format(char.money)),
              _buildInfoRow('Jumlah Pengikut / Followers', '${char.followers} Orang'),
              _buildInfoRow('Jumlah Teman Dekat', '${char.friends.length} Orang'),
              _buildInfoRow('Jumlah Riwayat Notifikasi Inbox', '${char.inbox.length} Pesan'),
            ],
          ),
          const SizedBox(height: 16),
          _buildCardInfoGroup(
            isDark: isDark,
            title: 'Statistik Interaksi & Ajakan (VN System)',
            icon: Icons.forum,
            items: [
              _buildInfoRow('Ajakan Pacaran Diterima', '${char.countAjakanPacaran} kali'),
              _buildInfoRow('Ajakan Bercinta Diterima', '${char.countAjakanMakeLove} kali'),
              _buildInfoRow('Ajakan Masturbasi Diterima', '${char.countAjakanMasturbasi} kali'),
              _buildInfoRow('Total Riwayat Proposal / Event', '${char.proposalHistory.length} Kejadian'),
            ],
          ),
          const SizedBox(height: 16),
          _buildCardInfoGroup(
            isDark: isDark,
            title: 'Status Hukum & Khusus',
            icon: Icons.gavel,
            items: [
              _buildInfoRow('Pernah Dipenjara?', char.isImprisoned ? 'Ya (${char.remainingJailYears} Thn Sisa)' : 'Tidak'),
              _buildInfoRow('Hasil Kejahatan Terakhir', CurrencySettings.format(char.lastCrimeLoot)),
              _buildInfoRow('Kontrol KB Aktif?', char.birthControlActive ? 'Ya' : 'Tidak'),
            ],
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatProgressBar(String label, int value, Color color, bool isDark) {
    final clamped = value.clamp(0, 100);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$clamped%',
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: clamped / 100,
              minHeight: 10,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfoGroup({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.indigo.shade400, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
