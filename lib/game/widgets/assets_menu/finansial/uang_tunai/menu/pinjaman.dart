// lib/game/widgets/assets_menu/finansial/uang_tunai/menu/pinjaman.dart
part of '../uang_tunai.dart';

// ============================================================
// FUNGSI INTERNAL UNTUK PINJAMAN
// ============================================================
void showAjukanPinjamanDialogInternal(BuildContext context, _UangTunaiPageState state) {
  final formKey = GlobalKey<FormState>();
  int? jumlah;
  int? tenor;
  TextEditingController jumlahCtrl = TextEditingController();
  TextEditingController tenorCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Ajukan Pinjaman'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(labelText: 'Jumlah Pinjaman (Rp)'),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Masukkan jumlah';
                if (parseRupiah(val) <= 0) return 'Masukkan angka';
                return null;
              },
              onSaved: (val) => jumlah = parseRupiah(val ?? ''),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: tenorCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tenor (bulan)'),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Masukkan tenor';
                if (int.tryParse(val) == null) return 'Masukkan angka';
                return null;
              },
              onSaved: (val) => tenor = int.tryParse(val!),
            ),
            const SizedBox(height: 10),
            const Text('Bunga: 5% per tahun', style: TextStyle(fontSize: 12)),
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
              if (jumlah! <= 0 || tenor! <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jumlah dan tenor harus lebih dari 0')),
                );
                return;
              }
              // Simulasi persetujuan
              double bungaPerBulan = 0.05 / 12;
              double totalBunga = jumlah! * bungaPerBulan * tenor!;
              double totalBayar = jumlah! + totalBunga;
              double cicilanPerBulan = totalBayar / tenor!;

              state.setState(() {
                state.widget.character.money += jumlah!;
                state.loans.add({
                  'jumlah': jumlah,
                  'bunga': 5,
                  'tenor': tenor,
                  'sisaCicilan': tenor,
                  'cicilanPerBulan': cicilanPerBulan.round(),
                });
                state._addTransaction(jumlah!, 'Pinjaman diterima');
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pinjaman Rp ${formatRupiah(jumlah!)} disetujui!')),
              );
            }
          },
          child: const Text('Ajukan'),
        ),
      ],
    ),
  );
}

void bayarCicilanInternal(BuildContext context, _UangTunaiPageState state, int index) {
  final loan = state.loans[index];
  if (loan['sisaCicilan'] <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pinjaman sudah lunas')),
    );
    return;
  }
  int cicilan = loan['cicilanPerBulan'] as int;
  if (state.widget.character.money < cicilan) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saldo tidak cukup untuk membayar cicilan!')),
    );
    return;
  }
  state.setState(() {
    state.widget.character.money -= cicilan;
    loan['sisaCicilan'] = loan['sisaCicilan'] - 1;
    state._addTransaction(-cicilan, 'Bayar cicilan pinjaman');
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Cicilan Rp ${formatRupiah(cicilan)} dibayar. Sisa ${loan['sisaCicilan']} kali lagi.')),
  );
}

void showLoanManagementDialogInternal(BuildContext context, _UangTunaiPageState state) {
  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return AlertDialog(
            title: const Text('Manajemen Pinjaman'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.loans.isEmpty)
                    const Text('Tidak ada pinjaman aktif.'),
                  ...state.loans.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var loan = entry.value;
                    int sisa = loan['sisaCicilan'] as int;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('Pinjaman Rp ${formatRupiah(loan['jumlah'] as num)}'),
                        subtitle: Text(
                          'Tenor ${loan['tenor']}, sisa $sisa cicilan, cicilan Rp ${formatRupiah(loan['cicilanPerBulan'] as num)}',
                        ),
                        trailing: sisa > 0
                            ? ElevatedButton(
                                onPressed: () {
                                  bayarCicilanInternal(context, state, idx);
                                  setStateDialog(() {});
                                  Navigator.pop(ctx);
                                  showLoanManagementDialogInternal(context, state);
                                },
                                child: const Text('Bayar Cicilan'),
                              )
                            : const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      showAjukanPinjamanDialogInternal(context, state);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ajukan Pinjaman Baru'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    },
  );
}