import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:groceries_shopping_app/utils/card_type.dart';

class CreditCard {
  CreditCard(
      {this.expiryDate = "",
      this.cardHolderName = "",
      this.cardNumber = "",
      this.cardCVV = "",
      this.cardType = CardType.mastercard,
      this.showBackView = false});

  final String cardHolderName;
  final String cardCVV;
  final bool showBackView;
  final String cardNumber;
  final String expiryDate;
  final CardType cardType;
}
