// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/atlit_activities_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'action_menu/rekan_tim/rekan_tim_page.dart';

// Import action files per modul/folder
import 'action_menu/latihan_kondisi_fisik/finishing_drill_action.dart';
import 'action_menu/latihan_kondisi_fisik/physical_drill_action.dart';
import 'action_menu/latihan_kondisi_fisik/rest_recovery_action.dart';
import 'action_menu/latihan_kondisi_fisik/physio_consultation_action.dart';

import 'action_menu/kontrak_manajemen/negotiate_contract_action.dart';
import 'action_menu/kontrak_manajemen/consult_agent_action.dart';

import 'action_menu/pertandingan_statistik/career_history_modal.dart';

import 'action_menu/sosial_media_fans/press_conference_action.dart';
import 'action_menu/sosial_media_fans/post_social_media_action.dart';

import 'action_menu/rekan_tim/team_dinner_action.dart';

class AtlitActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AtlitActivitiesPage> createState() => _AtlitActivitiesPageState();
}

class _AtlitActivitiesPageState extends State<AtlitActivitiesPage> {
  String _formatFollowers(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

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
    final String statusStarter = ((widget.character.discipline + widget.character.health) / 2) >= 65 ? 'Pemain Utama (Starter) ⭐' : 'Pemain Cadangan 👥';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Karir Atlet ⚽🏆'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STATUS BAR PEMAIN ATLET
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50.withValues(alpha: 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.sports_soccer, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.character.jobName ?? 'Atlet Profesional',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.green.shade900,
                              ),
                            ),
                            Text(
                              'Status Skuad: $statusStarter',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, size: 16, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text(
                            'Kontrak Tersisa:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.character.athleteContractYears <= 1 ? Colors.red.shade100 : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.character.athleteContractYears} Tahun',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.character.athleteContractYears <= 1 ? Colors.red.shade900 : Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fitness_center, size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text('Kebugaran & Stamina:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
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
                      valueColor: AlwaysStoppedAnimation<Color>(fitnessVal >= 70 ? Colors.green : (fitnessVal >= 40 ? Colors.amber : Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_user_rounded, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            'Kepercayaan Publik: ${widget.character.publicTrust}%',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.psychology_alt_rounded, size: 14, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Text(
                            'Tekanan: ${widget.character.pressure}%',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            'Followers: ${_formatFollowers(widget.character.followers)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.purple),
                          const SizedBox(width: 4),
                          Text(
                            'Popularitas: ${widget.character.popularity}%',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // BADGE STATUS CEDERA (Tampil di bawah bar kebugaran jika mengalami cedera)
                  if (widget.character.athleteIsInjured) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade400),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.healing, color: Colors.white, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'STATUS: CEDERA (${widget.character.athleteInjuryType ?? "Cedera Otot"}) 🚑',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // KATEGORI 1: LATIHAN & KONDISI FISIK
          _buildCategoryHeader('LATIHAN & KONDISI FISIK', Icons.fitness_center, Colors.orange),
          _buildActionCard(
            title: 'Latihan Finishing & Shooting 🎯',
            subtitle: 'Melatih penyelesaian akhir, sepakan insting, dan volley',
            icon: Icons.sports_soccer,
            color: Colors.green,
            onTap: () => FinishingDrillAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Latihan Fisik & Kecepatan 🏃‍♂️',
            subtitle: 'Meningkatkan ketahanan otot dan kecepatan sprint',
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
            title: 'Pemulihan & Mandi Es 🛀',
            subtitle: 'Memulihkan stamina dan mencegah kelelahan otot',
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
            title: 'Konsultasi Fisioterapis 🩺',
            subtitle: 'Merawat persendian dan mencegah kecenderungan cedera (\$200)',
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

          // KATEGORI 2: PERTANDINGAN & KARIER INTI
          _buildCategoryHeader('PERTANDINGAN & STATISTIK', Icons.stadium, Colors.deepOrange),
          _buildActionCard(
            title: 'Riwayat Karir & Statistik Musim 📜',
            subtitle: 'Lihat perjalanan gol, assist, dan rating per perambahan usia',
            icon: Icons.history,
            color: Colors.purple,
            onTap: () => CareerHistoryModal.show(
              context: context,
              character: widget.character,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 3: KONTRAK & MANAJEMEN
          _buildCategoryHeader('KONTRAK & MANAJEMEN', Icons.business_center, Colors.purple),
          _buildActionCard(
            title: 'Negosiasi Kenaikan Kontrak 📝',
            subtitle: 'Minta kenaikan nilai gaji tahunan kepada manajemen klub',
            icon: Icons.monetization_on,
            color: Colors.purple,
            onTap: () => NegotiateContractAction.execute(
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
            onTap: () => ConsultAgentAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 4: SOSIAL & MEDIA
          _buildCategoryHeader('SOSIAL & MEDIA FANS', Icons.campaign, Colors.lightBlue),
          _buildActionCard(
            title: 'Hadir di Konferensi Pers 🎙️',
            subtitle: 'Berikan pernyataan pers setelah sesi latihan/pertandingan',
            icon: Icons.mic,
            color: Colors.lightBlue,
            onTap: () => PressConferenceAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Unggah Aktivitas di Medsos 📲',
            subtitle: 'Berinteraksi dengan penggemar dan meningkatkan popularitas',
            icon: Icons.thumb_up,
            color: Colors.blueAccent,
            onTap: () => PostSocialMediaAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 5: TIM & BONDING
          _buildCategoryHeader('KEKOMPAKAN & REKAN TIM', Icons.groups, Colors.amber.shade800),
          _buildActionCard(
            title: 'Makan Malam Bersama Tim 🥩',
            subtitle: 'Mentraktir rekan tim utama & cadangan (\$300)',
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
            title: 'Rekan Tim Utama & Cadangan 👥',
            subtitle: 'Berinteraksi, membangun chemistry, dan mengobrol bersama rekan',
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
}
