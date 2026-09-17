import 'adult_verification_model.dart';

class AdultVerificationController {
  final AdultVerificationModel model = AdultVerificationModel();

  void updateAgeGate(bool isConfirmed) {
    model.isAgeGateConfirmed = isConfirmed;
  }

  void updateBirthDate(DateTime dob) {
    model.birthDate = dob;
  }

  void updateAccount(String? accountType) {
    model.selectedAccountType = accountType;
    model.isAccountVerified = accountType != null;
  }

  void toggleParentalPin(bool enabled) {
    model.isParentalPinEnabled = enabled;
    if (!enabled) {
      model.parentalPin = null;
    }
  }

  void updateParentalPin(String? pin) {
    model.parentalPin = pin;
  }

  String? getValidationError() {
    if (!model.isAgeGateConfirmed) {
      return 'Harap konfirmasi pernyataan usia (18+) terlebih dahulu.';
    }
    if (model.birthDate == null) {
      return 'Harap masukkan tanggal lahir Anda.';
    }
    if (!model.isAdult) {
      return 'Usia Anda di bawah 18 tahun. Pembelian fitur 18+ tidak diizinkan.';
    }
    if (!model.isAccountVerified) {
      return 'Harap pilih akun terverifikasi (Google/Apple/Email).';
    }
    if (model.isParentalPinEnabled) {
      if (model.parentalPin == null || model.parentalPin!.length < 4) {
        return 'Harap masukkan PIN Orang Tua 4 digit yang valid.';
      }
    }
    return null; // Valid
  }
}
