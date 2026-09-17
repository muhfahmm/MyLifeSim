import 'package:flutter/material.dart';

class DobVerificationStep extends StatelessWidget {
  final DateTime? birthDate;
  final ValueChanged<DateTime> onDateSelected;

  const DobVerificationStep({
    super.key,
    required this.birthDate,
    required this.onDateSelected,
  });

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDate(BuildContext context) async {
    final initial = birthDate ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'PILIH TANGGAL LAHIR ANDA',
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int age = birthDate != null ? _calculateAge(birthDate!) : 0;
    final bool isAdult = age >= 18;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2836) : const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: birthDate != null ? (isAdult ? Colors.blue : Colors.red) : Colors.blue.shade200,
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
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cake_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Tanggal Lahir (DOB)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.blue.shade100 : Colors.blue.shade900,
                      ),
                    ),
                    const Text(
                      'Perhitungan usia otomatis dari tanggal lahir.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  birthDate == null
                      ? 'Belum memilih tanggal lahir'
                      : 'Lahir: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year} ($age Tahun)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: birthDate == null
                        ? Colors.grey
                        : (isAdult ? (isDark ? Colors.greenAccent : Colors.green.shade800) : Colors.red),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickDate(context),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(birthDate == null ? 'Pilih DOB' : 'Ubah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (birthDate != null && !isAdult) ...[
            const SizedBox(height: 8),
            const Text(
              '❌ Pembelian ditolak: Usia Anda di bawah 18 tahun.',
              style: TextStyle(color: Colors.red, fontSize: 11.5, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}
