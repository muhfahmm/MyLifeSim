// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/konsultasi/konsultasi.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN KONSULTASI KEUANGAN
// ============================================================
class KonsultasiPage extends StatelessWidget {
  final _InvestasiPageState state;
  const KonsultasiPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsultasi Keuangan'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.support_agent, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Bayar Rp 500.000 untuk mendapatkan saran investasi dari ahli keuangan.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Saran akan membantu Anda mengambil keputusan investasi yang lebih baik.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (state.character.money >= 500000) {
                          state.character.money -= 500000;
                          List<String> saran = [
                            'Saran: Beli saham Tech Corp, prospek cerah.',
                            'Saran: Jual properti di daerah padat, harga akan turun.',
                            'Saran: Investasi emas untuk lindung nilai inflasi.',
                            'Saran: Kripto terlalu volatil, hindari.',
                            'Saran: Deposito jangka panjang aman.',
                            'Saran: Diversifikasi portofolio Anda.',
                            'Saran: Perhatikan saham energi terbarukan.',
                          ];
                          String pesan = saran[Random().nextInt(saran.length)];
                          state.berita.add('💡 Konsultasi: $pesan');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(pesan)),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Uang tidak cukup!')),
                          );
                        }
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('Konsultasi (Rp 500.000)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}