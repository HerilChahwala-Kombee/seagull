import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_state.dart';

class PaymentNotifier extends StateNotifier<PaymentInfo> {
  PaymentNotifier() : super(PaymentInfo());

  void updateCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');
    final isValid = _validateCardNumber(cleaned);
    state = state.copyWith(cardNumber: _formatCardNumber(cleaned), isCardNumberValid: isValid);
  }

  void updateExpirationDate(String expirationDate) {
    final formatted = _formatExpirationDate(expirationDate);
    final isValid = _validateExpirationDate(formatted);
    state = state.copyWith(expirationDate: formatted, isExpirationDateValid: isValid);
  }

  void updateSecurityCode(String securityCode) {
    final isValid = _validateSecurityCode(securityCode);
    state = state.copyWith(securityCode: securityCode, isSecurityCodeValid: isValid);
  }

  void updateNameOnCard(String nameOnCard) {
    final isValid = _validateNameOnCard(nameOnCard);
    state = state.copyWith(nameOnCard: nameOnCard, isNameOnCardValid: isValid);
  }

  void updateBillingCountry(String billingCountry) {
    state = state.copyWith(billingCountry: billingCountry);
  }

  void updatePaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  // Validation methods
  bool _validateCardNumber(String cardNumber) {
    return cardNumber.length >= 13 && cardNumber.length <= 19 && RegExp(r'^[0-9]+$').hasMatch(cardNumber);
  }

  bool _validateExpirationDate(String expirationDate) {
    if (expirationDate.length != 5) return false;
    final parts = expirationDate.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return false;
    }

    return true;
  }

  bool _validateSecurityCode(String securityCode) {
    return securityCode.length >= 3 && securityCode.length <= 4 && RegExp(r'^[0-9]+$').hasMatch(securityCode);
  }

  bool _validateNameOnCard(String nameOnCard) {
    return nameOnCard.trim().length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameOnCard.trim());
  }

  // Formatting methods
  String _formatCardNumber(String cardNumber) {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
  }

  String _formatExpirationDate(String expirationDate) {
    final cleaned = expirationDate.replaceAll('/', '');
    if (cleaned.length >= 2) {
      return '${cleaned.substring(0, 2)}/${cleaned.substring(2, cleaned.length > 4 ? 4 : cleaned.length)}';
    }
    return cleaned;
  }
}
