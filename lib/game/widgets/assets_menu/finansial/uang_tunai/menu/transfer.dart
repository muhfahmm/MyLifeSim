// lib/game/widgets/assets_menu/finansial/uang_tunai/menu/transfer.dart
part of '../uang_tunai.dart';

// ============================================================
// FUNGSI INTERNAL UNTUK TRANSFER & PEMBAYARAN
// ============================================================
void showTransferDialogInternal(BuildContext context, _UangTunaiPageState state) {
  final formKey = GlobalKey<FormState>();
  String? tujuan;
  int? nominal;
  TextEditingController nominalCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Transfer / Pembayaran'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tujuan'),
              items: [
                'Bayar Listrik',
                'Bayar Air',
                'Bayar Internet',
                'Transfer ke Teman',
                'Transfer ke Keluarga',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => tujuan = val,
              validator: (val) => val == null ? 'Pilih tujuan' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nominalCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Nominal (Rp)'),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Masukkan nominal';
                if (parseRupiah(val) <= 0) return 'Masukkan angka';
                return null;
              },
              onSaved: (val) => nominal = parseRupiah(val ?? ''),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              if (nominal! <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nominal harus lebih dari 0')),
                );
                return;
              }
              if (state.widget.character.money < nominal!) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saldo tidak cukup!')),
                );
                return;
              }
              // Proses transfer
              state.setState(() {
                state.widget.character.money -= nominal!;
                state._addTransaction(-nominal!, 'Transfer: $tujuan');
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Berhasil transfer Rp ${formatRupiah(nominal!)} untuk $tujuan')),
              );
            }
          },
          child: const Text('Kirim'),
        ),
      ],
    ),
  );
}