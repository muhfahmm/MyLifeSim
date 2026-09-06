import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class StatistikAjakanMakelovePage extends StatelessWidget {
  final Character character;

  const StatistikAjakanMakelovePage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final historyList = character.proposalHistory.where((item) {
      final type = (item['type'] ?? '').toString();
      return type == 'Bercinta' || type == 'Make Love' || type == 'Bersetubuh' || type == 'Bercinta (Make Love)';
    }).toList().reversed.toList();

    final int totalDiterima = historyList.where((i) => i['status'] == 'Diterima').length;
    final int totalDitolak = historyList.where((i) => i['status'] == 'Ditolak').length;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Riwayat Ajakan Make Love', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            color: isDark ? Colors.grey.shade900 : Colors.red.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryBadge('Total Diajak', '${historyList.length}x', Colors.redAccent),
                _buildSummaryBadge('Diterima', '${totalDiterima}x', Colors.green),
                _buildSummaryBadge('Ditolak', '${totalDitolak}x', Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: historyList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department_outlined, size: 50, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada riwayat ajakan make love',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final item = historyList[index];
                      final bool isAccepted = item['status'] == 'Diterima';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 1,
                        color: isDark ? Colors.grey.shade800 : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isAccepted ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                            child: Icon(
                              isAccepted ? Icons.check_circle_outline : Icons.highlight_off,
                              color: isAccepted ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            item['name'] ?? 'Seseorang',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'Relasi: ${item['relation'] ?? '-'} • Usia Karakter: ${item['age'] ?? '-'} thn',
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isAccepted ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAccepted ? Colors.green : Colors.redAccent,
                              ),
                            ),
                            child: Text(
                              isAccepted ? 'Diterima' : 'Ditolak',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isAccepted ? Colors.green : Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
