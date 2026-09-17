import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';

class PilihKacamataPage extends StatefulWidget {
  final Character character;
  final VoidCallback onSaved;

  const PilihKacamataPage({
    super.key,
    required this.character,
    required this.onSaved,
  });

  @override
  State<PilihKacamataPage> createState() => _PilihKacamataPageState();
}

class _PilihKacamataPageState extends State<PilihKacamataPage> {
  late String _selectedAccessoriesType;

  // Daftar pilihan kacamata minus/resep medis (wajib kacamata)
  final Map<String, String> _kacamataOptions = {
    'Kacamata Minus Kotak Standar 👓': 'prescription01',
    'Kacamata Minus Frame Besar 👓': 'prescription02',
    'Kacamata Minus Bundar Classic 👓': 'round',
  };

  @override
  void initState() {
    super.initState();
    final currentAcc = widget.character.avatarAccessoriesType;
    _selectedAccessoriesType = (currentAcc == null || currentAcc == 'blank') ? 'prescription01' : currentAcc;
  }

  void _saveSelection() {
    widget.character.avatarAccessoriesType = _selectedAccessoriesType;
    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Kacamata Dokter 👓',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        child: Column(
          children: [
            // Preview Live Avatar Karakter dengan Kacamata Terpilih
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: widget.character.gender.toLowerCase().contains('perempuan')
                            ? [Colors.pink.shade300, Colors.purple.shade400]
                            : [Colors.blue.shade300, Colors.indigo.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Container(
                          width: 102,
                          height: 102,
                          color: isDark ? const Color(0xFF0F172A) : Colors.white,
                          child: Image.network(
                            AvatarGenerator.buildCustomAvatarUrl(
                              topType: widget.character.avatarTopType ?? 'shortRound',
                              accessoriesType: _selectedAccessoriesType,
                              hairColor: widget.character.avatarHairColor ?? '2c1b18',
                              clotheType: widget.character.avatarClotheType ?? 'shirtCrewNeck',
                              clotheColor: widget.character.avatarClotheColor ?? '262e33',
                              skinColor: widget.character.avatarSkinColor ?? 'edb98a',
                              eyeType: AvatarGenerator.getEyeType(widget.character.happiness),
                              eyebrowType: 'default',
                              mouthType: 'default',
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            width: 102,
                            height: 102,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.character.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Preview Karakter Saat Memakai Kacamata',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Banner Diagnosa Dokter
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2416) : Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade700, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.medical_services_rounded, color: Colors.amber.shade800, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diagnosis Resep Kacamata Dokter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pilih bingkai kacamata yang cocok untuk membantu penglihatan mata kamu.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Opsi Pemilihan Kacamata
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  Text(
                    'MODEL KACAMATA TERSEDIA:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.blue.shade300 : Colors.blue.shade800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._kacamataOptions.entries.map((entry) {
                    final String label = entry.key;
                    final String valCode = entry.value;
                    final bool isSelected = _selectedAccessoriesType == valCode;

                    return Card(
                      elevation: isSelected ? 3 : 1,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected ? Colors.blue : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      color: isSelected
                          ? (isDark ? const Color(0xFF1E2D42) : Colors.blue.shade50)
                          : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
                          child: Icon(
                            valCode == 'blank' ? Icons.highlight_off : Icons.visibility,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.blue)
                            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                        onTap: () {
                          setState(() {
                            _selectedAccessoriesType = valCode;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Tombol Simpan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                    ),
                    child: const Text(
                      'SIMPAN & GUNAKAN KACAMATA',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
