// lib/game/widgets/assets_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/uang_tunai/uang_tunai.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/investasi/investasi.dart';
import 'package:bitlife/game/widgets/assets_menu/finansial/kemewahan/kemewahan.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/kasino/kasino.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/museum/museum.dart';
import 'package:bitlife/game/widgets/assets_menu/aset_premium/garasi_mobil/garasi_mobil.dart';

class AssetsButton extends StatelessWidget {
  final Character character;
  final VoidCallback? onRefresh;

  const AssetsButton({
    super.key,
    required this.character,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        DialogHelper.show(
          context: context,
          title: 'Dashboard Aset & Kekayaan',
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Finansial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  UangTunaiItem(
                    character: character,
                    onPop: () => setStateDialog(() {}),
                  ),
                  InvestasiItem(
                    character: character,
                    onPop: () => setStateDialog(() {}),
                  ),
                  KemewahanItem(
                    character: character,
                    onPop: () => setStateDialog(() {}),
                  ),
                  const Divider(height: 32),
                  const Text('Aset Premium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  KasinoItem(character: character, onPop: () => setStateDialog(() {})),
                  MuseumItem(age: character.age, onPop: () => setStateDialog(() {})),
                  GarasiMobilItem(age: character.age, onPop: () => setStateDialog(() {})),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup Dashboard'),
            ),
          ],
        ).then((_) => onRefresh?.call());
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
          Text('Assets', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.amber)),
        ],
      ),
    );
  }
}