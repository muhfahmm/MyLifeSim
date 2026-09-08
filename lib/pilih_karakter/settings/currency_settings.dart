// lib/pilih_karakter/settings/currency_settings.dart

import 'package:flutter/material.dart';

/// Model konfigurasi mata uang
class CurrencyModel {
  final String code; // Kode ISO 4217 (contoh: USD, IDR)
  final String symbol; // Simbol mata uang (contoh: $, Rp, €)
  final String name; // Nama resmi mata uang
  final String flag; // Bendera / Icon emoji
  final double rateFromUsd; // Nilai tukar dari 1 USD (1 USD = X Currency)
  final String description; // Alasan & latar belakang

  const CurrencyModel({
    required this.code,
    required this.symbol,
    required this.name,
    required this.flag,
    required this.rateFromUsd,
    required this.description,
  });
}

class CurrencySettings {
  // Daftar 10 mata uang sesuai permintaan user
  static const List<CurrencyModel> availableCurrencies = [
    CurrencyModel(
      code: 'USD',
      symbol: '\$',
      name: 'Dolar Amerika Serikat',
      flag: '🇺🇸',
      rateFromUsd: 1.0,
      description:
          'Standar emas dunia. Hampir semua game simulasi menggunakan USD sebagai patokan harga global.',
    ),
    CurrencyModel(
      code: 'EUR',
      symbol: '€',
      name: 'Euro',
      flag: '🇪🇺',
      rateFromUsd: 0.92,
      description:
          'Mata uang resmi Uni Eropa (Jerman, Prancis, Italia, Spanyol, dll).',
    ),
    CurrencyModel(
      code: 'JPY',
      symbol: '¥',
      name: 'Yen Jepang',
      flag: '🇯🇵',
      rateFromUsd: 155.0,
      description:
          'Negara Asia yang paling sering dijadikan setting game (sekolah, anime, kerja di Tokyo).',
    ),
    CurrencyModel(
      code: 'KRW',
      symbol: '₩',
      name: 'Won Korea Selatan',
      flag: '🇰🇷',
      rateFromUsd: 1350.0,
      description:
          'Sangat relevan untuk gameplay di Korea Selatan dan sistem Wajib Militer.',
    ),
    CurrencyModel(
      code: 'GBP',
      symbol: '£',
      name: 'Pound Sterling Inggris',
      flag: '🇬🇧',
      rateFromUsd: 0.79,
      description:
          'Mata uang tertua dan terkaya di dunia. Cocok untuk karier di London.',
    ),
    CurrencyModel(
      code: 'CNY',
      symbol: '¥',
      name: 'Yuan Tiongkok',
      flag: '🇨🇳',
      rateFromUsd: 7.23,
      description:
          'Ekonomi terbesar kedua di dunia. Penting untuk gameplay di China.',
    ),
    CurrencyModel(
      code: 'IDR',
      symbol: 'Rp',
      name: 'Rupiah Indonesia',
      flag: '🇮🇩',
      rateFromUsd: 16000.0,
      description:
          'Mata uang lokal Indonesia agar pemain merasa terhubung dengan kehidupan sehari-hari.',
    ),
    CurrencyModel(
      code: 'INR',
      symbol: '₹',
      name: 'Rupee India',
      flag: '🇮🇳',
      rateFromUsd: 83.5,
      description:
          'Memberikan variasi untuk cerita "Jutawan Bollywood" atau pengusaha teknologi.',
    ),
    CurrencyModel(
      code: 'AUD',
      symbol: 'A\$',
      name: 'Dolar Australia',
      flag: '🇦🇺',
      rateFromUsd: 1.51,
      description:
          'Negara favorit untuk imigrasi dan pendidikan luar negeri.',
    ),
    CurrencyModel(
      code: 'BRL',
      symbol: 'R\$',
      name: 'Real Brasil',
      flag: '🇧🇷',
      rateFromUsd: 5.15,
      description:
          'Ekonomi terbesar di Amerika Latin dengan dinamika budaya karnaval & sepak bola.',
    ),
  ];

  /// Notifier mata uang aktif. Default adalah USD (index 0).
  static final ValueNotifier<CurrencyModel> selectedCurrency =
      ValueNotifier<CurrencyModel>(availableCurrencies[0]);

  /// Mendapatkan mata uang aktif saat ini
  static CurrencyModel get current => selectedCurrency.value;

  /// Mengubah mata uang yang dipilih
  static void setCurrency(CurrencyModel currency) {
    selectedCurrency.value = currency;
  }

