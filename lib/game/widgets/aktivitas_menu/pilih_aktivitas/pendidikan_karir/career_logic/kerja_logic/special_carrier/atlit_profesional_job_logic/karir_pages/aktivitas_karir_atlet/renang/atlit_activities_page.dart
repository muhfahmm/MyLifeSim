// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/atlit_activities_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

import 'action_menu/latihan_kondisi_fisik/swim_drill_action.dart';
import 'action_menu/latihan_kondisi_fisik/physical_drill_action.dart';
import 'action_menu/latihan_kondisi_fisik/rest_recovery_action.dart';
import 'action_menu/latihan_kondisi_fisik/physio_consultation_action.dart';

import 'action_menu/kontrak_manajemen/negotiate_contract_renang_action.dart';
import 'action_menu/kontrak_manajemen/consult_agent_renang_action.dart';

import 'action_menu/pertandingan_statistik/career_history_renang_modal.dart';
import 'season_stats_renang_modal.dart';

import 'action_menu/sosial_media_fans/press_conference_renang_action.dart';
import 'action_menu/sosial_media_fans/post_social_media_renang_action.dart';

import 'action_menu/rekan_tim/team_dinner_action.dart';
import 'action_menu/rekan_tim/rekan_tim_page.dart';

class AtlitRenangActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitRenangActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AtlitRenangActivitiesPage> createState() => _AtlitRenangActivitiesPageState();
}

class _AtlitRenangActivitiesPageState extends State<AtlitRenangActivitiesPage> {
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
            onPressed: () {
              Navigator.pop(ctx);
              if (mounted) setState(() {});
              widget.onRefresh();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int fitnessVal = widget.character.health;

    int totalGolds = 0;
    int totalMedals = 0;

    for (var item in widget.character.athleteSeasonStats) {
      totalGolds += (item['goldMedals'] as num?)?.toInt() ?? 0;
      totalMedals += (item['totalMedals'] as num?)?.toInt() ?? 0;
    }
    final currentStats = widget.character.currentAthleteStats;
    if (currentStats != null) {
      totalGolds += (currentStats['goldMedals'] as num?)?.toInt() ?? 0;
      totalMedals += (currentStats['totalMedals'] as num?)?.toInt() ?? 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Karir Atlet Renang 🏊‍♂️'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.blue.shade50.withValues(alpha: 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.pool, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.character.jobName ?? 'Perenang Atlet Profesional',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.blue.shade900,
                              ),
                            ),
                            Text(
                              'Status Skuad: Perenang Utama 🏊‍♂️',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue.shade800),
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
                      border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.blue.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Emas', '$totalGolds 🥇', Icons.workspace_premium, Colors.amber, isDark),
                        Container(height: 24, width: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        _buildStatItem('Total Medali', '$totalMedals 🏅', Icons.military_tech, Colors.blue, isDark),
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
          _buildCategoryHeader('LATIHAN & KONDISI FISIK', Icons.fitness_center, Colors.green),
          _buildActionCard(
            title: 'Latihan Teknik Renang 🏊‍♂️',
            subtitle: 'Tingkatkan teknik kayuhan dan pembalikan dinding',
            icon: Icons.pool,
            color: Colors.blue,
            onTap: () => SwimDrillAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Latihan Fisik & VO2 Max 💪',
            subtitle: 'Tingkatkan stamina dan daya tahan pernapasan',
            icon: Icons.directions_run,
            color: Colors.green,
            onTap: () => PhysicalDrillAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Istirahat & Pemulihan Otot 🛌',
            subtitle: 'Pulihkan energi fisik dan cegah cedera bahu',
            icon: Icons.bed,
            color: Colors.teal,
            onTap: () => RestRecoveryAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Konsultasi Fisioterapi 🏥',
            subtitle: 'Periksakan kesehatan sendi dan bahu ke dokter',
            icon: Icons.local_hospital,
            color: Colors.redAccent,
            onTap: () => PhysioConsultationAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildCategoryHeader('KONTRAK & MANAJEMEN', Icons.assignment, Colors.indigo),
          _buildActionCard(
            title: 'Diskusi Kontrak Klub 📝',
            subtitle: 'Bahas nilai gaji dan kesepakatan bonus medali',
            icon: Icons.edit_note,
            color: Colors.indigo,
            onTap: () => NegotiateContractRenangAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Konsultasi Agen Renang 👔',
            subtitle: 'Bicara dengan agen mengenai kejuaraan & sponsor',
            icon: Icons.support_agent,
            color: Colors.blueGrey,
            onTap: () => ConsultAgentRenangAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildCategoryHeader('REKAN TIM & KLUB', Icons.groups, Colors.orange),
          _buildActionCard(
            title: 'Makan Bersama Tim Renang 🍽️',
            subtitle: 'Tingkatkan keakraban antar perenang satu klub',
            icon: Icons.restaurant,
            color: Colors.orange,
            onTap: () => TeamDinnerAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Lihat Rekan Tim & Pelatih 👥',
            subtitle: 'Daftar perenang dan staf pelatih klub',
            icon: Icons.people,
            color: Colors.deepOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RekanTimRenangPage(character: widget.character)),
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildCategoryHeader('SOSIAL MEDIA & FANS', Icons.public, Colors.purple),
          _buildActionCard(
            title: 'Konferensi Pers Kejuaraan 🎙️',
            subtitle: 'Berikan wawancara resmi kepada media sport',
            icon: Icons.mic,
            color: Colors.purple,
            onTap: () => PressConferenceRenangAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Posting Media Sosial 📱',
            subtitle: 'Bagikan postingan seputar latihan renang kamu',
            icon: Icons.share,
            color: Colors.pink,
            onTap: () => PostSocialMediaRenangAction.execute(context, widget.character, _showResult),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildCategoryHeader('PERTANDINGAN & STATISTIK', Icons.stadium, Colors.blue),
          _buildActionCard(
            title: 'Statistik Musim Ini 📊',
            subtitle: 'Lihat perolehan medali emas dan total medali musim berjalan',
            icon: Icons.bar_chart,
            color: Colors.cyan,
            onTap: () => SeasonStatsRenangModal.show(context: context, character: widget.character),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Riwayat Karir & Medali Renang 📜',
            subtitle: 'Lihat perolehan medali emas, total medali, dan rating kejuaraan',
            icon: Icons.history,
            color: Colors.blue,
            onTap: () => CareerHistoryRenangModal.show(
              context: context,
              character: widget.character,
            ),
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
