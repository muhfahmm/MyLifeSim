// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/pindah_negara_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';

class PindahNegaraMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PindahNegaraMenuPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<PindahNegaraMenuPage> createState() => _PindahNegaraMenuPageState();
}

class _PindahNegaraMenuPageState extends State<PindahNegaraMenuPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _searchController.clear();
        searchQuery = '';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _fmt(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  String _capitalizeName(String rawName) {
    return rawName.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, dynamic>> filteredList = negaraList.where((n) {
      final String name = n['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Imigrasi & Kebangsaan ✈️🛂',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? Colors.lightBlueAccent : Colors.blue,
          unselectedLabelColor: isDark ? Colors.white70 : Colors.grey,
          indicatorColor: isDark ? Colors.lightBlueAccent : Colors.blue,
          tabs: const [
            Tab(text: 'Pindah Negara ✈️'),
            Tab(text: 'Ganti Kebangsaan 🛂'),
          ],
        ),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: _tabController.index == 0
                      ? 'Cari negara tujuan imigrasi...'
                      : 'Cari negara untuk naturalisasi...',
                  prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: isDark ? Colors.white70 : Colors.black54),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
              ),
            ),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPindahNegaraTab(filteredList),
                  _buildGantiKebangsaanTab(filteredList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPindahNegaraTab(List<Map<String, dynamic>> list) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (list.isEmpty) {
      return Center(
        child: Text(
          'Negara tidak ditemukan',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final n = list[i];
        final capitalizedName = _capitalizeName(n['name'] as String);
        final bool isCurrentLocation = widget.character.location.toLowerCase() == capitalizedName.toLowerCase();
        final bool canAfford = widget.character.money >= (n['cost'] as int);

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: (isCurrentLocation || !canAfford)
                ? null
                : () {
                    widget.character.money -= (n['cost'] as int);
                    widget.character.location = capitalizedName;
                    widget.character.happiness = (widget.character.happiness + (n['happiness'] as int)).clamp(0, 100);
                    
                    widget.character.resignJob();
                    widget.character.idolTrainees.clear();
                    widget.character.idolMainMembers.clear();
                    widget.character.idolStaff.clear();
                    
                    final msg = '✈️ Kamu pindah ke $capitalizedName! Karena berpindah negara, kamu otomatis mengundurkan diri dari pekerjaan lamamu. Kehidupan baru menanti! (+${n['happiness']}% Kebahagiaan)';
                    widget.character.inbox.add(msg);
                    
                    Navigator.pop(context);
                    widget.onComplete();

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Imigrasi Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: Text(msg),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              capitalizedName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: (isCurrentLocation || !canAfford)
                                    ? (isDark ? Colors.white54 : Colors.grey.shade500)
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                            ),
                            if (isCurrentLocation) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.green.shade900 : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: isDark ? Colors.green.shade700 : Colors.green.shade200),
                                ),
                                child: Text(
                                  '🏠 Tinggal di Sini',
                                  style: TextStyle(
                                    color: isDark ? Colors.greenAccent : Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n['desc'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: (isCurrentLocation || !canAfford)
                                ? (isDark ? Colors.white54 : Colors.grey.shade400)
                                : (isDark ? Colors.white70 : Colors.grey.shade600),
                          ),
                        ),
                        if (!isCurrentLocation) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Biaya: \$${_fmt(n['cost'] as int)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: canAfford
                                  ? (isDark ? Colors.tealAccent : Colors.teal)
                                  : (isDark ? Colors.redAccent : Colors.red.shade400),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isCurrentLocation)
                    Icon(
                      canAfford ? Icons.arrow_forward_ios : Icons.lock_outline,
                      size: 16,
                      color: canAfford
                          ? (isDark ? Colors.tealAccent : Colors.teal)
                          : (isDark ? Colors.white54 : Colors.grey.shade400),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGantiKebangsaanTab(List<Map<String, dynamic>> list) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (list.isEmpty) {
      return Center(
        child: Text(
          'Negara tidak ditemukan',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final n = list[i];
        final capitalizedName = _capitalizeName(n['name'] as String);
        final String birthCountry = widget.character.birthCountry ?? widget.character.location;
        final bool isAlreadyCitizen = birthCountry.toLowerCase() == capitalizedName.toLowerCase();
        
        final bool livesHere = widget.character.location.toLowerCase() == capitalizedName.toLowerCase();
        const int processingFee = 100000;
        final bool canAfford = widget.character.money >= processingFee;
        final bool hasIntelligence = widget.character.intelligence >= 70;
        final bool hasKarma = widget.character.karma >= 50;
        
        final bool meetsAllRequirements = livesHere && canAfford && hasIntelligence && hasKarma;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      capitalizedName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (isAlreadyCitizen) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.blue.shade900 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isDark ? Colors.blue.shade700 : Colors.blue.shade200),
                        ),
                        child: Text(
                          '🛂 Warga Negara',
                          style: TextStyle(
                            color: isDark ? Colors.lightBlueAccent : Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Ajukan permohonan naturalisasi dan dapatkan kewarganegaraan baru.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const Divider(height: 20),
                
                if (!isAlreadyCitizen) ...[
                  Text(
                    'Persyaratan Naturalisasi:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildReqRow(label: 'Tinggal di negara ini saat ini', passed: livesHere),
                  _buildReqRow(label: 'Biaya Administrasi: \$${_fmt(processingFee)}', passed: canAfford),
                  _buildReqRow(label: 'Ujian Integrasi & Wawasan Kebangsaan (Kecerdasan ≥ 70%)', passed: hasIntelligence),
                  _buildReqRow(label: 'Catatan Kelakuan Baik (Karma ≥ 50%)', passed: hasKarma),
                  
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: meetsAllRequirements
                            ? (isDark ? Colors.blue.shade700 : Colors.blue)
                            : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        foregroundColor: meetsAllRequirements
                            ? Colors.white
                            : (isDark ? Colors.white54 : Colors.grey.shade500),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: meetsAllRequirements ? () {
                        setState(() {
                          widget.character.money -= processingFee;
                          widget.character.birthCountry = capitalizedName;
                        });
                        widget.onComplete();

                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Row(
                              children: [
                                Icon(Icons.verified, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Naturalisasi Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            content: Text('🎉 Selamat! Permohonan kewarganegaraan barumu di $capitalizedName telah disetujui. Kamu sekarang memegang paspor resmi negara tersebut!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                      } : null,
                      child: const Text('Ajukan Kewarganegaraan', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReqRow({required String label, required bool passed}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: passed
                ? (isDark ? Colors.greenAccent : Colors.green)
                : (isDark ? Colors.redAccent : Colors.red),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: passed
                    ? (isDark ? Colors.white70 : Colors.black87)
                    : (isDark ? Colors.redAccent : Colors.red.shade700),
                fontWeight: passed ? FontWeight.normal : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}