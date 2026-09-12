// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/atlit_activities_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'balap_logic/logika_usia_rekan_tim_balap.dart';

import 'action_menu/latihan_kondisi_fisik/track_drill_balap_action.dart';
import 'action_menu/latihan_kondisi_fisik/neck_reflex_balap_action.dart';
import '../sepakbola/action_menu/latihan_kondisi_fisik/rest_recovery_action.dart';
import '../sepakbola/action_menu/latihan_kondisi_fisik/physio_consultation_action.dart';

import 'action_menu/kontrak_manajemen/negotiate_contract_balap_action.dart';
import 'action_menu/kontrak_manajemen/consult_agent_balap_action.dart';

import 'action_menu/pertandingan_statistik/career_history_balap_modal.dart';

import 'action_menu/sosial_media_fans/press_conference_balap_action.dart';
import 'action_menu/sosial_media_fans/post_social_media_balap_action.dart';

import 'action_menu/rekan_tim/team_dinner_balap_action.dart';
import '../sepakbola/action_menu/rekan_tim/rekan_tim_page.dart';

class AtlitBalapActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitBalapActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AtlitBalapActivitiesPage> createState() => _AtlitBalapActivitiesPageState();
}

class _AtlitBalapActivitiesPageState extends State<AtlitBalapActivitiesPage> {
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
    final String statusStarter = ((widget.character.discipline + widget.character.health) / 2) >= 65
        ? 'Pebalap Utama (Starter) 🏆'
        : 'Pebalap Cadangan / Test Driver 🏎️';

    final String teamCategory = LogikaUsiaRekanTimBalap.getKategoriTimBerdasarkanUsia(usia: widget.character.age);
    String displayJobName = widget.character.jobName ?? 'Pebalap Profesional';
    if (!displayJobName.contains(teamCategory) && !displayJobName.contains('Grand Prix')) {
      displayJobName = '$displayJobName ($teamCategory)';
    }

    int totalPodiums = 0;
    int totalPoles = 0;

    for (var item in widget.character.athleteSeasonStats) {
      totalPodiums += (item['podiums'] as num?)?.toInt() ?? (item['goals'] as num?)?.toInt() ?? 0;
      totalPoles += (item['polePositions'] as num?)?.toInt() ?? 0;
    }
    final currentStats = widget.character.currentAthleteStats;
    if (currentStats != null) {
      totalPodiums += (currentStats['podiums'] as num?)?.toInt() ?? (currentStats['goals'] as num?)?.toInt() ?? 0;
      totalPoles += (currentStats['polePositions'] as num?)?.toInt() ?? 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Karir Atlet Balap 🏎️🏆'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.red.shade50.withValues(alpha: 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.sports_motorsports, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayJobName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDark ? Colors.white : Colors.red.shade900,
                              ),
                            ),
                            Text(
                              'Status: $statusStarter',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red.shade800),
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
                      border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.red.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Podium', '$totalPodiums 🏆', Icons.emoji_events, Colors.amber.shade800, isDark),
                        Container(height: 24, width: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        _buildStatItem('Pole Position', '$totalPoles ⏱️', Icons.timer, Colors.deepOrange, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, size: 16, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text('Kontrak Tersisa:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
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
                          Text('Kebugaran & Refleks:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
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
                          Text('Kepercayaan Publik: ${widget.character.publicTrust}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.psychology_alt_rounded, size: 14, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Text('Tekanan: ${widget.character.pressure}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
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
                          Text('Followers: ${_formatFollowers(widget.character.followers)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.purple),
                          const SizedBox(width: 4),
                          Text('Popularitas: ${widget.character.popularity}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // KATEGORI 1: LATIHAN BALAP
          _buildCategoryHeader('LATIHAN SIRKUIT & REFLEKS', Icons.sports_motorsports, Colors.red),
          _buildActionCard(
            title: 'Latihan Simulasi Lap Sirkuit 🏎️',
            subtitle: 'Melatih racing line, trail braking, dan overtaking',
            icon: Icons.sports_motorsports,
            color: Colors.red,
            onTap: () => TrackDrillBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Latihan Otot Leher & G-Force 🏋️‍♂️',
            subtitle: 'Daya tahan otot leher saat menahan dorongan tikungan tajam',
            icon: Icons.fitness_center,
            color: Colors.deepOrange,
            onTap: () => NeckReflexBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Pemulihan & Mandi Es 🛀',
            subtitle: 'Memulihkan fokus dan kelelahan fisik pasca race',
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
            subtitle: 'Merawat persendian dan mencegah cedera (\$200)',
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

          // KATEGORI 2: PERTANDINGAN & STATISTIK
          _buildCategoryHeader('PERSERI & STATISTIK BALAP', Icons.stadium, Colors.deepOrange),
          _buildActionCard(
            title: 'Riwayat Karir & Statistik Seri 📜',
            subtitle: 'Lihat jumlah podium, pole position, dan rating per musim',
            icon: Icons.history,
            color: Colors.purple,
            onTap: () => CareerHistoryBalapModal.show(
              context: context,
              character: widget.character,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 3: KONTRAK & MANAJEMEN
          _buildCategoryHeader('KONTRAK & TIM PADDOCK', Icons.business_center, Colors.purple),
          _buildActionCard(
            title: 'Negosiasi Kontrak Tim Balap 📝',
            subtitle: 'Minta perbaikan nilai kontrak kepada manajemen pabrikan tim',
            icon: Icons.monetization_on,
            color: Colors.purple,
            onTap: () => NegotiateContractBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Diskusi Bersama Manajer / Agen 💼',
            subtitle: 'Membahas minat pabrikan tim balap lain di bursa transfer',
            icon: Icons.record_voice_over,
            color: Colors.deepPurple,
            onTap: () => ConsultAgentBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 4: SOSIAL & MEDIA FANS
          _buildCategoryHeader('SOSIAL & MEDIA FANS', Icons.campaign, Colors.lightBlue),
          _buildActionCard(
            title: 'Konferensi Pers Grand Prix 🎙️',
            subtitle: 'Memberikan wawasan pers pasca kualifikasi dan sesi race',
            icon: Icons.mic,
            color: Colors.lightBlue,
            onTap: () => PressConferenceBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Unggah On-Board Cam di Medsos 📲',
            subtitle: 'Bagikan video kamera helm dan sapa fans motorsport',
            icon: Icons.thumb_up,
            color: Colors.blueAccent,
            onTap: () => PostSocialMediaBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 5: TIM PADDOCK & REKAN
          _buildCategoryHeader('TIM PADDOCK & KRU MEKANIK', Icons.groups, Colors.amber.shade800),
          _buildActionCard(
            title: 'Makan Malam Bersama Tim Paddock 🥩',
            subtitle: 'Mentraktir insinyur mesin & mekanik tim balap (\$400)',
            icon: Icons.restaurant,
            color: Colors.amber.shade800,
            onTap: () => TeamDinnerBalapAction.execute(
              context: context,
              character: widget.character,
              onRefresh: _triggerRefresh,
              showResult: _showResult,
            ),
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Interaksi Kru Paddock 👥',
            subtitle: 'Berdiskusi bersama mekanik & rekan tim balap',
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
