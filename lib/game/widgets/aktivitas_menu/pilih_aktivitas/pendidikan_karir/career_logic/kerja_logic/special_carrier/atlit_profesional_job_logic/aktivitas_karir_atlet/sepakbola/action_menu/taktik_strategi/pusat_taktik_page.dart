// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/taktik_strategi/pusat_taktik_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PusatTaktikPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PusatTaktikPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PusatTaktikPage> createState() => _PusatTaktikPageState();
}

class _PusatTaktikPageState extends State<PusatTaktikPage> {
  String _currentStyle = 'Tiki-Taka Possession ⚽';
  final String _setPieceRole = 'Eksekutor Utama Penalti 🎯';

  void _showAlert(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(desc, style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _pelajariTaktikVideo() {
    final r = Random();
    final int intelGain = r.nextInt(3) + 2;
    final int disciplineGain = r.nextInt(2) + 1;
    widget.character.intelligence = (widget.character.intelligence + intelGain).clamp(0, 100);
    widget.character.discipline = (widget.character.discipline + disciplineGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Analisis Video Pertandingan 🎥',
      'Kamu menghabiskan 3 jam menonton rekaman taktik lawan dan pergerakan ruang.\n\n'
      '• Inteligensi: +$intelGain\n'
      '• Kedisiplinan: +$disciplineGain\n'
      'Pemahaman posisi dan visi bermainmu meningkat pesat!',
    );
  }

  void _diskusiPelatih() {
    final r = Random();
    final int trustGain = r.nextInt(5) + 3;
    widget.character.publicTrust = (widget.character.publicTrust + trustGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Diskusi Strategi dengan Pelatih Utama 📋',
      'Kamu berdiskusi empat mata dengan Pelatih mengenai skema pergerakan dan pressing tim.\n\n'
      '• Kepercayaan Pelatih & Publik: +$trustGain%\n'
      'Pelatih sangat terkesan dengan kedewasaan taktikmu di lapangan!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Taktik & Strategi Tim 📋'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // KARTU STATUS TAKTIK
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.analytics_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filosofi Permainan Tim',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                            Text(
                              _currentStyle,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTile('Peran Bola Mati', _setPieceRole, Colors.blue, isDark),
                      _buildInfoTile('Kecerdasan Taktik', '${widget.character.intelligence}%', Colors.purple, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // PILIHAN GAYA PERMAINAN
          _buildSectionTitle('Pilih Skema / Gaya Bermain Taktis ⚙️', isDark),
          _buildStyleCard('Tiki-Taka Possession ⚽', 'Mengandalkan umpan pendek dan penguasaan bola tinggi', Icons.loop, Colors.green),
          _buildStyleCard('Gegenpressing High Press ⚡', 'Pressing ketat di lini pertahanan lawan saat kehilangan bola', Icons.bolt, Colors.orange),
          _buildStyleCard('Counter Attack Kilat 🏎️', 'Bertahan rapat dan menyerang balik secepat kilat', Icons.flash_on, Colors.blue),
          _buildStyleCard('Parkir Bus Defensive 🛡️', 'Fokus pertahanan kokoh dan menjaga clean sheet', Icons.security, Colors.purple),

          const SizedBox(height: 16),

          // AKTIVITAS TAKTIK
          _buildSectionTitle('Aktivitas Pengembangan Taktik 🎯', isDark),
          _buildActionCard(
            title: 'Sesi Analisis Video Pertandingan 🎥',
            desc: 'Pelajari pola bertahan dan kelemahan bek lawan (+Intel & Disiplin)',
            icon: Icons.video_library_rounded,
            color: Colors.indigo,
            onTap: _pelajariTaktikVideo,
          ),
          _buildActionCard(
            title: 'Diskusi Taktik dengan Pelatih 📋',
            desc: 'Tingkatkan pemahaman instruksi pelatih (+Kepercayaan)',
            icon: Icons.record_voice_over_rounded,
            color: Colors.teal,
            onTap: _diskusiPelatih,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildInfoTile(String label, String val, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildStyleCard(String title, String desc, IconData icon, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = _currentStyle == title;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade300), width: isSelected ? 2 : 1),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: isSelected ? Icon(Icons.check_circle, color: color, size: 20) : null,
        onTap: () {
          setState(() {
            _currentStyle = title;
          });
        },
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
