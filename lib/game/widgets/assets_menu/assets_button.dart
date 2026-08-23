// lib/game/widgets/assets_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

// Import semua widget menu baru
import 'package:bitlife/game/widgets/assets_menu/finansial/uang_tunai.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/investasi.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/kemewahan.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/kasino.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/museum.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/garasi_mobil.dart';

class AssetsButton extends StatelessWidget {
  final int money;
  final int age; // Parameter umur untuk logika pembatasan

  const AssetsButton({
    super.key,
    required this.money,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // --- BUKA DASHBOARD UNTUK SEMUA USIA ---
        DialogHelper.show(
          context: context,
          title: 'Dashboard Aset & Kekayaan',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ============================================
              // 1. BAGIAN FINANSIAL (TERUSKAN AGE)
              // ============================================
              const Text('Finansial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 8),
              UangTunaiItem(money: money, age: age),
              InvestasiItem(age: age),
              KemewahanItem(age: age),

              const Divider(height: 32),

              // ============================================
              // 2. BAGIAN ASET PREMIUM (TERUSKAN AGE)
              // ============================================
              const Text('Aset Premium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 8),
              KasinoItem(age: age),
              MuseumItem(age: age),
              GarasiMobilItem(age: age),

              const Divider(height: 32),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup Dashboard'),
            ),
          ],
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.withOpacity(0.2),
        foregroundColor: Colors.amber,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.amber, width: 1.5),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_balance_wallet, size: 28),
          SizedBox(height: 4),
          Text(
            'Assets',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
