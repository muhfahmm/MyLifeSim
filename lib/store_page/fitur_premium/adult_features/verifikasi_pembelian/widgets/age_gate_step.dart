import 'package:flutter/material.dart';

class AgeGateStep extends StatelessWidget {
  final bool isConfirmed;
  final ValueChanged<bool> onChanged;

  const AgeGateStep({
    super.key,
    required this.isConfirmed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C1A35) : const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConfirmed ? Colors.purple : Colors.purple.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Usia Dasar (Age Gate)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark
                            ? Colors.purple.shade100
                            : Colors.purple.shade900,
                      ),
                    ),
                    const Text(
                      'Pernyataan kelayakan umur minimal 18 tahun.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '⚠️ Konten & Fitur ini ditujukan khusus untuk pengguna berusia 18 tahun ke atas. Apakah Anda menyatakan bahwa Anda telah berusia 18 tahun atau lebih?',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => onChanged(!isConfirmed),
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                Checkbox(
                  value: isConfirmed,
                  activeColor: Colors.purple.shade700,
                  onChanged: (val) => onChanged(val ?? false),
                ),
                Expanded(
                  child: Text(
                    'Ya, saya mengonfirmasi bahwa saya berusia 18+ tahun.',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isConfirmed
                          ? (isDark
                              ? Colors.purpleAccent
                              : Colors.purple.shade800)
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
