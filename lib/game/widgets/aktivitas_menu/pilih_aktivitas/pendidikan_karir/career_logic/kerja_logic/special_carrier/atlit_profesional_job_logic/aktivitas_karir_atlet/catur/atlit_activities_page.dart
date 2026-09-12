import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

import 'action_menu/latihan_kondisi_fisik/finishing_drill_action.dart';
import 'action_menu/latihan_kondisi_fisik/physical_drill_action.dart';
import 'action_menu/latihan_kondisi_fisik/rest_recovery_action.dart';
import 'action_menu/latihan_kondisi_fisik/physio_consultation_action.dart';

import 'action_menu/kontrak_manajemen/negotiate_contract_catur_action.dart';
import 'action_menu/kontrak_manajemen/consult_agent_catur_action.dart';

import 'action_menu/pertandingan_statistik/career_history_catur_modal.dart';

import 'action_menu/sosial_media_fans/press_conference_catur_action.dart';
import 'action_menu/sosial_media_fans/post_social_media_catur_action.dart';

import 'action_menu/rekan_tim/team_dinner_action.dart';
import 'action_menu/rekan_tim/rekan_tim_page.dart';

class AtlitCaturActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitCaturActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AtlitCaturActivitiesPage> createState() => _AtlitCaturActivitiesPageState();
}

class _AtlitCaturActivitiesPageState extends State<AtlitCaturActivitiesPage> {
  void _showResult(String title, String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _triggerRefresh() {
    if (mounted) setState(() {});
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int fitnessVal = widget.character.health;

    int totalMainStat = 0;
    for (var item in widget.character.athleteSeasonStats) {
      totalMainStat += (item['wins'] as num?)?.toInt() ?? 0;
    }
    final currentStats = widget.character.currentAthleteStats;
    if (currentStats != null) {
      totalMainStat += (currentStats['wins'] as num?)?.toInt() ?? 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Karir Atlet Catur ♟️'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.deepPurple.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text('♟️', style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.character.jobName ?? 'Pecatur Utama',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const Text(
                              'Status: Atlet Utama ♟️',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Kemenangan', '$totalMainStat ♟️', Icons.stars, Colors.amber, isDark),
                        Container(height: 24, width: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        _buildStatItem('Kontrak Sisa', '${widget.character.athleteContractYears} Thn', Icons.description, Colors.blue, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fitness_center, size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text('Kebugaran Fisik:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                        ],
                      ),
                      Text('$fitnessVal%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fitnessVal >= 70 ? Colors.green : Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: fitnessVal / 100,
                      minHeight: 10,
                      backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(fitnessVal >= 70 ? Colors.green : Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 1. LATIHAN & KONDISI FISIK
          _buildCategoryHeader('LATIHAN & KONDISI FISIK', Icons.fitness_center, Colors.deepPurple),
          _buildActionCard(
            title: 'Latihan Teknik & Ketajaman 🎯',
            subtitle: 'Melatih fokus dan teknik bertanding Catur',
            icon: Icons.sports,
            color: Colors.deepPurple,
            onTap: () => FinishingDrillAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Latihan Fisik & Ketahanan 🏃‍♂️',
            subtitle: 'Meningkatkan daya tahan tubuh dan kecepatan',
            icon: Icons.speed,
            color: Colors.orange,
            onTap: () => PhysicalDrillAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Istirahat & Pemulihan 💤',
            subtitle: 'Memulihkan stamina tubuh pasca sesi pertandingan',
            icon: Icons.hot_tub,
            color: Colors.teal,
            onTap: () => RestRecoveryAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Konsultasi Fisioterapi 🩺',
            subtitle: 'Merawat cedera fisik dan persendian bersama dokter team',
            icon: Icons.medical_services,
            color: Colors.blue,
            onTap: () => PhysioConsultationAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // 2. PERTANDINGAN & STATISTIK
          _buildCategoryHeader('PERTANDINGAN & STATISTIK', Icons.stadium, Colors.deepPurple),
          _buildActionCard(
            title: 'Riwayat Karir & Statistik 📜',
            subtitle: 'Lihat perolehan statistik pertandingan dan performa rating',
            icon: Icons.history,
            color: Colors.purple,
            onTap: () => CareerHistoryCaturModal.show(
              context: context,
              character: widget.character,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // 3. KONTRAK & MANAJEMEN
          _buildCategoryHeader('KONTRAK & MANAJEMEN', Icons.business_center, Colors.deepPurple),
          _buildActionCard(
            title: 'Negosiasi Kontrak 📝',
            subtitle: 'Minta negosiasi gaji dan nilai kontrak baru kepada klub',
            icon: Icons.monetization_on,
            color: Colors.purple,
            onTap: () => NegotiateContractCaturAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Diskusi Bersama Agen 💼',
            subtitle: 'Membahas peluang bursa transfer dan minat klub lain',
            icon: Icons.record_voice_over,
            color: Colors.deepPurple,
            onTap: () => ConsultAgentCaturAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // 4. SOSIAL & MEDIA
          _buildCategoryHeader('SOSIAL & MEDIA FANS', Icons.campaign, Colors.blue),
          _buildActionCard(
            title: 'Konferensi Pers 🎙️',
            subtitle: 'Wawancara bersama jurnalis media olahraga',
            icon: Icons.mic,
            color: Colors.blue,
            onTap: () => PressConferenceCaturAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Unggah Post Sosial Media 📲',
            subtitle: 'Bagikan postingan dan sapa penggemar di media sosial',
            icon: Icons.thumb_up,
            color: Colors.blueAccent,
            onTap: () => PostSocialMediaCaturAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // 5. KEKOMPAKAN & REKAN TIM
          _buildCategoryHeader('KEKOMPAKAN & REKAN TIM', Icons.groups, Colors.amber.shade800),
          _buildActionCard(
            title: 'Makan Malam Bersama Tim 🍽️',
            subtitle: 'Acara keakraban bersama kawan-kawan tim & pelatih',
            icon: Icons.restaurant,
            color: Colors.amber.shade800,
            onTap: () => TeamDinnerAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Daftar Rekan Tim & Pelatih 👥',
            subtitle: 'Lihat skuad tim dan bina keakraban',
            icon: Icons.group,
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RekanTimPage(
                    character: widget.character,
                    onRefresh: _triggerRefresh,
                  ),
                ),
              );
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? Colors.white70 : Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatItem(String label, String val, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              val,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
