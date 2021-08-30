import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:groceries_shopping_app/models/credit_card.dart';

import 'card_type.dart';

CreditCard defaultCard = CreditCard(
   expiryDate: "12/23",
    cardHolderName: "First User",
    cardCVV: "980",
    cardNumber: "7904 5631 0830 1840",
    showBackView: false
);

List<CreditCard> creditCardsList = [
  CreditCard(
      expiryDate: "12/23",
      cardHolderName: "First User",
      cardCVV: "980",
      cardNumber: "7904 5631 0830 1840",
      cardType: CardType.americanExpress,
      showBackView: false),
  CreditCard(
      expiryDate: "10/24",
      cardHolderName: "Second User",
      cardCVV: "892",
      cardNumber: "7904 5631 8829 0840",
      cardType: CardType.americanExpress,
      showBackView: false),
  CreditCard(
      expiryDate: "09/22",
      cardHolderName: "Third User",
      cardCVV: "812",
      cardNumber: "8920 5631 8829 2829",
      cardType: CardType.mastercard,
      showBackView: false),
  CreditCard(
      expiryDate: "01/23",
      cardHolderName: "Fourth User",
      cardCVV: "192",
      cardNumber: "7904 2921 9192 0840",
      cardType: CardType.visa,
      showBackView: false),
];

CustomCardType getCardTypeFromNumber(String input) {
  CustomCardType cardType;
  if (input.startsWith(new RegExp(
      r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
    cardType = CustomCardType.MasterCard;
  } else if (input.startsWith(new RegExp(r'[4]'))) {
    cardType = CustomCardType.Visa;
  } else if (input.startsWith(new RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
    cardType = CustomCardType.Verve;
  } else if (input.length <= 8) {
    cardType = CustomCardType.Others;
  } else {
    cardType = CustomCardType.Invalid;
  }
  return cardType;
}
