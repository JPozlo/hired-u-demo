import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/credit_card.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/utils/card_utils.dart';

class ChooseCardsPage extends StatefulWidget {
  const ChooseCardsPage({Key key}) : super(key: key);

  @override
  _ChooseCardsPageState createState() => _ChooseCardsPageState();
}

class _ChooseCardsPageState extends State<ChooseCardsPage> {
  List<CreditCard> _creditCardList = creditCardsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.mainScaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Hero(
              tag: 'backarrow',
              child: Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: response.setHeight(24)),
            ),
            onPressed: () {
              // setState(() => opacity = 0);
              Navigator.pop(context);
            }),
        title: Text(
          "Choose Card",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _creditCardList.length,
          itemBuilder: (context, index) {
            var currentCard = _creditCardList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Selected Card: ${currentCard.cardHolderName}")));
                      // Save chosen card to preferences and navigate back
                      Navigator.pop(context);
                    },
                    child: CreditCardWidget(
                      cardHolderName: currentCard.cardHolderName,
                      cardNumber: currentCard.cardNumber,
                      cvvCode: currentCard.cardCVV,
                      showBackView: currentCard.showBackView,
                      expiryDate: currentCard.expiryDate,
                      cardType: CardType.mastercard,
                    )),
              ),
            );
          }),
    );
  }
}
