import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/credit_card.dart';
import 'package:groceries_shopping_app/screens/checkout_screen.dart';
import 'package:groceries_shopping_app/screens/choose_cards_from_list.dart';
import 'package:groceries_shopping_app/screens/credit_cards_list.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/utils/card_utils.dart';

class PayWithCreditCardPage extends StatefulWidget {
  const PayWithCreditCardPage({Key key}) : super(key: key);

  @override
  _PayWithCreditCardPageState createState() => _PayWithCreditCardPageState();
}

class _PayWithCreditCardPageState extends State<PayWithCreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreditCard _creditCard;

  @override
  void initState() {
    super.initState();
    _creditCard = defaultCard;
    cardNumber = _creditCard.cardNumber;
    expiryDate = _creditCard.expiryDate;
    cardHolderName = _creditCard.cardHolderName;
    isCvvFocused = _creditCard.showBackView;
    cvvCode = _creditCard.cardCVV;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_topBarUI(), Spacer(), _cardUI(), Spacer(), _buttonsUI(),],
        ),
      ),
    );
  }

  Widget _topBarUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Hero(
            tag: 'backarrow',
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: response.setHeight(23),
              ),
            ),
          ),
          Spacer(flex: 5),
          Text(
            "Make Payment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: response.setFontSize(18),
            ),
          ),
          Spacer(flex: 5),
        ],
      ),
    );
  }

  Widget _cardUI() {
    return CreditCardWidget(
      cardBgColor: Colors.redAccent[200],
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      showBackView: isCvvFocused,
      obscureCardNumber: true,
      obscureCardCvv: true,
    );
  }

  Widget _buttonsUI() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.mainOrangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: const Text(
                  'Choose Another Card',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseCardsPage()));
              
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.mainOrangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckOut()));
              
              },
            )
          ],
        ),
      ),
    );
  }

  Future<AlertDialog> _showValidDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff1b447b),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18, color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
