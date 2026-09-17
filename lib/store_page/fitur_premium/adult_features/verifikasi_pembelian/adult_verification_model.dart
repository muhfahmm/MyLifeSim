class AdultVerificationModel {
  bool isAgeGateConfirmed;
  DateTime? birthDate;
  String? selectedAccountType; // 'Google Account', 'Apple ID', 'Email'
  bool isAccountVerified;
  String? parentalPin;
  bool isParentalPinEnabled;

  AdultVerificationModel({
    this.isAgeGateConfirmed = false,
    this.birthDate,
    this.selectedAccountType,
    this.isAccountVerified = false,
    this.parentalPin,
    this.isParentalPinEnabled = false,
  });

  int get calculatedAge {
    if (birthDate == null) return 0;
    final today = DateTime.now();
    int age = today.year - birthDate!.year;
    if (today.month < birthDate!.month ||
        (today.month == birthDate!.month && today.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  bool get isAdult => calculatedAge >= 18;
}
