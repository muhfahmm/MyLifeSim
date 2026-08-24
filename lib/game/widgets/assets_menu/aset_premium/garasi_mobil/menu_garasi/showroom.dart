part of '../garasi_mobil.dart';

class ShowroomPage extends StatefulWidget {
  final _GarasiMobilPageState state;
  const ShowroomPage({super.key, required this.state});

  @override
  State<ShowroomPage> createState() => _ShowroomPageState();
}

class _ShowroomPageState extends State<ShowroomPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Showroom'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: state.nextYear,
            tooltip: 'Tahun Berikutnya (Hasilkan Pendapatan)',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Statistik Showroom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mobil Dipamerkan:'),
                        Text('${state.showroom.length}'),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pendapatan:'),
                        Text('USD ${formatRupiah(state.totalPendapatanShowroom)}'),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pengunjung:'),
                        Text('${state.totalPengunjungShowroom} orang'),
                      ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Mobil yang Dipamerkan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (state.showroom.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Belum ada mobil di showroom. Pamerkan mobil dari koleksi!'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.showroom.length,
                  itemBuilder: (ctx, i) {
                    var mobil = state.showroom[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(Icons.storefront, color: Colors.teal),
                        title: Text('${mobil['nama']} (${mobil['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${mobil['merek']} | ${mobil['tipe']}'),
                            Text('Dipamerkan sejak ${mobil['tahunPamer']}'),
                            Text('Pendapatan/tahun: USD ${formatRupiah(5000000)}', style: const TextStyle(color: Colors.teal)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.undo, color: Colors.red),
                          onPressed: () {
                            state.batalkanPameran(i);
                            setState(() {});
                          },
                          tooltip: 'Kembalikan ke Garasi',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}