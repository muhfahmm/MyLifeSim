// lib/game/widgets/hubungan_menu/extended_family_view.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';

class ExtendedFamilyViewScreen extends StatefulWidget {
  final Character character;
  final String side; // 'Ayah' atau 'Ibu'
  final VoidCallback onRefresh;

  const ExtendedFamilyViewScreen({
    super.key,
    required this.character,
    required this.side,
    required this.onRefresh,
  });

  @override
  State<ExtendedFamilyViewScreen> createState() => _ExtendedFamilyViewScreenState();
}

class _ExtendedFamilyViewScreenState extends State<ExtendedFamilyViewScreen> {
  @override
  Widget build(BuildContext context) {
    // Filter extended family based on side
    final List<Map<String, String>> familyList = widget.character.extendedFamily.where((member) {
      final String relation = member['relation'] ?? '';
      if (widget.side == 'Ayah') {
        return relation.contains('Ayah');
      } else {
        // Fallback to Mother side
        return relation.contains('Ibu') || (!relation.contains('Ayah') && !relation.contains('Ibu'));
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Keluarga dari ${widget.side}'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: familyList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada data keluarga besar.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: familyList.length,
              itemBuilder: (context, index) {
                final member = familyList[index];
                final String name = member['name'] ?? 'Keluarga';
                final String relation = member['relation'] ?? 'Keluarga';
                final int relVal = int.tryParse(member['relationship'] ?? '50') ?? 50;
                final int extAge = int.tryParse(member['age'] ?? '0') ?? 0;
                final bool isDeceased = member['isDeceased'] == 'true';
                final bool isMale = (member['gender'] ?? 'Laki-laki') == 'Laki-laki';

                if (extAge < 0 && !isDeceased) return const SizedBox.shrink();

                final Color color = isDeceased ? Colors.grey : (isMale ? Colors.blueGrey : Colors.brown);

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: color.withOpacity(0.3)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isDeceased
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActionMenuScreen(
                                  character: widget.character,
                                  targetName: name,
                                  targetRole: relation,
                                ),
                              ),
                            ).then((_) {
                              setState(() {});
                              widget.onRefresh();
                            });
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(isMale ? Icons.face : Icons.face_3, color: color, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isDeceased ? '$name (Wafat)' : name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDeceased ? Colors.grey : Colors.black87,
                                        decoration: isDeceased ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Hubungan: $relation | Umur: $extAge tahun',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (!isDeceased) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text('Hubungan: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: relVal / 100,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        relVal > 65 ? Colors.green : relVal > 35 ? Colors.amber : Colors.red,
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$relVal%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: relVal > 65 ? Colors.green : relVal > 35 ? Colors.amber : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
