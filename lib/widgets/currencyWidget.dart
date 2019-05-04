import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/fonts.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';

class CurrencyWidget extends StatelessWidget {
  final Currency currency;

  CurrencyWidget({Key key, this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 50)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60,
              child: FadeInImage.assetNetwork(
                  fadeInDuration: Duration(milliseconds: 200),
                  placeholder: 'assets/placeholder.png',
                  image: currency.iconUrl),
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    offset: Offset(0, 5), color: Colors.black12, blurRadius: 20)
              ]),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Text('${currency.currencyCode}',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: LatoBold,
                        color: Colors.black)))
          ],
        ));
  }
}
