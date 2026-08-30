part of '../garasi_mobil.dart';

class ShowroomPage extends StatefulWidget {
  final GarasiMobilPageState state;
  const ShowroomPage({super.key, required this.state});

  @override
  State<ShowroomPage> createState() => _ShowroomPageState();
}

class _ShowroomPageState extends State<ShowroomPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
              color: isDark ? Colors.grey.shade800 : Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statistik Showroom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mobil Dipamerkan:', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                        Text('${state.showroom.length}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Pendapatan:', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                        Text('USD ${formatRupiah(state.totalPendapatanShowroom)}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Pengunjung:', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                        Text('${state.totalPengunjungShowroom} orang', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Mobil yang Dipamerkan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            if (state.showroom.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Belum ada mobil di showroom. Pamerkan mobil dari koleksi!', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
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
                        title: Text('${mobil['nama']} (${mobil['tahun']})', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${mobil['merek']} | ${mobil['tipe']}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                            Text('Dipamerkan sejak ${mobil['tahunPamer']}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
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