  /// Mengubah mata uang berdasarkan kode ISO (misal 'IDR', 'EUR')
  static void setCurrencyByCode(String code) {
    final found = availableCurrencies.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => availableCurrencies[0],
    );
    selectedCurrency.value = found;
  }

  /// Konversi nominal dari USD ke mata uang aktif yang dipilih.
  /// (Dolar USD disimpan sebagai basis data internal, dikonversi saat ditampilkan)
  static double convertFromUsd(num amountInUsd) {
    return amountInUsd * selectedCurrency.value.rateFromUsd;
  }

  /// Konversi nominal dari mata uang aktif kembali ke USD dasar.
  static double convertToUsd(num amountInCurrency) {
    if (selectedCurrency.value.rateFromUsd == 0) return amountInCurrency.toDouble();
    return amountInCurrency / selectedCurrency.value.rateFromUsd;
  }

  /// Format teks angka uang berdasarkan mata uang yang aktif
  /// Contoh:
  /// - USD 1000 -> "$1,000"
  /// - IDR 1000 USD -> "Rp 16.000.000"
  static String format(num amountInUsd, {bool showSymbol = true}) {
    final double converted = convertFromUsd(amountInUsd);
    final String formattedNum = _formatNumber(converted, selectedCurrency.value.code);
    if (!showSymbol) return formattedNum;

    final String symbol = selectedCurrency.value.symbol;
    if (selectedCurrency.value.code == 'IDR') {
      return '$symbol $formattedNum';
    } else {
      return '$symbol$formattedNum';
    }
  }

  /// Helper untuk memformat hanya angkanya saja setelah dikonversi ke mata uang aktif
  static String formatValue(num amountInUsd) {
    final double converted = convertFromUsd(amountInUsd);
    return _formatNumber(converted, selectedCurrency.value.code);
  }

  /// Helper internal format pemisah ribuan
  static String _formatNumber(double amount, String currencyCode) {
    final bool isIntegerCurrency = currencyCode == 'JPY' || currencyCode == 'KRW' || currencyCode == 'IDR';
    final int roundedVal = amount.round();

    if (isIntegerCurrency) {
      return roundedVal.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    } else {
      final String valStr = amount.toStringAsFixed(0);
      return valStr.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
  }

  /// Mendapatkan simbol mata uang aktif (misal $, Rp, €, ¥)
  static String get symbol => selectedCurrency.value.symbol;

  /// Helper untuk membuat Icon atau Text Widget simbol mata uang dinamis sesuai setting
  /// Jika USD -> Icons.attach_money / Icons.monetization_on
  /// Jika Rupiah / Euro / Yen / lainnya -> Text Widget berpola bold dengan simbol mata uang tersebut
  static Widget buildCurrencyIcon({
    Color? color,
    double size = 20,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    final String sym = symbol;
    if (sym == '\$') {
      return Icon(Icons.attach_money, color: color, size: size);
    } else {
      return Text(
        sym,
        style: TextStyle(
          color: color,
          fontSize: size * 0.75,
          fontWeight: fontWeight,
        ),
      );
    }
  }

  /// Reset ke default USD
  static void reset() {
    selectedCurrency.value = availableCurrencies[0];
  }
}

/// Halaman UI Pengaturan Mata Uang
class CurrencySettingsPage extends StatelessWidget {
  const CurrencySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          '💱 Mata Uang Game',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<CurrencyModel>(
        valueListenable: CurrencySettings.selectedCurrency,
        builder: (context, activeCurrency, _) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Header Informasi Conversi USD Basis
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.blue.shade700 : Colors.blue.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Semua transaksi internal game berbasis USD (\$)\n'
                        'Mata uang aktif saat ini: ${activeCurrency.flag} ${activeCurrency.name} (${activeCurrency.code})\n'
                        'Kurs: 1 USD = ${activeCurrency.symbol}${activeCurrency.rateFromUsd}',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Loop 10 mata uang
              ...CurrencySettings.availableCurrencies.map((curr) {
                final bool isSelected = curr.code == activeCurrency.code;

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.blue
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  color: isSelected
                      ? (isDark ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50)
                      : (isDark ? const Color(0xFF212121) : Colors.white),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      CurrencySettings.setCurrency(curr);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(curr.flag, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${curr.name} (${curr.code} / ${curr.symbol})',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isSelected
                                              ? Colors.blue
                                              : (isDark ? Colors.white : Colors.black87),
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check_circle, color: Colors.blue, size: 20),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  curr.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Simulasi: \$100 USD = ${CurrencySettings.format(100)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

