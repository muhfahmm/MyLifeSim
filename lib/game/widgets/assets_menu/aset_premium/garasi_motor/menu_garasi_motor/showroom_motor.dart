part of '../garasi_motor.dart';

class ShowroomMotorPage extends StatefulWidget {
  final _GarasiMotorPageState state;
  const ShowroomMotorPage({super.key, required this.state});

  @override
  State<ShowroomMotorPage> createState() => _ShowroomMotorPageState();
}

class _ShowroomMotorPageState extends State<ShowroomMotorPage> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Showroom Motor'),
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
                        const Text('Motor Dipamerkan:'),
                        Text('${state.showroomMotor.length}'),
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
            const Text('Motor yang Dipamerkan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (state.showroomMotor.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Belum ada motor di showroom. Pamerkan motor dari koleksi!'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.showroomMotor.length,
                  itemBuilder: (ctx, i) {
                    var motor = state.showroomMotor[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.storefront, color: Colors.teal),
                        title: Text('${motor['nama']} (${motor['tahun']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${motor['merek']} | ${motor['tipe']}'),
                            Text('Dipamerkan sejak ${motor['tahunPamer']}'),
                            Text('Pendapatan/tahun: USD ${formatRupiah(2500000)}', style: const TextStyle(color: Colors.teal)), // motor generates 2.5 Million
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
