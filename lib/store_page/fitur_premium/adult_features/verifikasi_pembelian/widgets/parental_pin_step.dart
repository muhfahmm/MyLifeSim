import 'package:flutter/material.dart';

class ParentalPinStep extends StatefulWidget {
  final bool isPinEnabled;
  final ValueChanged<bool> onTogglePin;
  final ValueChanged<String?> onPinEntered;

  const ParentalPinStep({
    super.key,
    required this.isPinEnabled,
    required this.onTogglePin,
    required this.onPinEntered,
  });

  @override
  State<ParentalPinStep> createState() => _ParentalPinStepState();
}

class _ParentalPinStepState extends State<ParentalPinStep> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF33291A) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isPinEnabled ? Colors.amber.shade700 : Colors.amber.shade200,
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
                  color: Colors.amber.shade800,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_person_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parental Control (PIN Orang Tua)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.amber.shade100 : Colors.amber.shade900,
                      ),
                    ),
                    const Text(
                      'Fitur proteksi tambahan untuk izin transaksi 18+.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aktifkan Proteksi PIN Orang Tua', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            subtitle: const Text('Minta masukan PIN 4 digit sebelum transaksi disetujui.', style: TextStyle(fontSize: 11)),
            value: widget.isPinEnabled,
            activeThumbColor: Colors.amber.shade800,
            onChanged: (val) {
              widget.onTogglePin(val);
              if (!val) {
                _pinController.clear();
                widget.onPinEntered(null);
              }
            },
          ),
          if (widget.isPinEnabled) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Masukkan PIN Orang Tua (4 Digit)',
                hintText: '****',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) {
                widget.onPinEntered(val);
              },
            ),
          ],
        ],
      ),
    );
  }
}
