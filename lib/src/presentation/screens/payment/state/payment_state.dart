enum PaymentMethod { creditCard, paypal, digitalWallet }

class PaymentInfo {
  final String cardNumber;
  final String expirationDate;
  final String securityCode;
  final String nameOnCard;
  final String billingCountry;
  final PaymentMethod selectedMethod;
  final String currency;
  final double exchangeRate;
  final bool isCardNumberValid;
  final bool isExpirationDateValid;
  final bool isSecurityCodeValid;
  final bool isNameOnCardValid;

  PaymentInfo({
    this.cardNumber = '',
    this.expirationDate = '',
    this.securityCode = '',
    this.nameOnCard = '',
    this.billingCountry = 'United States',
    this.selectedMethod = PaymentMethod.creditCard,
    this.currency = 'USD (\$)',
    this.exchangeRate = 0.92,
    this.isCardNumberValid = false,
    this.isExpirationDateValid = false,
    this.isSecurityCodeValid = false,
    this.isNameOnCardValid = false,
  });

  PaymentInfo copyWith({
    String? cardNumber,
    String? expirationDate,
    String? securityCode,
    String? nameOnCard,
    String? billingCountry,
    PaymentMethod? selectedMethod,
    String? currency,
    double? exchangeRate,
    bool? isCardNumberValid,
    bool? isExpirationDateValid,
    bool? isSecurityCodeValid,
    bool? isNameOnCardValid,
  }) {
    return PaymentInfo(
      cardNumber: cardNumber ?? this.cardNumber,
      expirationDate: expirationDate ?? this.expirationDate,
      securityCode: securityCode ?? this.securityCode,
      nameOnCard: nameOnCard ?? this.nameOnCard,
      billingCountry: billingCountry ?? this.billingCountry,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isCardNumberValid: isCardNumberValid ?? this.isCardNumberValid,
      isExpirationDateValid: isExpirationDateValid ?? this.isExpirationDateValid,
      isSecurityCodeValid: isSecurityCodeValid ?? this.isSecurityCodeValid,
      isNameOnCardValid: isNameOnCardValid ?? this.isNameOnCardValid,
    );
  }

  bool get isValid {
    switch (selectedMethod) {
      case PaymentMethod.creditCard:
        return isCardNumberValid && isExpirationDateValid && isSecurityCodeValid && isNameOnCardValid;
      case PaymentMethod.paypal:
      case PaymentMethod.digitalWallet:
        return true;
    }
  }
}