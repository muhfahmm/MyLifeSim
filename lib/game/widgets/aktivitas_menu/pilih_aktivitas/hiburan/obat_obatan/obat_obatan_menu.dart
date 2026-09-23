// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/obat_obatan/obat_obatan_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/store_page/store_page.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/rehabilitasi/rehabilitasi_modal.dart';
import 'database_obat.dart';

class ObatObatanMenuHelper {
  static void showObatObatanMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (!GlobalSettings.isObatObatanUnlocked.value) {
      DialogHelper.show(
        context: context,
        title: 'Fitur Terkunci',
        content: const Text('Fitur Obat-obatan ini memerlukan item "Akses Obat-obatan (18+)". Silakan beli akses di Toko MyLifeSim untuk membuka fitur ini.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StorePage(character: character),
                ),
              );
            },
            child: const Text('Buka Toko 🛒', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      );
      return;
    }

    if (character.age < 18) {
      DialogHelper.show(
        context: context,
        title: 'Akses Dibatasi',
        content: const Text('Kamu harus berusia minimal 18 tahun untuk mengakses menu ini.'),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObatObatanPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class ObatObatanPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const ObatObatanPage({
    super.key,
    required this.character,
    required this.onComplete,
  });

  @override
  State<ObatObatanPage> createState() => _ObatObatanPageState();
}

class _ObatObatanPageState extends State<ObatObatanPage> {
  static String _fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  Color _getAddictionColor(int level) {
    if (level < 34) return Colors.green;
    if (level < 67) return Colors.orange;
    return Colors.red;
  }

  String _getAddictionLabel(int level) {
    if (level < 34) return 'Rendah (Aman)';
    if (level < 67) return 'Sedang (Waspada)';
    return 'Tinggi (Bahaya Kecanduan!)';
  }

  void _executeKonsumsi(BuildContext context, Map<String, dynamic> item) {
    final int cost = item['cost'] as int;
    final int happinessBoost = item['happiness'] as int;
    final int healthPenalty = item['healthPenalty'] as int;
    final int addictionIncrease = item['addictionIncrease'] as int;
    final int overdoseChance = item['overdoseChance'] as int;
    final int policeChance = item['policeChance'] as int;
    final String itemName = item['name'] as String;

    if (widget.character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup',
        content: Text('Uang Anda tidak cukup untuk membeli $itemName secara mandiri (butuh ${_fmt(cost)}).'),
      );
      return;
    }

    final Random random = Random();

    // 1. Cek Ketahuan Polisi
    final bool caughtByPolice = random.nextInt(100) < policeChance;
    if (caughtByPolice) {
      final int fine = (cost * 3).clamp(500, 5000);
      widget.character.money = (widget.character.money - fine).clamp(0, 999999999);
      widget.character.happiness = (widget.character.happiness - 20).clamp(0, 100);

      final msg = '🚨 POLISI MERAZIA! Kamu tertangkap membawa $itemName. Kamu dikenakan denda ${_fmt(fine)} dan mendapat peringatan keras dari kepolisian!';
      widget.character.inbox.add(msg);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.local_police, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Terjaring Razia!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {});
                widget.onComplete();
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }

    // 2. Cek Overdosis
    final bool overdose = random.nextInt(100) < overdoseChance;

    setState(() {
      widget.character.money -= cost;
      widget.character.drugAddictionLevel = (widget.character.drugAddictionLevel + addictionIncrease).clamp(0, 100);

      if (overdose) {
        widget.character.health = (widget.character.health - 40).clamp(0, 100);
        widget.character.happiness = (widget.character.happiness - 30).clamp(0, 100);
      } else {
        widget.character.happiness = (widget.character.happiness + happinessBoost).clamp(0, 100);
        widget.character.health = (widget.character.health - healthPenalty).clamp(0, 100);
      }
    });

    if (overdose) {
      final msg = '🤮 OVERDOSIS! Kamu mengalami efek samping parah setelah mengonsumsi $itemName. Kesehatanmu anjlok tajam (-40% Kesehatan).';
      widget.character.inbox.add(msg);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: 28),
              SizedBox(width: 8),
              Text('OVERDOSIS!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onComplete();
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      final msg = '💊 Kamu mengadopsi & mengonsumsi $itemName. (+$happinessBoost% Kebahagiaan, -$healthPenalty% Kesehatan, +$addictionIncrease% Kecanduan)';
      widget.character.inbox.add(msg);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.sentiment_very_satisfied, color: Colors.purple, size: 28),
              SizedBox(width: 8),
              Text('Sensasi Euforia!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onComplete();
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            ),
          ],
        ),
      );
    }
  }

  void _showConfirmModal(BuildContext context, Map<String, dynamic> item) {
    final int cost = item['cost'] as int;
    final String itemName = item['name'] as String;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final bool canAfford = widget.character.money >= cost;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.medication_liquid, color: Colors.purple, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Harga: ${_fmt(cost)} | Kategori: ${item['type']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.purpleAccent : Colors.purple.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item['desc'] ?? '',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.purple.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Efek Kebahagiaan:', style: TextStyle(fontSize: 12)),
                        Text('+${item['happiness']}% 🥳', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dampak Kesehatan:', style: TextStyle(fontSize: 12)),
                        Text('-${item['healthPenalty']}% ❤️', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tingkat Kecanduan:', style: TextStyle(fontSize: 12)),
                        Text('+${item['addictionIncrease']}% 📈', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford ? Colors.purple : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                  label: Text(
                    canAfford ? 'Beli & Konsumsi (${_fmt(cost)})' : 'Uang Tidak Cukup',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (canAfford) {
                      _executeKonsumsi(context, item);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade100;
    final Color containerBg = isDark ? Colors.grey.shade900 : Colors.white;
    final Color cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final Color subtextColor = isDark ? Colors.white70 : Colors.black54;

    final int addictionLevel = widget.character.drugAddictionLevel;
    final Color addictionColor = _getAddictionColor(addictionLevel);
    final String addictionLabel = _getAddictionLabel(addictionLevel);

    const list = DatabaseObat.listObat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsumsi Obat-obatan 💊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            // Container Saldo
            Container(
              padding: const EdgeInsets.all(16),
              color: containerBg,
              child: Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Saldo Anda: ${_fmt(widget.character.money)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Indikator Bar Kecanduan
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: containerBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monitor_heart, color: Colors.purple, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Tingkat Kecanduan: $addictionLabel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$addictionLevel%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: addictionColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: addictionLevel / 100,
                      minHeight: 10,
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(addictionColor),
                    ),
                  ),
                  if (addictionLevel > 0) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        icon: const Icon(Icons.healing, color: Colors.green, size: 16),
                        label: const Text(
                          'Ikuti Program Rehabilitasi 💚',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RehabilitasiModal(
                                character: widget.character,
                                onComplete: () {
                                  setState(() {});
                                  widget.onComplete();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Daftar Obat
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final item = list[i];
                  final int cost = item['cost'] as int;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.purple.withValues(alpha: 0.12),
                        child: const Icon(Icons.medication, color: Colors.purple),
                      ),
                      title: Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${item['desc']}\nHarga: ${_fmt(cost)} | Kecanduan: +${item['addictionIncrease']}%',
                          style: TextStyle(
                            color: subtextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () => _showConfirmModal(context, item),
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
