// lib/game/widgets/assets_menu/finansial/investasi/menu_grid_investasi/berita/berita.dart
part of 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';

// ============================================================
// HALAMAN BERITA PASAR
// ============================================================
class BeritaPage extends StatelessWidget {
  final _InvestasiPageState state;
  const BeritaPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Pasar'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              state._generateMarketNews();
            },
            tooltip: 'Refresh Berita',
          ),
        ],
      ),
      body: state.berita.isEmpty
          ? const Center(
              child: Text(
                'Belum ada berita. Tekan tombol refresh.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.berita.length,
              itemBuilder: (ctx, i) {
                String text = state.berita[i];
                bool isEvent = text.startsWith('⚠️') || text.startsWith('💡');
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isEvent ? Colors.yellow.shade50 : null,
                  child: ListTile(
                    leading: Icon(
                      isEvent ? Icons.warning_amber : Icons.newspaper,
                      color: isEvent ? Colors.orange : Colors.blue,
                    ),
                    title: Text(
                      text,
                      style: TextStyle(
                        fontWeight: isEvent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: isEvent
                        ? const Text('Event', style: TextStyle(fontSize: 10, color: Colors.orange))
                        : const Text('Berita', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
                );
              },
            ),
    );
  }
}