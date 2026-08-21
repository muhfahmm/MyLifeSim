// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class KerjaMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KerjaMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<KerjaMenuScreen> createState() => _KerjaMenuScreenState();
}

class _KerjaMenuScreenState extends State<KerjaMenuScreen> {
  final List<Map<String, dynamic>> _availableJobs = [
    {
      'title': 'Supir Ojek Online',
      'salary': 400,
      'minIntel': 10,
      'req': 'Kecerdasan minimal 10%',
      'icon': Icons.motorcycle,
      'color': Colors.green,
    },
    {
      'title': 'Karyawan Toko',
      'salary': 500,
      'minIntel': 20,
      'req': 'Kecerdasan minimal 20%',
      'icon': Icons.store,
      'color': Colors.blue,
    },
    {
      'title': 'Buruh Pabrik',
      'salary': 600,
      'minIntel': 15,
      'req': 'Kecerdasan minimal 15%',
      'icon': Icons.precision_manufacturing,
      'color': Colors.orange,
    },
    {
      'title': 'Guru SD Swasta',
      'salary': 1200,
      'minIntel': 60,
      'req': 'Kecerdasan minimal 60%',
      'icon': Icons.school,
      'color': Colors.purple,
    },
    {
      'title': 'Pegawai Negeri Sipil (PNS)',
      'salary': 1500,
      'minIntel': 50,
      'req': 'Kecerdasan minimal 50%',
      'icon': Icons.gavel,
      'color': Colors.teal,
    },
    {
      'title': 'Manager IT',
      'salary': 3000,
      'minIntel': 80,
      'req': 'Kecerdasan minimal 80%',
      'icon': Icons.computer,
      'color': Colors.indigo,
    },
  ];

  void _applyJob(Map<String, dynamic> job) {
    if (widget.character.intelligence < job['minIntel']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lamaran Ditolak 🚫'),
          content: Text('Kecerdasanmu (${widget.character.intelligence}%) kurang mencukupi untuk posisi ${job['title']}. ${job['req']}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        widget.character.jobName = job['title'];
        widget.character.jobSalary = job['salary'];
      });
      widget.onRefresh();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lamaran Diterima! 🎉💼'),
          content: Text('Selamat! Kamu resmi bekerja sebagai ${job['title']} dengan gaji \$${job['salary']}/tahun. Gaji akan dibayarkan setiap kali kamu bertambah umur.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Luar Biasa!'),
            ),
          ],
        ),
      );
    }
  }

  void _resign() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resign Pekerjaan'),
        content: Text('Apakah kamu yakin ingin keluar dari pekerjaanmu sebagai ${widget.character.jobName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.character.jobName = null;
                widget.character.jobSalary = null;
              });
              widget.onRefresh();
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final hasJob = character.jobName != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan & Karir 💼'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Status Pekerjaan
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: hasJob ? Colors.green.shade50 : Colors.grey.shade100,
                      child: Icon(
                        hasJob ? Icons.badge : Icons.work_off,
                        size: 32,
                        color: hasJob ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hasJob ? 'Pekerjaan Saat Ini:' : 'Belum Memiliki Pekerjaan',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    if (hasJob) ...[
                      const SizedBox(height: 4),
                      Text(
                        character.jobName!,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gaji: \$${character.jobSalary}/tahun',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _resign,
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Resign / Keluar Kerja'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Daftar Lowongan Pekerjaan
            const Text(
              'Lowongan Pekerjaan Tersedia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),

            if (hasJob)
              Card(
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber.shade300),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Kamu sudah memiliki pekerjaan. Resign terlebih dahulu untuk melamar pekerjaan lain.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._availableJobs.map((job) {
                final meetsReq = character.intelligence >= job['minIntel'];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: job['color'].withOpacity(0.1),
                      child: Icon(job['icon'], color: job['color']),
                    ),
                    title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Gaji: \$${job['salary']}/tahun • ${job['req']}'),
                    trailing: Icon(
                      meetsReq ? Icons.arrow_forward_ios : Icons.lock,
                      size: 14,
                      color: meetsReq ? Colors.grey : Colors.red,
                    ),
                    onTap: () {
                      _applyJob(job);
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
